/*
** EPITECH PROJECT, 2022
** B-PSU-210-MPL-2-1-42sh-enzo.daumalle
** File description:
** signal_handler.c
*/

#include "my_sh.h"

void sign_handler(int sign_num)
{
    if (WIFSIGNALED(sign_num)) {
        if (WTERMSIG(sign_num) == SIGFPE)
            my_putstr("Floating exception");
        else
            my_putstr(strsignal(sign_num));
        if (WCOREDUMP(sign_num))
            my_putstr(" (core dumped)\n");
        else
            my_putchar('\n');
    }
    if (sign_num == SIGTSTP)
        my_putstr(HEADER);
    if (sign_num == SIGINT)
        my_putstr(HEADER);
}
