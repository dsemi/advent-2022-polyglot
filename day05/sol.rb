puts "Day 5: Ruby"

pts = STDIN.read.split("\n\n")
crates = pts[0].lines.reverse
stacks1 = Array.new((crates[0].length + 1) / 4) {|_| Array.new}
stacks2 = Array.new((crates[0].length + 1) / 4) {|_| Array.new}
crates.each do |line|
  (1...line.length).step(4) do |i|
    if line[i] >= 'A' and line[i] <= 'Z'
      stacks1[i / 4].push(line[i])
      stacks2[i / 4].push(line[i])
    end
  end
end
pts[1].lines.each do |line|
  line =~ /move (\d+) from (\d+) to (\d+)/
  n, a, b = $1.to_i, $2.to_i, $3.to_i
  n.times do
    stacks1[b-1].push(stacks1[a-1].pop)
  end
  stacks2[b-1].push(*stacks2[a-1][-n, n])
  stacks2[a-1] = stacks2[a-1].take(stacks2[a-1].length - n)
end
puts "Part 1: %20s" % stacks1.map(&:last).join
puts "Part 2: %20s" % stacks2.map(&:last).join
