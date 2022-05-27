/*
** EPITECH PROJECT, 2021
** 42sh
** File description:
** glob.c
*/

#include "my_sh.h"

int globbing_error(char **cmd, env_t *list, int r)
{
    if (r != 0) {
        if (r == GLOB_NOMATCH) {
            fprintf(stderr, "%s: No match.\n", cmd[0]);
            p_ntty(HEADER, list);
            return 1;
        } else {
            fprintf(stderr, "Some kinda glob error\n");
            p_ntty(HEADER, list);
            return 1;
        }
    }
    return 0;
}

void my_globbing(char *line, env_t *list)
{
    char **found;
    char **cmd = strsplit(line, " \t", false);
    glob_t gstruct;
    int r = glob(cmd[1], GLOB_ERR , NULL, &gstruct);

    if (globbing_error(cmd, list, r) == 1)
        return;
    found = gstruct.gl_pathv;
    while (*found != NULL) {
        printf("%s\t", *found);
        found++;
    }
    printf("\n");
    p_ntty(HEADER, list);
}
