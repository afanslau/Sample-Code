

m = ceil(linspace(10,2000,20));
u = ceil(linspace(10,2000,20));
n = 3;

ntrials = 3;

avgTrainerr = zeros(length(m),ntrials);
avgTesterr = zeros(length(m),ntrials);
avgtime = zeros(length(m),ntrials);
for t = 1:ntrials
    for nm = 1:length(m)
        % Use 70% completed dataset
        r = rand(m(nm))<0.3; %Movies that were rated by users
        nk = 3;
        x = randnclust(nk,m(nm),n,0.05,repmat([0 1],n,1))'; % Use random centroids
        theta = randnclust(nk,m(nm),n,0.05,repmat([0 1],n,1))';
        y = x*theta';
        % Linearly push ratings to be between 0 and 5
        y = (y-min(min(y)))/(max(max(y))-min(min(y))) * 5;
        try
            tic;
            [predicted,trainerr,testerr] = collabFilter(r,y,n);
            elapsed = toc;
            traine = sum(sum(abs(trainerr)))/sum(sum(r));
            teste = sum(sum(abs(testerr)))/sum(sum(~r));
        catch er
            disp(er);
            traine = NaN;
            teste = NaN;
            elapsed = NaN;
        end
        avgtime(nm, t) = elapsed;
        avgTrainerr(nm, t) = traine;
        avgTesterr(nm, t) = teste;
        disp(['Trial:' num2str(t) ' Size:' num2str(m(nm)) ' Train:' num2str(traine) ' Test:' num2str(teste) ' Time:' num2str(elapsed)]);
    end
end

trialsAvgTrainE = nanmean(avgTrainerr,2);
stdTrainE = nanstd(avgTrainerr,'dim',2);
trialsAvgTestE = nanmean(avgTesterr,2);
stdTestE = nanstd(avgTesterr,'dim',2);
trialsAvgT = nanmean(avgtime,2);
stdTime = nanstd(avgtime,'dim',2);

% for t = 1:ntrials
%     subplot(2,1,1)
%     imagesc(avgerr(:,:,t).^2)
%     subplot(2,1,2)
%     imagesc(isnan(avgerr(:,:,t)))
%     M(t) = getframe;
% end
% fps = 10;
% numtimes = 5;
% movie(M,numtimes,fps)

figure
subplot(1,2,1)
errorbar(m,trialsAvgTrainE, stdTrainE)
title(['Training Error ' num2str(m(1)) '-' num2str(m(end))])
xlabel('Num Users/Movies')
ylabel('Avg Error')
axis([0 m(end) 0 1.3]);

subplot(1,2,2)
errorbar(m,trialsAvgTestE,stdTestE)
title(['Test Error ' num2str(m(1)) '-' num2str(m(end))])
xlabel('Num Users/Movies')
ylabel('Avg Error')
axis([0 m(end) 0 1.3]);

figure
errorbar(m,trialsAvgT,stdTime)
title(['Avg Elapsed Time ' num2str(m(1)) '-' num2str(m(end))])
xlabel('Num Users/Movies')
ylabel('Seconds')
axis([0 m(end) 0 6]);

set(findall(gcf,'type','text'),'fontSize',18);







