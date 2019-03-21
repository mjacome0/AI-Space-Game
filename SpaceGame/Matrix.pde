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
    for (int i = 0; i< row; i++) {
      for (int j = 0; j< col; j++) {
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
  void randomizer(int n){
    for(int i = 0; i < row;i++){
      for(int j = 0; j < col; j++){
        matrix[i][j] = randomGaussian() * sqrt(2.0 / n);
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
}
