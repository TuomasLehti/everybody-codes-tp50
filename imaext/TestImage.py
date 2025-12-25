import unittest
from Image import Image

def test_get_root_dir_ofs(self):
    image = Image('civboot.ima')
    self.assertEqual(image.get_root_dir_ofs, 0x2600)