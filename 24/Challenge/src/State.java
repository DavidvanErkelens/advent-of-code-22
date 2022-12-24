import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class State {
    List<Blizzard> blizzards;
    int x;
    int y;
    int stepsTaken;

    public State(List<Blizzard> blizzards, int x, int y, int stepsTaken) {
        this.blizzards = blizzards;
        this.x = x;
        this.y = y;
        this.stepsTaken = stepsTaken;
    }

    public ArrayList<State> GetNextStates(List<char[]> grid) {
        int height = grid.size();
        int width = grid.get(0).length;
        var list = new ArrayList<State>();
        var blizzards = this.blizzards.stream().map(blizzard -> blizzard.nextStep(width, height)).toList();

//        // begin step
//        if (y == 0) {
//            if (IsBlizzardFree(blizzards, x, y + 1)) {
//                list.add(new State(blizzards, x, y + 1, stepsTaken + 1));
//            } else {
//                list.add(new State(blizzards, x, y, stepsTaken + 1));
//            }
//
//            return list;
//        }

        if (x > 0 && IsBlizzardFree(blizzards, x - 1, y) && grid.get(y)[x-1] != '#') {
            list.add(new State(blizzards, x - 1, y, stepsTaken + 1));
        }

        if (x < width - 1 && IsBlizzardFree(blizzards, x + 1, y) && grid.get(y)[x+1] != '#') {
            list.add(new State(blizzards, x + 1, y, stepsTaken + 1));
        }

        if (y > 0 && IsBlizzardFree(blizzards, x, y - 1) && grid.get(y-1)[x] != '#') {
            list.add(new State(blizzards, x, y - 1, stepsTaken + 1));
        }

        if (y < height - 1 && IsBlizzardFree(blizzards, x, y + 1)  && grid.get(y+1)[x] != '#') {
            list.add(new State(blizzards, x, y + 1, stepsTaken + 1));
        }

        if (IsBlizzardFree(blizzards, x, y)) {
            list.add(new State(blizzards, x, y, stepsTaken + 1));
        }

        return list;
    }

    private static boolean IsBlizzardFree(List<Blizzard> blizzards, int x, int y)
    {
        return blizzards.stream().noneMatch(blizzard -> blizzard.X == x && blizzard.Y == y);
    }
}
