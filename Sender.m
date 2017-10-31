classdef Sender < Radio
    methods
        function s = Sender(center, theta, phi, bw, name)
            s@Radio(center, theta, phi, bw, name);
            s.colorArray = 'red';
            s.colorBeam = 'blue';
        end
    end
end