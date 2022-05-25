/*
** EPITECH PROJECT, 2021
** B-PSU-101-MPL-1-1-minishell1-enzo.daumalle
** File description:
** pwd.c
*/

#include "my_sh.h"

void exec_pwd(UNUSED char *line, env_t **list, int id, UNUSED char **env)
{
    my_putstr(find_env("PWD", *list));
    my_putchar('\n');
    p_ntty(HEADER, *list);
}
