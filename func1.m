clc;
clear;
close all;
mat=[0,10,15;11,0,14;12,13,0];
tr=0.333;
out1=mat;
if ~(numel (mat(1,:))==numel (mat(:,1)))
    error("the number of elements in rows and culoms is not equal")
end

for i=1:numel (mat(1,:))
    if ~(mat(i,i)==0)
        error('the elemet of input(%d,%d) is not 0',i,i);
    end
end
usabale_data=zeros(numel(mat(1,:))*(numel(mat(1,:))-1),1);
udc=1;
for i=1:numel (mat(1,:))
    for j=1:numel (mat(1,:))
        if i==j
         continue
        else 
            usabale_data(udc)=mat(i,j);
            udc=udc+1;
        end

    end
end

norm=(usabale_data-(min(usabale_data)))/((max(usabale_data))-(min(usabale_data)));

%%first tereshhold
zeross=norm((0<=norm) & (norm<=0.15) );
oness=norm((0.85<=norm) & (norm<=1));
pot0=sort(norm((0.15<norm) & (norm<=0.3) ));
pot1=sort(norm((0.7<=norm) & (norm<0.85) ));
i1=numel(oness);
i0=numel(zeross);
p1=numel(pot1);
p0=numel(pot0);
make_1=0;
make_0=0;
ftr=0;
need1=0;
need0=0;
ftr=i1/(numel(mat(:,1))*(numel(mat(:,1))-1));
if tr>ftr 
 make_1=1;
 else
  make_0=1;
end
if make_1
    need1=round((tr-ftr)*numel(mat(1,:))*(numel(mat(1,:))-1));
    if need1>p1
       error("its impossible to reach this treshold");
    else
        for i=1:need1
            norm(find(norm==pot1(i),1))=0.85;
        end
    end


end
if make_0
    need0=round((ftr-tr)*numel(mat)*(numel(mat)-1));
    if need0>p0
       error("its impossible to reach this treshold");
    else 
        for i=1:need0
            norm(find(norm==pot0(i),1))=0.15;
        end
    end
    
end
oc=1;
denorm=((max(usabale_data)-min(usabale_data))*norm) + min(usabale_data);
for i=1:numel (mat(1,:))
    for j=1:numel (mat(1,:))
        if i~=j
         out1(i,j)=norm(oc);
           out2(i,j)=denorm(oc);
            oc=oc+1;
        
          
        end

    end
end



