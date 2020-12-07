defmodule BackendWeb.MessageController do
  use BackendWeb, :controller

  alias Backend.Channels
  alias Backend.Channels.Message
  alias BackendWeb.Auth.Guardian

  action_fallback BackendWeb.FallbackController

  def create(conn, %{"message" => message_params}) do
    user = Guardian.Plug.current_resource(conn)
    message_params = Map.put(message_params, "user_id", user.id)

    with {:ok, %Message{} = message} <- Channels.create_message(message_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.message_path(conn, :show, message))
      |> render("show.json", message: message)
    end
  end

  def show(conn, %{"id" => channel_id}) do
    messages = Channels.list_messages_from_channel(channel_id)

    render(conn, "index.json", messages: messages)
  end

  def update(conn, %{"id" => id, "message" => message_params}) do
    message = Channels.get_message!(id)

    with {:ok, %Message{} = message} <- Channels.update_message(message, message_params) do
      render(conn, "show.json", message: message)
    end
  end

  def delete(conn, %{"id" => id}) do
    message = Channels.get_message!(id)

    with {:ok, %Message{}} <- Channels.delete_message(message) do
      send_resp(conn, :no_content, "")
    end
  end
end
