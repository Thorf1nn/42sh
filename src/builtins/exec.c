/*
** EPITECH PROJECT, 2021
** B-PSU-101-MPL-1-1-minishell1-enzo.daumalle
** File description:
** exec.c
*/

#include "my_sh.h"

char *get_path(env_t *list, char **cmd)
{
    int i = 0;
    char **path = strsplit(find_env("PATH", list), ":", false);
    char *acs = NULL;

    if (!path)
        return NULL;
    acs = strcat_alloc(path[i++], "/");
    acs = strcat_alloc(acs, *cmd);
    while ((access(acs, X_OK)) != 0) {
        free(acs);
        if (!path[++i])
            return NULL;
        acs = strcat_alloc(path[i], "/");
        acs = strcat_alloc(acs, *cmd);
        if (!path[i])
            return NULL;
    }
    if (access(acs, X_OK) == -1)
        fprintf(stderr, "Permission denied\n");
    return acs;
}

static bool check_command(char *line, char ***cmd, char **path, env_t **list)
{
    int i = 0;

    for (; line[i] && (line[i] == ' ' || line[i] == '\t'); i++);
    if (!line[i]) {
        p_ntty(HEADER, *list);
        return false;
    }
    *cmd = strsplit(line, " \t", false);
    *path = get_path(*list, *cmd);
    return true;
}

static bool check_jobs(char ***cmd, char **path, env_t **list, char **env)
{
    static int i = 0;
    pid_t pid;
    *path = get_path(*list, *cmd);
    printf("[%d] %d\n", i, getpid());
    pid = fork();
    if (pid == 0)
        execve(*path, *cmd, env);
    i++;
    return true;
}

void exec_binary(env_t **list, char **env, tree_t leaf)
{
    int state = 0;
    char **cmd = NULL;
    char *path = NULL;

    if (!check_command(leaf.cmd, &cmd, &path, list))
        return;
    if (leaf.cmd[my_strlen(leaf.cmd) - 1] == '&' &&
    leaf.cmd[my_strlen(leaf.cmd) - 2] != '&') {
        leaf.cmd[my_strlen(leaf.cmd) - 1] = '\0';
        cmd = strsplit(leaf.cmd, " \t", false);
        if (check_jobs(&cmd, &path, list, env))
            return;
    }
    if (!fork()) {
        dup2(leaf.fd[IN], STDIN_FILENO);
        dup2(leaf.fd[OUT], STDOUT_FILENO);
        printf("%d %d\n", leaf.fd[IN], leaf.fd[OUT]);
        state = execve(cmd[0], cmd, env);
        closefd(leaf.fd);
        if (state == -1 && path)
            state = execve(path, cmd, env);
        if (state == -1) {
            fprintf(stderr, "%s: Command not found.\n", cmd[0]);
            exit(0);
        }
    } else {
        wait(&state);
        if (WIFSIGNALED(state))
            sign_handler(state);
        p_ntty(HEADER, *list);
    }
}
