defmodule BackendWeb.ChannelController do
  use BackendWeb, :controller

  alias Backend.Channels
  alias Backend.Channels.Channel
  alias BackendWeb.Auth.Guardian

  action_fallback BackendWeb.FallbackController

  def index(conn, _params) do
    channels = Channels.list_channels()
    render(conn, "index.json", channels: channels)
  end

  def create(conn, %{"channel" => channel}) do
    user = Guardian.Plug.current_resource(conn)
    channel_params = Map.put(channel, "user_id", user.id)

    with {:ok, %Channel{} = channel} <- Channels.create_channel(channel_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.channel_path(conn, :show, channel))
      |> render("show.json", channel: channel)
    end
  end

  def show(conn, %{"id" => id}) do
    channel = Channels.get_channel!(id)
    render(conn, "show.json", channel: channel)
  end

  def update(conn, %{"id" => id, "channel" => channel_params}) do
    user = Guardian.Plug.current_resource(conn)
    channel = Channels.get_channel!(id)
    is_owner = channel.user_id == user.id

    if is_owner do
      with {:ok, %Channel{} = channel} <- Channels.update_channel(channel, channel_params) do
        render(conn, "show.json", channel: channel)
      end
    else
      conn
      |> put_status(:unauthorized)
      |> render(BackendWeb.ErrorView, :"401")
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Guardian.Plug.current_resource(conn)
    channel = Channels.get_channel!(id)
    is_owner = channel.user_id == user.id

    if is_owner do
      with {:ok, %Channel{}} <- Channels.delete_channel(channel) do
        send_resp(conn, :no_content, "")
      end
    else
      conn
      |> put_status(:unauthorized)
      |> render(BackendWeb.ErrorView, :"401")
    end
  end
end
