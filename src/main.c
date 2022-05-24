/*
** EPITECH PROJECT, 2021
** B-PSU-101-MPL-1-1-minishell1-enzo.daumalle
** File description:
** main.c
*/

#include "my_sh.h"

static void on_process(builtin_t *builtin, env_t *list, char *line, char **env)
{
    tree_t *tree = NULL;

    if (line[my_strlen(line) - 1] == '\n')
        line[my_strlen(line) - 1] = '\0';
    tree = build_tree(line);
    exec_tree(builtin, list, env, tree);
}

int main(int argc, char **argv, char **env)
{
    builtin_t *builtin = NULL;
    size_t len = 0;
    env_t *list = init_env(env);
    char *line = NULL;

    (void) argc;
    (void) argv;
    srand(time(NULL));
    if (isatty(STDIN_FILENO))
        create_ncurses();
    signal(SIGINT, sign_handler);
    p_ntty(HEADER, list);
    while (getline(&line, &len, stdin) != -1)
        if (line)
            on_process(builtin, list, line, env);
    p_ntty(EXIT, list);
    free(line);
    return 0;
}
