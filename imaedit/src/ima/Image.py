from typing import List, Tuple
from src.ima.Block import Block
from src.ima.BootSector import BootSector
from src.ima.Directory import Directory
from src.ima.Entry import Entry
from src.ima.FileAllocationTable import FileAllocationTable

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
            self.get_root_dir_ofs(),
            self.boot_sector.get_num_of_root_dir_entries() * Entry.ENTRY_SIZE
        ))
    

    def get_root_dir_ofs(
        self
    ) -> int:
        """Returns the offset of the root directory."""
        num_fats = self.boot_sector.get_num_of_fats()
        fat_size = self.boot_sector.get_fat_size()
        block_size = self.boot_sector.get_sector_size()
        return (1 + num_fats * fat_size)  * block_size


    def get_data_region_ofs(
        self,
    ) -> int:
        """Returns the offset of the data region."""
        num_of_entries = self.boot_sector.get_num_of_root_dir_entries() 
        root_dir_size = num_of_entries * Entry.ENTRY_SIZE
        sector_size = self.boot_sector.get_sector_size()
        root_dir_sectors = (root_dir_size + sector_size - 1) // sector_size
        return self.get_root_dir_ofs() + root_dir_sectors * sector_size
    

    def get_cluster_ofs(
        self,
        cluster_idx : int
    ) -> int:
        """Returns the offset of a certain cluster."""
        corrected_cluster_idx = cluster_idx - 2
        return (
            self.get_data_region_ofs()
            + self.boot_sector.get_cluster_size() 
              * self.boot_sector.get_sector_size() 
              * corrected_cluster_idx
        )
    

    def get_file_entries(
        self,
        first_cluster_idx : int
    ) -> List[Entry]:
        """Gets all file entries across multiple directory clusters. Set
        argument to -1 if you want to get the entries of the root directory,
        otherwise it should be the first cluster idx of the directory in
        question."""
        entries : List[Entry] = []
        offsets : List[Tuple[int, int]] = []
        if first_cluster_idx == -1:
            offsets.append((
                self.get_root_dir_ofs(),
                self.boot_sector.get_num_of_root_dir_entries() * Entry.ENTRY_SIZE
            ))
        else:
            chain = self.file_allocation_table.get_chain(first_cluster_idx)
            offsets = [(
                self.get_cluster_ofs(cluster_idx),
                16 * Entry.ENTRY_SIZE
                ) for cluster_idx in chain]
        for ofs, size in offsets:
            dir = Directory(self.get_bytes(ofs, size))
            entries.extend(dir.get_entries())
        return entries
    

    def get_file(
        self,
        entry : Entry
    ) -> bytearray:
        """Returns a file from the image."""
        start = entry.get_first_cluster_idx()
        cluster_bytes = (
            self.boot_sector.get_cluster_size() 
            * self.boot_sector.get_sector_size()
        )
        chain = self.file_allocation_table.get_chain(start)
#        bytes = self.get_bytes(
#            self.get_cluster_ofs(start),
#            cluster_bytes
#        )
        bytes = bytearray()
        for fat_idx in chain:
            bytes.extend(self.get_bytes(
                self.get_cluster_ofs(fat_idx),
                cluster_bytes
            ))
        return bytes[0:entry.get_size()]