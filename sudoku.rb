class Sudoku

  possibleVals = [1,2,3,4,5,6,7,8,9]
  row1 = [7,9,6,8," ",4,3,2,1]
  row2 = [2,4,3,1,7,6,9,8,5]
  row3 = [8,5," ",2,3,9,4,7,6]
  row4 = [1,3,7,9," ",5,8,4,2]
  row5 = [9,2,5,4,1,8,7,6,3]
  row6 = [4,6,8,7,2,3,5,1,9]
  row7 = [6,1,4,5,9,7,2,3,8]
  row8 = [5,8,2,3,4," ",6,9,7]
  row9 = [3,7,9,6,8,2,1,5,4]
  grid = [row1, row2, row3,
          row4, row5, row6,
          row7, row8, row9]

  def self.print_grid(grid)
    (0..8).each do |i|
      grid[i].each do |num|
        print num
      end
      puts
    end
  end

  def self.get_index_of_empty(grid)
    index = -1
    row = -1
    (0..8).each do |i|
      index = grid[i].index(" ")
      row = i
      break
    end
    return row, index
  end

  def self.grid_helper(row_column_val)
    if(row_column_val / 3 == 0)
      local_val = 0
    elsif(row_column_val / 3 == 1)
      local_val = 3
    else
      local_val = 6
    end
    return local_val
  end

  def self.push_grid_values(grid, row, column)
    local_row = grid_helper(row)
    local_column = grid_helper(column)
    local_grid = []
    count = 0
    while(count < 3) do
      local_grid.push(grid[local_row][local_column])
      local_grid.push(grid[local_row][local_column + 1])
      local_grid.push(grid[local_row][local_column + 2])
      local_row = local_row + 1
      count = count + 1
    end
    return local_grid
  end

  def self.push_column_values(grid, column)
    column_vals = []
    (0..8).each do |row|
      column_vals.push(grid[row][column])
    end
    return column_vals
  end

  def self.possible_values_for_cell(grid, row, column, possibleVals)
    column_vals = push_column_values(grid, column)
    grid_vals = push_grid_values(grid, row, column)
    possible_row_vals = possibleVals - grid[row]
    possible_col_vals = possibleVals - column_vals
    possible_grid_vals = possibleVals - grid_vals
    return possible_row_vals, possible_col_vals, possible_grid_vals
  end

  print_grid(grid)
  row, column = get_index_of_empty(grid)
  p_row, p_col, p_grid = possible_values_for_cell(grid, row, column, possibleVals)

  print p_col

end