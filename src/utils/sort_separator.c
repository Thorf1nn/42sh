/*
** EPITECH PROJECT, 2021
** B-PSU-210-MPL-2-1-minishell2-enzo.daumalle
** File description:
** sort_separator.c
*/

#include "my_sh.h"

char *sort_seps(char *str, char **seps)
{
    int i = 0;
    int j = 0;
    char *str_sorted = malloc(sizeof(char) * (my_strlen(str) + 1));

    while (ch_isequal(*str, *seps) && *str)
        str += 1;
    while (str[i]) {
        while (i > 1 && ch_isequal(str[i], *seps))
            i++;
        if (i > 1 && ch_isequal(str[i - 1], *seps))
            str_sorted[j++] = *seps[0];
        str_sorted[j++] = str[i];
        if (str[i])
            i++;
    }
    if (str[i])
        return str;
    str_sorted[j] = '\0';
    return str_sorted;
}
