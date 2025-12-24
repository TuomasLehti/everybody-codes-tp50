from Block import Block
from BootSector import BootSector
from Directory import Directory
from Entry import Entry
from FileAllocationTable import FileAllocationTable

class Image(Block):

    """
    Contains all the bytes of a disk image.
    """

    def __init__(
        self,
        filename : str
    ):
        """
        Initializes a disk image. Does not check whether it is an actual disk
        image or not, because there really is no simple way to test that.
        """
        with open(filename, 'rb') as file:
            super().__init__(bytearray(file.read()))
        self.boot_sector = BootSector(self.get_bytes(0, 512))
        self.file_allocation_table = FileAllocationTable(self.get_bytes(
            self.boot_sector.get_fat_ofs(),
            self.boot_sector.get_sector_size() * self.boot_sector.get_fat_size()
        ))
        self.root_directory = Directory(self.get_bytes(
            self.boot_sector.get_root_dir_ofs(),
            self.boot_sector.get_num_of_root_dir_entries() * Entry.ENTRY_SIZE
        ))

    