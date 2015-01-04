class Sudoku

  @empty_cells_possible_vals = []
  @empty_cell_locations = []
  @empty_cells = 0
  @possibleVals = [1,2,3,4,5,6,7,8,9]

  row1 = [7,9,6," ", " ", " ", 3, " ", " "]
  row2 = [" "," "," "," ", 7, 6, 9, " ", " "]
  row3 = [8," ", " ", " ", 3, " ", " ", 7, 6]
  row4 = [" ", " ", " ", " ", " ", 5, " ", " ", 2]
  row5 = [" ", " ", 5, 4,1,8,7," ", " "]
  row6 = [4, " ", " ", 7, " ", " ", " ", " ", " "]
  row7 = [6,1," ", " ", 9, " ", " ", " ", 8]
  row8 = [5, " ", 2, 3, " ", " ", " ", " ", " "]
  row9 = [3, " ", 9, " ", " ", " ", " ", 5, 4]
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
    returnVals = []
    if grid == nil
      return []
    else
      (0..8).each do |row|
        (0..8).each do |column|
          if(grid[row][column] == " ")
            @empty_cells = @empty_cells + 1
            @empty_cell_locations.push([row, column])
            get_index_of_empty(grid[row][column + 1, -1])
          end
        end
      end
    end
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

  def self.possible_values_for_cell(grid, row, column)
    column_vals = push_column_values(grid, column)
    grid_vals = push_grid_values(grid, row, column)
    possible_row_vals = @possibleVals - grid[row]
    possible_cell_vals = possible_row_vals - column_vals - grid_vals
    return possible_cell_vals
  end

  def self.possible_values_for_all_cells(grid)
    get_index_of_empty(grid)
    (0..@empty_cell_locations.count - 1).each do |i|
      row = @empty_cell_locations[i][0]
      column = @empty_cell_locations[i][1]
      @empty_cells_possible_vals.push([row, column, possible_values_for_cell(grid, row, column)])
    end
  end

  def self.solve_sudoku(grid)
    i = 0
    while( i < @empty_cells_possible_vals.count ) do
      if(@empty_cells_possible_vals[i][2].count == 1)
        row = @empty_cells_possible_vals[i][0]
        column = @empty_cells_possible_vals[i][1]
        possible_value = @empty_cells_possible_vals[i][2][0]
        grid[row][column] = possible_value
        @empty_cells_possible_vals.delete_at(i)
        @empty_cells = @empty_cells - 1
      end
      i = i + 1
    end
    print_grid(grid)
    puts "----------------------------"
  end


  possible_values_for_all_cells(grid)
  #print_grid(grid)
  #puts "------------------------------"
  while(@empty_cells >= 0) do
    solve_sudoku(grid)
    possible_values_for_all_cells(grid)
  end

end