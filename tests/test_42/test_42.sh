#!/bin/bash

rougefonce='\e[0;31m'
vertfonce='\e[0;32m'
bleufonce='\e[0;33m'
neutre='\e[0;m'
jaune="\x1B[33m"
bleu="\x1B[34m"
majenta="\x1B[35m"
cyan="\x1B[36m"
blanc="\x1B[37m"

nb=0

print_perc() {
    SIZE1=$(stat -c%s ${1})
    SIZE2=$(stat -c%s ${2})
    PERC=$(bc <<< "scale=2; ($SIZE2 - $SIZE1)/$SIZE1 * 100")
    echo "with $PERC % compression"
}

make_test() {
    echo -ne "${1}" | ./42sh &> ../res_42sh
    if [ -d "moula" ]
    then
        rm -rf moula
    fi
    echo -ne "${1}" | tcsh &> ../res_tcsh
    sort ../res_42sh > ../res_42sh2
    sort ../res_tcsh > ../res_tcsh2
    Test=$(diff ../res_42sh2 ../res_tcsh2)
    if [ "$Test" = "" ]
            then
                echo -ne "${vertfonce}TEST ${nb} = ${neutre}"
                echo -n "[${1}]"
                echo -ne "${vertfonce} OK${neutre}\n"
            else
                echo -ne "${rougefonce}TEST ${nb} = ${neutre}"
                echo -n "[${1}]"
                echo -ne "${rougefonce} KO${neutre}\n"
            fi
    let 'nb=nb+1'
}

echo -e "${bleufonce}BUILDING...${neutre}"
if [ -f "42sh" ]; then
    clear;
else 
    make re && clear
fi
echo -e "${bleufonce}1 - MINISHELL1${neutre}\n"

echo -e "${jaune}TEST BASIQUE\n"
make_test "cat main.c"
make_test "cat tests/tests.txt"
make_test "echo test"
make_test "ls nofile"
make_test "ls              -t"
make_test "ls"
make_test "\n"
make_test "../my_segfault"
make_test "ls"
make_test "azedc"
make_test "pwd"
make_test "ls -l"
make_test "./42sh"
make_test "chmod -x tests/ratio"
make_test " ls\t\t-l"
make_test "\t\tpwd\n \t\tcd\npwd"
make_test "  \tpwd\t \ncd\t    \n ls"
make_test "pwd\t\tcd      pwd\t\n"
make_test "ls -l"
make_test "./prog_with_divZero"
make_test "../directory"
make_test "./thbv"
make_test "\t\t            clear \,"

echo -e "${majenta}\nTEST SETENV ~ UNSETENV\n"
make_test "setenv patate"
make_test "setenv patate pat"
make_test "setenv patate\nunsetenv patate"
make_test "setenv coucou="
make_test "setenv hey_"
make_test "setenv DEBUG 1"
make_test "setenv DEBUG 2"
make_test "setenv eazeaez* àààà"
make_test "setenv ^aaaa ^^aaaa"
make_test "setenv HOME /"
make_test "setenv a b c d"
make_test "unsetenv DEBUG"
make_test "unsetenv pwd"
make_test "unsetenv PATH         \t"
make_test "unsetenv              |"
make_test "unsetenv PATH\n\t\t\t/\n"
make_test "unsetenv a b c d"

echo -e "${cyan}\nTEST CD\n"
make_test "cd ~/"
make_test "cd -"
make_test "cd -/~"
make_test "cd ppp"
make_test "cd\npwd"
make_test "cd/npwd"
make_test "cd zesdrfgthvf"
make_test "cd main.c"
make_test "cd include"
make_test "cd ../\n cd ../\n cd -\n"
make_test "cd ../       ls"
make_test "cat /etc/shadow"
make_test "cd aaa bbb ccc"
make_test "cd ~"
make_test "cd"
make_test "cd qsdqsdqsd"
make_test "cd /"
make_test "cd ../../../"
make_test "cd ../../../../../../../../../../../"
make_test "\t\t\tmkdir moula\t\t\nchmod 0 moula\t\t\t\ncd moula\t\t\t"

