import argparse as _argparse
import os as _os
import pathlib as _pathlib
import sys as _sys
import functools as _ft

dpath = _ft.partial(_os.path.join, _os.path.dirname(_os.path.abspath(
    _os.path.normpath(__file__)
)))

hpath = _ft.partial(_os.path.join, _os.path.expanduser("~"))

_MAPPINGS = [
    ('alias', '.zsh/alias'),
    ('zfuncs', '.zsh/zfuncs'),
]

# Just symlink them to the home directory using the same name.
_FILES = set([
    '.tmux.conf',
    '.zshrc'
])

_BLACKLISTED = set([
    'private'
])


def _find_platform():
    """ Specify the platform we are on. OSX and Linux are supported """
    if _sys.platform in ('linux', 'linux2'):
        return 'linux'
    elif _sys.platform == 'darwin':
        return 'osx'

def _makedir(newdir):
    """ Create newdir, if necessary """
    _pathlib.Path(newdir).mkdir(parents=True, exist_ok=True)


def _create_symlink(src, target):
    """ Actually create the symlink """
    print("Symlinking {src} --> {target}".format(src=src, target=target))

    _makedir(_os.path.dirname(target))

    try:
        _os.symlink(src, target)
    except FileExistsError:
        print("File {target} already exists.".format(target=target))


def _symlink(dry=False, verbose=True):
    """
    Create symlinks 
    """
    print("Symlinking now ...")
    for file_ in _FILES:
        _create_symlink(dpath(file_), hpath(file_))

    for src, target in _MAPPINGS:
        for file_ in _os.listdir(dpath(src)):
            _create_symlink(dpath(src, file_), hpath(target, file_))

    platform = _find_platform()
    
    if platform is not None:
        _create_symlink(dpath('platform', platform), hpath('.zsh', 'platform'))

def main():
    _symlink(dry=True)


if __name__ == '__main__':
    main()