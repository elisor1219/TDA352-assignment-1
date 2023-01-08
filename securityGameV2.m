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
brokeHidenProp = false;
adversaryWon = false;


%Start by testing for m_0, aka message = 0
mTest = dec2bin(0);
for i = 1:2^K
    rTest = dec2bin(i, K);
    cTest = commit(mTest, rTest, X, sha256hasher);
    if strcmp(cTest, c)
        %If we find a collison, we loose
        if brokeHidenProp
            adversaryWon = false;
            tEnd = toc;
            return
        end
        brokeHidenProp = true;
    end
end

%Now test for m_1, aka message = 1
mTest = dec2bin(1);
for i = 1:2^K
    rTest = dec2bin(i, K);
    cTest = commit(mTest, rTest, X, sha256hasher);
    if strcmp(cTest, c)
        %If we find a collison, we loose
        if brokeHidenProp
            adversaryWon = false;
            tEnd = toc;
            return
        end
        brokeHidenProp = true;
    end
end

if brokeHidenProp
    adversaryWon = true;
end

tEnd = toc;
end

