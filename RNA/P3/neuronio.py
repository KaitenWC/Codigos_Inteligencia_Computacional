import numpy as np

def neuronio (peso, entrada, bias):
    soma = np.dot(entrada, peso)
    resultado = soma + bias
    if resultado >= 0:
        return 1
    else:
        return 0