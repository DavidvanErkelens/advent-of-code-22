#!/usr/local/bin/lua

Monkey = {
    items = {},
    fn = function(value) return value end,
    divisor = 1,
    nextIfTrue = 1,
    nextIfFalse = 1,
    itemsInspected = 0
}

function Monkey:new(items, fn, divisor, nextIfTrue, nextIfFalse)
    o = {
        items = items, fn = fn, divisor = divisor, nextIfTrue = nextIfTrue, nextIfFalse = nextIfFalse
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

function Monkey:print()
    print("Monkey holds items: ")
    for _, item in ipairs(self.items) do
        print("- " .. item)
    end
    print("It has done " .. self.itemsInspected .. " inspections")
    print("")
end

example_monkeys = {
    [1] = Monkey:new( {79, 98}, function(item) return item * 19  end, 23, 2, 3),
    [2] = Monkey:new( {54, 65, 75, 74}, function(item) return item + 6  end, 19, 2, 0),
    [3] = Monkey:new( {79, 60, 97}, function(item) return item * item  end, 13, 1, 3),
    [4] = Monkey:new( {74}, function(item) return item + 3  end, 17, 0, 1),
}
example_div_lcm = 96577

monkeys = {
    [1] = Monkey:new ({ 56, 56, 92, 65, 71, 61, 79 }, function (item) return  item * 7 end, 3, 3, 7),
    [2] = Monkey:new ({ 61, 85 }, function (item) return  item + 5 end, 11, 6, 4),
    [3] = Monkey:new ({ 54, 96, 82, 78, 69 }, function (item) return  item * item end,  7, 0, 7),
    [4] = Monkey:new ({ 57, 59, 65, 95 }, function (item) return  item + 4 end,  2, 5, 1),
    [5] = Monkey:new ({ 62, 67, 80 }, function (item) return  item * 17 end, 19, 2, 6),
    [6] = Monkey:new ({ 91 }, function (item) return  item + 7 end,  5, 1, 4),
    [7] = Monkey:new ({ 79, 83, 64, 52, 77, 56, 63, 92 }, function (item) return  item + 6 end, 17, 2, 0),
    [8] = Monkey:new ({ 50, 97, 76, 96, 80, 56 }, function (item) return  item + 3 end, 13, 3, 5),
}
div_lcm = 9699690

-- part 1:
--rounds = 20
rounds = 10000

for i = 1, rounds do
    for i, monkey in ipairs(monkeys) do
        for j, item in ipairs(monkey.items) do
            valueAfterInspection = monkey.fn(item)
            --valueBeforeTest = math.floor(valueAfterInspection / 3) -- part 1
            valueBeforeTest = valueAfterInspection % div_lcm
            if valueBeforeTest % monkey.divisor == 0 then
                nextMonkey = monkey.nextIfTrue + 1 -- lua is 1-indexed :(
                monkeys[nextMonkey].items[#monkeys[nextMonkey].items + 1] = valueBeforeTest
            else
                nextMonkey = monkey.nextIfFalse + 1 -- lua is 1-indexed :(
                monkeys[nextMonkey].items[#monkeys[nextMonkey].items + 1] = valueBeforeTest
            end
            monkey.itemsInspected = monkey.itemsInspected + 1
        end
        monkey.items = {}
        --break
    end
end

inspections = {}

for i, monkey in ipairs(monkeys) do
    inspections[#inspections + 1] = monkey.itemsInspected
end

table.sort(inspections, function(a, b)  return a > b end)

print("Answer: " .. (inspections[1] * inspections[2]))