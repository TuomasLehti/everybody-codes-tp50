import argparse
from typing import List
from Directory import Directory
from Entry import Entry
from Image import Image


"""
A program to extract all files from a IMA disk image to the current directory.
Existing files will be overwritten. A good description of FAT16 can be found at
https://www.tavi.co.uk/phobos/fat.html
"""


    

def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        prog="imaedit",
        description="Extract from and edit files on a 1.44 Mb IMA disk image"
    )
    subparsers = parser.add_subparsers(
        dest="command",
        required=True
    )
    parser_list = subparsers.add_parser(
        "list",
        help="List files in the disk image",
        description="List directory contents of a disk image."
    )
    parser_list.add_argument(
        "image",
        help="Disk image file."
    )
    return parser.parse_args()


def dir(
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
            dir(disk, entries, depth + 1)


def list(
    image_filename : str
):
    disk = Image(image_filename)
    print("Disk label:", disk.boot_sector.get_label())
    dir(disk, disk.get_file_entries(-1))    

    



def main():
    args = parse_args()
    if (args.command == "list"):
        list(args.image)


if __name__ == "__main__":
    main()


#disk = Image(IMA_FILENAME)
#print("Disk label:", disk.boot_sector.get_label(), end="\n\n")
#entries = disk.get_file_entries(disk.root_directory.get_entry(0).get_first_cluster_idx())
#dir(entries)
#print(str(disk.get_file(disk.root_directory.get_entry(4)), encoding="ascii"))