%% Plots Fig. 3 & 4 (GPIAS)
% Run sections separately. First section is required to load and process input data.
% Subequently, run individual section to produce individual figure panels.

tic

clear all 
close all

% --- user input ---
dosave = 0; 
savetable = 0; % to save SPSS
doplot = 0;

%Predefine SPSS factors
GPIAS = []; BIN = []; ID = []; COND = []; TIME = []; MEASURE=[]; WINDOW=[];

for nwindow = [50 1000]
    window = nwindow;
for nmeasure = 1:2
    if nmeasure == 1; measure = 'peak'; 
    elseif nmeasure == 2; measure = 'mean';
    end 
    
    

% Load data (load here 'Matlab_metadata' folder)
% loadpath = 'D:\...

% Define destination for figures
% savepath = 'D:\...

% add folder to optional additional matlab function, e.g. for violin plots
% addpath D:\...

close all

for cond = 1:2
    
    clear mousenames
    
    if cond==1; group = 'Ctrl'; elseif cond == 2; group = 'SD'; end
    
    inpost24{cond} = []; inpost4{cond} = []; inpre4{cond}=[];

if group(1) == 'C'
% --- Batch1 (without 6 weeks post) --
mousenames{1} =   {'Afour_BL'; 'Afour_postNOE';'Afour_postNOE2'};
mousenames{2} =   {'Bfour_BL'; 'Bfour_postNOE';'Bfour_postNOE2'};
mousenames{3} =   {'Dfour_BL'; 'Dfour_postNOE';'Dfour_postNOE2'};
mousenames{4} =   {'Efour_BL'; 'Efour_postNOE';'Efour_postNOE2'};
mousenames{5} =   {'Gfour_BL'; 'Gfour_postNOE';'Gfour_postNOE2'};
% mousenames{7} =   {'Hfour_BL'; 'Hfour_postNOE'};
mousenames{6} =   {'Ifour_BL'; 'Ifour_postNOE';'Ifour_postNOE2'};

elseif group(1) == 'S'
% --- Batch 2 ---
mousenames{1} =   {'Afive_BL'; 'Afive_postNOE'; 'Afive_postNOE2'};
mousenames{2} =   {'Bfive_BL'; 'Bfive_postNOE'; 'Bfive_postNOE2'};
mousenames{3} =   {'Dfive_BL'; 'Dfive_postNOE'; 'Dfive_postNOE2'};
mousenames{4} =   {'Efive_BL'; 'Efive_postNOE'; 'Efive_postNOE2'};
mousenames{5} =   {'Ffive_BL'; 'Ffive_postNOE'; 'Ffive_postNOE2'};
mousenames{6} =   {'Gfive_BL'; 'Gfive_postNOE'; 'Gfive_postNOE2'};
mousenames{7} =   {'Hfive_BL'; 'Hfive_postNOE'; 'Hfive_postNOE2'};
mousenames{8} =   {'Ifive_BL'; 'Ifive_postNOE'; 'Ifive_postNOE2'};
end


