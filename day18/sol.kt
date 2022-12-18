data class Pt(val x: Int, val y: Int, val z: Int) {
    fun adj(): List<Pt> {
        return listOf(Pt(x+1, y, z), Pt(x-1, y, z),
                      Pt(x, y+1, z), Pt(x, y-1, z),
                      Pt(x, y, z+1), Pt(x, y, z-1))
    }

    fun min(o: Pt): Pt {
        return Pt(minOf(x, o.x), minOf(y, o.y), minOf(z, o.z))
    }

    fun max(o: Pt): Pt {
        return Pt(maxOf(x, o.x), maxOf(y, o.y), maxOf(z, o.z))
    }

    operator fun plus(o: Pt): Pt {
        return Pt(x + o.x, y + o.y, z + o.z)
    }
}

fun main() {
    println("Day 18: Kotlin")
    val lava = generateSequence(::readLine).map {
        val pts = it.split(",")
        Pt(pts[0].toInt(), pts[1].toInt(), pts[2].toInt())
    }.toSet()
    val p1 = lava.flatMap { it.adj() }.count { !lava.contains(it) }
    println("Part 1: %20d".format(p1))
    var lo = Pt(Int.MAX_VALUE, Int.MAX_VALUE, Int.MAX_VALUE)
    var hi = Pt(Int.MIN_VALUE, Int.MIN_VALUE, Int.MIN_VALUE)
    for (c in lava) {
        lo = lo.min(c + Pt(-1, -1, -1))
        hi = hi.max(c + Pt(1, 1, 1))
    }
    var air = mutableSetOf(lo, hi)
    var frontier = ArrayDeque<Pt>(air)
    while (!frontier.isEmpty()) {
        frontier.addAll(
            frontier.removeFirst().adj().filter {
                (lo.x..hi.x).contains(it.x) && (lo.y..hi.y).contains(it.y) && (lo.z..hi.z).contains(it.z)
                && !lava.contains(it) && air.add(it)
            })
    }
    val p2 = lava.flatMap { it.adj() }.count { air.contains(it) }
    println("Part 2: %20d".format(p2))
}
