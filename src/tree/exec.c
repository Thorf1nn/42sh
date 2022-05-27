/*
** EPITECH PROJECT, 2021
** B-PSU-210-MPL-2-1-minishell2-enzo.daumalle
** File description:
** exec.c
*/

#include "my_sh.h"

/*----------------------------------------------------------------
Pipe -> int [2]
FD_IN = STDIN pour ta premiere commande
FD_OUT = STDOUT pour la derniere commande

et FD_OUT = pipe[1]
sinon FD_IN = pipe[0]

ls | cat -e

ls = STDIN // pipe[1]

cat -e = pipe[0] / STDOUT



ls | grep lib | cat -e

ls = STDIN // pipe[1]
grep lib = pipe[0] // new_pipe[1]
cat -e = new_pipe[0] / STDOUT
*/

void exec_pipe(builtin_t *builtin, tree_t *tree, env_t *list, char **env)
{
    pid_t pid;
    int fd[2];

    pid = fork();
    if (pid == -1)
        return;
    if (!pid) {
        if (pipe(fd) == -1) {
            perror("pipe");
            exit(84);
        }
        tree->left->fd[IN] = fd[IN];
        tree->right->fd[OUT] = fd[OUT];
        close(tree->left->fd[IN]);
        dup2(tree->right->fd[OUT], STDOUT_FILENO);
        exec_tree(builtin, list, env, tree->left);
    } else {
        close(tree->right->fd[OUT]);
        dup2(tree->left->fd[IN], STDIN_FILENO);
        exec_tree(builtin, list, env, tree->right);
    }
    closefd(fd);
}

void exec_tree(builtin_t *builtin, env_t *list, char **env, tree_t *tree)
{
    if (!tree)
        return;
    if (str_isequal(tree->sep, "|", true))
        return exec_pipe(builtin, tree, list, env);
    if (str_isequal(tree->sep, "*", true) || str_isequal(tree->sep, "?", true)
    || str_isequal(tree->sep, "]", true) || str_isequal(tree->sep, "[", true))
        return my_globbing(tree->cmd, list);
    if (tree->sep)
        redirection(tree);
    if (!tree->sep && tree->cmd) {
        tree->cmd = get_alias(list, tree->cmd);
        if (!(builtin = get_builtin(tree->cmd)))
            return exec_binary(&list, env, *tree);
        (*(builtin->fptr))(tree->cmd, &list, env);
        return;
    }
    exec_tree(builtin, list, env, tree->left);
    if (tree->sep[0] != '<' && tree->sep[0] != '>')
        exec_tree(builtin, list, env, tree->right);
}
