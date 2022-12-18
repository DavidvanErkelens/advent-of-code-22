fs = require 'fs'

class Grid
  constructor: ->
    @grid =
      [0...50].map (x) ->
        [0..50].map (y) ->
          [0..50].map (z) -> 0
    @points = []

  add_line: (line) ->
    params = line.split ','
    [x, y, z] = params.map (x) -> parseInt(x, 10)
    @grid[x][y][z] = 1
    @points.push [x, y, z]

  do_fill: ->
    points_to_check = [[0,0,0]]

    while points_to_check.length > 0
      [x, y, z] = points_to_check.pop()
      if x < 0 || x >= 50 || y < 0 || y >= 50 || z < 0 || z >= 50
        continue
      if @grid[x][y][z] == 0
        @grid[x][y][z] = 2
        points_to_check.push([x-1,y,z])
        points_to_check.push([x+1,y,z])
        points_to_check.push([x,y-1,z])
        points_to_check.push([x,y+1,z])
        points_to_check.push([x,y,z-1])
        points_to_check.push([x,y,z+1])

  get_surface_area: ->
    total = 0
    for point in @points
      total += @get_surface_area_for_point(point)
    return total

  get_surface_area_for_point: (point) ->
    [x, y, z] = point
    area = 0

    if (x == 0 || (x > 0 && @grid[x-1][y][z] == 2))
      area += 1
    if (x < 50 && @grid[x+1][y][z] == 2)
      area += 1
    if (y == 0 || (y > 0 && @grid[x][y-1][z] == 2))
      area += 1
    if (y < 50 && @grid[x][y+1][z] == 2)
      area += 1
    if (z == 0 || (z > 0 && @grid[x][y][z-1] == 2))
      area += 1
    if (z < 50 && @grid[x][y][z+1] == 2)
      area += 1

    return area


test = fs.readFileSync 'input/input.txt', 'utf-8'
lines = test.split /\r?\n/

grid = new Grid()

for line in lines
  grid.add_line line

grid.do_fill()

console.log grid.get_surface_area()
