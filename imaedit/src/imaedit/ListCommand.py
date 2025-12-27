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
        prefix: str = ''
    ):
         for idx, entry in enumerate(entries):
            print(prefix, end="")
            if idx < len(entries) - 1:
                print('├── ', end="")
            else:
                print('└── ', end="")
            print(entry)
            if (entry.has_attr(Entry.DIRECTORY_ATTR)) and (not entry.is_dot_entry()):
                new_entries = disk.get_file_entries(entry.get_first_cluster_idx())
                cls.dir(
                    disk, 
                    new_entries, 
                    prefix + ('│   ' if idx < len(entries) - 1 else '    ')
                )