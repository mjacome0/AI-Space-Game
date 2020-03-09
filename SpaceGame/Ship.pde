class Ship {
  Matrix decision;
  BigNeuralNet brain;
  //BigNeuralNet brain; Uses big neural network
  double [] inputLayer;
  int triangleLength;
  float inscribedRadius;
  boolean alive;
  int wrapAroundCount;
  long score;
  int good;
  // Column vector for each vertex
  Matrix topVertex;
  Matrix leftVertex;
  Matrix rightVertex;
  float deltaX;
  float deltaY;
  int speed;
  float rotateSpeed;
  float angle;
  Ship() {
    int firstHiddenLayerNodes = 10;
    int secondHiddenLayerNodes = 10;
    brain = new BigNeuralNet(firstHiddenLayerNodes, 9, secondHiddenLayerNodes, 
      firstHiddenLayerNodes + 1, 3, secondHiddenLayerNodes + 1);
    decision = new Matrix(3, 1);
    inputLayer = new double [8];
    topVertex = new Matrix(2, 1);
    reset();
  }
  Ship clone() {
    Ship temp = new Ship();
    temp.brain = brain.clone();
    return temp;
  }
  void reset() {
    triangleLength = 30;
    inscribedRadius = triangleLength * sqrt(3) / 6;
    alive= true;
    wrapAroundCount = 0;
    score = 0;
    good = 0;
    // The distance of the top vertex to the cetner of the triangle is equal to the triangleLength /sqrt(3)
    double [] topPoint = {0, 0 - (triangleLength / sqrt(3))};
    topVertex.arrayToMatrix(topPoint);
    // To get the next vertex simply take a previous vertex and rotate by 120 degrees or 2 * PI / 3radians
    leftVertex = multiplyMatrices(rotationMatrix(2 * PI / 3), topVertex);
    rightVertex = multiplyMatrices(rotationMatrix(2 * PI / 3), leftVertex);
    deltaX = 0;
    deltaY = 0;
    speed = 0;
    rotateSpeed = 0;
    angle = 0;
  }
  void display(boolean x) {
    // Some statements to allow teleporting if ship goes beyond viewable screen
    if (deltaX > width/2) {
      deltaX = -width/2;
      wrapAroundCount = wrapAroundCount + 1;
    }
    if (deltaX < -width/2) {
      deltaX = width/2;
      wrapAroundCount = wrapAroundCount + 1;
    }
    if (deltaY > height/2) {
      deltaY = -height/2;
      wrapAroundCount = wrapAroundCount + 1;
    }
    if (deltaY < -height/2) {
      deltaY = height/2;
      wrapAroundCount = wrapAroundCount + 1;
    }
    if (x) fill(0, 255, 0);
    else fill(255, 255, 255);
    // deltaX and deltaY describe how much the center of the triangle has moved. This is prettymuch the coordinates for the center of the triangle
    // The vertex coordinates help when drawing the triangle facing the proper direction
    // width / 2 and height / 2 are added to make the origin the center of the visible screen
    triangle((float)(topVertex.matrix[0][0] + width/2 + deltaX), (float)(topVertex.matrix[1][0] +
      height/2 + deltaY), (float)(leftVertex.matrix[0][0] + width/2 + deltaX), (float)(leftVertex.matrix[1][0]
      + height/2 + deltaY), (float)(rightVertex.matrix[0][0] + width/2 + deltaX), 
      (float)(rightVertex.matrix[1][0] + height/2 + deltaY));
    if (x) fill(0, 255, 0);
    else fill(255, 0, 0);
    ellipse((float)(topVertex.matrix[0][0] + width/2 + deltaX), (float)(topVertex.matrix[1][0] +
      height/2 + deltaY), 5, 5);
    if (x) fill(0, 255, 0);
    else fill(0, 0, 255);
    ellipse(width/2 + deltaX, height/2 + deltaY, inscribedRadius * 2, inscribedRadius * 2);
  }
  void move() {
    // The ship can only move in the direction it's facing
    // The angle keeps track of how much the ship has rotated
    // Polar coordinates help since we're moving some distance away from the center according to an angle
    // Added 90 degrees since 0 degrees lies along the postive x axis
    // The ship begins where it's facing the postive y axis
    deltaX = deltaX - speed * cos(angle + PI/2);
    deltaY = deltaY - speed * sin(angle + PI/2);
  }
  void spin() {
    // When spinning keep track of the angle
    // Cacluate the top vertex by multiplying the top vertex with the rotation vertex
    angle = angle + rotateSpeed;
    topVertex = multiplyMatrices(rotationMatrix(rotateSpeed), topVertex);
    // To get the next vertex simply take a previous vertex and rotate by 120 degrees or 2 * PI / 3radians
    leftVertex = multiplyMatrices(rotationMatrix(2 * PI / 3), topVertex);
    rightVertex = multiplyMatrices(rotationMatrix(2 * PI / 3), leftVertex);
  }
  void act() {
    if (decision.matrix[0][0] > 0.7) {
      speed = 5;
    } else {
      speed = 0;
    }
    if (decision.matrix[1][0] > 0.7 && !(decision.matrix[2][0] > 0.7)) {
      rotateSpeed = -PI/30;
    } else if (decision.matrix[2][0] > 0.7 && !(decision.matrix[1][0] > 0.7)) {
      rotateSpeed = PI/30;
    } else rotateSpeed = 0;
  }
  void look() {
    double [] distances = new double [8];
    for (int i = 0; i < 8; i++) {
      distances[i] = lookInDirection(angle + PI/2 + (i * PI / 4));
    }
    inputLayer = normalize(distances);
  }
  double lookInDirection(float direction) {
    float x = deltaX;
    float y = deltaY;
    int i = 0;
  whileLoop:
    do {
      i = i + 1;
      x = deltaX - (10 * i) * cos(direction);
      y = deltaY - (10 * i) * sin(direction);
      for (int j = 0; j < rockCount; j++) {
        if (collision(x, y, (float)rocks[j].center.matrix[0][0], (float)rocks[j].center.matrix[1][0], 50, 
          rocks[j].radius)) break whileLoop;
      }
    } while (x > - width / 2 && x < width / 2 && y > - height / 2 && y < height / 2);
    return distance(x, y, deltaX, deltaY);
  }
  void think() {
    Matrix inputMatrix = new Matrix(8, 1);
    inputMatrix.arrayToMatrix(inputLayer);
    decision = brain.feedForward(inputMatrix);
  }
  Ship crossover(Ship p) {
    Ship temp = new Ship();
    temp.brain = brain.crossover(p.brain);
    return temp;
  }
  void mutate(float rate) {
    brain.mutate(rate);
  }
}
