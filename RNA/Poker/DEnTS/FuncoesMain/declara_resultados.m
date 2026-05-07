function [absoluto, porcentagem, mediaPontos] = declara_resultados(jogadores, tightness, resultados, estruturaApostas, tipoJogo, t)

    numJogadores = size(jogadores,2);
    absoluto = zeros(numJogadores,numJogadores);
    
    if estruturaApostas > 4
        buyin = 100000;
    else
        buyin = 1000;
    end
  
    fprintf('\n============================= Resultados: =============================\n');
    
    for ii=1:numJogadores
        for jj=1:numJogadores
            absoluto(ii,jj) = size(find(resultados(:,ii)==jj),1);
        end
    end

    porcentagem = (absoluto/size(resultados,1))*100;
    
    pontuacoes(1,1:numJogadores) = sqrt(numJogadores*buyin)./((1:numJogadores)+1);
    mediaPontos = zeros(1,numJogadores);
    
    fprintf('\n')
    formatSpec1 = 'Estatísticas para o Jogador índide %d (IA: %s): \n';  
    for ii=1:numJogadores
        switch (jogadores(ii))
            case 1
                str = sprintf('Smart (%.2f)', tightness(ii));
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
        
        fprintf(formatSpec1, round(ii), str);
        
        for jj=1:numJogadores
            formatSpec2 = '    Número de torneios em %dº Lugar: %d (%.2f%%)\n'; 
            fprintf(formatSpec2, jj, absoluto(ii,jj), porcentagem(ii,jj));
        end
        fprintf('\n')
        
        mediaPontos(1,ii) = (porcentagem(ii,:)*0.01)*pontuacoes(1,:)';
    end
    
    if tipoJogo ~= 3
        fprintf('\n------ Resultados de acordo com a Dr. Neaus Tournament Formula: ------\n\n');
        
        [PontosOrdenados,indicesPontosOrdenados] = sort(mediaPontos,'descend');
        
        for ii=1:numJogadores
            formatSpec = '%2dº Colocado: Índice %d %s com %.4f pontos\n';
            %switch (jogadores(ii))
            switch (jogadores(indicesPontosOrdenados(ii)))
                case 1
                    str = sprintf('(IA: Smart (%.2f))', tightness(indicesPontosOrdenados(ii)));
                case 2
                    str = '(IA: Random)';
                case 3
                    str = '(IA: Check/Fold)';
                case 4
                    str = '(IA: Call)';
                case 5
                    str = '(IA: BlindLimp)';
                case 6
                    str = '(IA: Raise)';
                case 7
                    str = '(IA: Humano)';
                case 11
                    str = '(IA: MyBot1)';
                case 21
                    str = '(IA: MyBot2)';
                case 31
                    str = '(IA: MyBot3)';
                case 41
                    str = '(IA: MyBot4)';
                case 51
                    str = '(IA: MyBot5)';
                case 61
                    str = '(IA: MyBot6)';
                case 71
                    str = '(IA: MyBot7)';
                case 81
                    str = '(IA: MyBot8)';
                case 91
                    str = '(IA: MyBot9)';
                otherwise
                    str = '(IA: MyBot10)';
            end
            
            if ii == 1 || PontosOrdenados(ii) ~= PontosOrdenados(ii-1)
%                 fprintf(formatSpec, round(colocacao(1)), ...
%                     round(indicesPontosOrdenados(ii)), str, PontosOrdenados(ii));
                fprintf(formatSpec, round((ii)), round(indicesPontosOrdenados(ii)),...
                    str, PontosOrdenados(ii));
            else
                colocacao = find(PontosOrdenados == PontosOrdenados(ii));
                fprintf(formatSpec, round(colocacao(1)), ...
                    round(indicesPontosOrdenados(ii)), str, PontosOrdenados(ii));
            end
        end
    end
    
    fprintf('\n=======================================================================\n\n');
    
    fprintf('Tempo total de simulação: %.4f segundos \n', sum(t));
    
end

