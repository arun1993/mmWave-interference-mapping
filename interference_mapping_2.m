p_sta = load('data/sectorpattern_3d_sta.mat');
p_ap = load('data/sectorpattern_3d_ap.mat');

client_theta = [0 0 0];
client_elevation = [0 0 0];
theta = [-45 -10 45; -20 0 60; 25 20 -45; 60 40 -10; 75 45 20];
phi = [4 2 3; 4 2 3; 4 2 3; 4 2 3; 4 2 3];

theta_index = zeros(5,3);
phi_index = zeros(5,3);

for i=1:5
    for j=1:3
theta_index(i,j) = min(find((theta(i,j)<=p_ap.az(1,:))));
phi_index(i,j) = min(find((phi(i,j)<=p_ap.el(:,1))));
    end
end

signal_strength = zeros(5,3,34);


for i=1:5
    for j=1:3
        for sector=1:34
            strength(i,j,sector) = p_ap.pattern_rssi(phi_index(i,j),theta_index(i,j),sector);
        end
    end
end

interference = zeros(5,3);

for i=1:5
    for j=1:3
        sum = 0;
        for k=1:5 
            for l=1:3 
                if ((k ~=i) && (l ~=j)) 
                    for sector=1:34
                        interference(i,j) = interference(i,j) + p_ap.pattern_rssi(phi_index(k,l),theta_index(k,l),sector);
                    end
                end
            end
        end
    end
end


for i = 1:5
    for j=1:3 
        sir(i,j) = strength(i,j) / interference(i,j);
    end
end


                
