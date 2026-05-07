function [estruturaAposta, tipoJogo, jogadores, tightness, numTorneios, numJogadores, tempoSimulacao, flagLogs, flagHuman] = configura_jogo()

    disp('--------------------------------------------------------------------------')
    fprintf('                            Bem vindo ao DEnTS\n')
    disp('--------------------------------------------------------------------------')
    fprintf('\n')
    disp('Iniciando configurações')
    fprintf('\n')
    
    flagLogs = true;
    flagHuman = false;
    numTorneios = 1;
    tempoSimulacao = 0;
    
    while true
        
        disp('Modo de jogo:')
        disp('1: 1 IA do usuário vs até 9 IAs pré-estabelecidas (Teste IA)')
        disp('2: Batalha entre até 10 diferentes AIs do usuário (Batalha IA)')
        disp('3: Jogador humano vs até 9 IAs (Humano)')
        tipoJogo = input('Escolha: ');
        if  tipoJogo == 1 || tipoJogo == 2 || tipoJogo == 3 
            break;
        else
            fprintf('Escolha uma opção válida\n \n')
        end
    end
    
    if tipoJogo == 1
        
        while true
            numOponentes = zeros(1,6);
            
            prompt = {'Número de oponentes "Smart":', ...
                'Número de oponentes Random:', 'Número de oponentes Check/fold:', ...
                'Número de oponentes Call:', 'Número de Oponentes BlindLimp:', ...
                'Número de Oponentes Raise:'};
            dlg_title = 'Número de oponentes';
            num_lines = 1;
            def = {'0','0','0','0','0','0'};
            answer = inputdlg(prompt,dlg_title,num_lines,def);
            numOponentes(1:6) = round([str2double(answer{1}) str2double(answer{2}) ...
                str2double(answer{3}) str2double(answer{4}) ...
                str2double(answer{5}) str2double(answer{6})]);
            
            if  sum(numOponentes) < 1 || sum(numOponentes) > 9
                fprintf('O número total de oponentes deve ser entre 1 e 9\n \n')
            else
                
                while true
                    numSmart = numOponentes(1);
                    tightnessSmart = zeros(1,numSmart);
                                                           
                    if numSmart == 0
                        break;
                    end
                    
                    prompt = cell(1,numSmart);
                    def = cell(1,numSmart);                     
                    for ii=1:numSmart
                        prompt{ii} = sprintf('Tightness da IA Smart #%d (entre 0.65 e 0.99, 0 para aleatória)',round(ii));
                        def{ii} = '0.8';
                    end
                    dlg_title = 'Valores de Tightness';
                    num_lines = 1;
                    answer = inputdlg(prompt,dlg_title,num_lines,def);
                    tightnessErro = 0;
                    for ii=1:numSmart
                        if str2double(answer(ii)) == 0
                            tightnessSmart(ii) = (rand()/(1/0.39)) + 0.60;
                        elseif str2double(answer(ii)) >= 0.60 && str2double(answer(ii)) <= 0.99
                            tightnessSmart(ii) = str2double(answer(ii));
                        else
                            tightnessErro = 1;
                        end
                    end
                    
                    if tightnessErro == 0
                        break;
                    end
                    fprintf('Escolha uma opção válida (entre 0.65 e 0.99 ou 0 para aleatória) \n \n')
                end
                totOpponents = sum(numOponentes);
                jogadores = zeros(1,totOpponents + 1);
                tightness = zeros(1,totOpponents + 1);
                jogadores(1:numOponentes(1)) = 1;
                tightness(1:numOponentes(1)) = tightnessSmart;
                jogadores(numOponentes(1)+1:sum(numOponentes(1:2))) = 2;
                jogadores(sum(numOponentes(1:2))+1:sum(numOponentes(1:3))) = 3;
                jogadores(sum(numOponentes(1:3))+1:sum(numOponentes(1:4))) = 4;
                jogadores(sum(numOponentes(1:4))+1:sum(numOponentes(1:5))) = 5;
                jogadores(sum(numOponentes(1:5))+1:totOpponents) = 6;
                jogadores(end) = 11;
                numJogadores = size(jogadores,2);
                break;
            end
        end
        
    elseif tipoJogo == 3
        
        flagHuman = true;
        
        while true
            
            flagAIMyBot = false; %#ok<NASGU>
            numOponentes = zeros(1,16);
            
            prompt = {'Número de oponentes "Smart":', ...
                'Número de oponentes Random:', 'Número de oponentes Check/fold:', ...
                'Número de oponentes Call:', 'Número de Oponentes BlindLimp:', ...
                'Número de Oponentes Raise:'};
            dlg_title = 'Número de oponentes';
            num_lines = 1;
            def = {'0','0','0','0','0','0'};
            answer = inputdlg(prompt,dlg_title,num_lines,def);
            numOponentes(1:6) = round([str2double(answer{1}) str2double(answer{2}) ...
                str2double(answer{3}) str2double(answer{4}) ...
                str2double(answer{5}) str2double(answer{6})]);
            
            if sum(numOponentes) == 0
               flagAIMyBot = true;
            else
               flagAIMyBot = logical(input('\nDeseja jogar contra IAs implementadas no MATLAB? (0 - Não, 1 - Sim): '));
            end
            
            if flagAIMyBot
                prompt = {'Número de oponentes "MyBot1":', ...
                    'Número de oponentes "MyBot2":', 'Número de oponentes "MyBot3":', ...
                    'Número de oponentes "MyBot4":', 'Número de oponentes "MyBot5":', ...
                    'Número de oponentes "MyBot6":', 'Número de oponentes "MyBot7":', ...
                    'Número de oponentes "MyBot8":', 'Número de oponentes "MyBot9":', ...
                    'Número de oponentes "MyBot10":'};
                dlg_title = 'Número de oponentes MyBot';
                num_lines = 1;
                def = {'0','0','0','0','0','0','0','0','0','0'};
                answer2 = inputdlg(prompt,dlg_title,num_lines,def);
                numOponentes(7:16) = round([str2double(answer2{1}) str2double(answer2{2}) ...
                    str2double(answer2{3}) str2double(answer2{4}) str2double(answer2{5}) ...
                    str2double(answer2{6}) str2double(answer2{7}) str2double(answer2{8}) ...
                    str2double(answer2{9}) str2double(answer2{10})]);
            end
            if  sum(numOponentes) < 1 || sum(numOponentes) > 9
                fprintf('O número total de oponentes deve ser entre 1 e 9\n \n')
            else
                while true
                    numSmart = numOponentes(1);
                    tightnessSmart = zeros(1,numSmart);
                    
                    if numSmart == 0
                        break;
                    end
                    
                    prompt = cell(1,numSmart);
                    def = cell(1,numSmart);
                    for ii=1:numSmart
                        prompt{ii} = sprintf('Tightness da IA Smart #%d (entre 0.65 e 0.99, 0 para aleatória)',round(ii));
                        def{ii} = '0.8';
                    end
                    dlg_title = 'Valores de Tightness';
                    num_lines = 1;
                    answer = inputdlg(prompt,dlg_title,num_lines,def);
                    tightnessErro = 0;
                    for ii=1:numSmart
                        if str2double(answer(ii)) == 0
                            tightnessSmart(ii) = round((rand()/(1/0.39)) + 0.60,2);
                        elseif str2double(answer(ii)) >= 0.60 && str2double(answer(ii)) <= 0.99
                            tightnessSmart(ii) = round(str2double(answer(ii)),2);
                        else
                            tightnessErro = 1;
                        end
                    end
                    if tightnessErro == 0
                        break;
                    end
                    fprintf('Escolha uma opção válida (entre 0.65 e 0.99 ou 0 para aleatória) \n \n')
                end
                totOpponents = sum(numOponentes);
                jogadores = zeros(1,totOpponents + 1);
                tightness = zeros(1,totOpponents + 1);
                jogadores(1:numOponentes(1)) = 1;
                tightness(1:numOponentes(1)) = tightnessSmart;
                jogadores(numOponentes(1)+1:sum(numOponentes(1:2))) = 2;
                jogadores(sum(numOponentes(1:2))+1:sum(numOponentes(1:3))) = 3;
                jogadores(sum(numOponentes(1:3))+1:sum(numOponentes(1:4))) = 4;
                jogadores(sum(numOponentes(1:4))+1:sum(numOponentes(1:5))) = 5;
                jogadores(sum(numOponentes(1:5))+1:sum(numOponentes(1:6))) = 6;
                jogadores(sum(numOponentes(1:6))+1:sum(numOponentes(1:7))) = 11;
                jogadores(sum(numOponentes(1:7))+1:sum(numOponentes(1:8))) = 21;
                jogadores(sum(numOponentes(1:8))+1:sum(numOponentes(1:9))) = 31;
                jogadores(sum(numOponentes(1:9))+1:sum(numOponentes(1:10))) = 41;
                jogadores(sum(numOponentes(1:10))+1:sum(numOponentes(1:11))) = 51;
                jogadores(sum(numOponentes(1:11))+1:sum(numOponentes(1:12))) = 61;
                jogadores(sum(numOponentes(1:12))+1:sum(numOponentes(1:13))) = 71;
                jogadores(sum(numOponentes(1:13))+1:sum(numOponentes(1:14))) = 81;
                jogadores(sum(numOponentes(1:14))+1:sum(numOponentes(1:15))) = 91;
                jogadores(sum(numOponentes(1:15))+1:totOpponents) = 101;
                jogadores(end) = 7;
                numJogadores = size(jogadores,2);
                break;
            end
        end
        
    else
        
        while true            
            numJogadores = int8(input('\nDetermine o número de IAs diferentes: '));
            if  numJogadores < 2 || numJogadores > 10
                fprintf('O número total de jogadores deve ser entre 2 e 10 \n \n')
            else
                jogadores = zeros(1,numJogadores);
                for ii=1:numJogadores
                    jogadores(ii) = 10*ii + 1;
                end
                tightness = zeros(1,numJogadores);
                break;
            end           
        end
        
    end
    
    formatSpec1 = '    %d IA  %s\n';
    formatSpec2 = '    %d IAs %s\n';
    
    tiposia = {'Smart', 'Random', 'Check/fold', 'Call', 'Blindlimp', 'Raise' ...
        'Mybot1', 'Mybot2', 'Mybot3', 'Mybot4', 'Mybot5', 'Mybot6', ...
        'Mybot7', 'Mybot8', 'Mybot9', 'Mybot10'};
    
    if tipoJogo == 1
        
        fprintf('\nModo 1 selecionado. A mesa será composta por:\n    1 IA  MyBot1\n')
        for ii=1:6
            if numOponentes(ii) == 1
                fprintf(formatSpec1, round(numOponentes(ii)), char(tiposia(ii)))
            elseif numOponentes(ii) ~= 0
                fprintf(formatSpec2, round(numOponentes(ii)), char(tiposia(ii)))
            end
        end
    elseif tipoJogo == 2
        fprintf('\nModo 2 selecionado. A mesa será composta por:\n')
        for ii=1:numJogadores
            fprintf(formatSpec1, 1, char(tiposia(6+ii)))
        end
    else
        fprintf('\nModo 3 selecionado. A mesa será composta por:\n    1 Jogador Humano\n')
        for ii=1:16
            if numOponentes(ii) == 1
                fprintf(formatSpec1, round(numOponentes(ii)), char(tiposia(ii)))
            elseif numOponentes(ii) ~= 0
                fprintf(formatSpec2, round(numOponentes(ii)), char(tiposia(ii)))
            end
        end
    end
    
    fprintf('\n')
    
    while true
        disp('Estrutura das apostas (buy-in, small blind, big bliind):')
        disp('1: 1000, 5, 10')
        disp('2: 1000, 10, 20')
        disp('3: 1000, 50, 100')
        disp('4: 1000, 100, 200')
        disp('5: 100000, 5, 10')
        disp('6: 100000, 10, 20')
        disp('7: 100000, 50, 100')
        disp('8: 100000, 100, 200')
        estruturaAposta = round(input('Escolha: '));
        fprintf('\n')
        if  estruturaAposta < 1 || estruturaAposta > 8
            fprintf('Escolha uma opção válida\n')
        else
            break;
        end
    end
    
    if tipoJogo ~= 0
                  
        while true                   
            disp('Limite da simulação:')
            disp('1: Número de torneios')
            disp('2: Tempo de simulação')
            tipoLimite = input('Escolha: ');
            if  tipoLimite == 1 || tipoLimite == 2
                break;
            else
                fprintf('Escolha uma opção válida\n \n')
            end
        end

        fprintf('\n')
        
        while true
            if  tipoLimite == 1
                tempoSimulacao = Inf;
                numTorneios = round(input('Determine o número de torneios a jogar: '));
                if  numTorneios < 1
                    fprintf('Escolha uma opção válida\n \n')
                else
                    break;
                end
            else
                tempoSimulacao = round(input('Determine o tempo de simulação em minutos: '));
                numTorneios = Inf;
                if  tempoSimulacao < 1
                    fprintf('Escolha uma opção válida\n \n')
                else
                    break;
                end
            end
        end
             
        flagLogs = logical(input('\nDeseja armazenar um log de ações? (0 - Não, 1 - Sim): '));
    end
    
    temp = randperm(numJogadores);
    tightness = tightness(temp);
    jogadores = jogadores(temp);
    
end

