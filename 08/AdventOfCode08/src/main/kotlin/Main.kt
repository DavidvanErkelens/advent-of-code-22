import java.io.File
import kotlin.math.max

fun main() {
    val lines = readFileAsLinesUsingUseLines("input/input.txt")
    val grid = Array<Array<Int>>(lines.size) { arrayOf() }
    for ((i, line) in lines.withIndex()) {
        val numbers = line.split("").filter { it != "" }
        grid[i] = numbers.map { it.toInt() }.toTypedArray()
    }

    val alongLines = 2 * (grid.size) + (2 * (grid[0].size - 2))
    var visible = 0
    var bestScore = 0

    for (x in 1 until grid[0].size - 1) {
        for (y in 1 until grid.size - 1) {
            // part 1:
            if (isVisibleFromOutside(grid, x, y)) visible += 1

            // part 2:
            bestScore = max(getScenicScore(grid, x, y), bestScore)
        }
    }

    // part 1:
    println(String.format("Outer size: %d, visible: %d, total trees seen: %d", alongLines, visible, (alongLines + visible)))

    // part 2:
    println(String.format("Best scenic score: %d", bestScore))
}

fun isVisibleFromOutside(grid: Array<Array<Int>>, x: Int, y: Int): Boolean {
    val height = grid[y][x]

    // visible from top?
    var fromTop = true
    for (i in 0 until y) if (grid[i][x] >= height) fromTop = false
    if (fromTop) return true

    // visible from bottom?
    var fromBottom = true
    for (i in y + 1 until grid.size) if (grid[i][x] >= height) fromBottom = false
    if (fromBottom) return true

    // visible from left?
    var fromLeft = true
    for (i in 0 until x) if (grid[y][i] >= height) fromLeft = false
    if (fromLeft) return true

    // visible from right?
    var fromRight = true
    for (i in x + 1 until grid[0].size) if (grid[y][i] >= height) fromRight = false
    if (fromRight) return true

    return false

}

fun getScenicScore(grid: Array<Array<Int>>, x: Int, y: Int): Int {
    var totalTreesSeenUp = 0
    var totalTreesSeenDown = 0
    var totalTreesSeenLeft = 0
    var totalTreesSeenRight = 0
    val height = grid[y][x]

    // look up (change y)
    for (i in y - 1 downTo  0) {
        // even if the view is blocked the tree counts
        totalTreesSeenUp += 1
        if (grid[i][x] >= height) break
    }

    // look down
    for (i in y + 1 until grid.size) {
        totalTreesSeenDown += 1
        if (grid[i][x] >= height) break
    }

    // look left
    for (i in x - 1 downTo  0) {
        totalTreesSeenLeft += 1
        if (grid[y][i] >= height) break
    }

    // look right
    for (i in x + 1 until grid[0].size) {
        totalTreesSeenRight += 1
        if (grid[y][i] >= height) break
    }

    return totalTreesSeenUp * totalTreesSeenDown * totalTreesSeenLeft * totalTreesSeenRight
}

fun readFileAsLinesUsingUseLines(fileName: String): List<String>
    = File(fileName).useLines { it.toList() }
