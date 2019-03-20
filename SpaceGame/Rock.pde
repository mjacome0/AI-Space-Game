class Rock{
  // The radius of the circle that surrounds the visible square. The rocks are generate randomly along this circle 
  float circleRadius = 800 * sqrt(2) / 2;
  int radius;
  // Column vector                 [ x ]
  // Holds the x, y coordinates    [ y ]
  Matrix center = new Matrix(2, 1);
  float slope;
  float speed;
  color defaultColor = color(101, 67, 33);
  
  Rock(){
    radius = 20;
    reset();
  }
  
  void display(){
    fill(defaultColor);
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
