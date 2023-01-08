%% Version 1
clc;clf;clear

XRange = 0:30;

emptyBins = zeros(1,size(XRange,2));
overfullBins = zeros(1,size(XRange,2));

for X = XRange %Number of bins (Truncation point)
    inputBits = 17; %Always 17 bits going in (Balls thrown) (16 bits of random and 1 bit of message)
    
    goFor = 10000;
    
    binsTot = zeros(goFor,X+1);
    moreThenOneBal = zeros(1,goFor);
    emptySpace = zeros(1,goFor);
    
    lower = XRange(1)-0.5;    %Removed 0.5 so round is fair
    upper = X+0.5;  %Added 0.5 so round is fair
    
    for k = 1:goFor
        r = round((upper - lower).*rand(1,inputBits) + lower);
        for j = 1:size(r,2)
            binsTot(k,r(j)+1) = binsTot(k,r(j)+1) + 1;
        end
        moreThenOneBal(k) = sum(binsTot(k,:) >= 2);
        emptySpace(k) = sum(binsTot(k,:) <= 0);
    end
    
    %binsMean = mean(binsTot)
    
    %bar(binsMean)
    
    overfullBins(X+1) = sum(moreThenOneBal)/((X+1) * goFor);
    %disp("Bins with more then 1 balls: " + overfullBins*100 + "%")
    
    emptyBins(X+1) = sum(emptySpace)/((X+1) * goFor);
    %disp("Bins with 0 balls: " + emptyBins*100 + "%")


end



hold on
grid on

plot(XRange,emptyBins, "LineWidth", 2)
plot(XRange,overfullBins, "LineWidth", 2)

legend("Empty bins", "Overfull bins", "FontSize",17)
title("Probability of breaking the binding property", "FontSize",17)
xlabel("X = truncation point", "FontSize",17)
ylabel("Probability", "FontSize",17)

saveas(gcf, "bindingBins.png");

%% Version 2
clc;clf;clear;
%Red balls = 0 
%Blue balls = 1
%    or
%Have two "diffrent" bins for one bin, on red and one blue.

%Think of the balls as diffrent inputs, aka, on red ball is the input
%0||r, r \in {0,1}^16 and the green is 1||r. Then the bins are the diffrent
%output. So we have 2^X outputs, aka 2^X bins because output \in {0,1}^X
%If two green balls hapens to end up in the same bin, that is not
%considered as a collision. But if one red and green ball ends up in the
%same bin, that means we have a collision. Becuse two diffrent messages, 
%m = 0, and m = 1 are having the same output. 
%If more then one red and green balls ends up in the same bin, we will
%still just count that as one collisions.
%So if we have at least one collision, the binding property is considerd
%broken! To simulate the probablity, we need to test this many times and
%divide the times the binding property where considerd broken with the
%total amount of times the test where run. This is done for EVERY value of
%X. 

%Throw total of 2^17 balls
%2^16 red balls
tic
redBalls = 2^16;         %16 is from the assignment
greenBalls = 2^16;
goForIterations = 1:1000;
XIterations = 0:20;     %From assignment X \in [0,30]

bindingBroken = zeros(size(goForIterations,2), size(XIterations,2));

for i = XIterations
    X = i;
    bins = 2.^X;
    i
    tic
    for j = goForIterations
        %Simulat throwing 2^16 red balls (row 1) and throwing 2^16 green 
        % balls (row 2).
        %Starting at 1 because 2^0 = 1
        %Row is color of ball, column is which ball, value is in which bin
        ballsInWhichBin = randUniform(1, bins, 2, redBalls);
        
        %Row is color of ball, colum is which bin, value is the number of balls in
        %that bin
        numberOfBalsInEachBin = zeros(2, bins);
        
        %Add the right number of balls to each bin
        for k = 1:size(ballsInWhichBin,2)
            binNumberRed = ballsInWhichBin(1,k);
            binNumberGreen = ballsInWhichBin(2,k);
            numberOfBalsInEachBin(1, binNumberRed) = numberOfBalsInEachBin(1, binNumberRed) + 1;
            numberOfBalsInEachBin(2, binNumberGreen) = numberOfBalsInEachBin(2, binNumberGreen) + 1;
        end
        
        %Determin if a bin has any balls in it
        binHasBalls = numberOfBalsInEachBin >= 1;
        
        %Determiin if a bin has at least on red and green ball in it
        binHasOverflow = sum(binHasBalls, 1) >= 2;
        
        %If any bin has more then one sort of ball, the binding is borken
        if sum(binHasOverflow, 2) >= 1
            bindingBroken(j,i+1) = 1;
        end
    end
    toc
end


bindingBrokenProb = sum(bindingBroken,1)./size(bindingBroken,1);

plot(XIterations, bindingBrokenProb(XIterations+1));
toc

%% Version 3
clc;clf;clear;

%Throw total of 2^17 balls
%2^16 red balls
tic
redBalls = 2^16;         %16 is from the assignment
greenBalls = 2^16;
goForIterations = 1:1000;
XIterations = 0:40;     %From assignment X \in [0,30]

bindingBroken = zeros(size(goForIterations,2), size(XIterations,2));

parfor i = XIterations
    X = i;
    bins = 2.^X;
    i

    for j = goForIterations
        %Simulat throwing 2^16 red balls (row 1) and throwing 2^16 green 
        % balls (row 2).
        %Starting at 1 because 2^0 = 1
        %Row is color of ball, column is which ball, value is in which bin
        ballsInWhichBin = randUniform(1, bins, 2, redBalls);

        collisions = ismember(ballsInWhichBin(1,:), ballsInWhichBin(2,:));
        if sum(collisions, 2) >= 1
            bindingBroken(j,i+1) = 1;
        end
    end
