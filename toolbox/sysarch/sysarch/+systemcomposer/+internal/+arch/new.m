function app = new( name, version, modelType )

arguments
    name = 'untitled_arch'
    version = 1
    modelType{ mustBeMember( modelType, { 'Model', 'Subsystem' } ) } = 'Model'
end

systemcomposer.internal.arch.feature( 'on', version );

try
    if strcmp( modelType, 'Model' )
        bdH = new_system( name, 'Architecture' );
    else
        bdH = new_system( name, 'Subsystem', 'SimulinkSubDomain', 'Architecture' );
    end
catch ME
    if strcmpi( ME.identifier, 'Simulink:LoadSave:InvalidBlockDiagramName' )


        error( 'SystemArchitecture:LoadSave:InvalidArchName',  ...
            'Invalid architecture name' );
    else
        rethrow( ME );
    end
end

app = Simulink.SystemArchitecture.internal.ApplicationManager.getAppMgrFromBDHandle( bdH );

