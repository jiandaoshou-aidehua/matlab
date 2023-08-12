function config = slTearOffConfig(  )



































config = [ 
struct( 'blockType', 'Goto',  ...
'blockParams', [  ],  ...
'complBlockPath', 'simulink/Signal Routing/From',  ...
'copyHandler', @handleCopyGotoFromBlock,  ...
'shapeType', 'rightArrow' ),  ...
 ...
struct( 'blockType', 'From',  ...
'blockParams', [  ],  ...
'complBlockPath', 'simulink/Signal Routing/Goto',  ...
'copyHandler', @handleCopyGotoFromBlock,  ...
'shapeType', 'leftArrow' ),  ...
 ...
struct( 'blockType', 'DataStoreRead',  ...
'blockParams', [  ],  ...
'complBlockPath', 'simulink/Signal Routing/Data Store Write',  ...
'copyHandler', @handleCopyDataStoreBlock,  ...
'shapeType', 'leftArrow' ),  ...
 ...
struct( 'blockType', 'DataStoreWrite',  ...
'blockParams', [  ],  ...
'complBlockPath', 'simulink/Signal Routing/Data Store Read',  ...
'copyHandler', @handleCopyDataStoreBlock,  ...
'shapeType', 'rightArrow' ),  ...
 ...
struct( 'blockType', 'DataStoreMemory',  ...
'blockParams', [  ],  ...
'complBlockPath', 'simulink/Signal Routing/Data Store Read',  ...
'copyHandler', @handleCopyDataStoreBlock,  ...
'shapeType', 'rightArrow' ),  ...
 ...
struct( 'blockType', 'DataStoreMemory',  ...
'blockParams', [  ],  ...
'complBlockPath', 'simulink/Signal Routing/Data Store Write',  ...
'copyHandler', @handleCopyDataStoreBlock,  ...
'shapeType', 'leftArrow' ),  ...
 ...
struct( 'blockType', 'MessageQueueReader',  ...
'blockParams', [  ],  ...
'complBlockPath', 'messageslib/Message Queue Writer',  ...
'copyHandler', @handleCopyMessageQueueBlock,  ...
'shapeType', 'leftArrow' ),  ...
 ...
struct( 'blockType', 'MessageQueueWriter',  ...
'blockParams', [  ],  ...
'complBlockPath', 'messageslib/Message Queue Reader',  ...
'copyHandler', @handleCopyMessageQueueBlock,  ...
'shapeType', 'rightArrow' ),  ...
 ...
struct( 'blockType', 'MessageQueue',  ...
'blockParams', [  ],  ...
'complBlockPath', 'messageslib/Message Queue Reader',  ...
'copyHandler', @handleCopyMessageQueueBlock,  ...
'shapeType', 'rightArrow' ),  ...
 ...
struct( 'blockType', 'MessageQueue',  ...
'blockParams', [  ],  ...
'complBlockPath', 'messageslib/Message Queue Writer',  ...
'copyHandler', @handleCopyMessageQueueBlock,  ...
'shapeType', 'leftArrow' ),  ...
 ...
struct( 'blockType', 'SubSystem',  ...
'blockParams',  ...
struct( 'name', 'IsSimulinkFunction',  ...
'value', 'on' ),  ...
'complBlockPath', 'simulink/User-Defined Functions/Function Caller',  ...
'copyHandler', @handleCopySimulinkFunctionBlock,  ...
'shapeType', 'rightArrow' ),  ...
 ...
struct( 'blockType', 'ModelMask',  ...
'blockParams', [  ],  ...
'complBlockPath', 'simulink/Ports & Subsystems/Model',  ...
'copyHandler', @handleCopyModelMaskBlock,  ...
'shapeType', 'rightArrow' ),  ...
 ...
struct( 'blockType', 'VariantSource',  ...
'blockParams',  ...
struct( 'name', 'Mask',  ...
'value', 'off' ),  ...
'complBlockPath', 'simulink/Signal Routing/Variant Sink',  ...
'copyHandler', @handleCopyInlineVariantBlock,  ...
'shapeType', 'upArrow' ),  ...
 ...
struct( 'blockType', 'VariantSink',  ...
'blockParams',  ...
struct( 'name', 'Mask',  ...
'value', 'off' ),  ...
'complBlockPath', 'simulink/Signal Routing/Variant Source',  ...
'copyHandler', @handleCopyInlineVariantBlock,  ...
'shapeType', 'upArrow' ),  ...
struct( 'blockType', 'VariantPMConnector',  ...
'blockParams',  ...
struct( 'name', 'ConnectorBlkType',  ...
'value', 'Primary' ),  ...
'complBlockPath', 'nesl_utility/Variant Connector',  ...
'copyHandler', @handleCopyVariantConnectorBlock,  ...
'shapeType', 'upArrow' ),  ...
struct( 'blockType', 'VariantPMConnector',  ...
'blockParams',  ...
struct( 'name', 'ConnectorBlkType',  ...
'value', 'Nonprimary' ),  ...
'complBlockPath', 'nesl_utility/Variant Connector',  ...
'copyHandler', @handleCopyVariantConnectorBlock,  ...
'shapeType', 'upArrow' )
 ];

end 


function copyCommonParams( supportedBlock, complBlock )

