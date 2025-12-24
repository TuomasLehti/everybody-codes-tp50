import unittest
from Entry import Entry
from Image import Image

class TestEntry(unittest.TestCase):

    @classmethod
    def setUpClass(cls):
        cls.__image = Image("civboot.ima")
        cls.__root = cls.__image.root_directory

    def test_get_name(self):
        entry = self.__root.get_entry(0)
        self.assertEqual(entry.get_file_name(), 'IO.SYS')

    def test_get_size(self):
        entry = self.__root.get_entry(0)
        self.assertEqual(entry.get_size(), 33430)

    def test_has_attr_iosys(self):
        entry = self.__root.get_entry(0)
        self.assertTrue(entry.has_attr(Entry.HIDDEN_ATTR))
        self.assertTrue(entry.has_attr(Entry.SYSTEM_ATTR))
        self.assertTrue(entry.has_attr(Entry.READ_ONLY_ATTR))

    def test_has_attr_volume(self):
        entry = self.__root.get_entry(2)
        self.assertTrue(entry.has_attr(Entry.VOLUME_ID_ATTR))

    def test_has_attr_autoexec(self):
        entry = self.__root.get_entry(4)
        self.assertFalse(entry.has_attr(Entry.HIDDEN_ATTR))
        self.assertFalse(entry.has_attr(Entry.SYSTEM_ATTR))
        self.assertFalse(entry.has_attr(Entry.READ_ONLY_ATTR))

    def test_get_modofication_time(self):
        entry = self.__root.get_entry(0)
        creation = entry.get_modification_time()
        self.assertEqual(creation.year, 1991)
        self.assertEqual(creation.month, 11)
        self.assertEqual(creation.day, 11)
        self.assertEqual(creation.hour, 5)
        self.assertEqual(creation.minute, 0)

    def test_get_first_cluster_idx(self):
        entry = self.__root.get_entry(4)
        self.assertEqual(entry.get_first_cluster_idx(), 0xec)