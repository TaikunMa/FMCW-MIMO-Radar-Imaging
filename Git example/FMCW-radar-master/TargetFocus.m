function [RangeIdx TimeIdx] = TargetFocus(AlignedProfiles)

%Find Target Window
[MP MaxIndexRange] = max(max(abs(AlignedProfiles),[],2));            %max value and index over range

RangeStart = MaxIndexRange - 20;
RangeEnd = MaxIndexRange + 20;

if MaxIndexRange < 20
    RangeStart = MaxIndexRange;
    RangeEnd = MaxIndexRange + 40;
end
RangeIdx = RangeStart:RangeEnd;

%Find Sampling Index for Target
[MaxPower MaxIndexTime] = max(max(abs(AlignedProfiles),[],1));       %max value and index over time
StartTime = MaxIndexTime - 100;
EndTime = MaxIndexTime + 100;
if EndTime > size(AlignedProfiles,2)                                 %Max occurs close to end of recording
    EndTime = MaxIndexTime;
    StartTime = MaxIndexTime - 200;
end
if StartTime < 0
    StartTime = 10;
    EndTime = MaxIndexTime + 210;
end
TimeIdx = StartTime:EndTime;


end