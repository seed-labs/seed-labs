#!/bin/bash

echo "Installing miscellaneous tools ..."
DOWNLOADS=/home/seed/Downloads


# Install gdbpeda (gdb plugin)
git clone https://github.com/longld/peda.git $DOWNLOADS/gdbpeda
sudo cp -r $DOWNLOADS/gdbpeda  /opt
echo "source /opt/gdbpeda/peda.py" >> ~/.gdbinit
rm -rf $DOWNLOADS/gdbpeda


