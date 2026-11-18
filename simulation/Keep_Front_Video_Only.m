function Keep_Front_Video_Only()
folder=fileparts(mfilename('fullpath'));
mdl='VIRTUAL_self_driving_stack_autoLocalize_v2';
file=fullfile(folder,[mdl '.slx']);
if bdIsLoaded(mdl)
    assert(strcmp(get_param(mdl,'SimulationStatus'),'stopped'),'Stop simulation first.');
    assert(strcmp(get_param(mdl,'Dirty'),'off'),'Save or discard current model edits first.');
end
backup=fullfile(folder,'backups','before_front_video_only');
if ~isfolder(backup), mkdir(backup); end
if ~isfile(fullfile(backup,[mdl '.slx']))
    copyfile(file,fullfile(backup,[mdl '.slx']));
end
addpath(folder,fullfile(folder,'YOLO Files'));
load_system(file);
% These three displays are fed by right, rear, and left CSI cameras.
for id=[14238 14239 14240]
    b=Simulink.ID.getHandle([mdl ':' num2str(id)]);
    set_param(b,'Commented','on');
end
% Keep front CSI display (SID 14241). Hide remaining diagnostic viewers.
blocks=find_system(mdl,'LookUnderMasks','all','FollowLinks','off', ...
    'RegExp','on','BlockType','Reference', ...
    'SourceBlock','quarc_library/Multimedia/Video Display');
front=[mdl '/CSICameras/Video Compressed' newline 'Display3/Video Display'];
for k=1:numel(blocks)
    if ~strcmp(blocks{k},front)
        set_param(blocks{k},'Commented','on');
    end
end
tile=Simulink.ID.getHandle([mdl ':14426']);
set_param(tile,'Commented','on');
save_system(mdl,file);
fprintf('Saved front CSI video-only display configuration.\n');
end
