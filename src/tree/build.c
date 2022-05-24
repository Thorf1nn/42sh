/*
** EPITECH PROJECT, 2022
** B-PSU-210-MPL-2-1-minishell2-enzo.daumalle
** File description:
** build.c
*/

#include "my_sh.h"

// static int find_redirect(tree_t *tree)
// {
//     for (; *path && *path == ' ' && *path != '\t'; path += 1);
//     if (str_isequal(tree->sep, "<", true))
//         return 1;
//     if (str_isequal(tree->sep, ">", true))
//         return 2;
//     if (str_isequal(tree->sep, "<<", true))
//         return 3;
//     if (str_isequal(tree->sep, ">>", true))
//         return 4;
//     return 0;
// }

void add_node(tree_t **tree, char *line, char *sep)
{
    tree_t *newNode = malloc(sizeof(tree_t));
    int nb = find_word(line, sep);

    my_printf("%s\n", line);
    if (line[nb]) {
        newNode->sep = my_strdup(sep);
    } else
        newNode->sep = NULL;
    newNode->cmd = my_strdup(line);
    newNode->left = NULL;
    newNode->right = NULL;
    // if (newNode->sep)
    //     redirection(newNode);
    *tree = newNode;
}

void create_tree(tree_t **node, char *line, char **seps)
{
    int nb = find_word(line, *seps);

    if (!(*seps))
        return;
    if (!line[nb])
        create_tree(node, line, seps + 1);
    if (!(*node)) {
        add_node(node, line, *seps);
        (*node)->left = NULL;
        (*node)->right = NULL;
    }
    if (line[nb]) {
        create_tree(&(*node)->left,
        range_strdup(line, NULL, *seps, false), seps);
        create_tree(&(*node)->right, line + nb + 1, seps);
    }
}

tree_t *build_tree(char *line)
{
    char *seps[7] = {";", ">", "<", ">>", "<<", "|"};
    tree_t *root = NULL;
    char *sline = NULL;

    sline = sort_sep(line, seps[0]);
    create_tree(&root, sline, seps);
    return root;
}