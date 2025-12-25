import unittest
from src.ima.Image import Image

class TestImage(unittest.TestCase):

    def test_get_root_dir_ofs(self):
        image = Image('civboot.ima')
        self.assertEqual(image.get_root_dir_ofs(), 0x2600)

    def test_get_data_region_ofs(self):
        image = Image('civboot.ima')
        self.assertEqual(image.get_data_region_ofs(), 0x4200)

    def test_get_cluster_idx(self):
        image = Image('civboot.ima')
        self.assertEqual(image.get_cluster_ofs(2), 0x4200)
        self.assertEqual(image.get_cluster_ofs(3), 0x4400)

    def test_get_file_entries(self):
        image = Image('test_big_dir.IMA')
        entries = image.get_file_entries(2)
        self.assertEqual(len(entries), 65)
