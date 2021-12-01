defmodule LawadvisorWeb.TaskControllerTest do
  use LawadvisorWeb.ConnCase

  import Lawadvisor.{UserFixtures, TaskFixtures}

  @valid_user_attrs %{
    username: "joeffreygarcia",
    password: "P@ssw0rd"
  }
  @invalid_user_attrs %{
    username: "garciajoeffrey",
    password: "P@ssw0rd"
  }

  setup %{conn: conn} do
    user = create_user(@valid_user_attrs)
    tasks = create_tasks(user.user_id)
    token = generate_token(@valid_user_attrs, conn)
    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "Bearer #{token}")
      
    {:ok, conn: conn, tasks: tasks}
  end

  describe "View tasks" do
    test "with valid user with tasks", %{conn: conn, tasks: tasks} do
      conn = get(conn, Routes.task_path(conn, :view))
      assert json_response(conn, 200) == tasks
    end

    test "with valid user but no tasks" do
      conn = build_conn()
      create_user(@invalid_user_attrs)
      token = generate_token(@invalid_user_attrs, conn)
      conn =
        conn
        |> put_req_header("accept", "application/json")
        |> put_req_header("authorization", "Bearer #{token}")

      conn = get(conn, Routes.task_path(conn, :view))
      assert json_response(conn, 200) == "No tasks to be viewed for this user"
    end
  end

  describe "Add task" do
    test "with valid user adding task with empty task_no", %{conn: conn} do
      params = %{
        details: "Example Task 5"
      }

      conn = post(conn, Routes.task_path(conn, :add), params)
      assert json_response(conn, 200) == "Successfully added task"

      conn = get(conn, Routes.task_path(conn, :view))
      assert json_response(conn, 200) == [
        %{
          "details" => "Example Task 1",
          "task_no" => 1
        },
        %{
          "details" => "Example Task 2",
          "task_no" => 2
        },
        %{
          "details" => "Example Task 3",
          "task_no" => 3
        },
        %{
          "details" => "Example Task 4",
          "task_no" => 4
        },
        %{
          "details" => "Example Task 5",
          "task_no" => 5
        }
      ]
    end

    test "with valid user adding task to a specific task_no", %{conn: conn} do
      params = %{
        task_no: 1,
        details: "Example Task 5"
      }

      conn = post(conn, Routes.task_path(conn, :add), params)
      assert json_response(conn, 200) == "Successfully added task"

      conn = get(conn, Routes.task_path(conn, :view))
      assert json_response(conn, 200) == [
        %{
          "details" => "Example Task 5",
          "task_no" => 1
        },
        %{
          "details" => "Example Task 1",
          "task_no" => 2
        },
        %{
          "details" => "Example Task 2",
          "task_no" => 3
        },
        %{
          "details" => "Example Task 3",
          "task_no" => 4
        },
        %{
          "details" => "Example Task 4",
          "task_no" => 5
        }
      ]
    end

    test "with valid user adding task to an invalid task no", %{conn: conn} do
      params = %{
        task_no: 6,
        details: "Example Task 6"
      }

      conn = post(conn, Routes.task_path(conn, :add), params)
      assert json_response(conn, 400)["task_no"] == "Task number does not exist"

      params = %{
        task_no: 0,
        details: "Example Task 6"
      }

      conn = post(conn, Routes.task_path(conn, :add), params)
      assert json_response(conn, 400)["task_no"] == "Task number is invalid"

      params = %{
        task_no: "a",
        details: "Example Task 6"
      }

      conn = post(conn, Routes.task_path(conn, :add), params)
      assert json_response(conn, 400)["task_no"] == "Task number is invalid"
    end

    test "with invalid user" do
      conn = build_conn()
      conn = post(conn, Routes.task_path(conn, :add), %{})
      assert json_response(conn, 401) == "Unauthorized"
    end
  end

  describe "Remove task" do
    test "with valid user and valid task no", %{conn: conn} do
      conn = delete(conn, Routes.task_path(conn, :remove, 1))
      assert json_response(conn, 200) == "Successfully removed task"
    end

    test "with valid user and invalid task no", %{conn: conn} do
      conn = delete(conn, Routes.task_path(conn, :remove, 5))
      assert json_response(conn, 400)["task_no"] == "Task number does not exist"

      conn = delete(conn, Routes.task_path(conn, :remove, "a"))
      assert json_response(conn, 400)["task_no"] == "Task number is invalid"
    end

    test "with invalid user" do
      conn = build_conn()
      conn = delete(conn, Routes.task_path(conn, :remove, 1))
      assert json_response(conn, 401) == "Unauthorized"
    end
  end

  describe "Update task" do
    test "with valid user and valid task no", %{conn: conn} do
      params = %{
        task_no: 1,
        details: "Updated Task 1"
      }
      conn = post(conn, Routes.task_path(conn, :update, params))
      assert json_response(conn, 200) == "Successfully updated task"

      conn = get(conn, Routes.task_path(conn, :view))
      assert json_response(conn, 200) == [
        %{
          "details" => "Updated Task 1",
          "task_no" => 1
        },
        %{
          "details" => "Example Task 2",
          "task_no" => 2
        },
        %{
          "details" => "Example Task 3",
          "task_no" => 3
        },
        %{
          "details" => "Example Task 4",
          "task_no" => 4
        }
      ]
    end

    test "with valid user and invalid task no", %{conn: conn} do
      params = %{
        task_no: 6,
        details: "Updated task 1"
      }
      conn = post(conn, Routes.task_path(conn, :update, params))
      assert json_response(conn, 400)["task_no"] == "Task number does not exist"

      params = %{
        task_no: "a",
        details: "Updated task 1"
      }
      conn = post(conn, Routes.task_path(conn, :update, params))
      assert json_response(conn, 400)["task_no"] == "Task number is invalid"
    end

    test "with invalid user" do
      conn = build_conn()
      conn = post(conn, Routes.task_path(conn, :update, %{}))
      assert json_response(conn, 401) == "Unauthorized"
    end
  end

  describe "Move task" do
    test "with valid user moving 1st task to 4th", %{conn: conn} do
      params = %{
        task_no: 1,
        new_task_no: 4
      }

      conn = post(conn, Routes.task_path(conn, :move), params)
      assert json_response(conn, 200) == "Successfully moved task"

      conn = get(conn, Routes.task_path(conn, :view))
      assert json_response(conn, 200) == [
        %{
          "details" => "Example Task 2",
          "task_no" => 1
        },
        %{
          "details" => "Example Task 3",
          "task_no" => 2
        },
        %{
          "details" => "Example Task 4",
          "task_no" => 3
        },
        %{
          "details" => "Example Task 1",
          "task_no" => 4
        }
      ]
    end

    test "with valid user moving 2nd task to 4th", %{conn: conn} do
      params = %{
        task_no: 2,
        new_task_no: 4
      }

      conn = post(conn, Routes.task_path(conn, :move), params)
      assert json_response(conn, 200) == "Successfully moved task"

      conn = get(conn, Routes.task_path(conn, :view))
      assert json_response(conn, 200) == [
        %{
          "details" => "Example Task 1",
          "task_no" => 1
        },
        %{
          "details" => "Example Task 3",
          "task_no" => 2
        },
        %{
          "details" => "Example Task 4",
          "task_no" => 3
        },
        %{
          "details" => "Example Task 2",
          "task_no" => 4
        }
      ]
    end

    test "with valid user moving 3rd task to 4th", %{conn: conn} do
      params = %{
        task_no: 3,
        new_task_no: 4
      }

      conn = post(conn, Routes.task_path(conn, :move), params)
      assert json_response(conn, 200) == "Successfully moved task"

      conn = get(conn, Routes.task_path(conn, :view))
      assert json_response(conn, 200) == [
        %{
          "details" => "Example Task 1",
          "task_no" => 1
        },
        %{
          "details" => "Example Task 2",
          "task_no" => 2
        },
        %{
          "details" => "Example Task 4",
          "task_no" => 3
        },
        %{
          "details" => "Example Task 3",
          "task_no" => 4
        }
      ]
    end

    test "with valid user moving 4th task to 3rd", %{conn: conn} do
      params = %{
        task_no: 4,
        new_task_no: 3
      }

      conn = post(conn, Routes.task_path(conn, :move), params)
      assert json_response(conn, 200) == "Successfully moved task"

      conn = get(conn, Routes.task_path(conn, :view))
      assert json_response(conn, 200) == [
        %{
          "details" => "Example Task 1",
          "task_no" => 1
        },
        %{
          "details" => "Example Task 2",
          "task_no" => 2
        },
        %{
          "details" => "Example Task 4",
          "task_no" => 3
        },
        %{
          "details" => "Example Task 3",
          "task_no" => 4
        }
      ]
    end

    test "with valid user moving 4th task to 2nd", %{conn: conn} do
      params = %{
        task_no: 4,
        new_task_no: 2
      }

      conn = post(conn, Routes.task_path(conn, :move), params)
      assert json_response(conn, 200) == "Successfully moved task"

      conn = get(conn, Routes.task_path(conn, :view))
      assert json_response(conn, 200) == [
        %{
          "details" => "Example Task 1",
          "task_no" => 1
        },
        %{
          "details" => "Example Task 4",
          "task_no" => 2
        },
        %{
          "details" => "Example Task 2",
          "task_no" => 3
        },
        %{
          "details" => "Example Task 3",
          "task_no" => 4
        }
      ]
    end

    test "with valid user moving 4th task to 1st", %{conn: conn} do
      params = %{
        task_no: 4,
        new_task_no: 1
      }

      conn = post(conn, Routes.task_path(conn, :move), params)
      assert json_response(conn, 200) == "Successfully moved task"

      conn = get(conn, Routes.task_path(conn, :view))
      assert json_response(conn, 200) == [
        %{
          "details" => "Example Task 4",
          "task_no" => 1
        },
        %{
          "details" => "Example Task 1",
          "task_no" => 2
        },
        %{
          "details" => "Example Task 2",
          "task_no" => 3
        },
        %{
          "details" => "Example Task 3",
          "task_no" => 4
        }
      ]
    end

    test "with valid user moving task to an invalid task no", %{conn: conn} do
      params = %{
        task_no: 0,
        new_task_no: 1
      }

      conn = post(conn, Routes.task_path(conn, :move), params)
      assert json_response(conn, 400)["task_no"] == "Task number is invalid"

      params = %{
        task_no: 5,
        new_task_no: 1
      }

      conn = post(conn, Routes.task_path(conn, :move), params)
      assert json_response(conn, 400)["message"] == "Task number does not exist"

      params = %{
        task_no: "a",
        new_task_no: 1
      }

      conn = post(conn, Routes.task_path(conn, :move), params)
      assert json_response(conn, 400)["task_no"] == "Task number is invalid"
    end

    test "with valid user moving task to an invalid new task no", %{conn: conn} do
      params = %{
        task_no: 4,
        new_task_no: 0
      }

      conn = post(conn, Routes.task_path(conn, :move), params)
      assert json_response(conn, 400)["new_task_no"] == "New task number is invalid"

      params = %{
        task_no: 4,
        new_task_no: 5
      }

      conn = post(conn, Routes.task_path(conn, :move), params)
      assert json_response(conn, 400)["message"] == "New task number is invalid"

      params = %{
        task_no: 4,
        new_task_no: "a"
      }

      conn = post(conn, Routes.task_path(conn, :move), params)
      assert json_response(conn, 400)["new_task_no"] == "New task number is invalid"
    end
  end

  def generate_token(user, conn) do
    conn = post(conn, Routes.login_path(conn, :login), user)
    json_response(conn, 200)["access_token"]
  end

end
