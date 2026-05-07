function [X] = extrai_features(cartas, dados, estado, historico)
    eq = calcula_equity_mc(cartas, 100);
    bb = max(dados(1), 1); N_max = 10;
    d_n = [dados(1:2)/bb, dados(3:5)/N_max, dados(6)/4, dados(7:10)/bb, dados(11:12)/N_max];
    
    est_c = zeros(4, N_max); [~, n_at] = size(estado); est_c(:, 1:n_at) = estado;
    est_n = [est_c(1,:)/N_max; est_c(2:3,:)/bb; est_c(4,:)];
    
    hist_c = zeros(6, 4, N_max); hist_c(:,:, 1:n_at) = historico;
    X = [eq, d_n, est_n(:)', hist_c(:)'/10];
    X(isnan(X)) = 0;
end