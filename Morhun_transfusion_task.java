import java.util.*;
import java.util.function.BiFunction;

class WaterJugProblem {
    static class State {
        int x, y, z;
        State(int x, int y, int z) { this.x = x; this.y = y; this.z = z; }

        @Override
        public boolean equals(Object o) {
            if (this == o) return true;
            if (o == null || getClass() != o.getClass()) return false;
            State state = (State) o;
            return x == state.x && y == state.y && z == state.z;
        }

        @Override
        public int hashCode() { return Objects.hash(x, y, z); }

        @Override
        public String toString() { return "(" + x + ", " + y + ", " + z + ")"; }
    }

    static final int MAX_X = 9, MAX_Y = 4, MAX_Z = 7;
    static final State START = new State(9, 4, 0);
    static final State GOAL = new State(6, 4, 3);

    public static List<State> bfs() {
        Queue<List<State>> queue = new LinkedList<>();
        Set<State> visited = new HashSet<>();
        queue.add(Collections.singletonList(START));

        while (!queue.isEmpty()) {
            List<State> path = queue.poll();
            State current = path.get(path.size() - 1);

            if (current.equals(GOAL)) return path;

            for (State next : getNextStates(current)) {
                if (!visited.contains(next)) {
                    visited.add(next);
                    List<State> newPath = new ArrayList<>(path);
                    newPath.add(next);
                    queue.add(newPath);
                }
            }
        }
        return null;
    }

    private static List<State> getNextStates(State s) {
        List<State> states = new ArrayList<>();
        states.add(transfer(s.x, s.y, MAX_Y, (x, y) -> new State(x, y, s.z)));
        states.add(transfer(s.x, s.z, MAX_Z, (x, z) -> new State(x, s.y, z)));
        states.add(transfer(s.y, s.x, MAX_X, (y, x) -> new State(x, y, s.z)));
        states.add(transfer(s.y, s.z, MAX_Z, (y, z) -> new State(s.x, y, z)));
        states.add(transfer(s.z, s.x, MAX_X, (z, x) -> new State(x, s.y, z)));
        states.add(transfer(s.z, s.y, MAX_Y, (z, y) -> new State(s.x, y, z)));
        return states;
    }

    private static State transfer(int from, int to, int maxTo, BiFunction<Integer, Integer, State> createState) {
        int total = from + to;
        return total <= maxTo ? createState.apply(0, total) : createState.apply(total - maxTo, maxTo);
    }

    public static void main(String[] args) {
        List<State> solution = bfs();
        if (solution != null) {
            System.out.println("Solution path:");
            solution.forEach(System.out::println);
        } else {
            System.out.println("No solution found.");
        }
    }
}