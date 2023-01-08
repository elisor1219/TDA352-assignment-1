function cBin = commit(message, random, X, sha256hasher)
%COMMIT Commit a message with sha256, message and random are two character
%strings
%   Detailed explanation goes here
input = [message random];
c = uint8(sha256hasher.ComputeHash(uint8(input)));
c = dec2bin(c);
c = c';
c = c(:)';
cBin = c(1:X);


end

