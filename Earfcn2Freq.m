function CenterFreq = Earfcn2Freq(earfcn,radiotech)

    switch radiotech
        case "NR"
            if earfcn <= 599999
                Delta = 5;
                NrefOff = 0;
                FrefOff = 0;
            elseif earfcn <= 2016666
                Delta = 15;
                NrefOff = 600000;
                FrefOff = 3000;
            else
                Delta = 60;
                NrefOff = 2016667;
                FrefOff = 24250.08;
            end

            CenterFreq = (FrefOff + Delta*(earfcn - NrefOff))/1000;
            
        case "LTE"
            
            earfcn_table = [850 1150 2000 2175 5145 5330 9820 66486 66661 66936 1001 1125 2100 2250 5035 39750 39948 40072 66736 66911 67011 125290];
            Freq_table = [1955 1985 2115 2132.5 742.5 763 2355 2115 2132.5 2160  1970.1 1982.5 2125 2140 731.5 2506 2525.8 2538.2 2140 2157.5 2167.5 0];

            index = earfcn_table == earfcn;
            if any(index)
                CenterFreq = Freq_table(index);
            else
                "Error"
            end
    
    
    end


end