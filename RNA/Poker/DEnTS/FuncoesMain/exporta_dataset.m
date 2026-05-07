% EXPORTA_DATASET.m  
clear all; clc;

% Solicita o arquivo gerado pelo torneio
[file, path] = uigetfile('*.mat', 'Selecione o log de ações');
if isequal(file,0)
    disp('Operação cancelada pelo usuário.');
    return;
end

disp(['Carregando dados de: ', file, '...']);
load(fullfile(path, file), 'G_inputs', 'G_outputs');

num_amostras = size(G_inputs, 1);

if num_amostras == 0
    error('As matrizes estão vazias! Nenhuma jogada para processar.');
end

disp(['Iniciando extração de features de ', num2str(num_amostras), ' jogadas...']);

X_data = zeros(num_amostras, 293); 
Y_data = zeros(num_amostras, 1);

for i = 1:num_amostras
    cartas = G_inputs{i,1};
    dados = G_inputs{i,2};
    estado = G_inputs{i,3};
    historico = G_inputs{i,4};
    aposta = G_outputs(i);
    
    X_data(i, :) = extrai_features(cartas, dados, estado, historico);
    
    valor_call = dados(9);
    if aposta < valor_call
        Y_data(i) = 0;
    elseif aposta == valor_call
        Y_data(i) = 1;
    else
        Y_data(i) = 2;
    end
end

save('dataset_processado.mat', 'X_data', 'Y_data');
disp('Dataset exportado com sucesso! Arquivo dataset_processado.mat criado.');