% Choose a random x and theta, produce y
% Remove some values, and use it to learn x' theta'
% Compare the error across different numbers of removed values

nm = 100;
nu = 100;
n = 5;
nk = 3;

ntrials = 5;
N = (nm*nu);
nRemoved = ceil(linspace(0,round(N*0.9),50));
percRemoved = 100.*(nRemoved./N);
percComplete = 100-percRemoved;

x = randnclust(nk,nm,n,0.05,repmat([0 1],n,1))'; % Use random centroids
theta = randnclust(nk,nu,n,0.05,repmat([0 1],n,1))';
y = x*theta';
y = (y-min(min(y)))/(max(max(y))-min(min(y))) * 5;

x2 = rand(size(x));
theta2 = rand(size(theta));
y2 = x2*theta2';
y2 = (y2-min(min(y2)))/(max(max(y2))-min(min(y2))) * 5;

% y = rand(nm,nu)*5;
% y2 = rand(nm,nu)*5;

allTrainErr = zeros(ntrials,length(nRemoved));
allTestErr = zeros(size(allTrainErr));
chanceErr = zeros(size(allTrainErr));
allTrainErr2 = zeros(ntrials,length(nRemoved));
allTestErr2 = zeros(size(allTrainErr));
chanceErr2 = zeros(size(allTrainErr));

for nt = 1:ntrials,
    nrindx = 1;
    for nr = nRemoved, 
        r = ones(nm,nu);
        % Choose nr random elements to remove
        r(randperm(nRemoved(end),nr)) = 0; 
        % Predict y by learning x theta
        [predicted,trainerr,testerr,xout,thetaout] = collabFilter(r,y,n);
        [predicted2,trainerr2,testerr2,xout2,thetaout2] = collabFilter(r,y2,n);

        % Record data and compare to choosing a random rating matrix
        allTrainErr(nt,nrindx) = sum(sum(abs(trainerr))) / sum(sum(r));
        allTestErr(nt,nrindx) = sum(sum(abs(testerr))) / sum(sum(~r));
        chanceErr(nt,nrindx) = mean(mean(abs((5*rand(size(y)) - y))));

        allTrainErr2(nt,nrindx) = sum(sum(abs(trainerr2))) / sum(sum(r));
        allTestErr2(nt,nrindx) = sum(sum(abs(testerr2))) / sum(sum(~r));
        chanceErr2(nt,nrindx) = mean(mean(abs((5*rand(size(y2)) - y2))));

        nrindx = nrindx+1;
        disp(['nr:' num2str(nr) ' nt:' num2str(nt)]);
    end
end

figure;
subplot(3,2,1);
% plot(percComplete,mean(allTrainErr),percComplete,mean(allTrainErr2));
% hold on;
errorbar(percComplete,mean(allTrainErr),std(allTrainErr),'b');
% errorbar(percComplete,mean(allTrainErr2),std(allTrainErr2),'b');
% hold off;
title('Uniform Training Error');
xlabel('Percent Complete');
ylabel('Training Error');
box off;
axis([0 100 0 2]);

subplot(3,2,2);
% plot(percComplete,mean(allTrainErr),percComplete,mean(allTrainErr2));
% hold on;
% errorbar(percComplete,mean(allTrainErr),std(allTrainErr),'b');
errorbar(percComplete,mean(allTrainErr2),std(allTrainErr2),'b');
% hold off;
title('Clustered Training Error');
xlabel('Percent Complete');
ylabel('Training Error');
box off;
axis([0 100 0 1]);

subplot(3,2,3);
% plot(percComplete,mean(allTestErr),percComplete,mean(allTestErr2));
hold on;
errorbar(percComplete,mean(allTestErr),std(allTestErr),'b');
% errorbar(percComplete,mean(allTestErr2),std(allTestErr2),'b');
hold off;
title('Test Error');
xlabel('Percent Complete');
ylabel('Test Error');
box off;
axis([0 100 0 1]);

subplot(3,2,4);
% plot(percComplete,mean(allTestErr),percComplete,mean(allTestErr2));
hold on;
% errorbar(percComplete,mean(allTestErr),std(allTestErr),'b');
errorbar(percComplete,mean(allTestErr2),std(allTestErr2),'b');
hold off;
title('Test Error');
xlabel('Percent Complete');
ylabel('Test Error');
box off;
axis([0 100 0 1]);

subplot(3,2,5);
% plot(percComplete,mean(chanceErr),percComplete,mean(chanceErr2));
% hold on;
errorbar(percComplete,mean(chanceErr),std(chanceErr),'b');
% errorbar(percComplete,mean(chanceErr2),std(chanceErr2),'b');    
% hold off;
title('Chance Error');
xlabel('Percent Complete');
ylabel('Error');
box off;
axis([0 100 0 2]);

subplot(3,2,6);
% plot(percComplete,mean(chanceErr),percComplete,mean(chanceErr2));
% hold on;
% errorbar(percComplete,mean(chanceErr),std(chanceErr),'b');
errorbar(percComplete,mean(chanceErr2),std(chanceErr2),'b');    
% hold off;
title('Chance Error');
xlabel('Percent Complete');
ylabel('Error');
box off;
axis([0 100 0 2]);

set(findall(gcf,'type','text'),'fontSize',18);


    