defmodule TaskTracker.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias TaskTracker.Accounts.User

  # a user has an email address that must be unique,
  # a name, and a manager, who is also a user
  schema "users" do
    field :email, :string
    field :name, :string
    belongs_to :manager, TaskTracker.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :name, :manager_id])
    |> validate_required([:email, :name])
    |> unique_constraint(:email)
  end
end
