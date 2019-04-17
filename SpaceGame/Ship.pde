class Ship{
  Matrix decision;
  BigNeuralNet brain;
  double [] inputLayer;
  int triangleLength;
  float inscribedRadius;
  boolean alive;
  int warps;
  long score;
  long good;
  
  // Column vector for each vertex
  Matrix topVertex;
  Matrix leftVertex;
  Matrix rightVertex;
  float deltaX;
  float deltaY;
  int speed;
  float rotateSpeed;
  float angle;
  
  Ship(){
    reset();
    int firstHiddenLayerNodes = 10;
    int secondHiddenLayerNodes = 10;
    brain = new BigNeuralNet(firstHiddenLayerNodes, rockCount + 1, secondHiddenLayerNodes, firstHiddenLayerNodes + 1, 3, secondHiddenLayerNodes + 1);
  }
  
  void reset(){
    decision = new Matrix(3, 1);
    inputLayer = new double [rockCount];
    triangleLength = 30;
    inscribedRadius = triangleLength * sqrt(3) / 6;
    alive= true;
    warps = 0;
    score = 0;
    good = 0;
    
    // The distance of the top vertex to the cetner of the triangle is equal to the triangleLength / sqrt(3)
    topVertex = new Matrix(2, 1);
    topVertex.arrayToMatrix(new double[] {0, 0 - (triangleLength / sqrt(3))});
    // To get the next vertex simply take a previous vertex and rotate by 120 degrees or 2 * PI / 3 radians
    leftVertex = multiplyMatrices(rotationMatrix(2 * PI / 3), topVertex);
    rightVertex = multiplyMatrices(rotationMatrix(2 * PI / 3), leftVertex);
    
    deltaX = 0;
    deltaY = 0;
    speed = 0;
    rotateSpeed = 0;
    angle = 0; 
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
    triangle((float)(topVertex.matrix[0][0] + width/2 + deltaX), (float)(topVertex.matrix[1][0] + height/2 + deltaY), (float)(leftVertex.matrix[0][0] + width/2 + deltaX), (float)(leftVertex.matrix[1][0] + height/2 + deltaY), (float)(rightVertex.matrix[0][0] + width/2 + deltaX), (float)(rightVertex.matrix[1][0] + height/2 + deltaY));
    fill(255,0,0);
    ellipse((float)(topVertex.matrix[0][0] + width/2 + deltaX), (float)(topVertex.matrix[1][0] + height/2 + deltaY), 5, 5);
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
    topVertex = multiplyMatrices(rotationMatrix(rotateSpeed), topVertex);
    
    // To get the next vertex simply take a previous vertex and rotate by 120 degrees or 2 * PI / 3 radians 
    leftVertex = multiplyMatrices(rotationMatrix(2 * PI / 3), topVertex);
    rightVertex = multiplyMatrices(rotationMatrix(2 * PI / 3), leftVertex);
  }
  
  void act(){
    /*
    if(round((float)decision.matrix[0][0]) == 0){ // Decides not to move forward
      speed = 0;
    }
    else{ // Decides to move forward
      speed = 5;
    }
    if(round((float)decision.matrix[1][0]) == 1 && round((float)decision.matrix[2][0]) == 0){ // Decides not to turn left
      rotateSpeed = -PI/30;
    }
    else if(round((float)decision.matrix[1][0]) == 0 && round((float)decision.matrix[2][0]) == 1){
      rotateSpeed = PI/30;
    }
    else{
      rotateSpeed = 0;
    }
    */
    if(decision.matrix[0][0] > 0.8){
      speed = 5;
    }
    else{
      speed = 0;
    }
    if(decision.matrix[1][0] > 0.8 && !(decision.matrix[2][0] > 0.8)){
      rotateSpeed = -PI/30;
    }
    else if(decision.matrix[2][0] > 0.8 && !(decision.matrix[1][0] > 0.8)){
      rotateSpeed = PI/30;
    }
    else rotateSpeed = 0;
  }
  
  void look(){
    double [] distances = new double [rockCount];
    for(int i = 0; i < rockCount; i++){
      distances[i] = distance(deltaX, deltaY, (float)rock[i].center.matrix[0][0], (float)rock[i].center.matrix[1][0]);
    }
    inputLayer = normalize(distances);
    
    /*int [] ids = new int [8]; 
    for(int i = 0; i < 8; i++) ids[i] = -1;
    double [] distances = new double [8];
    boolean found = false;
    float x;
    float y;
    int count = 0;
    
    x = deltaX;
    y = deltaY;
    while(x < width / 2){
      x = x + 20;
      for(int i = 0; i < rockCount; i++){
        if(collision(x, y, (float)rock[i].center.matrix[0][0], (float)rock[i].center.matrix[1][0], 20, rock[i].radius)){
          found = true;
          ids[0] = i;
          distances[0] = distance(deltaX, deltaY, (float)rock[i].center.matrix[0][0], (float)rock[i].center.matrix[1][0]);
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
      for(int i = 0; i <rockCount; i++){
        if(collision(x, y, (float)rock[i].center.matrix[0][0], (float)rock[i].center.matrix[1][0], 20, rock[i].radius)){
          found = true;
          ids[1] = i;
          distances[1] = distance(deltaX, deltaY, (float)rock[i].center.matrix[0][0], (float)rock[i].center.matrix[1][0]);
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
      for(int i = 0; i < rockCount; i++){
        if(collision(x, y, (float)rock[i].center.matrix[0][0], (float)rock[i].center.matrix[1][0], 20, rock[i].radius)){
          found = true;
          ids[2] = i;
          distances[2] = distance(deltaX, deltaY, (float)rock[i].center.matrix[0][0], (float)rock[i].center.matrix[1][0]);
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
      for(int i = 0; i < rockCount; i++){
        if(collision(x, y, (float)rock[i].center.matrix[0][0], (float)rock[i].center.matrix[1][0], 20, rock[i].radius)){
          found = true;
          ids[3] = i;
          distances[3] = distance(deltaX, deltaY, (float)rock[i].center.matrix[0][0], (float)rock[i].center.matrix[1][0]);
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
      for(int i = 0; i < rockCount; i++){
        if(collision(x, y, (float)rock[i].center.matrix[0][0], (float)rock[i].center.matrix[1][0], 20, rock[i].radius)){
          found = true;
          ids[4] = i;
          distances[4] = distance(deltaX, deltaY, (float)rock[i].center.matrix[0][0], (float)rock[i].center.matrix[1][0]);
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
      for(int i = 0; i < rockCount; i++){
        if(collision(x, y, (float)rock[i].center.matrix[0][0], (float)rock[i].center.matrix[1][0], 20, rock[i].radius)){
          found = true;
          ids[5] = i;
          distances[5] = distance(deltaX, deltaY, (float)rock[i].center.matrix[0][0], (float)rock[i].center.matrix[1][0]);
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
      for(int i = 0; i < rockCount; i++){
        if(collision(x, y, (float)rock[i].center.matrix[0][0], (float)rock[i].center.matrix[1][0], 20, rock[i].radius)){
          found = true;
          ids[6] = i;
          distances[6] = distance(deltaX, deltaY, (float)rock[i].center.matrix[0][0], (float)rock[i].center.matrix[1][0]);
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
      for(int i = 0; i < rockCount; i++){
        if(collision(x, y, (float)rock[i].center.matrix[0][0], (float)rock[i].center.matrix[1][0], 20, rock[i].radius)){
          found = true;
          ids[7] = i;
          distances[7] = distance(deltaX, deltaY, (float)rock[i].center.matrix[0][0], (float)rock[i].center.matrix[1][0]);
          break;
        }
      }
      if(found) break;
    }
    if(!found) distances[7] = distance(0, 0, count * 20, count * 20);
    
    for(int i = 0; i < rockCount; i++) rock[i].defaultColor = color(101, 67, 33);
    for(int i = 0; i < 8; i++){
      if(ids[i] != -1){
        rock[ids[i]].defaultColor = color(255, 255, 0);
        if(distances[i] > 150) score = score + 1;
      }
    }
    
    double [] normalizedDistance = normalize(distances);
    for(int i = 0; i < 8; i++){
      inputLayer[i + 1] = normalizedDistance[i];
    }
    */
  }
  
  void think(){
    Matrix inputMatrix = new Matrix(rockCount, 1);
    inputMatrix.arrayToMatrix(inputLayer); 
    inputMatrix.addBias();
    
    Matrix first_hiddenLayer = multiplyMatrices(brain.input_hidden, inputMatrix);
    first_hiddenLayer.activate();
    first_hiddenLayer.addBias();
    
    Matrix second_hiddenLayer = multiplyMatrices(brain.hidden_hidden, first_hiddenLayer);
    second_hiddenLayer.activate();
    second_hiddenLayer.addBias();
    
    Matrix outputLayer = multiplyMatrices(brain.hidden_output, second_hiddenLayer);
    outputLayer.activate();
    decision = outputLayer;
    
    /*
    Matrix hiddenLayer_withoutBias = multiplyMatrices(brain.input_hidden, inputMatrix);
    hiddenLayer_withoutBias.activate();
    double [] hiddenLayer_withoutBias_array = hiddenLayer_withoutBias.getArray();
    double [] hiddenLayer = new double [brain.row1 + 1];
    hiddenLayer[0] = 1;
    for(int i = 0; i < brain.row1; i++){
      hiddenLayer[i + 1] = hiddenLayer_withoutBias_array[i];
    }
    Matrix hiddenLayerMatrix = new Matrix(brain.row1 + 1, 1);
    hiddenLayerMatrix.arrayToMatrix(hiddenLayer);
    
    Matrix outputLayer = multiplyMatrices(brain.hidden_output, hiddenLayerMatrix);
    outputLayer.activate();
    decision = outputLayer; //<>//
    */
  }
  
  Ship crossover(Ship a){
    Ship temp = new Ship();
    int randR = floor(random(brain.input_hidden.row));
    int randC = floor(random(brain.input_hidden.col));
    for(int i = 0; i < brain.input_hidden.row; i++){
      for(int j = 0; j < brain.input_hidden.col; j++){
        if ((i< randR)|| (i==randR && j<=randC)) {
          temp.brain.input_hidden.matrix[i][j] = brain.input_hidden.matrix[i][j];
        } 
        else { 
          temp.brain.input_hidden.matrix[i][j] = a.brain.input_hidden.matrix[i][j];
        }
      }
    }
    
    randR = floor(random(brain.hidden_output.row));
    randC = floor(random(brain.hidden_output.col));
    for(int i = 0; i < brain.hidden_output.row; i++){
      for(int j = 0; j < brain.hidden_output.col; j++){
        if ((i< randR)|| (i==randR && j<=randC)) {
          temp.brain.hidden_output.matrix[i][j] = brain.hidden_output.matrix[i][j];
        } 
        else { 
          temp.brain.hidden_output.matrix[i][j] = a.brain.hidden_output.matrix[i][j];
        }
      }
    }
    
    randR = floor(random(brain.hidden_hidden.row));
    randC = floor(random(brain.hidden_hidden.col));
    for(int i = 0; i < brain.hidden_hidden.row; i++){
      for(int j = 0; j < brain.hidden_hidden.col; j++){
        if ((i< randR)|| (i==randR && j<=randC)) {
          temp.brain.hidden_hidden.matrix[i][j] = brain.hidden_hidden.matrix[i][j];
        } 
        else { 
          temp.brain.hidden_hidden.matrix[i][j] = a.brain.hidden_hidden.matrix[i][j];
        }
      }
    }
    
    return temp;
  }
}
