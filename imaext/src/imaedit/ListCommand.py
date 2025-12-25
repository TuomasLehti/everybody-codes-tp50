from typing import List
from src.ima.Entry import Entry
from src.ima.Image import Image

class ListCommand:

    @classmethod
    def register(
        cls,
        subparsers
    ) -> None:
        parser = subparsers.add_parser(
            "list",
            help="List files in the disk image",
            description="List directory contents of the disk image."
        )
        parser.add_argument(
            "image",
            help="Disk image file"
        )
        parser.set_defaults(
            func=cls.run
        )


    @classmethod
    def run(
        cls,
        args
    ) -> None:
        disk = Image(args.image)
        print("Disk label:", disk.boot_sector.get_label())
        entries = disk.get_file_entries(-1)
        cls.dir(disk, entries)    


    @classmethod
    def dir(
        cls,
        disk: Image,
        entries: List[Entry],
        depth: int = 0
    ):
        for idx, entry in enumerate(entries):
            print('│   ' * depth, end="")
            if idx < len(entries) - 1:
                print('├── ', end="")
            else:
                print('└── ', end="")
            print(
                entry.get_file_name(),
                entry.get_size(),
                entry.get_modification_time(),
            )
            if entry.has_attr(Entry.DIRECTORY_ATTR) and not entry.is_dot_entry():
                entries = disk.get_file_entries(entry.get_first_cluster_idx())
                cls.dir(disk, entries, depth + 1)