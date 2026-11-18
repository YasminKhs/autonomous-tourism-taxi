function Fix_RealSense_Device_Name()
folder=fileparts(mfilename('fullpath'));
mdl='VIRTUAL_self_driving_stack_autoLocalize_v2';
file=fullfile(folder,[mdl '.slx']);
backup=fullfile(folder,'backups','before_realsense_device_fix');
if bdIsLoaded(mdl)
    assert(strcmp(get_param(mdl,'SimulationStatus'),'stopped'),'Stop the simulation first.');
    assert(strcmp(get_param(mdl,'Dirty'),'off'),'Save or discard model edits first.');
end
if ~isfolder(backup), mkdir(backup); end
if ~isfile(fullfile(backup,[mdl '.slx']))
    copyfile(file,fullfile(backup,[mdl '.slx']));
end
addpath(folder,fullfile(folder,'YOLO Files'));
originalFolder=pwd;
cleanup=onCleanup(@()cd(originalFolder));
cd(folder);
Setup_QCar2_Params_Addons(1,1);
load_system(file);
init=Simulink.ID.getHandle([mdl ':13566']);
device=get_param(init,'object_name');
assert(~isempty(device) && ~strcmp(device,'unassigned'), ...
    'Video3D Initialize has no device name.');
for id=[13567 13568]
    capture=Simulink.ID.getHandle([mdl ':' num2str(id)]);
    set_param(capture,'object_name',device);
end
save_system(mdl,file);
fprintf('RealSense depth and RGB capture now use device name "%s".\n',device);
end
