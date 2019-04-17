public class Matrix{
  int row;
  int col;
  double[][] matrix;
  
  Matrix(int r, int c) {
    row = r;
    col = c;
    matrix = new double[row][col];
  }
  
  Matrix(double[][] m) {
    matrix = m;
    col = m.length;
    row = m[0].length;
  }
  
  void arrayToMatrix(double[] arr) {
    for (int i = 0; i < row; i++) {
      for (int j = 0; j < col; j++) {
        matrix[i][j] =  arr[i * col + j];
      }
    }
  }
  
  double [] getArray(){
    double [] res = new double [row * col];
    for(int i = 0; i < row; i++){
      for(int  j = 0; j < col; j++){
        res[i * col + j] = matrix[i][j];
      }
    }
    return res;
  }
  
  // this just takes a matrix and gives it a random value  
  void randomizer(){
    for(int i = 0; i < row; i++){
      for(int j = 0; j < col; j++){
        matrix[i][j] = random(-1, 1);
      }
    }
  }
  
  void activate(){
    for(int i = 0; i < row; i++){
      for(int j = 0; j < col; j++){
        matrix[i][j] = (1)/(1+exp((float)-matrix[i][j]));
      }
    }
  }
  
  void mutate(float rate){
    for(int i = 0; i < row; i++){
      for(int j = 0; j < col; j++){
        float rand = random(1);
        if(rand < rate){
          matrix[i][j] = matrix[i][j] + randomGaussian() / 5;
          
          if (matrix[i][j] > 1) {
            matrix[i][j] = 1;
          }
          if (matrix[i][j] < -1) {
            matrix[i][j] = -1;
          }
        }
      }
    }
  }
  
  void display(){
    for(int i = 0; i < row; i++){
      for(int j = 0; j < col; j++){
        print(matrix[i][j] + " ");
      }
      println();
    }
  }
  
  void addBias(){
    double [][]temp = new double[row + 1][col];
    for(int i = 0; i < row; i++){
      for(int j = 0; j < col; j++){
        temp[i][j] = matrix[i][j];
      }
    }
    temp[row][col - 1] = 1;
    row = row + 1;
    matrix = temp;
  }
}
