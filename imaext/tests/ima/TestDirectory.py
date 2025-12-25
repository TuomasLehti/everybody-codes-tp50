import unittest
from src.ima.Entry import Entry
from src.ima.Directory import Directory
from src.ima.Image import Image


class TestDirectory(unittest.TestCase):

    def test_get_entries(self):
        image = Image('civboot.ima')
        dir = Directory(image.get_bytes(
            image.get_root_dir_ofs(), 
            image.boot_sector.get_num_of_root_dir_entries() * Entry.ENTRY_SIZE
        ))
        entries = dir.get_entries()
        self.assertEqual(len(entries), 6)