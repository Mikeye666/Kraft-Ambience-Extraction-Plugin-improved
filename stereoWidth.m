classdef stereoWidth < audioPlugin
    properties
        Width = 0.5;
        isAutoGain = true;
    end
    
    properties (Constant)
        PluginInterface = ...
            audioPluginInterface(...
            audioPluginParameter('Width', ...
            'Mapping', {'lin' 0, 1}));
    end
    
    methods
        function out = process(plugin, in)
            out = midSideProcessing(plugin, in);
        end
        
        function out = midSideProcessing(plugin, in)
            mid = (in(:,1) + in(:,2)) / 2;
            side = (in(:,1) - in(:,2)) / 2;
            mid = mid * (1-plugin.Width)* 2;
            side = side * plugin.Width * 2;
            out = [mid + side, mid-side];
        end
    end
    

end