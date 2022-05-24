/*
** EPITECH PROJECT, 2021
** 42sh
** File description:
** get_env.c
*/

#include "my_sh.h"

// exemple: set value of 'PWD': get_env("PWD", env)->data = ...
env_t *get_env(env_t *env, char *key)
{
    for (env_t *ls = env; ls; ls = ls->next)
        if (!strcmp(key, ls->key))
            return ls;
    fprintf(stderr, "ERROR, get_env: key '%s' not found !\n", key);
    exit(84);
}
