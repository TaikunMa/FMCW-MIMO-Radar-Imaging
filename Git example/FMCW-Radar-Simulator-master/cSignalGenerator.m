classdef cSignalGenerator
  properties
    % Periods
    afTime
    afTimeN

    % Signals
    afTxSignal
    afRxSignalSup
    afRxSignalInf

  end

  methods
    % Constructor
    function obj = cSignalGenerator(param)
      % Periods
      obj.afTime = 0:1./param.fSampleFreq:param.fObsTime;
      obj.afTimeN = mod(obj.afTime, param.fModTime);

      % Generating Tx Signal
      obj.afTxSignal = obj.generateTxSignal(param);

      % Generating Rx Signal
      for i=1:param.iNumOfTargets
        if i == 1
          obj.afRxSignalSup = obj.generateRxSignal(param, i, 0);
          obj.afRxSignalInf = obj.generateRxSignal(param, i, 1);
        else
          obj.afRxSignalSup = obj.afRxSignalSup + obj.generateRxSignal(param, i, 0);
          obj.afRxSignalInf = obj.afRxSignalInf + obj.generateRxSignal(param, i, 1);
        end

        % Adding noise to the signals
        obj.afRxSignalSup = obj.afRxSignalSup + obj.generateThermalNoise(param);
        obj.afRxSignalInf = obj.afRxSignalInf + obj.generateThermalNoise(param);

      end
    end


    function afTxSignal = generateTxSignal(obj, param)
      % Creating the transmited signal
      phi = (param.fCarrierFreq - param.fBandwith/2)*obj.afTimeN + ...
                param.fBandwith * (obj.afTimeN.^2) / (2*param.fModTime);
      % afTxSignal = sqrt(param.fTransmittedPower)*exp(j*2*pi*phi);
      afTxSignal = exp(j*2*pi*phi);
    end


    function afRxSignal = generateRxSignal(obj, param, targetNum, antennaNum)
      % TODO: Add antenna gain
      % TODO: Add antenna diagram
      % TODO: Transform the chirp to complex

      % Selecting antenna. 0 for RxSup, 1 for RxInf
      if antennaNum == 0
        antenna = param.antennaRxSup;
      else
        antenna = param.antennaRxInf;
      end

      % Moving targets and then calculating range
      x = param.targets(targetNum).x + obj.afTime * param.targets(targetNum).vx;
      y = param.targets(targetNum).y + obj.afTime * param.targets(targetNum).vy;
      z = param.targets(targetNum).z + obj.afTime * param.targets(targetNum).vz;

      afRange = sqrt((x - antenna.x).^2 + (y - antenna.y).^2 + (z - antenna.z).^2);
      afDelay = 2*afRange/param.c;

      fReceivedPower = obj.radarEquation(param, param.targets(targetNum), antenna);

      phi = (param.fCarrierFreq - param.fBandwith/2)*mod(obj.afTimeN-afDelay, param.fModTime) + ...
                param.fBandwith * (mod(obj.afTimeN-afDelay, param.fModTime).^2) / (2*param.fModTime);
      afRxSignal = exp(j*2*pi*phi);
      % afRxSignal = sqrt(fReceivedPower)*exp(j*2*pi*phi);
    end


    function fReceivedPower = radarEquation(obj, param, target, antenna)
      fRange = sqrt(target.x^2 + target.y^2 + target.z^2);

      fReceivedPower = param.fTransmittedPower*param.antennaTx.fGain*antenna.fGain* ...
                target.rcs*((1/param.fCarrierFreq)^2) / ((4*pi)^3 * fRange^4);
    end


    function acRuido = generateThermalNoise(obj, param)
      % TODO: Confirm the calculations here
      % Create the guassian white noise
      acRuido = exp(2*j*pi*rand(size(obj.afTime)));

      % Multipling by the amplitude of the thermal noise
      fPower = param.k*param.fNoiseTemperature*param.fBandwith*param.fNoiseFigure;
      acRuido = sqrt(fPower) * acRuido;
    end

  end
end
