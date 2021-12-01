# lawadvisor-test

Setup a project with your programming language of choice and create an API for managing a TODO list with the following specification:

SETUP
1) Install phoenix elixir(https://hexdocs.pm/phoenix/installation.html)
2) Git clone this repository
3) Move to the cloned repository folder
3) RUN mix deps.get
4) RUN mix ecto.create
4) RUN mix ecto.migrate
5) RUN mix phx.server

# Register

The user should be able to register with a username and password
Usernames must be unique across all users

URL: POST http://localhost:4000/api/register
<br />Example parameters:
```
{
  "username": "garciajoeffrey",
  "password": "P@ssw0rd"
}
```

SUCCESS:
```
{
  "message": "User registered successfully"
}
```

FAIL:
1) Username already exists
```
{
  "username": "Username already exists"
}
```

# Login

The user should be able to log in with the credentials they provided in the register endpoint

Should return an access token that can be used for the other endpoints

URL: POST http://localhost:4000/api/login
<br />Example parameters:
```
{
    "username": "garciajoeffrey",
    "password": "P@ssw0rd"
}
```

SUCCESS:
```
{
    "access_token": "SFMyNTY.g2gDbQAAACRmODA2ZDVjZS0wMGM4LTQ0ZTItYTBkZC0yOWZkOGZlYTViYzhuBgAmSsd0fQFiAAFRgA.ESabgHbtHUmOCFXmDqchH8M8cwg5GS1mCrbM93cQwSo"
}
```

FAIL:
1) Username does not exist
```
{
    "username": "Username does not exist"
}
```

2) Invalid password
```
{
    "password": "Invalid password. Please try again."
}
```

3) Missing parameters
```
{
    "password": "Enter password",
    "username": "Enter username"
}
```

# TODO List

NOTE: All APIs below will return 401 Unauthorize is no token or token is invalid.

The user should only be able to access their own tasks

The user should be able to list all tasks in the TODO list

URL: GET http://localhost:4000/api/tasks/view

SUCCESS
```
{
    "tasks": [
        {
            "details": "Example task 1",
            "task_no": 1
        }
    ]
}
```
FAIL
1) Valid user but no tasks
```
{
    "message": "No tasks to be viewed for this user"
}
```

The user should be able to add a task to the TODO list
<br/>URL: http://localhost:4000/api/tasks/add

Example parameters:
1) If task number not specified, the newly added task will be at the last todo"
```
{
    "task_no": "",
    "details": "Example task 1"
}
```

2) If task number is specified, the newly added task will be at the specified task number and the tasks below it will be moved"
```
{
    "task_no": 1,
    "details": "Example task 1"
}
```
SUCCESS:
```
{
    "message": "Successfully added task"
}
```

FAIL:
1) Specified task number still not exist in to do list
```
{
    "task_no": "Task number does not exist"
}
```

2) Invalid task number
```
{
    "task_no": "Task number is invalid"
}
```

The user should be able to update the details of a task in their TODO list
<br/>URL: http://localhost:4000/api/tasks/update

Example parameters:
```
{
    "task_no": 1,
    "details": "Updated task 1"
}
```

SUCCESS
```
{
    "message": "Successfully updated task"
}
```
FAIL
1) Task number does not exist
```
{
    "task_no": "Task number does not exist"
}
```
2) Invalid task number
```
{
    "task_no": "Task number is invalid"
}
```

The user should be able to remove a task from the TODO list
<br/>URL: DELETE http://localhost:4000/api/tasks/remove/{task_no}

SUCCESS:
```
{
    "message": "Successfully removed task"
}
```
FAIL:
1) Task number does not exist
```
{
    "task_no": "Task number does not exist"
}
```
2) Task number is invalid
```
{
    "task_no": "Task number is invalid"
}
```

The user should be able to reorder the tasks in the TODO list

A task in the TODO list should be able to handle being moved more than 50 times

A task in the TODO list should be able to handle being moved to more than one task away from its current position

<br/>URL: POST http://localhost:4000/api/tasks/move

SUCCESS:
```
{
    "message": "Successfully moved task"
}
```
FAIL:
1) Task number does not exist
```
{
    "message": "Task number does not exist"
}
```
2) Task number is invalid
```
{
    "task_no": "Task number is invalid"
}
```
3) Task number and new task number is the same
```
{
    "message": "Task number and new task number should be different"
}
```
4) New task number is invalid
```
{
    "message": "New task number is invalid"
}
```

* Return proper errors with corresponding HTTP codes

Note: You can think of this as an API endpoint that will be used to handle the drag and drop feature of a TODO list application.

All endpoints should return JSON responses.

You can also check the elixir unit test for more detailed tests. Thank you.
