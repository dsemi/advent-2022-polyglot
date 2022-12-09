import fileinput

print('Day 9: Python')

def sign(n):
  return (n > 0) - (n < 0)

data = [line.strip() for line in fileinput.input()]
knots = [0 for _ in range(10)]
p1, p2 = {0}, {0}
m = {'L': -1, 'R': 1, 'U': 1j, 'D': -1j}
for line in data:
  d, n = line.split()
  for _ in range(int(n)):
    knots[0] += m[d]
    for i in range(1, len(knots)):
      dxy = knots[i-1] - knots[i]
      if abs(dxy.real) > 1 or abs(dxy.imag) > 1:
        knots[i] += sign(dxy.real)
        knots[i] += sign(dxy.imag) * 1j
    p1.add(knots[1])
    p2.add(knots[9])

print('Part 1: {:20}'.format(len(p1)))
print('Part 2: {:20}'.format(len(p2)))
