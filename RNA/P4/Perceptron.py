import numpy as np
import pandas as pd

df_xk = pd.read_csv("entradasclassalunos.txt", sep=r'\s+', engine='python', header=None)
df_dk = pd.read_csv("saidaclassalunos.txt", sep=r'\s+', engine='python', header=None)
df_xk = df_xk.fillna(0)
xk = df_xk.values.astype(float)
df_dk = df_dk.fillna(0)
dk = df_dk.values.astype(float)

d = int(0.8*len(df_xk))
xk_treino = xk[:d]
dk_treino = dk[:d]
xk_vali = xk[d:]
dk_vali = dk[d:]

err = 1
w = np.random.rand(xk_treino.shape[1]) * 0.01
n = 0.1
epoca = 0
while err > 0 and epoca < 10000:
    err = 0
    for i in range(len(xk_treino)):
        x_amostra = xk_treino[i]
        d_amostra = dk_treino[i][0]
        u = (w.T)@(x_amostra)
        if u >= 0:
            y = 1
        else:
            y = 0
        if y != d_amostra:
            w = w + n * (d_amostra - y)*x_amostra
            err += 1
    epoca += 1
    # print("Época atual:", epoca)

acertos_vali = 0
for i in range(len(xk_vali)):
    x_amostra_vali = xk_vali[i]
    d_esperado = dk_vali[i][0]

    u_vali = (w.T) @ x_amostra_vali
    y_vali = 1 if u_vali >= 0 else 0

    if y_vali == d_esperado:
        acertos_vali += 1

acuracia = (acertos_vali / len(xk_vali)) * 100
print(f"Acurácia na validação: {acuracia:.2f}% ({acertos_vali} de {len(xk_vali)} amostras)")
#----------------------------------------------------------------------------
df_x_vali = pd.read_csv("entradasclassteste.txt", sep=r'\s+', engine='python', header=None)
df_x_vali = df_x_vali.fillna(0)
x_vali = df_x_vali.values.astype(float)

y_teste = np.zeros(len(x_vali))
for i in range(len(x_vali)):
    x_teste = x_vali[i]
    u_teste = (w.T) @ (x_teste)
    if u_teste >= 0:
        y_teste[i] = 1
    else:
        y_teste[i] = 0

with open('submissaoperceptron.txt', 'w') as arquivo:
    for j in range(len(y_teste)):
        arquivo.write(str(int(y_teste[j])) + '\n')

print("Fim do código.")