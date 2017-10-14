classdef STFT_Plugin_Template < audioPlugin
    
    % myBasicSourcePlugin is a template for a basic source plugin. Use this
    % template to create your own basic source plugin.
    
    properties
        % Use this section to initialize properties that the end-user
        % interacts with.
        
        Width = 1;
        isAutoGain = true;
        windowSize = 2048;
        overlapRatio = 0.75;
        hopSize;
        
        inputChanNum = 2;
        outputChanNum = 2;
        
        inputBuffer;
        outputBuffer;
        
        windowFunc;
    end
    properties (Access = private)
        % Use this section to initialize properties that the end-user does
        % not interact with directly.
    end
    properties (Constant)
        PluginInterface = ...
            audioPluginInterface(...
            audioPluginParameter('Width', ...
            'Mapping', {'pow', 2, 0, 4}), ...
            audioPluginParameter(...
                'isAutoGain',...
                'DisplayName','Auto output gain'), ...
            'InputChannels',2, ...
            'OutputChannels',2, ...
            'PluginName','666666');
    end
    methods
        %------------------------------------------------------------------
        % Construct
        %------------------------------------------------------------------
        function plugin = STFT_Plugin_Template
            plugin.hopSize = floor(plugin.windowSize*(1-plugin.overlapRatio));
            plugin.inputBuffer = zeros(plugin.windowSize, plugin.inputChanNum);
            plugin.outputBuffer = zeros(plugin.windowSize, plugin.outputChanNum);
            plugin.windowFunc = repmat(hann(2048),1,plugin.inputChanNum);
        end
        
        function out = process(plugin,in)
            % This section contains instructions to produce the output
            % audio signal. Use plugin.MyProperty to access a property of
            % your plugin. Use getSamplesPerFrame(plugin) to get the frame
            % size used by the environment.
            plugin.inputBuffer = [plugin.inputBuffer(plugin.hopSize+1:end,:); in];
            
            %   process the signal here
            processedSig = midSideProcessing(plugin, plugin.windowFunc.*plugin.inputBuffer);
            
            
            plugin.outputBuffer = plugin.outputBuffer + plugin.windowFunc.*processedSig;
            out = plugin.outputBuffer(1:plugin.hopSize,:);
            plugin.outputBuffer = [plugin.outputBuffer(plugin.hopSize+1:end,:); zeros(size(in,1),plugin.outputChanNum)];
        end
        function reset(plugin)
            % This section contains instructions to reset the plugin
            % between uses, or when the environment sample rate changes.
        end
%         function set.isAutoGain(plugin, val)
%             % This section contains instructions to execute if the
%             % specified property is modified. Properties associated with
%             % parameters are updated automatically. Use the set method to
%             % execute more complicated instructions.
%         end
        
        function out = midSideProcessing(plugin, in)
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