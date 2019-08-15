classdef cTarget
  properties
    % Position
    x
    y
    z
    vx
    vy
    vz
    rcs
  end

  methods
    function obj = cTarget(x, y, z, vx, vy, vz, rcs)
      obj.x = x;
      obj.y = y;
      obj.z = z;
      obj.vx = vx;
      obj.vy = vy;
      obj.vz = vz;
      obj.rcs = rcs;
    end
  end
end
