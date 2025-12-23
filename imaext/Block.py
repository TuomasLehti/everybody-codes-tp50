from typing import Tuple


class Block:


    """
    A block is a set of bytes. It is used to hold a buffer of bytes in memory,
    and the buffer in question can be either the whole image file or a 
    subsection of it. Subsections are usually called sectors or clusters.
    """


    def __init__(
        self,
        bytes : bytearray
    ):
        self.bytes = bytes

    
    def get_byte(
        self,
        ofs : int
    ) -> int:
        """Returns an 8-bit unsigned integer."""
        return self.bytes[ofs]


    def get_word(
        self,
        ofs : int
    ) -> int:
        """Returns a 16-bit unsigned integer. The FAT12 is little-endian."""
        return self.bytes[ofs] + self.bytes[ofs + 1] * 256


    def get_dword(
        self,
        ofs : int
    ) -> int:
        """Returns a 32-bit unsigned integer. The FAT12 is little-endian."""
        return (
            self.bytes[ofs] + 
            self.bytes[ofs + 1] * 256 +
            self.bytes[ofs + 2] * 256 * 256 +
            self.bytes[ofs + 3] * 256 * 256 * 256
        )
    

    def get_word_pair(
        self,
        ofs : int
    ) -> Tuple[int]:
        """Returns two 12-bit unsigned integers which have been packed to
        three bytes in the buffer."""
        first_byte = self.bytes[ofs]
        middle_high_nibble = self.bytes[ofs + 1] >> 4
        middle_low_nibble = self.bytes[ofs + 1] & 0x0F
        last_byte = self.bytes[ofs + 2]
        return (
            first_byte + (middle_low_nibble << 8),
            middle_high_nibble + (last_byte << 4)
        )


    def get_string(
        self,
        ofs : int,
        len : int
    ) -> str:
        """Returns a string from the image. The length must be known."""
        end = ofs + len
        return self.bytes[ofs:end].decode("ascii").strip()


    def get_bytes(
        self,
        ofs : int,
        len : int
    ) -> bytearray:
        return self.bytes[ofs:ofs + len]