defmodule Valleybot.Repo.Migrations.CreateTummies do
  use Ecto.Migration

  def change do
    create table(:tummies) do
      add :tummy, :string

      timestamps()
    end
  end
end
