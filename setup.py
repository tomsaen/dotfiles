import argparse as _argparse
import os as _os
import pathlib as _pathlib
import sys as _sys
import shutil as _shutil
import functools as _ft
import hashlib as _hashlib

dpath = _ft.partial(_os.path.join, _os.path.dirname(_os.path.abspath(
    _os.path.normpath(__file__)
)))

hpath = _ft.partial(_os.path.join, _os.path.expanduser("~"))

_MAPPINGS = [
    ('alias', '.zsh/alias'),
    ('zfuncs', '.zsh/zfuncs'),
]

_FILES = set([
    '.tmux.conf',
    '.zshrc'
])

_BLACKLISTED = set([
    'private'
])

vprint = None


def _modified_only(func):
    """ Decorator to only process files that have been changed """
    def proxy(*args, **kwargs):
        """ Decorated function """
        src, target, *args = args
        force = kwargs.get('force', False)

        if force or _hashed(src) != _hashed(target):
            return func(src, target, *args, **kwargs)
        else:
            vprint("{src} -> Hash did not change. Skipping.".format(src=src))
    return proxy


def _assert_existence(func):
    """ Decorator to assert src and target"""
    def proxy(*args, **kwargs):
        """ Decorated function """
        src, target, *args = args
        if _os.path.exists(src):
            _makedir(_os.path.dirname(target))
            return func(src, target, *args, **kwargs)
        else:
            vprint("{src} does not exist".format(src=src))
    return proxy


def _hashed(file_):
    """ Hash content of file_ and return the hexdigest """
    hashed = _hashlib.sha256()
    with open(file_, 'r') as fp:
        buf = fp.read().encode('utf-8')  # Do not do this for very big files
        hashed.update(buf)

    return hashed.hexdigest()


def _set_printer(verbose):
    """ Set global vprint """
    global vprint
    vprint = print if verbose else lambda *args, **kwargs: None


def _find_platform():
    """ Specify the platform we are on. OSX and Linux are supported """
    if _sys.platform in ('linux', 'linux2'):
        return 'linux'
    elif _sys.platform == 'darwin':
        return 'osx'

def _makedir(newdir):
    """ Create newdir, if necessary """
    _pathlib.Path(newdir).mkdir(parents=True, exist_ok=True)


@_assert_existence
@_modified_only
def _copy(src, target, **kwargs):
    """ Copy the file """
    vprint("Copying {src} --> {target}".format(src=src, target=target))

    force = kwargs.pop('force', False)
    dry = kwargs.pop('dry', False)

    if _os.path.exists(target):
        if force and not dry:
            _os.remove(target)
        else:
            return

    if not dry:
        _shutil.copy(src, target)

@_assert_existence
def _link(src, target, **kwargs):
    """ Actually create the symlink """
    vprint("Symlinking {src} --> {target}".format(src=src, target=target))
    dry = kwargs.pop('dry', False)

    try:
        if not dry:
            _os.symlink(src, target)
    except FileExistsError:
        vprint("File {target} already exists.".format(target=target))


def _platform_specifics(func, platform, dry=False, force=False):
    """ Handle platform specific stuff """
    # Platform specific
    source = "source-{platform}".format(platform=platform)
    func(dpath('platform', source), hpath('.zsh', 'platform'), force=force, dry=dry)

    tmux = "tmux-{platform}".format(platform=platform)
    func(dpath('platform', tmux), hpath('.tmux-platform'), force=force, dry=dry)


def _install(func, dry=False, force=False):
    """ Install dotfiles """
    vprint("Installing dotfiles now ...")

    if force:
        vprint("!! Force is activated. Overriding existing files !!")

    if dry:
        vprint("========== DRY RUN ==========")

    for file_ in _FILES:
        func(dpath(file_), hpath(file_), dry=dry, force=force)

    for src, target in _MAPPINGS:
        for file_ in _os.listdir(dpath(src)):
            func(dpath(src, file_), hpath(target, file_), dry=dry, force=force)

    platform = _find_platform()

    if platform is not None:
        _platform_specifics(func, platform, force=force)


def main():
    """ Main function """
    parser = _argparse.ArgumentParser(
        description="tomsaens dotfiles installer"
    )
    parser.add_argument('--force', action='store_true', default=False)
    parser.add_argument('--link', action='store_true', default=False,
                        help="If set, the dotfiles will only symlinked to their target. "
                             "Default is False (copy them)")
    parser.add_argument('--silent', action='store_true', default=False)
    parser.add_argument('--dry', action='store_true', default=False)

    args = parser.parse_args()

    func = _link if args.link else _copy

    verbose = not args.silent
    _set_printer(verbose)

    _install(func, dry=args.dry, force=args.force)


if __name__ == '__main__':
    main()
