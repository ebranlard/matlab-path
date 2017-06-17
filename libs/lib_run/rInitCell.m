% This script initialize a cell content

%% Clear the command window and close figures if matlab code is run in cell mode (not whole script)
if length(dbstack())==1
  close all;
  clc;
end

% Clean variables other than VARS.KEEP
if exist('VARS','var')
    if isfield(VARS,'KEEP')
        if iscell(VARS.KEEP)
            if ~any(cellfun(@(x)(isequal(x,'VARS')),VARS.KEEP))
                warning('VARS not found in VARS.KEEP, adding it')
                VARS.KEEP{end+1}='VARS';
            end
            clearvars('-except',VARS.KEEP{:});
        end
    end
end

%%
