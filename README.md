# Daily notes
Simple script to create and manage notes.

## Usage
- Run the script at the start of the day to create a new markdown file
- Run whenever major changes are made to a day
```
./todo.sh
```

## To Start
The script can't create the first note for you so this must be done manually
- name the note DD-MM-todo.md
	- where DD is the current day
	- where MM is the current month

Then follow this template to fill out the first note
```
# Mmm DD TODO

## Heading

- [ ] Task
	- [ ] Sub Task
- [x] Completed Task

## Heading 2

- [ ] Task
- [ ] Task

```
