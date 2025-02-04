#!/bin/bash

# Instructions:
# - Files are named YY-MM-DD-todo.md
# - First line is "# MMM DD TODO" (e.g. "# Feb 03 TODO")
# - Sections are marked with ## (e.g. "## Work")
# - Tasks are marked with [ ] or [x] (e.g. "- [ ] task" or "- [x] completed task") 
# - Subtasks are indented with 2 spaces (e.g. "  - [ ] subtask")


TODO_DIR="/Users/balaji/Documents/notes"

DATE=$(date "+%b %d")
filename="$TODO_DIR/$(date "+%y-%m-%d")-todo.md"
yesterday_filename="$TODO_DIR/$(date -v -1d "+%y-%m-%d")-todo.md"

if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "Error: Not a git repository"
    exit 1
fi

if [ ! -f "$filename" ]; then
    cp "$yesterday_filename" "$filename"

    sed -i '' "1s/.*$/# $DATE TODO/" "$filename"

    git add "$filename"
    git commit -m "$DATE: Created todo file"

    exit 0
fi

git add "$TODO_DIR"/*.md

if ! git diff --cached --quiet; then
    git commit -m "$DATE: Updated todo lists"
    echo "Changes committed and pushed"
else
    echo "No changes to commit"
fi
