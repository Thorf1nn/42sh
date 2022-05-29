/*
** EPITECH PROJECT, 2022
** 42sh
** File description:
** redirection.c
*/

#include "my_sh.h"

static void double_redirection_input(tree_t *tree, char *path)
{
    size_t len = 0;
    char *buffer = NULL;

    if (str_isequal(tree->sep, "<<", true)) {
        printf("? ");
        while (getline(&buffer, &len, stdin) != -1) {
            if (buffer[my_strlen(buffer) - 1] == '\n')
                buffer[my_strlen(buffer) - 1] = '\0';
            if (str_isequal(buffer, path, true))
                break;
            printf("? ");
        }
    }
}

void redirection(tree_t *tree)
{
    char *path = my_strdup(tree->cmd + find_word(tree->cmd, tree->sep));

    path += my_strlen(tree->sep);
    for (; *path && *path == ' ' && *path != '\t'; path += 1);
    if (str_isequal(tree->sep, "<", true))
        tree->left->fd[IN] = open(path, O_RDONLY, 0644);
    if (str_isequal(tree->sep, ">", true))
        tree->left->fd[OUT] = open(path, O_WRONLY | O_CREAT | O_TRUNC, 0644);
    if (str_isequal(tree->sep, ">>", true))
        tree->left->fd[OUT] = open(path, O_WRONLY | O_CREAT | O_APPEND, 0644);
    double_redirection_input(tree, path);
    if (tree->left->fd[IN] == -1 || tree->left->fd[OUT] == -1)
        fprintf(stderr, "Error: cannot open file\n");
}
