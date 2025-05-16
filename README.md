# Configuration Repository

This repository contains various configuration files and scripts to streamline development and system setup. It includes shell helpers, Makefile templates, terminal/IDE settings and custom command-line utilities.

## 📦 Contents

### 1. **Makefile Templates**

-   `Makefile`: Generic multi-language Makefile (C/C++) with auto linker detection

#### Old template, kept for compatibility:

-   `oldMakefile`: General-purpose Makefile for C projects not using my `libft`.
-   `libftMakefile`: Specialized Makefile for projects integrating my `libft`.

### 2. **CLI Commands (`bin/`)**

These are now standalone scripts accessible from anywhere after :

-   `ftinit`: Initialize a project with `src/`, `.gitignore`, and an optional Makefile
-   `hcreate`: Create `.h/.c` or `.hpp/.cpp` files with proper include guards or class template
-   `gitingest`: Display file structure and/or content of given directory.
-   `gupdate`: Pull updates for multiple Git repositories
-   `managedns`: Toggle DNS control through NetworkManager (Arch Linux focused)

The `custom_completion.sh` file is used to defined completions for theses commands.

### 3. **Shell Scripts**

-   `init.sh`: Bootstraps your shell with aliases and function sourcing
-   `utils.sh`: Remaining helper functions and aliases (mostly minor utilities)
-   `git_alias.sh`: Git-specific aliases and conventional commit helper

### 4. **Development Utilities**

-   `vl_msg.md`: Guide for interpreting Valgrind diagnostics and memory errors

### 5. **Terminal & Editor Configuration**

#### **🖥️ Terminal**

-   `config/alacritty.toml`: Alacritty terminal configuration.
-   `config/catppuccin-mocha.toml`: Color scheme settings for Alacritty.
-   `config/tmux.conf`: Tmux configuration for enhanced workflow and Neovim integration.

#### **📝 VSCode**

-   `vscode/settings.json`: Predefined VSCode preferences.
-   `vscode/reinst_ext.sh`: Script to reinstall saved VSCode extensions.

## ⚙️ Usage

### **Initialize Shell Configuration**

Run the `init.sh` script to add aliases and functions to your shell:

```bash
./init.sh
```

### **🧠 Aliases & Functions (still in utils.sh)**

#### Aliases

-   `cl`: Clears terminal
-   `la`: `ls -a`
-   `vl`: Short `valgrind`
-   `vla`: Verbose `valgrind` config
-   `ccw`: C compiler with strict flags
-   `py`: Shortcut for `python3`
-   Git Aliases: Includes `gs` (status), `gl` (log), `gcl` (clone), `ga` (add), `gp` (push), etc.

#### Shell Functions

-   `srcs_fill [dir]`: Auto-fill FILES in Makefile from `<dir> | curent dir` files
-   `exinit <dir>`: Clones a template `.exemple` folder into `<dir>`
-   `manproto <fn>`: Extracts C function prototype from `man`
-   `convc`: Shows how to write conventional commits

## 🛠️ Makefile Commands

-   `make` — Compile project
-   `make clean` — Remove object files
-   `make fclean` — Remove binary and object files
-   `make re` — Clean and rebuild
-   `make run` — Run compiled binary

If using libft, clone it and configure:

```make
LIB_DIRS  = libft
LIB_FILES = ft
```

## **🖥️ Terminal Setup**

-   **Alacritty**: Configured with `MesloLGSDZ NerdFont`, opacity settings, dynamic padding, and Catppuccin theme.
-   **Tmux**: Includes window navigation shortcuts, status bar customization, and integration with Neovim.
