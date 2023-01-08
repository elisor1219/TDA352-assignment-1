function [adversaryWon, tEnd, didGuess] = securityGame(X,K,sha256hasher)
%SECURITYGAME Summary of this function goes here
%   Detailed explanation goes here

tic;
%1) Advr. - - - - - - - - - - - - - - - - - -
%Message just one bit
m_0 = dec2bin(0);
m_1 = dec2bin(1);

%2) Challenger - - - - - - - - - - - - - - - -
b = dec2bin(randUniform(0,1,1,1));
%Rand value 16 bits
r = dec2bin(randUniform(0,1,1,K))';

if strcmp(b,'0')
    m = m_0;
else
    m = m_1;
end

%Input to commit always 17 bits
c = commit(m, r, X, sha256hasher);

%3) Advr. - - - - - - - - - - - - - - - - - -
C = cell(1,4);
C(1,1) = {'m_0 = 0'};
C(1,2) = {'Rand keys'};
C(1,3) = {'m_1 = 1'};
C(1,4) = {'Rand keys'};


%Start by testing for m_0, aka message = 0
mTest = dec2bin(0);
for i = 1:2^K
    rTest = dec2bin(i, K);
    cTest = commit(mTest, rTest, X, sha256hasher);
    if strcmp(cTest, c)
        C(size(C,1) + 1, 1) = {cTest};
        C(size(C,1), 2) = {rTest};
        
    end
end

%Now test for m_1, aka message = 1
mTest = dec2bin(1);
counter = 2;
for i = 1:2^K
    rTest = dec2bin(i, K);
    cTest = commit(mTest, rTest, X, sha256hasher);
    if strcmp(cTest, c)
        C(counter, 3) = {cTest};
        C(counter, 4) = {rTest};
        counter = counter + 1;
    end
end

%Guess if it is b = 0 or b = 1
%Take the one with the most found commits
CommitMessage0 = C(2:end,1);
CommitMessage0 = CommitMessage0(~cellfun('isempty',CommitMessage0));
CommitMessage1 = C(2:end,3);
CommitMessage1 = CommitMessage1(~cellfun('isempty',CommitMessage1));

sizeM0 = size(CommitMessage0, 1);
sizeM1 = size(CommitMessage1, 1);

if sizeM0 > sizeM1
    bGuess = dec2bin(0);
    didGuess = 0;
elseif sizeM0 < sizeM1
    bGuess = dec2bin(1);
    didGuess = 0;
else
    %If they have the same amount, guess
    bGuess = dec2bin(randUniform(0,1,1,1));
    didGuess = 1;
end

if strcmp(b, bGuess)
    adversaryWon = 1;
else
    adversaryWon = 0;
end
tEnd = toc;

end

