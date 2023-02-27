def Settings(**kwargs):
    return {
        # https://github.com/ycm-core/YouCompleteMe/issues/3690
        #
        # NOTE: Make sure that the path below is the same path to the python
        # interpreter that you used to compile the plugin. You can specify the
        # interpreter used during compilation via "/usr/local/bin/python3 ./install.py"
        #
        # Afterwards, run "cat /path/to/YouCompleteMe/third_party/ycmd/PYTHON_USED_DURING_BUILDING"
        # to get the path to put into the following config.
{{ if eq .chezmoi.os "linux" -}}
        "interpreter_path": "/usr/bin/python3.10",
{{ else if eq .chezmoi.os "darwin" -}}
        "interpreter_path": "/usr/local/opt/python@3.9/bin/python3.9",
{{ end -}}
    }
