
function funs = ReadData
    funs.readEdges=@readEdges;
    funs.readRole=@readRole;
    funs.readID=@readID;
end

%function [src1,dst1,eigenScore,eigenValueDrop,lamda1,lamda2,lamda3,lamda4,lamd5,lamda6,nlamda1,nlamda2,nlamda3,lamda5,nlamda5,nlamda6] = readEdges(filename, startRow, endRow)
function [src1,dst1,eigenScore,eigenValueDrop] = readEdges(filename, startRow, endRow)

%% Initialize variables.
delimiter = ',';
if nargin<=2
    startRow = 2;
    endRow = inf;
end

%% Format string for each line of text:
%   column1: double (%f)
%	column2: double (%f)
%   column3: double (%f)
%	column4: double (%f)
%   column5: double (%f)
%	column6: double (%f)
%   column7: double (%f)
%	column8: double (%f)
%   column9: double (%f)
%	column10: double (%f)
%   column11: double (%f)
%	column12: double (%f)
%   column13: double (%f)
%	column14: double (%f)
%   column15: double (%f)
%	column16: double (%f)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'HeaderLines', startRow(1)-1, 'ReturnOnError', false);
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'HeaderLines', startRow(block)-1, 'ReturnOnError', false);
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

%% Allocate imported array to column variable names
src1 = dataArray{:, 1};
dst1 = dataArray{:, 2};
eigenScore = dataArray{:, 3};
eigenValueDrop = dataArray{:, 4};
lamda1 = dataArray{:, 5};
lamda2 = dataArray{:, 6};
lamda3 = dataArray{:, 7};
lamda4 = dataArray{:, 8};
lamd5 = dataArray{:, 9};
lamda6 = dataArray{:, 10};
nlamda1 = dataArray{:, 11};
nlamda2 = dataArray{:, 12};
nlamda3 = dataArray{:, 13};
lamda5 = dataArray{:, 14};
nlamda5 = dataArray{:, 15};
nlamda6 = dataArray{:, 16};
end %end readEdges


function [r] = readRole(filename, nRoles, startRow, endRow)
%% Initialize variables.
if nargin<=3
    %nRoles = 5
    startRow = 1;
    endRow = inf;
end

%% Format string for each line of text:
%   column1: double (%f)
%	column2: double (%f)
%   column3: double (%f)
%	column4: double (%f)
%   column5: double (%f)
% For more information, see the TEXTSCAN documentation.
formatSpec = '';
for i=1:nRoles
    formatSpec = strcat(formatSpec, '%16f');
end
%formatSpec = '%16f%16f%16f%16f%f%[^\n\r]';
formatSpec = strcat(formatSpec, '%[^\n\r]');

%% Open the text file.
fileID = fopen(filename,'r');

dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', '', 'WhiteSpace', '', 'HeaderLines', startRow(1)-1, 'ReturnOnError', false);
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', '', 'WhiteSpace', '', 'HeaderLines', startRow(block)-1, 'ReturnOnError', false);
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

%% Allocate imported array to column variable names
nRows = size(dataArray{:, 1});
nRows = nRows(1);
class(nRows);

%r1 = dataArray{:, 1};
%r2 = dataArray{:, 2};
%r3 = dataArray{:, 3};
%r4 = dataArray{:, 4};
%r5 = dataArray{:, 5};
%r = [r1 r2 r3 r4 r5];

r = zeros(nRows, nRoles);
for i = 1: nRoles
    r(:, i) = dataArray{:, i};
end
end %readRole

function id = readID(filename, startRow, endRow)

%% Initialize variables.
delimiter = ' ';
if nargin<=2
    startRow = 1;
    endRow = inf;
end

%% Format string for each line of text:
%   column1: double (%f)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%f%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'HeaderLines', startRow(1)-1, 'ReturnOnError', false);
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'HeaderLines', startRow(block)-1, 'ReturnOnError', false);
    dataArray{1} = [dataArray{1};dataArrayBlock{1}];
end

%% Close the text file.
fclose(fileID);

%% Allocate imported array to column variable names
id = dataArray{:, 1};
%id = int32(id);
end %readID

