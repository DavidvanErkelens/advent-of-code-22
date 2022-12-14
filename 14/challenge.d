#!/usr/bin/env rdmd

import std.stdio;
import std.file;
import std.string;
import std.conv;
import std.algorithm;

class Point
{
    int x, y;

    this(int x, int y)
    {
        this.x = x;
        this.y = y;
    }

    this(string from)
    {
        string[] split = from.split(",");
        x = to!int(split[0]);
        y = to!int(split[1]);
    }

    string to_string()
    {
        return "(" ~ to!string(x) ~ "," ~ to!string(y) ~ ")";
    }
}

class Line
{
    Point from, to;

    this(string from, string to)
    {
        this.from = new Point(from);
        this.to = new Point(to);
    }

    void print_line()
    {
        writeln("Line from ", from.to_string(), " to ", to.to_string());
    }

    Point[] get_all_points()
    {
        Point[] points;

        if (this.from.y == this.to.y) {
            for (int x = min(this.from.x, this.to.x); x <= max(this.from.x, this.to.x); x++) {
                points ~= new Point(x, this.from.y);
            }
        }

        if (this.from.x == this.to.x) {
            for (int y = min(this.from.y, this.to.y); y <= max(this.from.y, this.to.y); y++) {
                points ~= new Point(this.from.x, y);
            }
        }

        return points;
    }
}

class Grid
{
    char[][] grid;
    int maxY = 5;
    int minX = 495;
    int maxX = 505;

    this(string[] lines)
    {
        Line[] parsedLines;
        foreach (string line; lines) {
            string[] points = line.split(" -> ");
            for (int i = 1; i < points.length; i++) {
                auto parsedLine = new Line(points[i - 1], points[i]);
                parsedLines ~= parsedLine;
                maxY = max(maxY, max(parsedLine.from.y, parsedLine.to.y));
                maxX = max(maxX, max(parsedLine.from.x, parsedLine.to.x));
                minX = min(minX, min(parsedLine.from.x, parsedLine.to.x));
            }
        }

        // these values are for part 2, part 1 can use 2 or so instead of 150.
        minX -= 150;
        maxX += 150;
        maxY += 2;

        grid = new char[][](maxY + 1, maxX - minX + 1);

        foreach (Line parsedLine; parsedLines) {
            parsedLine.print_line();
            foreach (Point p; parsedLine.get_all_points()) {
                write_value_to_grid(p.x, p.y, '#');
            }
        }

        write_value_to_grid(500, 0, '+');
    }

    void print_grid()
    {
        for (int i = 0; i <= this.maxY; i++) {
            for (int j = minX; j <= this.maxX; j++) {
                printf("%c", get_value_from_grid(j, i));
            }
            printf("\n");
        }
    }

    char get_value_from_grid(int x, int y)
    {
        // extra for part 2:
        if (y >= maxY) return '#';

        char val = grid[y][x - minX];
        char def;
        if (val == def) return '.'; // catch default value of 'char' as '.' so we don't have to init the entire grid
        return val;
    }

    void write_value_to_grid(int x, int y, char value)
    {
        grid[y][x - minX] = value;
    }

    int let_it_snow()
    {
        int rested_sands = 0;

        Point sand_location = new Point(500, 0);
        write_value_to_grid(500, 0, 'o');

        while (true) {
            // check if free falling (enable for part 1)
            //if (sand_location.y >= maxY) {
            //    break;
            //}

            // check if can move down
            if (get_value_from_grid(sand_location.x, sand_location.y + 1) == '.') {
                write_value_to_grid(sand_location.x, sand_location.y, '.');
                sand_location.y += 1;
                write_value_to_grid(sand_location.x, sand_location.y, 'o');
                continue;
            }

            // check if can move diagonal left
            if (get_value_from_grid(sand_location.x - 1, sand_location.y + 1) == '.') {
                write_value_to_grid(sand_location.x, sand_location.y, '.');
                sand_location.y += 1;
                sand_location.x -= 1;
                write_value_to_grid(sand_location.x, sand_location.y, 'o');
                continue;
            }

            // check if can move diagonal right
            if (get_value_from_grid(sand_location.x + 1, sand_location.y + 1) == '.') {
                write_value_to_grid(sand_location.x, sand_location.y, '.');
                sand_location.y += 1;
                sand_location.x += 1;
                write_value_to_grid(sand_location.x, sand_location.y, 'o');
                continue;
            }

            // we're stuck, see if we're at start, then we can stop
            rested_sands += 1;
            if (sand_location.x == 500 && sand_location.y == 0) break;

            // sand is stuck, let's start again
            sand_location.x = 500;
            sand_location.y = 0;
            write_value_to_grid(500, 0, 'o');
        }

        return rested_sands;
    }
}

void main()
{
    auto file = File("input/input.txt", "r");

    string[] lines;

    while (!file.eof()) {
        lines ~= chomp(file.readln());
    }

    auto grid = new Grid(lines);
    grid.print_grid();

    auto number = grid.let_it_snow();
    writeln("The answer is: ", number);
}