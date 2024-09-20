# Shows file paths for list of installed application: tree
# 1. List all installed applications
# 2. Use `grep` to filter all apps with the word tree
# 3. Use `cut` to take string that you want by identifying a delimiter and choosing (-f) which of the index you want
# 4. Use `xargs` to pass the string to `dpkg` to show the file path of all the packages piped through
apt list --installed | grep tree | cut -d '/' -f 1 | xargs dpkg -L