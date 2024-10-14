

## default syntax

> [!NOTE|label:references:]
> - default syntax for nvim-nighly:
>   - `/usr/local/Caskroom/neovim-nightly/latest/nvim-macos-x86_64/share/nvim/runtime/syntax/groovy.vim`

### regex
```bash
^\s*(?:[Ss]tring|[Bb]oolean|[Mm]ap|[Ll]ist|def|void)\s*([^()]+)
# Boolean foo()
# String foo()
# def foo()
# Map foo()
# List foo()

^\s*(?:[Ss]tring|[Bb]oolean|[Mm]ap|[Ll]ist|def|void)(?:<.+>)?\s*([^()]+)
# List<Map<String, String>> foo()
# List foo()
```
