// The point (0, 0) exists on the top left corner for the visible screen
// For this reason I add width / 2 for x coordinates and height / 2 for y coordinates
// This is generally sufficient in making objects center around the visible center of the screen isntead of centering at (0, 0)

// Takes two matrices and returns the product between them
Matrix multiplyMatrices (Matrix mat1, Matrix mat2){
  Matrix res = new Matrix(mat1.row, mat2.col);
  for(int i = 0; i < mat2.row;i++){
    for(int j = 0; j < mat2.col; j++){
      res.matrix[i][j] = 0;
      for(int k = 0;  k < mat1.col; k++){
         res.matrix[i][j] = res.matrix[i][j] + (mat1.matrix[i][k] * mat2.matrix[k][j]);
      }
    }
  }
  return res;
}

class Matrix{
  int row;
  int col;
  float[][] matrix;
  
  Matrix(int r, int c) {
    row = r;
    col = c;
    matrix = new float[row][col];
  }
  
  Matrix(float[][] m) {
    matrix = m;
    col = m.length;
    row = m[0].length;
  }
  
  void arrayToMatrix(float[] arr) {
    for (int i = 0; i< row; i++) {
      for (int j = 0; j< col; j++) {
        matrix[i][j] =  arr[i * col + j];
      }
    }
  }
// this just takes a matrix and gives it a random value  
  void randomizer(){
    for(int i = 0; i < row;i++){
      for(int j = 0; j < col; j++){
       matrix[i][j] = random(0,1);
      }
    }
  }
}


//start of the initial nn 
//right now i just put that it makes the 2 matricies when an instance of it is called
class nn{
Matrix output;
Matrix input;
int row1;
int row2;
int col1;
int col2;
//gave it a changeable 3 layer system just incase we need to change nodes later
  nn(int r1, int c1,int r2, int c2){
     row1 = r1;
     row2 = r2;
     col1 = c1;
     col2 = c2;
     input = new Matrix(r1,c1);
     output = new Matrix(r2,c2); 
   
     output.randomizer();  
     input.randomizer();  
  }
  
}
//called the instance and intialized it with a 5*9 and a 3*6
//seeing input-hidden weights would just be first.input.matrix[i][j]
//seeing hidden-output weights would just be first.output.matrix[i][j]
nn first = new nn(5,9,3,6);

long warps = 0;

// Takes an angle and returns the rotation matrix for that angle
Matrix rotationMatrix (float radians){
  Matrix res = new Matrix(2, 2);
  res.arrayToMatrix(new float[] {cos(radians), -sin(radians), sin(radians), cos(radians)});
  return res;
}

// The radius of the circle that surrounds the visible square. The rocks are generate randomly along this circle 
float circleRadius = 800 * sqrt(2) / 2;

class Rock{
  int radius;
  // Column vector                 [ x ]
  // Holds the x, y coordinates    [ y ]
  Matrix center = new Matrix(2, 1);
  float slope;
  float speed;
  
  Rock(){
    radius = 20;
    reset();
  }
  
  void display(){
    fill(101, 67, 33);
    ellipse(center.matrix[0][0] + width / 2, center.matrix[1][0] + height / 2, radius * 2, radius * 2);
  }
  
  void move(){
    center.matrix[0][0] = center.matrix[0][0] + speed;
    center.matrix[1][0] = center.matrix[1][0] + slope;
    
    if(sqrt(pow(center.matrix[0][0], 2) + pow(center.matrix[1][0], 2)) > circleRadius){
      reset();
    }
  }
  
  void reset(){
    center.matrix[0][0] = 0;
    center.matrix[1][0] = circleRadius;
    do{
      center = multiplyMatrices(rotationMatrix(random(2*PI)), center);
    }
    while (center.matrix[0][0] == ship.deltaX);
    slope = (ship.deltaY - center.matrix[1][0]) / (ship.deltaX - center.matrix[0][0]);
    while((center.matrix[0][0] == ship.deltaX) || ((slope > 5) || (slope < -5))){
      center = multiplyMatrices(rotationMatrix(random(2*PI)), center);
      slope = (ship.deltaY - center.matrix[1][0]) / (ship.deltaX - center.matrix[0][0]);
    }
    
    if((ship.topVertex.matrix[0][0] + width/2 + ship.deltaX) > (center.matrix[0][0] + width / 2)){
      speed = 1;
    }
    else{
      speed = -1;
      slope = slope * -1;
    }
  }
}

class Ship{
  int triangleLength;
  float inscribedRadius;
  float deltaX;
  float deltaY;
  
  // Column vector for each vertex
  Matrix topVertex;
  Matrix leftVertex;
  Matrix rightVertex;
  int speed;
  float rotateSpeed;
  float angle;
  
