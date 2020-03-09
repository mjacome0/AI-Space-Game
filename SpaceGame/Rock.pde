class Rock {
  // The radius of the circle that surrounds the visible square. The rocks are generate randomly along this circle
  float circleRadius = 800 * sqrt(2) / 2;
  int radius;
  // Column vector [ x ]
  // Holds the x, y coordinates [ y ]
  Matrix center = new Matrix(2, 1);
  double slope;
  float speed;
  color defaultColor = color(101, 67, 33);
  Rock() {
    radius = 20;
    reset();
  }
  void display() {
    fill(defaultColor);
    ellipse((float)center.matrix[0][0] + width / 2, (float)center.matrix[1][0] + height / 2, radius * 2, 
      radius * 2);
  }
  void move() {
    center.matrix[0][0] = center.matrix[0][0] + speed;
    center.matrix[1][0] = center.matrix[1][0] + slope;
    if (sqrt(pow((float)center.matrix[0][0], 2) + pow((float)center.matrix[1][0], 2)) > circleRadius) {
      reset();
    }
  }
  void reset() {
    center.matrix[0][0] = 0;
    center.matrix[1][0] = circleRadius;
    double rand = random(1);
    double x = 0;
    double y = 0;
    if (rand < 0.3) {
      for (int i = 0; i < shipCount; i++) {
        if (ships[i].alive) {
          x = ships[i].deltaX;
          y = ships[i].deltaY;
        }
      }
    } else {
      x = random(800) - 400;
      y = random(800) - 400;
    }
    do {
      center = multiplyMatrices(rotationMatrix(random(2*PI)), center);
    } while (center.matrix[0][0] == x);
    slope = (y - center.matrix[1][0]) / (x - center.matrix[0][0]);
    while ((center.matrix[0][0] == x) || ((slope > 5) || (slope < -5))) {
      center = multiplyMatrices(rotationMatrix(random(2*PI)), center);
      slope = (y - center.matrix[1][0]) / (x - center.matrix[0][0]);
    }
    if (x > center.matrix[0][0]) {
      speed = 1;
    } else {
      speed = -1;
      slope = slope * -1;
    }
  }
}
