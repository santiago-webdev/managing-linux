# Will give readwrite permissions to all users on the file named name-the-directory
``` bash
chmod a+rw name-the-directory
```
# To go the the previous directory
``` bash
cd -
```

# This gives a list of packages installed by me from the AUR excluding the helper
``` bash
pacman -Qm | awk '{print $1}' | awk '!/paru/'
```

# And this list everything.
``` bash
pacman -Qe | awk '{print $1}'
```

# Determine type of command, list contents of aliases and functions. Search man pages
``` bash
apropos
type
info
man
<command> --help-all
```
