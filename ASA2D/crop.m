function [Data,Maps] = crop(Data,Maps,st_x,nd_x,st_y,nd_y)

Data.X0 = Data.XSample;
Data.Y0 = Data.YSample;

Data.X = Data.XSample(st_y:nd_y,st_x:nd_x);
Data.Y = Data.YSample(st_y:nd_y,st_x:nd_x);
Data.GrainID = Data.GrainID(st_y:nd_y,st_x:nd_x);
% Data.Phi1 = Data.Phi1(st_y:nd_y,st_x:nd_x);
% Data.Phi = Data.Phi(st_y:nd_y,st_x:nd_x);
% Data.Phi2 = Data.Phi2(st_y:nd_y,st_x:nd_x);

Maps.S11_2 = Maps.s11_F1(st_y:nd_y,st_x:nd_x);
Maps.S12_2 = Maps.s12_F1(st_y:nd_y,st_x:nd_x);
Maps.S22_2 = Maps.s22_F1(st_y:nd_y,st_x:nd_x);

