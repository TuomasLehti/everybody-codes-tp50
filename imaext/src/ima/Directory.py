from typing import List
from src.ima.Block import Block
from src.ima.Entry import Entry

class Directory(Block):

    """A directory holds multiple entries, which can be directories 
    themselves."""

    def get_entry(
        self,
        idx : int
    ) -> Entry:
        return Entry(self.get_bytes(Entry.ENTRY_SIZE * idx, Entry.ENTRY_SIZE))
    

    def get_entries(
        self
    )-> List[Entry]:
        """Returns a list of entries. Deleted entries are not included. Dot
        entries are included."""
        entries = []
        num_of_entries = len(self.bytes) // Entry.ENTRY_SIZE
        for idx in range(0, num_of_entries):
            entry = self.get_entry(idx)
            if entry.is_last_entry():
                break
            if not entry.is_deleted():
                entries.append(entry)
        return entries