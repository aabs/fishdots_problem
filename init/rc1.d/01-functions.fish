function problem
  if test 0 -eq (count $argv)
    problem_help
    return
  end
  switch $argv[1]
    case home
      emit problem_home
    case ls
      emit problem_ls
    case open
      emit problem_open
    case create
      emit problem_new  $argv[2] $argv[3]
    case known
      emit problem_known $argv[2]
    case question
      emit problem_question $argv[2]
    case test
      emit problem_test $argv[2]
    case idea
      emit problem_idea $argv[2]
    case task
      emit problem_task $argv[2]
      emit task_new $argv[2] # integration into fishdots_todo
    case summarise
      emit problem_summarise
    case save
      emit problem_save
    case sync
      emit problem_sync
    case consolidate
      emit problem_consolidate
    case '*'
      emit problem_help
  end
end

function _prob_ls -e problem_ls 
  find $FD_PROB_HOME/ -maxdepth 1 -mindepth 1 -type d ! -name '.git'
end

function problem_home -e problem_home
  cd $FD_PROB_HOME
end

function problem_create -e problem_new -a title summary
    set -U FD_PROB_CURRENT (problem_create_path $title)
    mkdir -p $FD_PROB_CURRENT
    echo -e "# PROBLEM: $title\n\n- $summary" > $FD_PROB_CURRENT/problem.md
    echo -e "# KNOWN\n\n" > $FD_PROB_CURRENT/known.md
    echo -e "# QUESTIONS\n\n" > $FD_PROB_CURRENT/questions.md
    echo -e "# TESTS\n\n" > $FD_PROB_CURRENT/tests.md
    echo -e "# IDEAS\n\n" > $FD_PROB_CURRENT/ideas.md
    echo -e "# TASKS\n\n" > $FD_PROB_CURRENT/tasks.md
end

function problem_open -e problem_open -d "select from existing problems"
  set matches (find $FD_PROB_HOME/ -maxdepth 1 -mindepth 1 -type d ! -name ".git")
  if test 1 -eq (count $matches) and test -d $matches
    set -U FD_PROB_CURRENT $matches[1]
    echo "chose option 1"
    return
  end
  set -g dcmd "dialog --stdout --no-tags --menu 'select the file to edit' 20 60 20 " 
  set c 1
  for option in $matches
    set l (get_file_relative_path $option)
    set -g dcmd "$dcmd $c '$l'"
    set c (math $c + 1)
  end
  set choice (eval "$dcmd")
  clear
  if test $status -eq 0
  echo "edit option $choice"
    set -U FD_PROB_CURRENT $matches[$choice]
  end
end

function problem_known  -e problem_known -a the_fact
    echo -e "- $the_fact" >> $FD_PROB_CURRENT/known.md
end

function problem_question -e problem_question -a the_question
    echo -e "- $the_question" >> $FD_PROB_CURRENT/questions.md
end

function problem_test -e problem_test -a the_test
    echo -e "- $the_test" >> $FD_PROB_CURRENT/tests.md
end

function problem_idea -e problem_idea -a the_idea
    echo -e "- $the_idea" >> $FD_PROB_CURRENT/ideas.md
end

function problem_task -e problem_task -a the_task
    echo -e "- $the_task" >> $FD_PROB_CURRENT/tasks.md
end

function problem_summarise -e problem_summarise
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

function problem_consolidate -e problem_consolidate
    set -l target "$FD_PROB_HOME"/(basename $FD_PROB_CURRENT).md
    summarise > $target
end

function problem_save -e problem_save -d "save all new or modified notes locally"
  fishdots_git_save $FD_PROB_HOME  "prob updates and additions"
end

function problem_sync -e problem_sync -d "save all notes to origin repo"
  fishdots_git_sync $FD_PROB_HOME  "prob updates and additions"
end

function _enter_problem_home
  pushd .
  cd $FD_PROB_HOME  
end

function _leave_problem_home
  popd
end


function problem_help -e problem_help -d "display usage info"
  echo "Fishdots problems Usage"
  echo "===================="
  echo "problem <command> [options] [args]"
  echo ""

    echo "problem home"
    echo "  "
    echo""

    echo "problem open"
    echo "  select a problem to work on"
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

