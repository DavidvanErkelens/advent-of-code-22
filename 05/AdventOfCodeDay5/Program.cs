using System.Text.RegularExpressions;

string text = File.ReadAllText("../../../input/input.txt");
string[] parts = text.Split("\n\n");

string[] crateLines = parts[0].Split("\n").Reverse().ToArray();
char[][] explodedCrateLines = crateLines.Select(x => x.ToCharArray()).ToArray();

char[] topLine = explodedCrateLines[0];

Dictionary<int, Stack<char>> stacks = new Dictionary<int, Stack<char>>();

for (int i = 0; i < topLine.Length; i++)
{
    if (topLine[i] != ' ')
    {
        int number = topLine[i] - '0';
        var stack = new Stack<char>();

        for (int j = 1; j < crateLines.Length; j++)
        {
            char element = explodedCrateLines[j][i];
            if (element != ' ') stack.Push(element);
            else break;
        }

        stacks.Add(number, stack);
    }
}

PrintCrates(stacks);

string[] instructions = parts[1].Split("\n");
Regex instructionRegex = new Regex("move ([0-9]+) from ([0-9]+) to ([0-9]+)");

foreach (var instruction in instructions)
{
    var match = instructionRegex.Match(instruction);
    var number = Int32.Parse(match.Groups[1].Captures[0].Value);
    var from = Int32.Parse(match.Groups[2].Captures[0].Value);
    var to = Int32.Parse(match.Groups[3].Captures[0].Value);

    // Part 1:
    // for (int i = 0; i < number; i++)
    // {
    //     char item = stacks[from].Pop();
    //     stacks[to].Push(item);
    // }

    // Part 2:
    char[] items = new char[number];
    for (int i = 0; i < number; i++)
    {
        items[i] = stacks[from].Pop();
    }

    foreach (var item in items.Reverse())
    {
        stacks[to].Push(item);
    }
}

PrintCrates(stacks);
GetOutput(stacks);

void PrintCrates(Dictionary<int, Stack<char>> stacks)
{
    foreach (KeyValuePair<int,Stack<char>> stack in stacks)
    {
        Console.Write($"{stack.Key}: ");
        foreach (var c in stack.Value.Reverse())
        {
            Console.Write($"[{c}] ");
        }

        Console.WriteLine();
    }
}

void GetOutput(Dictionary<int, Stack<char>> stacks)
{
    Console.Write("The value: ");
    foreach (var stack in stacks.Values)
    {
        Console.Write(stack.Peek());
    }

    Console.WriteLine();
}