echo -e "${cyan}\nTEST ATYPIQUE\n"
make_test "/usr/bin/ls"
make_test "/usr/bin/svdojvnsd"
make_test "tests/ratio"
make_test "chmod +x tests/ratio"
make_test "tests/ratio"
make_test "include"
make_test "include/"
make_test "./include"
make_test "/include"
make_test "list.c/"
make_test "list.c/include"
make_test "sudo ls"
make_test "exit 4n"
make_test "exit eeee"
make_test "exit"

echo -e "\n${bleufonce}2 - MINISHELL2${neutre}"
echo -e "${cyan}\nSEPARATOR : ${majenta};\n"
make_test "ls;;;;;;echo $?;;;;ls;;;     regerge   ;;; \t\nrcho cc"
make_test ";;;;;;;;;;;;;echo salut;;;;;;;;;;;;;;;ls"
make_test ";;;;;;;echo ok; echo ok;"
make_test "/bin/ls; exit; cd -"
make_test "ls; echo ok; echo ok"
make_test "ls; echo ok"
make_test "unsetenv ls; setenv c; cd -"
make_test "ls; echo ok; echo ok; | cat -e"
make_test "exit;ls"
make_test "ls -l, ls -l; ls -la -r; echo salut;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;echo salut"

echo -e "${cyan}\nSEPARATOR : ${majenta}|\n"
make_test "ls -l | cat -e"
make_test "ls -l | cat -e | cat -e"
make_test "ls -l | cat -e | cat -e | cat -e"
make_test "echo coucou | cat -e"
make_test "touch coucou | ls"

echo -e "${cyan}\nREDIRECTIONS\n"
make_test "ls -l > file.txt\n cat file.txt"
make_test "touch file.txt\nls -l > file.txt\ncat file.txt"
make_test "rm file.txt\ntouch file.txt\nls -l > file.txt\necho \"coucou les gens\" >> file.txt\ncat file.txt"
make_test "ls > > mdr"
make_test "echo \"salut\" < "
make_test "ls > tester"
make_test "ls -l > tester\ncat tester"
make_test "ls < > ls"
make_test "echo salut le gens > test.txt\n echo ok >> test.txt\ncat test.txt"
make_test "./42sh > failure.txt"
make_test "ls <<"
make_test "cat << >"
make_test "cat <<<<<<<<<<<<<<<"
make_test "echo coucuo >                                "

echo -e "\n${bleufonce}FINAL - 42SH${neutre}"
echo -e "${bleu}\nPATH LANDING\n"
make_test "/usr/bin/ls"
make_test "bin/ls"
make_test "/usr/bin/ls -l"
make_test "/bin/ls -l"
make_test "/usr/bin/cd"
make_test "cd /usr/bin"
make_test "cd /usr/bin/ls"
make_test "cd /usr/bin/ls -l"

echo -e "${bleu}\nSETENV ~ UNSETENV${neutre}\n"
make_test "unsetenv env_foo"
make_test "setenv env_foo"
make_test "setenv env_foo env_bar"
make_test "setenv env_foo env_b"
make_test "unsetenv env_*"

echo -e "${bleu}\nLine formatting (space and tabs)${neutre}\n"
make_test "ls                                                                             -l"
make_test "echo coucou                                                                     | c a t -e "
make_test " "
make_test "\t"
make_test "\t\t\t\þ"
make_test "     &           "
make_test "\t\t $ "
make_test "unsetenv                                                                                                                 ls                                                                                                                                         \ mdr"

echo -e "${majenta}Error Handling\n"
echo "int main(void){char *str = \"coucou les gen\"; str[0] = 'a'; return 0;}" > test_with_segfault.c; gcc -o testeeeeeeeeeeeeeeeeer test_with_segfault.c
make_test "./testeeeeeeeeeeeeeeeeer"; echo -e "${jaune}binary segfault"
echo "int main(void){return 1/0;}" > test_with_segfault.c; gcc -w -o testeeeeeeeeeeeeeeeeer test_with_segfault.c
make_test "./testeeeeeeeeeeeeeeeeer"; echo -e "${jaune}division by zero"
make_test "./mac_bin"; echo -e "${jaune}binary build with mac"
mkdir TESTS_DIRSSS
make_test "./TESTS_DIRSSS"; echo -e "${jaune}exec directory\n"

