from Block import Block

class Entry(Block):


    """A file entry in a directory."""


    ENTRY_SIZE = 32


    READ_ONLY_ATTR = 0b0000_0001
    HIDDEN_ATTR = 0b0000_0010
    SYSTEM_ATTR = 0b0000_0100
    VOLUME_ID_ATTR = 0b0000_1000
    DIRECTORY_ATTR = 0b0001_0000
    ARHIVE_ATTR = 0b0010_0000


    __FILENAME_OFS = 0x00
    __FILENAME_LEN = 8
    __EXTENSION_OFS = 0x08
    __EXTENSION_LEN = 3
    __ATTRIBUTES_OFS = 0x0b
    __SIZE_OFS = 0x1c


    def get_file_name(
        self
    ) -> str:
        """Returns the name of the file in 8.3 format."""
        return (
            self.get_string(self.__FILENAME_OFS, self.__FILENAME_LEN)
            + '.'
            + self.get_string(self.__EXTENSION_OFS, self.__EXTENSION_LEN)
        )
    

    def get_size(
        self
    ) -> int:
        return self.get_dword(self.__SIZE_OFS)
    
    
    def has_attr(
        self,
        attribute : int,
    ) -> bool:
        return self.get_byte(self.__ATTRIBUTES_OFS) & attribute == attribute