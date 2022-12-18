fs = require 'fs'

class Cube
  constructor: (line) ->
    params = line.split ','
    [@x, @y, @z] = params.map (x) -> parseInt(x, 10)

  print: ->
    console.log "#{@x},#{@y},#{@z}"

  distanceTo: (other) ->
    return Math.abs(@x - other.x) + Math.abs(@y - other.y) + Math.abs(@z - other.z)

test = fs.readFileSync 'input/example.txt', 'utf-8'
lines = test.split /\r?\n/
cubes = lines.map (line) -> new Cube line

overlaps = 0

for outer in cubes
  do (outer) ->
    for inner in cubes
      do (inner) ->
        if outer.distanceTo(inner) == 1
          overlaps += 1

console.log(cubes.length * 6 - overlaps)