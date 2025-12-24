from Block import Block
from Entry import Entry

class Directory(Block):

    """A directory holds multiple entries, which can be directories 
    themselves."""

    def get_entry(
        self,
        idx : int
    ) -> Entry:
        return Entry(self.get_bytes(Entry.ENTRY_SIZE * idx, Entry.ENTRY_SIZE))