echo -e "${bleu}Simple pipe\n"
make_test "ls -l | cat -e"
make_test "ls -l | cat -e | cat -e"
make_test "ls -l | cat -e | cat -e | cat -e"
make_test "echo coucou | cat -e"

echo -e "\n${bleu}Pipe with redirection\n"
make_test "ls -l | cat -e > file.txt\n cat file.txt"
make_test "rm file.txt\ntouch file.txt\nls -l | cat -e > file.txt\ncat file.txt"
make_test "rm file.txt\ntouch file.txt\nls -l | cat -e > file.txt\necho \"coucou les gens\" >> file.txt\ncat file.txt"

echo -e "\n${bleu}Advanced pipe\n"
make_test "ls -l | cat -e | cat -e | cat -e"
echo "ls | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e |cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e |cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e |cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e |cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e |cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e |cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e |cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e |cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e |cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e |cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e |cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e |cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e |cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e |cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e |cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e |cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e |cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e |cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e |cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e |cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e |cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e |cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e |cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e |cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e |cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e |cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e | cat -e" > big_iniput_test
make_test "`cat big_iniput_test`"

echo -e "\n${bleu}Advanced manipulations\n"
make_test "ls -l | sort -r | head -n 3; ls -l | sort -r | tail -n 3 > output; diff -s output expected_output"
make_test "ls -la -lr -r -a | cat -e > output; diff -s output; rm output; ls < /dev/null > output; diff -s output"
make_test "ls -la | cat -e | sort -r | clear > testttttt; cat -e testttttt; ls < /dev/null >> output; cat output"

echo -e "\n${majenta}&& and || tests"
make_test "ls nofile && echo ok"
echo "int main(void){return 0;" > testerrrrrr.c
make_test "gcc testerrrrrr.c && ls"
make_test "echo coucou || ls && echo coucou"

echo -e "\n${majenta}Globbing\n"
make_test "ls *"
make_test "ls *.*"
mkdir CHENAPANT CHENEE CHENAAA
make_test "ls CHEN*"

echo -e "\n${bleu}Var Interpreter\n"
make_test "set a=1; echo $a"
make_test "set a=1; set b=$a; echo $a $b"
make_test "set a = ls; $a"
make_test "set a = ls; set b = $a; $b"
make_test "set a = ls; set b = $a ls; $b"
make_test "set a = \"ls -la ; unsetenv PATH\" ; $a ; ls"

echo -e "\n${bleu}Inhibitor\n"
make_test "ls \ -la"
make_test "ls \ -la | cat -e"
make_test "echo \ ls"

echo -e "\n${bleu}Magic Quote\n"
make_test "echo \`ls -la\`"
make_test "echo \"\`ls -la\`\""
make_test "echo \"\`ls -la\`\" | cat -e"
make_test "`echo ls`"

echo -e "\n${bleu}Alias\n"
make_test "alias ls ls -la' ; ls"
make_test "alias ls ls -la' ; ls | cat -e"
make_test "alias clear echo coucou les gens; clear"
make_test "alias clear echo coucou les gens; clear | cat -e"

echo -e "\n${bleu}Scripting\n"
echo "for file in \`ls -1\`; do" > testerrrrrrrrr.sh; echo "echo \"\$file helooo\"" >> testerrrrrrrrr.sh; echo "done" >> testerrrrrrrrr.sh
make_test "./testerrrrrrrrr.sh"
chmod a+x testerrrrrrrrr.sh
make_test "./testerrrrrrrrr.sh"

echo -e "\n${bleu}Which\n"
make_test "which ls"
make_test "which ls | cat -e"
make_test "which bash"
make_test "which clear"
make_test "which for"

echo -e "\n${bleu}Where${neutre}\n"
make_test "where ls"
make_test "where ls | cat -e"
make_test "where bash"
make_test "where clear"
make_test "where for"

rm -rf TESTS_DIRSSS CHENAPANT CHENEE CHENAAA
rm test_with_segfault.c testeeeeeeeeeeeeeeeeer testerrrrrrrrr.sh big_iniput_test output file.txt coucou ls test.txt failure.txt tester testttttt testerrrrrr.c