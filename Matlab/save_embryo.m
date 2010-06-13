function handles = save_embryo(handles)
% save the embryo file to the DATA_SEMIAUTO directory


% if ~handles.embryo.changed
%     return;
% else
%     % want to save it with this equal to zero
%     handles.embryo.changed = 0;
% end

% if unchanged, don't bother
% can just store changed variable in Embryo4D class, set it back to
% unchanged upon save (i.e. at the bottom of this function)
% or is that a problem because sometimes you just change the CG? does that
% ever happen? probably not because of re-tracking...
% could also just re-load saved thing and compare, but then this barely
% saves time because loading takes almost as long as saving (maybe half the
% time)

% do this first so that the saved form will always have this set to zero
handles.embryo.changed = 0;


embryo4d = handles.embryo;
filename = fullfile(handles.tempsrc.parent, 'embryo_data');
try
    save(filename, 'embryo4d');
%     save(filename, 'embryo4d', '-v7');
catch ME
   % IN CASE IT RUNS OUT OF MEMORY WHILE SAVING!!!!!!!!!!!!!!!!!!!!! 
   disp('Error in save_embryo.m: out of memory!') 
   keyboard
    
end




% %%
% dir = '/Users/mgelbart/Desktop/gastrulation/DATA_SEMIAUTO/2009_11_04_sequence/cg objects/';
% 
% for time_i = handles.info.start_time:handles.info.end_time
%     for layer_i = handles.info.bottom_layer:sign(handles.info.top_layer-handles.info.bottom_layer):handles.info.top_layer
%         filename2 = handles.info.image_file(time_i, layer_i, dir);
%         filename2 = chgext(filename2, 'mat');
% %         tempcg = handles.embryo.getCellGraph(time_i, layer_i);
% %         tempcg.setParent([]);
%         load(filename2);
%         handles.embryo.addCellGraph(tempcg, time_i, layer_i);
%     end
% end
% 
% 
% %%
% 
% 
%     handles.embryo = Embryo4D(...
%         handles.info.start_time, handles.info.end_time, handles.info.master_time, ...
%         handles.info.bottom_layer, handles.info.top_layer, handles.info.master_layer, ... 
%         handles.info.tracking_area_change_Z, handles.info.tracking_layers_back_Z, ...
%         handles.info.tracking_centroid_distance_Z / handles.info.microns_per_pixel, ...
%         handles.info.tracking_area_change_T, handles.info.tracking_layers_back_T, ...
%         handles.info.tracking_centroid_distance_T / handles.info.microns_per_pixel);


