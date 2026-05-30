%% Loads ABR data and plots related Figures.

% User input defines which protocol to analyse (tonesR, tonesL, clicksR,
%clicksR), which channel (L or R), which condition (ctrl or sd), which time
%(pre or post NOE) and which animal. Run first section of script to load
%ABR data, compute the response measures mentioned below. Run the sections below the intial loop to
%plot the various response measures (e.g. peak latency).

% Response measures:
% - Cont: RMS (area under the plot)
% - Cont: RMS (slope of regression line) 
% - Cont: First peak magnitude
% - Cont: First peak latency 


clear all
close all
% savepath = 'D:\tinnitus_project\mice\Final_group\ABRs\Figures\'
% variablespath = 'D:\tinnitus_project\mice\Final_group\ABRs\variables\'

doplot = 0; % to plot individual traces
doplot90db = 0; % to plot 90db traces only
savetable = 0; % to save peak mag and lat diff SPSS table

display 'START'
for cond = 1:2
    
if cond == 1; group = 'Ctrl'; elseif cond == 2; group = 'SD'; end
    
savevar = 0; % save variables for plotting startle/ABR correlations yes or no

% clicks SD
        dpA = [-27 nan 1 24 39 56]; % list with start of window for respective peaks
        dpB = [-10 nan 23 38 55 76]; % list with ends of window for respective peaks
        

%user input -----
if group(1) == 'C'
IDs = ['Afour';'Bfour';'Dfour';'Efour';'Gfour';'Ifour'];

path = 'D:\...'; % Important: path to inoput data 'Data_group1'
savepath = 'D:\...'; % saving destination for figures
tablepath = 'D:\...'; % saving destination for tables


else
IDs = ['Afive';'Bfive';'Dfive';'Efive';'Ffive';'Gfive';'Hfive';'Ifive'] ;
% % checked up to Ffive
% IDs = ['Bfive'] ;
path = 'D:\...'; % Important: path to inoput data 'Data_group2'
savepath = 'D:\...';
tablepath = 'D:\...';

end

% ------- user input
% First:
freqlist = [20]; % 1,2,4,8,16K or 20 for clicks
% Second: 
% Specifiy prdgm below [ 1 2 3 4]
% -----------------



paradigm = ['tonesL';'tonesR';'clickL';'clickR']; %[ 1 2 3 4]
channelcode = {'Left';'Right'};

lastpk = 6; % last peak to plot (example: lastpk = 4 plots peaks 1,2,3,4)

plotall = 1;
savetraces =0; %to save plots of ABR traces
savethreshold = 0; %to save plots with ABR thresholds pre and post NOE
SaveThresholdChange = 0;
% ---------------
   
% file details
for Nmouse = 1:size(IDs,1)
%     close all
    for time = 1:2 %1:2
for    prdgm = 4 %1:4 % 2for tonesR, 4 for clickR
for ch = 2 %1 for left electrode, 2 for right electrode
    clear rawtable raw
    
    if prdgm == 1 || prdgm == 2
        intlist = [9 8 7 6 5 4 3 2]; % ints for tones
    elseif prdgm == 3 || prdgm == 4
        intlist = [9 8 7 6 5 4 ]; % ints for clicks [9 8 7 6 5 4 ]
    end

