% EE627 Final Project - music recommender
% Project - generates a table with the statistics for test tracks
% Note: First load proj.mat to load the relevant statistics. This script is
% for generating the output table only
%clear;
close all;
%load proj.mat
outputFile = 'table.csv';

% Temporary for a quick test
%numUsers = 10;
numUsers = 20000;
tracksPerUser = 6;
% Max # Genres per track
maxGenre = 21;

%wrOut = cell(tracksPerUser*numUsers+1,2);
%wrOut(1,1:2) = {'TrackID', 'Predictor'};
tabOut = cell(tracksPerUser*numUsers+1,10);
tabOut(1,1:10) = {'userID', 'trackID', 'album', 'artist', 'num_genre_ratings', 'max', 'min', 'mean', 'variance', 'median'};
% Rules based recommendation approach
for ii = 1:numUsers
  for jj = 1:tracksPerUser
    testTrack = testSet(ii, jj+1);
    outRow = (ii-1)*tracksPerUser+jj+1;
    userIdx = testSet(ii);
    tabOut(outRow,1) = {userIdx};
    tabOut(outRow,2) = {testTrack};
    if albumHits(ii,jj) == 0
      tabOut(outRow,3) = {NaN};
    else
      tabOut(outRow,3) = {albumRating(ii,jj)};
    end
    if artistHits(ii,jj) == 0
      tabOut(outRow,4) = {NaN};
    else
      tabOut(outRow,4) = {artistRating(ii,jj)};
    end
    tabOut(outRow,5) =  {genreStat1(ii,jj)};
    tabOut(outRow,6) =  {genreStat2(ii,jj)};
    tabOut(outRow,7) =  {genreStat3(ii,jj)};
    tabOut(outRow,8) =  {genreStat4(ii,jj)};
    tabOut(outRow,9) =  {genreStat5(ii,jj)};
    tabOut(outRow,10) =  {genreStat6(ii,jj)};
  end
end

writecell(tabOut,outputFile);
