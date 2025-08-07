upstream: https://github.com/tomipiriyev/Loko.git
latest upstream commit: fe415ad25786e896874eeb3ae1ae623ab8c7d61a

# Unpack script

```sh
FILTER_BRANCH_SQUELCH_WARNING=1 git filter-branch -f --tree-filter '
  find . -name "*.zip" -execdir 7z -y x {} \; ; find . -name "*.zip" -exec rm {} \;
  find . -name "__MACOSX" -exec rm -r {} + ; find . -name ".DS_STORE" -exec rm -r {} +
' HEAD
```
