console.log('Day 13: JavaScript');

const readline = require('readline');
const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
  terminal: false,
});

function cmp(a, b) {
  let ta = typeof a;
  let tb = typeof b;
  if (ta == 'number' && tb == 'number') {
    return (a < b) ? -1 : (a > b) ? 1 : 0;
  } else if (ta == 'number' && tb == 'object') {
    return cmp([a], b);
  } else if (ta == 'object' && tb == 'number') {
    return cmp(a, [b]);
  } else {
    for (let i = 0; i < Math.min(a.length, b.length); i++) {
      let c = cmp(a[i], b[i]);
      if (c != 0) return c;
    }
    return cmp(a.length, b.length);
  }
}

let p1 = 0;
let p2 = 1;
let packets = [];

let i = 1;
rl.on('line', (line) => {
  if (line == '') {
    if (cmp(packets[packets.length-2], packets[packets.length-1]) == -1) p1 += i;
    i++;
  } else {
    packets.push(eval(line));
  }
});

rl.once('close', () => {
  if (cmp(packets[packets.length-2], packets[packets.length-1]) == -1) p1 += i;
  let a = [[2]];
  let b = [[6]];
  packets.push(a);
  packets.push(b);
  packets.sort(cmp);
  p2 *= packets.findIndex(e => e == a) + 1;
  p2 *= packets.findIndex(e => e == b) + 1;
  console.log('Part 1: ' + p1.toString().padStart(20));
  console.log('Part 2: ' + p2.toString().padStart(20));
});
