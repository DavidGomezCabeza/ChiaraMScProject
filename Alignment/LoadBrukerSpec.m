function [ DataBeforePhase ] = LoadBrukerSpec(SpecOrFid)
%LOADBRUKERSPEC Summary of this function goes here
%   Detailed explanation goes here

 SpecOrFid=1;
if SpecOrFid==true
%     FileName='metabolite\nmr\Acetoacetic acid\1';
%     fname=[FileName,'/fid'];
    fname='fidBrukerSample_2';
    SizeTD1=1;
    SizeTD2=32768*2;
    ByteOrder=2;
    if (ByteOrder == 2)
        id=fopen(fname, 'r', 'l');	    		%use little endian format if asked for
    else
        id=fopen(fname, 'r', 'b');			%use big endian format by default
    end
    
    FidData=zeros(1,SizeTD1*SizeTD2);
    [FidData, count] = fread(id, SizeTD1*SizeTD2, 'int');


    
        %填零或者截取
    kk=zeros(1,64*1024-length(FidData));
    FidData=[FidData' kk];
    L=length(FidData);
    ComplexFidData=FidData(1:2:L-1)+j*FidData(2:2:L);
%     ComplexFidData=ComplexFidData(1:4*1024);

%     Sw1=29761.904;
%     nD2=length(ComplexFidData);
%     t=exp(-[0:1/Sw1:(nD2-1)/Sw1]*pi*3);
%     ComplexFidData=ComplexFidData.*t;
    
    % ComplexFidData=ComplexFidData(1:16*1024);

%     ComplexFidData=ComplexFidData(SizeTD2/2*2+1:SizeTD2/2*3);
%     ComplexFidData=ComplexFidData(1:SizeTD2/2);
%    ComplexFidData=ComplexFidData(1:2048);
    
    L=length(ComplexFidData);
    figure(1)
    plot(real(ComplexFidData))
    bOwnData=false;%如果是自己的数据需要
    SpecSw=6000.0;
    if (bOwnData==true)
        MK=importdata('Sw.txt');
        Sw=MK(:,1);
        GroupTime=MK(:,3);
        Index = find(Sw == SpecSw);
        GroupTime=GroupTime(Index);
        ShiftNum=floor(GroupTime/(120*1000000)*SpecSw);
    else
%         FileName=[FileName,'\acqus']
%         ShiftNum = DetermineBrukerDigitalFilter(FileName);
       ShiftNum=76;
    end
%   ShiftNum=60;
    ShiftNum=76;
    TempFidData=ComplexFidData(1:ShiftNum);
    
    
    ComplexFidData=[ComplexFidData(ShiftNum+1:L) TempFidData];
    
    ComplexFidData(1)=ComplexFidData(1)-3000000;
    ComplexFidData(2)=ComplexFidData(2)-5000000;
    ComplexFidData(3)=ComplexFidData(3)-6000000;
    ComplexFidData(4)=ComplexFidData(4)-8000000;
    
    DataBeforePhase=(fft(ComplexFidData'));
    DataBeforePhase=fftshift(DataBeforePhase);
    
    DataBeforePhase=DataBeforePhase';
%         figure(1)
%     plot(real(DataBeforePhase))
%     Time=GroupTime/(120*1000000);
%     a_num = -((1:L))/(L);
%     DataBeforePhase = DataBeforePhase .* exp(j*pi*2*(SpecSw*Time*a_num));
kk=real(DataBeforePhase);
    figure(2)
    plot(kk);
    
else
    fname='1r';
    SizeTD1=1;
    SizeTD2=128*1024;
    ByteOrder=2;
    if (ByteOrder == 2)
        id=fopen(fname, 'r', 'l');			%use little endian format if asked for
    else
        id=fopen(fname, 'r', 'b');			%use big endian format by default
    end
    
    RealSpecData=zeros(1,SizeTD1*SizeTD2);
    [RealSpecData, count] = fread(id, SizeTD1*SizeTD2, 'int');
    L=length(RealSpecData);
    
    fname='1i';
    if (ByteOrder == 2)
        id=fopen(fname, 'r', 'l');			%use little endian format if asked for
    else
        id=fopen(fname, 'r', 'b');			%use big endian format by default
    end 
    ImagSpecData=zeros(1,SizeTD1*SizeTD2);
    [ImagSpecData, count] = fread(id, SizeTD1*SizeTD2, 'int');
    
    a_num = -((1:L))/(L);
    DataBeforePhase=RealSpecData+j*ImagSpecData;
    DataBeforePhase=DataBeforePhase';
    figure(2)
    plot(real(DataBeforePhase));
    
end
end

