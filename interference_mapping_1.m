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

signal_rssi = zeros(5,3);
sector_mat = zeros(5,3);

for i=1:5
    for j=1:3
        [signal_rssi(i,j),sector_mat(i,j)] = max(p_ap.pattern_rssi(phi_index(i,j),theta_index(i,j),:));
    end
end
client_ap_rssi = zeros(5);
client_ap_map = zeros(5);

for i=1:5
    [client_ap_rssi(i),client_ap_map(i)] = max(signal_rssi(i,:));
end

client_ap_sector = zeros(5);
for i=1:5 
    client_ap_sector(i) = sector_mat(i,client_ap_map(i));     
end


interference = zeros(5);
for i=1:5
    for j=1:5
        if i ~= j 
        current_sector = client_ap_sector(j);
        current_ap = client_ap_map(j,1);
        interference(i) = interference(i) + p_ap.pattern_rssi(phi_index(i,current_ap),theta_index(i,current_ap),current_sector);
        end
    end
end
sir = zeros(5);
 for i=1:5
     sir(i) = client_ap_rssi(i)/interference(i);
 end
 
