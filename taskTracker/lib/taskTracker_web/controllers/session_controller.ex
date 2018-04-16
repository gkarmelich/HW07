defmodule TaskTrackerWeb.SessionController do
  use TaskTrackerWeb, :controller


  def create(conn, %{"email" => email}) do
    user = TaskTracker.Accounts.get_user_by_email(email)

    if user do
      conn
      |> put_session(:user_id, user.id)
      |> put_flash(:info, "Welcome, #{user.name}")
      |> redirect(to: page_path(conn, :feed))
    else
      conn
      |> put_flash(:error, "Cannot create session!")
      |> redirect(to: page_path(conn, :index))
    end
  end


  def delete(conn, _params) do
    conn
    |> delete_session(:user_id)
    |> put_flash(:info, "You have logged out!")
    |> redirect(to: page_path(conn, :index))
  end
end
