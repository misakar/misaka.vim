# coding: utf-8
import sys
import vim

def initPythonModule():
    if sys.version_info[:2] < (2, 4):
        vim.command('let s:has_supported_python = 0')
