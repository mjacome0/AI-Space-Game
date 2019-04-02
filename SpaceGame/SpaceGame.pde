Ship [] ship;
Rock [] rock;
int shipCount = 1000;
int rockCount = 15;
int startTime = 0;

// Keeping track of time ship is still
long totalTimeStill = 0;
long timeStill = 0;

// Keeping track of time ship is moving 
long totalTimeMoving = 0;
long timeMoving = 0;

void createGame(){
  ship = new Ship[shipCount];
  rock = new Rock[10];
  for(int i = 0; i < shipCount; i++){
    ship[i] = new Ship();
  }
  for(int i = 0; i < 10; i++){
    rock[i] = new Rock();
  }
  timeMoving = 0;
  totalTimeStill = 0;
  totalTimeMoving = 0;
  timeStill = millis(); // Begin keeping track of time still since ship is not moving at first 
}
/*
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
*/

void setup(){
  frameRate(240);
  size(800, 800);
  background(0);
  noStroke();
  ellipseMode(CENTER); 
  ship = new Ship[shipCount];
  rock = new Rock[rockCount];
  for(int i = 0; i < shipCount; i++){
    ship[i] = new Ship();
  }
  for(int i = 0; i < rockCount; i++){
    rock[i] = new Rock();
  }
  startTime = millis();
}

void draw(){
  int gameTime = millis() - startTime;
  background(0);
  textSize(32);
  fill(255,255,255);
  text("Score", 650,100);
  text(gameTime / 1000,650,150);
  for(int i = 0; i < shipCount; i++){
    if(ship[i].alive){
      ship[i].display();
      ship[i].look();
      ship[i].think();
      ship[i].act();
      ship[i].spin();
      ship[i].move();
      for(int j = 0; j < rockCount; j++){
        if(collision(ship[i].deltaX, ship[i].deltaY, (float)rock[j].center.matrix[0][0], (float)rock[j].center.matrix[1][0], ship[i].inscribedRadius, rock[j].radius)){
          ship[i].alive = false;
          ship[i].scoreBefore = ship[i].score;
          if(ship[i].warps != 0) ship[i].score = ship[i].score - (long)pow(ship[i].warps + 5, 8);
        }
      }
    }
  }
  for(int i = 0; i < rockCount; i++){
    rock[i].display();
    rock[i].move();
  }
  boolean shipAlive = false;
  for(int i = 0; i < shipCount; i++){
    if(ship[i].alive){
      shipAlive = true;
      break;
    }
  }
  if(!shipAlive){
    for(int i = 0; i < rockCount; i++){
      rock[i].reset();
    }
    sort(ship, 0, shipCount - 1);
    //println();
    //println("Best ship:");
    println("Score: " + ship[shipCount - 1].score + "\tWarps: " + ship[shipCount - 1].warps + "\tTime: " + (millis() - startTime)/1000);
    //println();
    //println("Worst ship:");
    //println("Score before warps: " + ship[0].scoreBefore + "\tScore: " + ship[0].score + "\tWarps: " + ship[0].warps);
    for(int i = 0; i < shipCount / 2; i++){
      ship[i].reset(true);
    }
    for(int i = shipCount / 2; i < shipCount; i = i + 2){
      ship[i].crossover(ship[i + 1]);
      ship[i].reset(false);
      ship[i + 1].reset(false);
    }
    delay(1000);
    startTime = millis();
  }
  /*
  //println(frameRate);
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
    rock[i].move();
    if(collision(ship.deltaX, ship.deltaY, (float)rock[i].center.matrix[0][0], (float)rock[i].center.matrix[1][0], ship.inscribedRadius, rock[i].radius)){
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
      
      ship.brain.input_hidden.randomizer(9);
      ship.brain.hidden_output.randomizer(6);
      
      createGame();
      break;
    }
  }
  ship.look();
  ship.think();
  ship.act();
  ship.spin();
  ship.move();
  */
}

/*
void keyReleased(){
  if(key == CODED){
    if(keyCode == UP){
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
*/

// Takes two matrices and returns the product between them
public Matrix multiplyMatrices (Matrix mat1, Matrix mat2){
  Matrix res = new Matrix(mat1.row, mat2.col);
  for(int i = 0; i < mat1.row;i++){
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
  res.arrayToMatrix(new double[] {cos(radians), -sin(radians), sin(radians), cos(radians)});
  return res;
}

public double distance(float x1, float y1, float x2, float y2){
  double ans = sqrt(pow(x1 - x2, 2) + pow(y1 - y2, 2));
  return ans;
}

public boolean collision(float x1, float y1, float x2, float y2, float r1, float r2){
  boolean ans = false;
  double distance = distance(x1, y1, x2, y2);
  if(distance < (r1 + r2)) ans = true;
  return ans;
}

public double [] normalize(double [] input){
  int size = input.length;
  double sum = 0;
  for(int i = 0; i < size; i++){
    sum = sum + input[i];
  }
  double avg = sum / size;
  double total = 0;
  for(int i = 0; i < size; i++){
    total = total + pow((float)(input[i] - avg), 2);
  }
  double var = total / sum;
  double [] res = input;
  for(int i = 0; i < size; i++){
    res[i] = (input[i] - avg) / sqrt((float)(var + 0.00001));
  }
  return res;
}

int partition(Ship arr[], int low, int high){ 
  Ship pivot = arr[high];
  int i = low-1; // index of smaller element 
  for (int j=low; j<high; j++){ 
    if (arr[j].score <= pivot.score){ 
      i++; 
      Ship temp = arr[i];
      arr[i] = arr[j];
      arr[j] = temp;
    }
  } 
  Ship temp = arr[i+1]; 
  arr[i+1] = arr[high];
  arr[high] = temp; 
  return i+1; 
}

void sort(Ship arr[], int low, int high) { 
  if(low < high){ 
    int pi = partition(arr, low, high); 
    sort(arr, low, pi-1);
    sort(arr, pi+1, high); 
  }
} 
