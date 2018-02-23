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

function _fdp_test_can_append_to_named_section1 -d "try to insert a string in the correct part of the current problem"
    assert (test $FD_PROB_CURRENT = 'unset') "current problem should be unset. Was $FD_PROB_CURRENT"
    problem_start_new_problem_file "title" "some summary"
    assert (test $FD_PROB_CURRENT != 'unset') "current problem should not be set. Was $FD_PROB_CURRENT"
    assert (test -f $FD_PROB_CURRENT) "should create the new problem file"
end

function _fdp_test_new_prob_file_contains_title
    ls > /dev/null ^ /dev/null
end

function _fdp_test_eq_fail
    assert_fails (test 'hello' = 'world') "hello should not equal world"
end

function _fdp_test_eq_pass
    assert_eq 'hello' 'hello'
end


function go
    cd ~/dev/fishdots_problem/
    source test/funit.fish
    source test/test1.fish
    set cases 

    __fixture "__setup" "__teardown" '_fdp_test_eq_fail _fdp_test_eq_pass _fdp_test_can_append_to_named_section1 _fdp_test_new_prob_file_contains_title'


end