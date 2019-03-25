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
  
  //should take a number from 0 to 100 and mutate the matrix x amount of time 
  //values are allowed to get mutated twice in the case of larger mutation rates
  void mutation(float rate){
    int i;
    int j;
    rate = 100/rate;
    float amount = (row*col)/rate;
    while(amount > 0){
      i = (int)floor(random(0,row));
      j = (int)floor(random(0,col));
      float randomposneg = random(-1,1);
        double temp = matrix[i][j]/20;
        if(randomposneg > 0){
          matrix[i][j] += temp;
          amount--;
        }
        else{
          matrix[i][j] -= temp;
          amount--;
        }
    }
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
