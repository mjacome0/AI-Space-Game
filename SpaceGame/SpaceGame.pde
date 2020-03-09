Ship [] ships;
Rock [] rocks;
int shipCount = 400;
int rockCount = 15;
int startTime = 0;
int gen = 1;
PrintWriter output;
void setup() {
  frameRate(600);
  size(800, 800);
  background(0);
  noStroke();
  ellipseMode(CENTER);
  ships = new Ship[shipCount];
  rocks = new Rock[rockCount];
  output = createWriter("final.txt");
  for (int i = 0; i < shipCount; i++) {
    ships[i] = new Ship();
  }
  for (int i = 0; i < rockCount; i++) {
    rocks[i] = new Rock();
  }
  startTime = millis();
}
void draw() {
  int gameTime = millis() - startTime;
  background(0);
  textSize(32);
  fill(255, 255, 255);
  text("Score", 650, 100);
  text(gameTime / 1000, 650, 150);
  for (int i = shipCount - 1; i >= 0; i--) {
    if (ships[i].alive) {
      if (i == 0) ships[i].display(true);
      else ships[i].display(false);
      ships[i].look();
      ships[i].think();
      ships[i].act();
      ships[i].score = ships[i].score + 1;
      ships[i].spin();
      ships[i].move();
      for (int j = 0; j < rockCount; j++) {
        if (collision(ships[i].deltaX, ships[i].deltaY, (float)rocks[j].center.matrix[0][0], 
          (float)rocks[j].center.matrix[1][0], ships[i].inscribedRadius, rocks[j].radius)) {
          ships[i].alive = false;
          if (ships[i].wrapAroundCount > 0) ships[i].score = (long)sqrt(ships[i].score);
          break;
        }
      }
    }
  }
  for (int i = 0; i < rockCount; i++) {
    rocks[i].display();
    rocks[i].move();
  }
  boolean shipAlive = false;
  for (int i = 0; i < shipCount; i++) {
    if (ships[i].alive) {
      shipAlive = true;
      break;
    }
  }
  if (!shipAlive) {
    for (int i = 0; i < rockCount; i++) {
      rocks[i].reset();
    }
    int index = 0;
    long highestScore = ships[0].score;
    for (int i = 0; i < shipCount; i++) {
      if (ships[i].score > highestScore) {
        index = i;
        highestScore = ships[i].score;
      }
    }
    println("Score: " + ships[index].score + "\tWraps: " + ships[index].wrapAroundCount + "\tTime:" + (gameTime / 1000) + "\t\tGen: " + gen);
    output.println(ships[index].score);
    if (ships[index].score > 2147483646) {
      output.flush(); // Writes the remaining data to the file
      output.close(); // Finishes the file
      exit(); // Stops the program
    }
    Ship [] nextGen = new Ship[shipCount];
    nextGen[0] = ships[index].clone();
    for (int i = 1; i < shipCount; i++) {
      if (i < shipCount / 2) {
        nextGen[i] = ships[selectShip()].clone();
      } else {
        int parentIndex1;
        int parentIndex2;
        do {
          parentIndex1 = selectShip();
          parentIndex2 = selectShip();
        } while (parentIndex1 == parentIndex2);
        nextGen[i] = ships[parentIndex1].crossover(ships[parentIndex2]).clone();
      }
      nextGen[i].mutate(0.1);
    }
    for (int i = 0; i < shipCount; i++) ships[i] = nextGen[i].clone();
    gen = gen + 1;
    startTime = millis();
  }
}
// Takes two matrices and returns the product between them
public Matrix multiplyMatrices (Matrix mat1, Matrix mat2) {
  Matrix res = new Matrix(mat1.row, mat2.col);
  for (int i = 0; i < mat1.row; i++) {
    for (int j = 0; j < mat2.col; j++) {
      res.matrix[i][j] = 0;
      for (int k = 0; k < mat1.col; k++) {
        res.matrix[i][j] = res.matrix[i][j] + (mat1.matrix[i][k] * mat2.matrix[k][j]);
      }
    }
  }
  return res;
}
// Takes an angle and returns the rotation matrix for that angle
public Matrix rotationMatrix (float radians) {
  Matrix res = new Matrix(2, 2);
  res.arrayToMatrix(new double[] {cos(radians), -sin(radians), sin(radians), cos(radians)});
  return res;
}
public double distance(float x1, float y1, float x2, float y2) {
  double ans = sqrt(pow(x1 - x2, 2) + pow(y1 - y2, 2));
  return ans;
}
public boolean collision(float x1, float y1, float x2, float y2, float r1, float r2) {
  boolean ans = false;
  double distance = distance(x1, y1, x2, y2);
  if (distance < (r1 + r2)) ans = true;
  return ans;
}
public double [] normalize(double [] input) {
  int size = input.length;
  double [] res = new double[size];
  for (int i = 0; i < size; i++) {
    res[i] = (input[i] - 10)/((800 * sqrt(2)) - 10);
  }
  return res;
}
int selectShip() {
  long totalScore = 0;
  for (int i = 0; i < shipCount; i++) {
    totalScore = totalScore + ships[i].score;
  }
  long rand = 0;
  long sum = 0;
  int index = 0;
  rand = (int)random(totalScore);
  sum = 0;
  for (int i = 0; i < shipCount; i++) {
    sum = sum + ships[i].score;
    if (sum > rand) {
      index = i;
      break;
    }
  }
  return index;
}
void keyPressed() {
  output.flush(); // Writes the remaining data to the file
  output.close(); // Finishes the file
  exit(); // Stops the program
}
