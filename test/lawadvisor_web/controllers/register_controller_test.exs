defmodule LawadvisorWeb.RegisterControllerTest do
  use LawadvisorWeb.ConnCase

  import Lawadvisor.UserFixtures

  @register_attrs %{
    username: "garciajoeffrey",
    password: "P@ssw0rd"
  }
  @exist_attrs %{
    username: "joeffreygarcia",
    password: "P@ssw0rd"
  }
  @invalid_attrs %{username: nil, password: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "register user" do
    test "with valid username and password", %{conn: conn} do
      conn = post(conn, Routes.register_path(conn, :register), @register_attrs)
      assert json_response(conn, 200) == "User registered successfully"
    end

    test "with username already exist", %{conn: conn} do
      create_user(@exist_attrs)
      conn = post(conn, Routes.register_path(conn, :register), @exist_attrs)
      assert json_response(conn, 400)["username"] == "Username already exists"
    end

    test "empty parameters", %{conn: conn} do
      conn = post(conn, Routes.register_path(conn, :register), @invalid_attrs)
      assert json_response(conn, 400)["username"] == "Enter username"
      assert json_response(conn, 400)["password"] == "Enter password"
    end
  end

end
