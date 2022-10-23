# NeuralNetworkPropeller
Neural Network to Predict Small Propeller Performance


The file "main.m" reads the experimental data of the propellers in the "Data" folder, to extract Input and Output matrices. This matrices are the input and output data for the neural network you want to trade. 
The specific neural network employed is a a two-layer feed-forward network with sigmoid hidden neurons and linear output neurons. 

INPUTS.

The first four data are the coefficients of a 3rd-grade polynomial adjust of the chord as a function of normalized radius. The following five are the coefficients for the 4th-grade polynomial adjusts of the pitch in function of normalized radius, finally the blade radius, rotational speed in rev/s, and the advance ratio J.

OUTPUS.

torque and thrust coefficients

You can estimate the data using the neural network converted into a Matlab function as:
 Output = myNeuralNetworkFunction2(Input)

For more details, please refer to: https://www.airitilibrary.com/Publication/alDetailedMesh?docid=P20140627004-202212-202205060002-202205060002-367-374
