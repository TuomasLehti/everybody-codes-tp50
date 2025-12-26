from datetime import datetime, date, time
from src.ima.Block import Block

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
    __MODIFICATION_DATE_OFS = 0x18
    __MODIFICATION_TIME_OFS = 0x16
    __FIRST_CLUSTER_IDX_OFS = 0x1A


    def get_file_name(
        self
    ) -> str:
        """Returns the name of the file in 8.3 format."""
        name = self.get_string(self.__FILENAME_OFS, self.__FILENAME_LEN)
        ext = self.get_string(self.__EXTENSION_OFS, self.__EXTENSION_LEN)
        return (
            name
            + ('.' if not ext == '' else '')
            + ext
        )
    

    def get_size(
        self
    ) -> int:
        """Returns the size of the file in bytes."""
        return self.get_dword(self.__SIZE_OFS)
    
    
    def has_attr(
        self,
        attribute : int,
    ) -> bool:
        """Returns true if the file has a certain attribute. Attributes are
        defined as *_ATTR and they can be added to check if a file is eg.
        hidden and a system file."""
        return self.get_byte(self.__ATTRIBUTES_OFS) & attribute == attribute
    

    def is_deleted(
        self
    ) -> bool:
        return self.get_byte(self.__FILENAME_OFS) == 0xE5
    

    def is_last_entry(
        self
    ) -> bool:
        return self.get_byte(self.__FILENAME_OFS) == 0x00
    

    def is_available(
        self
    ) -> bool:
        """Returns the availability of an entry. An entry is available if it
        has not been used at all or if it is deleted."""
        return self.is_last_entry() or self.is_deleted()
    

    def is_dot_entry(
        self
    ) -> bool:
        return self.get_byte(self.__FILENAME_OFS) == 0x2E
    

    def get_modification_time(
        self
    ) -> datetime:
        modification_date = self.get_word(self.__MODIFICATION_DATE_OFS)
        d = date(
            1980 + (modification_date >> 9),
            (modification_date & 0b0000_0001_1110_0000) >> 5,
            modification_date & 0b0000_0000_0001_1111
        )
        modification_time = self.get_word(self.__MODIFICATION_TIME_OFS)
        t = time(
            modification_time >> 11,
            (modification_time & 0b0000_0111_1110_0000) >> 5,
            2 * (modification_date & 0b0000_0000_0001_1111)
        )
        return datetime.combine(d, t)
    

    def get_first_cluster_idx(
        self
    ) -> int:
        return self.get_word(self.__FIRST_CLUSTER_IDX_OFS)
    

    def __str__(
        self
    ) -> str:
        if not self.has_attr(Entry.DIRECTORY_ATTR):
            size_str = f"{str(self.get_size()):>7}"
        else:
            size_str =  " <DIR> "
        return (
            f"{self.get_file_name():<12} "
            f"{size_str} "
            f"{self.get_modification_time()}"
        )