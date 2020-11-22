defmodule Livechatapp.Repo do
  use Ecto.Repo,
    otp_app: :livechatapp,
    adapter: Ecto.Adapters.Postgres
end
