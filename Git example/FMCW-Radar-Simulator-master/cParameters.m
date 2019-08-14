classdef cParameters
  properties
    % Parameters file
    sConfigFile
    xmlDoc

    % Constants
    c
    k

    % Frequencies
    fBandwith
    fSampleFreq
    fCarrierFreq

    % Power
    fTransmittedPower

    % Periods
    fObsTime
    fModTime
    iNumOfMod
    iPointsPerMod

    % Targets
    iNumOfTargets
    targets

    % Antennas
    antennaTx
    antennaRxSup
    antennaRxInf

    % Noise
    fNoiseTemperature
    fNoiseFigure

    % Detection
    fCFAR

  end

  methods
    function obj = cParameters()
      obj.sConfigFile = 'parameters.xml';
      obj.xmlDoc = xml2struct(obj.sConfigFile);

      obj.c = 3e8;
      obj.k = 1.38e-23;

      obj.fBandwith = str2num(obj.extractDataXml({'bandwith'}));
      obj.fSampleFreq = str2num(obj.extractDataXml({'sample_frequency'}));
      obj.fCarrierFreq = str2num(obj.extractDataXml({'carrier_frequency'}));

      obj.fTransmittedPower = str2num(obj.extractDataXml({'transmitted_power'}));

      obj.fObsTime = str2num(obj.extractDataXml({'observation_time'}));
      obj.fModTime = str2num(obj.extractDataXml({'modulation_time'}));
      obj.iNumOfMod = floor(obj.fObsTime / obj.fModTime);
      obj.iPointsPerMod = floor(obj.fModTime*obj.fSampleFreq);

      obj.iNumOfTargets = str2num(obj.extractDataXml({'number_of_targets'}));
      obj.targets = [];
      for i = 1:obj.iNumOfTargets
        sTarget = ['target', num2str(i)];
        obj.targets = [obj.targets cTarget( ...
          str2num(obj.extractDataXml({'targets', sTarget, 'x'})), ...
          str2num(obj.extractDataXml({'targets', sTarget, 'y'})), ...
          str2num(obj.extractDataXml({'targets', sTarget, 'z'})), ...
          str2num(obj.extractDataXml({'targets', sTarget, 'vx'})), ...
          str2num(obj.extractDataXml({'targets', sTarget, 'vy'})), ...
          str2num(obj.extractDataXml({'targets', sTarget, 'vz'})), ...
          str2num(obj.extractDataXml({'targets', sTarget, 'rcs'})) ...
        )];
      end

      fGainDB = str2num(obj.extractDataXml({'antennas', 'antenna1', 'gain'}));
      fGainLinear = 10^(fGainDB/10.);
      obj.antennaTx = cAntenna( ...
        str2num(obj.extractDataXml({'antennas', 'antenna1', 'x'})), ...
        str2num(obj.extractDataXml({'antennas', 'antenna1', 'y'})), ...
        str2num(obj.extractDataXml({'antennas', 'antenna1', 'z'})), ...
        fGainLinear ...
      );

      fGainDB = str2num(obj.extractDataXml({'antennas', 'antenna2', 'gain'}));
      fGainLinear = 10^(fGainDB/10.);
      obj.antennaRxSup = cAntenna( ...
        str2num(obj.extractDataXml({'antennas', 'antenna2', 'x'})), ...
        str2num(obj.extractDataXml({'antennas', 'antenna2', 'y'})), ...
        str2num(obj.extractDataXml({'antennas', 'antenna2', 'z'})), ...
        fGainLinear ...
      );

      fGainDB = str2num(obj.extractDataXml({'antennas', 'antenna3', 'gain'}));
      fGainLinear = 10^(fGainDB/10.);
      obj.antennaRxInf =  cAntenna( ...
        str2num(obj.extractDataXml({'antennas', 'antenna3', 'x'})), ...
        str2num(obj.extractDataXml({'antennas', 'antenna3', 'y'})), ...
        str2num(obj.extractDataXml({'antennas', 'antenna3', 'z'})), ...
        fGainLinear ...
      );


      obj.fNoiseTemperature = str2num(obj.extractDataXml({'noise_temperature'}));
      obj.fNoiseFigure = str2num(obj.extractDataXml({'noise_figure'}));
      obj.fNoiseFigure = 10^(obj.fNoiseFigure/10.);

      obj.fCFAR = str2num(obj.extractDataXml({'cfar'}));

    end


    function value = extractDataXml(obj, fields)
      xmlNode = obj.xmlDoc;
      for i=1:size(fields, 2)
        for j=1:size(xmlNode.Children, 2)
          xmlChild = xmlNode.Children(j);
          if strcmp(xmlChild.Name, fields(i)) == 1
            xmlNode = xmlChild;
            break
          end
        end
      end
      value = xmlNode.Children(1).Data;
    end
  end

end
