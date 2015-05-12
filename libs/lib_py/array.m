% ARRAY Class to format matrices for easy copy and pasting to python

% Copyright (c) 2009, Robin Ince
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without 
% modification, are permitted provided that the following conditions are 
% met:
% 
%     * Redistributions of source code must retain the above copyright 
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright 
%       notice, this list of conditions and the following disclaimer in 
%       the documentation and/or other materials provided with the distribution
%       
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
% POSSIBILITY OF SUCH DAMAGE.


classdef array < double
    properties
        format = '%.15e'
    end % properties
    
    methods
        function A = array(X, format)
            A = A@double(X);
            if nargin > 1
                A.format = format;
            end
        end % constructor
           
        function display(A)
            disp([inputname(1) ' =']);
            fprintf(1,'\n');
            fprintf(1,'array(');
            A.recurse_dims(double(A),1,1,1);
            fprintf(1,')\n\n'); % close array
        end % display
        
        function recurse_dims(A,x,depth,first,last)
            if first(end) ~= 1 
                % indent if not the first one of this dimension
                st = '';
                st(1:depth-1) = ' ';
                fprintf(1,['      ' st])
            end
            fprintf(1,'[') % open dimension
            if ndims(x) > 2
                s = size(x);
                for i=1:s(1)
                    newx = squeeze(x(i,:,:,:,:,:,:,:,:,:,:));
                    f = 0;
                    l = 0;
                    if i==s(1)
                        l=1;
                    end
                    if i==1
                        f=1;
                    end
                    A.recurse_dims(newx,depth+1,[first f],[last l]);
                end
            else
                s = size(x);
                for i=1:s(1)
                    st = '';
                    if i~=1
                        st(1:depth) = ' ';
                        fprintf(1,['      ' st])
                    end

                    if s(2)==1
                        fprintf(1,['[' A.format ']'],x(i,1))
                    else
                        fprintf(1,'[')
                        fprintf(1,[A.format ', '],x(i,1:end-1))
                        fprintf(1,[A.format ']'],x(i,end))
                    end
                    if i~=s(1)
                        fprintf(1,',\n');
                    end
                end
            end
            if last(end)==1
                fprintf(1,']')
            else
                fprintf(1,'],\n\n')
            end              
        end % recurse_dims
        
    end % methods
end

