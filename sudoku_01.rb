class Sudoku
  @empty_cell_locations = []
  @empty_cells = 1
  @possibleVals = [1,2,3,4,5,6,7,8,9]
  @empty_cells_hash = Hash.new
  @decision_tree = []
  @left_node_tried = nil

  #Initialize subgrid_hash
  @subgrid_hash = Hash.new
  @subgrid_hash["1"] = []
  @subgrid_hash["2"] = []
  @subgrid_hash["3"] = []
  @subgrid_hash["4"] = []
  @subgrid_hash["5"] = []
  @subgrid_hash["6"] = []
  @subgrid_hash["7"] = []
  @subgrid_hash["8"] = []
  @subgrid_hash["9"] = []

  row1 = [7,9,6," ", " ", " ", 3, " ", " "]
  row2 = [" "," "," "," ", 7, 6, 9, " ", " "]
  row3 = [8," ", " ", " ", 3, " ", " ", 7, 6]
  row4 = [" ", " ", " ", " ", " ", 5, " ", " ", 2]
  row5 = [" ", " ", 5, 4,1,8,7," ", " "]
  row6 = [4, " ", " ", 7, " ", " ", " ", " ", " "]
  row7 = [6,1," ", " ", 9, " ", " ", " ", 8]
  row8 = [5, " ", 2, 3, " ", " ", " ", " ", " "]
  row9 = [3, " ", 9, " ", " ", " ", " ", 5, 4]
  @grid = [row1, row2, row3,
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

  def self.get_index_of_empty(local_grid)
    if local_grid == nil
      return []
    else
      @empty_cell_locations.clear
      @empty_cells = 0
      (0..8).each do |row|
        (0..8).each do |column|
          if(local_grid[row][column] == " ")
            @empty_cells = @empty_cells + 1
            @empty_cell_locations.push([row, column])
            get_index_of_empty(@grid[row][column + 1, -1])
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

  def self.determine_subgrid(local_row, local_column)
    subgrid = 0
    if(local_row == 0 && local_column == 0)
      subgrid = 1
    elsif(local_row == 0 && local_column == 3)
      subgrid = 2
    elsif(local_row == 0)
      subgrid = 3
    elsif(local_row == 3 && local_column == 0)
      subgrid = 4
    elsif(local_row == 3 && local_column == 3)
      subgrid = 5
    elsif(local_row == 3)
      subgrid = 6
    elsif(local_row == 6 && local_column == 0)
      subgrid = 7
    elsif(local_row == 6 && local_column == 3)
      subgrid = 8
    else
      subgrid = 9
    end
    return subgrid
  end

  def self.define_subgrid_location(row, column)
    subgrid = 0
    local_row = grid_helper(row)
    local_column = grid_helper(column)
    subgrid = determine_subgrid(local_row, local_column)
    return subgrid
  end

  def self.eliminate_possible_values_grid
    subgrid = 1
    while(subgrid < 10) do
      cell = 0
      while(cell < @subgrid_hash["#{subgrid}"].count) do
        cell_to_check = 0
        cur_row = @subgrid_hash["#{subgrid}"][cell][0]
        cur_column = @subgrid_hash["#{subgrid}"][cell][1]
        cur_vals = @subgrid_hash["#{subgrid}"][cell][2]
        while(cell_to_check < @subgrid_hash["#{subgrid}"].count) do
          if(@subgrid_hash["#{subgrid}"][cell_to_check] ==
             @subgrid_hash["#{subgrid}"][cell])
            #do nothing
          else
            cur_vals = cur_vals - @subgrid_hash["#{subgrid}"][cell_to_check][2]
          end
          cell_to_check = cell_to_check + 1
        end
        if(!cur_vals.empty?)
          @empty_cells_hash["#{cur_row}#{cur_column}"] = cur_vals
        end
        cell = cell + 1
      end
      subgrid = subgrid + 1
    end
  end

  def self.possible_values_for_all_cells(grid)
    get_index_of_empty(grid)
    (1..9).each do |s_grid|
      @subgrid_hash["#{s_grid}"].clear
    end
    (0..@empty_cell_locations.count - 1).each do |i|
      row = @empty_cell_locations[i][0]
      column = @empty_cell_locations[i][1]
      subgrid = define_subgrid_location(row, column)
      possible_values_cell = possible_values_for_cell(grid, row, column)
      @empty_cells_hash["#{row}#{column}"] = possible_values_cell
      @subgrid_hash["#{subgrid}"].push([row, column, possible_values_cell])
    end
    eliminate_possible_values_grid
    eliminate_possible_values_column
  end

  def self.eliminate_possible_values_column
    i = 0
    while(i < @empty_cell_locations.count) do
      row = @empty_cell_locations[i][0]
      column = @empty_cell_locations[i][1]
      current_cell_values = @empty_cells_hash["#{row}#{column}"]
      j = 0
      ##COLUMNS
      while(j < @empty_cell_locations.count) do
        other_row = @empty_cell_locations[j][0]
        other_column = @empty_cell_locations[j][1]
        if(other_row != row && other_column == column)
          other_cell_vals = @empty_cells_hash["#{other_row}#{other_column}"]
          current_cell_values = current_cell_values - other_cell_vals
        end
        j = j + 1
      end
      if(!current_cell_values.empty?)
        @empty_cells_hash["#{row}#{column}"] = current_cell_values
      end
      j = 0
      ##ROWS
      while(j < @empty_cell_locations.count) do
        other_row = @empty_cell_locations[j][0]
        other_column = @empty_cell_locations[j][1]
        if(other_row == row && other_column != column)
          other_cell_vals = @empty_cells_hash["#{other_row}#{other_column}"]
          current_cell_values = current_cell_values - other_cell_vals
        end
        j = j + 1
      end
      if(!current_cell_values.empty?)
        @empty_cells_hash["#{row}#{column}"] = current_cell_values
      end

      i = i + 1
    end
  end

  def self.solve_empty_cells(grid)
    i = 0
    while( i < @empty_cell_locations.count ) do
      row = @empty_cell_locations[i][0]
      column = @empty_cell_locations[i][1]
      if(@empty_cells_hash["#{row}#{column}"] != nil && @empty_cells_hash["#{row}#{column}"].length == 1)
        possible_value = @empty_cells_hash["#{row}#{column}"]
        @grid[row][column] = possible_value[0]
        @empty_cell_locations.delete_at(i)
        @empty_cells_hash.delete("#{row}#{column}")
        @empty_cells = @empty_cells - 1
      end
      i = i + 1
    end
  end

  def self.min_count_of_values
    min_value = 9
    (0..@empty_cell_locations.count - 1).each do |i|
      row = @empty_cell_locations[i][0]
      col = @empty_cell_locations[i][1]
      cell_values = @empty_cells_hash["#{row}#{col}"]
      puts "ROW/COL: #{row}#{col}"
      puts "CELL VALUES:"
      puts cell_values
      if(cell_values.nil?)
        min_value = 0
      elsif(cell_values.count < min_value)
        min_value = cell_values.count
      end
    end
    return min_value
  end

  Test

  def self.solve_sudoku(grid)
    while( @empty_cells > 0 ) do
      solve_empty_cells(@grid)
      possible_values_for_all_cells(@grid)
      min_cell_val_count = min_count_of_values
      print_grid(grid)
      puts "--------------------------"
      puts "Empty Cells: #{@empty_cells}"
      puts "Min Val: #{min_cell_val_count}"
    end
  end

  solve_sudoku(@grid)

end