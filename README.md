# tmux-paste-popup

A tmux plugin to provide a popup for easy pasting.

## Requirements

`tmux` >= 3.2

## Installation

### Via TPM

Add plugin to the list of TPM plugins in `.tmux.conf`:
```
set -g @plugin 'minefuto/tmux-paste-popup'
```
Press `prefix + I` to fetch the plugin and source it.

### Manual Install

To install the `tmux-paste-popup` plugin, clone this repository into your tmux plugins directory:

```sh
git clone https://github.com/minefuto/tmux-paste-popup ~/clone/path
```

Then, add this line to your `.tmux.conf`:

```sh
run-shell ~/clone/path/tmux-paste-popup.tmux
```

Reload your tmux configuration:

```sh
tmux source-file ~/.tmux.conf
```

## Usage

To use the `tmux-paste-popup` plugin, simply press the `prefix + ]`(default) to open the popup window.
Then, you can execute the following operations.

To use the `tmux-paste-popup` plugin, simply press the `prefix + ]`(default).

| Key     | Action                       |
| ------- | ---------------------------- |
| `Enter` | paste buffer                 |
| `q`     | exit                         |
| `j`     | scroll forward 1 line        |
| `k`     | scroll backward 1 line       |
| `f`     | scroll forward popup size    | 
| `b`     | scroll backward popup size   |
| `g`     | scroll top                   |
| `G`     | scroll bottom                | 
| `n`     | select next paste buffer     |
| `p`     | select previous paste buffer |

## Configuration

You can configure the `tmux-paste-popup` plugin by adding the following options to your `.tmux.conf`:
```sh
set -g @paste_popup_key ']'                    # for open the popup window key
set -g @paste_popup_override_command 'pbpaste' # for paste from clipboard
set -g @paste_popup_width '80%'                # for configure popup width
set -g @paste_popup_height '80%'               # for configure popup height
```

## License

MIT
