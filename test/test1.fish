function go
    cd ~/dev/fishdots_problem/
    source init/rc1.d/01-functions.fish
    source test/funit.fish
    source test/test1.fish

    __fixture "__setup" "__teardown" \
        "can_append_to_named_section1" \
        "new_prob_file_contains_title" \
        "new_prob_file_contains_scaffolding" \
        "switching_problem_switches_current_problem_file" \
        "adding_fact_inserts_at_end_of_KNOWN_section"

end

function __setup
    set -x FDP_TEST_DEV_DIR "$HOME/dev/fishdots_problem"
    source $FDP_TEST_DEV_DIR/init/rc0.d/01-env.fish
    source $FDP_TEST_DEV_DIR/init/rc1.d/01-functions.fish

    if test -d $FDP_TEST_DEV_DIR/scratch
        mkdir -p $FDP_TEST_DEV_DIR/scratch
    end
    set -x FD_PROB_HOME $FDP_TEST_DEV_DIR/scratch
    __drop_all_probs
end

function __teardown
end

function __drop_all_probs
    rm -rf $FD_PROB_HOME
    set -U FD_PROB_CURRENT "unset"
end

function can_append_to_named_section1 -d "try to insert a string in the correct part of the current problem"
    assert (test $FD_PROB_CURRENT = 'unset') "current problem should be unset. Was $FD_PROB_CURRENT"
    problem_start_new_problem_file "title" "some summary"
    assert (test $FD_PROB_CURRENT != 'unset') "current problem should not be set. Was $FD_PROB_CURRENT"
    assert (test -f $FD_PROB_CURRENT) "should create the new problem file"
end

function new_prob_file_contains_title
    # arrange
    set -l title sghsjdjdhgfjhsjs
    set -l summary jfhjdhgfjdghfgjdfd

    # act
    problem_start_new_problem_file $title $summary
    
    # assert
    assert (test -f $FD_PROB_CURRENT) "current prob should exist as a file"
    assert (grep $title $FD_PROB_CURRENT >/dev/null) "should be able to find the title in the file"
    assert (grep $summary $FD_PROB_CURRENT >/dev/null) "should be able to find the title in the file"
end

function new_prob_file_contains_scaffolding
    # arrange
    set -l title sghsjdjdhgfjhsjs
    set -l summary jfhjdhgfjdghfgjdfd

    # act
    problem_start_new_problem_file $title $summary
    
    # assert
    assert (grep "# PROBLEM" $FD_PROB_CURRENT >/dev/null) "must contain '# PROBLEM'"
    assert (grep "# KNOWN" $FD_PROB_CURRENT >/dev/null) "must contain '# KNOWN'"
    assert (grep "# IDEAS" $FD_PROB_CURRENT >/dev/null) "must contain '# IDEAS'"
    assert (grep "# QUESTIONS" $FD_PROB_CURRENT >/dev/null) "must contain '# QUESTIONS'"
    assert (grep "# TESTS" $FD_PROB_CURRENT >/dev/null) "must contain '# TESTS'"
end

function switching_problem_switches_current_problem_file
    # arrange
    set -l title title1
    set -l summary summary1

    # act
    problem_start_new_problem_file $title $summary
    set -l init_prob_path $FD_PROB_CURRENT
    
    # assert
    assert (test -f $FD_PROB_CURRENT) "current prob should exist as a file"
    
    set -l title title2
    set -l summary summary2
    problem_start_new_problem_file $title $summary
    set -l new_prob_path $FD_PROB_CURRENT
    assert (test -f $FD_PROB_CURRENT) "current prob should exist as a file"

    assert_neq $init_prob_path $new_prob_path
end

function adding_fact_inserts_at_end_of_KNOWN_section
    set -l title title1
    set -l summary summary1
    problem_start_new_problem_file $title $summary
    set -l init_prob_path $FD_PROB_CURRENT
    # now overwrite whatever got written with something predictable
    echo -e "# PROBLEM: problem\n\n- summary\n\n# KNOWN\n\n- fact 1\n- fact 2\n- fact 3\n\n# QUESTIONS\n\n# IDEAS\n\n# TESTS\n\n# TASKS\n\n" > $FD_PROB_CURRENT
    set -l fact kjashhjahkdfhakdhfgasjdhgakj
    fact $fact

end

function read_file -d "read each line of a file into a list" -a file_name
    cat $file_name | read -zx content
end

function split_lines
    set -x content_lines (string split \n $argv[1])    
end

function two_lines_are_adjacent_in_file -a first_line second_line
    set -l found_first_line (false)
    read_file $FD_PROB_CURRENT
    set -l idx1 (first_index_of "$first_line" $contents)
    set -l idx2 (first_index_of "$second_line" $contents)
    assert_eq (math $idx1 + 1) $idx2
end

function first_index_of
    # after reading the file, the raw content will be in $content
    set -l content $argv[2]
    echo "content: $content"
    split_lines $content
    set -l result -1
    set -l cnt 1
    set -l lim (count $content_lines)
    echo "lim: $lim"
    set -l target $argv[1]
    echo "target: $target"
    while test $cnt -le $lim
        set -l cur $list[$cnt]
        echo "cur: $cur"
        if test "$target" = "$cur"
            echo "match found"
            set -l result $cnt
            break
        end
        set -g cnt (math $cnt + 1)
        echo "cnt': $cnt"
    end
    echo $result
end