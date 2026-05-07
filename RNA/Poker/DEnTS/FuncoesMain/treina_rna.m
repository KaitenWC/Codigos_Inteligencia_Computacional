% TREINA_RNA.m - Rede Neural(Z-Score + Gradient Clipping)
disp('Carregando dados processados...');
load('dataset_processado.mat', 'X_data', 'Y_data');

% Prepara e limpa qualquer possível NaN residual que tenha vindo do jogo
X = X_data'; 
X(isnan(X)) = 0; 
X(isinf(X)) = 0;
num_amostras = length(Y_data);

% --- NORMALIZAÇÃO Z-SCORE ---
disp('Aplicando Z-Score...');
mu_X = mean(X, 2); 
sigma_X = std(X, 0, 2); 
sigma_X(sigma_X == 0) = 1; 

X_norm = (X - mu_X) ./ sigma_X;

% One-Hot Encoding
Y = zeros(3, num_amostras);
Y(1, Y_data == 0) = 1;
Y(2, Y_data == 1) = 1;
Y(3, Y_data == 2) = 1;

% --- ARQUITETURA ---
tamanho_entrada = size(X_norm, 1);
tamanho_oculta = 32; 
tamanho_saida = 3;

% Inicialização
W1 = randn(tamanho_oculta, tamanho_entrada) * sqrt(2/tamanho_entrada);
b1 = zeros(tamanho_oculta, 1);
W2 = randn(tamanho_saida, tamanho_oculta) * sqrt(2/tamanho_oculta);
b2 = zeros(tamanho_saida, 1);

% --- HIPERPARÂMETROS ---
taxa_aprendizado = 0.001; % 
epocas = 1500;
limite_grad = 1.0; 

disp('Iniciando treinamento ...');

for epoca = 1:epocas
    % --- FORWARD PASS ---
    Z1 = (W1 * X_norm) + b1;
    A1 = max(0, Z1); 
    
    Z2 = (W2 * A1) + b2;
    expZ2 = exp(Z2 - max(Z2)); 
    A2 = expZ2 ./ sum(expZ2, 1);
    
    % --- BACKPROPAGATION ---
    dZ2 = A2 - Y;
    dW2 = (dZ2 * A1') / num_amostras;
    db2 = sum(dZ2, 2) / num_amostras;
    
    dA1 = W2' * dZ2;
    dZ1 = dA1 .* (Z1 > 0); 
    dW1 = (dZ1 * X_norm') / num_amostras;
    db1 = sum(dZ1, 2) / num_amostras;
    
    % --- GRADIENT CLIPPING ---
    dW1 = max(min(dW1, limite_grad), -limite_grad);
    db1 = max(min(db1, limite_grad), -limite_grad);
    dW2 = max(min(dW2, limite_grad), -limite_grad);
    db2 = max(min(db2, limite_grad), -limite_grad);
    
    % --- ATUALIZAÇÃO ---
    W1 = W1 - (taxa_aprendizado * dW1);
    b1 = b1 - (taxa_aprendizado * db1);
    W2 = W2 - (taxa_aprendizado * dW2);
    b2 = b2 - (taxa_aprendizado * db2);
    
    % Mostra o progresso
    if mod(epoca, 100) == 0
        loss = -sum(sum(Y .* log(A2 + 1e-8))) / num_amostras;
        fprintf('Época %d/%d | Erro (Loss): %.4f\n', epoca, epocas, loss);
        
       
        if isnan(loss)
            disp('ALERTA: O erro virou NaN. O treinamento parou.');
            break;
        end
    end
end

save('pesos_poker.mat', 'W1', 'b1', 'W2', 'b2', 'mu_X', 'sigma_X');
disp('Treinamento concluído e salvo!');