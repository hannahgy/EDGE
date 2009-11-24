function draw_3d_cell_one_layer(C, Z, handles, highlight)

if isempty(C)
    return;
end

dx = handles.info.microns_per_pixel;
dz = handles.info.microns_per_z_step;
z_highlight = abs(Z - handles.info.bottom_layer) + 1;
% add 1 to match with matlab array indexing

z_points = (z_highlight - 1) * dx;


% MEMBRANES
if get(handles.cbox_show_membs, 'Value')
    
    % highlight the special layer
    if highlight
        col = 'r';
    else 
        col = 'k';
    end

    verts = C.vertexCoords * dx;

    % put the beginning one at the end for wrap-around drawing
    verts(size(verts, 1)+1, :) = verts(1, :);      

    for j = 1:size(verts, 1)-1
        plot3(verts(j:j+1, 2), verts(j:j+1, 1), [z_points(i); z_points(i)], col)
    end
end


% SURFACE
% if get(handles.cbox_show_surface, 'Value')
%     csImage = Misc.drawCellStack(CS);
%     Xpts = squeeze(csImage(1, :, :)) * dx;
%     Ypts = squeeze(csImage(2, :, :)) * dx;
%     Zpts = squeeze(csImage(3, :, :)) * dz;
% 
%     colormap(bone);  
% %     colormap(copper)
%     surf(Xpts, Ypts, Zpts); shading interp;
% %     surf(Xpts, Ypts, Zpts, 'EdgeAlpha', 0); % transparent edges
% end



% VERTICES
if get(handles.cbox_show_vertices, 'Value')
    verts = C.vertexCoords * dx;
    %size: z x num verts x 2
    for zz = 1:size(verts, 1)
        % highlight the special layer
        if highlight
            col = '*r';
        else 
            col = '*b';
        end
        plot3(verts(zz, 2), verts(zz, 1), z_points, col);
    end
end



cent = C.centroid * dx;

% CENTROID
if get(handles.cbox_show_centroids, 'Value')
    if highlight
        col = '.r';
    else 
        col = '.b';
    end
    
    plot3(cent(2), cent(1), z_points, col);
    
%     % centroid line
%     linecent = cent;
%     linezpts = z_points;
%     for i = size(cent, 1):-1:1
%         if isnan(linecent(i, 1))
%             linecent(i, :) = [];
%             linezpts(i) = [];
%         end
%     end
%     line(linecent(:, 2), linecent(:, 1), linezpts, 'Color', 'g');
end




% % CENTROID FIT
% if get(handles.cbox_show_centroid_fit, 'Value')
% 
%     fitObj = CS.centroidLineFit;
%     % slope must be adjusted by dz/dx
%     Mx = fitObj.mX * dz/dx;
%     Bx = fitObj.bX * dx;
%     My = fitObj.mY * dz/dx;
%     By = fitObj.bY * dx;
% 
%     line_z = linspace(min(z_points), max(z_points) + (max(z_points) - min(z_points))/2.5);
%     % line_z = linspace(min(z_points), max(z_points) + (max(z_points)-min(z_points))/max(length(z_points), 1));
%     xss = (line_z / Mx) + Bx;
%     yss = (line_z / My) + By;  
%     plot3(xss, yss, line_z, 'g');
% end



%{
% plot the vertex fits and the vertices themsevles
vertFitObjects = CS.verticesLineFit;
for all = 1:length(vertFitObjects)
    currentObj = vertFitObjects(all);
    Mx = currentObj.mX * dz/dx;
    Bx = currentObj.bX * dx;
    My = currentObj.mY * dz/dx;
    By = currentObj.bY * dx;
    xss = (line_z / Mx) + Bx;
    yss = (line_z / My) + By;
    plot3(xss, yss, line_z, 'b');
end
%}

