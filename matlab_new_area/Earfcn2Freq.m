function CenterFreq = Earfcn2Freq(earfcn)
    earfcn_table = [1075,850, 1150, 2000, 2175, 5145, 5330, 9820, 66486, 66661, 66936, 1001, 1125, 2100, 2250, 5035, 39750, 39948, 40072, 66736, 66911, 67011, 125290,2350,2560,55340,66586,66836,67086,648672,2100,2561,5230,55344,55542,55740,648672,653952,5815,9820,39750,1003,2250,5035];
    Freq_table = [1977.5, 1955, 1985, 2115, 2132.5, 742.5, 763, 2355, 2115, 2132.5, 2160, 1970.1, 1982.5, 2125, 2140, 731.5, 2506, 2525.8, 2538.2, 2140, 2157.5, 2167.5, 0,2150,885,3560,2125,2150,2175,3730.08,2125,885.1,751,3560.4,3580.2,3600,3730.08,3809.28,742.5,2355,2506,1970.3,2140,731.5];
    index = earfcn_table == earfcn;
    if any(index)
        CenterFreq = Freq_table(index);
    else
        CenterFreq = NaN; % Return NaN if no match found
        warning('EARFCN value not found in LTE table.');
    
    end
end