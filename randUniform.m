function randNum = randUniform(lowerBound,upperBound, numberOfRows, numberOfCol)
%RANDUNIFORM Returns uniformly random intedger numbers between bounds.
%   If "numberOfCol" is not defined, it wil return a matrix of size
%   "numberOfRows".

if ~exist("numberOfCol", "var")
    numberOfCol = numberOfRows;
end

lower = lowerBound - 0.5;       %Removed 0.5 so round is fair
upper = upperBound + 0.5;       %Added 0.5 so round is fair

randNum = round((upper - lower) .* rand(numberOfRows, numberOfCol) + lower);

end

