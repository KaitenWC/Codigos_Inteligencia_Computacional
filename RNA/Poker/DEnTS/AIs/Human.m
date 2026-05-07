function [aposta] = Human(cartas, dados, estado, historico)
    v_call = dados(9);
    r_min = dados(10);
    pos = dados(3);
    pot = dados(7);
    j_ativos = max(dados(11), 2); 
    
    eq_hu = calcula_equity_mc(cartas, 150);
    eq_real = eq_hu / (1 + ((j_ativos - 2) * 0.15)); % Multi-way suavizado
    
    p_odds = v_call / (pot + v_call + 0.01);
    razao_p = pos / j_ativos;
    
    if razao_p <= 0.34, mod_ag = 0.10; % Early
    elseif razao_p <= 0.67, mod_ag = 0.00; % Middle
    else, mod_ag = -0.10; end % Late
    
    l_call = p_odds;
    l_raise = p_odds + 0.25 + mod_ag;
    eq_p = eq_real + (randn() * 0.04); % Ruído estocástico
    
    if eq_p >= l_raise
        aposta = round(v_call + (r_min * randi([1, 3]))); 
    elseif eq_p >= l_call
        aposta = round(v_call);
    else
        aposta = round(v_call - 1);
    end
    
    if aposta < 0, aposta = 0; end
    armazena_acao(cartas, dados, estado, historico, aposta);
end