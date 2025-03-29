import bpy  # Blender Python API
import time # Used for time keeping
import random
import bmesh

# Select all objects
bpy.ops.object.select_all(action='SELECT')

# # Delete selected objects
bpy.ops.object.delete()

# Define position (x, y, z)
position = (0,0, 0)

# Add a rectangular plane at the given position
#bpy.ops.mesh.primitive_cube_add(size=2, location=position,scale=(1,2,2))

bpy.ops.mesh.primitive_cube_add(size=2, location=position,scale=(1,3,2))

# activeRect = bpy.context.object

# TODO: Use a rect?
def draw_line(start, end):
#    bpy.ops.mesh.primitive_cube_add(size=2, location=start,scale=e)
#    bpy.ops.mesh.primitive_cube_add(size=2, location=start,scale=(abs(end.x -start.x),abs(end.y - start.y),2));
    mesh = bpy.data.meshes.new(name="Line")
    obj = bpy.data.objects.new("Line", mesh)
    bpy.context.collection.objects.link(obj)

    bm = bmesh.new()
    v1 = bm.verts.new(start)
    v2 = bm.verts.new(end)
    bm.edges.new([v1, v2])
    
    bm.to_mesh(mesh)
    bm.free()

class Cell:
    def __init__(self, x: int, y: int):
        self.x = x  # Final in Python means we just avoid modifying it
        self.y = y
        self.walls = [True, True, True, True]  # Assuming 4 walls (top, right, bottom, left)
        self.isVisited = False


grid: list[Cell] = [];
stack: list[Cell] = [];
DIM: int = 3;
current:Cell;


for j in range(DIM):
 for i in range(DIM):
        grid.append(
          Cell(
             i,
             j,
          ),
        )
      
current = grid[0];
current.isVisited = True;
grid[0] = current;

#for cell in grid:
#    bpy.ops.mesh.primitive_cube_add(size=2, location=(cell.x+1,cell.y+1, 1),scale=(1,2,1))


# Start: showCell
def showCell(cell:Cell,cellW:float):
     x:float = cell.x * cellW;
     y:float = cell.y * cellW;

     if cell.walls[0]:
       print("Wall 0");
       draw_line((x,y,0),(x + cellW, y,0));
      # canvas.drawLine(Offset(x, y), Offset(x + cellW, y), painter);
    

     if cell.walls[1]:
       print("Wall 1");
       draw_line((x + cellW, y,0), (x + cellW, y + cellW,0));
    

     if cell.walls[2]:
       print("Wall 2");
       draw_line((x + cellW, y + cellW,0), (x, y + cellW,0));
    

     if cell.walls[3]:
       print("Wall 3");
       draw_line((x, y + cellW,0), (x, y,0));
    

     if cell.isVisited:
       print("Wall 0");
      # canvas.drawRect(
      #   Rect.fromLTWH(x, y, cellW, cellW),
      #   Paint()
      #     ..color = cell.x == current.x && cell.y == current.y ? Colors.purple : Colors.blue
      #     ..strokeWidth = 0,
      # );
    

# End: showCell

# Start: getIndex
def getIndex(x:int,y:int):
    if x < 0 or y < 0 or x > DIM - 1 or y > DIM - 1: 
      return -1;

    return x + y * DIM;
# End: getIndex


# Start: checkNeighbours

def checkNeighbours(cell:Cell):
    neighbours: list[Cell] = []
    x, y = cell.x, cell.y

    top_index: int = getIndex(x, y - 1)
    right_index: int = getIndex(x + 1, y)
    bottom_index: int = getIndex(x, y + 1)
    left_index: int= getIndex(x - 1, y)

    if top_index != -1 and not grid[top_index].isVisited:
        neighbours.append(grid[top_index])

    if right_index != -1 and not grid[right_index].isVisited:
        neighbours.append(grid[right_index])

    if bottom_index != -1 and not grid[bottom_index].isVisited:
        neighbours.append(grid[bottom_index])

    if left_index != -1 and not grid[left_index].isVisited:
        neighbours.append(grid[left_index])

    return random.choice(neighbours) if neighbours else None

# End: checkNeighbours

# Start: removeWalls
def removeWalls(currentCell: Cell, next_cell: Cell):
    x:int = currentCell.x - next_cell.x;

    if x == 1:
        currentCell.walls[3] = False
        next_cell.walls[1] = False
    elif x == -1:
        currentCell.walls[1] = False
        next_cell.walls[3] = False

    y = currentCell.y - next_cell.y
    if y == 1:
        currentCell.walls[0] = False
        next_cell.walls[2] = False
    elif y == -1:
        currentCell.walls[2] = False
        next_cell.walls[0] = False

    grid[getIndex(currentCell.x, currentCell.y)] = currentCell
    grid[getIndex(next_cell.x, next_cell.y)] = next_cell
# End: removeWalls

width:int = 500;
cellW:float = width / DIM;

while any(not cell.isVisited for cell in grid):
    # Select all objects
    bpy.ops.object.select_all(action='SELECT')

    # # Delete selected objects
    bpy.ops.object.delete()

    for i in range(len(grid)): 
        cell: Cell = grid[i];
        showCell(cell, cellW);
        

    nextCell:Cell = checkNeighbours(current);

    if nextCell is not None:
          nextCell.isVisited = True;

          stack.append(current);

          grid[getIndex(current.x, current.y)] = current;

          removeWalls(current, nextCell);

          current = nextCell;
    elif stack: 
          current = stack.pop();

print("Latest Grid");
print(grid);
