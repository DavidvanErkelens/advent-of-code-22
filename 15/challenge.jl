regex = r"^Sensor at x=(-?[0-9]+), y=(-?[0-9]+): closest beacon is at x=(-?[0-9]+), y=(-?[0-9]+)$"

struct Point
    x::Int
    y::Int
end

struct Sensor
    location::Point
    beacon::Point
end

function line_to_sensor(line::String)::Sensor
    m = match(regex, line)
    location = Point(parse(Int, m[1]), parse(Int, m[2]))
    beacon = Point(parse(Int, m[3]), parse(Int, m[4]))
    return Sensor(location, beacon)
end

distance_between_points(p1::Point, p2::Point)::Int =
    abs(p1.x - p2.x) + abs(p1.y - p2.y)

distance_between_sensor_and_beacon(sensor::Sensor)::Int =
    distance_between_points(sensor.location, sensor.beacon)

function sensor_points_at_line(y::Int, sensor::Sensor)::Set{Int}
    set = Set{Int}()

    sensor_reach = distance_between_sensor_and_beacon(sensor)
    if (sensor.location.y - sensor_reach > y) return set end
    if (sensor.location.y + sensor_reach < y) return set end

    y_dist = abs(sensor.location.y - y)
    reach_horizontal = sensor_reach - y_dist

    foreach(x -> push!(set, x), range(max(0,sensor.location.x - reach_horizontal), min(4000000,sensor.location.x + reach_horizontal)))

    return set
end

function sensors_points_at_line(y::Int, sensors::Array{Sensor})::Set{Int}
    set = Set{Int}()
    for sensor in sensors
        if sensor.beacon.y == y
            set = setdiff(set, [sensor.beacon.x])
        end
    end
    return set
end

function is_in_reach(point::Point, sensor::Sensor)::Bool
     sensor_reach = distance_between_sensor_and_beacon(sensor)
     return distance_between_points(point, sensor.location) <= sensor_reach
end

is_in_limit(point::Point)::Bool =
    point.x >= 0 && point.x <= 4000000 && point.y >= 0 && point.y <= 4000000

function get_points_just_outside_reach(sensor::Sensor)::Array{Point}
    points = Point[]
    outside_sensor_reach = distance_between_sensor_and_beacon(sensor) + 1

    for y in range(sensor.location.y - outside_sensor_reach, sensor.location.y + outside_sensor_reach)
        dy = abs(sensor.location.y - y)
        dx = outside_sensor_reach - dy
        push!(points, Point(sensor.location.x + dx, y))
        push!(points, Point(sensor.location.x - dx, y))
    end

    return points
end

lines = readlines("input/input.txt")

sensors = Sensor[]
for line in lines
    sensor = line_to_sensor(line)
    push!(sensors, sensor)
end

# Part 1:
covered_positions = sensors_points_at_line(2000000, sensors)
println(length(covered_positions))

# Part 2
checked_points = Set{Point}()
for sensor in sensors
    done = false
    for point in get_points_just_outside_reach(sensor)
        if ! is_in_limit(point) continue end
        if point in checked_points continue end
        seen_by_other = false
        for other_sensor in sensors
            if sensor.location.x == other_sensor.location.x && sensor.location.y == sensor.location.y continue end
            if is_in_reach(point, other_sensor)
                seen_by_other = true
                break
            end
        end

        push!(checked_points, point)

        if ! seen_by_other
            println(point)
            score = point.x * 4000000 + point.y
            println(score)
            done = true
            break
        end
    end

    if done break end
end
