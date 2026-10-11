function [R,az,el,v_radial] = func_geometry_engine(ac_lla,ac_att,ac_vel_ned,tgt_lla,tgt_vel_ned)

%ac_lla     : [lat lon alt]    aircraft    (deg,deg,m)
%ac_att     : [roll pitch yaw] aircraft          (deg)
%ac_vel_ned : [Vn   Ve    Vd]  aircraft          (m/s)
%tgt_lla    :      [Nx3]       Targets
%tgt_vel_ned:      [Nx3]       Target Velocities (m/s)



N        = size(tgt_lla,1);
R        = zeros(1,N);
az       = zeros(1,N);
el       = zeros(1,N);
v_radial = zeros(1,N);


%NED to Body Rotation Matrix

c_ned2_body = angle2dcm(deg2rad(ac_att(3)),deg2rad(ac_att(2)),deg2rad(ac_att(1)));

    for t = 1:N
        %hedef konumu, uçağa göre NED'de
        d_ned = func_lla2ned_custom(tgt_lla(t,:),ac_lla);
        % NED to Body
        d_body = c_ned2_body * d_ned(:);
        
        %Spherical Coordinates
        R(t)  = norm(d_body);
        az(t) = atan2d(d_body(2),d_body(1));                           % positive right
        el(t) = atan2d(d_body(3),sqrt(d_body(1)^2 + d_body(2)^2));     % downward positive (body z axis looks down)
    
        %rad  hız (yak)
        % v_rel = tgt_vel_ned(t,:) - ac_vel_ned;
        % los   = d_ned(:) / norm(d_ned);
        % v_radial(t) = -dot(v_rel(:),los);
    end
end



    