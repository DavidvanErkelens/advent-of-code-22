import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.*;

public class Main {
    public static void main(String[] args) throws IOException {
        Path filePath = Path.of("input/input.txt");
        String content = Files.readString(filePath);
        String[] lines = content.split("\n");
        List<char[]> grid = Arrays.stream(lines).map(String::toCharArray).toList();

        ArrayList<Blizzard> initialBlizzards = new ArrayList<>();

        for (int y = 1; y < lines.length - 1; y++) {
            char[] splitString = lines[y].toCharArray();

            for (int x = 1; x < splitString.length - 1; x++) {
                switch (splitString[x]) {
                    case '>' -> initialBlizzards.add(new Blizzard(x, y, Direction.RIGHT));
                    case '<' -> initialBlizzards.add(new Blizzard(x, y, Direction.LEFT));
                    case 'v' -> initialBlizzards.add(new Blizzard(x, y, Direction.DOWN));
                    case '^' -> initialBlizzards.add(new Blizzard(x, y, Direction.UP));
                }
            }
        }

        int height = lines.length;
        int width = lines[0].length();

        ArrayList<String> seen = new ArrayList<>();

        int[][] goals = {
                { width - 2, height - 1 },
                { 1, 0 },
                { width - 2, height - 1 }
        };

        int currentGoal = 0;

        State initialState = new State(initialBlizzards, 1, 0, 0);
        Queue<State> toProcess = new LinkedList<>();
        toProcess.add(initialState);

        while (!toProcess.isEmpty()) {
            State state = toProcess.remove();

            String strRep = String.format("%d-%d-%d", state.x, state.y, state.stepsTaken);
            if (seen.contains(strRep)) {
                continue;
            }

            seen.add(strRep);

            System.out.printf("\rProcessing states with %d steps", state.stepsTaken);

            if (state.x == goals[currentGoal][0] && state.y == goals[currentGoal][1]) {
                System.out.printf("\nWe reached goal %d after %d steps\n", currentGoal, state.stepsTaken);
                currentGoal += 1;
                if (currentGoal == goals.length) {
                    break;
                }
                toProcess.clear();
            }

            toProcess.addAll(state.GetNextStates(grid));
        }
    }
}