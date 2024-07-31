import torch
from torchvision import datasets
from torchvision import transforms
import matplotlib.pyplot as plt


class Autoencoder(nn.Module):
    def __init__(self):
        super(Autoencoder,self).__init__()
        self.encoder = nn.Sequential(
            nn.linear(28 * 28, 128), 
        )
