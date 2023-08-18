T = readtable("cleaned_combined_Longmont_2022_August.csv");
Lat = T.latitude;
Lon = T.longitude;
freq = T.dl_center_freq;
h = T.altitude/1000;
rsrp = T.rsrp;
operator = T.operator;
[x,y,utmzone] = deg2utm(Lat,Lon);
TT  = table;
TT.ue_x = x;
TT.ue_y = y;
TT.ue_h = h;
TT.freq = freq;
TT.rsrp = rsrp;
TT.operator = operator;
writetable(TT,"August_2022.csv");

