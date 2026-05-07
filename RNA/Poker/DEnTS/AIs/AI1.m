function [aposta] = AI1(cartas, dados, estado, historico)
    persistent W1 b1 W2 b2 mu_X sigma_X carregado;
    
    % Carrega os parâmetros apenas na primeira vez
    if isempty(carregado)
        if exist('pesos_poker.mat', 'file') == 2
            load('pesos_poker.mat', 'W1', 'b1', 'W2', 'b2', 'mu_X', 'sigma_X');
            carregado = true;
        else
            aposta = 0; % Fold de segurança se não achar os pesos
            return;
        end
    end
    
    % 1. Extrai as features cruas
    X_cru = extrai_features(cartas, dados, estado, historico)';
    
    % 2. NORMALIZAÇÃO: Escala a mão atual usando a memória do treinamento
    X_norm = (X_cru - mu_X) ./ sigma_X;
    
    % --- 3. PROPAGAÇÃO DA REDE ---
    Z1 = (W1 * X_norm) + b1;
    A1 = max(0, Z1); % ReLU
    Z2 = (W2 * A1) + b2;
    
    % Escolhe a maior ativação
    [~, idx] = max(Z2);
    decisao = idx - 1;
    
    % --- 4. EXECUTA A APOSTA ---
    v_call = dados(9);
    r_min = dados(10);
    
    if decisao == 0
        aposta = v_call - 1; % Fold
    elseif decisao == 1
        aposta = v_call; % Call
    else
        aposta = v_call + (r_min * 2); % Raise
    end
    
    if aposta < 0, aposta = 0; end
end