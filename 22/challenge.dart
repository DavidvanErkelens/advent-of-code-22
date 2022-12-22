import 'dart:io';

class Position {
  int x;
  int y;
  int direction;

  Position(this.x, this.y, this.direction) {}
}

void printGrid(List<List<String>> grid) {
  for (var line in grid) {
    print(line.join());
  }
}

int getCurrentArea(int x, int y) {
  if (x >= 50 && x < 100 && y >= 0 && y < 50) return 1;
  if (x >= 100 && y >= 0 &&  x < 150 && y < 50) return 2;
  if (x >= 50 && y >= 50 &&  x < 100 && y < 100) return 3;
  if (x >= 0 && y >= 100 &&  x < 50 && y <  150) return 4;
  if (x >= 50 && y >= 100 &&  x < 100 && y < 150) return 5;
  if (x >= 0 && y >= 150 &&  x < 50 && y <  200) return 6;
  return 0;
}

Position getNextPosition(Position pos, List<List<String>> grid, bool isPartOne)
{
  final directions = [[1,0], [0,1], [-1, 0], [0,-1]];
  final currentArea = getCurrentArea(pos.x, pos.y);

  final RIGHT = 0;
  final DOWN = 1;
  final LEFT = 2;
  final UP = 3;

  final dX = directions[pos.direction][0];
  final dY = directions[pos.direction][1];

  final width = grid[0].length;
  final height = grid.length;


  var nextX = pos.x + dX;
  var nextY = pos.y + dY;

  if (isPartOne) {

    while(true) {
      nextX %= width;
      nextY %= height;
      if (grid[nextY][nextX] == ' ') {
        nextX += dX ;
        nextY += dY;
      } else {
        break;
      }
    }
    return Position(nextX, nextY, pos.direction);
  }

  if (getCurrentArea(nextX, nextY) == currentArea) {
    return Position(nextX, nextY, pos.direction);
  }

  if (currentArea == 1) {
    if (dX == 1) {
      // move to 2, no translation
      return Position(nextX, nextY, pos.direction);
    }
    if (dY == 1) {
      // move to 3, no translation
      return Position(nextX, nextY, pos.direction); 
    }
    if (dX == -1) {
      // move to 4, needs translation
      return Position(0, 149 - nextY, RIGHT);
    }
    if (dY == -1) {
      // move to 6
      return Position(0, nextX + 100, RIGHT);
    }
  }
  if (currentArea == 2) {
    if (dX == 1) {
      // move to 5
      return Position(99, 149 - nextY, LEFT);
    }
    if (dY == 1) {
      // move to 3
      return Position(99, nextX, LEFT);
    }
    if (dX == -1) {
      // move to 1, no translation needed
      return Position(nextX, nextY, pos.direction);
    }
    if (dY == -1) {
      // move to 6, only wrap
      return Position(nextX - 100, 199, pos.direction);
    }
  }
  if (currentArea == 3) {
    if (dX == 1) {
      // move to 2
      return Position(nextY + 50, 49, UP);
    }
    if (dY == 1) {
      // move to 5, no translation needed
      return Position(nextX, nextY, pos.direction);
    }
    if (dX == -1) {
      // move to 4
      return Position(nextY - 50, 100, DOWN);
    }
    if (dY == -1) {
      // move to 1, no translation needed
      return Position(nextX, nextY, pos.direction);
    }
  }
  if (currentArea == 4) {
    if (dX == 1) {
      // move to 5, no translation needed
      return Position(nextX, nextY, pos.direction);
    }
    if (dY == 1) {
      // move to 6, no translation needed
      return Position(nextX, nextY, pos.direction);
    }
    if (dX == -1) {
      // move to 1
      return Position(50, 149 - nextY, UP);
    }
    if (dY == -1) {
      // move to 3
      return Position(50, nextX + 50, RIGHT);
    }
  }
  if (currentArea == 5) {
    if (dX == 1) {
      // move to 2
      return Position(149, 149 - nextY, LEFT);
    }
    if (dY == 1) {
      // move to 6
      return Position(49, nextX + 100, LEFT);
    }
    if (dX == -1) {
      // move to 4, no translation needed
      return Position(nextX, nextY, pos.direction);
    }
    if (dY == -1) {
      // move to 3, no translation needed
      return Position(nextX, nextY, pos.direction);
    }
  }
  if (currentArea == 6) {
    if (dX == 1) {
      // move to 5
      return Position(nextY - 100, 149, UP);
    }
    if (dY == 1) {
      // move to 2, only wrap
      return Position(nextX + 100, 0, pos.direction);
    }
    if (dX == -1) {
      // move to 1
      return Position(nextY - 100, 0, DOWN);
    }
    if (dY == -1) {
      // move to 4, no translation needed
      return Position(nextX, nextY, pos.direction);
    }
  }

  throw new Error();
}

void main() async {

  final file = File('input/input.txt');

  List<String> data = (await file.readAsString()).split("\n\n");
  var grid = data[0].split("\n").map((e) => e.padRight(150)).map((e) => e.split("")).toList();


  RegExp exp = RegExp(r'([0-9]+|R|L]?)');
  final instructions = exp.allMatches(data[1]).toList();

  var startX = grid[0].indexWhere((element) => element == ".");

  solve(startX, instructions, grid, true);
  solve(startX, instructions, grid, false);
}

void solve(int startX, List<RegExpMatch> instructions, List<List<String>> grid, bool isPartOne) {
  var currentPos = Position(startX, 0, 0);

  for (var instruction in instructions) {
    var instr = instruction[0]!;
    var intVal = int.tryParse(instr);
    if (intVal == null) {
      if (instr == "R") {
        currentPos.direction += 1;
      } else {
        currentPos.direction -= 1;
      }
      currentPos.direction %= 4;
    } else {
      for (var i = 0; i < intVal; i++) {
        var nextPos = getNextPosition(currentPos, grid, isPartOne);

        if (grid[nextPos.y][nextPos.x] == '#') {
          break;
        }

        if (grid[nextPos.y][nextPos.x] == ' ') {
          throw new Error();
        }

        currentPos = nextPos;
      }
    }
  }


  print("Final position: ${currentPos.x}, ${currentPos.y}");

  final lastRow = currentPos.y + 1;
  final lastColumn = currentPos.x + 1;

  print("Score: ${1000 * lastRow + 4 * lastColumn + currentPos.direction}");
}