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
}
