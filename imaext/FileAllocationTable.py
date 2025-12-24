from typing import List
from Block import Block


class FileAllocationTable(Block):

    __CHAIN_END_MARKER = 4095

    def __init__(
        self,
        bytes : bytearray
    ):
        super().__init__(bytes)
        self.__expand_fat()


    def get_chain(
        self,
        start : int
    ) -> List[int]:
        chain : List[int] = []
        while start != self.__CHAIN_END_MARKER:
            chain.append(start)
            start = self.__fat[start]
        return chain

    
    def __expand_fat(
        self
    ):
        """Expands the 12-bit numbers so that they don't have to be unpacked
        each time a value is needed."""
        self.__fat : List[int] = []
        for idx in range(0, len(self.bytes), 3):
            first, second = self.get_word_pair(idx)
            self.__fat.append(first)
            self.__fat.append(second)



    def print_fat(
        self
    ):
        print(self.__fat)


    
