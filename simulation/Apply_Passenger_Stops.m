function Apply_Passenger_Stops()
folder=fileparts(mfilename('fullpath'));
addpath(folder,fullfile(folder,'YOLO Files'));
mdl='VIRTUAL_self_driving_stack_autoLocalize_v2';
file=fullfile(folder,[mdl '.slx']);
if bdIsLoaded(mdl)
    assert(strcmp(get_param(mdl,'SimulationStatus'),'stopped'),'Stop the simulation first.');
    assert(strcmp(get_param(mdl,'Dirty'),'off'),'Save existing edits first.');
end
backup=fullfile(folder,'backups','before_passenger_stops');
if ~isfolder(backup), mkdir(backup); end
if ~isfile(fullfile(backup,[mdl '.slx']))
    copyfile(file,fullfile(backup,[mdl '.slx']));
end
load_system(file);
mission=[mdl '/Passenger Stops'];
if getSimulinkBlockHandle(mission)==-1
    add_block('simulink/User-Defined Functions/MATLAB Function',mission,'Position',[100 700 320 820]);
end
c=find(sfroot,'-isa','Stateflow.EMChart','Path',mission);
c.Script=fileread(fullfile(folder,'passenger_stop_controller.m'));
c.ChartUpdate='DISCRETE'; c.SampleTime='Controller_Sample_Time';
if getSimulinkBlockHandle([mdl '/Passenger Stop Clock'])==-1
    add_block('simulink/Sources/Digital Clock',[mdl '/Passenger Stop Clock'], ...
        'SampleTime','Controller_Sample_Time','Position',[-100 780 -20 810]);
    add_block('simulink/Signal Routing/From',[mdl '/Passenger Measured Speed'], ...
        'GotoTag','measuredSpeed','Position',[-100 740 -20 770]);
    add_block('simulink/Sources/Constant',[mdl '/Passenger Ready Time'], ...
        'Value','Initialization_Time+2','Position',[-100 830 -20 860]);
    add_block('simulink/Sinks/Display',[mdl '/Passenger Stage 0 Pickup 2 Dropoff 4 Done'], ...
        'Position',[400 750 520 790]);
    add_block('simulink/Sinks/Display',[mdl '/Passenger Target Distance m'], ...
        'Position',[400 810 520 850]);
    speedPorts=get_param([mdl '/speedController'],'PortHandles');
    line=get_param(speedPorts.Inport(1),'Line');
    originalSource=get_param(line,'SrcPortHandle');
    delete_line(mdl,originalSource,speedPorts.Inport(1));
    ph=get_param(mission,'PortHandles');
    add_line(mdl,originalSource,ph.Inport(1),'autorouting','on');
    posePorts=get_param([mdl '/localization'],'PortHandles');
    add_line(mdl,posePorts.Outport(1),ph.Inport(2),'autorouting','on');
    add_line(mdl,'Passenger Measured Speed/1','Passenger Stops/3','autorouting','on');
    add_line(mdl,'Passenger Stop Clock/1','Passenger Stops/4','autorouting','on');
    add_line(mdl,'Passenger Ready Time/1','Passenger Stops/5','autorouting','on');
    add_line(mdl,ph.Outport(1),speedPorts.Inport(1),'autorouting','on');
    add_line(mdl,'Passenger Stops/2','Passenger Stage 0 Pickup 2 Dropoff 4 Done/1','autorouting','on');
    add_line(mdl,'Passenger Stops/3','Passenger Target Distance m/1','autorouting','on');
end
save_system(mdl,file);
fprintf('Passenger stops saved. Original model backed up to %s\n',backup);
end
