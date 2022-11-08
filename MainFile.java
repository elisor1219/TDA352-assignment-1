import java.security.NoSuchAlgorithmException;
import java.util.Random;

public class MainFile {
    static int K = 16;
    //To not use the trunc. function, set this to a large number, i.e. 100000
    static int X = 15;
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
        int wrongguesses = message[0].length*2;
        for (int i = 0; i < message[0].length; i++) {
            rightGuesses += message[Integer.parseInt(originalString)][i];
            wrongguesses -= message[Integer.parseInt(originalString)][i];
        }
        

        System.out.println("Rand binary string: " + randValString);
        System.out.println("Original string:    " + originalString);
        System.out.println("Commit:             " + shortCommit);

        System.out.println("Right guesses:  " + rightGuesses);
        System.out.println("Wronng guesses: " + wrongguesses);

        System.out.println("Ratio: " + (double) rightGuesses/(message[0].length*2));

        System.out.println("1/(2^" + X +") = " + 1/(Math.pow(2,X)* 2));

        //---Second part---
        System.out.println("\n-----Second part-----");
        String[] shortCommitChanged = {"", ""};

        String[] randValStringGuess = adversary.breakBinding(shortCommit);

        for (int i = 0; i < randValStringGuess.length; i++) {
            if (randValStringGuess[i].equals("-1")){
                shortCommitChanged[i] = "Aborted. Exceeded time limit";
            }else{
                shortCommitChanged[i] = CS.commit(Integer.toString(i), randValStringGuess[i]);
            }
        }

        System.out.println("Original commit with " + originalString + " : " + shortCommit);
        System.out.println("Commit changed to 0: " + shortCommitChanged[0]);
        System.out.println("Commit changed to 1: " + shortCommitChanged[1]);
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
