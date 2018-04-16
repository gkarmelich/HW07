defmodule TaskTrackerWeb.TaskController do
  use TaskTrackerWeb, :controller

  alias TaskTracker.Work
  alias TaskTracker.Work.Task

  def index(conn, _params) do
    tasks = Work.list_tasks()
    render(conn, "index.html", tasks: tasks)
  end

  def new(conn, _params) do
    changeset = Work.change_task(%Task{})
    render(conn, "new.html", changeset: changeset)
  end


  def create(conn, %{"task" => task_params}) do
    case Work.create_task(task_params) do
      {:ok, _task} ->
        conn
        |> put_flash(:info, "Task created successfully.")
        |> redirect(to: page_path(conn, :feed))
      {:error, %Ecto.Changeset{} = changeset} ->
        users = TaskTracker.Accounts.list_users()
        render(conn, "new.html", changeset: changeset, users: users,
          cancel: true)
    end
  end

  def show(conn, %{"id" => id}) do
    task = Work.get_task!(id)
    blocks = Work.get_blocks_by_task_id(id)
    render(conn, "show.html", task: task, blocks: blocks)
  end

  def edit(conn, %{"id" => id}) do
    task = Work.get_task!(id)
    changeset = Work.change_task(task)
    blocks = Work.get_blocks_by_task_id(id)
    |> Enum.sort(fn (a, b) -> a.id > b.id end)
    render(conn, "edit.html", task: task, changeset: changeset, blocks: blocks)
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    task = Work.get_task!(id)

    case Work.update_task(task, task_params) do
      {:ok, _task} ->
        conn
        |> put_flash(:info, "Task updated successfully.")
        |> redirect(to: task_path(conn, :edit, task))
      {:error, %Ecto.Changeset{} = changeset} ->
        blocks = Work.get_blocks_by_task_id(id)
        render(conn, "edit.html", task: task, changeset: changeset, blocks: blocks)
    end
  end

  def delete(conn, %{"id" => id}) do
    task = Work.get_task!(id)
    {:ok, _task} = Work.delete_task(task)

    conn
    |> put_flash(:info, "Task deleted successfully.")
    |> redirect(to: task_path(conn, :index))
  end
end
