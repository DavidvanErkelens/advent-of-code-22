import scala.collection.mutable
import scala.collection.mutable.ArrayBuffer
import scala.io.Source
import scala.util.control.Breaks.break

class Point(val x: Int, val y: Int):
  def generatePermutations(): List[Point] = {
    List[Point](
      new Point(x - 1, y),
      new Point(x + 1, y),
      new Point(x, y - 1),
      new Point(x, y + 1),
    )
  }
end Point

class Path(val currentPoint: Point, val cost: Int)

end Path

class Grid(val grid: Array[Array[String]], val costs: Array[Array[Int]]):

  private val height = grid.length
  private val width = grid(0).length

  def print(): Unit =
    grid.foreach(x => println(x.mkString))


  def isInRange(point: Point): Boolean =
    point.x >= 0 && point.y >= 0 && point.x < width && point.y < height

  def getStartPoint: Point =
    var point = new Point(0,0)
    for (y <- 0 until height) {
      for (x <- 0 until width) {
        if (grid(y)(x) == "S") point = Point(x, y)
      }
    }
    point

  def getAllLowestPoints(): Array[Point] =
    val list = new ArrayBuffer[Point]()
    for (y <- 0 until height) {
      for (x <- 0 until width) {
        if (grid(y)(x) == "a") list.append(new Point(x, y))
      }
    }
    list.toArray

  def canMoveTo(from: Point, to: Point): Boolean =
    if (!isInRange(to)) return false

    var fromValue = grid(from.y)(from.x)
    if (fromValue == "S") fromValue = "a"

    var toValue = grid(to.y)(to.x)
    if (toValue == "E") toValue = "z"

    toValue.charAt(0).intValue - fromValue.charAt(0).intValue <= 1

  def isValidNextStep(path: Path): Boolean =
    if (path.currentPoint.x == 0 && path.currentPoint.y == 0) return false

    val cheapestCostSoFar = costs(path.currentPoint.y)(path.currentPoint.x)
    if (cheapestCostSoFar > 0 && cheapestCostSoFar <= path.cost) return false

    costs(path.currentPoint.y)(path.currentPoint.x) = path.cost

    true

  def isEndPoint(point: Point): Boolean =
    grid(point.y)(point.x) == "E"
end Grid

object Grid {
  def buildFromFile(file: List[String]): Grid = {
    val grid = file.map(_.split("")).toArray
    val costs = Array.ofDim[Int](grid.length, grid(0).length)
    new Grid(grid, costs)
  }
}

object Main {
  def main(args: Array[String]): Unit = {
    val filename = "input/input.txt"
    val source = Source.fromFile(filename)

    val linesInFile = source.getLines().toList
    source.close()

    val grid = Grid.buildFromFile(linesInFile)
    grid.print()

    var lowestCost = 400
    grid.getAllLowestPoints().foreach(x => {
      val score = getLowestCostToTop(x, grid, lowestCost)
      if score > 0 then {
        lowestCost = Math.min(score, lowestCost)
      }
    })

    printf("The shortest path from any 'a' to 'E' is %d\n", lowestCost)
  }

  private def getLowestCostToTop(startPoint: Point, grid: Grid, stopAt: Int): Int =
    var lowestCost = 0
    try
      val paths = mutable.PriorityQueue.empty[Path](Ordering.by(-_.cost))
      val startPath = Path(startPoint, 0)
      paths.enqueue(startPath)

      while (paths.nonEmpty) {
        val path = paths.dequeue()
        if (grid.isEndPoint(path.currentPoint)) {
          printf("Reached endpoint after %d steps\n", path.cost)
          lowestCost = path.cost
          break
        }

        if (path.cost > stopAt) {
          printf("No path found with a length under %d\n", stopAt)
          break
        }

        val nextPaths = path.currentPoint
          .generatePermutations()
          .filter(x => grid.isInRange(x))
          .filter(x => grid.canMoveTo(path.currentPoint, x))
          .map(x => new Path(x, path.cost + 1))
        nextPaths.foreach(p => {
          if (grid.isValidNextStep(p)) {
            paths.enqueue(p)
          }
        })
      }

      lowestCost
    finally
      return lowestCost
}