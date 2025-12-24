from Block import Block

class Entry(Block):


    """A file entry in a directory."""


    ENTRY_SIZE = 32
    

    __FILENAME_OFS = 0x00
    __FILENAME_LEN = 8
    __EXTENSION_OFS = 0x08
    __EXTENSION_LEN = 3


    def get_file_name(
        self
    ) -> str:
        """Returns the name of the file in 8.3 format."""
        return (
            self.get_string(self.__FILENAME_OFS, self.__FILENAME_LEN)
            + '.'
            + self.get_string(self.__EXTENSION_OFS, self.__EXTENSION_LEN)
        )