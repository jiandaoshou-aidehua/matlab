function prevState = enableIncrementalExport( state )

arguments
    state logical = logical.empty(  );
end

mlock;
persistent WEBVIEW_INCREMENTAL_EXPORT

if isempty( WEBVIEW_INCREMENTAL_EXPORT )
    env = getenv( "WEBVIEW_INCREMENTAL_EXPORT" );

    WEBVIEW_INCREMENTAL_EXPORT = isempty( env ) || ( strcmpi( env, "on" ) || strcmpi( env, "1" ) );
end

prevState = WEBVIEW_INCREMENTAL_EXPORT;

if ~isempty( state )
    WEBVIEW_INCREMENTAL_EXPORT = state;
end
end