  Ship(){
    triangleLength = 30;
    inscribedRadius = triangleLength * sqrt(3) / 6;
    deltaX = 0;
    deltaY = 0;
    speed = 0;
    rotateSpeed = 0;
    angle = 0;
    // The distance of the top vertex to the cetner of the triangle is equal to the triangleLength / sqrt(3)
    topVertex = new Matrix(2, 1);
    topVertex.arrayToMatrix(new float[] {0, 0 - (triangleLength / sqrt(3))});
                              
    // To get the next vertex simply take a previous vertex and rotate by 120 degrees or 2 * PI / 3 radians 
    leftVertex = multiplyMatrices(rotationMatrix(2 * PI / 3), topVertex);
    rightVertex = multiplyMatrices(rotationMatrix(2 * PI / 3), leftVertex);
  }
  
  void display(){
    // Some statements to allow teleporting if ship goes beyond viewable screen
    if(deltaX > width/2){
      deltaX = -width/2;
      warps = warps + 1;
    }
    if(deltaX < -width/2){
      deltaX = width/2;
      warps = warps + 1;
    }
    if(deltaY > height/2){
      deltaY = -height/2;
      warps = warps + 1;
    }
    if(deltaY < -height/2){
      deltaY = height/2;
      warps = warps + 1;
    }
    fill(255,255,255); 
    // deltaX and deltaY describe how much the center of the triangle has moved. This is pretty much the coordinates for the center of the triangle
    // The vertex coordinates help when drawing the triangle facing the proper direction
    // width / 2 and height / 2 are added to make the origin the center of the visible screen
    triangle(topVertex.matrix[0][0] + width/2 + deltaX, topVertex.matrix[1][0] + height/2 + deltaY, leftVertex.matrix[0][0] + width/2 + deltaX, leftVertex.matrix[1][0] + height/2 + deltaY, rightVertex.matrix[0][0] + width/2 + deltaX, rightVertex.matrix[1][0] + height/2 + deltaY);
    fill(255,0,0);
    ellipse(topVertex.matrix[0][0] + width/2 + deltaX, topVertex.matrix[1][0] + height/2 + deltaY, 5, 5);
    fill(0,0,255);
    ellipse(width/2 + deltaX, height/2 + deltaY, inscribedRadius * 2, inscribedRadius * 2);
  }
  
  void move(){
    // The ship can only move in the direction it's facing
    // The angle keeps track of how much the ship has rotated 
    // Polar coordinates help since we're moving some distance away from the center according to an angle 
    // Added 90 degrees since 0 degrees lies along the postive x axis
    // The ship begins where it's facing the postive y axis
    deltaX = deltaX - speed * cos(angle + PI/2);
    deltaY = deltaY - speed * sin(angle + PI/2);
  }
  
  void spin(){
    // When spinning keep track of the angle
    // Cacluate the top vertex by multiplying the top vertex with the rotation vertex
    angle = angle + rotateSpeed;
    topVertex = multiplyMatrices(rotationMatrix(rotateSpeed), topVertex);
    
    // To get the next vertex simply take a previous vertex and rotate by 120 degrees or 2 * PI / 3 radians 
    leftVertex = multiplyMatrices(rotationMatrix(2 * PI / 3), topVertex);
    rightVertex = multiplyMatrices(rotationMatrix(2 * PI / 3), leftVertex);
  }
  
  void look(){
    float x = topVertex.matrix[0][0] + width/2 + deltaX;
    float y = topVertex.matrix[1][0] + height/2 + deltaY;
    while(!(x > width || x < 0 || y > height || y < 0) ){
      x = x + 20;
      ellipse(x, y , 30, 30);
    }
    
    x = topVertex.matrix[0][0] + width/2 + deltaX;
    while(!(x > width || x < 0 || y > height || y < 0) ){
      x = x - 20;
      ellipse(x, y , 30, 30);
    }
    
    x = topVertex.matrix[0][0] + width/2 + deltaX;
    while(!(x > width || x < 0 || y > height || y < 0) ){
      y = y - 20;
      ellipse(x, y , 30, 30);
    }
    
    y = topVertex.matrix[1][0] + height/2 + deltaY;
    while(!(x > width || x < 0 || y > height || y < 0) ){
      y = y + 20;
      ellipse(x, y , 30, 30);
    }
    
    x = topVertex.matrix[0][0] + width/2 + deltaX;
    y = topVertex.matrix[1][0] + height/2 + deltaY;
    while(!(x > width || x < 0 || y > height || y < 0) ){
      y = y + 20;
      x = x + 20;
      ellipse(x, y , 30, 30);
    }
    
    x = topVertex.matrix[0][0] + width/2 + deltaX;
    y = topVertex.matrix[1][0] + height/2 + deltaY;
    while(!(x > width || x < 0 || y > height || y < 0) ){
      y = y + 20;
      x = x - 20;
      ellipse(x, y , 30, 30);
    }
    
    x = topVertex.matrix[0][0] + width/2 + deltaX;
    y = topVertex.matrix[1][0] + height/2 + deltaY;
    while(!(x > width || x < 0 || y > height || y < 0) ){
      y = y - 20;
      x = x + 20;
      ellipse(x, y , 30, 30);
    }
    
    x = topVertex.matrix[0][0] + width/2 + deltaX;
    y = topVertex.matrix[1][0] + height/2 + deltaY;
    while(!(x > width || x < 0 || y > height || y < 0) ){
      y = y - 20;
      x = x - 20;
      ellipse(x, y , 30, 30);
    }
  }
}

