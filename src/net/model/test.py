import torch
from model.cnn import SimpleCNN

x = torch.randn(21,3,224,224)
model = SimpleCNN(num_class = 4)
output = model(x)
print(output.shape)