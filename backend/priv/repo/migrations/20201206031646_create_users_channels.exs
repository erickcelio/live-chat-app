defmodule Backend.Repo.Migrations.CreateUsersChannels do
  use Ecto.Migration

  def change do
    create table(:users_channels) do
      add :user_id, references(:users)
      add :channel_id, references(:channels)
    end

    create unique_index(:users_channels, [:user_id, :channel_id])
  end
end
