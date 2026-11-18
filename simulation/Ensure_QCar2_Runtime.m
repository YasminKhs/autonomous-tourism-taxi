function Ensure_QCar2_Runtime()
% Restart only the virtual QCar2 workspace before each Simulink run.
% Never open a raw TCP connection to the HIL proxy: its protocol expects
% a real HIL client, so a probe can disrupt the next HIL Initialize.
qvl=fullfile(getenv('QAL_DIR'),'0_libraries','matlab','qvl');
if ~isfolder(qvl), error('QAL_DIR does not point to the Quanser resources.'); end
addpath(qvl);
qlabs=QuanserInteractiveLabs();
if ~qlabs.open('localhost')
    error('QLabs is not connected. Open QCar2 / Open Plane World and rerun the setup.');
end
car=QLabsQCar2(qlabs);
car.actorNumber=0;
present=car.ping();
qlabs.close();
if ~present
    error(['QCar2 actor 0 is missing in QLabs. Run ' ...
        'Virtual_Setup_Competition_Map before starting the Simulink model.']);
end
target = 'tcpip://localhost:17000';
models = fullfile(getenv('RTMODELS_DIR'),'QCar2');
workspace = fullfile(models,'QCar2_Workspace_studio.rt-win64');
if ~isfile(workspace)
    error('QCar2 runtime model is missing: %s',workspace);
end

% Both names are used by the competition resources. Quiet stop handles
% the case where no previous model is running.
for name = {'QCar2_Workspace','QCar2_Workspace_studio'}
    candidate = fullfile(models,[name{1} '.rt-win64']);
    if isfile(candidate)
        system(['quarc_run -q -Q -t ' target ' "' candidate '"']);
    end
end
pause(1);

[status,output] = system(['quarc_run -D -r -t ' target ' "' workspace '"']);
if status ~= 0
    error('Could not start QCar2_Workspace_studio (exit %d):\n%s',status,output);
end

ports = [18960 18965 18967];
names = {'QCar2 HIL','Video3D camera','QCar localization'};
for k=1:numel(ports)
    started = tic;
    ready = false;
    while toc(started) < 30
        [netStatus, listeners] = system('netstat -an -p tcp');
        pattern = ['(?m)^\s*TCP\s+\S+:' num2str(ports(k)) '\s+\S+\s+LISTENING(?:\s|$)'];
        if netStatus == 0 && ~isempty(regexp(listeners,pattern,'once'))
            ready = true;
            break
        end
        pause(0.5);
    end
    if ~ready
        error(['%s server did not start on localhost:%d. Check that QLabs ' ...
            'is open in QCar2 / Open Plane World, then rerun the setup.'], ...
            names{k},ports(k));
    end
    fprintf('%s ready on localhost:%d\n',names{k},ports(k));
end
pause(2); % allow the proxy to finish initialization after binding sockets
end
