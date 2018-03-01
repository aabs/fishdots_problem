function __create_problem -a title summary
    set -U FD_PROB_CURRENT (problem_create_path $title)
    mkdir -p $FD_PROB_CURRENT
    echo -e "# PROBLEM: $title\n\n- $summary" > $FD_PROB_CURRENT/problem.md
    echo -e "# KNOWN\n\n" > $FD_PROB_CURRENT/known.md
    echo -e "# QUESTIONS\n\n" > $FD_PROB_CURRENT/questions.md
    echo -e "# TESTS\n\n" > $FD_PROB_CURRENT/tests.md
    echo -e "# IDEAS\n\n" > $FD_PROB_CURRENT/ideas.md
    echo -e "# TASKS\n\n" > $FD_PROB_CURRENT/tasks.md
end

function problem_create_path -d "USAGE: problem_create_path 'blah' => ~/.problems/2018-02-21.mojo.md"
    set -l title_slug (string sub -l 32 (string replace " " "_" $argv[1]))
    set -l d (date --iso-8601)
    echo "$FD_PROB_HOME/$d-$title_slug"
end

function problem -a title summary
    __create_problem $title $summary
end

function known -a the_fact
    echo -e "- $the_fact" >> $FD_PROB_CURRENT/known.md
end

function question -a the_question
    echo -e "- $the_question" >> $FD_PROB_CURRENT/questions.md
end

function newtest -a the_test
    echo -e "- $the_test" >> $FD_PROB_CURRENT/tests.md
end

function idea -a the_idea
    echo -e "- $the_idea" >> $FD_PROB_CURRENT/ideas.md
end

function new_task -a the_task
    echo -e "- $the_task" >> $FD_PROB_CURRENT/tasks.md
end

function summarise
    cat $FD_PROB_CURRENT/problem.md
    echo ""
    cat $FD_PROB_CURRENT/known.md
    echo ""
    cat $FD_PROB_CURRENT/questions.md
    echo ""
    cat $FD_PROB_CURRENT/tests.md
    echo ""
    cat $FD_PROB_CURRENT/ideas.md
    echo ""
    cat $FD_PROB_CURRENT/tasks.md
end

function consolidate
    set -l target "$FD_PROB_HOME"/(basename $FD_PROB_CURRENT).md
    summarise > $target
end
