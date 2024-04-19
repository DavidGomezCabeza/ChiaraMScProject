function  [fid, SizeTD2, SizeTD1]= GetFIdFromBidary(fname, SizeTD2, SizeTD1, ByteOrder)
%UNTITLED1 Summary of this function goes here
%  Detailed explanation goes here
if (ByteOrder == 2)
    id=fopen(fname, 'r', 'l');			%use little endian format if asked for
else
    id=fopen(fname, 'r', 'b');			%use big endian format by default
end
a = zeros(SizeTD2*SizeTD1, 1);
[a, count] = fread(id, SizeTD2*SizeTD1, 'int32');

for tel=1:SizeTD1
    fid(tel, 1:(SizeTD2/2)) = (a((tel-1)*SizeTD2 + (1 : 2 : SizeTD2-1)) + sqrt(-1)*a((tel-1)*SizeTD2 + (2 : 2 : SizeTD2))).';
end

fclose(id);
% figure(1)
% for i=1:SizeTD1
%     subplot(1,SizeTD1,i); plot(real(fid(i,:)));
% end
% 
% for i=1:SizeTD1
%     Spec(i,:)=fftshift(fft(fid(i,:)));
% end
% 
% figure(2)
% for i=1:6
%     subplot(1,6,i); plot(abs(Spec(10+i,:)));
% end
% 
% figure(3)
% for i=1:SizeTD1
%     subplot(1,SizeTD1,i); plot(real(Spec(i,:)));
% end