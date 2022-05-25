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

static void redirection(tree_t *tree)
{
    char *path = my_strdup(tree->cmd + find_word(tree->cmd, tree->sep));

    path += my_strlen(tree->sep);
    for (; *path && *path == ' ' && *path != '\t'; path += 1);
    if (str_isequal(tree->sep, "<", true))
        tree->left->fd[IN] = open(path, O_WRONLY | O_CREAT | O_TRUNC, 0644);
    if (str_isequal(tree->sep, ">", true))
        tree->left->fd[OUT] = open(path, O_WRONLY | O_CREAT | O_TRUNC, 0644);
    if (str_isequal(tree->sep, "<<", true))
        tree->left->fd[IN] = open(path, O_WRONLY | O_CREAT | O_TRUNC, 0644);
    if (str_isequal(tree->sep, ">>", true))
        tree->left->fd[OUT] = open(path, O_WRONLY | O_CREAT | O_APPEND, 0644);
    if (tree->left->fd[IN] == -1 || tree->left->fd[OUT] == -1)
        my_putstr("Error: cannot open file\n");
}

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
}

void exec_tree(builtin_t *builtin, env_t *list, char **env, tree_t *tree)
{
    if (!tree)
        return;
    if (str_isequal(tree->sep, "|", true))
        return exec_pipe(builtin, tree, list, env);
    if (tree->sep)
        redirection(tree);
    if (!tree->sep && tree->cmd) {
        if (!(builtin = get_builtin(tree->cmd)))
            return exec_binary(&list, env, *tree);
        (*(builtin->fptr))(tree->cmd, &list, env);
        return;
    }
    exec_tree(builtin, list, env, tree->left);
    if (tree->sep[0] != '<' && tree->sep[0] != '>')
        exec_tree(builtin, list, env, tree->right);
}
