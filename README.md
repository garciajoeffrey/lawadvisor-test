# lawadvisor-test

Setup a project with your programming language of choice and create an API for managing a TODO list with the following specification:

# Register

The user should be able to register with a username and password

Usernames must be unique across all users

# Login

The user should be able to log in with the credentials they provided in the register endpoint

Should return an access token that can be used for the other endpoints

# TODO List

The user should only be able to access their own tasks

The user should be able to list all tasks in the TODO list

The user should be able to add a task to the TODO list

The user should be able to update the details of a task in their TODO list

The user should be able to remove a task from the TODO list

The user should be able to reorder the tasks in the TODO list

A task in the TODO list should be able to handle being moved more than 50 times

A task in the TODO list should be able to handle being moved to more than one task away from its current position

* Return proper errors with corresponding HTTP codes

Note: You can think of this as an API endpoint that will be used to handle the drag and drop feature of a TODO list application.

All endpoints should return JSON responses.
