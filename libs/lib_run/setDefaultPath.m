function setDefaultPath
    clearPath                                                                   ; % just in case

    global PATH
    if ispc
        % Windows
        PATH.FLIB                = 'F:/fortran/_lib/windows-ia32/'                  ;
        PATH.PHDTHESIS           = 'F:/Exchange/'                                   ;
    else
        % Vortex Codes
        PATH.VL                  = '/work/libs/VortexCodes/VortexLattice/'           ;
        PATH.VL_PRESC            = '/work/libs/VortexCodes/VortexLattice_Prescribed/';
        PATH.VCYL                = '/work/libs/VortexCodes/VortexCylinders/'         ;
        PATH.VC2D                = '/work/libs/VortexCodes/VortexCode2D/'            ;
        PATH.VC2DKATZ            = '/work/libs/VortexCodes/VortexCode2D_Katz/'       ;
        PATH.VC_LIB              = '/work/libs/VortexCodes/VC_lib/'                              ;
        PATH.VC_LIB_C            = '/work/libs/VortexCodes/VC_lib/_Legacy/C/'                    ;
        PATH.VC_LIB_MAT          = '/work/libs/VortexCodes/VC_lib/_Legacy/matlab/'               ;



        % Omnivor
        PATH.FLIB                = '/work/libs/OmniVor/_src/_lib/linux-ia32/' ;
        PATH.BEAR                = '/work/libs/OmniVor/matlab/Layer4_Bear/'      ;
        PATH.COYOTE              = '/work/libs/OmniVor/matlab/Layer3_Coyote/'    ;
        PATH.RACCOON             = '/work/libs/OmniVor/matlab/Layer2_Raccoon/'   ;
        PATH.MOUFFETTE           = '/work/libs/OmniVor/matlab/Layer1_Mouffette/' ;
        PATH.CHIPMUNK            = '/work/libs/OmniVor/matlab/Layer0_Chipmunk/'  ;
        PATH.Environment         = '/work/libs/OmniVor/matlab/Environment/'      ;
        PATH.OMNIVORLINK         = '/work/libs/OmniVor/matlab/Link/'             ;
        PATH.Time                = '/work/libs/General/Time/'                                ;
        PATH.Mesh                = '/work/libs/General/Mesh/'                                ;
        PATH.SpecAn              = '/work/libs/General/SpectralAnalysis/'                    ;


        % ---   Wind Energy
        PATH.BEM                 = '/work/bins/WindEnergy/BEMCodes/BEM/'                        ;
        PATH.WTlib               = '/work/libs/WindEnergy/WTlib/'                               ;
        PATH.THEODORSEN          = '/work/libs/WindEnergy/WTTheory/Theodorsen/'                ;
        PATH.OPTIMCIRC           = '/work/libs/WindEnergy/WTTheory/OptimalCirculation/'        ;
        PATH.EXPANSION           = '/work/libs/WindEnergy/WTTheory/WakeExpansion/'             ;
        PATH.Wind                = '/work/libs/WindEnergy/Wind/'                                ; % Used to be '/work/lib/OmniVor_lib/matlab/Wind/';

        % --- Fluid MEch
        PATH.PROFILES            = '/work/libs/FluidMechanics/Profiles/'            ;
        PATH.POTFLOW             = '/work/libs/FluidMechanics/PotentialFlow/'       ;

        % Data
        PATH.TMP                 = '/work/tmp/'                                     ;
        PATH.DATA_MOVIE          = '/work/movies/'                                  ;

        PATH.DATA_IN             = '/work/data/'                                    ;
        PATH.DATA_OUT            = '/work/data/'                                    ;
        PATH.DATA_WT             = '/work/data/WT/'                                 ;

        PATH.TIPLOSSDB           = '/work/data/BEM/TipLossDB/'                      ;


        % OLD
        %PATH.PHDTHESIS           = '/work/publications/phdthesis/'                  ;


    end
