public class Matrix{
  int row;
  int col;
  float[][] matrix;
  
  Matrix(int r, int c) {
    row = r;
    col = c;
    matrix = new float[row][col];
  }
  
  Matrix(float[][] m) {
    matrix = m;
    col = m.length;
    row = m[0].length;
  }
  
  void arrayToMatrix(float[] arr) {
    for (int i = 0; i< row; i++) {
      for (int j = 0; j< col; j++) {
        matrix[i][j] =  arr[i * col + j];
      }
    }
  }
  
  // this just takes a matrix and gives it a random value  
  void randomizer(){
    for(int i = 0; i < row;i++){
      for(int j = 0; j < col; j++){
        matrix[i][j] = random(0,1);
      }
    }
  }
  
  void Activation(){
    for(int i = 0; i < row; i++){
      for(int j = 0; j < col; j++){
        matrix[i][j] = (1)/(1+exp(-matrix[i][j]));
      }
    }
  }
}
