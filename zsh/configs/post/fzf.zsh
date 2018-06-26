export FZF_DEFAULT_OPTS="--color dark,hl:33,hl+:37,fg+:235,bg+:136,fg+:254 --color info:254,prompt:37,spinner:108,pointer:235,marker:235"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

fo() {
    local out file key
    IFS=$'\n' out=($(fzf-tmux --query="$1" --exit-0 --expect=ctrl-o,ctrl-e))
    key=$(head -1 <<< "$out")
    file=$(head -2 <<< "$out" | tail -1)
    if [ -n "$file" ]; then
        [ "$key" = ctrl-o ] && open "$file" || emacsclient -t "$file"
    fi
}

fg() {
    local file

    file="$(ag --nobreak --noheading $@ | fzf -0 -1 | awk -F: '{print $1 " +" $2}')"

    if [[ -n $file ]]
    then
        emacsclient -t $file
    fi
}

# cf - fuzzy cd from anywhere
# ex: cf word1 word2 ... (even part of a file name)
# zsh autoload function
cf() {
    local file

    file="$(locate -Ai -0 $@ | grep -z -vE '~$' | fzf --read0 -0 -1)"

    if [[ -n $file ]]
    then
        if [[ -d $file ]]
        then
            cd -- $file
        else
            cd -- ${file:h}
        fi
    fi
}

fbr() {
    local branches branch
    branches=$(git branch --all | grep -v HEAD) &&
        branch=$(echo "$branches" |
                     fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
        git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

lastpass() {
    local passwords
    passwords=$(lpass ls | fzf | awk '{print $(NF)}' | sed 's/\]//g')
    lpass show -c --password $passwords
}
