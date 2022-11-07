import java.security.NoSuchAlgorithmException;
import java.util.Random;

public class MainFile {
    static int K = 4;
    static int X = 4;
    static boolean debugMode = false;
    public static void main(String[] args) throws NoSuchAlgorithmException {
        System.out.println("\n----------------------------------------------");
        CommitmentScheme CS = new CommitmentScheme(X);
        Attacker adversary = new Attacker();

        String originalString = "1";
        String randValString = randBinary(K);
        String shortCommit = CS.commit(originalString, randValString);

        int[][] message = adversary.findMessageAndRandVal(shortCommit);
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

        System.out.println(1/(Math.pow(2,X)* 2));
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
