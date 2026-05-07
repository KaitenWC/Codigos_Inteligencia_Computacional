import numpy as np

t = np.linspace(0, 2 * np.pi, 1000)
x = np.cos(t)
y = np.sin(t)

def distorcao(x, y):
    x = np.array(x)
    y = np.array(y)

    d_xy = 10 * np.log10(np.mean((x - y)**2)/np.mean(x**2))
    return d_xy

resultado = distorcao(x,y)
print(f"A distorção entre as ondas é: {resultado:.2f} dB")