set -U FD_PROB_HOME "$HOME/.problems"

if not test -d $FD_PROB_HOME 
    mkdir -p $FD_PROB_HOME
end

if not set -q FD_PROB_CURRENT
    set -U FD_PROB_CURRENT "unset"
end


