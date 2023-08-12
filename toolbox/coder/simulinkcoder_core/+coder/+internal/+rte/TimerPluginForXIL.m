function TimerPluginForXIL( codeDescriptor, impFolder, buildInfo )





R36
codeDescriptor( 1, 1 )coder.codedescriptor.CodeDescriptor
impFolder( 1, : )char
buildInfo( 1, 1 )RTW.BuildInfo
end 

assert( isfolder( impFolder ) );

pluginContext = coder.internal.rte.PluginContext.XIL;
implementationFilename = coder.internal.rte.util.TimerFilenameForXIL;
privateHeaderFilename = 'rte_private_timer.h';
tObj = coder.internal.rte.TimingServiceGenerator(  ...
pluginContext, implementationFilename, privateHeaderFilename, impFolder );
tObj.generateRTEImplementation( codeDescriptor );





buildInfo.addIncludePaths( impFolder );
buildInfo.addSourceFiles( fullfile( impFolder, implementationFilename ) );
end 

% Decoded using De-pcode utility v1.2 from file /tmp/tmprSqC7S.p.
% Please follow local copyright laws when handling this file.
