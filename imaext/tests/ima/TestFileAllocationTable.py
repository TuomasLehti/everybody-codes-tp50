from typing import List
import unittest
from src.ima.Image import Image

class TestBootSector(unittest.TestCase):

    @classmethod
    def setUpClass(cls):
        cls.__image = Image("civboot.ima")
        cls.__fat = cls.__image.file_allocation_table


    def test_get_chain(self):
        chain : List[int] = self.__fat.get_chain(2)
        self.assertEqual(chain[-1], 67)