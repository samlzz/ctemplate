# C Project Utilities Repository

This repository is designed to provide utility files and templates for C projects. It contains resources to streamline the setup of Makefiles, configuration files, and utilities for projects. Below is an explanation of each file and its purpose.

## Contents

### 1. `Makefile`

A general-purpose Makefile template for C projects **not using the `libft` library**. It provides a basic structure for compiling and linking your project files with customizable targets.

### 2. `libftMakefile`

A Makefile template specifically designed for C projects **that use the `libft` library**. It handles both the compilation of your project and the integration of the `libft` library seamlessly.

### 3. `utils.sh`

A shell script containing a collection of utility functions. These functions can assist in automating repetitive tasks or managing project configurations. These utilities are reusable across projects.

### 4. `init.sh`

A script to initialize your shell configuration with the utilities from `utils.sh`. When executed, it appends the content of `utils.sh` to your shell configuration file ( e.g., `.bashrc`, `.zshrc`, ... ).

### 5. `.gitignore`

A template `.gitignore` file tailored for C projects. It excludes unnecessary files, such as compiled binaries and object files, from being tracked in your Git repository.

### 6. `valgrind_errors.md`

A Markdown file explaining common Valgrind errors and how to resolve them. This file is an essential reference for debugging memory issues in C projects.

## How to Use This Repository

1. **Add Utilities to Your Shell Configuration**:  
   Run the `init.sh` script to add the utilities from `utils.sh` to your shell configuration.

   ```bash
   ./init.sh
   ```

   If you can't execute it because it doesn't have enought permision:

   ```bash
   chmod +x init.sh
   ```

2. **Your now able to use theses alias and functions in your shell**:  
    See bellow how to use them.

### **Alias and Functions Overview**

Here is a detailed explanation of the aliases and functions, their purposes, and how to use them.


### **Aliases**

1. **`cl`**:
   - Command: `clear`
   - **Purpose**: Clears the terminal screen for better visibility.

2. **`la`**:
   - Command: `ls --all`
   - **Purpose**: Lists all files and directories, including hidden files (those starting with a dot).

3. **`vl`**:
   - Command: `valgrind`
   - **Purpose**: Shortens the command to run `valgrind`, a tool for detecting memory issues in programs.

4. **`ccw`**:
   - Command: `gcc -Wall -Wextra -Werror`
   - **Purpose**: Compiles C programs with strict warning flags, helping identify potential code issues.

### **Functions**

#### 1. **`exinit`**

   - **Usage**: `exinit <target_directory>`
   - **Description**:
     - Searches for a `.exemple` directory in the parent directories of the current working directory ( stop at root ).
     - If found, creates the `target_directory` and copies the contents of `.exemple` into it.
     - Outputs success or an error message if no `.exemple` directory is found.
   - **Example**:

     ```bash
     exinit my_project
     ```

#### 2. **`manproto`**

   - **Usage**: `manproto <function_name>`
   - **Description**:
     - Extracts the prototype of a function from its corresponding `man` page.
     - Automatically checks the correct section of the `man` page if necessary.
   - **Example**:

     ```bash
     manproto printf
     ```

#### 3. **`ccreate`**

   - **Usage**: `ccreate <filename> <source_extension> <header_extension>`
   - **Description**:
     - Creates a source file and an associated header file.
     - Generates include guards (`#ifndef`, `#define`, `#endif`) in the header file.
     - Automatically includes the header file in the source file.
   - **Do not use**:
     - This function is an auxiliair function for hppcreate and hcreate functions
     - It is not protected from bad inputs, so I recommend using the already existing functions or creating your own that will use this one.

#### 4. **`hppcreate`**

   - **Usage**: `hppcreate <filename>`
   - **Description**:
     - Uses `ccreate` to create a `.cpp` source file and its associated `.hpp` header file.
   - **Example**:

     ```bash
     hppcreate myclass
     ```

#### 5. **`hcreate`**

   - **Usage**: `hcreate <filename>`
   - **Description**:
     - Uses `ccreate` to create a `.c` source file and its associated `.h` header file.
   - **Example**:

     ```bash
     hcreate mymodule
     ```

