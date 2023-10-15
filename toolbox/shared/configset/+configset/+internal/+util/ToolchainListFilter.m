classdef ToolchainListFilter < coder.make.internal.ToolchainListFilter

    properties ( Access = private )
        SimulinkConfigSet
    end

    methods
        function obj = ToolchainListFilter( cs )

            arguments
                cs
            end


            obj.SimulinkConfigSet = cs;
            obj = obj.setTargetHWDeviceType( get_param( cs, 'TargetHWDeviceType' ) );
            obj = obj.setBoard( get_param( cs, 'HardwareBoard' ) );
        end

        function ret = isProductConfigurationCompatible( obj, toolchainInfoRegistry )
            arguments
                obj
                toolchainInfoRegistry( 1, 1 )coder.make.internal.IToolchainInfoRegistry
            end

            if isempty( toolchainInfoRegistry.isConfigSetCompatibleFcn )

                ret = true;
                return ;
            end

            if isempty( obj.SimulinkConfigSet )

                ret = false;
                return ;
            end

            ret = obj.evalIsConfigSetCompatibleFcn( toolchainInfoRegistry );
        end
    end

    methods ( Access = private )
        function ret = evalIsConfigSetCompatibleFcn( obj, toolchainInfoRegistry )

            arguments
                obj
                toolchainInfoRegistry( 1, 1 )coder.make.internal.IToolchainInfoRegistry
            end


            try
                ret = toolchainInfoRegistry.isConfigSetCompatibleFcn( obj.SimulinkConfigSet );
            catch e
                ret = false;
                warning( message( 'RTW:targetRegistry:badIsConfigSetCompatibleFcnWarning',  ...
                    toolchainInfoRegistry.ConfigName,  ...
                    e.getReport( 'basic' ) ) );
            end
        end
    end
end


