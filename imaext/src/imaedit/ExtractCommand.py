from datetime import datetime
import logging
import os
from pathlib import Path
from typing import List
from src.ima.Entry import Entry
from src.ima.Image import Image

class ExtractCommand:

    @classmethod
    def register(
        cls,
        subparsers
    ) -> None:
        parser = subparsers.add_parser(
            "extract",
            help="Extract files from the disk image",
            description=
                "Extracts the contents of the disk image into the destination directory.\n"
                "Existing files are not overwritten unless the image contains a newer\n"
                "version."
        )
        parser.add_argument(
            "image",
            help="the name of the disk image file"
        )
        parser.add_argument(
            "destination",
            nargs="?",
            default=".",
            help="destination directory (default: current directory)"
        )
        parser.add_argument(
            "-v", "--verbose",
            help="also list skipped files",
            action="store_true"
        )
        parser.add_argument(
            "-q", "--quiet",
            help="suppress output",
            action="store_true"
        )
        parser.set_defaults(
            func=cls.run
        )


    @classmethod
    def run(
        cls,
        args
    ) -> None:
        if args.verbose:
            logging_level = logging.DEBUG
        elif args.quiet:
            logging_level = logging.WARNING
        else:
            logging_level = logging.INFO
        logging.basicConfig(
            level=logging_level,
            format="%(message)s"
        )
        disk = Image(args.image)
        cls.log = logging.getLogger(__name__)
        entries = disk.get_file_entries(-1)
        destpath = Path(args.destination)
        cls.log.info(f'Extracting {disk.boot_sector.get_label()} to {destpath}')
        cls.extract(disk, entries, destpath, Path())


    @classmethod
    def extract(
        cls,
        disk: Image,
        entries: List[Entry],
        destpath: Path,
        curpath: Path
    ):
         os.makedirs(destpath / curpath, exist_ok=True)
         for idx, entry in enumerate(entries):
            new_name = curpath / entry.get_file_name()
            if entry.is_dot_entry():
                continue
            if entry.has_attr(Entry.DIRECTORY_ATTR):
                new_entries = disk.get_file_entries(entry.get_first_cluster_idx())
                cls.extract(disk, new_entries, destpath, new_name)
            else:
                dest_filename = Path(destpath) / curpath / entry.get_file_name()
                if not dest_filename.exists():
                    cls.log.info(f'Extract  {new_name}  -> created')
                    overwrite = True
                else:
                    dest_mod_ts = datetime.fromtimestamp(dest_filename.stat().st_mtime)
                    src_mod_ts = entry.get_modification_time()
                    if dest_mod_ts < src_mod_ts:
                        cls.log.info(f'Extract  {new_name}  -> overwritten (newer)')
                        overwrite = True
                    else:
                        cls.log.debug(f'Extract  {new_name}  -> skipped (older)')
                        overwrite = False
                if overwrite:
                    file_contents = disk.get_file(entry)
                    with open(destpath / curpath / entry.get_file_name(), "wb") as f:
                        f.write(file_contents)