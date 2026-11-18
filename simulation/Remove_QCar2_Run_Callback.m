function Remove_QCar2_Run_Callback()
folder=fileparts(mfilename('fullpath'));
mdl='VIRTUAL_self_driving_stack_autoLocalize_v2';
file=fullfile(folder,[mdl '.slx']);
backup=fullfile(folder,'backups','before_remove_runtime_callback');
if bdIsLoaded(mdl)
    assert(strcmp(get_param(mdl,'SimulationStatus'),'stopped'),'Stop simulation first.');
    assert(strcmp(get_param(mdl,'Dirty'),'off'),'Save or discard model edits first.');
end
if ~isfolder(backup), mkdir(backup); end
if ~isfile(fullfile(backup,[mdl '.slx']))
    copyfile(file,fullfile(backup,[mdl '.slx']));
end
addpath(folder,fullfile(folder,'YOLO Files'));
load_system(file);
callback=get_param(mdl,'StartFcn');
assert(isempty(callback) || contains(callback,'Ensure_QCar2_Runtime'), ...
    'Model has an unrelated StartFcn; inspect it before removal.');
set_param(mdl,'StartFcn','');
save_system(mdl,file);
fprintf('Removed QCar2 runtime StartFcn. Run Virtual_Setup_Competition_Map before Simulink.\n');
end
