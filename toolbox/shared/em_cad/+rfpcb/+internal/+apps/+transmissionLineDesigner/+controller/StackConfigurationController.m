classdef StackConfigurationController < rfpcb.internal.apps.transmissionLineDesigner.controller.Controller

    methods
        function obj = StackConfigurationController( Model, App )


            arguments
                Model( 1, 1 )rfpcb.internal.apps.transmissionLineDesigner.model.AppModel{ mustBeNonempty } = rfpcb.internal.apps.transmissionLineDesigner.model.AppModel;
                App( 1, 1 )rfpcb.internal.apps.transmissionLineDesigner.view.AppView{ mustBeNonempty } = rfpcb.internal.apps.transmissionLineDesigner.view.AppView;
            end
            obj@rfpcb.internal.apps.transmissionLineDesigner.controller.Controller( Model, App );

            log( obj.Model.Logger, '% StackConfigurationController is created.' )
        end

        function process( obj, src, evt )


            arguments
                obj( 1, 1 )rfpcb.internal.apps.transmissionLineDesigner.controller.StackConfigurationController{ mustBeNonempty };
                src = [  ];%#ok<INUSA>
                evt = [  ];%#ok<INUSA>
            end


            log( obj.Model.Logger, '% Stack configuration selected.' );
        end
    end
end

