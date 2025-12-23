import unittest
from Block import Block

class TestBlock(unittest.TestCase):

    @classmethod
    def setUpClass(cls):
        with open("small.bin", "br") as file:
            cls._block = Block(bytearray(file.read()))

    def test_get_byte(self):
        self.assertEqual(self._block.get_byte(0), 0x10)

    def test_get_word(self):
        self.assertEqual(self._block.get_word(0), 0x1110)

    def test_get_dword(self):
        self.assertEqual(self._block.get_dword(0), 0x13121110)

    def test_get_string(self):
        self.assertEqual(self._block.get_string(4, 8), "abcd")

if __name__ == '__main__':
    unittest.main()