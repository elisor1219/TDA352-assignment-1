import java.security.NoSuchAlgorithmException;
import java.util.Random;

public class MainFile {
    static int K = 16;
    //To not use the trunc. function, set this to a large number, i.e. 100000
    static int X = 1;
    static boolean debugMode = false;
    public static void main(String[] args) throws NoSuchAlgorithmException {
        System.out.println("\n----------------------------------------------");
        CommitmentScheme CS = new CommitmentScheme(X);
        Attacker adversary = new Attacker();

        String originalString = "0";
        String randValString = randBinary(K);
        String shortCommit = CS.commit(originalString, randValString);

        int[][] message = adversary.findMessage(shortCommit);
        if (debugMode) {
            for (int i = 0; i < message[0].length; i++) {
                System.out.println(message[0][i] + "  " + message[1][i]);
            }
        }

        int rightGuesses = 0;
        int wrongGuesses = message[0].length*2;
        for (int i = 0; i < message[0].length; i++) {
            rightGuesses += message[Integer.parseInt(originalString)][i];
            wrongGuesses -= message[Integer.parseInt(originalString)][i];
        }
        

        System.out.println("Rand binary string: " + randValString);
        System.out.println("Original string:    " + originalString);
        System.out.println("Commit:             " + shortCommit);

        System.out.println("Right guesses:  " + rightGuesses);
        System.out.println("Wronng guesses: " + wrongGuesses);

        System.out.println("Ratio: " + (double) rightGuesses/(message[0].length*2));

        System.out.println("1/(2^" + X +" * 2) = 2^-(" + X + "+1) = " + 1/(Math.pow(2,X)* 2));

        //---Second part---
        System.out.println("\n-----Second part-----");
        //String[] shortCommitChanged = {"", ""};

        String[][] randValStringGuess = adversary.breakBinding(shortCommit);
        int rightKeys = Integer.parseInt(randValStringGuess[1][0]) 
                        + Integer.parseInt(randValStringGuess[3][0]);
        int totalTries = (randValStringGuess[0].length);

        System.out.println("Right keys found: " + rightKeys);
        System.out.println("Total tries:      " + totalTries);

        System.out.println("Ratio:            " + (double) rightKeys/totalTries);

        System.out.println("1/(2^" + X +") = 2^-" + X +" = " + 1/(Math.pow(2,X)));

        //for (int i = 0; i < randValStringGuess.length; i++) {
        //    if (randValStringGuess[i][0].equals("-1")){
        //        shortCommitChanged[i] = "Aborted. Exceeded time limit";
        //    }else{
        //        shortCommitChanged[i] = CS.commit(Integer.toString(i), randValStringGuess[i][0]);
        //    }
        //}

        //System.out.println("Original commit with " + originalString + " : " + shortCommit);
        //System.out.println("Commit changed to 0: " + shortCommitChanged[0] + " \t Itterations = " + randValStringGuess[0][1]);
        //System.out.println("Commit changed to 1: " + shortCommitChanged[1] + " \t Itterations = " + randValStringGuess[1][1]);
    }

    private static String randBinary(int numberOfNum){
        Random rand = new Random();
        StringBuilder randStringOfNum = new StringBuilder();
        for (int i = 0; i < numberOfNum; i++) {
            randStringOfNum.append(rand.nextInt(2));
        }
        return randStringOfNum.toString();
    }
    
}
