% CONSOLIDA_DATASET_MASTER.m 
clear all; clc;

% Selecione a pasta principal "Logs"
pasta_logs = uigetdir('', 'Selecione a pasta PRINCIPAL "Logs"');
if isequal(pasta_logs, 0)
    disp('Operação cancelada.');
    return;
end


arquivos = dir(fullfile(pasta_logs, '**', '*.mat'));

if isempty(arquivos)
    error('Nenhum arquivo .mat encontrado nas subpastas.');
end

X_total = [];
Y_total = [];

disp(['Encontrados ', num2str(length(arquivos)), ' arquivos de torneio no total. Processando...']);

for k = 1:length(arquivos)
    caminho_completo = fullfile(arquivos(k).folder, arquivos(k).name);
    
    
    if contains(arquivos(k).name, 'dataset_processado')
        continue;
    end
    
    load(caminho_completo, 'G_inputs', 'G_outputs');
    num_amostras = size(G_inputs, 1);
    
    if num_amostras == 0
        continue; 
    end
    
    X_temp = zeros(num_amostras, 293);
    Y_temp = zeros(num_amostras, 1);
    
    for i = 1:num_amostras
        cartas = G_inputs{i,1};
        dados = G_inputs{i,2};
        estado = G_inputs{i,3};
        historico = G_inputs{i,4};
        aposta = G_outputs(i);
        
        X_temp(i, :) = extrai_features(cartas, dados, estado, historico);
        
        valor_call = dados(9);
        if aposta < valor_call
            Y_temp(i) = 0;
        elseif aposta == valor_call
            Y_temp(i) = 1;
        else
            Y_temp(i) = 2;
        end
    end
    
    X_total = [X_total; X_temp];
    Y_total = [Y_total; Y_temp];
    disp(['Processado: ', arquivos(k).name, ' (', num2str(num_amostras), ' ações)']);
end

X_data = X_total;
Y_data = Y_total;
save('dataset_processado.mat', 'X_data', 'Y_data');
disp(['Sensacional! dataset_processado.mat salvo com um total de ', num2str(length(Y_data)), ' amostras.']);