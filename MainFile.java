import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.security.NoSuchAlgorithmException;
import java.util.Random;

public class MainFile {
    static int K = 16;
    //To not use the trunc. function, set this to a large number, i.e. 100000
    static int X = 16;
    static boolean debugMode = false;
    public static void main(String[] args) throws NoSuchAlgorithmException {
        //Best way here would be to move the inside of the for-loop to 
        //another function.
        String[] ratioHidingSave = new String[X+1];
        String[] ratioBindningSave = new String[X+1];
        for (int j = 0; j <= X; j++) {
            System.out.println("\n----------------------------------------------");
            CommitmentScheme CS = new CommitmentScheme(j);
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
            Double ratioGuesses;
            for (int i = 0; i < message[0].length; i++) {
                rightGuesses += message[Integer.parseInt(originalString)][i];
                wrongGuesses -= message[Integer.parseInt(originalString)][i];
            }
            ratioGuesses = (double) rightGuesses/(message[0].length*2);
            ratioHidingSave[j] = ratioGuesses.toString();

            System.out.println("Rand binary string: " + randValString);
            System.out.println("Original string:    " + originalString);
            System.out.println("Commit:             " + shortCommit);

            System.out.println("Right guesses:  " + rightGuesses);
            System.out.println("Wronng guesses: " + wrongGuesses);

            System.out.println("Ratio: " + ratioGuesses);

            System.out.println("1/(2^" + j +" * 2) = 2^-(" + j + "+1) = " + 1/(Math.pow(2,j)* 2));

            //---Second part---
            System.out.println("\n-----Second part-----");
            //String[] shortCommitChanged = {"", ""};

            String[][] randValStringGuess = adversary.breakBinding(shortCommit);
            //This is so we need to find a key for message m_0 and 
            //also for m_1 that makes c = commit(m_0, k) commit(m_1, k).
            int rightKeys = 0;
            Double ratioKeys;
            int keysFor0 = Integer.parseInt(randValStringGuess[1][0]);
            int keysFor1 = Integer.parseInt(randValStringGuess[3][0]);
            if (keysFor0 >= 1 && keysFor1 >= 1  ){
                rightKeys = keysFor0 + keysFor1;
            }
            int totalTries = (randValStringGuess[0].length);

            ratioKeys = (double) rightKeys/totalTries;
            ratioBindningSave[j] = ratioKeys.toString();

            System.out.println("Right keys found: " + rightKeys);
            System.out.println("Total tries:      " + totalTries);

            System.out.println("Ratio:            " + ratioKeys);

            System.out.println("1/(2^" + j +") = 2^-" + j +" = " + 1/(Math.pow(2,j)));

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
        
        File myFile = new File("data.txt");
        try {
            myFile.createNewFile();
          } catch (IOException e) {
            System.out.println("An error occurred.");
            e.printStackTrace();
          }

        try {
            FileWriter myWriter = new FileWriter(myFile.getName());
            //First write X to the file.
            myWriter.write(X + "|");
            for (String string : ratioHidingSave) {
                myWriter.write(string+"|");
            }
            for (String string : ratioBindningSave) {
                myWriter.write(string+"|");
            }
            myWriter.close();
        } catch (IOException e) {
            System.out.println("An error occurred.");
            e.printStackTrace();
        }
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
