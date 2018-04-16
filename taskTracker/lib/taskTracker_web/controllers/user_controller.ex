defmodule TaskTrackerWeb.UserController do
  use TaskTrackerWeb, :controller

  alias TaskTracker.Accounts
  alias TaskTracker.Accounts.User

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: page_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    subordinate_names = Accounts.get_subordinate_names(id)

    manager_name = if user.manager_id == nil do
      "None"
    else
      manager = Accounts.get_user!(user.manager_id)
      manager.name
    end

    render(conn, "show.html", user: user, manager_name: manager_name,
      subordinate_names: subordinate_names)
  end

  def edit(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    users = Accounts.list_users()
    changeset = Accounts.change_user(user)
    subordinate_names = Accounts.get_subordinate_names(id)
    render(conn, "edit.html", user: user, changeset: changeset, users: users,
    subordinate_names: subordinate_names)
  end


  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    case Accounts.update_user(user, user_params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "User updated successfully.")

        current_user = conn.assigns[:current_user]
        new_manager_id = user_params["manager_id"]

        if Integer.to_string(current_user.id) == new_manager_id do
          conn
          |> redirect(to: user_path(conn, :index))
        else
          conn
          |> redirect(to: page_path(conn, :feed))
        end

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    {:ok, _user} = Accounts.delete_user(user)

    conn
    |> delete_session(:user_id)
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: page_path(conn, :index))
  end
end
