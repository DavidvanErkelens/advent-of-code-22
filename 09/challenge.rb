require 'set'

Location = Struct.new(:x, :y) do
  def to_str
    "#{x}-#{y}"
  end
end

def do_step (knots, dx, dy, visited_locations)
  knots[0].x += dx
  knots[0].y += dy

  knots.each_with_index do |knot, index|
    if index == 0
      next
    end

    if knot.x == knots[index -1].x && (knot.y - knots[index -1].y).abs > 1
      knot.y += knots[index - 1].y > knot.y ? 1 : -1
    elsif knot.y == knots[index-1].y && (knot.x - knots[index-1].x).abs > 1
      knot.x += knots[index -1].x > knot.x ? 1 : -1
    elsif (knot.x - knots[index - 1].x).abs > 1 || (knot.y - knots[index - 1].y).abs > 1
      knot.x += knots[index -1].x > knot.x ? 1 : -1
      knot.y += knots[index - 1].y > knot.y ? 1 : -1
    else
      break
    end
  end

  visited_locations.add(knots[-1].to_str)

end

def print_grid (knots, width, height)
  (0...height).each do |y|
    (0...width).each do |x|
      printed = false
      knots.each_with_index do |knot, index|
        if knot.x == x - 10 && knot.y == y - 10
          print index
          printed = true
          break
        end
      end
      unless printed
        print '.'
      end
    end
    print "\n"
  end
  print "\n"
  STDOUT.flush
end

lines = File.readlines("input/input.txt").map(&:chomp)
knots = [
  Location.new(0, 0), # H
  Location.new(0, 0), # 1 (comment all lines below this one for part 1)
  Location.new(0, 0), # 2
  Location.new(0, 0), # 3
  Location.new(0, 0), # 4
  Location.new(0, 0), # 5
  Location.new(0, 0), # 6
  Location.new(0, 0), # 7
  Location.new(0, 0), # 8
  Location.new(0, 0), # 9
]

visited_locations = Set.new([knots[-1].to_str])

lines.each do |line|
  instr = line.split(" ")
  num = instr[1].to_i
  dx = 0
  dy = 0
  case (instr[0])
  when "R"
    dx = 1
  when "U"
    dy = 1
  when "D"
    dy = -1
  when "L"
    dx = -1
  else
    puts "Unknown instruction #{instr[0]}"
  end

  (0...num).each do |_|
    do_step knots, dx, dy, visited_locations
  end
end

puts visited_locations.length