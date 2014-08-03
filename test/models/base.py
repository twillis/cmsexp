import unittest
from sqlalchemy import engine_from_config
from sqlalchemy.orm import sessionmaker
from cmsexp import models
from faker import internet

DB_SETTINGS = {'sa.url': 'sqlite:///:memory:',
               'sa.echo': True}


def create_testuser():
    return models.User(email=internet.email())

def get_engine(settings=DB_SETTINGS):
    return engine_from_config(settings, prefix="sa.")


def get_session(engine):
    return sessionmaker(bind=engine)()


def create_tables(engine, meta=models.Base.metadata):
    meta.create_all(engine)


def drop_tables(engine, meta=models.Base.metadata):
    meta.drop_all(engine)

class DBTestCase(unittest.TestCase):
    def setUp(self):
        self.engine = get_engine()
        self.session = get_session(self.engine)
        create_tables(self.engine)
        
    def tearDown(self):
        drop_tables(self.engine)

    def save(self, obj):
        self.session.add(obj)
        self.session.commit()

