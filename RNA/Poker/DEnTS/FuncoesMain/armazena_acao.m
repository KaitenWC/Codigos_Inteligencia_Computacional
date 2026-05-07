function [] = armazena_acao(cartas, dados, estado, historico, aposta)
    
    global G_inputs;
    global G_outputs;
    global G_cont;
       
    G_cont = G_cont + 1;
    G_inputs{G_cont,1} = cartas;
    G_inputs{G_cont,2} = dados;
    G_inputs{G_cont,3} = estado;
    G_inputs{G_cont,4} = historico;
    G_outputs(G_cont,1) = aposta;

end

