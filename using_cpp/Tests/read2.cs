public class Solution {
    public  int IslandPerimeter(int[][] grid)
        {
            int result = 0;

            for (int i = 0; i < grid.Length; i++)
                for (int j = 0; j < grid[i].Length; j++)
                    if (grid[i][j] == 1)
                        result += countPerimeter(grid, i, j);

            return result;
        }

        public  int countPerimeter(int[][] grid, int x, int y)
        {
            int count = 0;

            if (x-1 < 0 || grid[x - 1][y] == 0) // UP
                count++;
            if (x + 1 > grid.Length - 1 || grid[x + 1][y] == 0) //DOWN
                count++;
            if (y-1 < 0 || grid[x][y - 1] == 0) // LEFT
                count++;
            if (y+1 > grid[x].Length-1 || grid[x][y + 1] == 0) // RIGHT
                count++;
                
            return count;
        }
}