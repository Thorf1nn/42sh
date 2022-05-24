/*
** EPITECH PROJECT, 2021
** B-PSU-101-MPL-1-1-minishell1-enzo.daumalle
** File description:
** init_builts.c
*/

#include "my_sh.h"

static const builtin_t builtins[NB_CMDS] = {
    {"cd", &exec_cd},
    {"pwd", &exec_pwd},
    {"env", &exec_env},
    {"exit", &exec_exit},
    {"setenv", &set_env},
    {"unsetenv", &unset_env}
};

builtin_t *get_builtin(char *line)
{
    int i = 0;
    char *command = NULL;

    for (; line[i] && (line[i] == ' ' || line[i] == '\t'); i++);
    if (!line[i])
        return NULL;
    command = range_strdup(line + i, NULL, " ", true);
    for (int i = 0; i < NB_CMDS; i++)
        if (str_isequal(command, builtins[i].cmd, true))
            return (builtin_t *) &builtins[i];
    return NULL;
}
