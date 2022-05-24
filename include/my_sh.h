/*
** EPITECH PROJECT, 2022
** my_sh
** File description:
** my_sh.h
*/

#ifndef __MY_SH_H__
    #define __MY_SH_H__

    #define UNUSED __attribute__((unused))
    #define ERROR_MEMORY  "Error of memory"
    #define HEADER        " ❖ "
    #define EXIT          "exit\n"
    #define NB_CMDS       6

    #include "my.h"
    #include "ncurses.h"
    #include "tree.h"
    #include "env.h"
    #include <unistd.h>
    #include <string.h>
    #include <stdlib.h>
    #include <stdio.h>
    #include <stdbool.h>
    #include <sys/types.h>
    #include <sys/stat.h>
    #include <sys/wait.h>
    #include <fcntl.h>
    #include <signal.h>
    #include <termios.h>
    #include <errno.h>

typedef struct builtin_s {
    char *cmd;
    void (*fptr) (char *, env_t **env, char **);
} builtin_t;

// typedef struct aliases_s {
//     char *alias;
//     char *cmd;
//     aliases_t *next;
// } aliases_t;

builtin_t *get_builtin(char *line);

//Tree
tree_t *build_tree(char *line);
void exec_tree(builtin_t *builtin, env_t *list, char **env, tree_t *tree);
//Utils
char *sort_sep(char *str, char *sep);
void my_putstrerr(char const *str);
int my_str_isalpha_numeric(const char *str);
void closefd(int *fd);
void p_ntty(char const *output, env_t *list);
void sign_handler(int sign_num);
void add_node_at_back(char *key, char *value, env_t **node);
void check_flags(int ac, char **av);
//Env
env_t *init_env(char **env);
void edit_venv(char *kenv, env_t **env, char *nwvenv);
char *find_env(char *kenv, env_t *env);
void set_env(char *line, env_t **list, char **env);
void unset_env(char *line, env_t **list, char **env);
char *get_path(env_t *list, char **cmd);
env_t *get_env(env_t *env, char *key);
//Exec
void exec_binary(env_t **list, char **env, tree_t leaf);
void exec_cd(char *line, env_t **list, char **env);
void exec_env(char *line, env_t **list, char **env);
void exec_pwd(char *line, env_t **list, char **env);
void exec_exit(char *line, env_t **list, char **env);

#endif /* __MY_SH_H__ */
