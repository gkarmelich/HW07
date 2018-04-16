defmodule TaskTracker.Repo.Migrations.RemoveTimeInvested do
  use Ecto.Migration

  def change do
    alter table(:tasks) do
      remove :time_invested
    end
  end
end
