class Ship{
  Matrix decision = new Matrix(3,1);
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
  
  void act(){
    if(decision.matrix[0][0] == 0){ // Decides not to move forward
      ship.speed = 0;
      timeStill = millis(); // Ship went from moving to not moving. Begin to keep track of time ship isn't moving 
      totalTimeMoving = totalTimeMoving + int((millis() - timeMoving) / 500); // Ship stopped moving so update total time ship was moving
    }
    else{ // Decides to move forward
      ship.speed = 5;
      totalTimeStill = totalTimeStill + int((millis() - timeStill) / 500); // Ship started moving so update total time ship was not moving 
      timeMoving = millis(); // Ship went from not moving to moving. Begin to keep track of time ship is moving
    }
    if(decision.matrix[1][0] == 1 && decision.matrix[2][0] == 0){ // Decides not to turn left
      ship.rotateSpeed = -PI/30;
    }
    else if(decision.matrix[1][0] == 0 && decision.matrix[2][0] == 1){
      ship.rotateSpeed = PI/30;
    }
    else{
      ship.rotateSpeed = 0;
    }
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
  
  void look(Rock a){
    int [] lastMultiple = new int [8]; 
    boolean inBox = true;
    boolean found = false;
    float x;
    float y;
    int i = 0;
    while(inBox){
      inBox = false;
      x = deltaX;
      y = deltaY;
      i = i + 1;
      if(deltaX + (i * 20) < width / 2){
        if(collision(x + (i * 20), y, a.center.matrix[0][0], a.center.matrix[1][0], 20, a.radius)){
          found = true;
          break;
        }
        inBox = true;
      }
      else{
        if(lastMultiple[0] == 0){
          lastMultiple[0] = i;
        }
      }
      
      if(deltaX - (i * 20) > - width / 2){
        if(collision(x - (i * 20), y, a.center.matrix[0][0], a.center.matrix[1][0], 20, a.radius)){
          found = true;
          break;
        }
        inBox = true;
      }
      else{
        if(lastMultiple[1] == 0){
          lastMultiple[1] = i;
        }
      }
      
      if(deltaY + (i * 20) < height / 2){
        if(collision(x, y + (i * 20), a.center.matrix[0][0], a.center.matrix[1][0], 20, a.radius)){
          found = true;
          break;
        }
        inBox = true;
      }
      else{
        if(lastMultiple[2] == 0){
          lastMultiple[2] = i;
        }
      }
      
      if(deltaY - (i * 20) > - height / 2){
        if(collision(x, y - (i * 20), a.center.matrix[0][0], a.center.matrix[1][0], 20, a.radius)){
          found = true;
          break;
        }
        inBox = true;
      }
      else{
        if(lastMultiple[3] == 0){
          lastMultiple[3] = i;
        }
      }
      
      if(deltaX + (i * 20) < width / 2 && deltaY + (i * 20) < height / 2){
        if(collision(x + (i * 20), y + (i * 20), a.center.matrix[0][0], a.center.matrix[1][0], 20, a.radius)){
          found = true;
          break;
        }
        inBox = true;
      }
      else{
        if(lastMultiple[4] == 0){
          lastMultiple[4] = i;
        }
      }
      
      if(deltaX + (i * 20) < width / 2 && deltaY - (i * 20) > - height / 2){
        if(collision(x + (i * 20), y - (i * 20), a.center.matrix[0][0], a.center.matrix[1][0], 20, a.radius)){
          found = true;
          break;
        }
        inBox = true;
      }
      else{
        if(lastMultiple[5] == 0){
          lastMultiple[5] = i;
        }
      }
      
      if(deltaX - (i * 20) > - width / 2 && deltaY + (i * 20) < height / 2){
        if(collision(x - (i * 20), y + (i * 20), a.center.matrix[0][0], a.center.matrix[1][0], 20, a.radius)){
          found = true;
          break;
        }
        inBox = true;
      }
      else{
        if(lastMultiple[6] == 0){
          lastMultiple[6] = i;
        }
      }
      
      if(deltaX - (i * 20) > - width / 2 && deltaY - (i * 20) > - height / 2){
        if(collision(x - (i * 20), y - (i * 20), a.center.matrix[0][0], a.center.matrix[1][0], 20, a.radius)){
          found = true;
          break;
        }
        inBox = true;
      }
      else{
        if(lastMultiple[7] == 0){
          lastMultiple[7] = i;
        }
      }
    }
    if(found){
      a.defaultColor = color(255, 255, 0);
    }
    else{
      a.defaultColor = color(101, 67, 33);
    }
  }
}
