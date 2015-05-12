function [ Path ] = FindFigsUp()
    startfolder=pwd;
    pattern='figsdump';
    depthlim=5;
    newson='';
    Path='';
    PathDotDot='';
    cpt=0;
    while( isempty(Path) && cpt<5)
        [R D]=FindFigsUp('.',pattern,0,depthlim,newson);
        [startIndex, endIndex, tokIndex, matchStr, tokenStr, exprNames, splitStrR]=regexp(R,'!');
        [startIndex, endIndex, tokIndex, matchStr, tokenStr, exprNames, splitStrD]=regexp(D,'!');
        Path=FindFigsInterpreter( splitStrR , splitStrD );

        [startIndex, endIndex, tokIndex, matchStr, tokenStr, exprNames, splitStr]=regexp(pwd,'[\\//]');
        newson=splitStr{end};
        cpt=cpt+1;
        cd('../');
        if(isempty(Path))
            PathDotDot=strcat(PathDotDot,'../');
        end
    end
    cd(startfolder);
    Path=strcat(PathDotDot,Path,'/');
end

