/*
** EPITECH PROJECT, 2021
** B-PSU-210-MPL-2-1-42sh-enzo.daumalle
** File description:
** create_allias.c
*/

#include "my_sh.h"

void print_aliases(env_t *alias)
{
    env_t *tmp = alias;

    while(tmp != NULL) {
        if (tmp->next == NULL){
            my_printf("key : %s\n", tmp->key);
            my_printf("value : %s\n", tmp->value);

        } else {
            my_printf("key : %s\n", tmp->key);
            my_printf("value : %s\n", tmp->value);
        }
        tmp = tmp->next;
    }
}

void exec_alias(char *line, UNUSED env_t **list, int id, UNUSED char **env)
{
    int len_cmd = 0;
    char **cmd = strsplit(line, " \t", false);

    for (len_cmd = 0; cmd[len_cmd]; len_cmd += 1);
    if (len_cmd == 1) {
        print_aliases(*list);
        return;
    }
    if (len_cmd > 1 && len_cmd < 3) {
        my_printf("Missing arg for alias.\n");
        return;
    }
    if (len_cmd >= 3)
        add_node_at_back(cmd[1], cmd[2], ALIAS, list);
    p_ntty(HEADER, *list);
}
