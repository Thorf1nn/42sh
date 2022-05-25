#!/usr/bin/env ruby

require_relative "print_in_color"

def print_test_result value

    if value == true
        print_in_color("success !\n", "green")
    elsif value == false
        print_in_color("failed !\n", "red")
    else
        print_in_color("crash !\n", "red")
    end

end
