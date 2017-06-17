NOTE: this folder contains generic tools, tools that are field dependent should not be place in here

# --------------------------------------------------------------------------------}
# --- Folder content 
# --------------------------------------------------------------------------------{
# The different folders and their intended content is given below

lib_Angle: Angle manipulation functions

lib_Logics: Logic functions, manipulating booleans
 - E.g. getting intervals, given a vector saying whether we are in an interval or not

lib_Run: Tools useful to run of matlab scripts
 - Timing of matlab scripts
 - Closing figures when a cell is run standalone only
 - Saving matlab script name
 - Managing matlab paths
 - Managing matlab variables (loading them, comparing them)


lib_System: System tools
 - Access file system
 - Info about system
 - Execute commands 

lib_String: String tools
 
lib_Time: Time manipulation functions
- NOTE: ftic ftoc is not part of this




# --------------------------------------------------------------------------------}
# --- Naming conventions
# --------------------------------------------------------------------------------{
Naming conventions:
 - The letter "f" is used in front of functions to mark that they are functions, and not class or main matlab scripts. It also helps distinguish with builtin matlab functions

 - When a builting matlab function is slightly adjusted, the name and case of the matlab function is kept, and a "f" is prepended, e.g. "dir" becomes "fdir", "tic", becomes "ftic". This also applies to matlab functions which are not available from one version to another, like "pad". The function "fpad" is there to mimic the implementation of "pad", for versions of matlab where pad is not available.

 - Other functions uses the CameCase convention, e.g. using capital letters for each naming components. The function "fPrettyTime" is an example.
