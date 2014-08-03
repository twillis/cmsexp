'''
test crud and other logic
'''
import unittest
from cmsexp import models
from faker import internet, lorem
from base import DBTestCase, create_testuser


class TestPageCrud(DBTestCase):
    def setUp(self):
        DBTestCase.setUp(self)
        self.user = create_testuser()
        self.save(self.user)

    def testCreatePageWAuthor(self):
        # page with author reference
        page = models.Page(author=self.user, title=" ".join(lorem.words()))
        self.save(page)
        self.assertEqual(page.author.id, self.user.id)
        self.assertIn(page.id, [p.id for p in self.user.pages])
        self.assert_(page._slug)
        self.assert_(len(page._slug) > 0)
        
        #section with page and author reference
        section = models.PageSection(author=self.user, 
                                     body=lorem.paragraphs(10), 
                                     page=page)
        self.save(section)
        self.assertEqual(section.page.id, page.id)
        self.assertEqual(section.author.id, self.user.id)
        self.assertIn(section.id, [s.id for s in page.sections])

        # unique slug
        new_page = models.Page(author=page.author, title=page.title)
        self.save(new_page)
