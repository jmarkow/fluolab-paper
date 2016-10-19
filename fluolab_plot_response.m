% simple plot for each day's worth of feedback


% how many changes today?

[nsamples,ntrials]=size(fluo.mat);
fluo_max=max(fluo.mat);
fluo_min=min(fluo.mat);

% fluo_norm=fluo.mat./repmat(fluo_max,[nsamples 1])

%fluo_norm=fluo.mat-repmat(mean(fluo.mat')',[1 ntrials]);
%%mu=mean(zscore(fluo.mat(:,fluo.trials.catch_other))');
%fluo_norm=fluolab_vec_rej(fluo.mat,mean(fluo.mat(:,fluo.trials.catch_other)')');

padding=template.extract_options.padding;
fluo_norm=fluo.mat;
%fluo_norm=fluo.mat-repmat(mean(fluo.mat')',[1 ntrials]);
win_data=fluolab_window_data(fluo_norm,fluo.t,fluo.trials.times,fluo.trials.change_idx);
smooth_size=20;

%%

[s,f,t]=zftftb_pretty_sonogram(audio.data(:,min(fluo.trials.raw.other)),audio.fs,'len',70,'overlap',69.5,'clipping',[-5 2],'filtering',600);

load custom_colormaps;
% plot the stim times up top
ax=[];
fig.panels=figure();

ax(end+1)=axes('position',[.05 .8 .1 .15]);
imagesc(t,f./1e3,s);
set(ax(end),'view',[90 -90]);
xlim([padding(1) t(end)-padding(2)]);
ylim([0 9]);
colormap(fee_map);
axis off;

% scale bar

h=line([padding(1) padding(1)+.1],[-1 -1],'color','k');
set(h,'clipping','off');

ylimits=[.1 .5;...
    0 .4;...
    0 .1;...
    0 .15;...
    0 24];

ax(end+1)=axes('position',[.2 .8 .75 .15]);
plot(fluo.trials.times(fluo.trials.daf),'k.');
ylim([padding(1) t(end)-padding(2)]);
set(ax(end),'xtick',[],'xcolor','none','ytick',[]);

score=[];
score(1,:)=markolab_smooth(max(win_data(:,fluo.trials.daf))',smooth_size);
score(2,:)=markolab_smooth(mean(win_data(:,fluo.trials.daf))',smooth_size);
score(3,:)=markolab_smooth(std(win_data(:,fluo.trials.daf))',smooth_size);

df_score=sum(diff(score).^2);

%axis off;
ax(end+1)=axes('position',[.2 .68 .75 .1]);
plot(markolab_smooth(max(win_data(:,fluo.trials.daf))',smooth_size),'k.');
set(ax(end),'xtick',[],'xcolor','none','ytick',ylimits(1,:));
ylim(ylimits(1,:));
ylabel('Max dF/F');


ax(end+1)=axes('position',[.2 .56 .75 .1]);
plot(markolab_smooth(mean(win_data(:,fluo.trials.daf))',smooth_size),'k.');
set(ax(end),'xtick',[],'xcolor','none','ytick',ylimits(2,:));
ylim(ylimits(2,:));
ylabel('Mean dF/F');

ax(end+1)=axes('position',[.2 .44 .75 .1]);
plot(markolab_smooth(std(win_data(:,fluo.trials.daf))',smooth_size),'k.');
set(ax(end),'xtick',[],'xcolor','none','ytick',ylimits(3,:));
ylim(ylimits(3,:))
ylabel('SD dF/F');

ax(end+1)=axes('position',[.2 .3 .75 .1]);
plot(df_score,'k.');
set(ax(end),'xtick',[],'xcolor','none','ytick',ylimits(4,:));
ylim(ylimits(4,:));
ylabel('Diff. dF/F');

ax(end+1)=axes('position',[.2 .18 .75 .1]);

% plot ToD

tod=(fluo.date_number(fluo.trials.daf)-floor(fluo.date_number(1)))*24;
plot(tod,'k.');
set(ax(end),'ytick',ylimits(5,:));
linkaxes(ax(2:end),'x');
ylim(ylimits(5,:));
ylabel('ToD');

set(fig.panels,'position',[500 500 350 650],'paperpositionmode','auto');