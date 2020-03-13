# gv
Another golang version manager inspired by [helmenv](https://github.com/little-angry-clouds/helmenv) and based on the binary golang version manager - [g](https://github.com/voidint/g).

`gv` is just a simple wrapper on `g`, which provides all the functionalities.

## Installation

1. Checkout `gv` into any path (`$HOME/g` in the example)

```
git clone https://github.com/shohi/gv.sh ~/.g
```

2. Add `~/.g` to your `$PATH`

```
echo 'export PATH="$HOME/.g:$PATH"' >> ~/.bashrc
# Or
echo 'export PATH="$HOME/.g:$PATH"' >> ~/.zshrc
```

3. Source the script

```
echo 'source $HOME/.g/gv.sh' >> ~/.bashrc
# Or
echo 'source $HOME/.g/gv.sh' >> ~/.zshrc
```

## Usage

### gv help

```
$> gv help
Usage: gv <command> [<options>]
Commands:
    list-remote   List all installable versions
    list          List all installed versions
    install       Install a specific version
    use           Switch to specific version
    uninstall     Uninstall a specific version
```

### helmenv list-remote

List installable versions:

```
$> gv list-remote
Fetching versions...
  1
  1.2.2
  1.3
  1.3.1
  1.3.2
  ...
```

### gv list
List installed versions, and show an asterisk before the currently active version:

```
$> gv list
* 1.11.11
  1.13
  1.13.5
```

### gv install
Install a specific version, and will be activated after installation:

```
$> gv install 1.14
Installed successfully
```

### gv use
Switch to specific version:

```
$> gv use 1.13
go version go1.13 darwin/amd64
```

### gv uninstall
Uninstall a specific version:

```
$> gv uninstall 1.13
Uninstall successfully
```

## Thanks
1. voidint/g, <https://github.com/voidint/g>
2. little-angry-clouds/helmenv, https://github.com/little-angry-clouds/helmenv
