classdef cAntenna
  properties
    x
    y
    z

    fGain
  end

  methods
    function obj = cAntenna(x, y, z, gain)
      obj.x = x;
      obj.y = y;
      obj.z = z;
      obj.fGain = gain;
    end
  end

end
