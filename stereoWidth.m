classdef stereoWidth < audioPlugin
    properties
        Width = 1;
        isAutoGain = true;
    end
    
    properties (Constant)
        PluginInterface = ...
            audioPluginInterface(...
            audioPluginParameter('Width', ...
            'Mapping', {'pow', 2, 0, 4}), ...
            audioPluginParameter(...
                'isAutoGain',...
                'DisplayName','Auto output gain'));
    end
    
    methods
        function out = process(plugin, in)
            mid = (in(:,1) + in(:,2)) / 2;
            side = (in(:,1) - in(:,2)) / 2;
            side = side * plugin.Width;
            out = [mid + side, mid-side];
            if plugin.isAutoGain
                complementryGain = 1/(0.5+0.5*plugin.Width);
            else
                complementryGain = 1;
            end
            out = out*complementryGain;
        end
    end
end