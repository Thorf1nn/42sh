/*
** EPITECH PROJECT, 2021
** B-PSU-210-MPL-2-1-42sh-enzo.daumalle
** File description:
** history.c
*/

#include "my_sh.h"

int getchh(void)
{
    int ch;
    struct termios oldtc;
    struct termios newtc;

    tcgetattr(STDIN_FILENO, &oldtc);
    newtc = oldtc;
    newtc.c_lflag &= ~(ICANON | ECHO);
    tcsetattr(STDIN_FILENO, TCSANOW, &newtc);
    ch = getchar();
    tcsetattr(STDIN_FILENO, TCSANOW, &oldtc);
    return ch;
}

int print_history(void)
{
    int i = getchh();
    int j = 0;
    int k = 0;

    while (1) {
        if (i == 27) {
            j = getchh();
            k = getchh();
        }
        if (i == 27 && j == 91) {
            switch (k) {
                case 65: printf("UP arrow\n"); break;
                case 66: printf("DOWN arrow\n"); break;
                case EOF: return 0; break;
                default: break;
            }
        }
    }
    return 0;
}