%load file
if time == 1
  if group(1) == 'C'
    rawtable = readtable([path 'DataBL\BL_txtFiles\' num2str(IDs(Nmouse,:)) '_' num2str(paradigm(prdgm,:)) '.txt']);
    inputfile = [path 'DataBL\BL_txtFiles\' num2str(IDs(Nmouse,:)) '_' num2str(paradigm(prdgm,:)) '.txt'];


  else
%     rawtable = readtable([path 'BL\' num2str(IDs(Nmouse,:)) '_' num2str(paradigm(prdgm,:)) '_BL.txt']);
    inputfile = [path 'BL\' num2str(IDs(Nmouse,:)) '_' num2str(paradigm(prdgm,:)) '_BL.txt'];

  end
elseif time == 2
    if group(1) == 'C'
%     rawtable = readtable([path 'Data_postNOE\PN_txtfiles\' num2str(IDs(Nmouse,:)) '_pNOE_' num2str(paradigm(prdgm,:)) '.txt']);
    inputfile = [path 'Data_postNOE\PN_txtfiles\' num2str(IDs(Nmouse,:)) '_pNOE_' num2str(paradigm(prdgm,:)) '.txt'];

    else
%     rawtable = readtable([path 'postNOE\' num2str(IDs(Nmouse,:)) '_' num2str(paradigm(prdgm,:)) '_pNOE.txt']);
    inputfile = [path 'postNOE\' num2str(IDs(Nmouse,:)) '_' num2str(paradigm(prdgm,:)) '_pNOE.txt'];

    end
end

% load selected file
opts = detectImportOptions(inputfile);
opts = setvartype(opts, ['ABRGroupHeader__________________________________'], 'string');  %or 'char' if you prefer
opts.DataLines(1) = 1; % set beginning of data to line 1 (so the entire file is loaded)
rawtable = readtable(inputfile, opts);
%convert to array
raw = table2array(rawtable);


% find indexes for level
clear idx index
idx{9} = find(strcmp(raw, 'Att = 0 dB'));
idx{8} = find(strcmp(raw, 'Att = 10 dB'));
idx{7} = find(strcmp(raw, 'Att = 20 dB'));
idx{6} = find(strcmp(raw, 'Att = 30 dB'));
idx{5} = find(strcmp(raw, 'Att = 40 dB'));
idx{4} = find(strcmp(raw, 'Att = 50 dB'));
idx{3} = find(strcmp(raw, 'Att = 60 dB')); % for tones
idx{2} = find(strcmp(raw, 'Att = 70 dB')); % for tones

% find index for level and frequency
clear index
if prdgm == 1 || prdgm == 2
    for int = intlist
        fcount = 1;
        for freq = [1 2 4 8 16] % 1 2 4 8 16K sound frequency
        index{freq}{int} = idx{int}(fcount:fcount+1);
        fcount = fcount+2; %go to value corresponding to next higher freq in idx vector
        end
    end
elseif prdgm == 3 || prdgm == 4
    for int = intlist
        fcount = 1;
        for freq = [20] % 1 2 4 8 16K sound frequency, or 20 for clicks
        index{freq}{int} = idx{int}(fcount:fcount+1);
        fcount = fcount+2; %go to value corresponding to next higher freq in idx vector
        end
    end
end


for freq = freqlist

% Define plot input matrix
if prdgm == 1 || prdgm == 2 % for tones
    dpoints = length(25:268);
elseif prdgm == 3 || prdgm == 4 % for clicks
    dpoints = length(24:267);
end

clear metaL metaR MetaL MetaR 
% extract ABR trace for each sound level
for int = intlist
    for t = 1:dpoints % number of datapoints per ABRS trace
        if prdgm == 1 || prdgm == 2 % for tones
            metaL{freq}(int,:) = raw( (index{freq}{int}(1)+3) : (index{freq}{int}(1)+2+dpoints) )';
            metaR{freq}(int,:) = raw( (index{freq}{int}(2)+3) : (index{freq}{int}(2)+2+dpoints) )';
        elseif prdgm == 3 || prdgm == 4 % for clicks
            metaL{freq}(int,:) = raw( (index{freq}{int}(1)+1) : (index{freq}{int}(1)+dpoints) )';
            metaR{freq}(int,:) = raw( (index{freq}{int}(2)+1) : (index{freq}{int}(2)+dpoints) )';
        end
    end
    % convert to numerical 
    for x = 1:length(metaL{freq}(int,:))
    MetaL{freq}(int,x) = str2num( cell2mat(metaL{freq}(int,x)) );
    MetaR{freq}(int,x) = str2num( cell2mat(metaR{freq}(int,x)) );

    end
end

colourmap = [0 0.7 0.7];



%% define input values
% to do: compute per freq

% define if R or L 
clear input
if ch == 2 
input{freq} = MetaR{freq};
elseif ch == 1
    input{freq} = MetaL{freq};
end


%% ABR trace
% test to find out minimal plotting input needed
close all
figure; hold all
for cint = [9 8 7 6 5 4 3]
    
% ptest{cint} = plot(input{freq}(cint,:)+cint/200000,'-','linewidth',1.5,'Color',colourmap*(cint/10) ); %ABR trace
ptest{cint} = plot(input{freq}(cint,:)+cint/200000,'-','linewidth',1.5,'Color','b' ); %ABR trace

end

            set(gca,'linewidth',1,'Fontsize',10)
            xlabel('ms')
            ylabel('Intensity (dB)')
            yticks([2:9]/200000)
            yticklabels({'20';'30';'40';'50';'60';'70';'80';'90'})
            xticks([25:25:250])
            xticklabels({'1';'2';'3';'4';'5';'6';'7';'8';'9';'10'})
pause

%% find peaks & throughs
% between datapoints 25-75 

%find local maxima magnitude and locations
clear pks locs trs...
    all_ons_locs all_ons_pks ons_locs ons_pks idx_prepk idx_postpk thr_locs thr_mag...
    loc_mxpk var
    
    


%%  

    intcl = [ 0 3 6 9 12 15 18 21 24]; % indicators for shifting response window per intensity, relative to highest intesnity
    c=0; % intesnity counter
for int = intlist 
    c = c+1;
    intc = intcl(c);
    % find magnitude and location of all local peaks
    [pks{int},locs{int}] = findpeaks(input{freq}(int,:));
     
    % find magnitude and location of all local throughs
    [trs_meta{int},locs_trs{int}] = findpeaks(-input{freq}(int,:));
    trs{int} = -trs_meta{int}; %reverse negative values again
    
    % DEFINE VARIRABLITY VECTOR
%     var(int) = std(input{freq}(int,1:40)); % fixed: baseline of the trace
    var(int) = std(input{freq}(36+intc:96+intc)); % moving window: response window
    
 

    %---
    % FIRST PEAK
    % select peaks in expected response window (FIRST pos. peak)
%     metapkidx = find(locs{int}<=65 & locs{int}>= 40 ); % ixd of peak
%     locations in window used for threshold detection (18/08/21)

%     metapkidx = find(locs{int}<= 66+intc & locs{int}>= 36+intc ); % eff. 70 and 40; ixd of peak locations in window % old
    for peak = [2 1 3:lastpk]

%         dpA = [30 41 71 86 115]; % list with start of window for respective peaks
%         dpB = [40 51 81 101 125]; % list with ends of window for respective peaks

        % clicks CTRL
%         dpA = [-19 nan 11 27 42 66]; % list with start of window for respective peaks
%         dpB = [-15 nan 24 41 63 76]; % list with ends of window for respective peaks
        
        if peak == 2 % find second peak in given window
%            metapkidx = find(locs{int}<= 55+intc & locs{int}>= 45+intc ); 
           metapkidx = find(locs{int}<= 65+intc & locs{int}>= 40+intc ); % previously 45, 060921

        else % find other peaks rel. to second peak
            try
            metapkidx = find(locs{int}<= loc_mxpk{2}{int}+dpB(peak)+intc & locs{int}>= loc_mxpk{2}{int}+dpA(peak)+intc ); 
            end
        end
 
%  metapkidx
 
    % predefine meta matrixes
    ons_locs{int} = [];
    ons_peaks{int} = [];
    all_ons_locs{int} = [];
    all_ons_pks{int} = [];
    
    for n = 1:length(metapkidx) 
    all_ons_locs{int}(n) = locs{int}(metapkidx(n)); % peak locations in window
    all_ons_pks{int}(n) = pks{int}(metapkidx(n)); % peak magnitude in window
    end  
  
        
    
    % --- exclude 'early' peaks, rel. to correspnding high int. responses ---
    if int == 9 % for highest intensity
    ons_locs{int} = all_ons_locs{int}; % peak locations in window
    ons_pks{int} = all_ons_pks{int}; % peak magnitude in window
    end
    
    if int < 9 % for lower intensities
        for n = 1:length(metapkidx) 
            if isempty(loc_mxpk{peak}{int+1}) % check if higher int has a response
                continue                %...if not, ignore current peak
            else
               if all_ons_locs{int}(n) < loc_mxpk{peak}{int+1}-1 % also ignore peak if it is earlier than higher intensity peak,
                                                           % granting a 'buffer' of 3 dp
                 ons_locs{int}(n) = nan; % peak locations in window
                 ons_pks{int}(n) = nan; % peak magnitude in window
                   continue
               else ons_locs{int}(n) = locs{int}(metapkidx(n)); % peak locations in window
                 ons_pks{int}(n) = pks{int}(metapkidx(n)); % peak magnitude in window
               end
            end
        end
    end
    
    % --- find peak ---
    % Find magnitude and location of peak closest to corresponding peak for
    % the pre condtion (for highest intesntity, 90 dB) or corresponding to the next higher intesnity
    % within the same condtion for intesnity below 90 dB. 
    
    % Highest intesnity (90dB)
    if time == 2 && int == 9
        % select peak closest to PRE NOE peak
        try
        pkmetdiff = abs( ons_locs{int}-pklat_raw{cond}{peak}{Nmouse}{1}{freq}(ch,int) );
        mxpk{peak}{int} = ons_pks{int} (find(pkmetdiff == min(pkmetdiff)));
        loc_mxpk{peak}{int} = ons_locs{int}(find( ons_pks{int} == mxpk{peak}{int} ));
           % if there is no corresponding peak detected in the pre
           % condtion,accept detected peak by default
           if isnan(pklat_raw{cond}{peak}{Nmouse}{1}{freq}(ch,int)); mxpk{peak}{int}=ons_pks{int}; loc_mxpk{peak}{int}=ons_locs{int};end        
           % if there are two peaks with egual distance to corresp. high
           % intensity peak, pick the later one
           if length(mxpk{peak}{int})>1;  mxpk{peak}{int} =  mxpk{peak}{int}(2); loc_mxpk{peak}{int}=loc_mxpk{peak}{int}(2);
           end
        catch
            display('WARNING: PRE NOE day possibly not loaded')
        mxpk{peak}{int} = [];
        loc_mxpk{peak}{int} = [];
        end
    elseif time == 1 && int == 9
        try
    %find magnitude and location of highest peak (within 25-75 dp)
        mxpk{peak}{int} = max(ons_pks{int}); % maximum peak for this intensity
        loc_mxpk{peak}{int} = ons_locs{int}(find( ons_pks{int} == mxpk{peak}{int} )); %location of maximum peak
        catch
        mxpk{peak}{int} = [];
        loc_mxpk{peak}{int} = [];
        end
    end
    
    % Lower intensities
    if int < 9
        try
        pkmetdiff = abs(ons_locs{int}-loc_mxpk{peak}{int+1});
        mxpk{peak}{int} = ons_pks{int} (find(pkmetdiff == min(pkmetdiff)));
        loc_mxpk{peak}{int} = ons_locs{int}(find( ons_pks{int} == mxpk{peak}{int} ));
           % if there are two peaks with egual distance to corresp. high
           % intensity peak, pick the later one
           if length(mxpk{peak}{int})>1;  mxpk{peak}{int} =  mxpk{peak}{int}(2); loc_mxpk{peak}{int}=loc_mxpk{peak}{int}(2);
           end
        catch
    mxpk{peak}{int} = [];
    loc_mxpk{peak}{int} = [];
        end
    end
    
  
    
    
    % find neighbrouing throughs
    if isempty(mxpk{peak}{int}) == 1 || mxpk{peak}{int} == 0 || isnan( mxpk{peak}{int})
       thr_locs{peak}(int,:) = [ 0 0 ]; % if there is no defined peak, leave throughs data empty
       thr_mag{peak}(int,:) = [0 0 ];
    else
        idx_prepk = find (locs_trs{int} < loc_mxpk{peak}{int});
        idx_postpk = find (locs_trs{int} > loc_mxpk{peak}{int});
          if isempty(idx_prepk); trh_locsA = nan; thr_magA = nan; else trh_locsA = locs_trs{int}(idx_prepk(end)); thr_magA = trs{int}(idx_prepk(end));  end
          if isempty(idx_postpk); trh_locsB = nan; thr_magB = nan; else trh_locsB = locs_trs{int}(idx_postpk(1)); thr_magB = trs{int}(idx_postpk(1)); end

        thr_locs{peak}(int,:) = [trh_locsA trh_locsB ]; % select closest throughs
        thr_mag{peak}(int,:) = [thr_magA thr_magB];
    end

    end



% ------- PLOT ------------------------------------------------------------


% figures of ABR traces with markers
if doplot ==1
   
    thresh = 'n.a.';

    hold all
    if time ==1
    title([ 'Ch' num2str(ch) ' PRE ' num2str(paradigm(prdgm,:)) ' - ' num2str(IDs(Nmouse,:)) ' - treshold ' num2str(thresh) '0 dB - ' num2str(freq) 'K'])
    else
    title([ 'Ch' num2str(ch) ' POST ' num2str(paradigm(prdgm,:)) ' - ' num2str(IDs(Nmouse,:)) ' - treshold ' num2str(thresh) '0 dB - ' num2str(freq) 'K'])
    end

    figure
    hold all;
        for peak = 1:lastpk
            for cint = [ 9 8 7 6 5 4 3 2]
                p(cint) = plot(input{freq}(cint,:)+cint/200000,'-','linewidth',1.5,'Color',colourmap*(cint/10) ); %ABR trace
            %     p(int) = plot(detrend(input{freq}(int,:))+int/200000,'-','linewidth',1.5,'Color','red' ); %ABR trace

                try
                p1(cint) = plot(loc_mxpk{peak}{cint},mxpk{peak}{cint}+cint/200000,'O','linewidth',1.5,'Color','c','MarkerSize',5 ); %primary peak
                p2(cint) = plot(thr_locs{peak}(cint,:),thr_mag{peak}(cint,:)+cint/200000,'O','linewidth',1.5,'Color','k','MarkerSize',5 ); %primary throughs
                catch;end

                %     pvar1(int) = plot([1 length(MetaR(int,:))],[var(int) var(int)]+int/200000,'--','linewidth',0.5,'Color','k' )% variance line
                 plot([1 length(input{freq}(cint,:))],[var(cint)*3 var(cint)*3]+cint/200000,'--','linewidth',0.5,'Color','k' );% variance line
                 plot([1 length(input{freq}(cint,:))],[0 0]+cint/200000,'-','linewidth',0.5,'Color','k' );% variance line

                % plot settings
            set(gca,'linewidth',1,'Fontsize',10)
            xlabel('ms')
            ylabel('Intensity (dB)')
            end


            yticks([2:9]/200000)
            yticklabels({'20';'30';'40';'50';'60';'70';'80';'90'})
            xticks([25:25:250])
            xticklabels({'1';'2';'3';'4';'5';'6';'7';'8';'9';'10'})
        end

        if savetraces == 1
            if time == 1
                 print('-r750','-dtiff',[savepath 'traces\Ch' num2str(ch) ' PRE '...
                  num2str(paradigm(prdgm,:)) ' - ' num2str(IDs(Nmouse,:)) ],'-painters');
            else
                 print('-r750','-dtiff',[savepath 'traces\Ch' num2str(ch) ' POST '...
                  num2str(paradigm(prdgm,:)) ' - ' num2str(IDs(Nmouse,:)) ],'-painters');
            end
        end

pause
close all

elseif doplot90db == 1
    
    if int == [9]
      figure
      hold all;
         % plot trace
         p(int) = plot(input{freq}(int,:)*10^6,'-','linewidth',3,'Color',[.6 .6 .6] ); % *10^6 to convert into uV
         for peak = 1:lastpk
            try
            p1(int) = plot(loc_mxpk{peak}{int},mxpk{peak}{int}*10^6,'O','linewidth',2,'Color',[0 1 0],'MarkerSize',8,'markerfacecolor',[0 1 0] ); %primary peak
            p2(int) = plot(thr_locs{peak}(int,:),thr_mag{peak}(int,:)*10^6,'O','linewidth',2,'Color',[0 .5 0],'MarkerSize',8,'markerfacecolor',[0 .5 0] ); %primary throughs
            catch;end
        
            % plot settings
            set(gca,'linewidth',1,'Fontsize',10)
            set(gca,'linewidth',1.5,'Fontsize',14)
            xlabel('Time (ms)')
            ylabel('Voltage (μV)')
         end
%     yticks([2:9]/200000)
%     yticklabels({'20';'30';'40';'50';'60';'70';'80';'90'})
    xticks([25:25:250])
    xticklabels({'1';'2';'3';'4';'5';'6';'7';'8';'9';'10'})
%     ylim([-3 3])
    
    if time ==1
    title([ 'Ch' num2str(ch) ' PRE ' num2str(paradigm(prdgm,:)) ' - ' num2str(IDs(Nmouse,:)) '-' num2str(freq) 'K'])
    else
    title([ 'Ch' num2str(ch) ' POST ' num2str(paradigm(prdgm,:)) ' - ' num2str(IDs(Nmouse,:)) '-' num2str(freq) 'K'])
    end
    
        if savetraces == 1
            if time == 1
                 print('-r750','-dtiff',[savepath 'Ch' num2str(ch) ' PRE '...
                  num2str(paradigm(prdgm,:)) ' - 90dB - ' num2str(IDs(Nmouse,:)) ],'-painters');
            else
                 print('-r750','-dtiff',[savepath 'Ch' num2str(ch) ' POST '...
                  num2str(paradigm(prdgm,:)) ' - 90db - ' num2str(IDs(Nmouse,:)) ],'-painters');
            end
        end
    
    pause
    close all
    end
    
  

end





     for peak = 1:6
        %% Peak latency 
        % Important: don't convert pklat_raw to ms here, as BL pklat_raw is used to
        % define peakes in Post1!
        
        for int = intlist 
            if isempty(loc_mxpk{peak}{int}); pklat_raw{cond}{peak}{Nmouse}{time}{freq}(ch,int) = nan;
            else
            pklat_raw{cond}{peak}{Nmouse}{time}{freq}(ch,int) = loc_mxpk{peak}{int};   
            end 
            

           % Save converted pklat seperately 
           pklat{cond}{peak}{Nmouse}{time}{freq}(ch,int) = pklat_raw{cond}{peak}{Nmouse}{time}{freq}(ch,int)/25;
            
            
        end
        
        

        %% Calculate peak magnitude

        % do this in intial loop
        % in this section, plot peak magnitude vs intensity

        % use first detected peak and 2nd detected through
        display(['Producing PKMAG for peak...' num2str(peak)])
        for int = intlist
            if isempty(mxpk{peak}{int}-thr_mag{peak}(int,2)); pkmag_raw{cond}{peak}{Nmouse}{time}{freq}(ch,int) = 0;
            else
            pkmag_raw{cond}{peak}{Nmouse}{time}{freq}(ch,int) = (mxpk{peak}{int}-thr_mag{peak}(int,2)); 
            end
            if int == 9 &&  isnan( pkmag_raw{cond}{peak}{Nmouse}{time}{freq}(ch,int) );
                display(' ---- NaN detected in PKmag - leave keyboard via dbquit command')
                keyboard
            end
            % convert into micro V
            pkmag{cond}{peak}{Nmouse}{time}{freq}(ch,int) = pkmag_raw{cond}{peak}{Nmouse}{time}{freq}(ch,int)*10^6;
        end

        %% Calculate RMS for each intensity

        % range 30 - 200 seems to include the whole response (Afour 90 dB)
        % start w range 40 - 100, but shift it by 4 for every intensity
        if prdgm == 2 || prdgm == 4
            rmsintc = 0;
            for int = intlist
                rmsintc = rmsintc +4;
            rmslvl_ClR_raw{cond}{Nmouse}{time}{freq}(ch, int) = rms(input{freq}(int,36+rmsintc:96+rmsintc)); % *10^6 to convert to micro V --- EDIT
           % convert to MicroV
            rmslvl_ClR{cond}{Nmouse}{time}{freq}(ch, int) = rmslvl_ClR_raw{cond}{Nmouse}{time}{freq}(ch, int)*10^6;
            end
        elseif prdgm == 1 || prdgm == 3
                    rmsintc = 0;
            for int = intlist
                    rmsintc = rmsintc +4;
            rmslvl_ClL_raw{cond}{Nmouse}{time}{freq}(ch, int) = rms(input{freq}(int,36+rmsintc:96+rmsintc))*10^6; % --- EDIT
            % convert to MicroV
            rmslvl_ClL{cond}{Nmouse}{time}{freq}(ch, int) = rmslvl_ClL_raw{cond}{Nmouse}{time}{freq}(ch, int)*10^6;
            end
        end
     end


end

% THRESHOLD - based on 5 peaks

%based on magnitude of detected peaks
thresh = 9;
for peak = 1:5
    for int = intlist
        crit = 3*var(int); % threshold criterium based on variance of response window

        if isempty(mxpk{peak}{int}) % if no peak detected, keep prev intensity as threshold
        else if int < thresh... % if peak detected and current intesnity is lower then current treshold...
                && mxpk{peak}{int}-thr_mag{peak}(int,1)>= crit || mxpk{peak}{int}-thr_mag{peak}(int,2)>= crit % ...and if peak is high enough
                thresh = int; % ...take current intensity as threshold
             end    
        end       
    end
end

threshold{Nmouse}{time}{freq}(ch) = thresh;

hold all
if time ==1
title([ 'Ch' num2str(ch) ' PRE ' num2str(paradigm(prdgm,:)) ' - ' num2str(IDs(Nmouse,:)) ' - treshold ' num2str(thresh) '0 dB - ' num2str(freq) 'K'])
else
title([ 'Ch' num2str(ch) ' POST ' num2str(paradigm(prdgm,:)) ' - ' num2str(IDs(Nmouse,:)) ' - treshold ' num2str(thresh) '0 dB - ' num2str(freq) 'K'])
end

end
end
end
    end
end

end

% compute peak magnitude differences
for cond = 1:2
        if cond == 1; mousen =6; elseif cond==2, mousen =8; end

    for Nmouse = 1:mousen

        y2 = [];
        x = [1:5]; % peaks

        % calculate ratio post/pre
        clear pre post d Ratio 
        for peak = 1:5
            pre(peak) = pkmag{cond}{peak}{Nmouse}{1}{freq}(ch,9); % peak magnitude pre
            post(peak) = pkmag{cond}{peak}{Nmouse}{2}{freq}(ch,9); % post
                
            % for boxplot
            d(peak) = post(peak)-pre(peak);
            Bdelta{cond}(Nmouse,peak) = d(peak);

        end


        Delta{cond}{Nmouse}(1,:) = pre;
        Delta{cond}{Nmouse}(2,:) = post;
        Delta{cond}{Nmouse}(3,:) = d;



    end
end
%compute peak latency ratios
for cond = 1:2
        if cond == 1; mousen =6; elseif cond==2, mousen =8; end

    for Nmouse = 1:mousen

        y2 = [];
        x = [1:5]; % peaks

         % calculate ratio post/pre
        clear pre post d Ratio 
        for peak = 1:5
            pre(peak) = pklat{cond}{peak}{Nmouse}{1}{freq}(ch,9); % peak magnitude pre
            post(peak) = pklat{cond}{peak}{Nmouse}{2}{freq}(ch,9); % post
                
            % for boxplot
            d(peak) = post(peak)-pre(peak);
            BLatdelta{cond}(Nmouse,peak) = d(peak);
            
%             if isnan(BLatdelta{cond}(Nmouse,peak))
%                 display('PKlatdelta is NAN')
%                 keyboard
%             end

        end


        Delta{cond}{Nmouse}(1,:) = pre;
        Delta{cond}{Nmouse}(2,:) = post;
        Delta{cond}{Nmouse}(3,:) = d;

    end
end


PKMAG=[];peakID=[];ID=[];COND=[];PKLAT=[];

for cond = 1:2
    for peak = 1:5
        if cond==1; IDprim=0; nmouse = 6; elseif cond == 2; IDprim=6; nmouse = 8; end % mouse ID primer for continuous labels across both groups
            for Nmouse = 1:nmouse
                clear input1 input2
                input1 = Bdelta{cond}(Nmouse,peak); % Peak mag
                input2 = BLatdelta{cond}(Nmouse,peak); % Peak lat

              PKMAG = [PKMAG; input1];
              PKLAT = [PKLAT; input2];
              peakID = [peakID; peak];
              ID = [ID; [Nmouse+IDprim] ];
              COND = [COND; cond ];

            end
    end
end


% Construct SPSS table (defferences)
VpeakData = [ID PKMAG PKLAT peakID COND log(PKMAG) log(PKLAT)];
Vpeak_table = array2table(VpeakData); % convert to table
Vpeak_table.Properties.VariableNames(1:7) = {'ID','PKMAG_diff','PKLAT_diff','peakID','COND','PKMAG_ln','PKLAT_ln'}; % name the columns
 
if savetable == 1
% writetable(Vpeak_table,[tablepath 'TinnitusMice_VpeakDifferences' num2str(freq) 'K_CH' num2str(ch) '.xlsx']) % convert table to .xlsx file
end



%% Q-Q plots

close all
figure(10)
ylim([0 4.5])
qqplot(VpeakData(:,2))
title('Q-Q plot on raw ABR Vpeak data')

figure(11)
% log 10 transomfred
qqplot(log10( VpeakData(:,2)) )
ylim([-1 1])
title('Q-Q plot on log-transformed ABR Vpeak data')

figure(11)
% ln transformed
qqplot(log( VpeakData(:,2)))
ylim([-6 4])
xlim([-4 4])

title('Q-Q plot on log-transformed ABR Vpeak data')


set(gca,'linewidth',1.5,'fontsize',14)

% savepath = ...
% print(figure(10),'-r750','-dtiff',[savepath 'GPIAS_Q-Qplot_alldata.tiff'],'-painters');


%% sort for SPSS

% peak magnitude I-V
pkmag{cond}{peak}{Nmouse}{time}{freq}(ch,int)
PKMAG=[];peakID=[];TIME=[];ID=[];COND=[];PKLAT=[];

for t = 1:2
    for cond = 1:2
        for peak = 1:5
            if cond==1; IDprim=0; nmouse = 6; elseif cond == 2; IDprim=6; ; nmouse = 8; end % mouse ID primer for continuous labels across both groups
                for Nmouse = 1:nmouse
                    clear input
                    input1 = pkmag{cond}{peak}{Nmouse}{t}{freq}(ch,9);
                    input2 = pklat{cond}{peak}{Nmouse}{t}{freq}(ch,9);

                  PKMAG = [PKMAG; input1];
                  PKLAT = [PKLAT; input2];
                  peakID = [peakID; peak];
                  TIME = [TIME; t];
                  ID = [ID; [Nmouse+IDprim] ];
                  COND = [COND; cond ];

                end
        end
    end
end

% Construct SPSS table
VpeakData2 = [ID PKMAG PKLAT peakID TIME COND];

% Add a column for peakmag where zeros are replaced by 0.001
idx0 = find(PKMAG == 0);
PKMAG_NoZeros = PKMAG;
PKMAG_NoZeros(idx0) = 0.01;

VpeakData2 = [ID PKMAG PKLAT peakID TIME COND PKMAG_NoZeros];


Vpeak_table2 = array2table(VpeakData2); % convert to table
Vpeak_table2.Properties.VariableNames(1:7) = {'AnimalID','WaveMag','WaveLat','WaveID','TIME','CONDITION','WaveMag_NoZeros'}; % name the columns

if savetable == 1
writetable(Vpeak_table2,[tablepath 'TinnitusMice_Vpeak' num2str(freq) 'K_CH' num2str(ch) '.xlsx']) % convert table to .xlsx file
end




    %% FIG. 7,9A:  Plot peak magnitudes I to V for 90dB - pre vs post - Ctrl & SD
    
    % dosave = 1
    dosave = 0
close all
figure; hold all
cmap = [.5 .5 1;1 .5 .5; 0.9 0.6 0.3 ]; % colourmap
x_input = [1:5; 1.4:5.4]-0.26; % x coordinates
for cond = 1:2
    if cond == 1; mousen =6; elseif cond==2, mousen =8; end
    for Nmouse = 1:mousen
        y1 = [];
        y2 = [];
        x = x_input(cond,:); % peaks
        for peak = 1:5
        y1 =[y1 pkmag{cond}{peak}{Nmouse}{1}{freq}(ch,9)];
        y2 = [y2 pkmag{cond}{peak}{Nmouse}{2}{freq}(ch,9)];
        end

         % plot connection lines
         for n = 1:length(y1)
            if cond == 1; l1 = plot([x(n) x(n)+0.2], [y1(n) y2(n)], '-k','linewidth',1.5,'markersize',1,'Color',[.6 .6 .6]);
            elseif cond == 2; l2 = plot([x(n) x(n)+0.2], [y1(n) y2(n)], '-k','linewidth',1.5,'markersize',1,'Color',[.2 .2 .2]);
            end
         end

        % plot pre & post values
        % pre NOE peaks
        p1 = plot(x, y1, 'O','color',cmap(1,:),'linewidth',2,'markersize',3.5,'markerfacecolor',cmap(1,:));
        % post NOE peaks
        p2 = plot(x+0.2, y2, 'O','color',cmap(2,:),'linewidth',2,'markersize',3.5,'markerfacecolor',cmap(2,:));

    end
end

% plot settings
xlim([0 6])
set(gca,'linewidth',1.2,'fontsize',15)
xticks([1:5]); 
xticklabels({'I';'II';'III';'IV';'V'}); 
xlabel(['Wave No'])
ylabel(['Wave magnitude (μV)'])
legend([l1 l2 p1 p2 ],'Control','SD','BL','Post1w')
title([ 'Ch' num2str(ch) ' - ' num2str(paradigm(prdgm,:)) ' - ' num2str(freq) 'K - ' group ])
grid on

if dosave == 1
        print('-r750','-dtiff',[savepath 'FIGA_5Peaks_Magnitude_CtrlvsSD_' num2str(channelcode{ch})...
        'Ear_' paradigm(prdgm,:) '_' num2str(freq) 'K'],'-painters');
end

  
    %%  FIG 7,9B: Plot peak magnitudes I to V for 90dB - changes (differences)
%   Ctrl & SD

    % dosave = 1
    % dosave = 0
    
% close all
figure(11); hold all

Markers = {'+','o','*','x','v','d','^','s','>','<'};

for cond = 1:2
        if cond == 1; mousen =6; elseif cond==2, mousen =8; end

    for Nmouse = 1:mousen

        y2 = [];
        x = [1:5]; % peaks

        % calculate differences post/pre
        clear pre post d Ratio 
        for peak = 1:5
            pre(peak) = pkmag{cond}{peak}{Nmouse}{1}{freq}(ch,9); % peak magnitude pre
            post(peak) = pkmag{cond}{peak}{Nmouse}{2}{freq}(ch,9); % post
                
            % for boxplot
            d(peak) = post(peak)-pre(peak);
            Bdelta{cond}(Nmouse,peak) = d(peak);

        end


        Delta{cond}{Nmouse}(1,:) = pre;
        Delta{cond}{Nmouse}(2,:) = post;
        Delta{cond}{Nmouse}(3,:) = d;


        % plot
        if cond == 1
%           p1 = plot(x, Delta{cond}{Nmouse}(3,:),[strcat(Markers{Nmouse})],'Color',[.6 .6 .6],'linewidth',1,'markerfacecolor',[.6 .6 .6]);
          p1 = plot(x, Delta{cond}{Nmouse}(3,:),'o','Color',[.6 .6 .6],'linewidth',1,'markersize',5,'markerfacecolor',[.6 .6 .6]);

        elseif cond ==2
%           p2 = plot(x+0.2, Delta{cond}{Nmouse}(3,:),[strcat(Markers{Nmouse})],'Color',[.2 .2 .2],'linewidth',1,'markerfacecolor',[.2 .2 .2]);
          p2 = plot(x+0.2, Delta{cond}{Nmouse}(3,:),'o','Color',[.2 .2 .2],'linewidth',1,'markersize',5,'markerfacecolor',[.2 .2 .2]);

        end

    end
end

for peak = 1:5
    % box plot
      b1 = boxplot(Bdelta{1}(:,peak),'Position',[peak],'Colors','k','Widths',0.2,'Whisker',0,'Symbol','');
      b2 = boxplot(Bdelta{2}(:,peak),'Position',[peak+0.2],'Colors','k','Widths',0.2,'Whisker',0,'Symbol','');
       set([b1 b2],{'linew'},{1.3})
end

% Sig markers
if freq == 8
    % Wave III, p=0,026
    plot([2.9 3.3], [.9 .9],'-k','linewidth',1.2) % line (wave I, BL to post2)
%     plot(mean([1 1.7]), 230, '*k','Markersize',7,'linewidth',1.1) % marker1
end
      

l1 = plot([0 6], [0 0], '--k','linewidth',1);

% set(gca, 'YScale', 'log')
box off
    xlim([0 6])
%      ylim([-2*10^-6 2*10^-6])
       ylim([-2 2])

    set(gca,'linewidth',1.2,'fontsize',15)
    xticks([1:5]); 
    xticklabels({'I';'II';'III';'IV';'V'}); 
    xlabel(['Wave No'])
    ylabel(['Wave magnitude Post-BL (μV)'])
    legend([p1 p2],'Control','SD')
    title([ 'Ch' num2str(ch) ' - ' num2str(paradigm(prdgm,:)) ' - ' num2str(freq) 'K - SD&Ctrl'])
    grid on
    
    A = Bdelta{1}(:,1);
    B = Bdelta{2}(:,1);
    [P H] = ranksum(A,B)
    grid on
    

if dosave == 1
         print(figure(11),'-r750','-dtiff',[savepath 'FIGB_5PeakMagnitude_Differences_CtrlcsSD_'...
         num2str(channelcode{ch}) 'Ear_' paradigm(prdgm,:) '_' num2str(freq) 'K'],'-painters');
end



  %% FIG. 7,9C: Plot peak latencies I to V for 90dB - pre vs post - Ctrl&SD

   % dosave = 1
    dosave = 0

cmap = [.5 .5 1;1 .5 .5; 0.9 0.6 0.3 ]; % colourmap
% close all
figure(10); hold all
x_input = [1:5; 1.4:5.4]-0.26; % x coordinates
for cond = 1:2
    if cond == 1; mousen =6; elseif cond==2, mousen =8; end
    for Nmouse = 1:mousen
        y1 = [];
        y2 = [];
        y125 = [];
        y225 = [];
        x = x_input(cond,:); % peaks
        for peak = 1:5
        y1 =[y1 pklat{cond}{peak}{Nmouse}{1}{freq}(ch,9)];
        y2 = [y2 pklat{cond}{peak}{Nmouse}{2}{freq}(ch,9)];
        
%         y125 =[y125 pklat2{cond}{peak}{Nmouse}{1}{freq}(ch,9)];
%         y225 = [y225 pklat2{cond}{peak}{Nmouse}{2}{freq}(ch,9)];
        end

         % plot connection lines
         for n = 1:length(y1)
            if cond == 1; l1 = plot([x(n) x(n)+0.2], [y1(n) y2(n)], '-k','linewidth',1.5,'markersize',1,'Color',[.6 .6 .6]);
            elseif cond == 2; l2 = plot([x(n) x(n)+0.2], [y1(n) y2(n)], '-k','linewidth',1.5,'markersize',1,'Color',[.2 .2 .2]);
            end
         end

        % plot pre & post values
        % pre NOE peaks
        p1 = plot(x, y1, 'O','color',cmap(1,:),'linewidth',2,'markersize',3.5,'markerfacecolor',cmap(1,:));
        % post NOE peaks
        p2 = plot(x+0.2, y2, 'O','color',cmap(2,:),'linewidth',2,'markersize',3.5,'markerfacecolor',cmap(2,:));

    end
end

% plot settings
xlim([0 6])
 ylim([1 5])

set(gca,'linewidth',1.2,'fontsize',15)
xticks([1:5]); 
xticklabels({'I';'II';'III';'IV';'V'}); 
xlabel(['Wave No'])
ylabel(['Wave latency (ms)'])
grid on
% legend([l1 l2 p1 p2 ],'Ctrl','SD','pre','post','location','southeast')

title([ 'Ch' num2str(ch) ' - ' num2str(paradigm(prdgm,:)) ' - ' num2str(freq) 'K' ])
    

if dosave ==1
        print(figure(10),'-r750','-dtiff',[savepath 'FIGC_5PeakLatency_CtrlcsSD_'...
        num2str(channelcode{ch}) 'Ear_' paradigm(prdgm,:) '_' num2str(freq) 'K'],'-painters');
end
%% FIG. 7,9 D : Peak latencies - differences (Ctrl & SD)
% close all

% dosave = 1
% dosave = 0

close all
figure(11); hold all

Markers = {'+','o','*','x','v','d','^','s','>','<'};

for cond = 1:2
        if cond == 1; mousen =6; elseif cond==2, mousen =8; end

    for Nmouse = 1:mousen

        y2 = [];
        x = [1:5]; % peaks

        % calculate ratio post/pre
        % calculate differences post/pre
        clear pre post d Ratio 
        for peak = 1:5
            pre(peak) = pklat{cond}{peak}{Nmouse}{1}{freq}(ch,9); % peak magnitude pre
            post(peak) = pklat{cond}{peak}{Nmouse}{2}{freq}(ch,9); % post
                
            % for boxplot
            d(peak) = post(peak)-pre(peak);
            Blatdelta{cond}(Nmouse,peak) = d(peak);

        end


        Delta{cond}{Nmouse}(1,:) = pre;
        Delta{cond}{Nmouse}(2,:) = post;
        Delta{cond}{Nmouse}(3,:) = d;

        % plot
        if cond == 1
%           p1 = plot(x, Delta{cond}{Nmouse}(3,:),[strcat(Markers{Nmouse})],'Color',[.5 .5 .5],'linewidth',1.5);
          p1 = plot(x, Delta{cond}{Nmouse}(3,:),'o','Color',[.6 .6 .6],'linewidth',1,'markersize',5,'markerfacecolor',[.6 .6 .6]);

        elseif cond ==2
%           p2 = plot(x+0.2, Delta{cond}{Nmouse}(3,:),[strcat(Markers{Nmouse})],'Color',[0 0 0],'linewidth',1.5);
          p2 = plot(x+0.2, Delta{cond}{Nmouse}(3,:),'o','Color',[.2 .2 .2],'markersize',1,'markersize',5,'markerfacecolor',[.2 .2 .2]);

        end

    end
end

for peak = 1:5
    % box plot
      b1 = boxplot(Blatdelta{1}(:,peak),'Position',[peak],'Colors','k','Widths',0.2,'Whisker',0,'Symbol','');
      b2 = boxplot(Blatdelta{2}(:,peak),'Position',[peak+0.2],'Colors','k','Widths',0.2,'Whisker',0,'Symbol','');
      set([b1 b2],{'linew'},{1.3})
end
      

l1 = plot([0 6], [0 0], '--k','linewidth',1);

% Sig markers
if freq == 8
    % Wave III, p<0.001
    plot([.9 1.3], [.9 .9],'-k','linewidth',1.2) % line (wave I, BL to post2)
     plot(mean([.9 1.3])-0.07, 1, '*k','Markersize',7,'linewidth',1.1) % marker1
     plot(mean([.9 1.3])+0.07, 1, '*k','Markersize',7,'linewidth',1.1) % marker2

end

% set(gca, 'YScale', 'log')
box off
    xlim([0 6])
    ylim([-1 1])
    if freq == 8
            ylim([-2 2])
    end
    set(gca,'linewidth',1.2,'fontsize',15)
    xticks([1:5]); 
    xticklabels({'I';'II';'III';'IV';'V'}); 
    xlabel(['Wave No'])
    ylabel(['Wave latency Post-BL (ms)'])
%       legend([p1 p2],'Ctrl','SD')
      legend off
    title([ 'Ch' num2str(ch) ' - ' num2str(paradigm(prdgm,:)) ' - ' num2str(freq) 'K - SD&Ctrl'])
    grid on

if dosave == 1
        print(figure(11),'-r750','-dtiff',[savepath 'FigD_5PeakLatency_Differences_CtrlcsSD_'...
        num2str(channelcode{ch}) 'Ear_' paradigm(prdgm,:) '_' num2str(freq) 'K'],'-painters');
end
 
%% response modulation analysis


%% Plot peak latency, total signal magnitude and RMS - slope & area
peak = 2

dosave =0
% dosave = 1;
% dosave = 0;
% savepath = ...




% pklat{cond}{peak}{Nmouse}{time}{freq}(ch,int)
% consider excluding peak for 40 dB, as often not present
ylabels = {'Peak latency','Peak magnitude (μV)','RMS'};
for c = 2 %1:3
    close all
    clear y1 y2 nanidx1 nanidx2 ints 
    for cond = 1 %1:2
        if cond == 1; IDl = 6; elseif cond ==2; IDl=8; end
         display(['IDl is' num2str(IDl)])
        for Nmouse = 5 %1:IDl

        if c == 1 % Peak latency
        y1 = pklat{cond}{peak}{Nmouse}{1}{freq}(ch,intlist(end):9); % time 1
        y2 = pklat{cond}{peak}{Nmouse}{2}{freq}(ch,intlist(end):9); % time 2
        elseif c == 2 % Peak magnitude
        y1 = pkmag{cond}{peak}{Nmouse}{1}{freq}(ch,intlist(end):9); % *10^6 for conversi9on into micro V
        y2 = pkmag{cond}{peak}{Nmouse}{2}{freq}(ch,intlist(end):9);
        elseif c== 3 % RMS
        y1 = rmslvl_ClR{cond}{Nmouse}{1}{freq}(ch,intlist(end):9);
        y2 = rmslvl_ClR{cond}{Nmouse}{2}{freq}(ch,intlist(end):9);
        end
        
       

        ints = [intlist(end)*10:10:90];
        
       
        % exclude NaNs and crop vectors accordingly (make them comparable)
        nanidx1 = find(isnan(y1)==1); %find nans
        nanidx2 = find(isnan(y2)==1); %find nans
        y1([nanidx1 nanidx2])=[]; %crop
        y2([nanidx1 nanidx2])=[];%crop
        ints([nanidx1 nanidx2])=[];%crop
        
        % Excluding outliers & replace with values within average 
          % INCLUDE CRITERION: if any value is larger than the both
          % orevious ones, consider outlier
%         for n =1:length(y1)-2
%             if y1(n) > mean(y1)+ std(y1); % outlier if value larger than average+std
%                     try y1(n)=mean([y1(n-1) y1(n+1)]); catch y1(n)=0; end ;
%             elseif n == 1 || n==2 || n==3 || n==4 || n==5 || n==6
%                 if y1(n)> y1(end) % outlier if value is larger than 90dB response
%                     try y1(n)=mean([y1(n-1) y1(n+1)]); catch y1(n)=0; end ;
%                 end
%             elseif n == 1 || n==2 || n==3 || n==4
%                 if y1(n)> mean(y1) % outlier if low intensity response is larger than average of trace
%                     try y1(n)=mean([y1(n-1) y1(n+1)]); catch y1(n)=0; end ;
%                 end
%             end
%         end
%         for n =1:length(y2)-2
%             if y2(n) > mean(y2)+ std(y2);
%                     try y2(n)=mean([y2(n-1) y2(n+1)]); catch y2(n)=0; end ;
%             elseif n == 1 || n==2 || n==3 || n==4 || n==5 || n==6
%                 if y2(n)> y2(end) % outlier if value is larger than 90dB response
%                     try y2(n)=mean([y2(n-1) y2(n+1)]); catch y2(n)=0; end ;
%                 end
%             elseif n == 1 || n==2 || n==3 || n==4
%                 if y2(n)> mean(y2) % outlier if low intensity response is larger than average of trace
%                     try y2(n)=mean([y2(n-1) y1(n+2)]); catch y1(n)=0; end ;
%                 end
%             end
%         end
        

          outidx1 = []; outidx2 = [];
        for n =[length(y1)-2]:-1:1
            if y1(n) > y1(n+1) % outlier if value larger than average+std
                    try y1(n)=mean([y1(n-1) y1(n+1)]); catch y1(n)=y1(n+1); end 
                    outidx1 = [outidx1 n];
            end
        end
         for n =[length(y1)-2]:-1:1
            if y2(n) > y2(n+1) % outlier if value larger than average+std
                    try y2(n)=mean([y2(n-1) y2(n+1)]); catch y2(n)=y2(n+1); end 
                    outidx2 = [outidx2 n];
            end
        end
        

        % SLOPES
        
        % PANEL 1 - BL only
         % pre NOE 
            clear slope1 slope 2 intercept1 intercept2
            figure; hold all
            p1 = plot(ints, y1, '-Ob','color',[.5 .5 1],'linewidth',2);
            % mark outliers & replacements
            po1 = plot(ints(outidx1), y1(outidx1), 'Og','linewidth',2);


            [fit1] = polyfit(ints,y1,1); % polyfit. linear
            slope1 = fit1(1);
            intercept1 = fit1(2);
            fy1 = [slope1*min(ints)+intercept1 slope1*max(ints)+intercept1];
            plot([min(ints) max(ints)],fy1,':','color',[.5 .5 1],'linewidth',3);
            
             % plot settings
                legend([p1],'BL','location','northwest')
                set(gca,'linewidth',1.5,'fontsize',14)
                xticks([40:10:90]); 
                xlabel(['Sound level (dB)'])
                ylabel(ylabels{c})
                
                if dosave == 1
                    %  print
                print(figure(1),'-r750','-dtiff',[savepath 'PeakIISlope_BL_example_'...
                    num2str(channelcode{ch}) 'Ear_' paradigm(prdgm,:) '_' num2str(freq)...
                    'K_mouse' num2str(Nmouse) '_Cond' num2str(cond)],'-painters');
                end

            
         % PANEL 2 - BL and Post
            % pre NOE 
            clear slope1 slope 2 intercept1 intercept2
            figure; hold all
            p1 = plot(ints, y1, '-Ob','color',[.5 .5 1],'linewidth',2);
            % mark outliers & replacements
            po1 = plot(ints(outidx1), y1(outidx1), 'Og','linewidth',2);


            [fit1] = polyfit(ints,y1,1); % polyfit. linear
            slope1 = fit1(1);
            intercept1 = fit1(2);
            fy1 = [slope1*min(ints)+intercept1 slope1*max(ints)+intercept1];
            plot([min(ints) max(ints)],fy1,':','color',[.5 .5 1],'linewidth',3);

            % post NOE 
            p2 = plot(ints, y2, '-O','color',[1 .5 .5],'linewidth',2);
            % mark outliers & replacements
            po1 = plot(ints(outidx1), y1(outidx1), 'Og','linewidth',2);

            [fit2] = polyfit(ints,y2,1); % polyfit, linear
            slope2 = fit2(1);
            intercept2 = fit2(2);
            fy2 = [slope2*min(ints)+intercept2 slope2*max(ints)+intercept2];
            plot([min(ints) max(ints)],fy2,':','color',[1 .5 .5],'linewidth',3);
                % plot settings
                legend([p1 p2],'BL','Post1w','location','northwest')
                set(gca,'linewidth',1.5,'fontsize',14)
                xticks([40:10:90]); 
                xlabel(['Sound level (dB)'])
                ylabel(ylabels{c})
                
                if dosave == 1
                    %  print
                print(figure(2),'-r750','-dtiff',[savepath 'PeakIISlope_BL&Post_example_'...
                    num2str(channelcode{ch}) 'Ear_' paradigm(prdgm,:) '_' num2str(freq)...
                    'K_mouse' num2str(Nmouse) '_Cond' num2str(cond)],'-painters');
                end

            % save slope value for pre and post
            Out_slope{c}{cond}{ch}{freq}(Nmouse,1)= slope1;
            Out_slope{c}{cond}{ch}{freq}(Nmouse,2)= slope2;

%             slope ratio post/pre 
            if slope2/slope1 < 0 % EXCLUSION CRITERION
            Outsloperat{c}{cond}(Nmouse,ch)=nan;
            else
            Outsloperat{c}{cond}(Nmouse,ch)= slope2/slope1;
            end

        % AREA BELOW PLOT
            % polygon envelopes
            % x values
            ints_env_frame=[90 80 70 60 50 40 30 20];
            ints_env_A = ints_env_frame(1:length(y1)); ints_env_B = ints_env_A(end);
            ints_env = [ints_env_A ints_env_B];
            % y values
            y1_env = [zeros(1,length(y1)) y1(1)];
            y2_env = [zeros(1,length(y2)) y2(1)];

            % plot polygons
            % PANEL 3 - area BL and Post
            figure;hold all

            plot([ints ints_env],[y1 y1_env],'O-','color',[.5 .5 1],'linewidth',2)
            plot([ints ints_env],[y2 y2_env],'O-r','color',[1 .5 .5],'linewidth',2)
            
                 % colour in the area
                a = area(ints,y1);
                a.FaceAlpha = 0.2; a.FaceColor = [.5 .5 1];
                b = area(ints,y2);
                b.FaceAlpha = 0.2; b.FaceColor = [1 .5 .5];

            % area under plots
            Out_area{c}{cond}{1}(Nmouse,ch) = polyarea([y1 y1_env],[ints ints_env]);
            Out_area{c}{cond}{2}(Nmouse,ch) = polyarea([y2 y2_env],[ints ints_env]);

            if slope2/slope1 < 0 % EXCLUSION CRITERION
            Outarrat{c}{cond}(Nmouse,ch) = nan;
            Outardiff{c}{cond}(Nmouse,ch) = nan;
            else
%             ratio post / pre
            Outarrat{c}{cond}(Nmouse,ch) = Out_area{c}{cond}{2}(Nmouse,ch)/Out_area{c}{cond}{1}(Nmouse,ch);
%             difference post - pre
            Outardiff{c}{cond}(Nmouse,ch) = Out_area{c}{cond}{2}(Nmouse,ch)-Out_area{c}{cond}{1}(Nmouse,ch);
            end

                % plot settings
                set(gca,'linewidth',1.5,'fontsize',14)
                xticks([40:10:90]); 
                xlabel(['Sound level (dB)'])
                ylabel(ylabels{c})
                legend([p1 p2],'BL','Post1','location','northwest')
                
                if dosave == 1
                    %  print
                print(figure(3),'-r750','-dtiff',[savepath 'PeakIIArea_example_'...
                    num2str(channelcode{ch}) 'Ear_' paradigm(prdgm,:) '_' num2str(freq)...
                    'K_mouse' num2str(Nmouse) '_Cond' num2str(cond)],'-painters');
                end


        end
        
        
    % Exlude Extreme Outliers ( +/- 2 sdt around mean)
    clear crit
    critpos = mean(Outsloperat{c}{cond}(:,2))+2*std(Outsloperat{c}{cond}(:,2));
    critneg = mean(Outsloperat{c}{cond}(:,2))-2*std(Outsloperat{c}{cond}(:,2));
    for ii = 1:Nmouse
        if critneg > Outsloperat{c}{cond}(ii,2) || Outsloperat{c}{cond}(ii,2) > critpos
            Outsloperat_ex{c}{cond}(ii,2) = nan;
        else
            Outsloperat_ex{c}{cond}(ii,2) = Outsloperat{c}{cond}(ii,2);

        end
    end
    % Exlude Extreme Outliers ( +/- 1 sdt around mean)
    clear crit
    critpos = mean(Outarrat{c}{cond}(:,2))+2*std(Outarrat{c}{cond}(:,2));
    critneg = mean(Outarrat{c}{cond}(:,2))-2*std(Outarrat{c}{cond}(:,2));
    for ii = 1:Nmouse
        if critneg > Outarrat{c}{cond}(ii,2) || Outarrat{c}{cond}(ii,2) > critpos
            Outarrat_ex{c}{cond}(ii,2) = nan;
        else
            Outarrat_ex{c}{cond}(ii,2) = Outarrat{c}{cond}(ii,2);

        end
    end
        
        
    
    end
    
end



% Generate SPSS table
% Factors: condtion, pkltslope, pkltarrat, pklatarrdiff
%                    pkmagslope, pkmagarrat, pkmagardiff
%                    RMSslope,RMSarrat, RMSardiff

display('line 1102')

COND = [];PKLTslope = [];PKLTarrat = [];PKLTardiff = [];PKmagslope = [];PKMagarrat = [];PKMAGarrdiff = [];
RMSslope = [];RMSarrat = [];RMSdiff = [];

for cond = 1:2
COND = [COND; ones(size(Outsloperat_ex{c}{cond}(:,ch),1),1)*cond];
PKLTslope = [PKLTslope; Outsloperat_ex{1}{cond}(:,ch)];
PKLTarrat = [PKLTarrat; Outarrat_ex{1}{cond}(:,ch)];
% PKLTardiff = [PKLTardiff; Outardiff{1}{cond}(:,ch)];

PKmagslope = [PKmagslope; Outsloperat_ex{2}{cond}(:,ch)];
PKMagarrat = [PKMagarrat; Outarrat_ex{2}{cond}(:,ch)];
% PKMAGarrdiff = [PKMAGarrdiff; Outardiff{2}{cond}(:,ch)];

RMSslope = [RMSslope; Outsloperat_ex{3}{cond}(:,ch)];
RMSarrat = [RMSarrat; Outarrat_ex{3}{cond}(:,ch)];
% RMSdiff = [RMSdiff; Outardiff{3}{cond}(:,ch)];
end
ID = [1:14]';

ABRdyn = [ID COND PKLTslope*100 PKmagslope*100 PKMagarrat*100 ...
RMSslope*100 RMSarrat*100 ];

% Construct SPSS table
% Table with pre/post ratios?

% ABRdyn = [ID COND PKLTslope PKmagslope PKMagarrat RMSslope RMSarrat];
ABRdyn_table = array2table(ABRdyn); % convert to table
ABRdyn_table.Properties.VariableNames(1:7) = {'ID','COND', 'PKLTslope', 'PKmagslope', 'PKMagarrat',...
'RMSslope', 'RMSarrat'}; % name the columns
 
if savetable == 1
writetable(ABRdyn_table,[tablepath 'TinnitusMice_ABRdynamics_'...
                          num2str(freq) 'K_CH' num2str(ch) '.xlsx']) % convert table to .xlsx file
end
%% ABR dynamics: plot ratios


close all; clear P H
IDX1 = find(ABRdyn(:,2)==1);
IDX2 = find(ABRdyn(:,2)==2);
ct = 0;STDs = [];
xc = [1 3 5 7 9 11 13]-1;
for m = [3 4 6 7 9 10] % choose target: [ID COND PKLTslope(3) PKLTarrat(4) PKLTardiff(5) 
                                          % PKmagslope(6) PKMagarrat(7)  PKMAGarrdiff(8) 
                                          % RMSslope(9) RMSarrat(10) RMSdiff(11)]
    ct = ct+1;
    
    ploty1 = ABRdyn(IDX1,m);
    ploty2 = ABRdyn(IDX2,m);
    
    STDs = [STDs std(ABRdyn(IDX1,m)) std(ABRdyn(IDX2,m))  ];
    [P(ct) H(ct)] = ranksum(ABRdyn(IDX1,m),ABRdyn(IDX2,m))

figure(10); hold all
% line at 1
plot([0 14],[1 1],':k','linewidth',1.5)
% main plot
plot([1]+xc(ct),[ploty1],'O','Color',[.6 .6 .6],'Markersize',5,'linewidth',2)
plot([1.7]+xc(ct),[ploty2],'O','Color',[.4 .4 .4],'Markersize',5,'linewidth',2)
% box plot
b1 = boxplot([ploty1],'positions',[1]+xc(ct),'Colors','k','Widths',0.35,'Whisker',0,'Symbol','');
b2 = boxplot([ploty2],'positions',[1.7]+xc(ct),'Colors','k','Widths',0.35,'Whisker',0,'Symbol','');
set([b1 b2],'linewidth',1.5)
% means
plot([1 1.7]+xc(ct),[nanmean(ploty1) nanmean(ploty2)],'O-','Color','k','Markersize',8,'linewidth',2)

xlim([0 14])
ylim([0 10])

end
xticks([1.35 3.35 5.35 7.35 9.35 11.35])
xticklabels({'Latency (slope)','Latency (area)','Magnitude (slope)','Magnitude (area)','RMS (slope)','RMS (area)'});
xtickangle(15)
set(gca, 'YScale', 'log')
ylabel('Ratio (post/pre)')
set(gca,'linewidth',1.5,'fontsize',14);
    a = get(gca,'XTickLabel');
    set(gca,'XTickLabel',a,'fontsize',10,'FontWeight','normal')   
    b = get(gca,'YLabel'); 
    b.FontSize = 14; 
ax.color = 'k';
% title([ num2str(channelcode{ch}) 'Ear ' paradigm(prdgm,:) ' ' num2str(freq) 'K'])
box off
ylim([0.4 3])

p1=plot([1]+xc(ct),[ploty1(1)],'O','Color',[.6 .6 .6],'Markersize',5,'linewidth',2);
p2=plot([1.75]+xc(ct),[ploty2(1)],'O','Color',[.4 .4 .4],'Markersize',5,'linewidth',2);
legend([p1 p2],'Ctrl','SD')

% savepath = ...
% print(figure(10),'-r750','-dtiff',[savepath 'Ratios_preANDpost_CtrlANDSD_'...
%         num2str(channelcode{ch}) 'Ear_' paradigm(prdgm,:) '_' num2str(freq) 'K'],'-painters');

%% ABR dynamics: plot ratios (Modulation)

% To do: plot pre-post values, plot changes (ratios), exclude outliers (?), stats for chnages
% (ranksum in matlab?)

% dosave = 1;
 dosave = 0;
% savepath = ...

close all; clear P H
IDX1 = find(ABRdyn(:,2)==1);
IDX2 = find(ABRdyn(:,2)==2);
ct = 0;STDs = [];
xc = [1 3 5 7 9 11 13]-1;

figure(10); hold all

% horizontal line at 100 %
plot([0 7],[100 100],'--k','linewidth',1)

% ABRdyn_table = {'ID','COND', 'PKLTslope', 'PKmagslope', 'PKMagarrat','RMSslope', 'RMSarrat'}

for m = [3 4 6] % choose target: [ID COND PKLTslope(3) 
                                          % PKmagslope(4) PKMagarrat(5)  
                                          % RMSslope(6) RMSarrat(7) ]
    ct = ct+1;
    
    ploty1 = ABRdyn(IDX1,m);
    ploty2 = ABRdyn(IDX2,m);
    
    STDs = [STDs std(ABRdyn(IDX1,m)) std(ABRdyn(IDX2,m))  ];
    [P(ct) H(ct)] = ranksum(ABRdyn(IDX1,m),ABRdyn(IDX2,m))


% main plot
plot([1]+xc(ct),[ploty1],'O','Color',[.6 .6 .6],'Markersize',5,'linewidth',2,'markerfacecolor',[.6 .6 .6])
plot([1.7]+xc(ct),[ploty2],'O','Color',[.2 .2 .2],'Markersize',5,'linewidth',2,'markerfacecolor',[.2 .2 .2])
% box plot
b1 = boxplot([ploty1],'positions',[1]+xc(ct),'Colors','k','Widths',0.4,'Whisker',0,'Symbol','');
b2 = boxplot([ploty2],'positions',[1.7]+xc(ct),'Colors','k','Widths',0.4,'Whisker',0,'Symbol','');
set([b1 b2],'linewidth',1.5)
% means
plot([1 1.7]+xc(ct),[nanmean(ploty1) nanmean(ploty2)],'O-','Color','k','Markersize',8,'linewidth',2)


end




xticks([1.35 3.35 5.35])
xticklabels({'Wave II latency','Wave II magnitude','RMS'});
xtickangle(15)
set(gca, 'YScale', 'log')
ylabel(['Modulation by sound level'; '       (% of BL)         '])
set(gca,'linewidth',1.5,'fontsize',14);
    a = get(gca,'XTickLabel');
    set(gca,'XTickLabel',a,'fontsize',12,'FontWeight','normal')   
    b = get(gca,'YLabel'); 
    b.FontSize = 14; 
ax.color = 'k';
% title([ num2str(channelcode{ch}) 'Ear ' paradigm(prdgm,:) ' ' num2str(freq) 'K'])
box off

 ylim([40 400])
if freq == 16
      ylim([10 1000])
end

if freq == 8
 ylim([1 4000])
end

xlim([0 7])

% Sig markers
if freq == 8
    % Latency Mod., p=0.008
    plot([1 1.7], [350 350],'-k','linewidth',1) % line (wave I, BL to post2)
end


p1=plot([1]+xc(ct),[ploty1(1)],'O','Color',[.6 .6 .6],'Markersize',5,'linewidth',2,'markerfacecolor',[.6 .6 .6]);
p2=plot([1.7]+xc(ct),[ploty2(1)],'O','Color',[.2 .2 .2],'Markersize',5,'linewidth',2,'markerfacecolor',[.2 .2 .2]);
legend([p1 p2],'Control','SD')

if dosave ==1
    print(figure(10),'-r750','-dtiff',[savepath 'ABR-Modulation_preANDpost_CtrlANDSD_'...
        num2str(channelcode{ch}) 'Ear_' paradigm(prdgm,:) '_' num2str(freq) 'K'],'-painters');
end

    
%% Fig. 8 A,B: ABR dynamics: plot ratios (Total magnitude)


close all; clear P H
IDX1 = find(ABRdyn(:,2)==1);
IDX2 = find(ABRdyn(:,2)==2);
ct = 0;STDs = [];
xc = [1 3 5 7 9 11 13]-1;

figure(10); hold all

% horizontal line at 100 %
plot([0 7],[100 100],'--k','linewidth',1)

for m = [5 7] % choose target: [ID COND PKLTslope(3) 
                                          % PKmagslope(4) PKMagarrat(5)  
                                          % RMSslope(6) RMSarrat(7) ]
    ct = ct+1;
    
    ploty1 = ABRdyn(IDX1,m);
    ploty2 = ABRdyn(IDX2,m);
    
    STDs = [STDs std(ABRdyn(IDX1,m)) std(ABRdyn(IDX2,m))  ];
    [P(ct) H(ct)] = ranksum(ABRdyn(IDX1,m),ABRdyn(IDX2,m))


% main plot
plot([1]+xc(ct),[ploty1],'O','Color',[.6 .6 .6],'Markersize',5,'linewidth',2,'markerfacecolor',[.6 .6 .6])
plot([1.7]+xc(ct),[ploty2],'O','Color',[.2 .2 .2],'Markersize',5,'linewidth',2,'markerfacecolor',[.2 .2 .2])
% box plot
b1 = boxplot([ploty1],'positions',[1]+xc(ct),'Colors','k','Widths',0.5,'Whisker',0,'Symbol','');
b2 = boxplot([ploty2],'positions',[1.7]+xc(ct),'Colors','k','Widths',0.5,'Whisker',0,'Symbol','');
set([b1 b2],'linewidth',1.5)
% means
plot([1 1.7]+xc(ct),[nanmean(ploty1) nanmean(ploty2)],'O-','Color','k','Markersize',8,'linewidth',2)


end

% Sig markers
% if freq == 20
%     % Wave II, p=0.011
% plot([1 1.7], [220 220],'-k','linewidth',1) % line (wave I, BL to post2)
% %     plot(mean([1 1.7])-0.06, 240, '*k','Markersize',7,'linewidth',1.1) % marker1
% %     plot(mean([1 1.7])+0.06, 240, '*k','Markersize',7,'linewidth',1.1) % marker1
% elseif freq == 8
%     % Wave II, p=0.008
%     plot([1 1.7], [220 220],'-k','linewidth',1) % line (wave I, BL to post2)
%     plot(mean([1 1.7]), 235, '*k','Markersize',7,'linewidth',1.1) % marker1
% 
% 
% end
    

xticks([1.35 3.35])
xticklabels({'Wave II','RMS'});
% xtickangle(15)
set(gca, 'YScale', 'log')
ylabel(['Total signal magnitude'; '       (% of BL)      '])
set(gca,'linewidth',1.5,'fontsize',14);
    a = get(gca,'XTickLabel');
    set(gca,'XTickLabel',a,'fontsize',12,'FontWeight','normal')   
    b = get(gca,'YLabel'); 
    b.FontSize = 14; 
ax.color = 'k';
% title([ num2str(channelcode{ch}) 'Ear ' paradigm(prdgm,:) ' ' num2str(freq) 'K'])
box off
ylim([10 300])
xlim([0 5])

if freq == 16
      ylim([10 1000])
 end


p1=plot([1]+xc(ct),[ploty1(1)],'O','Color',[.6 .6 .6],'Markersize',5,'linewidth',2,'markerfacecolor',[.6 .6 .6]);
p2=plot([1.7]+xc(ct),[ploty2(1)],'O','Color',[.2 .2 .2],'Markersize',5,'linewidth',2,'markerfacecolor',[.2 .2 .2]);
legend([p1 p2],'Control','SD')

if dosave == 1
print(figure(10),'-r750','-dtiff',[savepath 'ABR_TotalMagnitude_preANDpost_CtrlANDSD_'...
        num2str(channelcode{ch}) 'Ear_' paradigm(prdgm,:) '_' num2str(freq) 'K'],'-painters');
end
    

%% ABR dynamics: Contruct matrix with pre and post values

% Out_area{c}{cond}{1}(Nmouse,ch)

ID = []; TIME = []; COND = [];PKLTslope = [];PKLTar = [];PKMGslope = [];PKMGar = [];
RMSslope = [];RMSar = [];

for t = 1:2
    for cond = 1:2
    COND = [COND; ones(size(Out_area{c}{cond}{t}(:,ch),1),1)*cond];
    TIME = [TIME; ones(size(Out_area{c}{cond}{t}(:,ch),1),1)*t];
    ID = [ID; [1:size(Out_area{c}{cond}{t}(:,ch),1)]' ];

    PKLTslope = [PKLTslope; Out_slope{1}{cond}{ch}{freq}(:,t)];
    PKLTar = [PKLTar; Out_area{1}{cond}{t}(:,ch)];
    
    PKMGslope = [PKMGslope; Out_slope{2}{cond}{ch}{freq}(:,t)];
    PKMGar = [PKMGar; Out_area{2}{cond}{t}(:,ch)];
    
    RMSslope = [RMSslope; Out_slope{3}{cond}{ch}{freq}(:,t)];
    RMSar = [RMSar; Out_area{3}{cond}{t}(:,ch)];

    end
end

% Construct SPSS table
ABRdynpp = [ID TIME COND PKLTslope PKLTar PKMGslope PKMGar  RMSslope RMSar];
ABRdynpp_table = array2table(ABRdynpp); % convert to table
ABRdynpp_table.Properties.VariableNames(1:9) = {'ID','COND','Time','PKLTslope', 'PKLTarrat', 'PKmagslope', 'PKMagarrat',...
'RMSslope', 'RMSarrat'}; % name the columns

%%  ABR dyanmics: plot pre & post values
close all
IDX1c = find(ABRdynpp(:,2)==1 & ABRdynpp(:,3)==1 ); % time 1 and cond 1
IDX2c = find(ABRdynpp(:,2)==2 & ABRdynpp(:,3)==1 ); % time 2 and cond 1
IDX1sd = find(ABRdynpp(:,2)==1 & ABRdynpp(:,3)==2 ); % time 1 and cond 2
IDX2sd = find(ABRdynpp(:,2)==2 & ABRdynpp(:,3)==2 );

cmap = [.5 .5 1; 1 .5 .5];

labellist = {'ID','COND','Time','Peak latency (slope)', 'Peak latency (area)', 'Peak magnitude (slope)', 'Peak magnitude (area)',...
'RMS (slope)', 'RMS (area)'};

for m = 4:9
    figure; hold all
  
%     plot([1 1.5],[ABRdynpp(IDX1c,m) ABRdynpp(IDX2c,m)],'o','color',cmap(1,:),'linewidth',2,'markersize',7)
%     plot([2 2.5],[ABRdynpp(IDX1sd,m) ABRdynpp(IDX2sd,m)],'o','color',cmap(2,:),'linewidth',2,'markersize',7)
    
    plot([1],[ABRdynpp(IDX1c,m)],'o','color',cmap(1,:),'linewidth',2,'markersize',7) % plot time 1 for ctrl
    plot([1.5],[ABRdynpp(IDX2c,m)],'o','color',cmap(2,:),'linewidth',2,'markersize',7) % plot time 2 for ctrl
    plot([2],[ABRdynpp(IDX1sd,m)],'o','color',cmap(1,:),'linewidth',2,'markersize',7) % plot time 1 for SD
    plot([2.5],[ABRdynpp(IDX2sd,m)],'o','color',cmap(2,:),'linewidth',2,'markersize',7) % plot time 2 SD
    
    plot([1 1.5],[ABRdynpp(IDX1c,m) ABRdynpp(IDX2c,m)],'-k','linewidth',1.5) % line
    plot([2 2.5],[ABRdynpp(IDX1sd,m) ABRdynpp(IDX2sd,m)],'-k','linewidth',1.5) % line

    if m ==4
    % legend plots
    p1 = plot([1],[ABRdynpp(IDX1c(1),m)],'o','color',cmap(1,:),'linewidth',2,'markersize',7);
    p2 = plot([1.5],[ABRdynpp(IDX2c(1),m)],'ok','color',cmap(2,:),'linewidth',2,'markersize',7);
    legend([p1 p2],'Pre','Post 1w','location','southwest')
    end
xlim([0.5 3])
xticks([1.25 2.25])
xticklabels({'Ctrl','SD'});

% set(gca, 'YScale', 'log')
% ylim([0 2])
set(gca,'linewidth',1.5,'fontsize',14);
ax.color = 'k';
ylabel(labellist{m})
% title([ num2str(channelcode{ch}) 'Ear ' paradigm(prdgm,:) ' ' num2str(freq) 'K'])
box off

% savepath = ...
% print('-r750','-dtiff',[savepath labellist{m} '_preANDpost_CtrlANDSD_'...
%         num2str(channelcode{ch}) 'Ear_' paradigm(prdgm,:) '_' num2str(freq) 'K'],'-painters');

end


    





