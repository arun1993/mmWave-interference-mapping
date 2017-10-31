classdef Receiver < Radio
    methods
        function s = Receiver(center, theta, phi, bw, name)
            s@Radio(center, theta, phi, bw, name);
            s.colorArray = 'blue';
            s.colorBeam = 'red';
        end
    end
end