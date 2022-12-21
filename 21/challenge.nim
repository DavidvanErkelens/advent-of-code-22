import strutils
import std/sequtils
import std/sugar
import std/math
import tables

let fileContents = readFile("input/input.txt")
let lines = fileContents.splitLines().filter(x => not isEmptyOrWhitespace(x))

var monkeysToSolve = initTable[string, string]()
var monkeysWithAnswer = initTable[string, float64]()

for line in lines:
  let monkey = line.split(": ")
  try:
    let parsedValue = parseInt(monkey[1]).float
    monkeysWithAnswer[monkey[0]] = parsedValue
  except:
    monkeysToSolve[monkey[0]] = monkey[1]

proc solve(toSolve: Table[string, string], withAnswer: Table[string, float64], isPartOne: bool): float64 =
  var monkeysToSolve = toSolve
  var monkeysWithAnswer = withAnswer
  while true:
    var solved = newSeq[string]()
    for name, sum in pairs(monkeysToSolve):
      let split = sum.split(" ")
      let (left, op, right) = (split[0], split[1], split[2])
      if monkeysWithAnswer.hasKey(left) and monkeysWithAnswer.hasKey(right):
        if not isPartOne and name == "root":
          return monkeysWithAnswer[left]
        if op == "-":
          monkeysWithAnswer[name] = monkeysWithAnswer[left] - monkeysWithAnswer[right]
        if op == "+":
          monkeysWithAnswer[name] = monkeysWithAnswer[left] + monkeysWithAnswer[right]
        if op == "/":
          monkeysWithAnswer[name] = monkeysWithAnswer[left] / monkeysWithAnswer[right]
        if op == "*":
          monkeysWithAnswer[name] = monkeysWithAnswer[left] * monkeysWithAnswer[right]
        solved.add(name)
        if name == "root":
          break
    if monkeysWithAnswer.hasKey("root"):
      break
    for monkey in solved:
      monkeysToSolve.del(monkey)

  return monkeysWithAnswer["root"]

# Part one
var partOne = solve(monkeysToSolve, monkeysWithAnswer, true)
echo "Outcome part one: " & $partOne.int

# input is somewhere in between these two
var lowerBound: int64 = 1
var upperBound = 5000000000000

# output of the right part of the monkey for 'root', irrespective of 'humn'
var wanted = float(5697586809113)

while true:
  var test = lowerBound + ((upperBound - lowerBound) div 2)

  monkeysWithAnswer["humn"] = test.float

  var output = solve(monkeysToSolve, monkeysWithAnswer, false)

  if output == wanted:
    echo "Got it! Answer for part 2 is " & $test
    break

  if output > wanted:
    lowerBound = test
  else:
    upperBound = test



