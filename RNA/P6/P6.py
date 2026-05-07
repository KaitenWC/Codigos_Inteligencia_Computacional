import numpy as np
import pandas as pd
from sklearn.neural_network import MLPRegressor as mlp
import matplotlib.pyplot as plt
from sklearn.preprocessing import StandardScaler

df_xk = pd.read_csv("entradaajustealunos.txt", sep=r'\s+', engine='python', header=None)
df_dk = pd.read_csv("saidaajustealunos.txt", sep=r'\s+', engine='python', header=None)
df_xk = df_xk.fillna(0)
xk = df_xk.values.astype(float)
df_dk = df_dk.fillna(0)
dk = df_dk.values.astype(float)

d = int(0.8*len(df_xk))
xk_treino = xk[:d]
dk_treino = dk[:d]
xk_vali = xk[d:]
dk_vali = dk[d:]

# Normalização dos dados
scaler_x = StandardScaler()
xk_treino = scaler_x.fit_transform(xk_treino)
xk_vali = scaler_x.transform(xk_vali)
scaler_y = StandardScaler()
dk_treino = scaler_y.fit_transform(dk_treino)
dk_vali = scaler_y.transform(dk_vali)
# Numero de camadas escondidas e épocas
hls = 3
n_epocas = 10000

mlp = mlp(hidden_layer_sizes=hls, max_iter=n_epocas, solver='lbfgs')
mlp.fit(xk_treino, dk_treino.ravel())

prev_teste = mlp.predict(xk_vali)
matriz_corr = np.corrcoef(prev_teste.flatten(), dk_vali.flatten())
correlacao = matriz_corr[0, 1]
print(f"Coeficiente de Correlação: {correlacao}")
prev_train = mlp.predict(xk_treino)

corr_train = np.corrcoef(
    prev_train.flatten(),
    dk_treino.flatten()
)[0,1]
print(corr_train)

plt.figure(figsize=(10, 5))

# Plotando os dados reais de validação (linha azul com bolinhas)
plt.plot(dk_vali, label='Saída Real', marker='o', linestyle='-', alpha=0.7)

# Plotando as previsões da nossa rede (linha laranja pontilhada)
plt.plot(prev_teste, label='Previsão da MLP', marker='x', linestyle='--', color='darkorange')

# Adicionando detalhes ao gráfico
plt.title('Ajuste de Curva: Saída Real vs Previsão da Rede Neural')
plt.xlabel('Amostras')
plt.ylabel('Valores')
plt.legend()
plt.grid(True)

# Exibindo o gráfico
plt.show()


ent_vali= pd.read_csv("entradaajusteteste.txt", sep=r'\s+', engine='python', header=None)
prev_final = mlp.predict(ent_vali)

np.savetxt('exemplosubmissaomlp.txt', prev_final, fmt='%f')

