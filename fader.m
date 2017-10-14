classdef fader < audioPlugin
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Gain = 1;
    end
    
    properties (Constant)
        PluginInterface = audioPluginInterface(...
                          audioPluginParameter(...
                          'Gain', 'Mapping', {'log', 0.001, 2}));
    end
    
    methods
        function out = process(plugin, in)
            out = in*plugin.Gain;
        end
    end
    
end

