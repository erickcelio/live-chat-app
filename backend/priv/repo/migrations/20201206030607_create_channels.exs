defmodule Backend.Repo.Migrations.CreateChannels do
  use Ecto.Migration

  def change do
    create table(:channels) do
      add :name, :string
      add :user_id, references(:users)

      timestamps()
    end

    create unique_index(:channels, [:name])
  end
end
