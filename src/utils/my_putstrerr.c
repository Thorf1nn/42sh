/*
** EPITECH PROJECT, 2022
** B-PSU-101-MPL-1-1-minishell1-enzo.daumalle
** File description:
** my_putstrerr.c
*/

#include "my_sh.h"

void my_putstrerr(char const *str)
{
    int i = 0;

    write(2, &str[i++], my_strlen(str));
}
