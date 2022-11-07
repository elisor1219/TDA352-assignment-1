import java.security.NoSuchAlgorithmException;

public class Attacker {
    private int X;
    private CommitmentScheme CS;
    private boolean debugMode = false;
    private boolean loadBarOn = false;
    private int maxSearchFindMessage = (int) Math.pow(2,16);
    private int maxSearchBreakBinding = (int) Math.pow(2,16);

    public Attacker(){
    }

    private void setCS(int X){
        this.CS = new CommitmentScheme(X);
    }

    protected void setX(int X){
        this.X = X;
    }

    protected int getX(){
        return this.X;
    }

    protected String[] breakBinding(String shortCommit) throws NoSuchAlgorithmException{
        setX(shortCommit.length());
        setCS(getX());

        int randValUpTo = maxSearchBreakBinding; 

        //So the first collumn is the message 0 and the second message 1
        String[] randVal = {"", ""};
        //Start by guessing message = 0;
        randVal[0] = findRand(shortCommit, "0", randValUpTo);
        //Then by guessing message = 1;
        randVal[1] = findRand(shortCommit, "1", randValUpTo);
        return randVal;
    }

    protected int[][] findMessage(String shortCommit) throws NoSuchAlgorithmException{
        setX(shortCommit.length());
        setCS(getX());

        //Starting with testing for maximum of 16 binary.
        int randValUpTo = maxSearchFindMessage; 

        //So the first collumn is the message 0 and the second message 1
        //The index of the rows are the randVal used
        int[][] message = new int[2][randValUpTo];
        //Start by guessing message = 0;
        message[0] = testMessage(shortCommit, "0", randValUpTo);
        //Then by guessing message = 1;
        message[1] = testMessage(shortCommit, "1", randValUpTo);

        return message;
    }

    protected int[] testMessage (String shortCommit, String guessMessage, int randValUpTo) throws NoSuchAlgorithmException{
        String guessRandVal;
        String guessCommit;

        int[] foundMessage = new int[randValUpTo];

        for (int i = 0; i < randValUpTo; i++) {
            guessRandVal = Integer.toBinaryString(i);

            guessCommit = CS.commit(guessMessage, guessRandVal);
            if(shortCommit.equals(guessCommit)){
                foundMessage[i] = 1;
            } else{
                foundMessage[i] = 0;
            }
        }

        return foundMessage;
    }

    protected String findRand (String shortCommit, String guessMessage, int randValUpTo) throws NoSuchAlgorithmException{
        String guessRandVal;
        String guessCommit = "-1";

        int i = 0;
        while (true) {
            if (i > randValUpTo){
                if (loadBarOn){
                    System.out.println("Search aborted at i = " + i);
                }
                return "-1";
            }
            guessRandVal = Integer.toBinaryString(i);

            guessCommit = CS.commit(guessMessage, guessRandVal);
            if(shortCommit.equals(guessCommit)){
                if (debugMode){
                System.out.println("Found randVal in " + i + " steps.");
                System.out.println("RandVal: " + guessRandVal);
                }
                if (loadBarOn){
                    System.out.println("Found randVal at i = " + i);
                }
                return guessRandVal;
            }
            i++;
            if (loadBarOn && Math.floorMod(i, 500000) == 0){
                System.out.println("Search index = " +  i);
            }
        }
    }
}
