function problem_get_statement -d "get a description of the problem, to form the title and filename"
    dialog --ok-label "Submit" \
        --backtitle "Start work on a new problem" \
        --title "Problem Statement" \
        --stdout \
        --separator "|" \
        --form "Create a new user" \
        15 50 0 \
        "Problem:" 1 1	"$title" 	1 10 30 0 \
        "Outline:" 2 1	"$outline"  2 10 35 256
end

function problem_start_new -d "closes off the old problem and starts a new one"
    set -l tmp (problem_get_statement)
    clear
    set prb_stmt (string split "|" $tmp)
    problem_start_new_problem_file $prb_stmt[1] $prb_stmt[2]
end

function problem_create_path -d "USAGE: problem_create_path 'blah' => ~/.problems/2018-02-21.mojo.md"
    set -l title_slug (string sub -l 32 (string replace " " "_" $argv[1]))
    set -l d (date --iso-8601)
    echo "$FD_PROB_HOME/$d-$title_slug.md"
end

function problem_start_new_problem_file -d "create a new problem file given a title and summary"
# USAGE:    problem_start_new_problem_file "mojo" "I can't find my mojo baby!"
    set -l title $argv[1]
    set -l summary $argv[2]
    set -U FD_PROB_CURRENT (problem_create_path $title)
    mkdir -p (dirname $FD_PROB_CURRENT)
    touch $FD_PROB_CURRENT
    echo -e "# PROBLEM: $argv[1]\n\n- $summary\n\n# KNOWN\n\n# QUESTIONS\n\n# IDEAS\n\n# TESTS\n\n# TASKS\n\n" > $FD_PROB_CURRENT
end

function problem_edit_current -d "open editor to edit current problem"
    if not test -f $FD_PROB_CURRENT
        problem_start_new    
    end
    set -l cmd $EDITOR $FD_PROB_CURRENT
    eval $cmd
end