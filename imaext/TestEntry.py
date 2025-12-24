import unittest
from Image import Image

class TestEntry(unittest.TestCase):

    @classmethod
    def setUpClass(cls):
        cls.__image = Image("civboot.ima")
        cls.__root = cls.__image.root_directory

    def test_get_name(self):
        entry = self.__root.get_entry(0)
        self.assertEqual(entry.get_file_name(), 'IO.SYS')