Ship ship;
Rock [] rock;
// Keeping track of time ship is still
long totalTimeStill = 0;
long timeStill = 0;

// Keeping track of time ship is moving 
long totalTimeMoving = 0;
long timeMoving = 0;

void createGame(){
  ship = new Ship();
  rock = new Rock[10];
  for(int i = 0; i < 10; i++){
    rock[i] = new Rock();
  }
}

long dontMoveFitnessFunction(){
  return totalTimeStill * totalTimeStill - totalTimeMoving;
}

long dontMoveTakeWarpsFitnessFunction(){
  return dontMoveFitnessFunction() + (warps * warps * warps);
}

long dontMoveNoWarpsFitnessFunction(){
  return dontMoveFitnessFunction() - (warps * warps * warps);
}

long moveFitnessFunction(){
  return totalTimeMoving * totalTimeMoving - totalTimeStill;
}

long moveTakeWarpsFitnessFunction(){
  return moveFitnessFunction() + (warps * warps * warps);
}

long moveNoWarpsFitnessFunction(){
  return moveFitnessFunction() - (warps * warps * warps);
}

boolean collision(Ship a, Rock b){
  boolean ans = false;
  float distance = sqrt(pow(a.deltaX - b.center.matrix[0][0], 2) + pow(a.deltaY - b.center.matrix[1][0], 2));
  if(distance < (a.inscribedRadius + b.radius)) ans = true;
  return ans;
}

int startTime;

void setup(){
  size(800, 800);
  background(0);
  noStroke();
  ellipseMode(CENTER); 
  createGame();
  timeStill = millis(); // Begin keeping track of time still since ship is not moving at first 
  startTime = millis();
}

void draw(){
  int gameTime = millis() - startTime;
  background(0);
  textSize(32);
  text("Score", 650,100);
  text(gameTime / 1000,650,150);
  ship.display();
  ship.look();
  ship.spin();
  ship.move();
  for(int i = 0; i < 10; i ++){
    rock[i].display();
    rock[i].move();
    if(collision(ship, rock[i])){
      if(ship.speed == 0){ // If ship is not moving. Update total time ship was still 
        totalTimeStill = totalTimeStill + int((millis() - timeStill) / 500);
      }
      else{ // Otherwise need to update total time ship was moving 
        totalTimeMoving = totalTimeMoving + int((millis() - timeMoving) / 500);
      }
      println("Time still: " + totalTimeStill);
      println("Time moving: " + totalTimeMoving);
      println("Number of warps: " + warps);
      println();
      println("Move fitness: " + moveFitnessFunction());
      println("Move and warp around the screen: " + moveTakeWarpsFitnessFunction());
      println("Move and don't warp around the screen: " + moveNoWarpsFitnessFunction());
      println();
      println("Don't move fitness: " + dontMoveFitnessFunction());
      println("Don't move and warp around the screen: " + dontMoveTakeWarpsFitnessFunction());
      println("Don't move and don't warp around the screen: " + dontMoveNoWarpsFitnessFunction());
      println();
      println();
      totalTimeStill = 0;
      totalTimeMoving = 0;
      warps = 0;
      delay(1000);
      startTime = millis();
      createGame();
      break;
    }
  }
}

void keyReleased(){
  if(key == CODED){
    if (keyCode == UP){
      ship.speed = 0;
      timeStill = millis(); // Ship went from moving to not moving. Begin to keep track of time ship isn't moving 
      totalTimeMoving = totalTimeMoving + int((millis() - timeMoving) / 500); // Ship stopped moving so update total time ship was moving
    }
    if (keyCode == LEFT){
      ship.rotateSpeed = 0;
    }
    if (keyCode == RIGHT){
      ship.rotateSpeed = 0;
    }
  }
}

void keyPressed(){
  if(key == CODED){
    if(keyCode == UP){
      ship.speed = 5;
      totalTimeStill = totalTimeStill + int((millis() - timeStill) / 500); // Ship started moving so update total time ship was not moving 
      timeMoving = millis(); // Ship went from not moving to moving. Begin to keep track of time ship is moving
    }
    else if (keyCode == LEFT){
      ship.rotateSpeed = -PI/30;
    }
    else if (keyCode == RIGHT){
      ship.rotateSpeed = PI/30;
    }
  }
}
