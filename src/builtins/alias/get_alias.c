/*
** EPITECH PROJECT, 2022
** 42sh
** File description:
** get_alias.c
*/

#include "my_sh.h"

char *get_alias(env_t *alias, char *line)
{
    char *dest = NULL;

    if (!line || !line[0])
        return line;
    while (*line && (*line == ' ' || *line == '\t'))
        line += 1;
    if (!(*line))
        return NULL;
    for (; alias; alias = alias->next) {
        if (alias->id == ALIAS && str_isequal(line, alias->key, false)) {
            line += my_strlen(alias->key);
            dest = strcat_alloc(alias->value, line);
            return dest;
        }
    }
    return line;
}
