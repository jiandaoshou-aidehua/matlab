function definition = makeDefinitionForThreeWay( theirs, base, mine, options )

arguments
    theirs{ mustBeTextScalar }
    base{ mustBeTextScalar }
    mine{ mustBeTextScalar }
    options{ mustBeA( options, 'comparisons.internal.ThreeWayOptions' ) }
end

if isa( options.MergeConfig, class( comparisons.internal.merge.MergeIntoTarget.empty(  ) ) )
    definition = makeMergeIntoTargetDefiniton( theirs, base, mine, options );
else
    throwUnexpectedConfigError( class( options.MergeConfig ) );
end
end

function throwUnexpectedConfigError( configName )
error( 'MakeDefinitionForThreeWay:UnexpectedConfig', [ 'Unexpected config: ', configName ] );
end

function definition = makeMergeIntoTargetDefiniton( theirs, base, mine, options )
builder = comparisons.internal.dispatcherutil.MergeIntoTargetDefinitionBuilder(  );

builder.setTheirs( theirs );
builder.setBase( base );
builder.setMine( mine );
builder.setType( options.Type );
builder.setConfig( options.MergeConfig );

definition = builder.build(  );
end


