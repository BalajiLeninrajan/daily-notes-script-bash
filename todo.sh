#!/bin/bash

# Instructions:
# - Files are named YY-MM-DD-todo.md
# - First line is "# MMM DD TODO" (e.g. "# Feb 03 TODO")
# - Sections are marked with ## (e.g. "## Work")
# - Tasks are marked with [ ] or [x] (e.g. "- [ ] task" or "- [x] completed task") 
# - Subtasks are indented with 2 spaces (e.g. "  - [ ] subtask")


TODO_DIR="."

DATE=$(date "+%b %d")
filename="$TODO_DIR/$(date "+%y-%m-%d")-todo.md"
yesterday_filename="$TODO_DIR/$(date -v -1d "+%y-%m-%d")-todo.md"

generate_commit_message() {
    local diff=$(git diff --cached)
    
    local completed=$(echo "$diff" | grep '^\+.*\[x\]' | sed 's/^[+\-]*//' | tr -d '[]x' | tr '\n' ',' | sed 's/,$//')
    local added=$(echo "$diff" | grep '^\+.*\[ \]' | sed 's/^[+\-]*//' | tr -d '[]' | tr '\n' ',' | sed 's/,$//')
    
    local message="$DATE:"
    
    if [ ! -z "$completed" ]; then
        message="$message Completed: $completed."
    fi
    
    if [ ! -z "$added" ]; then
        message="$message Added: $added."
    fi
    
    if [ "$message" == "$DATE:" ]; then
        message="$DATE: Updated todo lists"
    fi

    echo "$message"
}

main() {
    if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        echo "Error: Not a git repository"
        exit 1
    fi

    git pull

    if [ ! -f "$filename" ]; then
        cp "$yesterday_filename" "$filename"

        sed -i '' "1s/.*$/# $DATE TODO/" "$filename"

        git add "$filename"
        git commit -m "$DATE: Created todo file"
        git push

        exit 0
    fi

    git add "$TODO_DIR"/*.md

    if ! git diff --cached --quiet; then
        COMMIT_MSG=$(generate_commit_message)
        
        git commit -m "$COMMIT_MSG"
        git push
        
        echo "Changes committed and pushed: $COMMIT_MSG"
    else
        echo "No changes to commit"
    fi
}

main 