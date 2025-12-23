from Block import Block

class BootSector(Block):

    SECTOR_SIZE_OFS = 0x0b
    NUM_OF_RESERVED_SECTORS_OFS = 0x0e
    NUM_OF_FATS_OFS = 0x10
    FAT_SIZE_OFS = 0x16
    LABEL_OFS = 0x2b
    LABEL_LEN = 11
    FILE_SYSTEM_ID_OFS = 0x36
    FILE_SYSTEM_ID_LEN = 8
    FILE_SYSTEM_ID_FAT12 = 'FAT12'


    def get_label(
        self
    ) -> str:
        """Returns the disk label."""
        return self.bytes.get_string(
            BootSector.LABEL_OFS, BootSector.LABEL_LEN
        )


    def get_file_system_id(
        self
    ) -> str:
        """Returns the file system id. This describes the file system used."""
        return self.bytes.get_string(
            BootSector.FILE_SYSTEM_ID_OFS, BootSector.FILE_SYSTEM_ID_LEN
        )


    def get_sector_size(
        self
    ) -> int:
        """Returns the number of bytes in a (logical) sector."""
        return self.bytes.get_word(BootSector.SECTOR_SIZE_OFS)
    

    def get_num_of_reserved_sectors(
        self
    ) -> int:
        """Returns the number of reserved sectors in the beginning of the image."""
        return self.bytes.get_word(BootSector.NUM_OF_RESERVED_SECTORS_OFS)
    

    def get_num_of_fats(
        self
    ) -> int:
        """Returns the number of file allocation tables."""
        return self.bytes.get_byte(BootSector.NUM_OF_FATS_OFS)


    def get_fat_size(
        self
    ) -> int:
        """Returns the number of logical sectors per fat."""
        # This project deals only with FAT12, no need to check 0x024.
        return self.bytes.get_word(BootSector.FAT_SIZE_OFS)
    

    def get_fat_ofs(
        self
    ) -> int:
        """Returns the offset of the first file allocation table."""
        return self.get_sector_size() * self.get_num_of_reserved_sectors()
    

    def get_root_dir_ofs(
        self
    ) -> int:
        """Returns the offset of the root directory."""
        num_fats = self.get_num_of_fats()
        fat_size = self.get_fat_size()
        block_size = self.get_block_size()
        return (1 + num_fats * fat_size)  * block_size


