console.log('Day 13: JavaScript');

const readline = require('readline');
const rl = readline.createInterface({input: process.stdin});

function cmp(a, b) {
  if (typeof a == 'number' && typeof b == 'number') {
    return (a < b) ? -1 : (a > b) ? 1 : 0;
  } else if (typeof a == 'number' && typeof b == 'object') {
    return cmp([a], b);
  } else if (typeof a == 'object' && typeof b == 'number') {
    return cmp(a, [b]);
  } else {
    for (let i = 0; i < Math.min(a.length, b.length); i++) {
      let c = cmp(a[i], b[i]);
      if (c != 0) return c;
    }
    return cmp(a.length, b.length);
  }
}

let packets = [];

rl.on('line', (line) => { if (line != '') packets.push(eval(line)) });

rl.once('close', () => {
  let p1 = 0;
  for (let i = 1; i < packets.length; i += 2) {
    if (cmp(packets[i-1], packets[i]) < 0) p1 += (i+1)/2;
  }
  console.log('Part 1: ' + p1.toString().padStart(20));
  let a = [[2]];
  let b = [[6]];
  packets.push(a, b);
  packets.sort(cmp);
  let p2 = (packets.findIndex(e => e == a) + 1) * (packets.findIndex(e => e == b) + 1);
  console.log('Part 2: ' + p2.toString().padStart(20));
});
