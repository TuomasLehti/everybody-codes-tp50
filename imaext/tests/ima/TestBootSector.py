import unittest
from src.ima.Image import Image

class TestBootSector(unittest.TestCase):

    @classmethod
    def setUpClass(cls):
        cls.__image = Image("civboot.ima")
        cls.__boot_sector = cls.__image.boot_sector

    def test_get_label(self):
        self.assertEqual(self.__boot_sector.get_label(), "CIVBOOT")

    def test_get_file_system_id(self):
        self.assertEqual(self.__boot_sector.get_file_system_id(), "FAT12")

    def test_get_sector_size(self):
        self.assertEqual(self.__boot_sector.get_sector_size(), 512)

    def test_get_cluster_size(self):
        self.assertEqual(self.__boot_sector.get_cluster_size(), 1)

    def test_get_reserved_sectors(self):
        self.assertEqual(self.__boot_sector.get_num_of_reserved_sectors(), 1)

    def test_get_num_of_fats(self):
        self.assertEqual(self.__boot_sector.get_num_of_fats(), 2)

    def test_get_fat_ofs(self):
        self.assertEqual(self.__boot_sector.get_fat_ofs(), 512)

    def test_get_num_of_root_directory_entries(self):
        self.assertEqual(self.__boot_sector.get_num_of_root_dir_entries(), 224)

if __name__ == '__main__':
    unittest.main()