mv start.md $(date "+%y-%m-%d")-todo.md

sed -i '' "1s/.*$/# $(date "+%b %d") TODO/" $(date "+%y-%m-%d")-todo.md

git init
git add $(date "+%y-%m-%d")-todo.md
git commit -m "$(date "+%b %d"): Created todo file"
