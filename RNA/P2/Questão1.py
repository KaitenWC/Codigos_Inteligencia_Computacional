import numpy as np
import matplotlib.pyplot as plt

def gaussiana (medX, varX, medY, varY, npts):
    x_gauss = np.random.normal(medX, np.sqrt(varX), npts)
    y_gauss = np.random.normal(medY, np.sqrt(varY), npts)
    return x_gauss, y_gauss

def dist_unif(medX, medY, margem, npts):
    #Calculos de maximo e minimo a partir de 1 dev padrão
    minX = medX - margem
    maxX = medX + margem
    minY = medY - margem
    maxY = medY + margem
    #Calculo da distribuição uniforme
    x_unif = np.random.uniform(minX, maxX, npts)
    y_unif = np.random.uniform(minY, maxY, npts)
    return x_unif, y_unif

npts = 100
medX = 10
varX = 0.7
medY = 10
varY = 0.7

x_gauss, y_gauss = gaussiana(medX, varX, medY, varY, npts)
margem = 5
x_unif, y_unif = dist_unif(medX, medY, margem, npts)

plt.figure(figsize=(8, 6))


plt.scatter(x_gauss, y_gauss, alpha=0.4, color='blue', edgecolors='white', linewidth=0.5, label='Gaussiana')
plt.scatter(x_unif, y_unif, alpha=0.4, color='orange', edgecolors='white', linewidth=0.5, label='Uniforme')

plt.title('Classes: Gaussiana vs Uniforme')
plt.legend() # Mostra a legenda das cores
plt.grid(True, linestyle='--', alpha=0.7)

plt.axhline(medY, color='gray', linewidth=1)
plt.axvline(medX, color='gray', linewidth=1)

plt.show()