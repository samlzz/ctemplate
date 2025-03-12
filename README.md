# Configuration Repository

This repository contains various configuration files and scripts to streamline development and system setup. It includes shell configurations, utility scripts, Makefile templates, and settings for terminal tools like Alacritty and Tmux.

## Contents

### 1. **Makefile Templates**

-   `Makefile`: General-purpose Makefile for C projects not using my `libft`.
-   `libftMakefile`: Specialized Makefile for projects integrating my `libft`.

### 2. **Shell Scripts**

-   `utils.sh`: A collection of shell utilities and aliases.
-   `git_alias.sh`: Defines useful Git aliases for efficiency.
-   `init.sh`: Script to initialize shell configurations with `utils.sh` and Git aliases.

### 3. **Project Utilities**

-   `vl_msg.md`: Detailed explanations of Valgrind message types and severity.

### 4. **Configuration Files**

-   `config/alacritty.toml`: Alacritty terminal configuration.
-   `config/catppuccin-mocha.toml`: Color scheme settings for Alacritty.
-   `config/tmux.conf`: Tmux configuration for enhanced workflow and Neovim integration.

## How to Use

### **Initialize Shell Configuration**

Run the `init.sh` script to add aliases and functions to your shell configuration:

```bash
./init.sh
```

If needed, set execute permissions:

```bash
chmod +x init.sh
```

### **Available Aliases**

-   `cl`: Clears the terminal.
-   `la`: Lists all files, including hidden ones.
-   `vl`: Runs `valgrind`.
-   `vl`: Runs `valgrind` with a set of default arguments.
-   `ccw`: Compiles C programs with strict warnings.
-   `py`: Runs `python3`.
-   Git Aliases: Includes `gs` (status), `gl` (log), `gcl` (clone), `ga` (add), `gp` (push), etc.

### **Utility Functions**

-   `exinit <dir>`: Initializes a directory with `.exemple` content.
-   `manproto <function>`: Extracts function prototypes from `man` pages.
-   `hcreate <name>`: Creates a `.h` source file with, optinaly, an associated `.c` file.
-   `hppcreate <name>`: Creates a `.hpp` source file with an associated `.cpp` file.
-   `ftinit [--noMake|-nm]`: Initializes a C project directory, optionally have a Makefile, and if it is, ask if it should include `libft`.
-   `gupdate`: Updates multiple Git repositories.

#### For Arch linux

-   `managedns on|off|state`: Manages DNS settings for NetworkManager.

### **Makefile Commands**

-   `make`: Compiles the project.
-   `make clean`: Removes object files.
-   `make fclean`: Removes executables and object files.
-   `make re`: Cleans and recompiles everything.
-   `make run`: Executes the compiled program.

_in project with libft_

-   `make lib`: Retrieve and compiles the `libft` library.
-   `make dellib`: Delete the `libft` folder.
-   `make relib`: Delete, retrieve and recompiles `libft`.

## Terminal Configurations

-   **Alacritty**: Configured with `MesloLGSDZ NerdFont`, opacity settings, dynamic padding, and Catppuccin theme.
-   **Tmux**: Includes window navigation shortcuts, status bar customization, and integration with Neovim.
