defmodule TaskTrackerWeb.BlockController do
  use TaskTrackerWeb, :controller

  alias TaskTracker.Work
  alias TaskTracker.Work.Block

  action_fallback TaskTrackerWeb.FallbackController

  def index(conn, _params) do
    blocks = Work.list_blocks()
    render(conn, "index.json", blocks: blocks)
  end

  def create(conn, %{"block" => block_params}) do
    with {:ok, %Block{} = block} <- Work.create_block(block_params) do
      task = Work.get_task!(block.task_id)

      conn
      |> put_status(:created)
      |> put_resp_header("location", block_path(conn, :show, block))
      |> render("show.json", block: block)
    end
  end

  def show(conn, %{"id" => id}) do
    block = Work.get_block!(id)
    render(conn, "show.json", block: block)
  end

  def update(conn, %{"id" => id, "block" => block_params}) do
    block = Work.get_block!(id)

    with {:ok, %Block{} = block} <- Work.update_block(block, block_params) do
      render(conn, "show.json", block: block)
    end
  end

  def delete(conn, %{"id" => id}) do
    block = Work.get_block!(id)
    with {:ok, %Block{}} <- Work.delete_block(block) do
      send_resp(conn, :no_content, "")
    end
  end
end