#### 6. **`ftinit`**

   - **Usage**: `ftinit [--noMake -nm]`
   - **Description**:
     - Prepares the current directory for a C project.
     - Checks if a template directory (`$HOME/ctemplate`) exists. If not, prompts to download it from GitHub.
     - Copies a `.gitignore` template into the current directory.
     - If `--noMake` or `-nm` is not specified:
       - Asks whether the project will use `libft`.
       - Copies the appropriate Makefile (`Makefile` or `libftMakefile`) into the current directory.
   - **Example**:

     ```bash
     ftinit
     ftinit --noMake
     ```

### **How to Use Them in Your Projects**

- **Initialize a project**: Use `ftinit` to quickly set up a new project with the appropriate files.
- **Generate source and header files**: Use `hcreate` or `hppcreate` to generate files with pre-filled include guards.
- **Extract function prototypes**: Use `manproto` to get prototypes from `man` pages.

## Makefile explaination

### Makefile Usage Guide (Non-`libft` Projects)

This Makefile is designed for C projects **not using the `libft` library**. It automates common build tasks, such as compiling, linking, cleaning, and running your project.

### **Key Variables**

- **`NAME`**: Define the name of the final executable or library.
  - Example: `NAME = my_program`

- **`SRC_DIR`**: Directory containing source files (`.c`).
  - Default: `src/`

- **`OBJ_DIR`**: Directory where object files (`.o`) are stored after compilation.
  - Default: `build/`

- **`INCL_DIR`**: Directory for header files (`.h`), if any. Add paths here to include them during compilation.
  - Example: `INCL_DIR = include/`

- **`C_FILES`**: List of source files to compile.
  - Example: `C_FILES = main.c utils.c`

### **Commands**

- **`make` or `make all`**: Compiles the project.
  - Creates the `OBJ_DIR` if it doesn’t exist.
  - Compiles all source files in `SRC_DIR` to object files in `OBJ_DIR`.
  - Links the object files to create the final executable or library (`NAME`).

- **`make clean`**: Deletes all object files (`.o`) and removes the `OBJ_DIR`.

- **`make fclean`**: Performs `clean` and also deletes the final executable (`NAME`).

- **`make re`**: Cleans everything (`fclean`) and rebuilds the project from scratch.

- **`make run`**: Executes the compiled program (`./$(NAME)`) and pipes its output through `cat -e` for easier debugging.

### **Customizing the Makefile**

1. Define `NAME`
2. Add Source Files in `C_FILES`
3. Include Headers (optional)

### **Features**

- **Flexible Linking**: Automatically detects whether to create an archive (`.a`) or an executable based on the `NAME` variable.
- **Color-Coded Outputs**: The Makefile uses colors to distinguish between different stages of the build process:
  - **Yellow**: Compilation.
  - **Green**: Successful builds.
  - **Blue**: Cleaning object files.
  - **Cyan**: Cleaning executables.

---

### Makefile Usage Guide (Projects Using `libft`)

This Makefile is specifically designed for C projects that **require integration with the `libft` library**. It automates not only the compilation of your project but also the retrieval, setup, and management of the `libft` library. Like the general Makefile for non-`libft` projects, it handles compilation, cleaning, and linking, but it adds functionality to fetch `libft` from a Git repository, compile it, and seamlessly link it with your project.

### Additional Rules in the Makefile for `libft` Projects

**1. `lib`**

- **Purpose**: Compiles the `libft` library and prepares it for use in your project.
- **How it works**:
  - Checks if the `libft` directory exists. If not, it retrieves the library from the specified Git repository (`LIBFT_GIT`).
  - Invokes the appropriate `libft` rules (`bonus` or `bobjects`) to compile the library.

- **Usage**:

  ```bash
  make lib
  ```

---

**2. `relib`**
- **Purpose**: Cleans and recompiles the `libft` library.
- **How it works**:
  - Executes the `dellib` rule to remove the `libft` directory.
  - Rebuilds everything, including retrieving `libft` if necessary, by calling `make all`.

- **Usage**:
  ```bash
  make relib
  ```

---

**3. `dellib`**
- **Purpose**: Deletes the `libft` directory and all its contents.
- **How it works**:
  - Removes the `libft` directory entirely.
  - Ensures a clean state for the library before retrieval or rebuilding.

- **Usage**:
  ```bash
  make dellib
  ```
