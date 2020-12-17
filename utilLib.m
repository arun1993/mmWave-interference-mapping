classdef utilLib < handle
    methods (Static)
        function ret = getAngle(vec1, vec2)
            ret = atan2(norm(cross(vec1,vec2)),dot(vec1,vec2));
        end
        
        function [beamtheta, beamphi] = SphereGrid(N, bw)
            %addpath('geogridLib');
            [beamtheta, beamphi] = GridSphere(N);
            idx = beamtheta<(90-bw);
            beamtheta(idx) = [];
            beamphi(idx) = [];
            beamtheta = pi/2 - deg2rad(beamtheta);
            beamphi = deg2rad(mod(beamphi, 360));
        end
        
        function visualCoverageMap(traceFile, sep)
            load(traceFile);
            if sep
                OsN = 1:sN;
            else
                OsN = 1;
            end
            
            for OsNi = OsN
                if sep
                    IsN = OsNi;
                else
                    IsN = 1:sN;
                end
                
                if exist('xRngN', 'var')
                    map = zeros(xRngN, yRngN);
                    for xIdx = 1:xRngN
                        for yIdx = 1:yRngN
                            for dirIdx = 1:dirRngN
                                hasLOS = 0;
                                for IsNi = IsN
                                    if sum(result(IsNi, xIdx, yIdx, dirIdx, 1:2) > 0) == 2
                                        hasLOS = 1;
                                    end
                                end
                                if hasLOS
                                    map(yIdx, xIdx) = map(yIdx, xIdx)+1;
                                end
                            end
                        end
                    end
                elseif exist('totalN', 'var')
                    xRng = unique(motion(:, 1));
                    yRng = unique(motion(:, 2));
                    xRngN_ = length(xRng);
                    yRngN_ = length(yRng);
                    map = zeros(xRngN_, yRngN_);
                    dirRngN = size(motion, 1)/xRngN_/yRngN_;
                    
                    for totali = 1:totalN
                        hasLOS = 0;
                        for IsNi = IsN
                            if sum(result(IsNi, totali, 1:2) > 0) == 2
                                hasLOS = 1;
                            end
                        end
                        if hasLOS
                            xIdx = find(xRng == motion(totali, 1));
                            yIdx = find(yRng == motion(totali, 2));
                            map(yIdx, xIdx) = map(yIdx, xIdx)+1;
                        end
                        
                    end
                end
                utilLib.declareFig(OsNi);
                surf((map/dirRngN))
                view(3)
                colorbar
            end
        end
        
        function visualCoverageDist(traceFile, sep)
            load(traceFile);
            if sep
                OsN = 1:sN;
            else
                OsN = 1;
            end
            
            for OsNi = OsN
                if sep
                    IsN = OsNi;
                else
                    IsN = 1:sN;
                end
                
                utilLib.declareFig(OsNi);
                axis equal
                xlim([0 10])
                ylim([0 10])
                zlim([0 5])
                view(3)
                box on
                grid on
                
                if exist('xRngN', 'var')
                    map = zeros(xRngN, yRngN);
                    for xIdx = 1:xRngN
                        for yIdx = 1:yRngN
                            for dirIdx = 1:dirRngN
                                hasLOS = 0;
                                for IsNi = IsN
                                    if sum(result(IsNi, xIdx, yIdx, dirIdx, 1:2) > 0) == 2
                                        hasLOS = 1;
                                    end
                                end
                                if hasLOS
                                    map(yIdx, xIdx) = map(yIdx, xIdx)+1;
                                end
                            end
                        end
                    end
                elseif exist('totalN', 'var')
                    xRng = unique(motion(:, 1));
                    yRng = unique(motion(:, 2));
                    xRngN_ = length(xRng);
                    yRngN_ = length(yRng);
                    map = zeros(xRngN_, yRngN_);
                    dirRngN = size(motion, 1)/xRngN_/yRngN_;
                    
                    for totali = 1:100
                        hasLOS = 0;
                        for IsNi = IsN
                            if sum(result(IsNi, totali, 1:2) > 0) == 2
                                hasLOS = 1;
                            end
                        end
                        if hasLOS
                            p = utilLib.translateRotate([0 0; 0 0; 0 1], ...
                                [motion(totali, 1) motion(totali, 2) 1.5].', ...
                                deg2rad([motion(totali, 3) motion(totali, 4)]));
                            plot3(p(1,:), p(2,:), p(3,:));
                        end
                        
                    end
                end
            end
        end
        
        function y = translateRotate(x, pos, ori)
            % pos = [x; y; z]
            % ori = [theta; phi]
            Ry = [cos(ori(1)) 0 sin(ori(1)); 0 1 0; -sin(ori(1)) 0 cos(ori(1))];
            Rz = [cos(ori(2)) -sin(ori(2)) 0; sin(ori(2)) cos(ori(2)) 0; 0 0 1];
            rc = repmat(pos, 1, size(x, 2));
            
            y = Rz*Ry*x+rc;
        end
        
        function ang = angleDiff(ang1, ang2)
            y1 = utilLib.translateRotate([0 0; 0 0; 0 1], [0; 0; 0], ang1);
            y2 = utilLib.translateRotate([0 0; 0 0; 0 1], [0; 0; 0], ang2);
            ang = utilLib.getAngle(y1(:, 2), y2(:, 2));
        end
        
        function declareFig(n)
            f = figure(n); clf(f); hold on;
        end
        
        function imagesc(sNi, data, x, y, ax)
            x = unique(round(x));
            y = unique(round(y));
            f = figure(sNi); clf(f); hold on;
            imagesc( ( data ) )
            set(gca,'XTick',1:length(x))
            set(gca,'XTickLabel',num2cell(x))
            set(gca,'YTick',1:length(y))
            set(gca,'YTickLabel',num2cell(y))
            caxis(ax)
            colormap hot
            colorbar
        end
        
        function angleInRadians = deg2rad(angleInDegrees)
            angleInRadians = (pi/180) * angleInDegrees;
        end
        
        function angleInDegrees = rad2deg(angleInRadians)
            angleInDegrees = (180/pi) * angleInRadians;            
        end
        
    end
end