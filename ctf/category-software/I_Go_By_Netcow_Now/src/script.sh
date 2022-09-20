shopt -s expand_aliases
alias cat="cowsay Who let the cows out? It was my evil twin!"
alias ls="cowsay The Cows are in the way of my commands!"
alias grep="cowsay Who let the cows out? It was my evil twin!"
alias awk="cowsay Who let the cows out? It was my evil twin!"
alias pwd="cowsay Who let the cows out? It was my evil twin!"
alias cd="cowsay Who let the cows out? It was my evil twin!"
alias head="cowsay Who let the cows out? It was my evil twin!"
alias tail="cowsay Who let the cows out? It was my evil twin!"
alias less="cowsay Who let the cows out? It was my evil twin!"
alias more="cowsay Who let the cows out? It was my evil twin!"
alias sed="cowsay Who let the cows out? It was my evil twin!"
alias awk="cowsay Who let the cows out? It was my evil twin!"
alias find="cowsay Who let the cows out? It was my evil twin!"

while :
do
    echo "user @ csictf: $ "
    read input
    eval $input 2>/dev/null
done