end


bindingBrokenProb = sum(bindingBroken,1)./size(bindingBroken,1);

plot(XIterations, bindingBrokenProb(XIterations+1));
toc

%% Version 4
clc;clf;clear;

%Throw total of 2^17 balls
%2^16 red balls
tic
redBalls = 2^16;         %16 is from the assignment
greenBalls = 2^16;
goForIterations = 1:1;
XIterations = 0:40;     %From assignment X \in [0,30]

bindingBroken = zeros(size(goForIterations,2), size(XIterations,2));

for i = XIterations
    X = i;
    bins = 2.^X;
    i

    tic
    for j = goForIterations
        ballsInWhichBin = randUniform(1, bins, 2, redBalls);
        ballsInWhichBin = sort(ballsInWhichBin,2);
        
        pRed = 1;
        pGreen = 1;
        for k = 1:size(ballsInWhichBin,2)
            if ballsInWhichBin(1,pRed) < ballsInWhichBin(2,pGreen)
                pRed = pRed + 1;
                continue
            elseif ballsInWhichBin(1,pRed) > ballsInWhichBin(2,pGreen)
                pGreen = pGreen + 1;
                continue
            else
                bindingBroken(j,i+1) = 1;
                break;
            end
        end
    end
    toc
end


bindingBrokenProb = sum(bindingBroken,1)./size(bindingBroken,1);
toc
%% Plot for v4
clf;
plot(XIterations, bindingBrokenProb(XIterations+1), "LineWidth", 2);
grid on

legend("Overfull bins", "FontSize",17, 'Location','southwest')
title("Probability of breaking the binding property", "FontSize",17)
xlabel("X = truncation point", "FontSize",17)
ylabel("Probability", "FontSize",17)
axis([0 XIterations(end) 0 1.1])

saveas(gcf, "bindingBinsV4.png");

%% Version 5 worse then before
clc;clf;clear;

%Throw total of 2^17 balls
%2^16 red balls
tic
redBalls = 2^16;         %16 is from the assignment
greenBalls = 2^16;
goForIterations = 1:100;
XIterations = 0:40;     %From assignment X \in [0,30]

bindingBroken = zeros(size(goForIterations,2), size(XIterations,2));

parfor i = XIterations
    X = i;
    bins = 2.^X;
    i

    ballsInWhichBin = randUniform(1, bins, 2*size(goForIterations,2), redBalls);
    ballsInWhichBin = sort(ballsInWhichBin,2);
    
    for j = goForIterations
        pRed = 1;
        pGreen = 1;
        for k = 1:size(ballsInWhichBin,2)
            if ballsInWhichBin(j,pRed) < ballsInWhichBin(size(goForIterations,2) + j,pGreen)
                pRed = pRed + 1;
                continue
            elseif ballsInWhichBin(j,pRed) > ballsInWhichBin(size(goForIterations,2) + j,pGreen)
                pGreen = pGreen + 1;
                continue
            else
                bindingBroken(j,i+1) = 1;
                break;
            end
        end
    end
end


bindingBrokenProb = sum(bindingBroken,1)./size(bindingBroken,1);

plot(XIterations, bindingBrokenProb(XIterations+1));
toc

%% Version 6
% This version changes some things after feedback
clc;clf;clear;

%So what would hapend if I only throw one ball of one collo , and then try
%to see where the other balls land.

%Throw total of 2^17 balls
%2^16 red balls and 2^16 green balls
tic
redBalls = 2^16;         %16 is from the assignment
greenBalls = 2^16;
goForIterations = 1:1;
XIterations = 0:30;     %From assignment X \in [0,30]

bindingBroken = zeros(size(goForIterations,2), size(XIterations,2));

for i = XIterations
    X = i;
    bins = 2.^X;
    disp("i = " + i);

    tic
    for j = goForIterations
        ballsInWhichBin = randUniform(1, bins, 2, redBalls);
        ballsInWhichBin = sort(ballsInWhichBin,2);
        
        pRed = 1;
        pGreen = 1;
        for k = 1:size(ballsInWhichBin,2)
            if ballsInWhichBin(1,pRed) < ballsInWhichBin(2,pGreen)
                pRed = pRed + 1;
                continue
            elseif ballsInWhichBin(1,pRed) > ballsInWhichBin(2,pGreen)
                pGreen = pGreen + 1;
                continue
            else
                bindingBroken(j,i+1) = 1;
                break;
            end
        end
    end
    toc
end


bindingBrokenProb = sum(bindingBroken,1)./size(bindingBroken,1);
toc
% Plot for v4
clf;
plot(XIterations, bindingBrokenProb(XIterations+1), "LineWidth", 2);
grid on

legend("Overfull bins", "FontSize",17, 'Location','southwest')
title("Probability of breaking the binding property", "FontSize",17)
xlabel("X = truncation point", "FontSize",17)
ylabel("Probability", "FontSize",17)
axis([0 XIterations(end) 0 1.1])

saveas(gcf, "bindingBinsV4.png");

%%
A = [1 2 5 1, 3 6 7 8];
[uniqueA i j] = unique(A,'first');
indexToDupes = find(not(ismember(1:numel(A),i)))

%%
tic
ballsInWhichBin = randUniform(1, bins, 2*1000, redBalls);
toc


%%
clc;
K = 16;
sha256hasher = System.Security.Cryptography.SHA256Managed;
message = dec2bin(1);
random = dec2bin(randUniform(0,1,1,K))';
input = [message random];
c = uint8(sha256hasher.ComputeHash(uint8(input)));
c = dec2bin(c);
c = c';
c = c(:)';
cBin = c(1:X);
disp(cBin)











