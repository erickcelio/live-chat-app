defmodule BackendWeb.UserView do
  use BackendWeb, :view

  def render("user.json", %{user: user, token: token}) do
    %{
      email: user.email,
      token: token
    }
  end

  def render("user_changed_with_success.json", _assigns) do
    %{
      message: "changed with success!"
    }
  end
end
