function fid=getfile(k,parfile)
%get the matrix of phasede spectrum file and it's data head

if nargin < 1
    [fname,pathname] = uigetfile('*.*','Open Varian fid / data / phasefile');
    fname= strcat(pathname, fname);
else
    fname=k;
end

%this programm only accepts the file with name 'fid', 'data' or 'phasefile'.
if( (isequal(fname,0)==1) )
	disp('Error in open fid or data or phasefile.');
	return;
end
    

%begin read fid or spectrum
fp = fopen(fname,'r','b');

[a, count] = fread(fp, 6, 'int32');
[b, count] = fread(fp, 2, 'int16');
[c, count] = fread(fp, 1, 'int32');
if(c==0)
    c=1; % 必须有一个头
end
datafilehead = struct('nblocks',a(1),  'ntraces',a(2),'np',a(3),  'ebytes',a(4),  'tbytes',a(5),  'bbytes',a(6),  'vers_id',b(1),  'status',b(2), 'nbheaders',c(1));
clear a b c count;
BinaryStatus = fliplr(dec2bin(datafilehead.status));
if (BinaryStatus(1) == '0') % 0 = no data, 1 = data
    msgbox('No data point in file.');
    bSuccess = false;
    return;
end

if((BinaryStatus(3) == '0') & (BinaryStatus(4) == '0')) % the data is 16-bit integer
	s_databytes='int16';
elseif ((BinaryStatus(3) == '1') & (BinaryStatus(4) == '0')) % the data is 32-bit integer
	s_databytes='int32';
else
	s_databytes='float';
end
if(datafilehead.ebytes == 2)
	s_ebytes = 'int16';
else
	s_ebytes = 'int32';
end
a = zeros(datafilehead.nblocks * datafilehead.ntraces*datafilehead.np, 1);
for(ii = 1:1:datafilehead.nblocks)
    for(jj = 1:1:datafilehead.nbheaders)
        fread(fp, 14, 'int16');	%read datablockhead, 28 or 56 bytes;
    end
    [b,count] = fread(fp, datafilehead.np*datafilehead.ntraces, s_databytes);
    a((ii-1)*datafilehead.np*datafilehead.ntraces+1 : ii*datafilehead.np*datafilehead.ntraces) = b;
end
clear b count;

% recombine a[] into complex matrix data[][]
% if(BinaryStatus(5) == 1)   %complex data point
    data = zeros(datafilehead.nblocks*datafilehead.ntraces, datafilehead.np/2);
    for(ii = 1 : datafilehead.nblocks * datafilehead.ntraces)
        data(ii, 1 : (datafilehead.np/2)) = (a( ((ii-1)*datafilehead.np+1) : 2 : (ii*datafilehead.np) ) - sqrt(-1) * a(((ii-1)*datafilehead.np+2) : 2 : (ii*datafilehead.np)))';
    end
% else
%     data=zeros(datafilehead.nblocks*datafilehead.ntraces, datafilehead.np);
%     for(ii=1:datafilehead.nblocks*datafilehead.ntraces)
%         data(ii,1:datafilehead.np)=(a( ((ii-1)*datafilehead.np+1) :1 : (ii*datafilehead.np) ) )';
%     end
% end
clear a;
fclose(fp);
[curpar.nF1, curpar.np] = size(data);
if(BinaryStatus(2) == '0')  %0-fid, 1-spectrum
    fid = data';
else
    spec = data';
end
clear data;
if(BinaryStatus(2) == '1')  %0-fid, 1-spectrum
%    spec=fliplr(fftshift(fft(fid,curpar.nF2)));
%else
    fid=ifft(spec);
end
if false
    curpar=struct('filename',fname,...
          'sfrq',0,...
          'sp',0,'sp1',0,...
          'wp',0,'wp1',0,...
          'trace','',...
          'unit','Hz',...
          'nF1',0,'nF2',0,...
          'nF1_s',0,'nF1_e',0,...
          'nF2_s',0,'nF2_e',0,...
          'conlvl',zeros(1,16),...
          'max_val',0,...
          'xlim',[0 1],...
          'ylim',[0 1],...
          'projectstate',0,...
          'tracestate',0,...
          'curtrace',1,... %current trace.
          'loaded',0,...
          'shown',0);
lastIndex=findstr(fname,'\')
fp = fopen(strcat(fname,'procpar'),'rt');
if fp == -1
	fp = fopen(strcat(pathname,'curpar'),'rt');
	if fp == -1
		disp('Error:Can''t find parameter file "procpar" in data director.');
	end
end
if fp>-1
curpar.sfrq=getpara(fp,'sfrq',1);
curpar.at=getpara(fp,'at',1);
curpar.sw=getpara(fp,'sw',1);
curpar.sp=getpara(fp,'sp',1);
curpar.wp=getpara(fp,'wp',1);
curpar.sp1=getpara(fp,'sp1',1);
curpar.wp1=getpara(fp,'wp1',1);
curpar.nF2=getpara(fp,'fn',1);
curpar.trace=getpara(fp,'trace',2);
curpar.unit=getpara(fp,'axis',2);
curpar.xlim=[curpar.sp (curpar.sp + curpar.wp)];
curpar.ylim=[curpar.sp1 (curpar.sp1 + curpar.wp1)];
fclose(fp);
end

disp('Done reading binary phased spectrum file.!');
end
datafilehead
function para = getpara(fp, paraname, paratype)
%retrieve parameter
%fp - handle of parameter file 'procpar' or 'curpar'
%paraname - name of the parameter which will be retrieved
%paratype - type of parameter, 1-real, 2-string

bfound=0;
paraname = strcat(paraname, ' ');
frewind(fp);
while(feof(fp)==0)
    strTemp=fgetl(fp);
    if(strfind(strTemp, paraname) == 1)   % find paramater such as 'sw ' in the begin of line
        strTemp=fgetl(fp);
        nn = strfind(strTemp, ' ');
        n = str2num(strTemp(1 : nn(1)-1)); % get arraydim
        strTemp=strTemp(nn(1)+1 : length(strTemp));
        if(paratype == 1)       % real type parameter
            tok = regexp(strTemp, '(\S*?) ', 'tokens');
            para = zeros(1,n);
            for(ii = 1:n)
                para(ii) = str2num(cell2mat(tok{ii}));
            end
        else    % string type parameter
            if(n == 1)
                tok = regexp(strTemp, '"(.*?)"', 'tokens');
                para = tok{1};
            else    % n > 1
                para=cell(n,1);
                tok = regexp(strTemp, '"(.*?)"', 'tokens');
                para(1,1)=tok{1};
                for(ii = 2 : n-1)
                    strTemp = fgetl(fp);
                    tok = regexp(strTemp, '"(.*?)"', 'tokens');
                    para(ii,1) = tok{1};
                end
            end
        end
        bfound=1;
        break;
    end
end
if(bfound == 0)
    if(paratype == 1)
        para = 0;
    else
        para = '';
    end
end