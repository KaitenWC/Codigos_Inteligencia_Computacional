function score = avalia_mao(cartas)
    valores_crus = mod(cartas, 13) + 1;
    naipes = floor(cartas / 13);
    valores = valores_crus;
    valores(valores == 1) = 14; 
    
    freq_v = zeros(1, 14);
    for i = 1:length(valores), freq_v(valores(i)) = freq_v(valores(i)) + 1; end
    
    freq_n = zeros(1, 4);
    for i = 1:length(naipes), freq_n(naipes(i) + 1) = freq_n(naipes(i) + 1) + 1; end
    [max_n, n_f] = max(freq_n);
    tem_f = max_n >= 5;
    
    v_u = sort(unique(valores), 'descend');
    if ismember(14, v_u), v_u = [v_u, 1]; end
    tem_s = false; high_s = 0; cons = 1;
    for i = 1:length(v_u)-1
        if v_u(i) - v_u(i+1) == 1
            cons = cons + 1;
            if cons == 5, tem_s = true; high_s = v_u(i-3); break; end
        else, cons = 1; end
    end
    
    quadra = find(freq_v == 4, 1, 'last');
    trincas = find(freq_v == 3);
    pares = find(freq_v == 2);
    base = 15;

    if tem_s && tem_f, score = 9 * base^5 + high_s * base^4; return; end
    if ~isempty(quadra), score = 8 * base^5 + quadra * base^4; return; end
    if length(trincas) >= 1 && ~isempty(pares), score = 7 * base^5 + trincas(end) * base^4 + pares(end) * base^3; return; end
    if tem_f, score = 6 * base^5 + max(valores(naipes == (n_f-1))) * base^4; return; end
    if tem_s, score = 5 * base^5 + high_s * base^4; return; end
    if ~isempty(trincas), score = 4 * base^5 + trincas(end) * base^4; return; end
    if length(pares) >= 2, score = 3 * base^5 + pares(end) * base^4 + pares(end-1) * base^3; return; end
    if length(pares) == 1, score = 2 * base^5 + pares(end) * base^4; return; end
    score = 1 * base^5 + max(valores) * base^4;
end