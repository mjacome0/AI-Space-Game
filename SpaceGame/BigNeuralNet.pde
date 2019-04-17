//start of the initial nn 
//right now i just put that it makes the 2 matricies when an instance of it is called
class BigNeuralNet{
Matrix hidden_hidden;
Matrix input_hidden;
Matrix hidden_output;
int row1;
int row2;
int row3;
int col1;
int col2;
int col3;
//gave it a changeable 3 layer system just incase we need to change nodes later
  BigNeuralNet(int r1, int c1,int r2, int c2, int r3, int c3){
     row1 = r1;
     row2 = r2;
     row3 = r3;
     col1 = c1;
     col2 = c2;
     col3 = c3;
     input_hidden = new Matrix(r1,c1);
     hidden_hidden = new Matrix(r2,c2); 
     hidden_output = new Matrix(r3, c3);
     
     input_hidden.randomizer();
     hidden_output.randomizer();
     hidden_hidden.randomizer();
  }
}
