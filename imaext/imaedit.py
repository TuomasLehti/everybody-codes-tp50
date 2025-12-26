import argparse
from src.imaedit.ExtractCommand import ExtractCommand
from src.imaedit.ListCommand import ListCommand
#from imaext import __version__


"""
A program to extract all files from a IMA disk image to the current directory.
Existing files will be overwritten. A good description of FAT16 can be found at
https://www.tavi.co.uk/phobos/fat.html
"""


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        prog="imaedit",
        description="Extract files from a 1.44 Mb IMA disk image"
    )
    subparsers = parser.add_subparsers(
        dest="command",
        required=True
    )
    ListCommand.register(subparsers)
    ExtractCommand.register(subparsers)
    return parser.parse_args()


def main():
    args = parse_args()
    args.func(args)


if __name__ == "__main__":
    main()
