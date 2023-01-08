%% More readible code
clc;clf;clear;

% dec2bin - convert to binary
% strcmp - cmp two binary values

X = 1;
K = 16;             %Given in assignment
sha256hasher = System.Security.Cryptography.SHA256Managed;


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
tic
for j = 1:2^K
    rTest = dec2bin(j, K);
    cTest = commit(mTest, rTest, X, sha256hasher);
    if strcmp(cTest, c)
        C(size(C,1) + 1, 1) = {cTest};
        C(size(C,1), 2) = {rTest};
        
    end
end

%Now test for m_1, aka message = 1
mTest = dec2bin(1);
counter = 2;
for j = 1:2^K
    rTest = dec2bin(j, K);
    cTest = commit(mTest, rTest, X, sha256hasher);
    if strcmp(cTest, c)
        C(counter, 3) = {cTest};
        C(counter, 4) = {rTest};
        counter = counter + 1;
    end
end
timer = toc;

%Guess if it is b = 0 or b = 1
%Take the one with the most found commits
CommitMessage0 = C(2:end,1);
CommitMessage0 = CommitMessage0(~cellfun('isempty',CommitMessage0));
RandKey0 = C(2:end,2);
RandKey0 = RandKey0(~cellfun('isempty',RandKey0));
CommitMessage1 = C(2:end,3);
CommitMessage1 = CommitMessage1(~cellfun('isempty',CommitMessage1));
RandKey1 = C(2:end,4);
RandKey1 = RandKey1(~cellfun('isempty',RandKey1));

sizeM0 = size(CommitMessage0, 1);
sizeM1 = size(CommitMessage1, 1);

if sizeM0 > sizeM1
    bGuess = dec2bin(0);
    CommitMessage1(sizeM1+1:sizeM0,1) = {'-'};
    RandKey1(sizeM1+1:sizeM0,1) = {'-'};
elseif sizeM0 < sizeM1
    bGuess = dec2bin(1);
    CommitMessage0(sizeM0+1:sizeM1,1) = {'-'};
    RandKey0(sizeM0+1:sizeM1,1) = {'-'};
else
    %If they have the same amount, guess
    bGuess = dec2bin(randUniform(0,1,1,1));
    disp("Guessed on " + bGuess + " on X = " + X)
end

if strcmp(b, bGuess)
    disp("Adversary wins!")
else
    disp("Challenger wins!")
end



%Creat a table
Table = table(CommitMessage0, RandKey0, CommitMessage1, RandKey1);
disp(Table)
disp("Time = " + timer)

%% Better for simulaton code
clc;clear;clf;

K = 16;             %Given in assignment
testPerX = 100;
won = zeros(testPerX, 31);
timer = zeros(testPerX, 31);
didguess = zeros(testPerX, 31);

tic
parfor i = 0:30
    sha256hasher = System.Security.Cryptography.SHA256Managed;
    X = i;
    disp("Starting work on " + X)
    for j = 1:testPerX
        [won(j, i+1), timer(j, i+1), didguess(j, i+1)] = securityGame(X, K, sha256hasher);
        disp("    Done with " + X + ":" + j + "/" + testPerX)
    end
end
toc

% Plot the hiding prob.
clf;
x = 0:30;
plot(x, mean(won), "LineWidth", 2);
grid on

legend("Simulation", "FontSize",12)
title("Probability of breaking the hiding property", "FontSize",14)
xlabel("X = truncation point", "FontSize",15)
ylabel("Probability", "FontSize",15)
axis([0, 30, 0, 1.1])


saveas(gcf, "hidingNew.png")

%% Plot when you loos if you are not 100% certain

testWon = won;

for i = 1:100
    for j = 1:31
        if didguess(i,j) == 1 && won(i,j) == 1
            testWon(i,j) = 0;
        end
    end
end

clf;
x = 0:30;
plot(x, mean(testWon), "LineWidth", 2);
grid on

legend("Simulation", "FontSize",12)
title("Probability of breaking the hiding property", "FontSize",14)
xlabel("X = truncation point", "FontSize",15)
ylabel("Probability", "FontSize",15)
axis([0, 30, 0, 1.1])


saveas(gcf, "hidingNewCertain.png")



%% Version 2
% We only break the hiding property if we can for 100% find m and r that
% gives us c. So if we have two two r's for the same m that is not a
% 100% certian. Also, if we have two r's for diffrent m, that is also not
% 100% certian.
clc;clear;clf;

K = 16;             %Given in assignment
testPerX = 100;
won = zeros(testPerX, 31);
timer = zeros(testPerX, 31);

tic
for i = 0:30
    X = i;
    disp("Starting work on " + X)
    nextIndex = i+1;
    parfor j = 1:testPerX
        sha256hasher = System.Security.Cryptography.SHA256Managed;
        [won(j, nextIndex), timer(j, nextIndex)] = securityGameV2(X, K, sha256hasher);
        disp("    Done with " + X + ":" + j + "/" + testPerX)
    end
end
toc

%%

% Plot the hiding prob.
clc;clf;
x = 0:30;
simFun = @(x) 1 ./ (1 + exp(17 - x));
hold on
%Plot the simulation
plot(x, mean(won,1), "LineWidth", 2);
%Plot a similar function
plot(x, simFun(x), "LineWidth", 2)
grid on

textInLegend = ["Simulation", "$\frac{1}{1 \, + \, \exp ({17 - x})}$"];
legend(textInLegend, "FontSize", 20, 'Location','northwest', 'Interpreter','latex')
title("Probability of breaking the hiding property", "FontSize",14)
xlabel("X = truncation point", "FontSize",15)
ylabel("Probability", "FontSize",15)
axis([0, 30, 0, 1.1])


hold off
saveas(gcf, "hidingNewV2.png")





