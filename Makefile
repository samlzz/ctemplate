#* VARIABLES
NAME = ...

#TODO: Folders name must end with '\'
SRC_DIR = src/
OBJ_DIR = build/
INCL_DIR = 

CC = cc
CFLAGS := -Wall -Wextra -Werror
RM = rm -f
MD = mkdir -p
AR = ar rcs

C_FILES =	...

#* Colors

ESC = \033[
DEF_COLOR = $(ESC)0;39m
GRAY = $(ESC)0;90m
RED = $(ESC)0;91m
GREEN = $(ESC)0;92m
YELLOW = $(ESC)0;93m
BLUE = $(ESC)0;94m
MAGENTA = $(ESC)0;95m
CYAN = $(ESC)0;96m
UNDERLINE = $(ESC)4m

COLOR_PRINT = @printf "$(1)$(2)$(DEF_COLOR)\n"


#* Automatic

ifdef INCL_DIR
	CFLAGS += -I$(INCL_DIR)
endif

SRCS = $(addprefix $(SRC_DIR), $(C_FILES))
OBJS =	$(addprefix $(OBJ_DIR), $(notdir $(SRCS:.c=.o)))

#? cmd for make final file
ifeq ($(suffix $(NAME)), .a)
	LINK_CMD = $(AR) $(NAME) $(OBJS)
else
	LINK_CMD = $(CC) $(CFLAGS) $(OBJS) -o $(NAME)
endif

#* Rules

all:	$(NAME)

$(NAME): $(OBJ_DIR) $(OBJS)
	@printf "$(GRAY)"
	$(LINK_CMD)
	$(call COLOR_PRINT,$(GREEN)$(UNDERLINE),$(NAME) compiled !)

$(OBJ_DIR)%.o: $(SRC_DIR)%.c
	$(call COLOR_PRINT,$(YELLOW),Compiling: $<)
	@$(CC) $(CFLAGS) -c $< -o $@

$(OBJ_DIR):
	@$(MD) $(OBJ_DIR)

clean:
	@$(RM) $(OBJS)
	@$(RM) -r $(OBJ_DIR)
	$(call COLOR_PRINT,$(BLUE),$(NAME) object files cleaned!)

fclean:		clean
	@$(RM) $(NAME)
	$(call COLOR_PRINT,$(CYAN),executables files cleaned!)

re:		fclean all
	$(call COLOR_PRINT,$(GREEN),Cleaned and rebuilt everything for $(NAME)!)

run:
	./$(NAME) | cat -e

.PHONY:		all clean fclean re run
