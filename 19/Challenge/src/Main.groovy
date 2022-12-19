import groovy.transform.AutoClone

@AutoClone
class Blueprint implements Comparable<Blueprint> {
    public int number
    public int minutesPassed = 0

    public int ore = 0
    public int oreRobots = 1
    public int oreRobotOreCosts

    public int clay = 0
    public int clayRobots = 0
    public int clayRobotOreCost

    public int obsidian = 0
    public int obsidianRobots = 0
    public int obsidianRobotOreCost
    public int obsidianRobotClayCost

    public int geodes = 0
    public int geodeRobots = 0
    public int geodeRobotOreCost
    public int geodeRobotObsidianCost

    Blueprint(String line) {
        def pattern = ~"Blueprint ([0-9]+): Each ore robot costs ([0-9]+) ore. Each clay robot costs ([0-9]+) ore. Each obsidian robot costs ([0-9]+) ore and ([0-9]+) clay. Each geode robot costs ([0-9]+) ore and ([0-9]+) obsidian."

        def matcher = line =~ pattern

        number = matcher[0][1] as int
        oreRobotOreCosts = matcher[0][2] as int
        clayRobotOreCost = matcher[0][3] as int
        obsidianRobotOreCost = matcher[0][4] as int
        obsidianRobotClayCost = matcher[0][5] as int
        geodeRobotOreCost = matcher[0][6] as int
        geodeRobotObsidianCost = matcher[0][7] as int
    }

    int maxOreRequired() { return Math.max(oreRobotOreCosts, Math.max(clayRobotOreCost, Math.max(obsidianRobotOreCost, geodeRobotOreCost))) }

    boolean CanBuildOreRobot() { return ore >= oreRobotOreCosts && oreRobots < maxOreRequired() }
    boolean CanBuildClayRobot() { return ore >= clayRobotOreCost && clayRobots < obsidianRobotClayCost }
    boolean CanBuildObsidianRobot() { return ore >= obsidianRobotOreCost && clay >= obsidianRobotClayCost && obsidianRobots < geodeRobotObsidianCost }
    boolean CanBuildGeodeRobot() { return ore >= geodeRobotOreCost && obsidian >= geodeRobotObsidianCost }

    List<Blueprint> NextStates()
    {
        def list = []

        def canBuildOre = CanBuildOreRobot()
        def canBuildClay = CanBuildClayRobot()
        def canBuildObsidian = CanBuildObsidianRobot()
        def canBuildGeode = CanBuildGeodeRobot()

        ore += oreRobots
        clay += clayRobots
        obsidian += obsidianRobots
        geodes += geodeRobots

        minutesPassed += 1

        if (canBuildGeode) {
            ore -= geodeRobotOreCost
            obsidian -= geodeRobotObsidianCost
            geodeRobots += 1
            list.add(this)
        } else if (canBuildObsidian) {
            ore -= obsidianRobotOreCost
            clay -= obsidianRobotClayCost
            obsidianRobots += 1
            list.add(this)
        } else {
            // do not hoard
            if (ore < 15) {
                list.add(this)
            }

            if (canBuildOre) {
                def newItem = this.clone()
                newItem.ore -= oreRobotOreCosts
                newItem.oreRobots += 1
                list.add(newItem)
            }

            if (canBuildClay) {
                def newItem = this.clone()
                newItem.ore -= clayRobotOreCost
                newItem.clayRobots += 1
                list.add(newItem)
            }
        }

        return list
    }

    @Override
    int compareTo(Blueprint o) {
        if (geodes != o.geodes) {
            return o.geodes <=> geodes
        }
        if (obsidian != o.obsidian) {
            return o.obsidian <=> obsidian
        }
        if (clay != o.clay) {
            return o.clay <=> clay
        }
        return o.ore <=> ore
    }

    int potential()
    {
        def minutesLeft = 32 - minutesPassed
        def machineEveryMinute = (minutesLeft..32).toList().sum() as int
        return geodes + (minutesLeft * geodeRobots) + machineEveryMinute
    }
}

static void main(String[] args) {
    println "Hello world!"

    def totalScore = 0
    new File("../input/input.txt").eachLine { line ->
        totalScore += GetScoreForLine(line)
    }

    printf("Total score: %d\n", totalScore)
}

static int GetScoreForLine(String line)
{
    def blueprint = new Blueprint(line)

    def queue = new PriorityQueue<Blueprint>()
    queue.add(blueprint)

    def highestScore = 0

    while (!queue.empty) {
        def next = queue.poll()
        printf("\rChecking blueprint with %d minutes passed (items in queue: %d, highest score: %d)", next.minutesPassed, queue.size(), highestScore)
        if (next.minutesPassed == 32) {
            highestScore = Math.max(highestScore, next.geodes)
            continue
        }

        for (followUp in next.NextStates()) {

            if (followUp.potential() < highestScore) {
                continue
            }

            queue.add(followUp)
        }
    }

    printf("Maximum number of geodes: %d\n", highestScore)
    return blueprint.number * highestScore
}