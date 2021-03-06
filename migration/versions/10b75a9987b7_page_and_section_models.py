"""page and section models

Revision ID: 10b75a9987b7
Revises: 16c958dbae6c
Create Date: 2014-08-02 20:01:36.808127

"""

# revision identifiers, used by Alembic.
revision = '10b75a9987b7'
down_revision = '16c958dbae6c'

from alembic import op
import sqlalchemy as sa


def upgrade():
    ### commands auto generated by Alembic - please adjust! ###
    op.create_table('page',
    sa.Column('id', sa.Integer(), nullable=False),
    sa.Column('created_on', sa.DateTime(), nullable=True),
    sa.Column('updated_on', sa.DateTime(), nullable=True),
    sa.Column('title', sa.Unicode(length=1024), nullable=False),
    sa.Column('author_id', sa.Integer(), nullable=True),
    sa.Column('_slug', sa.Unicode(length=1024), nullable=True),
    sa.Column('published_date', sa.DateTime(), nullable=True),
    sa.ForeignKeyConstraint(['author_id'], ['user.id'], ),
    sa.PrimaryKeyConstraint('id'),
    sa.UniqueConstraint('_slug')
    )
    op.create_table('pagesection',
    sa.Column('id', sa.Integer(), nullable=False),
    sa.Column('created_on', sa.DateTime(), nullable=True),
    sa.Column('updated_on', sa.DateTime(), nullable=True),
    sa.Column('body', sa.UnicodeText(), nullable=True),
    sa.Column('page_id', sa.Integer(), nullable=False),
    sa.Column('author_id', sa.Integer(), nullable=False),
    sa.Column('weight', sa.Integer(), nullable=True),
    sa.ForeignKeyConstraint(['author_id'], ['user.id'], ),
    sa.ForeignKeyConstraint(['page_id'], ['page.id'], ),
    sa.PrimaryKeyConstraint('id')
    )
    ### end Alembic commands ###


def downgrade():
    ### commands auto generated by Alembic - please adjust! ###
    op.drop_table('pagesection')
    op.drop_table('page')
    ### end Alembic commands ###
