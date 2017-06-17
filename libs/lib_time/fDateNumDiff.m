function dt=fDateNumDiff(t2,t1)
% takes two datenums and returns the difference in seconds
dt=etime(datevec(t2),datevec(t1));
