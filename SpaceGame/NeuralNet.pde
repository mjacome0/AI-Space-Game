//start of the initial nn 
//right now i just put that it makes the 2 matricies when an instance of it is called
class NeuralNet{
Matrix hidden_output;
Matrix input_hidden;
int row1;
int row2;
int col1;
int col2;
//gave it a changeable 3 layer system just incase we need to change nodes later
  NeuralNet(int r1, int c1,int r2, int c2){
     row1 = r1;
     row2 = r2;
     col1 = c1;
     col2 = c2;
     input_hidden = new Matrix(r1,c1);
     hidden_output = new Matrix(r2,c2); 
     
     input_hidden.randomizer(9);
     hidden_output.randomizer(6);    
  }
  
    NeuralNet crossover(NeuralNet secondShip){
    NeuralNet temp = new NeuralNet(row1,col1,row2,col2);
    for(int i = 0; i < secondShip.input_hidden.row; i++){
      for(int j = 0; j < secondShip.input_hidden.col; j++){
        temp.input_hidden.matrix[i][j] = (input_hidden.matrix[i][j] + secondShip.input_hidden.matrix[i][j])/2;
      }
    }  
    for(int i = 0; i < secondShip.hidden_output.row; i++){
      for(int j = 0; j < secondShip.hidden_output.col; j++){
        temp.hidden_output.matrix[i][j] = (hidden_output.matrix[i][j] + secondShip.hidden_output.matrix[i][j])/2;
      }
    }
    return temp;
  } 
  
  void mutateNN(int rate){
   input_hidden.mutation(rate);
   hidden_output.mutation(rate); 
  }
}
