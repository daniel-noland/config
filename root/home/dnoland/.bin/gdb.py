#!/usr/bin/gdb --eval-command=python
# vim: set filetype=python:
import sys
import gdb
gdb.execute("file " + sys.argv[1])
t = gdb.Type(sys.argv[0])
print("sizeof " + str(sys.argv[0]) + " = " + str(t.sizeof()))
end
