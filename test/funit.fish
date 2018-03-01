function __fixture -d "run all the unit tests"
    
    set -l fn_setup $argv[1]
    set -l fn_teardown $argv[2]
    set -l test_cases $argv[-1..3]
    set -l cases_to_run (count $test_cases)
    ok "FUnit running $cases_to_run cases"
    set scount 0
    set fcount 0
    for t in $test_cases
        eval $fn_setup
        if eval $t ^ /dev/null
            log_test_run $t "PASS"
            set scount (math $scount + 1)
        else
            log_test_run $t "FAIL"
            set fcount (math $fcount + 1)
        end
        eval $fn_teardown
    end
    ok "FUnit outcome: $scount successes / $fcount failures"
end

function log_test_run
    set_color yellow
    printf "%s" "=> "
    set_color normal
    printf "%s" (string replace -a "_" " " $argv[1])
    if test $argv[2] = "PASS"
        set_color green
    else
        set_color red
    end
    printf " %s\n" $argv[2]
    set_color normal
end

function assert_neq -d "check if argv[1] is not equal to argv[2]" -a left right
    assert (test $left != $right) "$left is not equal to $right"
end

function assert_eq -d "check if argv[1] is equal to argv[2]" -a left right
    assert (test $left = $right) "$left is not equal to $right"
end

function assert -d "check if argv[1] is true and wail if not" 
    if test $status -eq 0
        true
    else
        echo "ASSERTION FAILURE: " $argv[1]
        false
    end
end

function assert_fails -d "check if argv[1] is false and wail if not" -a predicate error_msg
    if test $status -ne 0
        true
    else
        echo "ASSERTION FAILURE: $error_msg"
        false
    end
end
