from sqlalchemy import  Column, Integer, UnicodeText, Unicode, DateTime, ForeignKey
from sqlalchemy.orm import relationship, backref, object_session
from sqlalchemy.ext.declarative import declarative_base, declared_attr
from sqlalchemy import event
import datetime
from sqlalchemy_utils.types.password import PasswordType
from uuid import uuid4
from slugify import UniqueSlugify
import logging
log = logging.getLogger(__name__)


class ModelBase(object):
    id = Column(Integer, primary_key=True)
    created_on = Column(DateTime, default=datetime.datetime.now)
    updated_on = Column(DateTime, onupdate=datetime.datetime.now)

    @declared_attr
    def __tablename__(cls):
        return cls.__name__.lower()

    @classmethod
    def __declare_last__(cls):
        for e in ['before_insert', 'before_update']:
            f = getattr(cls, 'cb_%s' % e, None)
            if f:
                event.listen(cls, e, f)

    @staticmethod
    def cb_before_insert(mapper, connection, target):
        cb = getattr(target, 'do_before_insert', None)
        if cb:
            cb(object_session(target))

    @staticmethod
    def cb_before_update(mapper, connection, target):
        cb = getattr(target, 'do_before_update', None)
        if cb:
            cb(object_session(target))

    def apply_data(self, **kw):
        for k, v in kw.items():
            if k in self._sa_instance_state.dict:
                setattr(self, k, v)
            else:
                log.warn("param %s ignored" % k)

Base = declarative_base(cls=ModelBase)

def Ref(cls, col="id"):
    return ForeignKey("%s.%s" % (cls.__tablename__, col))


class User(Base):
    email = Column(Unicode(1024), unique=True)
    first_name = Column(Unicode(1024))
    last_name = Column(Unicode(1024))
    password = Column(PasswordType(schemes=['pbkdf2_sha512', ]), nullable=True)

    
class Command(Base):
    expire_on = Column(DateTime, nullable=False)
    command_id = Column(Unicode(36), default=lambda : str(uuid4()), unique=True)
    command_type = Column(Unicode(1024))
    command_date = Column(UnicodeText)
    identity = Column(Unicode(1024))


class Page(Base):
    title = Column(Unicode(1024), nullable=False)
    author_id = Column(Integer, Ref(User))
    _slug = Column(Unicode(1024), unique=True)
    published_date = Column(DateTime, default=datetime.datetime.now)
    author = relationship(User, backref=backref("pages", order_by=published_date))

    def do_before_insert(self, session):
        self._slug = self._get_slug_from_tile(session)

    def _get_slug_from_tile(self, session):
        existing_slugs = [s[0] for s in session.query(self.__class__._slug).all()]
        slugify = UniqueSlugify(uids=existing_slugs)
        slugify.to_lower = True
        slugify.max_length = 1019
        return slugify(self.title)

class PageSection(Base):
    body = Column(UnicodeText)
    page_id = Column(Integer, Ref(Page), nullable=False)
    author_id = Column(Integer, Ref(User), nullable=False)
    weight = Column(Integer, default=0)
    page = relationship(Page, backref=backref("sections", order_by=weight))
    author = relationship(User)
