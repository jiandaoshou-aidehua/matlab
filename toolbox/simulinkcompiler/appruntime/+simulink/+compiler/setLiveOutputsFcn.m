function in = setLiveOutputsFcn( in, callback )

arguments
    in( 1, 1 )Simulink.SimulationInput
    callback( 1, 1 )function_handle
end

product = "Simulink_Compiler";
[ status, msg ] = builtin( 'license', 'checkout', product );
if ~status
    product = extractBetween( msg, 'Cannot find a license for ', '.' );
    if ~isempty( product )
        error( message( 'simulinkcompiler:build:LicenseCheckoutError', product{ 1 } ) );
    end
    error( msg );
end

if ~slfeature( 'EnableLiveOutputs' )
    error( 'Invalid usage' );
end

in.ExperimentalProperties.RapidAccelLiveOutputsFcn = callback;

end

