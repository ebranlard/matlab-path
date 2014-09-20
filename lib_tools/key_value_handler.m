function key_value_handler(varargin)
% This function is helpful to handle arguments passed of the form 'key','value' to a function.
% The programmer of a function provides a list of keys with default values, and the varargin input from the user.
% The handler will evaluate the user varargins in the workspace of the callee function and use default values 
% if the user didn't provide the key.
% The Keys are case sensiive, just like in matlab. Default values can be ommited.
% 
% Example of calls:
% function(varargin) 
% key_string={'name=MyTitle'};
% key_vector={'x=0:9','y=linspace(0,1,10)','z'}
% key_value_handler('keys_string',keys_string,'keys_vector',keys_vector, {'x',[0 1 2],'name','A Name','y',[2 3 4]} )
%
%
% E.Branlard - April 2014 
varargin

keys_values_string={};
keys_values_number={};
keys_values_vector={};
%% The key_value_handler accepts key,values arguments....
if mod(nargin,2)~=1
    error('Input should be list of:  key, values and the final argument is the user varargins')
end
for iarg=1:2:(length(varargin)-1)
    varargin{iarg}
    switch varargin{iarg} 
        case 'keys_string'
            keys_values_string=varargin{iarg+1};
        case 'keys_number'
            keys_values_number=varargin{iarg+1};
        case 'keys_vector'
            keys_values_vector=varargin{iarg+1};
        otherwise
            error('Unknown argument')
    end
end
UserInput=varargin{length(varargin)};

%% Extracting keys and default values
[keys_string,def_string]=split_default_values(keys_values_string,'string');
[keys_number,def_number]=split_default_values(keys_values_number,'number');
[keys_vector,def_vector]=split_default_values(keys_values_vector,'vector');

keys={keys_string{:},keys_number{:},keys_vector{:}};
defs={def_string{:},def_number{:},def_vector{:}};


%% Initialize each key to empty (not required)
% for ik=1:length(keys)
%     assignin('caller',lower(keys{ik}),[]);
% end

%% Evaluate each key so that it's equal to its value
key_set=UserInput{1:2:length(UserInput)};
for iarg=1:2:length(UserInput)
    if ismember(UserInput{iarg},keys)
        assignin('caller',UserInput{iarg},UserInput{iarg+1});
    else
        error('Unknown argument key')
    end
end

%% Use default for keys not set by users
key_notset=setdiff(keys,key_set);
for ik=1:length(key_notset)
    id=find(ismember(keys,key_notset(ik)));
    if id>0
        assignin('caller',keys{id},defs{id});
    end
end

end

function [keys,def]=split_default_values(kv,kind)
    keys={};
    def={};
    if ~isempty(kv)
       for i=1:length(kv)
           split=strsplit(kv{i},'=');
           keys{end+1}=split{1};
           if length(split)>1
               if isequal(kind,'string')
                   def{end+1}=split{2};
               elseif isequal(kind,'number')
                   def{end+1}=str2num(split{2});
               elseif isequal(kind,'vector')
                   def{end+1}=eval(split{2}); 
               else
                   error('unknown kind')
               end
           else
               def{end+1}=[];
           end
       end
    end
end
