function [adversaryWon, tEnd] = securityGameV3(X,K,sha256hasher)
%SECURITYGAME Summary of this function goes here
%   Detailed explanation goes here

tic;
%1) Advr. - - - - - - - - - - - - - - - - - -
%Message just one bit
m_0 = dec2bin(0);
m_1 = dec2bin(1);

%2) Challenger - - - - - - - - - - - - - - - -
%Rand value 16 bits
r = dec2bin(randUniform(0,1,1,K))';

%Input to commit always 17 bits
c = commit(m_0, r, X, sha256hasher);

%3) Advr. - - - - - - - - - - - - - - - - - -
%"Setting" the variables. Could use adversaryWon, but fell like it is more
%readible now.
adversaryWon = false;


%Start by testing for m_0, aka message = 0
mTest = m_1;
for i = 1:2^K
    rTest = dec2bin(i, K);
    cTest = commit(mTest, rTest, X, sha256hasher);
    if strcmp(cTest, c)
        %If we find a collison, we win
        adversaryWon = true;
        tEnd = toc;
        return
    end
end

tEnd = toc;
end

