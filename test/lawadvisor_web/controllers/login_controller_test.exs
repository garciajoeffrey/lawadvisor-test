defmodule LawadvisorWeb.LoginControllerTest do
  use LawadvisorWeb.ConnCase

  import Lawadvisor.UserFixtures

  @login_attrs %{
    username: "joeffreygarcia",
    password: "P@ssw0rd"
  }
  @invalid_user_attrs %{
    username: "joeffreygarcia1",
    password: "P@ssw0rd"
  }
  @invalid_pass_attrs %{
    username: "joeffreygarcia",
    password: "P@ssw0rd1"
  }
  @invalid_attrs %{username: nil, password: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "Login user" do
    test "with valid username and password", %{conn: conn} do
      create_user(@login_attrs)
      conn = post(conn, Routes.login_path(conn, :login), @login_attrs)
      assert json_response(conn, 200)["access_token"]
    end

    test "with username not existing", %{conn: conn} do
      conn = post(conn, Routes.login_path(conn, :login), @invalid_user_attrs)
      assert json_response(conn, 400)["username"] == "Username does not exist"
    end

    test "with incorrect password", %{conn: conn} do
      create_user(@login_attrs)
      conn = post(conn, Routes.login_path(conn, :login), @invalid_pass_attrs)
      assert json_response(conn, 400)["username"] == "Invalid password. Please try again."
    end

    test "with missing parameters", %{conn: conn} do
      conn = post(conn, Routes.login_path(conn, :login), @invalid_attrs)
      assert json_response(conn, 400)["username"] == "Enter username"
      assert json_response(conn, 400)["password"] == "Enter password"
    end
  end

end
