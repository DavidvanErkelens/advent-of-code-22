public class Blizzard {
    public int X;
    public int Y;
    public Direction direction;

    public Blizzard(int x, int y, Direction direction) {
        X = x;
        Y = y;
        this.direction = direction;
    }

    public Blizzard nextStep(int width, int height)
    {
        return switch (direction) {
            case RIGHT -> new Blizzard(X == width - 2 ? 1 : X + 1, Y, Direction.RIGHT);
            case DOWN -> new Blizzard(X, Y == height - 2 ? 1 : Y + 1, Direction.DOWN);
            case UP -> new Blizzard(X, Y == 1 ? height - 2 : Y - 1, Direction.UP);
            case LEFT -> new Blizzard(X == 1 ? width - 2 : X - 1, Y, Direction.LEFT);
        };
    }
}
