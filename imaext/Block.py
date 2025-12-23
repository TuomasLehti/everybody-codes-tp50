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


    def get_string(
        self,
        ofs : int,
        len : int
    ) -> str:
        """Returns a string from the image. The length must be known."""
        end = ofs + len
        return self.bytes[ofs:end].decode("ascii").strip()


    def get_block(
        self,
        ofs : int,
        len : int
    ) -> bytearray:
        return Block(self.bytes[ofs:ofs + len])
