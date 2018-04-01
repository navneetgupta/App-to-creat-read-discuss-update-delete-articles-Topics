defmodule Discuss.Repo.Migrations.AddCommments do
  use Ecto.Migration

  def change do
    create table (:comments) do
      add :content, :string
      add :user_id, references(:users)
      add :topic_id, references(:topics)


      timestamps()
    end
  end
end
