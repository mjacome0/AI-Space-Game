Ship [] ship;
Rock [] rock;
int shipCount = 400;
int rockCount = 15;
int startTime = 0;

void setup(){
  frameRate(600);
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
  text(gameTime, 650, 150);
  int index = 0;
  for(int i = shipCount- 1 ; i >= 0; i--){
    if(ship[i].alive){
      index = i;
      break;
    }
  }
  
  for(int i = 0; i < shipCount; i++){
    if(ship[i].alive){
      if(i == index) ship[i].display(true);
      else ship[i].display(false);
      ship[i].look();
      ship[i].think();
      ship[i].act();
      ship[i].spin();
      ship[i].move();
      for(int j = 0; j < rockCount; j++){
        if(collision(ship[i].deltaX, ship[i].deltaY, (float)rock[j].center.matrix[0][0], (float)rock[j].center.matrix[1][0], ship[i].inscribedRadius, rock[j].radius)){
          ship[i].alive = false;
          if(ship[i].warps != 0) ship[i].score = ship[i].score - (long)pow(ship[i].warps + 5, 3);
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
    println("Score: " + ship[shipCount - 1].score + "\t\tWarps: " + ship[shipCount - 1].warps + "\tTime: " + (gameTime/1000));
    for(int i = shipCount / 2, j = 0; i < shipCount; i = i + 2, j++){
      ship[j] = ship[i].crossover(ship[i + 1]);
    }
    for(int i = 0; i < shipCount; i++) ship[i].reset();
    for(int i = shipCount / 4; i < shipCount; i++) {
      ship[i].brain.hidden_output.mutate(0.08);
      ship[i].brain.input_hidden.mutate(0.08);
      ship[i].brain.hidden_hidden.mutate(0.08);
    }
    startTime = millis();
  }
}


void keyReleased(){
  if(key == CODED){
    if(keyCode == UP){
      ship[0].speed = 0;
    }
    if (keyCode == LEFT){
      ship[0].rotateSpeed = 0;
    }
    if (keyCode == RIGHT){
      ship[0].rotateSpeed = 0;
    }
  }
}

void keyPressed(){
  if(key == CODED){
    if(keyCode == UP){
      ship[0].speed = 5;
    }
    else if (keyCode == LEFT){
      ship[0].rotateSpeed = -PI/30;
    }
    else if (keyCode == RIGHT){
      ship[0].rotateSpeed = PI/30;
    }
  }
}


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
  /*double sum = 0;
  for(int i = 0; i < size; i++){
    sum = sum + input[i];
  }
  double avg = sum / size;
  double total = 0;
  for(int i = 0; i < size; i++){
    total = total + pow((float)(input[i] - avg), 2);
  }
  double var = total / (input.length - 1);
  double [] res = new double[size];
  for(int i = 0; i < size; i++){
    res[i] = (input[i] - avg) / sqrt((float)(var + 0.000000001));
  }
  */
  double [] res = new double[size];
  for(int i = 0; i < size; i++){
    res[i] = (input[i] - 28.66)/((800 * sqrt(2)) - 28.66);
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
