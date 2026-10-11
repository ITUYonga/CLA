function [outVec] = func_bodyangles2ned(az,el,roll,pitch,yaw)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
arguments (Input)
    az
    el
    roll
    pitch
    yaw
end

arguments (Output)
    outVec
end


c_bodyAngles2nedDCM = [cos(az)*cos(el),  cos(el)*sin(az), -sin(el);
                       -sin(az)       ,  cos(az)        ,        0;
                       sin(el)*cos(az),  sin(az)*sin(el), cos(el)];

d_body = c_bodyAngles2nedDCM' * [100000; 0; 0];

c_body2nedDCM = [cos(yaw)*cos(pitch),  sin(yaw)*cos(pitch), -sin(pitch);
                 sin(roll)*sin(pitch)*cos(yaw)-cos(roll)*sin(yaw), sin(roll)*sin(pitch)*sin(yaw)+cos(roll)*cos(yaw), sin(roll)*cos(pitch);
                 cos(roll)*sin(pitch)*cos(yaw)+ sin(roll)*sin(yaw),  cos(roll)*sin(pitch)*sin(yaw)-sin(roll)*cos(yaw), cos(roll)*cos(pitch)];

outVec = c_body2nedDCM' * d_body;
end