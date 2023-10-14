classdef SimulationRunnerRapidLocal < MultiSim.internal.SimulationRunnerParallelLocal ...
        & MultiSim.internal.SimulationRunnerRapidBase

    methods
        function obj = SimulationRunnerRapidLocal( simMgr, pool )
            arguments
                simMgr( 1, 1 )Simulink.SimulationManager
                pool( 1, 1 )parallel.Pool = gcp
            end
            obj@MultiSim.internal.SimulationRunnerRapidBase( simMgr, pool );
            obj@MultiSim.internal.SimulationRunnerParallelLocal( simMgr, pool );
        end
    end

    methods ( Access = protected )
        function simInputs = setupLogging( obj, simInputs )
            nSimIn = numel( simInputs );
            for i = 1:nSimIn
                if ( simInputs( i ).isLTFSetToOn(  ) )
                    simInputs( i ) = simInputs( i ).addHiddenModelParameter( 'LoggingFileName',  ...
                        locGetFullFileName( obj.WorkingDir, simInputs( i ).getLTFName(  ) ) );
                end
            end
        end
    end
end

function fileName = locGetFullFileName( workingDir, fileName )
arguments
    workingDir char
    fileName char
end


[ pathstr, name, ext ] = fileparts( fileName );
if ~MultiSim.internal.isAbsolutePath( pathstr )
    fileName = fullfile( workingDir, pathstr, [ name, ext ] );
end
end
