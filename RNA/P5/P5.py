import numpy as np
import pandas as pd
from matplotlib import pyplot as plt

# 1. Carregamento dos Dados
df_xk = pd.read_csv("entradamodelagemalunos.txt", sep=r'\s+', engine='python', header=None)
df_dk = pd.read_csv("saidamodelagemalunos.txt", sep=r'\s+', engine='python', header=None)
xk_flat = df_xk.fillna(0).values.astype(float).flatten()
dk_flat = df_dk.fillna(0).values.astype(float).flatten()

# 2. Criação da Matriz de Atrasos (Memória ARX)
atrasos = 2
X_dinamico = []
D_alvo = []

for k in range(atrasos, len(xk_flat)):
    amostra = [
        xk_flat[k],
        xk_flat[k - 1],
        xk_flat[k - 2],
        dk_flat[k - 1],
        dk_flat[k - 2]
    ]
    X_dinamico.append(amostra)
    D_alvo.append(dk_flat[k])

X_dinamico = np.array(X_dinamico)
D_alvo = np.array(D_alvo).reshape(-1, 1)

# 3. Divisão Treino e Validação
d = int(0.8 * len(X_dinamico))
xk_treino = X_dinamico[:d]
dk_treino = D_alvo[:d]
xk_vali = X_dinamico[d:]
dk_vali = D_alvo[d:]

# 4. Normalização
mu = np.mean(xk_treino, axis=0)
sigma = np.std(xk_treino, axis=0)
xk_treino = (xk_treino - mu) / sigma
xk_vali = (xk_vali - mu) / sigma

# 5. Inicialização do Adaline
w = np.random.rand(xk_treino.shape[1], 1) * 0.01
tol_err = 0.1
bias = 0
n = 0.00001
epoca = 0
paciencia = 10000
epocas_sem_melhora = 0
melhor_mse_vali = float('inf')
melhor_w = np.copy(w)
melhor_bias = bias

y_treino = xk_treino @ w + bias
err = dk_treino - y_treino
mse = np.mean(err ** 2)

# 6. Treinamento
while mse > tol_err and epoca < 100_000:
    for i in range(len(xk_treino)):
        x_amostra = xk_treino[i].reshape(-1, 1)
        d_amostra = dk_treino[i][0]
        y_amostra = (w.T) @ x_amostra + bias
        erro_am = d_amostra - y_amostra[0][0]

        w = w + n * erro_am * x_amostra
        bias = bias + n * erro_am

    y_treino = xk_treino @ w + bias
    mse = np.mean((dk_treino - y_treino) ** 2)

    y_vali = xk_vali @ w + bias
    mse_vali = np.mean((dk_vali - y_vali) ** 2)

    if mse_vali < melhor_mse_vali:
        melhor_mse_vali = mse_vali
        melhor_w = np.copy(w)
        melhor_bias = bias
        epocas_sem_melhora = 0
    else:
        epocas_sem_melhora += 1

    if epocas_sem_melhora >= paciencia:
        print(f"Early Stopping na época {epoca}.")
        w = np.copy(melhor_w)
        bias = melhor_bias
        break

    epoca += 1

print(f"Total de Épocas: {epoca}")
print(f"MSE Treino: {mse:.6f} | MSE Validação: {mse_vali:.6f}")
mape_treino = np.mean(np.abs((dk_treino - y_treino) / dk_treino)) * 100
print(f"Erro Percentual (MAPE): {mape_treino:.2f}%")

# 7. Gráfico de Validação
tempo = range(len(dk_vali))
plt.figure(figsize=(12, 6))
plt.plot(tempo, dk_vali, label='Saída Real do Sistema (dk)', color='black', linewidth=2)
plt.plot(tempo, y_vali, label='Predição do Adaline (y)', color='red', linestyle='--', linewidth=2)
plt.title('Comparação: Adaline ARX vs Sistema Dinâmico Real (Validação)', fontsize=14)
plt.xlabel('Amostras no Tempo (k)', fontsize=12)
plt.ylabel('Temperatura / Saída', fontsize=12)
plt.grid(True, linestyle=':', alpha=0.7)
plt.legend()
plt.show()

# 8. PREDIÇÃO LIVRE

ent_teste = pd.read_csv("entradamodelagemteste.txt", sep=r'\s+', engine='python', header=None)
ent_flat = ent_teste.fillna(0).values.astype(float).flatten()
y_teste = []

# Pegamos os últimos valores conhecidos da nossa base de dados para dar a partida
x_passado_1 = xk_flat[-1]
x_passado_2 = xk_flat[-2]
y_passado_1 = dk_flat[-1]
y_passado_2 = dk_flat[-2]

for k in range(len(ent_flat)):
    x_atual = ent_flat[k]

    # Monta a amostra com a mesma estrutura do treinamento
    amostra = np.array([x_atual, x_passado_1, x_passado_2, y_passado_1, y_passado_2])

    # Normaliza usando o MESMO mu e sigma do treino
    amostra_norm = (amostra - mu) / sigma

    # Faz a predição matricial
    y_pred = amostra_norm.reshape(1, -1) @ w + bias
    y_teste.append(y_pred[0][0])

    # ATUALIZA OS ATRASOS PARA O PRÓXIMO LOOP
    x_passado_2 = x_passado_1
    x_passado_1 = x_atual
    y_passado_2 = y_passado_1
    y_passado_1 = y_pred[0][0]  # Usa a PRÓPRIA predição como realidade passada

# Salva o arquivo final
np.savetxt('exemplosubmissaoadaline.txt', y_teste, fmt='%.4f')
print("Fim. Arquivo de submissão gerado!")