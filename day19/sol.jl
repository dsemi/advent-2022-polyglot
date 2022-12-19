using Printf

println("Day 19: Julia")

struct Blueprint
  num::Int32
  costs::Array{Int32, 2}
  maxCosts::Vector{Int32}
end

function dfs(b::Blueprint, res, time, amts, bots, bans)
  time == 0 && return max(res, amts[1])
  upperBd = amts[1] + time*bots[1] + time*(time+1)÷2
  upperBd <= res && return res
  for (i, cost) in enumerate(eachrow(b.costs))
    bit = 1 << (i-1)
    if bans & bit == 0 && (i == 1 || bots[i] < b.maxCosts[i]) && all(amts .>= cost)
      chans = [0, 0, 0, 0]
      chans[i] = 1
      res = dfs(b, res, time-1, amts .+ bots .- cost, bots .+ chans, 0)
      bans |= bit
    end
  end
  return dfs(b, res, time-1, amts .+ bots, bots, bans)
end

function sim(b::Blueprint, time)
  dfs(b, 0, time, [0, 0, 0, 0], [0, 0, 0, 1], 0)
end

blueprints = Vector{Blueprint}()
while !eof(stdin)
  line = readline(stdin)
  num, oreBotOre, clayBotOre, obsBotOre, obsBotClay, geodeBotOre, geodeBotObs =
    [parse(Int32, m.match) for m in eachmatch(r"\d+", line)]
  costs = Array{Int32, 2}([
    0 geodeBotObs 0 geodeBotOre;
    0 0 obsBotClay obsBotOre;
    0 0 0 clayBotOre;
    0 0 0 oreBotOre;
  ])
  maxCosts = vec(findmax(costs, dims=1)[1])
  push!(blueprints, Blueprint(num, costs, maxCosts))
end

p1 = sum(b.num * sim(b, 24) for b in blueprints)
@printf "Part 1: %20d\n" p1
p2 = prod(sim(b, 32) for b in blueprints[1:3])
@printf "Part 2: %20d\n" p2
