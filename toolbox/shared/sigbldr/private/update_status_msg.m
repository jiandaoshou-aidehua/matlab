function update_status_msg( UD, dynamicMode )






persistent index outMsgs

if isempty( index )
outMsgs = {  ...
getString( message( 'sigbldr_ui:update_status_msg:SelectSignal' ) ) ...
, getString( message( 'sigbldr_ui:update_status_msg:AdjustT' ) ) ...
, getString( message( 'sigbldr_ui:update_status_msg:SelectPoint' ) ) ...
, getString( message( 'sigbldr_ui:update_status_msg:DragPointY' ) ) ...
, getString( message( 'sigbldr_ui:update_status_msg:DragSegmentY' ) ) ...
, getString( message( 'sigbldr_ui:update_status_msg:DragSegmentT' ) ) ...
, getString( message( 'sigbldr_ui:update_status_msg:CoordPoint' ) ) ...
, getString( message( 'sigbldr_ui:update_status_msg:CoordSegment' ) ) ...
, getString( message( 'sigbldr_ui:update_status_msg:ZoomT' ) ) ...
, getString( message( 'sigbldr_ui:update_status_msg:ZoomY' ) ) ...
, getString( message( 'sigbldr_ui:update_status_msg:ZoomTY' ) ) ...
, getString( message( 'sigbldr_ui:update_status_msg:DragPointT' ) ) ...
, getString( message( 'sigbldr_ui:update_status_msg:ButtonDownAddPoint' ) ) ...
, getString( message( 'sigbldr_ui:update_status_msg:AdjustPointY' ) ) ...
, getString( message( 'sigbldr_ui:update_status_msg:AdjustPointT' ) ) ...
, getString( message( 'sigbldr_ui:update_status_msg:AdjustSegmentY' ) ) ...
, getString( message( 'sigbldr_ui:update_status_msg:AdjustSegmentT' ) ) ...
, getString( message( 'sigbldr_ui:update_status_msg:AddNewPoint' ) ) ...
 };
index = 1;
set( UD.hgCtrls.status.msgText, 'String', outMsgs{ index } );
end 

if nargin > 1
if dynamicMode ~= index
index = dynamicMode;
set( UD.hgCtrls.status.msgText, 'String', outMsgs{ dynamicMode } );
end 
elseif ( UD.current.mode ~= index )
index = UD.current.mode;
set( UD.hgCtrls.status.msgText, 'String', outMsgs{ index } );
end 

% Decoded using De-pcode utility v1.2 from file /tmp/tmpjMAgiT.p.
% Please follow local copyright laws when handling this file.