% if strcmp(MEASURE, 'Area (orthogonal)') && ~isnan(z_highlight)
% % draw the orthogonal plane
%     [area plane Vpts] = orthogonal_area(CS, z_points(z_highlight), INFO);
%     n = plane(:, 1); % normal
%     nx = n(1); ny = n(2); nz = n(3);
%     c = plane(:, 2); % point
% 
%     % we want to pick 4 (x,y) points to draw the plane (4 corners)
%     plsz = 5; % size of the plane
%     planeX(2) = cent(1, 1) + plsz;
%     planeX(1) = cent(1, 1) - plsz;
%     planeY(2) = cent(1, 2) + plsz;
%     planeY(1) = cent(1, 2) - plsz;
% 
%     % find Z using the formula for a plane and solving for z
%     % the repmat is just to get Z as a matrix for surf
%     planeZ = (1/nz)*(n.'*c - nx*repmat(planeX, 2, 1) - ...
%         ny*repmat(planeY.', 1, 2));
% 
%     color = zeros(2, 2, 3);
%     % draw the actual shape used for orthogonal area, not just a 
%     % square plane. well, for this you'd need to use a bunch of triangles
%     % each connected with the center. otherwise it won't really work.
%     % wait, shouldn't it work? they all lie in a plane...
%     %{
%     planeX = Vpts(1, :);
%     planeY = Vpts(2, :);
%     planeZ = repmat(Vpts(3,:), length(planeX), 1);
%     color = zeros(length(planeX), length(planeX), 3);
%     %}
%     color(:,:,1) = 1;
%     surf(planeX, planeY, planeZ, ...
%         'FaceAlpha', 0.1, 'CData', color);
% 
%     % draw the points that are used for the orthogonal area
%     % orthoX = Vpts(1, :);
%     % orthoY = Vpts(2, :);
%     % orthoZ = Vpts(3, :);
%     % plot3(orthoX, orthoY, orthoZ, '+g');
% end
% 
% 
% ZP = Z;
% if get(handles.cbox_3d_myo, 'Value')
% 
%     [t z T Z] = getTZ(handles);
% 
%     rawmyo = double(imread(handles.info.myosin_file(T, Z, handles.src.myo)));
% 
%     rawmyo(rawmyo < mean(rawmyo(:)) + 2*std(rawmyo(:))) = 0;
% 
%     mnx=min(min(vertstacks(:,:,2)));
%     mxx=max(max(vertstacks(:,:,2)));
%     mny=min(min(vertstacks(:,:,1)));
%     mxy=max(max(vertstacks(:,:,1)));
%     mask=logical(rawmyo*0);
%     mask(round(mny/dx):round(mxy/dx),round(mnx/dx):round(mxx/dx),:)=1;
%     rawmyo(mask==0)=0;
% 
% 
% %     [qx,qy,vals] = find(rawmyo(:,:,i));
%     [qx,qy,vals] = find(rawmyo);
%     vals=vals/max(vals)*80;
%     nq=length(qx);
%     scatter3(qy*dx,qx*dx,max(z_points)+0*qy,vals,'sc','filled');
% %     scatter3(qy*dx,qx*dx,repmat(size(rawmyo,3)-i,nq,1)*dz,vals,'sc','filled');
%     
%     
% end
% 
% if get(handles.cbox_3d_stalk, 'Value')
%     [t z T Z] = getTZ(handles);
% 
% % hard-coded --- BAD!!!!!!!!!!!!!!!!!
%     for layer = 0:7
%     
%     
%         rawstalk = double(imread(handles.info.stalk_file(T, layer, handles.src.stalk)));
% 
%         rawstalk(rawstalk < mean(rawstalk(:)) + 3*std(rawstalk(:))) = 0;
% 
%         mnx=min(min(vertstacks(:,:,2)));
%         mxx=max(max(vertstacks(:,:,2)));
%         mny=min(min(vertstacks(:,:,1)));
%         mxy=max(max(vertstacks(:,:,1)));
%         mask=logical(rawstalk*0);
%         mask(round(mny/dx):round(mxy/dx),round(mnx/dx):round(mxx/dx),:)=1;
%         rawstalk(mask==0)=0;
% 
% 
%     %     [qx,qy,vals] = find(rawmyo(:,:,i));
%         [qx,qy,vals] = find(rawstalk);
%         vals=vals/max(vals)*80;
%         nq=length(qx);
%          scatter3(qy*dx,qx*dx, ZP(layer+1, 1)  +0*qy,vals,'sc','filled');
%     %     scatter3(qy*dx,qx*dx,repmat(size(rawmyo,3)-i,nq,1)*dz,vals,'sc','filled');
% 
%     end
%     
% end