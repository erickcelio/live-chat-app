defmodule Backend.Channels.Message do
  use Ecto.Schema
  import Ecto.Changeset

  alias Backend.Accounts
  alias Backend.Channels

  schema "messages" do
    field :content, :string

    belongs_to :channel, Channels.Channel
    belongs_to :user, Accounts.User
    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:content, :channel_id, :user_id])
    |> validate_required([:content, :channel_id, :user_id])
  end
end
