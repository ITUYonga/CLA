function d_ned = func_lla2ned_custom(tgt_lla,ref_lla)

%tgt_lla -- lla of the target
%ref_lla -- reference(aircraft)
%d_ned   -- [north;east;down] (meters)

% Transiiton to ECEF

p_tgt = lla2ecef(tgt_lla);
p_ref = lla2ecef(ref_lla);

% 2. fark vektörü (ECEF)

d_ecef = p_tgt(:) - p_ref(:);

% 3. ECEF to NED rotation (around reference)

lat = deg2rad(ref_lla(1));
lon = deg2rad(ref_lla(2));

c = [-sin(lat)*cos(lon),  -sin(lat)*sin(lon), cos(lat);
              -sin(lon),            cos(lon),        0;
     -cos(lat)*cos(lon),  -cos(lat)*sin(lon), -sin(lat)];

d_ned = c * d_ecef;



end   