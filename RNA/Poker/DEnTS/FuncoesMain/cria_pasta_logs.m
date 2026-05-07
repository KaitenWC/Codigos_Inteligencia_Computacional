function [f] = cria_pasta_logs(tipoJogo, flagLogs)

    if tipoJogo == 1
        nome = 'TesteIA';
    elseif tipoJogo == 2
        nome = 'BatalhaIA';
    elseif tipoJogo == 3
        nome = 'Humano';
    end

    h = datestr(clock,0);
    f = strcat('Logs/',[nome, ' ', h(1:11),' ',h(13:14),'-',h(16:17),'-',h(19:20)]);
    if flagLogs
        mkdir(f);
    end

end

