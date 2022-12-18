import java.util.ArrayDeque

data class Pt(val x: Int, val y: Int, val z: Int) {
    fun adj(): List<Pt> {
        return listOf(Pt(x+1, y, z), Pt(x-1, y, z),
                      Pt(x, y+1, z), Pt(x, y-1, z),
                      Pt(x, y, z+1), Pt(x, y, z-1))
    }
}

fun main() {
    println("Day 18: Kotlin")
    var space = mutableSetOf<Pt>()
    var p1 = 0
    var p2 = 0
    for (line in generateSequence(::readLine)) {
        val pts = line.split(",")
        val c = Pt(pts[0].toInt(), pts[1].toInt(), pts[2].toInt())
        p1 += 6
        for (c2 in c.adj()) {
            if (space.contains(c2)) {
                p1 -= 2
            }
        }
        space.add(c)
    }
    println("Part 1: %20d".format(p1))
    var minX = Int.MAX_VALUE
    var maxX = Int.MIN_VALUE
    var minY = Int.MAX_VALUE
    var maxY = Int.MIN_VALUE
    var minZ = Int.MAX_VALUE
    var maxZ = Int.MIN_VALUE
    for (c in space) {
        minX = minOf(minX, c.x-1)
        maxX = maxOf(maxX, c.x+1)
        minY = minOf(minY, c.y-1)
        maxY = maxOf(maxY, c.y+1)
        minZ = minOf(minZ, c.z-1)
        maxZ = maxOf(maxZ, c.z+1)
    }
    val topLeft = Pt(minX, minY, minZ)
    val botRight = Pt(maxX, maxY, maxZ)
    var visited = mutableSetOf(topLeft, botRight)
    var frontier = ArrayDeque<Pt>()
    frontier.add(topLeft)
    frontier.add(botRight)
    while (!frontier.isEmpty()) {
        val pt = frontier.remove()
        for (pt2 in pt.adj()) {
            if (pt2.x < minX || pt2.x > maxX || pt2.y < minY || pt2.y > maxY || pt2.z < minZ || pt2.z > maxZ) {
                continue
            }
            if (space.contains(pt2)) {
                p2 += 1
                continue
            }
            if (visited.add(pt2)) {
                frontier.add(pt2)
            }
        }
    }
    println("Part 2: %20d".format(p2))
}
