function [resultados, historico, deals, jogadores, tightness, t] = joga(estruturaAposta, jogadores, numTorneios, numJogadores, tempoSimulacao, tightness, flagLogs, flagHuman, f)

    % Número arbitráriamente grande pois se desconhece a quantidade
    % de torneios a jogar
    t = zeros(1,100000);
    historico = zeros(5, 4, numJogadores);
    resultados = zeros(100000, numJogadores);
    deals = zeros(100000,1);
    
    fprintf('\n========================= Iniciando torneios: =========================\n');
    
    ii = 1;
    while true
        
        n = num2str(ii);
        s = strcat(['Torneio', ' ', n]);
        
        if flagLogs
            fC = strcat([f,'/',s],'.txt');
        else
            fC = 'N';
        end
        
        fprintf('\nTorneio %d:', ii);
        
        tic;
        [resultado, historico, deal] = OOPoker(historico, estruturaAposta, jogadores, tightness, fC);
        t(ii) = toc;
        
        resultados(ii,:) = resultado;
        deals(ii) = deal;
        fprintf('\n\nTorneio %d terminado após %d partidas (%.2f segundos). \n', ii, round(deal),t(ii));
        
        formatSpec1 = '    %dº Colocado: AI: %s \n';
        
        for jj=1:numJogadores
            switch (jogadores(resultado == jj))
                case 1
                    str = sprintf('Smart (%.2f)', tightness(resultado == jj));
                case 2
                    str = 'Random';
                case 3
                    str = 'Check/Fold';
                case 4
                    str = 'Call';
                case 5
                    str = 'BlindLimp';
                case 6
                    str = 'Raise';
                case 7
                    str = 'Humano';
                case 11
                    str = 'MyBot1';
                case 21
                    str = 'MyBot2';
                case 31
                    str = 'MyBot3';
                case 41
                    str = 'MyBot4';
                case 51
                    str = 'MyBot5';
                case 61
                    str = 'MyBot6';
                case 71
                    str = 'MyBot7';
                case 81
                    str = 'MyBot8';
                case 91
                    str = 'MyBot9';
                otherwise
                    str = 'MyBot10';
            end
            fprintf(formatSpec1, jj, str);
        end
        clear mex
        
        if flagHuman
            fM = fullfile(f, s);
            exporta_acoes(fM);
        else
            if ii ~= numTorneios && sum(t) < tempoSimulacao*60
                temp = randperm(size(jogadores,2));
                jogadores = jogadores(temp);
                tightness = tightness(temp);
                historico = historico(:,:,temp);
                resultados = resultados(:,temp);
            end
        end
        
        if ii ~= numTorneios && sum(t) < tempoSimulacao*60
            fprintf('\n-----------------------------------------------------------------------\n');
        else
            fprintf('\n========================== Fim da simulação! ==========================\n');
            
            resultados(all(~resultados,2),:) = [];
            deals(all(~deals,2),:) = [];
            t(:, all(~t,1)) = [];
            break;
        end
        
        ii = ii+1;
    
    end

end

