
define_command problem "fishdots plugin for working through problems"
define_subcommand problem consolidate on_problem_consolidate "Consolidate all of the components of the current problem in a single file"
define_subcommand problem create on_problem_create "Create a new problem to solve"
define_subcommand problem home on_problem_home "switch to the home folder of the current problem"
define_subcommand problem idea on_problem_idea "Record an idea relating to the current problem"
define_subcommand problem known on_problem_known "Record a fact that is known "
define_subcommand problem ls on_problem_ls "List all of the problems"
define_subcommand_nonevented problem open problem_open "choose an existing problem to work on"
define_subcommand problem question on_problem_question "Record a question to be answered"
define_subcommand problem summarise on_problem_summarise "Summarise everything recorded for the current problem"
define_subcommand problem save on_problem_save "Save all edits locally"
define_subcommand problem sync on_problem_sync "save all edits then Sync to origin"
define_subcommand problem test on_problem_test "Record a Test to perform"
define_subcommand problem task on_problem_task "Record a Task to perform"

function prob_ls -e on_problem_ls
    find $FD_PROB_HOME/ -maxdepth 1 -mindepth 1 -type d ! -name '.git'
end

function problem_home -e on_problem_home
    cd $FD_PROB_HOME
end

function problem_create -e on_problem_create -a title summary
    set -U FD_PROB_CURRENT (problem_create_path $title)
    mkdir -p $FD_PROB_CURRENT
    echo -e "# PROBLEM: $title\n\n- $summary" >$FD_PROB_CURRENT/problem.md
    echo -e "# KNOWN\n\n" >$FD_PROB_CURRENT/known.md
    echo -e "# QUESTIONS\n\n" >$FD_PROB_CURRENT/questions.md
    echo -e "# TESTS\n\n" >$FD_PROB_CURRENT/tests.md
    echo -e "# IDEAS\n\n" >$FD_PROB_CURRENT/ideas.md
    echo -e "# TASKS\n\n" >$FD_PROB_CURRENT/tasks.md
end

function problem_open -e on_problem_open -d "select from existing problems"
    set matches (find $FD_PROB_HOME/ -maxdepth 1 -mindepth 1 -type d ! -name ".git")

    if test 1 -eq (count $matches)
        if test -d $matches
            set -U FD_PROB_CURRENT $matches[1]
            echo "chose option 1"
            return
        end
    end
    set -g dcmd "dialog --stdout --no-tags --menu 'select the file to edit' 20 60 20 "
    set c 1
    for option in $matches
        set l (basename "$option")
        set -g dcmd "$dcmd $c '$l'"
        set c (math $c + 1)
    end
    set choice (eval "$dcmd") 
    #clear
    if test $status -eq 0
        echo "edit option $choice"
        set -U FD_PROB_CURRENT $matches[$choice]
    end

    clear
    problem_summarise
end

function problem_known -e on_problem_known -a the_fact
    echo -e "- $the_fact" >>$FD_PROB_CURRENT/known.md
end

function problem_question -e on_problem_question -a the_question
    echo -e "- $the_question" >>$FD_PROB_CURRENT/questions.md
end

function problem_test -e on_problem_test -a the_test
    echo -e "- $the_test" >>$FD_PROB_CURRENT/tests.md
end

function problem_idea -e on_problem_idea -a the_idea
    echo -e "- $the_idea" >>$FD_PROB_CURRENT/ideas.md
end

function problem_task -e on_problem_task -a the_task
    echo -e "- $the_task" >>$FD_PROB_CURRENT/tasks.md
end

function problem_summarise -e on_problem_summarise
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

function problem_consolidate -e on_problem_consolidate
    set -l target "$FD_PROB_HOME"/(basename $FD_PROB_CURRENT).md
    summarise >$target
end

function problem_save -e on_problem_save -d "save all new or modified notes locally"
    fishdots_git_save $FD_PROB_HOME "prob updates and additions"
end

function problem_sync -e on_problem_sync -d "save all notes to origin repo"
    fishdots_git_sync $FD_PROB_HOME "prob updates and additions"
end

function _enter_problem_home
    pushd .
    cd $FD_PROB_HOME
end

function _leave_problem_home
    popd
end


function problem_create_path -d "USAGE: problem_create_path 'blah' => ~/.problems/2018-02-21.mojo.md"
    set -l title_slug (string sub -l 32 (string replace " " "_" $argv[1]))
    set -l d (date --iso-8601)
    echo "$FD_PROB_HOME/$d-$title_slug"
end

