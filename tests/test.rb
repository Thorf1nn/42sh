#!/usr/bin/env ruby

require_relative "test_makefile"

T_QUIET = '> temp.log 2> temp.log'

def test_42sh print_msg
    if print_msg
        print_in_color("|-> TESTS:\n", "yellow")
    end
    result = test_makefile(print_msg)
    if print_msg
        print_in_color("| FINISHED !\n", "yellow")
    end
    system "make fclean #{T_QUIET}"
    if File.exist?("temp.log")
        system "rm -rf temp.log"
    end
    return result
end

test_42sh(true)
