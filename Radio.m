classdef Radio < handle
    properties
        % core radio properties
        theta, phi, c, bw
        
        % derived array properties
        xyz, c2 % array geometry
        rlx, rly % reference line of array
        
        % derived beam properties
        beamx, beamy, beamz % beam geometry
        beamN, beamdir
    end
    properties
        % used by the superclass
        colorArray = 'red';
        colorBeam = 'blue'
        radioName = '';
    end
    properties (Access = private)
        % internal variables
        init = 0;
        phBeam = {}, phArray = {} % store plot data
    end
    properties (Constant)
        % class enumerate
        pArray = bitshift(1,0); 
        pBeam = bitshift(1,1);
        % class constant
        scaleArray = 0.5;
        scaleBeam = 0.8;
        beamShape = 20;
        beamDensity = 162; % 12, 42, 162, 642
    end
    methods
        function obj = Radio(center, theta, phi, bw, name)
            if nargin > 0
                obj.theta = deg2rad(theta);
                obj.phi = deg2rad(phi);
                obj.c = center(:);
                obj.bw = deg2rad(bw);
                obj.radioName = name;
                obj.init = 1;
                obj.checkParam();
                
                obj = updateArray(obj);
                obj = updateBeam(obj);
            end
        end
        function obj = updateArray(obj)
            x = [-1 1 1 -1]*Radio.scaleArray;
            y = [-1 -1 1 1]*Radio.scaleArray;
            z = [0 0 0 0];
            ct = [0 0 1].';
            %Rx = [1 0 0; 0 cos(obj.theta) -sin(obj.theta); 0 sin(obj.theta) cos(obj.theta)];
            Ry = [cos(obj.theta) 0 sin(obj.theta); 0 1 0; -sin(obj.theta) 0 cos(obj.theta)];
            Rz = [cos(obj.phi) -sin(obj.phi) 0; sin(obj.phi) cos(obj.phi) 0; 0 0 1];
            rc = repmat(obj.c, 1, 4);
            
            obj.xyz = Rz*Ry*([x;y;z])+rc;
            obj.c2 = Rz*Ry*(ct)+obj.c;
            
            obj.rlx = ( obj.xyz(:, 2) - obj.xyz(:, 1) ) + obj.c;
            obj.rly = ( obj.xyz(:, 4) - obj.xyz(:, 1) ) + obj.c;
        end
        function obj = updateBeam(obj)
            [x, y, z] = cylinder([0 tan(obj.bw)],Radio.beamShape);
            %Rx = [1 0 0; 0 cos(obj.theta) -sin(obj.theta); 0 sin(obj.theta) cos(obj.theta)];
            Ry = [cos(obj.theta) 0 sin(obj.theta); 0 1 0; -sin(obj.theta) 0 cos(obj.theta)];
            Rz = [cos(obj.phi) -sin(obj.phi) 0; sin(obj.phi) cos(obj.phi) 0; 0 0 1];
            sx = size(x);
            rc = repmat(obj.c, 1, sx(1)*sx(2));
            
            beam = Rz*Ry*([x(:) y(:) z(:)].'*Radio.scaleBeam/tan(obj.bw))+rc;
            obj.beamx = reshape(beam(1,:), 2, []);
            obj.beamy = reshape(beam(2,:), 2, []);
            obj.beamz = reshape(beam(3,:), 2, []);
            
            [beamtheta, beamphi] = utilLib.SphereGrid(Radio.beamDensity, rad2deg(obj.bw));
            
            obj.beamN = length(beamtheta);
            rc = repmat(obj.c, 1, obj.beamN);
            obj.beamdir = Rz*Ry*[sin(beamtheta).*cos(beamphi), ...
                           sin(beamtheta).*sin(beamphi), ...
                           cos(beamtheta)].'+rc;
        end
        function plot(obj, n, k)
            for obji = obj
                k = sum(k);
                if bitand(k, Radio.pArray)
                    obji.plotArray(n);
                end
                if bitand(k, Radio.pBeam)
                    obji.plotBeam(n);
                end
            end
        end
        function obj = setParams(obj, c, theta, phi)
            obj.c = c(:);
            obj.theta = deg2rad(theta);
            obj.phi = deg2rad(phi);
            obj.checkParam();
            if obj.getinit
                obj = updateArray(obj);
                obj = updateBeam(obj);
            end
        end
        function obj = setPosition(obj, c)
            obj.c = c(:);
            if obj.getinit
                obj = updateArray(obj);
                obj = updateBeam(obj);
            end
        end
        function obj = setTheta(obj, theta)
            obj.theta = deg2rad(theta);
            if obj.getinit
                obj = updateArray(obj);
                obj = updateBeam(obj);
            end
        end
        function obj = setPhi(obj, phi)
            obj.phi = deg2rad(phi);
            if obj.getinit
                obj = updateArray(obj);
                obj = updateBeam(obj);
            end
        end
        function obj = setBW(obj, bw)
            obj.bw = deg2rad(bw);
            if obj.getinit
                obj = updateArray(obj);
                obj = updateBeam(obj);
            end
        end
        function s = getinit(obj)
            s = obj.init;
        end
    end
    methods (Access = private)
        function ret = checkParam(obj)
            ret = 0;
            if obj.theta < 0 || obj.theta > pi
                warning('Out of valid range: theta');
                ret = 1;
            end
            if obj.phi < 0 || obj >= 2*pi
                warning('Out of valid range: phi');
                ret = 1;
            end
        end
        function plotArray(obj,n)
            figure(n)
            hold on
            for ii = 1:length(obj.phArray)
                if ~isempty(obj.phArray{ii})
                    delete(obj.phArray{ii});
                end
            end
            obj.phArray{1} = patch(obj.xyz(1,:), obj.xyz(2,:), obj.xyz(3,:), obj.colorArray);
            obj.phArray{2} = plot3([obj.c(1) obj.c2(1)], [obj.c(2) obj.c2(2)], [obj.c(3) obj.c2(3)], obj.colorBeam, 'LineWidth', 2);
            obj.phArray{3} = text(obj.c(1),obj.c(2),obj.c(3)+0.5,obj.radioName,'HorizontalAlignment','left','FontSize',10);
            obj.phArray{4} = plot3([obj.rlx(1) obj.c(1)], [obj.rlx(2) obj.c(2)], [obj.rlx(3) obj.c(3)], 'yellow', 'LineWidth', 1);
            obj.phArray{5} = plot3([obj.rly(1) obj.c(1)], [obj.rly(2) obj.c(2)], [obj.rly(3) obj.c(3)], 'yellow', 'LineWidth', 1);
            drawnow
        end
        function plotBeam(obj, n)
            figure(n);
            hold on
            for ii = 1:length(obj.phBeam)
                if ~isempty(obj.phBeam{ii})
                    delete(obj.phBeam{ii});
                end
            end
            obj.phBeam{1} = surf(obj.beamx, obj.beamy, obj.beamz);
            for ii = 1:obj.beamN
                obj.phBeam{1+ii} = plot3([obj.c(1) obj.beamdir(1, ii)], ... 
                                         [obj.c(2) obj.beamdir(2, ii)], ...
                                         [obj.c(3) obj.beamdir(3, ii)], 'red', 'linewidth', 1);
            end
            drawnow
        end
        function ret = getBeamTheta_(obj, vec)
            ls = obj.c2-obj.c;
            ret = utilLib.getAngle(ls,vec);
        end
        function ret = getBeamPhi_(obj, vec)
            angleX = utilLib.getAngle(obj.rlx-obj.c, vec-obj.c);
            angleY = utilLib.getAngle(obj.rly-obj.c, vec-obj.c);
            if angleY <= pi/2
                ret = angleX;
            else
                ret = 2*pi-angleX;
            end
        end
        function ret = getLOSNLOS_(obj, vec)
            if obj.getBeamTheta_(vec) > obj.bw
                ret = -1;
            else
                ret = 1;
            end
        end
        function ret = getBeamIndex_(obj, vec)
            minAngle = inf;
            b = -1;
            if obj.getBeamTheta_(vec) > obj.bw
                ret = b;
                return;
            end
            for ii = 1:obj.beamN
                a = utilLib.getAngle(obj.beamdir(:,ii)-obj.c, vec);
                if a < minAngle
                    minAngle = a;
                    b = ii;
                end
            end
            ret = b;
        end
    end
    methods (Static)        
        function ret = isLOS(s, r)
            [angleS, angleR] = Radio.getBeamTheta(s, r);
            ret = ((angleS < s.bw) & (angleR < r.bw));
        end
        function [BeamThetaS, BeamThetaR] = getBeamTheta(s, r)
            lsr = r.c-s.c;
            lrs = -lsr;
            BeamThetaS = s.getBeamTheta_(lsr);
            BeamThetaR = r.getBeamTheta_(lrs);
        end
        function [BeamPhiS, BeamPhiR] = getBeamPhi(s, r)
            ls = s.c2-s.c;
            lr = r.c2-r.c;
            Ns = ls/norm(ls);
            Nr = lr/norm(lr);
            lsr = r.c-s.c;
            lrs = -lsr;
            % beam from sender to receiver projected to the array plane
            Usr = lsr-dot(lsr, Ns)*Ns;
            Usr = Usr/norm(Usr)+s.c;
            Urs = lrs-dot(lrs, Nr)*Nr;
            Urs = Urs/norm(Urs)+r.c;
            
%             hold on
%             plot3([r.c(1) s.c(1)], [r.c(2) s.c(2)], [r.c(3) s.c(3)], 'green', 'LineWidth', 1.5)
%             plot3([Usr(1) s.c(1)], [Usr(2) s.c(2)], [Usr(3) s.c(3)], 'black', 'LineWidth', 1)
%             plot3([Urs(1) r.c(1)], [Urs(2) r.c(2)], [Urs(3) r.c(3)], 'black', 'LineWidth', 1)
            
            BeamPhiS = s.getBeamPhi_(Usr);
            BeamPhiR = r.getBeamPhi_(Urs);
        end
        function [BeamIndexS, BeamIndexR] = getBeamIndex(s, r)
            lsr = r.c-s.c;
            lrs = -lsr;
            
            BeamIndexS = s.getBeamIndex_(lsr);
            BeamIndexR = r.getBeamIndex_(lrs);
        end
        function ret = getLOSNLOS(s, r)
            % 1  - LOS
            % -1 - NLOS
            % more efficient than getBeamIndex
            lsr = r.c-s.c;
            lrs = -lsr;
            
            LOSNLOSS = s.getLOSNLOS_(lsr);
            LOSNLOSR = r.getLOSNLOS_(lrs);
            if LOSNLOSS > 0 && LOSNLOSR > 0
                ret = 1;
            else
                ret = -1;
            end
        end
    end
end