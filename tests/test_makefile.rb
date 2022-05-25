#!/usr/bin/env ruby

require_relative "test_lib/print_in_color"
require_relative "test_lib/print_test_result"

TM_QUIET = '> temp.log 2> temp.log'

def test_makefile print_msg

    make = system "make #{TM_QUIET}"
    clean = system "make clean #{TM_QUIET}"
    fclean = system "make fclean #{TM_QUIET}"
    make_re = system "make re #{TM_QUIET}"

    if print_msg
        print_in_color("| Makefile 'all'      :  ", "yellow")
        print_test_result(make)
        print_in_color("| Makefile 'clean'    :  ", "yellow")
        print_test_result(clean)
        print_in_color("| Makefile 'fclean'   :  ", "yellow")
        print_test_result(fclean)
        print_in_color("| Makefile 'make_re'  :  ", "yellow")
        print_test_result(make_re)
    end

    return make && clean && fclean && make_re

end
