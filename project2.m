% EE627 Final Project - music recommender
% Project 2 - generates statistics based on the relevant genre ratings in a
% user's training data
%clear;
close all;
%load proj.mat
% Read Data if it hasn't already been read. This takes awhile, so don't do
% this if you don't have to.  If you do, go get a cup of coffee...
%readData;
% Can also read a subset of the data - i.e. tracks only, training data only...
outputFile = 'submission.csv';

% Temporary for a quick test
%numUsers = 10;
numUsers = 20000;
tracksPerUser = 6;
% Max # Genres per track
maxGenre = 21;
hits = zeros(numUsers,tracksPerUser);
albumHits = zeros(numUsers,tracksPerUser);
artistHits = zeros(numUsers,tracksPerUser);
rating = zeros(numUsers,tracksPerUser);
albumRating = zeros(numUsers,tracksPerUser);
artistRating = zeros(numUsers,tracksPerUser);
genreScore = zeros(numUsers,tracksPerUser);
% Note the below is not saved, a row represents a track
genreRating = zeros(tracksPerUser,maxGenre);
% Keep track of the 6 genre stats:
% # with ratings
genreStat1 = zeros(numUsers,tracksPerUser);
% max score
genreStat2 = zeros(numUsers,tracksPerUser);
% min score
genreStat3 = zeros(numUsers,tracksPerUser);
% sum score
genreStat4 = zeros(numUsers,tracksPerUser);
% avg score
genreStat5 = zeros(numUsers,tracksPerUser);
% variance
genreStat6 = zeros(numUsers,tracksPerUser);


avgRating = zeros(numUsers,tracksPerUser);
trackScore = zeros(numUsers,tracksPerUser);
wrOut = cell(tracksPerUser*numUsers+1,2);
wrOut(1,1:2) = {'TrackID', 'Predictor'};
% Rules based recommendation approach
for ii = 1:numUsers
  testUser = testSet(ii, 1);
  % Zero out the genre ratings when starting on a new user
  genreRating = zeros(tracksPerUser,maxGenre); 
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
    artistID = assocData(2);
    genreData = assocData(3:end);
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
            currRating = trainData(searchRows(search),3);
            if kk == 1
	      % album hit
	      albumHits(ii,jj) = 1;
	      albumRating(ii,jj) = currRating;
            elseif kk == 2
	      % artist hit
	      artistHits(ii,jj) = 1;
	      artistRating(ii,jj) = currRating;
            else
              % genre hit
              genreStat1(ii,jj) = genreStat1(ii,jj) + 1;
              % Update Max
              if currRating > genreStat2(ii,jj)
                genreStat2(ii,jj) = currRating;
              end
              % Update Min if this is the first hit or if rating is lower than min
              if genreStat1(ii,jj) == 1 || currRating < genreStat3(ii,jj)
                genreStat3(ii,jj) = currRating;
              end
              genreStat4(ii,jj) = genreStat4(ii,jj) + currRating;
	      % Record the current rating at this track index row and genre hit # col
	      genreRating(jj,genreStat1(ii,jj)) = currRating;
            end
            %hits(ii,jj) = hits(ii,jj) + 1;
            %rating(ii,jj) = rating(ii,jj) + trainData(searchRows(search),3);
          end
        end
      end
    end
    % For this track, generate the genre mean and var
    genreStat5(ii,jj) = mean(genreRating(jj,1:genreStat1(ii,jj)));
    genreStat6(ii,jj) = var(genreRating(jj,1:genreStat1(ii,jj)));
  end % jj - track

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
    trackScore(ii,jj) = trackScore(ii,jj) + 0.01*genreStat3(ii,jj);
    % Penalize a high variance
    if ~isnan(genreStat6(ii,jj))
      trackScore(ii,jj) = trackScore(ii,jj) - 0.04*genreStat6(ii,jj);
    end
    % # hits is a confidence, take distance btwn 70 and avg, and multiply by # hits
    if ~isnan(genreStat5(ii,jj))
      trackScore(ii,jj) = trackScore(ii,jj) + 0.03*genreStat1(ii,jj)*(genreStat5(ii,jj) - 70);
    end
  end
  
  % Rank by the average rating
  %avgRating(ii,:) = rating(ii,:)./hits(ii,:);
  %for jj = 1:tracksPerUser
  %  if hits(ii,jj) == 0
  %    %avgRating(ii,jj) = 50;
  %    avgRating(ii,jj) = 25;
  %  end
  %  % Account for number of hits to skew the rankings slightly
  %  % More hits skews positive ratings up and negative ratings down
  %  if avgRating(ii,jj) > 50
  %    avgRating(ii,jj) = avgRating(ii,jj) + (1e-3)*hits(ii,jj);
  %  else
  %    avgRating(ii,jj) = avgRating(ii,jj) - (1e-3)*hits(ii,jj);
  %  end
  %end

  ranks = tiedrank(trackScore(ii,:));
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
