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
    float [] temp = new float[] {1, 1, 1};
    decision.arrayToMatrix(temp);
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
  
  void look(){
    int [] ids = new int [8]; 
    for(int i = 0; i < 8; i++) ids[i] = -1;
    float [] distances = new float [8];
    boolean found = false;
    float x;
    float y;
    int count = 0;
    
    x = deltaX;
    y = deltaY;
    while(x < width / 2){
      x = x + 20;
      for(int i = 0; i < 10; i++){
        if(collision(x, y, rock[i].center.matrix[0][0], rock[i].center.matrix[1][0], 20, rock[i].radius)){
          found = true;
          ids[0] = i;
          distances[0] = distance(deltaX, deltaY, rock[i].center.matrix[0][0], rock[i].center.matrix[1][0]);
          break;
        }
      }
      if(found) break;
    }
    if(!found) distances[0] = width / 2 - deltaX;
    
    x = deltaX;
    y = deltaY;
    found = false;
    while(x > - width / 2){
      x = x - 20;
      for(int i = 0; i < 10; i++){
        if(collision(x, y, rock[i].center.matrix[0][0], rock[i].center.matrix[1][0], 20, rock[i].radius)){
          found = true;
          ids[1] = i;
          distances[1] = distance(deltaX, deltaY, rock[i].center.matrix[0][0], rock[i].center.matrix[1][0]);
          break;
        }
      }
      if(found) break;
    }
    if(!found) distances[1] = deltaX + width / 2;
    
    x = deltaX;
    y = deltaY;
    found = false;
    while(y < height / 2){
      y = y + 20;
      for(int i = 0; i < 10; i++){
        if(collision(x, y, rock[i].center.matrix[0][0], rock[i].center.matrix[1][0], 20, rock[i].radius)){
          found = true;
          ids[2] = i;
          distances[2] = distance(deltaX, deltaY, rock[i].center.matrix[0][0], rock[i].center.matrix[1][0]);
          break;
        }
      }
      if(found) break;
    }
    if(!found) distances[2] = height / 2 - deltaY;
    
    x = deltaX;
    y = deltaY;
    found = false;
    while(y > - height / 2){
      y = y - 20;
      for(int i = 0; i < 10; i++){
        if(collision(x, y, rock[i].center.matrix[0][0], rock[i].center.matrix[1][0], 20, rock[i].radius)){
          found = true;
          ids[3] = i;
          distances[3] = distance(deltaX, deltaY, rock[i].center.matrix[0][0], rock[i].center.matrix[1][0]);
          break;
        }
      }
      if(found) break;
    }
    if(!found) distances[3] = height / 2 + deltaY;
    
    x = deltaX;
    y = deltaY;
    found = false;
    count = 0;
    while(x < width / 2 && y < height / 2){
      count = count + 1;
      x = x + 20;
      y = y + 20;
      for(int i = 0; i < 10; i++){
        if(collision(x, y, rock[i].center.matrix[0][0], rock[i].center.matrix[1][0], 20, rock[i].radius)){
          found = true;
          ids[4] = i;
          distances[4] = distance(deltaX, deltaY, rock[i].center.matrix[0][0], rock[i].center.matrix[1][0]);
          break;
        }
      }
      if(found) break;
    }
    if(!found) distances[4] = distance(0, 0, count * 20, count * 20);
    
    x = deltaX;
    y = deltaY;
    found = false;
    count = 0;
    while(x < width / 2 && y > - height / 2){
      count = count + 1;
      x = x + 20;
      y = y - 20;
      for(int i = 0; i < 10; i++){
        if(collision(x, y, rock[i].center.matrix[0][0], rock[i].center.matrix[1][0], 20, rock[i].radius)){
          found = true;
          ids[5] = i;
          distances[5] = distance(deltaX, deltaY, rock[i].center.matrix[0][0], rock[i].center.matrix[1][0]);
          break;
        }
      }
      if(found) break;
    }
    if(!found) distances[5] = distance(0, 0, count * 20, count * 20);
    
    x = deltaX;
    y = deltaY;
    found = false;
    count = 0;
    while(x > - width / 2 && y < height / 2){
      count = count + 1;
      x = x - 20;
      y = y + 20;
      for(int i = 0; i < 10; i++){
        if(collision(x, y, rock[i].center.matrix[0][0], rock[i].center.matrix[1][0], 20, rock[i].radius)){
          found = true;
          ids[6] = i;
          distances[6] = distance(deltaX, deltaY, rock[i].center.matrix[0][0], rock[i].center.matrix[1][0]);
          break;
        }
      }
      if(found) break;
    }
    if(!found) distances[6] = distance(0, 0, count * 20, count * 20);
    
    x = deltaX;
    y = deltaY;
    found = false;
    count = 0;
    while(x > - width / 2 && y > - height / 2){
      count = count + 1;
      x = x - 20;
      y = y - 20;
      for(int i = 0; i < 10; i++){
        if(collision(x, y, rock[i].center.matrix[0][0], rock[i].center.matrix[1][0], 20, rock[i].radius)){
          found = true;
          ids[7] = i;
          distances[7] = distance(deltaX, deltaY, rock[i].center.matrix[0][0], rock[i].center.matrix[1][0]);
          break;
        }
      }
      if(found) break;
    }
    if(!found) distances[7] = distance(0, 0, count * 20, count * 20);
    //println(distances[7]);
    
    for(int i = 0; i < 10; i++) rock[i].defaultColor = color(101, 67, 33);
    for(int i = 0; i < 8; i++) if(ids[i] != -1) rock[ids[i]].defaultColor = color(255, 255, 0);
  }
}
