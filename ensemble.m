% Ensembling script for EE627 Final Project
% Overall idea is we read the previously made submissions, along with their
% corresponding scores, and we generate a new submission
clear;
% We specifically want to exclude duplicate submissions, as this will invalidate
% final matrix inversion
% Total # submissions, including duplicates
NumSubmissions = 46;
%NumSubmissions = 2;
% Duplicates
NumDup = 2;
K = NumSubmissions - NumDup;
DupLocs = [14, 44];
N = 120000;
% All of the submission files are not necessarily in the same order
% So read the first submission files, and establish a master order
% Once this master order is established, sort all subsequent submissions to
% match the order
subFile = "submission1.csv";
tbl = readtable(subFile);
keyList = tbl(:,1);
numTst = height(keyList);
% Table of conglomerate Data
congData = cell(numTst,K+1);
% Populate the data from submission 1 into the conglomerate table
congData(:,1) = tbl.TrackID;
congData(:,2) = table2cell(array2table(tbl.Predictor(:,1)));
% k is the index of K, of which there are no duplicates
% ii is the submission index, of which there are duplicates
k = 1;
for ii=2:NumSubmissions
  % Skip over if this is a duplicate submission
  if ismember(ii, DupLocs)
    continue
  end
  k = k + 1;
  subFile = strcat("submission",num2str(ii),".csv");
  tbl = readtable(subFile);
  % First determine if reordering is needed
  % If reordering is not needed, save off the data and continue on
  if isequal(keyList.TrackID, tbl.TrackID)
    congData(:,k+1) = table2cell(array2table(tbl.Predictor(:,1)));
    continue
  end
  % Reordering must be done
  [~,loc] = ismember(keyList.TrackID(1:N), tbl.TrackID(:));
  congData(1:numTst,k+1) = table2cell(array2table(tbl.Predictor(loc(1:numTst))));
end

% We now have the conglomerate table of all the submissions.
% So now we crunch the data
% Construct the submission matrix, which is all the conglomerate data without
% the UserID/TrackID info
S = cell2mat(congData(:, 2:end));
% Convert S from 0:1 scale to -1:+1 scale
S = 2*S-1;
P = [0.81596; 0.78725; 0.80108; 0.81517; 0.84175; 0.85545; 0.7795; 0.86254; 0.86312; 0.8635; 0.8637; 0.86112; 0.85542; 0.86345; 0.866; 0.86575; 0.86558; 0.85508; 0.85408; 0.85217; 0.85687; 0.86533; 0.866; 0.86579; 0.86612; 0.86337; 0.86541; 0.86379; 0.85854; 0.84496; 0.8662; 0.55374; 0.55395; 0.59953; 0.60966; 0.69625; 0.62421; 0.71908; 0.8507; 0.85512; 0.87279; 0.85551; 0.856; 0.85579];

stx = N*(2*P-1);
sts = inv(S'*S);
% Final S-ensemble calculation
sens = S*sts*stx;

writetable(array2table(sens), 'ensemble.csv');
