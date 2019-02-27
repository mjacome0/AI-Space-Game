// The point (0, 0) exists on the top left corner for the visible screen
// For this reason I add width / 2 for x coordinates and height / 2 for y coordinates
// This is generally sufficient in making objects center around the visible center of the screen isntead of centering at (0, 0)

// Takes two matrices and returns the product between them
float[][] multiply (float [][]mat1, float [][] mat2){
  float [][] res = {};
  int mat1Row = mat1.length;
  int mat1Col = mat1[0].length;
  int mat2Row = mat2.length;
  int mat2Col = mat2[0].length;
  res = new float[mat1Row][mat2Col];
  for(int i = 0; i < mat2Row;i++){
    for(int j = 0; j < mat2Col; j++){
      res[i][j] = 0;
      for(int k = 0;  k < mat1Col; k++){
         res[i][j] = res[i][j] + (mat1[i][k] * mat2[k][j]);
      }
    }
  }
  return res;
}

// Takes an angle and returns the rotation matrix for that angle
float[][] rotationMatrix (float radians){
  float [][] res = {  {cos(radians), -sin(radians)},
                      {sin(radians), cos(radians)}  };
  return res;
}

// The radius of the circle that surrounds the visible square. The rocks are generate randomly along this circle 
float circleRadius = 800 * sqrt(2) / 2;

class Rock{
  int radius;
  // Column vector                 [ x ]
  // Holds the x, y coordinates    [ y ]
  float [][] center = new float[2][1];
  float slope;
  float speed;
  
  Rock(){
    radius = 20;
    reset();
  }
  
  void display(){
    fill(101, 67, 33);
    ellipse(center[0][0] + width / 2, center[1][0] + height / 2, radius * 2, radius * 2);
  }
  
  void move(){
    center[0][0] = center[0][0] + speed;
    center[1][0] = center[1][0] + slope;
    
    if(sqrt(pow(center[0][0], 2) + pow(center[1][0], 2)) > circleRadius){
      reset();
    }
  }
  
  void reset(){
    center[0][0] = 0;
    center[1][0] = circleRadius;
    do{
      center = multiply(rotationMatrix(random(2*PI)), center);
    }
    while (center[0][0] == ship.deltaX);
    slope = (ship.deltaY - center[1][0]) / (ship.deltaX - center[0][0]);
    while((center[0][0] == ship.deltaX) || ((slope > 5) || (slope < -5))){
      center = multiply(rotationMatrix(random(2*PI)), center);
      slope = (ship.deltaY - center[1][0]) / (ship.deltaX - center[0][0]);
    }
    
    if((ship.topVertex[0][0] + width/2 + ship.deltaX) > (center[0][0] + width / 2)){
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
  float [][] topVertex;
  float [][] leftVertex;
  float [][] rightVertex;
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
    topVertex = new float[][]{{0},
                              {0 - (triangleLength / sqrt(3))}};
                              
    // To get the next vertex simply take a previous vertex and rotate by 120 degrees or 2 * PI / 3 radians 
    leftVertex = multiply(rotationMatrix(2 * PI / 3), topVertex);
    rightVertex = multiply(rotationMatrix(2 * PI / 3), leftVertex);
  }
  
  void display(){
    // Some statements to allow teleporting if ship goes beyond viewable screen
    if(deltaX > width/2){
      deltaX = -width/2;
    }
    if(deltaX < -width/2){
      deltaX = width/2;
    }
    if(deltaY > height/2){
      deltaY = -height/2;
    }
    if(deltaY < -height/2){
      deltaY = height/2;
    }
    fill(255,255,255); 
    // deltaX and deltaY describe how much the center of the triangle has moved. This is pretty much the coordinates for the center of the triangle
    // The vertex coordinates help when drawing the triangle facing the proper direction
    // width / 2 and height / 2 are added to make the origin the center of the visible screen
    triangle(topVertex[0][0] + width/2 + deltaX, topVertex[1][0] + height/2 + deltaY, leftVertex[0][0] + width/2 + deltaX, leftVertex[1][0] + height/2 + deltaY, rightVertex[0][0] + width/2 + deltaX, rightVertex[1][0] + height/2 + deltaY);
    fill(255,0,0);
    ellipse(topVertex[0][0] + width/2 + deltaX, topVertex[1][0] + height/2 + deltaY, 5, 5);
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
    topVertex = multiply(rotationMatrix(rotateSpeed), topVertex);
    
    // To get the next vertex simply take a previous vertex and rotate by 120 degrees or 2 * PI / 3 radians 
    leftVertex = multiply(rotationMatrix(2 * PI / 3), topVertex);
    rightVertex = multiply(rotationMatrix(2 * PI / 3), leftVertex);
  }
}

Ship ship;
Rock [] rock;

void createGame(){
  ship = new Ship();
  rock = new Rock[10];
  for(int i = 0; i < 10; i++){
    rock[i] = new Rock();
  }
}

boolean collision(Ship a, Rock b){
  boolean ans = false;
  float distance = sqrt(pow(a.deltaX - b.center[0][0], 2) + pow(a.deltaY - b.center[1][0], 2));
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
  startTime = millis();
}

void draw(){
  int gameTime = millis() - startTime;
  println(gameTime);
  background(0);
  textSize(32);
  text("score", 650,100);
  text(gameTime,650,150);
  ship.display();
  ship.spin();
  ship.move();
  for(int i = 0; i < 10; i ++){
    rock[i].display();
    rock[i].move();
    if(collision(ship, rock[i])){
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
    }
    else if (keyCode == LEFT){
      ship.rotateSpeed = -PI/30;
    }
    else if (keyCode == RIGHT){
      ship.rotateSpeed = PI/30;
    }
  }
}
