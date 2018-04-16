defmodule TaskTrackerWeb.BlockView do
  use TaskTrackerWeb, :view
  alias TaskTrackerWeb.BlockView

  def render("index.json", %{blocks: blocks}) do
    %{data: render_many(blocks, BlockView, "block.json")}
  end

  def render("show.json", %{block: block}) do
    %{data: render_one(block, BlockView, "block.json")}
  end

  def render("block.json", %{block: block}) do
    %{id: block.id,
      start_time: block.start_time,
      end_time: block.end_time}
  end
end
