import argparse
from src.imaedit.ListCommand import ListCommand


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
    ListCommand.register(subparsers)
    return parser.parse_args()


    



def main():
    args = parse_args()
    args.func(args)


if __name__ == "__main__":
    main()


#disk = Image(IMA_FILENAME)
#print("Disk label:", disk.boot_sector.get_label(), end="\n\n")
#entries = disk.get_file_entries(disk.root_directory.get_entry(0).get_first_cluster_idx())
#dir(entries)
#print(str(disk.get_file(disk.root_directory.get_entry(4)), encoding="ascii"))