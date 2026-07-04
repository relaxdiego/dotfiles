#!/bin/bash
# Claude Code status line: reads session JSON on stdin, prints one line.
jq -r '"[\(.model.display_name)] \(.context_window.used_percentage // 0 | floor)% context used"'