if window == 1000 && measure(1) == 'm'
for ii = 1:size(mousenames,2) % number of mice to be included in analysis
    for m = 1:size(mousenames{ii},1)
    load([loadpath mousenames{ii}{m} '.mat'])
        if strcmp(mousenames{ii}{m}(7:8),'BL')
        inpre4{cond}= [ inpre4{cond} inh4'];
        elseif strcmp(mousenames{ii}{m}(end-2:end),'NOE')
        inpost4{cond}= [inpost4{cond} inh4'];
        elseif strcmp(mousenames{ii}{m}(end-2:end),'OE2')
        inpost24{cond}= [inpost24{cond} inh4'];
        end
    end
end
elseif window == 50 && measure(1) == 'm'
for ii = 1:size(mousenames,2) % number of mice to be included in analysis
    for m = 1:size(mousenames{ii},1)
    load([loadpath mousenames{ii}{m} '.mat'])
        if strcmp(mousenames{ii}{m}(7:8),'BL')
        inpre4{cond}= [ inpre4{cond} inh4_50'];
        elseif strcmp(mousenames{ii}{m}(end-2:end),'NOE')
        inpost4{cond}= [inpost4{cond} inh4_50'];
        elseif strcmp(mousenames{ii}{m}(end-2:end),'OE2')
        inpost24{cond}= [inpost24{cond} inh4_50'];
        end
    end
end
end

if window == 1000 && measure(1) == 'p'
for ii = 1:size(mousenames,2) % number of mice to be included in analysis
    for m = 1:size(mousenames{ii},1)
    load([loadpath mousenames{ii}{m} '.mat'])
        if strcmp(mousenames{ii}{m}(7:8),'BL')
        inpre4{cond}= [ inpre4{cond} inh4_peak'];
        elseif strcmp(mousenames{ii}{m}(end-2:end),'NOE')
        inpost4{cond}= [inpost4{cond} inh4_peak'];
        elseif strcmp(mousenames{ii}{m}(end-2:end),'OE2')
        inpost24{cond}= [inpost24{cond} inh4_peak'];
        end
    end
end
elseif window == 50 && measure(1) == 'p'
for ii = 1:size(mousenames,2) % number of mice to be included in analysis
    for m = 1:size(mousenames{ii},1)
    load([loadpath mousenames{ii}{m} '.mat'])
        if strcmp(mousenames{ii}{m}(7:8),'BL')
        inpre4{cond}= [ inpre4{cond} inh4_50_peak'];
        elseif strcmp(mousenames{ii}{m}(end-2:end),'NOE')
        inpost4{cond}= [inpost4{cond} inh4_50_peak'];
        elseif strcmp(mousenames{ii}{m}(end-2:end),'OE2')
        inpost24{cond}= [inpost24{cond} inh4_50_peak'];
        end
    end
end
end


if group(1) == 'C'
fignames = ['Afour';'Bfour';'Dfour';'Efour';'Gfour';'Ifour'];
else
fignames = ['Afive';'Bfive';'Dfive';'Efive';'Ffive';'Gfive';'Hfive';'Ifive'];
end

for n = 1:size(inpost4{cond},2)
[p(n),h(n)] = ranksum(inpre4{cond}(:,n),inpost4{cond}(:,n));

if doplot == 1
% plot individual animals
figure(n);hold all
    try
    hh = plot([1 2 3],[inpre4{cond}(:,n) inpost4{cond}(:,n) inpost24{cond}(:,n)],'O', 'linewidth',2);
    plot([1 2 3],[mean(inpre4{cond}(:,n)) mean(inpost4{cond}(:,n)) mean(inpost24{cond}(:,n))],'--k','linewidth',2)
    catch %if postNOE3 data are unavailable
    hh = plot([1 2],[inpre4{cond}(:,n) inpost4{cond}(:,n)],'O', 'linewidth',2);
    plot([1 2],[mean(inpre4{cond}(:,n)) mean(inpost4{cond}(:,n))],'--k','linewidth',2)
    % continue
    end
legend(hh,'bin 1','bin 2','bin 3','bin 4')
xlim([0 4]); ylim([0 2.5])
%TITLE
maint = fignames(n,:); subt = ['p(pre-post1w)=' num2str(p(n))];
title({maint;subt},'FontSize',10)
box off
set(gca,'linewidth',1.5)
xticks([1 2 3]); 
xticklabels({'pre','post(1w)','post(6w)'});
ylabel('Inhibition')

end

end

end

%% Rearrange data for SPSS input

clear inpreall inpostall inpostall2
% reshape input matrices for means over all blocks
for cond = 1:2
minpreall{cond} = reshape(inpre4{cond},[],1);
minpostall{cond} = reshape(inpost4{cond},[],1);
minpostall2{cond} = reshape(inpost24{cond},[],1);
end
% combine animals for each bin (1-4)
for cond = 1:2
for bin = 1:4
inpreall{cond}(:,bin)=inpre4{cond}(bin,:);
inpostall{cond}(:,bin)=inpost4{cond}(bin,:);
inpostall2{cond}(:,bin)=inpost24{cond}(bin,:);
end
end


% Contruct columns for SPSS table

input_all{nmeasure}{nwindow} = {inpreall; inpostall; inpostall2};

for t = 1:3
    input = input_all{nmeasure}{nwindow}{t};
for cond = 1:2
    if cond==1; IDprim=0; elseif cond == 2; IDprim=6; end % mouse ID primer for continuous labels across both groups
for bin = 1:size(input{cond},2)
    GPIAS = [GPIAS; input{cond}(:,bin)];
    BIN = [BIN; ones(length(input{cond}(:,bin)),1)*bin];
    ID = [ID; [[1:size(input{cond},1)]+IDprim]' ];
    COND = [COND; ones(length(input{cond}(:,bin)),1)*cond];
    TIME = [TIME; ones(length(input{cond}(:,bin)),1)*t];
    MEASURE = [MEASURE; ones(length(input{cond}(:,bin)),1)*nmeasure];
    WINDOW = [WINDOW; ones(length(input{cond}(:,bin)),1)*nwindow];

end
end
end

end
end

% Construct SPSS table
GPIASdata = [ID GPIAS BIN COND TIME MEASURE WINDOW]; % matrix
GPIAS_table = array2table(GPIASdata); % convert to table
GPIAS_table.Properties.VariableNames(1:7) = {'ID','GPIAS','Bin','Cond','Time','Measure','Window'}; % name the columns

if savetable == 1
% writetable ...

end

% sortgpias = sort(GPIAS)

%% OPTIONAL: plot GPIAS
close all
figure(10)
hist(GPIASdata(:,2))

hist(log10( GPIASdata(:,2) ))

% savepath = ...

if dosave == 1
print(figure(10),'-r750','-dtiff',[savepath 'AllGPIASdata_hist.tiff'],'-painters');
end

%% OPTIONAL: plot GPIAS q-q plot

close all
figure(10)
ylim([0 4.5])
qqplot(GPIASdata(:,2))
title('Q-Q plot on raw GPIAS data')
% 
% figure(11)
% qqplot(log10( GPIASdata(:,2)) )
% ylim([-1 1])
% title('Q-Q plot on log-transformed GPIAS data')

set(gca,'linewidth',1.5,'fontsize',14)

% savepath = ...

if dosave == 1
print(figure(10),'-r750','-dtiff',[savepath 'GPIAS_Q-Qplot_alldata.tiff'],'-painters');
end

%% define & exclude outliers

% close all
clear input outexc boot nanGPIASdataex
%Predefine SPSS factors
GPIAS = []; BIN = []; ID = []; COND = []; TIME = []; MEASURE=[]; WINDOW=[];

for nmeasure = 1:2
    for nwindow = [50 1000]

        input{1} = input_all{nmeasure}{nwindow}{1};
        input{2} = input_all{nmeasure}{nwindow}{2};
        input{3} = input_all{nmeasure}{nwindow}{3};

        % isequal( input{1}{1},input{2}{1})
        clear outexc
        for in = 1:3
            % --- bootstrap data & define outlier criterium
            for cond = 1:2
                for bin = 1:4
                    clear m
                    nostds = 5
                    m = bootstrp(5000,@mean,input{in}{cond}(:,bin)); % bootstrap
                    boot{in}{cond}(:,bin)=m; % save bootstrap data
        %             figure;hist(m);title(['Cond' num2str(cond) ' Bin' num2str(bin)]) % plot bootstrapped data
                    av(cond,bin) = mean(m); % define mean of bootstrapped data
                    err(cond,bin) = nostds*std(m); % define std of bootstrapped data
                    crit(cond,bin)= err(cond,bin); % outlier criterion

                end 
            end
            % --- find and exclude outliers in original data
            for cond = 1:2
                for bin = 1:4
                    outexc_count{in}{cond}(bin)=0; % counter
                    outinc_count{in}{cond}(bin)=0; % counter

                    for n = 1:length(input{in}{cond}(:,bin)) % go through each datapoint
                        if input{in}{cond}(n,bin) > av(cond,bin)+crit(cond,bin) || input{in}{cond}(n,bin) < av(cond,bin)-crit(cond,bin)
                            outexc{in}{cond}(n,bin)=NaN;
                            outexc_count{in}{cond}(bin)=outexc_count{in}{cond}(bin)+1; % counter +1 for each outlier
                        else
                            outexc{in}{cond}(n,bin)=input{in}{cond}(n,bin);
                            outinc_count{in}{cond}(bin)=outinc_count{in}{cond}(bin)+1; % counter +1 for each included datapoint

                        end
                    end
                end 
            end
        end
  
           % --- Contruct columns for SPSS table


            input_meta_outexc = {outexc{1}; outexc{2}; outexc{3}};

        for t = 1:3
            input_tab = input_meta_outexc{t};
            for cond = 1:2
                if cond==1; IDprim=0; elseif cond == 2; IDprim=6; end % mouse ID primer for continuous labels across both groups
                for bin = 1:size(input_tab{cond},2)
                    GPIAS = [GPIAS; input_tab{cond}(:,bin)];                    
                    BIN = [BIN; ones(length(input_tab{cond}(:,bin)),1)*bin];
                    ID = [ID; [[1:size(input_tab{cond},1)]+IDprim]' ];
                    COND = [COND; ones(length(input_tab{cond}(:,bin)),1)*cond];
                    TIME = [TIME; ones(length(input_tab{cond}(:,bin)),1)*t];
                    MEASURE = [MEASURE; ones(length(input_tab{cond}(:,bin)),1)*nmeasure];
                    WINDOW = [WINDOW; ones(length(input_tab{cond}(:,bin)),1)*nwindow];
                end
            end
        end

    end 
end


% uniq = unique(GPIAS)
% sortgpias = sort(GPIAS);

% Construct SPSS table
nanGPIASdataex = [ID GPIAS BIN COND TIME MEASURE WINDOW]; % matrix

% Produce table (including NaNs)
nanGPIAS_tableex = array2table(nanGPIASdataex); % convert to table
nanGPIAS_tableex.Properties.VariableNames(1:7) = {'ID','GPIAS','Bin','Cond','Time','Measure','Window'}; % name the columns

% Produce table (exlcuding NaNs)
nonanIDX = find(~isnan(nanGPIASdataex(:,2))); %find lines with NaNs
GPIASdataex = nanGPIASdataex(nonanIDX,:); % construct final array without NaNs

GPIAS_tableex = array2table(GPIASdataex); % convert to table
GPIAS_tableex.Properties.VariableNames(1:7) = {'ID','GPIAS','Bin','Cond','Time','Measure','Window'}; % name the columns

if savetable == 1
    % tablepath = 'D:\...';
    writetable(GPIAS_tableex,[tablepath 'TinnitusMice_GPIAS_ex' num2str(nostds) 'STDS.xlsx']) % convert table to .xlsx file
end

%% OPTIONAL: plot GPIAS q-q plot (on data with outliers excluded)

figure(100)
q1 = qqplot(GPIASdataex(:,2));
ylim([0 4.5])
title('Q-Q plot on selected data')

% figure(110)
% q2 = qqplot(log10( GPIASdataex(:,2)) );
% ylim([-1 1])
% title('Q-Q plot on log-transformed GPIAS data')

set(gca,'linewidth',1.5,'fontsize',14)

set(q1,'Color','r')

% savepath = ...

if dosave == 1
print(figure(100),'-r750','-dtiff',[savepath 'GPIAS_Q-Qplot_outliersexcluded.tiff'],'-painters');
end


%% OPTIONAL: Plot: compare conditions
% (this compares conditions 1 and 2, irrespective of other aspects like BL,
% Post1, Post2)
close all

input = GPIASdataex; % GPIASdata or GPIASdataex

Ctrlidx = find(input(:,4)==1);
SDidx = find(input(:,4)==2);

CtrlGPIAS = input(Ctrlidx,2);
SDGPIAS = input(SDidx,2);

figure(10);hold all
%plot all data
plot([1],[CtrlGPIAS],'Ob','Markersize',5,'Color',[.6 .6 .6],'LineWidth',2)
plot([2],[SDGPIAS],'Ob','Markersize',5,'Color',[.4 .4 .4],'LineWidth',2)
%plot means
plot([1 2],[mean(CtrlGPIAS) mean(SDGPIAS)],':Ok','linewidth',1.5,'markersize',10)
%plot box plots
b1 = boxplot([CtrlGPIAS ],'positions',[1],'colors','k'...
     ,'Whisker',0,'outliersize',3,'symbol','','widths',0.5);
b2 = boxplot([SDGPIAS],'positions',[2],'colors','k'...
     ,'Whisker',0,'outliersize',3,'symbol','','widths',0.5);
set([b1 b2],'linewidth',1.5)
 

xlim([0 3])
ylim([0.1 1.45])

xticks([1 2])
xticklabels({'Ctrl';'SD'})

maint = 'Condition';
title({maint},'FontSize',14)
box off
set(gca,'linewidth',1.5,'FontSize',14)
xlabel('Condition')
ylabel('GPIAS')



% savepath = ...

if dosave == 1
% print(figure(10),'-r750','-dtiff',[savepath 'GPIAS_ByCondition_outliersexcluded.tiff'],'-painters');
end

%% OPTIONAL: Plot: compare conditions time 1,2 and 3
close all

clear Ctrlidx SDidx CtrlGPIAS SDGPIAS
input = GPIASdataex; % GPIASdata or GPIASdataex

% inoput for both conds at time 1 (BL)
for t = 1:3
Ctrlidx{t} = find(input(:,4)==1 & input(:,5)==t);
SDidx{t} = find(input(:,4)==2 & input(:,5)==t);
CtrlGPIAS{t} = input(Ctrlidx{t},2);
SDGPIAS{t} = input(SDidx{t},2);
end

figure(11);hold all
tx = [0 3 6]
cmap = [.5 .5 1; 1 .5 .5; 0.9 0.6 0.3]
%plot all data
for t = 1:3
plot([1]+tx(t),[CtrlGPIAS{t}],'Ob','Markersize',5,'Color',[.6 .6 .6],'LineWidth',2)
plot([2]+tx(t),[SDGPIAS{t}],'Ob','Markersize',5,'Color',[.4 .4 .4],'LineWidth',2)
%plot means
plot([1]+tx(t),[mean(CtrlGPIAS{t})],'-O','Color',cmap(t,:),'linewidth',1.5,'markersize',10)
plot([2]+tx(t),[mean(SDGPIAS{t})],'-O','Color',cmap(t,:),'linewidth',1.5,'markersize',10)
plot([1 2]+tx(t),[mean(CtrlGPIAS{t}) mean(SDGPIAS{t})],'-k','linewidth',1.5,'markersize',10)

%plot box plots
b1 = boxplot([CtrlGPIAS{t} ],'positions',[1]+tx(t),'colors',cmap(t,:)...
     ,'Whisker',0,'outliersize',3,'symbol','','widths',0.5);
b2 = boxplot([SDGPIAS{t}],'positions',[2]+tx(t),'colors',cmap(t,:)...
     ,'Whisker',0,'outliersize',3,'symbol','','widths',0.5);
set([b1 b2],'linewidth',1.5)
end

p1 = plot([1]+tx(1),[mean(CtrlGPIAS{1})],'O','Color',cmap(1,:),'linewidth',1.5,'markersize',10);
p2 = plot([1]+tx(2),[mean(CtrlGPIAS{2})],'O','Color',cmap(2,:),'linewidth',1.5,'markersize',10);
p3 = plot([1]+tx(3),[mean(CtrlGPIAS{3})],'O','Color',cmap(3,:),'linewidth',1.5,'markersize',10);
legend([p1 p2 p3],'Pre','Post 1w','Post 6w')



xlim([0 9])
ylim([0.1 1.45])

xticks([1 2 4 5 7 8])
xticklabels({'Ctrl';'SD'})

maint = 'Condition';
% title({maint},'FontSize',14)
box off
set(gca,'linewidth',1.5,'FontSize',14)
xlabel('Condition')
ylabel('GPIAS')



% savepath = ...

if dosave == 1
% print ...
end

%% Fig. 3D: plot GPIAs as % of BL


close all

clear Ctrlidx SDidx CtrlGPIAS SDGPIAS
input = GPIASdataex; % GPIASdata or GPIASdataex

% inoput for both conds at time 1 (BL)
for t = 1:3
Ctrlidx{t} = find(input(:,4)==1 & input(:,5)==t);
SDidx{t} = find(input(:,4)==2 & input(:,5)==t);
CtrlGPIAS{t} = input(Ctrlidx{t},2);
SDGPIAS{t} = input(SDidx{t},2);
end

% Approach: for Ctrl animals find datapoints that exist for both BL and Post1

% 1. use original table (including NaNs) to match datapoints across condtions
nanGPIASdataex;
% 2. FYI, these are the labels of columns (note that 'Cond' refers to Ctrl
% & 6hSD
% groups, i.e. different animals with IDs 1-6 for Ctrl and 7-14 for SD
% group)(also, meaasure=1 is 'peak', measure=2 is 'mean' of the signal)
nanGPIAS_tableex = array2table(nanGPIASdataex); % convert to table
nanGPIAS_tableex.Properties.VariableNames(1:7) = {'ID','GPIAS','Bin','Cond','Time','Measure','Window'}; % name the columns
% 3. Now, for animal 1 (ID=1) find for Bin=1, Measure=1, Window=50 the
% datapoints for both Time=1 and Time =2, clalculate relative value or save
% NaN if one or both values are missing. Then repeat this for all bins,
% measures and windows (and for each animal).

% 1) find indeces 
clear idx
for ID = 1:14
   for cond = 1:2
    for bin =1:4
        for measure = 1:2
            for window = [50 1000]
                for time = 1:3
                idx{ID,time}{cond}{bin}{measure}{window} = find( nanGPIASdataex(:,1)==ID & nanGPIASdataex(:,4)==cond & nanGPIASdataex(:,3)==bin & nanGPIASdataex(:,5)==time...
                    &  nanGPIASdataex(:,6)==measure & nanGPIASdataex(:,7)==window) 
                % if isnumeric(idx{ID,time}{cond}{bin}{measure}{window})
                %     display 'is num!'
                % end
%                 meta = nanGPIASdataex(:,1)==ID & nanGPIASdataex(:,3)==bin  & nanGPIASdataex(:,5)==time &  nanGPIASdataex(:,6)==measure & nanGPIASdataex(:,7)==window
            end
        end
    end
    end
end
end

% 2) calculate relative value (or save NaN)


CTRL_relVp1_all = [];
CTRL_relVp2_all = [];
SD_relVp1_all = [];
SD_relVp2_all = [];
CTRL_relVp1_allNaN = 0;
CTRL_relVp2_allNaN = 0;
SD_relVp1_allNaN = 0;
SD_relVp2_allNaN = 0;

for ID = 1:14
    for cond = 1:2
    for bin = 1:4
        for measure = 1:2
            for window = [50 1000]
                for time = 1:3
        % Post1 as % of BL
        relVp1{ID}{cond}{bin}{measure}{window} = nanGPIASdataex(idx{ID,2}{cond}{bin}{measure}{window},2) / nanGPIASdataex(idx{ID,1}{cond}{bin}{measure}{window},2) ;
        % Post2 as % of BL
        relVp2{ID}{cond}{bin}{measure}{window} = nanGPIASdataex(idx{ID,3}{cond}{bin}{measure}{window},2) / nanGPIASdataex(idx{ID,1}{cond}{bin}{measure}{window},2) ;
        
        
        % Now produce input for plot. I.e. all datapoints for rel1, rel2 for Ctrl
        % and for SD
        if cond == 1
            CTRL_relVp1_all = [CTRL_relVp1_all;  relVp1{ID}{cond}{bin}{measure}{window}];
                  % Count NaNs % 21
                  if isnan(relVp1{ID}{cond}{bin}{measure}{window}); CTRL_relVp1_allNaN = CTRL_relVp1_allNaN+1; end
            CTRL_relVp2_all = [CTRL_relVp2_all;  relVp2{ID}{cond}{bin}{measure}{window}];
                  % Count NaNs % 27
                  if isnan(relVp2{ID}{cond}{bin}{measure}{window}); CTRL_relVp2_allNaN = CTRL_relVp2_allNaN+1; end
        elseif cond == 2 % 42
            SD_relVp1_all = [SD_relVp1_all;  relVp1{ID}{cond}{bin}{measure}{window}];
                  % Count NaNs
                  if isnan(relVp1{ID}{cond}{bin}{measure}{window}); SD_relVp1_allNaN = SD_relVp1_allNaN+1; end
            SD_relVp2_all = [SD_relVp2_all;  relVp2{ID}{cond}{bin}{measure}{window}];
                  % Count NaNs % 51
                  if isnan(relVp2{ID}{cond}{bin}{measure}{window}); SD_relVp2_allNaN = SD_relVp2_allNaN+1; end
        end



        if cond == 2
        end
                
                end
            end
         end
    end
    end
end


% produce ratio of the means (plot input)
for t = 2:3
    DiffCtrlGPIAS{t} = mean(CtrlGPIAS{t}) / mean(CtrlGPIAS{1})*100
    DiffSDGPIAS{t} = mean(SDGPIAS{t}) / mean(SDGPIAS{1})*100
end


close all
figure(11);hold all
tx = [0 3 6]
cmap = [.5 .5 1; 1 .5 .5; 0.9 0.6 0.3]


% plot individual datapoints (based on datapoints present over all timepoints)(taken x100 to plot as %, like the means))
plot([1],[CTRL_relVp1_all*100],'o','Color',[.6 .6 .6],'linewidth',2,'Markersize',5)
plot([1.5],[SD_relVp1_all*100],'o','Color',[.4 .4 .4],'linewidth',2,'Markersize',5)
plot([3],[CTRL_relVp2_all*100],'o','Color',[.6 .6 .6],'linewidth',2,'Markersize',5)
plot([3.5],[SD_relVp2_all*100],'o','Color',[.4 .4 .4],'linewidth',2,'Markersize',5)
% plot means (based on all datapoints)
p1 = plot([1 1.5],[DiffCtrlGPIAS{2} DiffSDGPIAS{2}],'O','Color',cmap(2,:),'linewidth',2,'markersize',15)
p2 = plot([3 3.5],[DiffCtrlGPIAS{3} DiffSDGPIAS{3}],'O','Color',cmap(3,:),'linewidth',2,'markersize',15)
% box plots
for bin = 1
b = boxplot([CTRL_relVp1_all*100 CTRL_relVp2_all*100],'positions',[1 3],'colors','k'...
     ,'Whisker',0,'outliersize',3,'symbol','','widths',0.3)
set(b,'linewidth',2)
b2 = boxplot([SD_relVp1_all*100 SD_relVp2_all*100],'positions',[1.5 3.5],'colors','k'...
     ,'Whisker',0,'outliersize',3,'symbol','','widths',0.3)
set(b2,'linewidth',2)
end
% line
% plot([0 5],[100 100],'k--')


% plot settings
xlim([0 4])
% ylim([0.8 1.2]*100)

% xticks([1.25 3.25])
% xticklabels({'Post1w (Ctrl, SD)';'Post8w (Ctrl, SD)'})

xticks([1 1.5 3 3.5])
xticklabels({'Ctrl';'6hSD';'Ctrl';'6hSD'})

legend([p1 p2],'Post1w/BL','Post8w/BL')

% maint = 'Condition';
% title({maint},'FontSize',14)
box off; grid off
set(gca,'linewidth',1.5,'FontSize',14)
% xlabel('Condition')
ylabel('GPIAS ratio (% of BL)')

% savepath = 'D:\...

if dosave == 1
% print(figure(11),'-r750','-dtiff',[savepath 'GPIAS_relative_changes.tiff'],'-painters');
end


%% Fig. 3C: baseline startle across groups
% SD and Ctrl plots separated.

% inoput for both conds at time 1 (BL)
for t = 1:3
Ctrlidx{t} = find(input(:,4)==1 & input(:,5)==t);
SDidx{t} = find(input(:,4)==2 & input(:,5)==t);
CtrlGPIAS{t} = input(Ctrlidx{t},2);
SDGPIAS{t} = input(SDidx{t},2);
end

close all
figure(111);hold all
tx = [0 3 6]
cmap = [.5 .5 1; 1 .5 .5; 0.9 0.6 0.3]

% 
% plot individual datapoints (based on datapoints present over all timepoints)(taken x100 to plot as %, like the means))
for n = 1:length(CtrlGPIAS{1})
p1 = plot([0.8+rand(1)],[CtrlGPIAS{1}(n)],'o','Color',[.6 .6 .6],'linewidth',2,'Markersize',5)
end
for nn = 1:length(SDGPIAS{1})
p2 = plot([2.2+rand(1)],[SDGPIAS{1}(nn)],'o','Color',[.4 .4 .4],'linewidth',2,'Markersize',5)
end


%line
plot([0 5],[1 1],'--k')



% plot settings
xlim([0 4])
ylim([0 1.6])

% xticks([1.25 3.25])
% xticklabels({'Post1w (Ctrl, SD)';'Post8w (Ctrl, SD)'})

xticks([1.3 2.7])
xticklabels({'Ctrl';'6hSD'})

% legend([p1 p2],'Ctrl BL','SD BL')

% maint = 'Condition';
% title({maint},'FontSize',14)
box off; grid off
set(gca,'linewidth',1.5,'FontSize',14)
% xlabel('Condition')
ylabel('GPIAS ratio')

% savepath = 'D:\...

if dosave == 1
% print(figure(111),'-r750','-dtiff',[savepath 'GPIAS_baseline-values.tiff'],'-painters');
end


%% Fig. optional : compare time

close all
clear Time1IDX Time2IDX Time3IDX Time1GPIAS Time2GPIAS Time3GPIAS

input = GPIASdataex; % GPIASdata or GPIASdataex


Time1IDX = find(input(:,5)==1);
Time2IDX = find(input(:,5)==2);
Time3IDX = find(input(:,5)==3);

Time1GPIAS = input(Time1IDX,2);
Time2GPIAS = input(Time2IDX,2);
Time3GPIAS = input(Time3IDX,2);



figure(10);hold all

% horizontal line at y=1
plot([0 5],[1 1],'--k')

% plot all data
plot([1],[Time1GPIAS],'o','Color',[.5 .5 1],'linewidth',2,'Markersize',5)
plot([2],[Time2GPIAS],'o','Color',[1 .5 .5],'linewidth',2,'Markersize',5)
plot([3],[Time3GPIAS],'o','Color',[ 0.9 0.6 0.3 ],'linewidth',2,'Markersize',5)
% box plots
b1 = boxplot([Time1GPIAS],'positions',[1],'colors','k','Whisker',0,'outliersize',3,'symbol','','widths',0.3);
b2 = boxplot([Time2GPIAS],'positions',[2],'colors','k','Whisker',0,'outliersize',3,'symbol','','widths',0.3);
b3 = boxplot([Time3GPIAS],'positions',[3],'colors','k','Whisker',0,'outliersize',3,'symbol','','widths',0.3);
set([b1 b2 b3],{'linew'},{2})% plot means
plot([1 2 3],[mean(Time1GPIAS) mean(Time2GPIAS) mean(Time3GPIAS)],':Ok','linewidth',2,'markersize',10)



xlim([0 4])
ylim([0 1.65])

xticks([1 2 3])
xticklabels({'BL';'Post1w';'Post8w'})

maint = 'Time';
% title({maint},'FontSize',14)
box off
set(gca,'linewidth',1.5,'FontSize',14)
xlabel('Testing time')
ylabel('GPIAS')

% savepath = 'D:\...

if dosave == 1

print(figure(10),'-r750','-dtiff',[savepath 'GPIAS_ByTime_outliersexcluded_all.tiff'],'-painters');
print(figure(10),'-r750','-dtiff',[savepath 'GPIAS_ByTime_outliersexcluded_all.tiff'],'-painters');

end

%% Fig. 3A: compare time (control group)

close all
clear Time1IDX Time2IDX Time3IDX Time1GPIAS Time2GPIAS Time3GPIAS

input = GPIASdataex; % GPIASdata or GPIASdataex


Time1IDX = find(input(:,5)==1 & input(:,4)==1  ); % time1, cond 1
Time2IDX = find(input(:,5)==2 & input(:,4)==1  ); % time2, cond1
Time3IDX = find(input(:,5)==3 & input(:,4)==1  );

Time1GPIAS = input(Time1IDX,2);
Time2GPIAS = input(Time2IDX,2);
Time3GPIAS = input(Time3IDX,2);



figure(10);hold all

% horizontal line at y=1
plot([0 5],[1 1],'--k')

% plot all data
plot([1],[Time1GPIAS],'o','Color',[.5 .5 1],'linewidth',2,'Markersize',5)
plot([2],[Time2GPIAS],'o','Color',[1 .5 .5],'linewidth',2,'Markersize',5)
plot([3],[Time3GPIAS],'o','Color',[ 0.9 0.6 0.3 ],'linewidth',2,'Markersize',5)
% box plots
b1 = boxplot([Time1GPIAS],'positions',[1],'colors','k','Whisker',0,'outliersize',3,'symbol','','widths',0.3);
b2 = boxplot([Time2GPIAS],'positions',[2],'colors','k','Whisker',0,'outliersize',3,'symbol','','widths',0.3);
b3 = boxplot([Time3GPIAS],'positions',[3],'colors','k','Whisker',0,'outliersize',3,'symbol','','widths',0.3);
set([b1 b2 b3],{'linew'},{2})% plot means
plot([1 2 3],[mean(Time1GPIAS) mean(Time2GPIAS) mean(Time3GPIAS)],':Ok','linewidth',2,'markersize',10)

% sig markers
% BL to Post1, p=0.009
plot([1 2], [1.55 1.55],'-k','linewidth',1) % line (wave I, BL to post2)
    plot(mean([1 2]), 1.59, '*k','Markersize',7,'linewidth',1.1) % marker1

xlim([0 4])
ylim([0 1.65])

xticks([1 2 3])
xticklabels({'BL';'Post1w';'Post8w'})

maint = 'Time';
% title({maint},'FontSize',14)
box off
set(gca,'linewidth',1.5,'FontSize',14)
xlabel('Testing time')
ylabel('GPIAS')

% savepath = 'D:\...

if dosave == 1

print(figure(10),'-r750','-dtiff',[savepath 'GPIAS_ByTime_outliersexcluded_Ctrl.tiff'],'-painters');
end

%% Fig 3B: compare time (6hSD group)

close all
clear Time1IDX Time2IDX Time3IDX Time1GPIAS Time2GPIAS Time3GPIAS

input = GPIASdataex; % GPIASdata or GPIASdataex


Time1IDX = find(input(:,5)==1 & input(:,4)==2  ); % time1, cond 1
Time2IDX = find(input(:,5)==2 & input(:,4)==2  ); % time2, cond1
Time3IDX = find(input(:,5)==3 & input(:,4)==2  );

Time1GPIAS = input(Time1IDX,2);
Time2GPIAS = input(Time2IDX,2);
Time3GPIAS = input(Time3IDX,2);



figure(10);hold all

% horizontal line at y=1
plot([0 5],[1 1],'--k')

% plot all data
plot([1],[Time1GPIAS],'o','Color',[.5 .5 1],'linewidth',2,'Markersize',5)
plot([2],[Time2GPIAS],'o','Color',[1 .5 .5],'linewidth',2,'Markersize',5)
plot([3],[Time3GPIAS],'o','Color',[ 0.9 0.6 0.3 ],'linewidth',2,'Markersize',5)
% box plots
b1 = boxplot([Time1GPIAS],'positions',[1],'colors','k','Whisker',0,'outliersize',3,'symbol','','widths',0.3);
b2 = boxplot([Time2GPIAS],'positions',[2],'colors','k','Whisker',0,'outliersize',3,'symbol','','widths',0.3);
b3 = boxplot([Time3GPIAS],'positions',[3],'colors','k','Whisker',0,'outliersize',3,'symbol','','widths',0.3);
set([b1 b2 b3],{'linew'},{2})% plot means
plot([1 2 3],[mean(Time1GPIAS) mean(Time2GPIAS) mean(Time3GPIAS)],':Ok','linewidth',2,'markersize',10)



xlim([0 4])
ylim([0 1.65])

xticks([1 2 3])
xticklabels({'BL';'Post1w';'Post8w'})

maint = 'Time';
% title({maint},'FontSize',14)
box off
set(gca,'linewidth',1.5,'FontSize',14)
xlabel('Testing time')
ylabel('GPIAS')

% savepath = 'D:\...

if dosave == 1
print(figure(10),'-r750','-dtiff',[savepath 'GPIAS_ByTime_outliersexcluded_SD.tiff'],'-painters');
end

%% Fig.4A: compare bins

clear Binidx BinGPIAS

close all
figure(10);hold all

input = GPIASdataex; % GPIASdata or GPIASdataex

% horizontal line at y=1
plot([0 5],[1 1],'--k')

for bin = 1:4
Binidx{:,bin} = find(input(:,3)==bin);
BinGPIAS{:,bin} = input(Binidx{:,bin},2);
end
% plot all data
for bin = 1:4
plot([bin],[BinGPIAS{:,bin}],'Ob','Markersize',5,'Color',[.5 .5 .5],'LineWidth',2)
end
% box plots
for bin = 1:4
b = boxplot([BinGPIAS{:,bin}],'positions',[bin],'colors','k'...
     ,'Whisker',0,'outliersize',3,'symbol','','widths',0.3)
set(b,'linewidth',2)
end
% plot means
plot([1 2 3 4],[mean(BinGPIAS{:,1}) mean(BinGPIAS{:,2}) mean(BinGPIAS{:,3}) mean(BinGPIAS{:,4})],':Ok','linewidth',2,'markersize',10)

% sig markers
% Bin1 to 2, p=0.003
plot([1 2], [1.36 1.36],'-k','linewidth',1) % line (wave I, BL to post2)
    plot(mean([1 2]), 1.4, '*k','Markersize',7,'linewidth',1.1) % marker1
% Bin1 to 3, p<0.001
plot([1 3], [1.46 1.46],'-k','linewidth',1) % line (wave I, BL to post2)
    plot(mean([1 3])-0.06, 1.5, '*k','Markersize',7,'linewidth',1.1) % marker1
    plot(mean([1 3])+0.06, 1.5, '*k','Markersize',7,'linewidth',1.1) % marker1
% Bin1 to 4, p<0.001
plot([1 4], [1.56 1.56],'-k','linewidth',1) % line (wave I, BL to post2)
    plot(mean([1 4])-0.06, 1.6, '*k','Markersize',7,'linewidth',1.1) % marker1
    plot(mean([1 4])+0.06, 1.6, '*k','Markersize',7,'linewidth',1.1) % marker1
    
xlim([0 5])
ylim([0 1.65])

xticks([1 2 3 4])
xticklabels({'Early1';'Early2';'Late1';'Late2'})
xtickangle(30)

maint = 'Interval';
% title({maint},'FontSize',14)
box off
set(gca,'linewidth',1.5,'FontSize',14)
xlabel('Presentation order')
ylabel('GPIAS')

% savepath = 'D:\...

if dosave == 1
print(figure(10),'-r750','-dtiff',[savepath 'GPIAS_ByBin_outliersexcluded.tiff'],'-painters');
end

%% OPTIONAL: Bin*Time 

close all
clear GPIASIDX GPIASVAL p1 p2 p3

input = GPIASdataex; % GPIASdata or GPIASdataex


% [ID GPIAS BIN COND TIME MEASURE WINDOW]; % matrix arrangement

% GPIAS by bin and time
for t = 1:3
    for bin= 1:4
    GPIASIDX{t}{bin} = find(input(:,3)==bin & input(:,5)==t );
    GPIASVAL{t}{bin} = input(GPIASIDX{t}{bin},2);
    end
end

% Plot

figure(10);hold all
tx = [0 5 10]; 
cmap = [.5 .5 1;1 .5 .5; 0.9 0.6 0.3 ]; % colourmap

% legend plots
p1 = plot(tx(1)+1,GPIASVAL{1}{1}(1),'o','Color',cmap(1,:),'linewidth',1.5,'Markersize',5);
p2 = plot(tx(2)+1,GPIASVAL{2}{1}(1),'o','Color',cmap(2,:),'linewidth',1.5,'Markersize',5);
p3 = plot(tx(3)+1,GPIASVAL{3}{1}(1),'o','Color',cmap(3,:),'linewidth',1.5,'Markersize',5);

% horizontal line at y=1
plot([0 15],[1 1],'--k')


for t = 1:3
    for bin= 1:4
        % plot all data
        p = plot(tx(t)+bin,GPIASVAL{t}{bin},'o','Color',cmap(t,:),'linewidth',1.5,'Markersize',5);
        % box plots
%         b = boxplot([GPIASVAL{t}{bin}],'positions',tx(t)+bin,'colors','k','Whisker',0,'outliersize',3,'symbol','');
%         set([b],'linewidth',1.5)

    end
    
        % plot errorbar 
        errorbar([1 2 3 4]+tx(t),[mean(GPIASVAL{t}{1}) mean(GPIASVAL{t}{2}) mean(GPIASVAL{t}{3})...
            mean(GPIASVAL{t}{4})],[std(GPIASVAL{t}{1}) std(GPIASVAL{t}{2}) std(GPIASVAL{t}{3})...
            std(GPIASVAL{t}{4})],'-k','linewidth',2.5,'markersize',9,'capsize',0)
        % plot mean 
%         plot([1 2 3 4]+tx(t),[mean(GPIASVAL{t}{1}) mean(GPIASVAL{t}{2}) mean(GPIASVAL{t}{3})...
%             mean(GPIASVAL{t}{4})],'-k','linewidth',1.5,'markersize',9)
end

xlim([0 15])
ylim([0 1.65])

% xticks([1 2 3 4 6 7 8 9 11 12 13 14])
% xticklabels({'Early';'Early trans.';'Late trans.';'Late';  'Early';'Early trans.';'Late trans.';'Late';  'Early';'Early trans.';'Late trans.';'Late'})
xticks([1 2 3 4 6 7 8 9 11 12 13 14])
xticklabels({'Early1';'Early2';'Late1';'Late2'})
xtickangle(30)



% maint = 'Bin*Time';
title({maint},'FontSize',14)
box off
set(gca,'linewidth',1.5,'FontSize',14)
% xlabel('Time bin')
ylabel('GPIAS')
legend([p1 p2 p3],'BL','Post1w','Post8w')

% savepath = 'D:\...


if dosave == 1
print(figure(10),'-r750','-dtiff',[savepath 'GPIAS_BinXTime_outliersexcluded.tiff'],'-painters');
end

%% OPTIONAL: Bin*Time (with fitted line) (not included)

close all
clear GPIASIDX GPIASVAL p1 p2 p3

input = GPIASdataex; % GPIASdata or GPIASdataex


% [ID GPIAS BIN COND TIME MEASURE WINDOW]; % matrix arrangement

% GPIAS by bin and time
for t = 1:3
    for bin= 1:4
    GPIASIDX{t}{bin} = find(input(:,3)==bin & input(:,5)==t );
    GPIASVAL{t}{bin} = input(GPIASIDX{t}{bin},2);
    end
end

% Plot

figure(10);hold all
tx = [0 5 10]; 
cmap = [.5 .5 1;1 .5 .5; 0.9 0.6 0.3 ]; % colourmap

% legend plots
p1 = plot(tx(1)+1,GPIASVAL{1}{1}(1),'o','Color',cmap(1,:),'linewidth',1.5,'Markersize',5);
p2 = plot(tx(2)+1,GPIASVAL{2}{1}(1),'o','Color',cmap(2,:),'linewidth',1.5,'Markersize',5);
p3 = plot(tx(3)+1,GPIASVAL{3}{1}(1),'o','Color',cmap(3,:),'linewidth',1.5,'Markersize',5);

% horizontal line at y=1
plot([0 15],[1 1],'--k')


for t = 1:3
    for bin= 1:4
        % plot all data
        p = plot(tx(t)+bin,GPIASVAL{t}{bin},'o','Color',cmap(t,:),'linewidth',1.5,'Markersize',5);
        % box plots
%         b = boxplot([GPIASVAL{t}{bin}],'positions',tx(t)+bin,'colors','k','Whisker',0,'outliersize',3,'symbol','');
%         set([b],'linewidth',1.5)

    end
    
        % plot errorbar 
         errorbar([1 2 3 4]+tx(t), ...
    [mean(GPIASVAL{t}{1}), mean(GPIASVAL{t}{2}), mean(GPIASVAL{t}{3}), mean(GPIASVAL{t}{4})], ...
    [std(GPIASVAL{t}{1}), std(GPIASVAL{t}{2}), std(GPIASVAL{t}{3}), std(GPIASVAL{t}{4})], ...
    'k', 'LineStyle', 'none', 'Marker', 'none', 'MarkerSize', 9, 'Capsize', 0, 'LineWidth', 2.5);
        
        
        % plot mean 
%         plot([1 2 3 4]+tx(t),[mean(GPIASVAL{t}{1}) mean(GPIASVAL{t}{2}) mean(GPIASVAL{t}{3})...
%             mean(GPIASVAL{t}{4})],'-k','linewidth',1.5,'markersize',9)
end

    for t = 1:3
        
% INPUT
% Produce equal length columns for each bin by padding with NaNs:
% Store the columns in a cell array
cols = {GPIASVAL{t}{1}, GPIASVAL{t}{2}, GPIASVAL{t}{3}, GPIASVAL{t}{4}};
% Find the maximum length
maxLen = max(cellfun(@length, cols));
% Pad each column with NaNs to match the maximum length
for i = 1:length(cols)
    cols{i} = [cols{i}; NaN(maxLen - length(cols{i}), 1)];
end
% Convert the padded columns back into a matrix (if desired)
y = horzcat(cols{:});
% Produce x values
x = repmat([1, 2, 3, 4], length(cols{i}), 1);

% FITTING
% Remove NaNs from x and y
validIndices = ~isnan(x) & ~isnan(y);  % Identify rows where neither x nor y are NaN
x_valid = x(validIndices);  % Filter x
y_valid = y(validIndices);  % Filter y

% Fit a linear polynomial (degree 1) to the valid data
p = polyfit(x_valid, y_valid, 1);  % p will contain the slope and intercept of the line

y_fitted = polyval(p, x); % Evaluating the fit using the coefficients


 % plot fitted line
%    p = plot(cx(cond)+tx(t)+bin,GPIASVAL{cond}{t}{bin},'o','Color',cmap(t,:),'linewidth',1.5,'Markersize',4);
   x_input = [tx(t)+1 tx(t)+2 +tx(t)+3 tx(t)+4]
   plot(x_input, mean(y_fitted), ':','linewidth',2.5,'Color', [0 0 0]); % Fitted line in red



    end




xlim([0 15])
ylim([0 1.65])

% xticks([1 2 3 4 6 7 8 9 11 12 13 14])
% xticklabels({'Early';'Early trans.';'Late trans.';'Late';  'Early';'Early trans.';'Late trans.';'Late';  'Early';'Early trans.';'Late trans.';'Late'})
xticks([1 2 3 4 6 7 8 9 11 12 13 14])
xticklabels({'Early1';'Early2';'Late1';'Late2'})
xtickangle(30)



% maint = 'Bin*Time';
title({maint},'FontSize',14)
box off
set(gca,'linewidth',1.5,'FontSize',14)
% xlabel('Time bin')
ylabel('GPIAS rate')
legend([p1 p2 p3],'BL','Post1w','Post8w')

% savepath = 'D:\...


if dosave == 1
print(figure(10),'-r750','-dtiff',[savepath 'GPIAS_BinXTime_outliersexcluded_regressionLine.tiff'],'-painters');
end


%% OPTIONAL: Bin*Time*Cond

close all
clear GPIASIDX GPIASVAL p1 p2 p3

input = GPIASdataex; % GPIASdata or GPIASdataex

% [ID GPIAS BIN COND TIME MEASURE WINDOW]; % matrix arrangement

% GPIAS by bin and time
for cond = 1:2
    for t = 1:3
        for bin= 1:4
        GPIASIDX{cond}{t}{bin} = find(input(:,3)==bin & input(:,5)==t & input(:,4)==cond);
        GPIASVAL{cond}{t}{bin} = input(GPIASIDX{cond}{t}{bin},2);
        end
    end
end


% Plot

figure(10);hold all
tx = [0 5 10]; 
cx = [0 17];
cmap = [.5 .5 1;1 .5 .5; 0.9 0.6 0.3 ]; % colourmap

for cond = 1:2
    for t = 1:3
        for bin= 1:4
            % plot all data
            p = plot(cx(cond)+tx(t)+bin,GPIASVAL{cond}{t}{bin},'o','Color',cmap(t,:),'linewidth',1.5,'Markersize',4);
            % box plots
%             b = boxplot([GPIASVAL{cond}{t}{bin}],'positions',cx(cond)+tx(t)+bin,'colors','k','Whisker',0,'outliersize',3,'symbol','');
%             set([b],'linewidth',1.5)

        end
            % plot errorbars 
            errorbar([1 2 3 4]+cx(cond)+tx(t),[mean(GPIASVAL{cond}{t}{1}) mean(GPIASVAL{cond}{t}{2}) mean(GPIASVAL{cond}{t}{3})...
                mean(GPIASVAL{cond}{t}{4})],[std(GPIASVAL{cond}{t}{1}) std(GPIASVAL{cond}{t}{2}) std(GPIASVAL{cond}{t}{3})...
                std(GPIASVAL{cond}{t}{4})],'-k','linewidth',2.5,'markersize',9,'capsize',0)
            
            % plot means (coloured)
%              plot([1 2 3 4]+cx(cond)+tx(t),[mean(GPIASVAL{cond}{t}{1}) mean(GPIASVAL{cond}{t}{2}) mean(GPIASVAL{cond}{t}{3})...
%                 mean(GPIASVAL{cond}{t}{4})],'-k','linewidth',2,'markersize',3) 

    end
end

xlim([0 33])
ylim([0 1.65])

XticksA = [1 2 3 4 6 7 8 9 11 12 13 14]; XticksB = XticksA+17;
xticks([XticksA XticksB])
xticklabels({'';'';'';''})
% a = get(gca,'XTickLabel');  
% set(gca,'XTickLabel',a,'fontsize',8,'FontWeight','normal')
% xtickangle(30)

maint = 'Bin*Time*Cond';
title({maint},'FontSize',14)
box off
set(gca,'linewidth',1.5,'FontSize',14)
xlabel('Control                             SD')
ylabel('GPIAS')
% legend([p1 p2 p3],'Pre','Post 1w','Post 6w','Location','Northwest')

% savepath = 'D:\...

if dosave == 1
print(figure(10),'-r750','-dtiff',[savepath 'GPIAS_BinXTimeXCond_outliersexcluded.tiff'],'-painters');
end

%% Fig.4B: Bin*Time*Cond (with linear regression line)


close all
clear GPIASIDX GPIASVAL p1 p2 p3

input = GPIASdataex; % GPIASdata or GPIASdataex

% [ID GPIAS BIN COND TIME MEASURE WINDOW]; % matrix arrangement

% GPIAS by bin and time
for cond = 1:2
    for t = 1:3
        for bin= 1:4
        GPIASIDX{cond}{t}{bin} = find(input(:,3)==bin & input(:,5)==t & input(:,4)==cond);
        GPIASVAL{cond}{t}{bin} = input(GPIASIDX{cond}{t}{bin},2);
        end
    end
end


% Plot

figure(10);hold all
tx = [0 5 10]; 
cx = [0 17];
cmap = [.5 .5 1;1 .5 .5; 0.9 0.6 0.3 ]; % colourmap

for cond = 1:2
    for t = 1:3
        for bin= 1:4
            % plot all data
            p = plot(cx(cond)+tx(t)+bin,GPIASVAL{cond}{t}{bin},'o','Color',cmap(t,:),'linewidth',1.5,'Markersize',4);
            % box plots
%             b = boxplot([GPIASVAL{cond}{t}{bin}],'positions',cx(cond)+tx(t)+bin,'colors','k','Whisker',0,'outliersize',3,'symbol','');
%             set([b],'linewidth',1.5)

        end

    errorbar([1 2 3 4]+cx(cond)+tx(t), ...
    [mean(GPIASVAL{cond}{t}{1}), mean(GPIASVAL{cond}{t}{2}), mean(GPIASVAL{cond}{t}{3}), mean(GPIASVAL{cond}{t}{4})], ...
    [std(GPIASVAL{cond}{t}{1}), std(GPIASVAL{cond}{t}{2}), std(GPIASVAL{cond}{t}{3}), std(GPIASVAL{cond}{t}{4})], ...
    'k', 'LineStyle', 'none', 'Marker', 'none', 'MarkerSize', 9, 'Capsize', 0, 'LineWidth', 2.5);

            


    end
end

for cond = 1:2
    for t = 1:3
        
% INPUT
% Produce equal length columns for each bin by padding with NaNs:
% Store the columns in a cell array
cols = {GPIASVAL{cond}{t}{1}, GPIASVAL{cond}{t}{2}, GPIASVAL{cond}{t}{3}, GPIASVAL{cond}{t}{4}};
% Find the maximum length
maxLen = max(cellfun(@length, cols));
% Pad each column with NaNs to match the maximum length
for i = 1:length(cols)
    cols{i} = [cols{i}; NaN(maxLen - length(cols{i}), 1)];
end
% Convert the padded columns back into a matrix (if desired)
y = horzcat(cols{:});
% Produce x values
x = repmat([1, 2, 3, 4], length(cols{i}), 1);

% FITTING
% Remove NaNs from x and y
validIndices = ~isnan(x) & ~isnan(y);  % Identify rows where neither x nor y are NaN
x_valid = x(validIndices);  % Filter x
y_valid = y(validIndices);  % Filter y

% Fit a linear polynomial (degree 1) to the valid data
p = polyfit(x_valid, y_valid, 1);  % p will contain the slope and intercept of the line

y_fitted = polyval(p, x); % Evaluating the fit using the coefficients


 % plot fitted line
%    p = plot(cx(cond)+tx(t)+bin,GPIASVAL{cond}{t}{bin},'o','Color',cmap(t,:),'linewidth',1.5,'Markersize',4);
   x_input = [cx(cond)+tx(t)+1 cx(cond)+tx(t)+2 cx(cond)+tx(t)+3 cx(cond)+tx(t)+4];
   plot(x_input, mean(y_fitted), ':','linewidth',2.5,'Color', [0 0 0]); % Fitted line in red



    end
end




xlim([0 33])
ylim([0 1.65])

XticksA = [1 2 3 4 6 7 8 9 11 12 13 14]; XticksB = XticksA+17;
xticks([XticksA XticksB])
xticklabels({'';'';'';''})
% a = get(gca,'XTickLabel');  
% set(gca,'XTickLabel',a,'fontsize',8,'FontWeight','normal')
% xtickangle(30)

maint = 'Bin*Time*Cond';
title({maint},'FontSize',14)
box off
set(gca,'linewidth',1.5,'FontSize',14)
xlabel('Control                            6hSD')
ylabel('GPIAS rate')
% legend([p1 p2 p3],'Pre','Post 1w','Post 6w','Location','Northwest')

% savepath = 'D:\...

if dosave == 1
% print ...
end


