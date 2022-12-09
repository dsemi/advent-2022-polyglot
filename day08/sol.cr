puts "Day 8: Crystal"

p1, p2 = 0, 0
grid = Array(Array(UInt8)).new
STDIN.each_line do |line|
  grid << [] of UInt8
  line.each_char do |v|
    grid[-1] << (v - '0').to_u8
  end
end

grid.each_index do |r|
  grid[r].each_index do |c|
    vis_from_edge = false
    scenic_score = 1
    [
      (r-1).downto(0).map {|nr| grid[nr][c] }.to_a,
      (r+1).upto(grid.size-1).map {|nr| grid[nr][c] }.to_a,
      (c-1).downto(0).map {|nc| grid[r][nc] }.to_a,
      (c+1).upto(grid[r].size-1).map {|nc| grid[r][nc] }.to_a,
    ].each do |path|
      ind = path.index {|x| x >= grid[r][c] }
      vis_from_edge |= ind.nil?
      scenic_score *= ind.nil? ? path.size : ind + 1;
    end
    if vis_from_edge
      p1 += 1
    end
    p2 = Math.max(p2, scenic_score)
  end
end

printf("Part 1: %20d\n", p1)
printf("Part 2: %20d\n", p2)