set_param( complBlock, 'FontAngle', get_param( supportedBlock, 'FontAngle' ) );
set_param( complBlock, 'FontName', get_param( supportedBlock, 'FontName' ) );
set_param( complBlock, 'FontSize', get_param( supportedBlock, 'FontSize' ) );
set_param( complBlock, 'FontWeight', get_param( supportedBlock, 'FontWeight' ) );
set_param( complBlock, 'BackgroundColor', get_param( supportedBlock, 'BackgroundColor' ) );
set_param( complBlock, 'ForegroundColor', get_param( supportedBlock, 'ForegroundColor' ) );
set_param( complBlock, 'DropShadow', get_param( supportedBlock, 'DropShadow' ) );
set_param( complBlock, 'ShowName', get_param( supportedBlock, 'ShowName' ) );
end 


function copyGeometry( supportedBlock, complBlock )
spos = get_param( supportedBlock, 'Position' );
width = spos( 3 ) - spos( 1 );
height = spos( 4 ) - spos( 2 );
dpos = get_param( complBlock, 'Position' );
cx = ( dpos( 1 ) + dpos( 3 ) ) / 2;
cy = ( dpos( 2 ) + dpos( 4 ) ) / 2;
dpos( 1 ) = cx - width / 2;
dpos( 2 ) = cy - height / 2;
dpos( 3 ) = dpos( 1 ) + width;
dpos( 4 ) = dpos( 2 ) + height;
set_param( complBlock, 'Position', dpos );
end 


function handleCopyGotoFromBlock( supportedBlock, complBlock )
copyCommonParams( supportedBlock, complBlock );
copyGeometry( supportedBlock, complBlock );
set_param( complBlock, 'GotoTag', get_param( supportedBlock, 'GotoTag' ) );
end 


function handleCopyDataStoreBlock( supportedBlock, complBlock )
copyCommonParams( supportedBlock, complBlock );
set_param( complBlock, 'DataStoreName', get_param( supportedBlock, 'DataStoreName' ) );
end 


function handleCopyMessageQueueBlock( supportedBlock, complBlock )
copyCommonParams( supportedBlock, complBlock );
set_param( complBlock, 'QueueName', get_param( supportedBlock, 'QueueName' ) );
end 


function handleCopySimulinkFunctionBlock( supportedBlock, complBlock )
copyCommonParams( supportedBlock, complBlock );
fcnPrototype = get_param( supportedBlock, 'FunctionPrototype' );
parentPath = get_param( supportedBlock, 'Parent' );
nameIdx = strfind( parentPath, '/' );
argIdx = strfind( fcnPrototype, '(' );
startIdx = strfind( fcnPrototype, '=' );

trigPort = find_system( supportedBlock,  ...
'FollowLinks', 'on', 'SearchDepth', 1, 'BlockType', 'TriggerPort' );
isScoped = strcmp( get_param( trigPort, 'FunctionVisibility' ), 'scoped' );
if isempty( startIdx )
startIdx = 0;
end 
fcnName = strtrim( fcnPrototype( startIdx + 1:argIdx - 1 ) );
if isempty( nameIdx ) || ~isScoped
parentName = '';
else 
parentName = [ parentPath( nameIdx( end  ) + 1:end  ), '.' ];
end 
fcnPrototype = [ fcnPrototype( 1:startIdx ), parentName, fcnName,  ...
fcnPrototype( argIdx:end  ) ];
set_param( complBlock, 'FunctionPrototype', fcnPrototype );
end 

function handleCopyModelMaskBlock( supportedBlock, complBlock )
copyCommonParams( supportedBlock, complBlock );
set_param( complBlock, 'ModelName', get_param( bdroot( supportedBlock ), 'Name' ) );
end 

function handleCopyInlineVariantBlock( supportedBlock, complBlock )
copyCommonParams( supportedBlock, complBlock );

varCtrls = get_param( supportedBlock, 'VariantControls' );

azvc = get_param( supportedBlock, 'AllowZeroVariantControls' );

vcMode = get_param( supportedBlock, 'VariantControlMode' );

showCond = get_param( supportedBlock, 'ShowConditionOnBlock' );

VAT = get_param( supportedBlock, 'VariantActivationTime' );


set_param( complBlock, 'AllowZeroVariantControls', azvc );
set_param( complBlock, 'VariantControlMode', vcMode );
set_param( complBlock, 'VariantControls', varCtrls );
set_param( complBlock, 'ShowConditionOnBlock', showCond );
set_param( complBlock, 'VariantActivationTime', VAT );
end 

function handleCopyVariantConnectorBlock( supportedBlock, complBlock )
copyCommonParams( supportedBlock, complBlock );

if ( strcmp( get_param( supportedBlock, 'ConnectorBlkType' ), 'Primary' ) )

set_param( complBlock, 'ConnectorBlkType', 'Nonprimary' );


else 

set_param( complBlock, 'ConnectorBlkType', 'Primary' );
end 

set_param( complBlock, 'ConnectorTag', get_param( supportedBlock, 'ConnectorTag' ) );
end 



% Decoded using De-pcode utility v1.2 from file /tmp/tmpNZOpef.p.
% Please follow local copyright laws when handling this file.
