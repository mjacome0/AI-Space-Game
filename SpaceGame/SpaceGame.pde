Ship ship;
Rock [] rock;
long warps = 0;
int startTime = 0;

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
  warps = 0;
  timeMoving = 0;
  totalTimeStill = 0;
  totalTimeMoving = 0;
  timeStill = millis(); // Begin keeping track of time still since ship is not moving at first 
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
  background(0);
  textSize(32);
  text("Score", 650,100);
  text(gameTime / 1000,650,150);
  ship.display();
  //ship.think();
  //ship.act();
  for(int i = 0; i < 10; i ++){
    rock[i].display();
    ship.look(rock[i]);
    rock[i].move();
    if(collision(ship.deltaX, ship.deltaY, rock[i].center.matrix[0][0], rock[i].center.matrix[1][0], ship.inscribedRadius, rock[i].radius)){
      if(ship.speed == 0){ // If ship is not moving. Update total time ship was still 
        totalTimeStill = totalTimeStill + int((millis() - timeStill) / 1000);
      }
      else{ // Otherwise need to update total time ship was moving 
        totalTimeMoving = totalTimeMoving + int((millis() - timeMoving) / 1000);
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
      delay(1000);
      startTime = millis();
      createGame();
      break;
    }
  }
  ship.spin();
  ship.move();
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

// Takes two matrices and returns the product between them
public Matrix multiplyMatrices (Matrix mat1, Matrix mat2){
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

// Takes an angle and returns the rotation matrix for that angle
public Matrix rotationMatrix (float radians){
  Matrix res = new Matrix(2, 2);
  res.arrayToMatrix(new float[] {cos(radians), -sin(radians), sin(radians), cos(radians)});
  return res;
}

public float distance(float x1, float y1, float x2, float y2){
  float ans = sqrt(pow(x1 - x2, 2) + pow(y1 - y2, 2));
  return ans;
}

public boolean collision(float x1, float y1, float x2, float y2, float r1, float r2){
  boolean ans = false;
  float distance = distance(x1, y1, x2, y2);
  if(distance < (r1 + r2)) ans = true;
  return ans;
}
