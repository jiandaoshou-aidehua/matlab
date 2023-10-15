classdef EventController < rfpcb.internal.apps.transmissionLineDesigner.controller.Controller





    methods
        function obj = EventController( Model, App )


            arguments
                Model( 1, 1 )rfpcb.internal.apps.transmissionLineDesigner.model.AppModel{ mustBeNonempty } = rfpcb.internal.apps.transmissionLineDesigner.model.AppModel;
                App( 1, 1 )rfpcb.internal.apps.transmissionLineDesigner.view.AppView{ mustBeNonempty } = rfpcb.internal.apps.transmissionLineDesigner.view.AppView;
            end
            obj@rfpcb.internal.apps.transmissionLineDesigner.controller.Controller( Model, App );

            log( obj.Model.Logger, '% EventController is created.' )
        end


        function onModelChange( obj, src, evt )


            arguments
                obj
                src = [  ];
                evt( 1, 1 )event.PropertyEvent = [  ];
            end

            if ~obj.Model.AppLoading
                update( obj.Model, src.Name );
                sync( obj.App );
                update( obj.App, src.Name );
            end
        end


        function onError( obj, src, evt )

            arguments
                obj
                src = [  ];
                evt = [  ];
            end

            error( obj.App, evt.Data );
        end


        function onAppState( obj, src, evt )



            arguments
                obj
                src( 1, 1 )rfpcb.internal.apps.transmissionLineDesigner.model.AppModel = [  ];%#ok<INUSA>
                evt( 1, 1 )event.EventData = [  ];
            end


            update( obj.App, evt.EventName );
        end
    end
end


