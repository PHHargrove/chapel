use BlockDist;

config const n = 10;

const block = new blockDist({1..n});
var D = {1..n} dmapped new dmap(block);
