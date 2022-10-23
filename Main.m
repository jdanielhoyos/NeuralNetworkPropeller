clear all
clc
close all


name = [];
dinfo = dir('Data\*geom*.txt');
for K = 1 : length(dinfo)
    Distr = [];
    TF = [];
    Inputs = [];
    Outputs = [];
    T = readtable(strcat('Data\',dinfo(K).name));
    Distr(:,[1:3]) = T{:,:};
    pchord = polyfit(Distr(:,1),Distr(:,2),3);
    ppitch = polyfit(Distr(:,1),Distr(:,3),4);
    Inputs(1,[1:9]) = [pchord, ppitch];   %First 1-4 coeff, the polynomial coeff of chord, 5-9 coeff pitch vs r/R
    guion = strfind(dinfo(K).name,'_');
    por = strfind(dinfo(K).name,'x');
    if length(por)<2        %if there just the x from .txt, continue
        continue
    end
    radius(K) = str2num(dinfo(K).name(guion(1)+1:por(1)-1))/2;  
    radius(K) = radius(K)/39.37;       %From inch to m
    if radius(K)>0.4
        continue
    end
    Inputs(1,10) = radius(K);   %10 is the total radius R
    y1 = polyval(pchord,Distr(:,1,1));
%     figure
%     plot(Distr(:,1,1),Distr(:,2,1),'o')
%     hold on
%     plot(Distr(:,1,1),y1)
%     hold off
    name{K} = {dinfo(K).name(1:guion(1)-1)};
    n = strcat('Data\',name{K},'*.txt');
    dinfo2 = dir(n{1});
    for i = 1 : length(dinfo2) 
        rr(K,i) = string(dinfo2(i).name);        
    end
    TF(K,:) = contains(rr(K,:),'geo');   
    dinfo2(logical(TF(K,:)))=[];          %Delete strings with propeller geometry
    
    TF = [];    
    for i = 1 : length(dinfo2) 
        rrr(K,i) = string(dinfo2(i).name);        
    end
    TF(K,:) = contains(rrr(K,:),'sta');   
    dinfo2(logical(TF(K,:)))=[];          %Delete strings with static results
    
    dele = [];
    rpm = [];
    for i = 1 : length(dinfo2)  %Run files with same geo different RPM
        guion2 = strfind(dinfo2(i).name,'_');        
        [num, status] = str2num(dinfo2(i).name(guion2(3)+1:end-4)); %-4 to delete .txt
        if status == 1
            rpm = [rpm num];
            
            dele(i) = [status];  
        else
            dele(i) = [status]; 
        end
    end    
    dinfo2(~logical(dele))=[];      %Remove data with no numbers at rpm
    for i = 1 : length(dinfo2) 
        Ta2 = readtable(strcat('Data\',dinfo2(i).name));        
        Ta3{i} = Ta2{:,:};
        [fila colum] = size(Ta3{i});
        for j = 1 : fila
            if rpm(i) >20000
                ll = 1;
            end
            Inputs(end+1,1:12) = [Inputs(end,1:10) rpm(i) Ta3{i}(j,1)];        %11 rpm, 12 J
            Outputs(end+1,1:2) = [Ta3{i}(j,2) Ta3{i}(j,3)];     % CT, CP
        end
    end
    Inputs(1,:) = [];
    In{K} = Inputs;
    Out{K} = Outputs;
end
Output = cat(1, Out{:});
Input = cat(1, In{:});