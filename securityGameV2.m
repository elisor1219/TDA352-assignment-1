function [adversaryWon, tEnd] = securityGameV2(X,K,sha256hasher)
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
%"Setting" the variables. Could use adversaryWon, but ffel like it is more
%readible now.
adversaryWon = false;
foundM0Key = false;
foundM1Key = false;

mTest = [dec2bin(0); dec2bin(1)];

for i = 1:2^K
    rTest = dec2bin(i, K);
    cTest1 = commit(mTest(1), rTest, X, sha256hasher);
    cTest2 = commit(mTest(2), rTest, X, sha256hasher);
    
    %Start by testing for m_0, aka message = 0
    if ~foundM0Key && strcmp(cTest1, c)
        foundM0Key = true;
    end
    %Now test for m_1, aka message = 1
    if ~foundM1Key && strcmp(cTest2, c)
        foundM1Key = true;
    end
    %If we find a collison, we loose
    if foundM0Key && foundM1Key
        adversaryWon = false;
        tEnd = toc;
        return
    end
end

if foundM0Key || foundM1Key
    adversaryWon = true;
end

tEnd = toc;
end

