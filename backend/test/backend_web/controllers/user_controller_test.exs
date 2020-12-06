defmodule BackendWeb.UserControllerTest do
  use BackendWeb.ConnCase

  alias Backend.Accounts
  alias Backend.Accounts.User

  @create_attrs %{
    email: "email@email.com",
    password: "password"
  }
  @update_attrs %{
    email: "updatedemail@email.com",
    password: "updated_password"
  }
  @invalid_attrs %{email: nil, encrypted_password: nil}

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)
      assert %{"email" => email, "token" => token} = Jason.decode!(conn.resp_body)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    %{user: user}
  end
end
