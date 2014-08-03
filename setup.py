import os

from setuptools import setup, find_packages

here = os.path.abspath(os.path.dirname(__file__))
with open(os.path.join(here, 'README.md')) as f:
    README = f.read()
with open(os.path.join(here, 'CHANGES.md')) as f:
    CHANGES = f.read()

requires = [
    'pyramid',
    'waitress',
    'sqlalchemy',
    'alembic',
    'pyramid_jinja2',
    'passlib',
    'colander',
    'pyramid_marrowmailer',
    'html2text',
    'pyramid_tm',
    'sqlalchemy-utils',
    'faker.py',
    'awesome-slugify'
    ]

setup(name='cmsexp',
      version='0.0',
      description='cmsexp',
      long_description=README + '\n\n' + CHANGES,
      classifiers=[
        "Programming Language :: Python",
        "Framework :: Pyramid",
        "Topic :: Internet :: WWW/HTTP",
        "Topic :: Internet :: WWW/HTTP :: WSGI :: Application",
        ],
      author='',
      author_email='',
      url='',
      keywords='web pyramid pylons',
      packages=find_packages(),
      include_package_data=True,
      zip_safe=False,
      install_requires=requires,
      tests_require=requires,
      test_suite="test",
      entry_points="""\
      [paste.app_factory]
      main = cmsexp:main
      """,
      )