function equity = calcula_equity_mc(cartas, n_sim)
    cartas_validas = cartas(cartas ~= -1);
    mao = cartas_validas(1:2);
    mesa = cartas_validas(3:end);
    baralho = 0:51;
    baralho(cartas_validas + 1) = [];
    vitorias = 0; empates = 0;

    for i = 1:n_sim
        deck = baralho(randperm(length(baralho)));
        faltam = 5 - length(mesa);
        mesa_sim = [mesa, deck(1:faltam)];
        mao_op = deck(faltam+1:faltam+2);
        
        s_j = avalia_mao([mao mesa_sim]);
        s_o = avalia_mao([mao_op mesa_sim]);
        
        if s_j > s_o, vitorias = vitorias + 1;
        elseif s_j == s_o, empates = empates + 1; end
    end
    equity = (vitorias + 0.5 * empates) / n_sim;
end