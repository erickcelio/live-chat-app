defmodule Backend.Channels.Channel do
  use Ecto.Schema

  import Ecto.Changeset

  alias Backend.Accounts
  alias Backend.Channels
  alias Backend.Repo

  schema "channels" do
    field :name, :string

    belongs_to :user, Accounts.User
    has_many :messages, Channels.Message
    many_to_many :users, Accounts.User, join_through: "users_channels", on_delete: :delete_all
    timestamps()
  end

  @doc false
  def changeset(channel, attrs) do
    channel
    |> cast(attrs, [:name, :user_id])
    |> validate_required([:name, :user_id])
    |> unique_constraint(:name)
    |> put_user(attrs)
  end

  def put_user(changeset, attrs) do
    user_id = attrs["user_id"]

    if user_id do
      user = Repo.get!(Accounts.User, user_id)
      Ecto.Changeset.put_assoc(changeset, :users, [user])
    else
      changeset
    end
  end
end
