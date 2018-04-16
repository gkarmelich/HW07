// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html";

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"

import $ from "jquery";


function stop_block_click(ev) {
  let btn = $(ev.target);
  let id = btn.data('id');
  let task_id = btn.data('task-id');
  let start_time = btn.data('start-time');
  let end_time = new Date();

  let text = JSON.stringify({
    block: {
      start_time: start_time,
      end_time: end_time,
      task_id: task_id
    }
  });

  $.ajax(block_path + "/" + id, {
    method: "put",
    dataType: "json",
    contentType: "application/json; charset=UTF-8",
    data: text,
    success: () => {}
  });
}


function update_block_click(ev) {
  let btn = $(ev.target);
  let id = btn.data('id');
  let task_id = btn.data('task-id');
  let start_time = null;
  let end_time = null;

  $('.start-time').each( (_, st) => {
    if (id == $(st).data('id')) {
      start_time = $(st).val();
    }
  });

  $('.end-time').each( (_, et) => {
    if (id == $(et).data('id')) {
      end_time = $(et).val();
    }
  });

  let text = JSON.stringify({
    block: {
      start_time: start_time,
      end_time: end_time,
      task_id: task_id
    }
  });

  $.ajax(block_path + "/" + id, {
    method: "put",
    dataType: "json",
    contentType: "application/json; charset=UTF-8",
    data: text,
    success: () => {}
  });
}


function create_block_click(ev) {
  let btn = $(ev.target);
  let start_time = new Date();
  let end_time = null;
  let task_id = btn.data('task-id');

  let text = JSON.stringify({
    block: {
      start_time: start_time,
      end_time: end_time,
      task_id: task_id
    }
  });

  $.ajax(block_path, {
    method: "post",
    dataType: "json",
    contentType: "application/json; charset=UTF-8",
    data: text,
    success: () => {}
  });
}


function delete_block_click(ev) {
  let btn = $(ev.target);
  let id = btn.data('id');

  $.ajax(block_path + "/" + id, {
    method: "delete",
    dataType: "json",
    contentType: "application/json; charset=UTF-8",
    data: "",
    success: () => {}
  });
}


function init_block() {
  if ($('.stop-block-btn')) {
    $('.stop-block-btn').click(stop_block_click);
  }

  if ($('.update-block-btn')) {
    $('.update-block-btn').click(update_block_click);
  }

  if ($('.create-block-btn')) {
    $('.create-block-btn').click(create_block_click);
  }

  if ($('.delete-block-btn')) {
    $('.delete-block-btn').click(delete_block_click);
  }
}

$(init_block);
