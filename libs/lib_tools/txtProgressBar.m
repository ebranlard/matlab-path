function []=txtProgressBar(i_over_n)
    % display percentage of progress in command window
    % i_over_n should be between 0 and 1
    % Important: the first call should start at 0!
    %
    % Example:
    % n=300
    % txtProgressBar(0);
    % for i=1:n
    %    pause(0.01);
    %    txtProgressBar(i/n);
    %  end
    if(i_over_n==0)
        fprintf('%02d %%\n',0);
    else
        fprintf('%s%02d %%\n',char([8 8 8 8 8]),floor(100*i_over_n));
    end
end

