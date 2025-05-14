# Configuration Repository

This repository contains various configuration files and scripts to streamline development and system setup. It includes shell configurations, utility scripts, Makefile templates, and settings of my IDE and some terminal tools.

## Contents

### 1. **Makefile Templates**

-   `newMakefile`: Makefile cross languages (C, C++)

#### Old template, kept for compatibility:

-   `Makefile`: General-purpose Makefile for C projects not using my `libft`.
-   `libftMakefile`: Specialized Makefile for projects integrating my `libft`.

### 2. **Shell Scripts**

-   `utils.sh`: Core utility script with many helper functions and aliases.
-   `git_alias.sh`: Git aliases and global Git configuration shortcuts.
-   `init.sh`: Script to bootstrap your shell with aliases and helper functions.
-   `gitingest.sh`: Smart utility to show file structure or content recap

### 3. **Project Utilities**

-   `vl_msg.md`: Detailed explanations of Valgrind message types and severity.

### 4. **Settings**

#### **Terminal Configurations**

-   `config/alacritty.toml`: Alacritty terminal configuration.
-   `config/catppuccin-mocha.toml`: Color scheme settings for Alacritty.
-   `config/tmux.conf`: Tmux configuration for enhanced workflow and Neovim integration.

#### **Editor Configuration**

-   `vscode/settings.json`: Predefined VSCode preferences.
-   `vscode/snippets/`: Custom code snippets (e.g. C++ class template).
-   `vscode/reinst_ext.sh`: Script to reinstall saved VSCode extensions.

## How to Use

### **Initialize Shell Configuration**

Run the `init.sh` script to add aliases and functions to your shell configuration:

```bash
./init.sh
```

### **Available Aliases**

-   `cl`: Clears terminal
-   `la`: `ls -a`
-   `vl`: Short `valgrind`
-   `vla`: Verbose `valgrind` config
-   `ccw`: C compiler with strict flags
-   `py`: Shortcut for `python3`
-   Git Aliases: Includes `gs` (status), `gl` (log), `gcl` (clone), `ga` (add), `gp` (push), etc.

### **Shell Functions**

-   `ftinit`: Initializes a C/C++ project with `src/` folder and, optionnaly, a Makefile
-   `srcs_fill [dir]`: Auto-fill FILES in Makefile from `<dir> | curent dir` files
-   `exinit <dir>`: Clones a template `.exemple` folder into `<dir>`
-   `manproto <fn>`: Extracts C function prototype from `man`
-   `hcreate <name>`: Creates `.h` and optional `.c`
-   `hppcreate <name>`: Creates `.hpp` and `.cpp`
-   `gupdate [dir]`: Pull updates from multiple Git repos
-   `convc`: Shows how to write conventional commits
-   `managedns on|off|state`: DNS control for Arch-based systems

## 🛠️ Makefile Commands (via `newMakefile`)

-   `make` — Compile project
-   `make clean` — Remove object files
-   `make fclean` — Remove binary and object files
-   `make re` — Clean and rebuild
-   `make run` — Run compiled binary

If using libft, use the old `libftMakefile` or clone it manually, then treat it like a classic librairie (see LIB_DIRS & LIB_FILES).

## Terminal Configurations

-   **Alacritty**: Configured with `MesloLGSDZ NerdFont`, opacity settings, dynamic padding, and Catppuccin theme.
-   **Tmux**: Includes window navigation shortcuts, status bar customization, and integration with Neovim.
