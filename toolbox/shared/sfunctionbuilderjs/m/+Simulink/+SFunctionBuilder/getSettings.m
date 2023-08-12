function settings = getSettings( blockHandle )




R36
blockHandle
end 

blockHandle = Simulink.SFunctionBuilder.internal.verifyBlockHandle( blockHandle );

AppData = Simulink.SFunctionBuilder.internal.getApplicationData( blockHandle );
settings = struct(  ...
'NumberDiscreteStates', AppData.SfunWizardData.NumberOfDiscreteStates,  ...
'DiscreteStatesIC', AppData.SfunWizardData.DiscreteStatesIC,  ...
'NumberContinuousStates', AppData.SfunWizardData.NumberOfContinuousStates,  ...
'ContinuousStatesIC', AppData.SfunWizardData.ContinuousStatesIC,  ...
'ArrayLayout', AppData.SfunWizardData.Majority,  ...
'SampleMode', AppData.SfunWizardData.SampleMode,  ...
'SampleTime', AppData.SfunWizardData.SampleTime,  ...
'NumberOfPWorks', AppData.SfunWizardData.NumberOfPWorks,  ...
'UseSimStruct', AppData.SfunWizardData.UseSimStruct,  ...
'DirectFeedthrough', AppData.SfunWizardData.DirectFeedThrough,  ...
'MultiInstanceSupport', AppData.SfunWizardData.SupportForEach,  ...
'MultiThreadSupport', AppData.SfunWizardData.EnableMultiThread,  ...
'CodeReuseSupport', AppData.SfunWizardData.EnableCodeReuse );
end 

% Decoded using De-pcode utility v1.2 from file /tmp/tmp93geAI.p.
% Please follow local copyright laws when handling this file.
