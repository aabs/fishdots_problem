function problem
  if test 0 -eq (count $argv)
    problem_help
    return
  end
  switch $argv[1]
    case home
      cd $FD_PROB_HOME
    case create
      problem_create $argv[2] $argv[3]
    case known
      problem_known $argv[2]
    case question
      problem_question $argv[2]
    case test
      problem_test $argv[2]
    case idea
      problem_idea $argv[2]
    case task
      problem_task $argv[2]
    case summarise
      problem_summarise
    case save
      problem_save
    case sync
      problem_sync
    case consolidate
      problem_consolidate
    case '*'
      problem_help
  end
end

function problem_create -a title summary
    set -U FD_PROB_CURRENT (problem_create_path $title)
    mkdir -p $FD_PROB_CURRENT
    echo -e "# PROBLEM: $title\n\n- $summary" > $FD_PROB_CURRENT/problem.md
    echo -e "# KNOWN\n\n" > $FD_PROB_CURRENT/known.md
    echo -e "# QUESTIONS\n\n" > $FD_PROB_CURRENT/questions.md
    echo -e "# TESTS\n\n" > $FD_PROB_CURRENT/tests.md
    echo -e "# IDEAS\n\n" > $FD_PROB_CURRENT/ideas.md
    echo -e "# TASKS\n\n" > $FD_PROB_CURRENT/tasks.md
end

function problem_known -a the_fact
    echo -e "- $the_fact" >> $FD_PROB_CURRENT/known.md
end

function problem_question -a the_question
    echo -e "- $the_question" >> $FD_PROB_CURRENT/questions.md
end

function problem_test -a the_test
    echo -e "- $the_test" >> $FD_PROB_CURRENT/tests.md
end

function problem_idea -a the_idea
    echo -e "- $the_idea" >> $FD_PROB_CURRENT/ideas.md
end

function problem_task -a the_task
    echo -e "- $the_task" >> $FD_PROB_CURRENT/tasks.md
end

function problem_summarise
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

function problem_consolidate
    set -l target "$FD_PROB_HOME"/(basename $FD_PROB_CURRENT).md
    summarise > $target
end

function problem_save -d "save all new or modified notes locally"
  _enter_problem_home
  git add -A .
  git commit -m "prob updates and additions"
  _leave_problem_home
end

function problem_sync -d "save all notes to origin repo"
  problem_save
  _enter_problem_home
  git fetch --all -t
  git push origin (git branch-name)
  _leave_problem_home
end

function _enter_problem_home
  pushd .
  cd $FD_PROB_HOME  
end

function _leave_problem_home
  popd
end


function problem_help -d "display usage info"
  echo "Fishdots problems Usage"
  echo "===================="
  echo "problem <command> [options] [args]"
  echo ""

    echo "problem home"
    echo "  "
    echo""

    echo "problem create"
    echo "  "
    echo""

    echo "problem known"
    echo "  "
    echo""

    echo "problem question"
    echo "  "
    echo""

    echo "problem test"
    echo "  "
    echo""

    echo "problem idea"
    echo "  "
    echo""

    echo "problem task"
    echo "  "
    echo""

    echo "problem summarise"
    echo "  "
    echo""

    echo "problem sync"
    echo "  "
    echo""

    echo "problem sync"
    echo "  "
    echo""

    echo "problem consolidate"
    echo "  "
    echo""
end

function problem_create_path -d "USAGE: problem_create_path 'blah' => ~/.problems/2018-02-21.mojo.md"
    set -l title_slug (string sub -l 32 (string replace " " "_" $argv[1]))
    set -l d (date --iso-8601)
    echo "$FD_PROB_HOME/$d-$title_slug"
end

