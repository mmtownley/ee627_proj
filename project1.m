% EE627 Final Project - music recommender
%clear;
close all;
% Read Data if it hasn't already been read. This takes awhile, so don't do
% this if you don't have to.  If you do, go get a cup of coffee...
%readData;
% Can also read a subset of the data - i.e. tracks only, training data only...

outputFile = 'submission.csv';

% Temporary for a quick test
%numUsers = 10;
numUsers = 20000;
tracksPerUser = 6;
hits = zeros(numUsers,tracksPerUser);
rating = zeros(numUsers,tracksPerUser);
avgRating = zeros(numUsers,tracksPerUser);
wrOut = cell(tracksPerUser*numUsers+1,2);
wrOut(1,1:2) = {'TrackID', 'Predictor'};
% Rules based recommendation approach
for ii = 1:numUsers
  testUser = testSet(ii, 1);
  
  for jj = 1:tracksPerUser
    testTrack = testSet(ii, jj+1);
    % Look up the user's rating of the track's associated album, artist,
    % and genre(s)
    % Search column 1 of track data for the track
    trackIdx = find(testTrack == trackData(:,1));
    albumID = trackData(trackIdx,2);
    % If the album ID exists, use that. If not listed under the track, then
    % just use the rest of the associated data from the track listing
    % Load associated elements (album, artist, genre(s))
    if isnan(albumID)
      assocData = trackData(trackIdx,2:end);
    else
      albumIdx = find(albumID == albumData(:,1));
      assocData = albumData(albumIdx,1:end);
    end
    % Associated data may include NaNs and -1s, so ignore those
    for kk = 1:length(assocData)
      elem = assocData(kk);
      if elem == -1
        break
      end
      if ~isnan(elem) && elem ~= -1
        searchData = [testUser, elem];
        searchRows = find(trainData(:,1) == searchData(1));
        for search = 1:length(searchRows)
          if trainData(searchRows(search),2) == searchData(2)
            hits(ii,jj) = hits(ii,jj) + 1;
      	    rating(ii,jj) = rating(ii,jj) + trainData(searchRows(search),3);
          end
        end
      end
    end
  end
  % Rank by the average rating
  avgRating(ii,:) = rating(ii,:)./hits(ii,:);
  for jj = 1:tracksPerUser
    if hits(ii,jj) == 0
      avgRating(ii,jj) = 50;
      %avgRating(ii,jj) = 25;
    end
    % Account for number of hits to skew the rankings slightly 
    % More hits skews positive ratings up and negative ratings down
    if avgRating(ii,jj) > 50
      avgRating(ii,jj) = avgRating(ii,jj) + (1e-3)*hits(ii,jj);
    else
      avgRating(ii,jj) = avgRating(ii,jj) - (1e-3)*hits(ii,jj);
    end
  end
  
  ranks = tiedrank(avgRating(ii,:));
  for jj = 1:tracksPerUser
    testTrack = testSet(ii, jj+1);
    outRow = (ii-1)*tracksPerUser+jj;
    wrOut(outRow+1,1) = {strcat(num2str(testUser),'_',num2str(testTrack))};
    if ranks(jj) > 3
      wrOut(outRow+1,2) = {'1'};
    else
      wrOut(outRow+1,2) = {'0'};
    end
  end
end

writecell(wrOut,outputFile);
