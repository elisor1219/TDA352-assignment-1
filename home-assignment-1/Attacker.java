import java.security.NoSuchAlgorithmException;

public class Attacker {
    private int X;
    private CommitmentScheme CS;

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

    protected int[][] findMessageAndRandVal(String shortCommit) throws NoSuchAlgorithmException{
        setX(shortCommit.length());
        setCS(getX());

        //Starting with testing for maximum of 16 binary.
        int randValUpTo = (int) Math.pow(2,16); 

        //So the first collumn is the message 0 and the second message 1
        //The idex of the rows are the randVal used
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
}
