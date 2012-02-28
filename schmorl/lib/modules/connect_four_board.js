

ConnectFourBoard.Class.create();
ConnectFourBoard.include({
  setup: function()  {

  },

  process_user_input: function(player_id, column_id)  {
    edited_columns = add_checker_to_column(player_id, column_id)  {
    win_columns = find_win(player_id)
    if win_columns.length > 0  {
      edited_columns += process_board_on_player_win(win_columns)
      increase_player_score(player_id)
    }
    board_changes = get_board_changes(edited_columns)
    return board_changes
  },

  find_win: function(player_id)  {
  },

  find_column_win: function(player_id)  {
  },

  find_row_win: function(player_id)  {
  },

  find_diagonal_win: function(player_id)  {
  },

  add_checker_to_column: function(player_id, column_id)  {
  },

});
