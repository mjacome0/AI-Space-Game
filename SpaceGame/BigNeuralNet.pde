//start of the initial nn
//right now i just put that it makes the 2 matricies when an instance of it is called
class BigNeuralNet {
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
  BigNeuralNet(int r1, int c1, int r2, int c2, int r3, int c3) {
    row1 = r1;
    row2 = r2;
    row3 = r3;
    col1 = c1;
    col2 = c2;
    col3 = c3;
    input_hidden = new Matrix(r1, c1);
    hidden_hidden = new Matrix(r2, c2);
    hidden_output = new Matrix(r3, c3);
    input_hidden.randomizer();
    hidden_output.randomizer();
    hidden_hidden.randomizer();
  }
  void display() {
    println("Input hidden matrix:");
    input_hidden.display();
    println("Hidden hidden matrix:");
    hidden_hidden.display();
    println("Hidden output matrix");
    hidden_output.display();
  }
  BigNeuralNet clone() {
    BigNeuralNet temp = new BigNeuralNet(row1, col1, row2, col2, row3, col3);
    temp.input_hidden = input_hidden.clone();
    temp.hidden_hidden = hidden_hidden.clone();
    temp.hidden_output = hidden_output.clone();
    return temp;
  }
  BigNeuralNet crossover(BigNeuralNet p) {
    BigNeuralNet temp = new BigNeuralNet(row1, col1, row2, col2, row3, col3);
    temp.input_hidden = input_hidden.crossover(p.input_hidden);
    temp.hidden_hidden = hidden_hidden.crossover(p.hidden_hidden);
    temp.hidden_output = hidden_output.crossover(p.hidden_output);
    return temp;
  }
  Matrix feedForward(Matrix inputMatrix) {
    inputMatrix.addBias();
    Matrix first_hiddenLayer = multiplyMatrices(input_hidden, inputMatrix);
    first_hiddenLayer.activate();
    first_hiddenLayer.addBias();
    Matrix second_hiddenLayer = multiplyMatrices(hidden_hidden, first_hiddenLayer);
    second_hiddenLayer.activate();
    second_hiddenLayer.addBias();
    Matrix outputLayer = multiplyMatrices(hidden_output, second_hiddenLayer);
    outputLayer.activate();
    return outputLayer;
  }
  void mutate(float rate) {
    input_hidden.mutate(rate);
    hidden_output.mutate(rate);
    hidden_hidden.mutate(rate);
  }
}
