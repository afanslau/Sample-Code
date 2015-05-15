% Given Y,r ratings, recommend n movies for each user
ratingProb = 0.7;

nm = 500;
nu = 100;
nf = 5; % number of features
nk = 3; % number of clusters
mspread = 0.3; % std of movie features
uspread = 5*mspread; % std of user preferences

x = randnclust(nk,nm,nf,mspread,repmat([0 1],nf,1))'; % Use random centroids
theta = randnclust(nk,nu,nf,uspread,repmat([0 5],nf,1))';

Y = x*theta'; %ceil(5*rand(nm,nu));
r = ratingProb>rand(nm,nu);

nrm = 3; % number of recommended movies
[predicted,err] = collabFilter(r,Y);

% Take the predicted ratings matrix and get the predicted ratings for
% movies not yet rated
% Sort all the non-rated movies first, then sort the rated ones.
% This way if the user has seen all the movies, they will get
% recommendations from the movies they've already watched.
pNotRated = predicted + repmat(max(predicted),nm,1).*~r;
% Find the indices of the max nrm of each column (best predicted ratings of new movies per user)

[sorted,mindex] = sort(pNotRated,'descend');
recMovies = mindex(1:nrm,:)


hist(recMovies(1,:));
title('Recommended Movies');
xlabel('Movie');
ylabel('Num Users');

plot(Y(:),predicted(:),'o');