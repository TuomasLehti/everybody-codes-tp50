from Block import Block
from BootSector import BootSector

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
        self.boot_sector = BootSector(self.get_block(0, 512))

    