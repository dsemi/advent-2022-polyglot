import scala.io.Source.stdin
import scala.collection.mutable.ArrayBuffer
import scala.collection.mutable.Set

case class Sensor(x: Long, y: Long, dist: Long)

case class Interval(lo: Long, hi: Long) {
  def union(o: Interval): Interval = Interval(lo min o.lo, hi max o.hi)

  def len(): Long = hi - lo
}

case class Line(sx: Long, sy: Long, ex: Long, ey: Long) {
  def intersect(o: Line): Option[(Long, Long)] = {
    if (sx <= o.ex && o.sx <= ex && sy <= o.sy && o.ey <= ey) {
      val (p1, p2) = (o.sx + o.sy, sx - sy)
      return Some(((p1 + p2) / 2, (p1 - p2) / 2))
    }
    None
  }
}

@main def main() = {
  println("Day 15: Scala")
  var sensors = ArrayBuffer[Sensor]()
  var bs = Set[Long]()
  for (ln <- stdin.getLines) {
    val pts = ln.split("=|:|,")
    val (sx, sy, bx, by) = (pts(1).toInt, pts(3).toInt, pts(5).toInt, pts(7).toInt)
    val dist = (sx - bx).abs + (sy - by).abs
    sensors += Sensor(sx, sy, dist)
    if (by == 2000000) bs += bx
  }
  var intervals = ArrayBuffer[Interval]()
  var urs = ArrayBuffer[Line]()
  var drs = ArrayBuffer[Line]()
  for (s <- sensors) {
    val diff = s.dist - (s.y - 2000000).abs
    if (diff >= 0) intervals += Interval(s.x - diff, s.x + diff + 1)
    urs += Line(s.x - s.dist - 1, s.y, s.x, s.y + s.dist + 1)
    urs += Line(s.x, s.y - s.dist - 1, s.x + s.dist + 1, s.y)
    drs += Line(s.x, s.y + s.dist + 1, s.x + s.dist + 1, s.y)
    drs += Line(s.x - s.dist - 1, s.y, s.x, s.y - s.dist - 1)
  }
  val interval = intervals.sortWith(_.lo < _.lo).reduce(_.union(_))
  val p1 = interval.len() - bs.count(interval.lo until interval.hi contains _)
  println("Part 1: %20d".format(p1))
  for (a <- urs) {
    for (b <- drs) {
      a.intersect(b) match {
        case Some((x, y)) => {
          if (x >= 0 && x <= 4000000 && y >= 0 && y <= 4000000
            && sensors.forall((s) => (x - s.x).abs + (y - s.y).abs > s.dist)) {
            println("Part 2: %20d".format(4000000*x + y))
            System.exit(0)
          }
        }
        case None =>
      }
    }
  }
}
