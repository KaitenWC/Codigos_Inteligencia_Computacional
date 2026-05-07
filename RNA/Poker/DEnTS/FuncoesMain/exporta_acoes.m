function [] = exporta_acoes(f)
    global G_inputs;
    global G_outputs;
    global G_cont;
    
    % Trunca X e Y exatamente no mesmo ponto para evitar desalinhamento
    G_inputs(G_cont+1:end, :) = [];
    G_outputs(G_cont+1:end) = [];
    
    % Salva o log do torneio
    save(f,'G_inputs','G_outputs');
    
    % Reseta para a próxima simulação mantendo o tamanho original (50.000)
    G_cont = 0;
    G_inputs = cell(50000, 4);
    G_outputs = zeros(50000, 1);
end