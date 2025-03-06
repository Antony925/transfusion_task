import java.util.*;

class WaterJugSolver {
    static class State {
        int x, y, z, w;

        State(int x, int y, int z, int w) {
            this.x = x;
            this.y = y;
            this.z = z;
            this.w = w;
        }

        boolean isGoal() {
            return x == 6 && y == 3 && z == 4;
        }

        List<State> getNextStates() {
            List<State> nextStates = new ArrayList<>();
            int[] capacities = {9, 4, 7, 1000};

            // Переливання між посудинами
            nextStates.add(pour(x, y, z, w, capacities[1], 0, 1));  // X → Y
            nextStates.add(pour(x, y, z, w, capacities[2], 0, 2));  // X → Z
            nextStates.add(pour(x, y, z, w, capacities[0], 1, 0));  // Y → X
            nextStates.add(pour(x, y, z, w, capacities[2], 1, 2));  // Y → Z
            nextStates.add(pour(x, y, z, w, capacities[0], 2, 0));  // Z → X
            nextStates.add(pour(x, y, z, w, capacities[1], 2, 1));  // Z → Y

            // Переливання з/до крана-стоку
            nextStates.add(pour(x, y, z, w, capacities[3], 0, 3));  // X → W
            nextStates.add(pour(x, y, z, w, capacities[3], 1, 3));  // Y → W
            nextStates.add(pour(x, y, z, w, capacities[3], 2, 3));  // Z → W
            nextStates.add(pour(x, y, z, w, capacities[0], 3, 0));  // W → X
            nextStates.add(pour(x, y, z, w, capacities[1], 3, 1));  // W → Y
            nextStates.add(pour(x, y, z, w, capacities[2], 3, 2));  // W → Z

            nextStates.removeIf(Objects::isNull); // Видаляємо невалідні стани
            return nextStates;
        }

        private State pour(int x, int y, int z, int w, int maxTo, int from, int to) {
            int[] values = {x, y, z, w};

            int total = values[from] + values[to];
            if (total <= maxTo) {
                values[to] = total;
                values[from] = 0;
            } else {
                values[to] = maxTo;
                values[from] = total - maxTo;
            }

            return new State(values[0], values[1], values[2], values[3]);
        }

        @Override
        public boolean equals(Object o) {
            if (this == o) return true;
            if (!(o instanceof State)) return false;
            State state = (State) o;
            return x == state.x && y == state.y && z == state.z && w == state.w;
        }

        @Override
        public int hashCode() {
            return Objects.hash(x, y, z, w);
        }

        @Override
        public String toString() {
            return String.format("(%d, %d, %d, %d)", x, y, z, w);
        }
    }

    public static void main(String[] args) {
        solve();
    }

    public static void solve() {
        Queue<List<State>> queue = new LinkedList<>();
        Set<State> visited = new HashSet<>();

        State start = new State(9, 4, 0, 0);
        queue.add(Collections.singletonList(start));
        visited.add(start);

        while (!queue.isEmpty()) {
            List<State> path = queue.poll();
            State current = path.get(path.size() - 1);

            if (current.isGoal()) {
                for (State state : path) {
                    System.out.println(state);
                }
                return;
            }

            for (State next : current.getNextStates()) {
                if (!visited.contains(next)) {
                    List<State> newPath = new ArrayList<>(path);
                    newPath.add(next);
                    queue.add(newPath);
                    visited.add(next);
                }
            }
        }

        System.out.println("No solution found");
    }
}