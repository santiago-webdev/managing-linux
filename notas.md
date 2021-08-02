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
# From https://stackoverflow.com/questions/62205627/using-bindkey-to-call-a-function-in-zsh-requires-pressing-enter-after-function-r
To display messages in a zle widget, you're supposed to use zle -M rather than echo. echo will output your message at
whatever the current cursor position is which isn't especially helpful. If you really want to use echo, calling zle
reset-prompt afterwards will redraw a fresh prompt. If you don't want a potential mess in your terminal, consider
starting with \r to move the cursor to the beginning of the line and ending with $termcap[ce] to clear to the end of
the line.
