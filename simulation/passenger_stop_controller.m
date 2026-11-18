function [speedCmd,stage,targetDistance] = passenger_stop_controller(nominalSpeed,pose,measuredSpeed,time,readyAfter)
%#codegen
% One pickup followed by one drop-off per simulation run. XY map meters.
% Stages: 0 approach pickup, 1 pickup dwell, 2 approach drop-off,
% 3 drop-off dwell, 4 mission complete.
persistent phase holdStarted lastTime
if isempty(phase)
    phase = 0; holdStarted = -1; lastTime = time;
end
if time < lastTime
    phase = 0; holdStarted = -1;
end
lastTime = time;
pickup = [2.19; -0.26];
dropoff = [0.92; -1.10];
speedCmd = nominalSpeed;
targetDistance = 0;
if phase < 2
    targetDistance = hypot(pose(1)-pickup(1),pose(2)-pickup(2));
elseif phase < 4
    targetDistance = hypot(pose(1)-dropoff(1),pose(2)-dropoff(2));
end
valid = all(isfinite(pose)) && isfinite(measuredSpeed);
if time >= readyAfter && valid
    % Trigger slightly inside the requested radius to allow braking travel.
    if (phase == 0 || phase == 2) && targetDistance <= 0.9
        phase = phase + 1;
        holdStarted = time;
    end
end
if phase == 1 || phase == 3
    speedCmd = 0;
    % Release after five simulation seconds even if the speed sensor jitters
    % or the car drifts slightly while braking. Each stage is entered once.
    if holdStarted >= 0 && time-holdStarted >= 5
        phase = phase + 1;
        holdStarted = -1;
        speedCmd = nominalSpeed;
    end
end
stage = phase;
end
