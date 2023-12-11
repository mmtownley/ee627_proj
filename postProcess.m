% EE627 Final Project - music recommender
% Project 2 - generates statistics based on the relevant genre ratings in a
% user's training data
%clear;
close all;
%load proj.mat
outputFile = 'submission.csv';

% Temporary for a quick test
%numUsers = 10;
numUsers = 20000;
tracksPerUser = 6;
% Max # Genres per track
maxGenre = 21;

%wrOut = cell(tracksPerUser*numUsers+1,2);
wrOut(1,1:2) = {'TrackID', 'Predictor'};
% Rules based recommendation approach
for ii = 1:numUsers
  % We've gathered all the stats for this user's rating for this track, so now crunch some numbers
  for jj = 1:tracksPerUser
    % Start by averaging album and artis score
    aaHits = albumHits(ii,jj) + artistHits(ii,jj); %alb/artist hits
    if aaHits > 0
      trackScore(ii,jj) = (albumRating(ii,jj) + artistRating(ii,jj))/aaHits;
    end
    % Add Max score
    trackScore(ii,jj) = trackScore(ii,jj) + 0.05*genreStat2(ii,jj);
    % Add Min score
    %trackScore(ii,jj) = trackScore(ii,jj) + 0.02*genreStat3(ii,jj);
    % Penalize a high variance
    if ~isnan(genreStat6(ii,jj))
      trackScore(ii,jj) = trackScore(ii,jj) - 0.05*genreStat6(ii,jj);
    end
    % # hits is a confidence, take distance btwn 70 and avg, and multiply by # hits
    if ~isnan(genreStat5(ii,jj))
      trackScore(ii,jj) = trackScore(ii,jj) + 0.05*genreStat1(ii,jj)*(genreStat5(ii,jj) - 70);
    end
  end
  
  ranks = tiedrank(trackScore(ii,:));
  for jj = 1:tracksPerUser
    testTrack = testSet(ii, jj+1);
    outRow = (ii-1)*tracksPerUser+jj;
    %wrOut(outRow+1,1) = {strcat(num2str(testUser),'_',num2str(testTrack))};
    if ranks(jj) > 3
      wrOut(outRow+1,2) = {'1'};
    else
      wrOut(outRow+1,2) = {'0'};
    end
  end
end

writecell(wrOut,outputFile);
