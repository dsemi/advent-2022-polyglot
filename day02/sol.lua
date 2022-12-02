print('Day 2: Lua')
local p1, p2 = 0, 0
for line in io.stdin:lines() do
   local a = line:byte(1) - ('A'):byte()
   local b = line:byte(3) - ('X'):byte()
   local wld = b == (a+1)%3 and 6 or b == a and 3 or 0
   p1 = p1 + wld + b + 1

   b = (a+b-1)%3
   wld = b == (a+1)%3 and 6 or b == a and 3 or 0
   p2 = p2 + wld + b + 1
end
print(string.format('Part 1: %20d', p1))
print(string.format('Part 2: %20d', p2))
