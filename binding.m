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
goForIterations = 1:2;
XIterations = 7:22;     %From assignment X \in [0,30]

bindingBroken = zeros(size(goForIterations,2), size(XIterations,2));

for i = XIterations
    X = i;
    bins = 2.^X;
    i

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
        binHasOverflow = sum(binHasBalls,1) >= 2;
        
        %If any bin has more then one sort of ball, the binding is borken
        if sum(binHasOverflow) >= 1
            bindingBroken(j,i+1) = 1;
        end
    end
end


bindingBrokenProb = sum(bindingBroken,1)./size(bindingBroken,1);

plot(XIterations, bindingBrokenProb(XIterations+1));
toc

