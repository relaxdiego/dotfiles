#!/usr/bin/env python3

#
# For more information, see:
# https://github.com/ycm-core/YouCompleteMe#configuring-through-vim-options
#
# Debugging:
# https://github.com/ycm-core/YouCompleteMe#the-ycmdebuginfo-command
#

import logging
import os
from pathlib import Path
import sys

log = logging.getLogger()


def Settings(**kwargs):
    log.debug("Running ycm_global_extra_conf.py")
    log.debug("Received kwargs: {}".format(kwargs))
    settings = {
        'sys_path': infer_extra_sys_paths(**kwargs)
    }

    # In case customization is needed later
    # configure_rust_language_server(settings, **kwargs)

    log.debug("Returning settings: {}".format(settings))
    return settings


def configure_rust_language_server(settings, **kwargs):
    if kwargs.get('language', None) == 'rust':
        settings['ls'] = {
            'rust': {
                # https://github.com/rust-lang/rls#configuration
            }
        }


def infer_extra_sys_paths(**kwargs):
    log.debug("Inferring extra sys paths")
    extra_sys_paths = []

    extra_sys_paths += get_python_project_sys_paths(**kwargs)

    log.info("Returning inferred extra sys paths {}".format(extra_sys_paths))
    return extra_sys_paths


def get_python_project_sys_paths(**kwargs):
    sys_paths = []
    if kwargs.get('language', None) == 'python':
        file_path = Path(kwargs.get('filename', None)).resolve().absolute()
        dunder_init = file_path.parent.joinpath('__init__.py')
        if dunder_init.exists():
            sys_paths.append(str(file_path.parent))
    else:
        log.debug("File is not python. Skipping")
    return sys_paths


def test_get_python_project_sys_paths__project_style_1():
    log.debug("test_get_python_project_sys_paths__project_style_1")
    log.debug("==================================================")
    dotfiles_vim_path = Path(__file__).resolve().parent.absolute()
    file_path = dotfiles_vim_path.joinpath('ycm_test_projects',
                                           'python_project_1',
                                           'some_subfolder',
                                           'some.py')
    settings_kwargs = {
        'language': 'python',
        'filename': str(file_path),
        'client_data': {}
    }
    settings = Settings(**settings_kwargs)
    log.debug("actual: {}".format(settings))
    expected_settings = {
        'sys_path': [
            str(dotfiles_vim_path.joinpath('ycm_test_projects',
                                           'python_project_1',
                                           'some_subfolder')),
        ]
    }
    log.debug("expect: {}".format(expected_settings))
    assert settings == expected_settings
    log.debug("PASS")


if 'TEST_YCM_GLOBAL_EXTRA_CONF' in os.environ:
    log.setLevel('DEBUG')

    handler = logging.StreamHandler(sys.stdout)
    handler.setLevel(logging.DEBUG)
    formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')
    handler.setFormatter(formatter)
    log.addHandler(handler)

    test_get_python_project_sys_paths__project_style_1()
