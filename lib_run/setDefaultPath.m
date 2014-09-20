function setDefaultPath
clearPath; %just in case

global PATH
if ispc
    % Windows
    PATH.FLIB    = 'F:/fortran/_lib/windows-ia32/';
    PATH.PHDTHESIS='F:/Exchange/';
else
    PATH.BEM        = '/work/bin/BEMCodes/BEM/'                        ; 
    PATH.VL         = '/work/bin/VortexCodes/VortexLattice/'           ; 
    PATH.VL_PRESC   = '/work/bin/VortexCodes/VortexLattice_Prescribed/';
    PATH.VCYL       = '/work/bin/VortexCodes/VortexCylinders/'           ; 
    PATH.VC2D       = '/work/bin/VortexCodes/VortexCode2D/'            ; 
    PATH.VC2DKATZ   = '/work/bin/VortexCodes/VortexCode2D_Katz/'       ; 

    PATH.VC_LIB_C   = '/work/lib/VC_lib/C/'                            ; 
    PATH.VC_LIB_MAT = '/work/lib/VC_lib/matlab/'                       ; 

    PATH.FLIB       = '/work/lib/OmniVor_lib/fortran/_lib/linux-ia32/' ; 


    PATH.BEAR       ='/work/lib/OmniVor_lib/matlab/Layer4_Bear/';
    PATH.COYOTE     ='/work/lib/OmniVor_lib/matlab/Layer3_Coyote/';
    PATH.RACCOON    ='/work/lib/OmniVor_lib/matlab/Layer2_Raccoon/';
    PATH.MOUFFETTE  ='/work/lib/OmniVor_lib/matlab/Layer1_Mouffette/';
    PATH.CHIPMUNK   ='/work/lib/OmniVor_lib/matlab/Layer0_Chipmunk/';
    PATH.Wind       ='/work/lib/OmniVor_lib/matlab/Wind/';
    PATH.Environment='/work/lib/OmniVor_lib/matlab/Environment/';
    PATH.OMNIVORLINK='/work/lib/OmniVor_lib/matlab/Link/';


    PATH.WTlib='/work/lib/WTlib/';



    PATH.THEODORSEN ='/work/lib/WTTheory/Theodorsen/';
    PATH.OPTIMCIRC  ='/work/lib/WTTheory/OptimalCirculation/';
    PATH.EXPANSION  ='/work/lib/WTTheory/WakeExpansion/';

    %% Fluid MEch
    PATH.PROFILES   ='/work/lib/FluidMechanics/Profiles/';
    PATH.POTFLOW    ='/work/lib/FluidMechanics/PotentialFlow/';


    %% Data
    PATH.TMP='/work/tmp/';
    PATH.DATA_MOVIE='/work/movies/';

    PATH.DATA_IN    ='/work/data/';
    PATH.DATA_OUT   ='/work/data/';
    PATH.DATA_WT    ='/work/data/WT/';
    
    PATH.TIPLOSSDB  ='/work/data/BEM/TipLossDB/';


    PATH.PHDTHESIS='/work/publications/phdthesis/';


end
