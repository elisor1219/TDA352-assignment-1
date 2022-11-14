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

    protected String[][] breakBinding(String shortCommit) throws NoSuchAlgorithmException{
        setX(shortCommit.length());
        setCS(getX());

        int randValUpTo = maxSearchBreakBinding; 

        //The first array/collumn is the key and the second when found, for 0
        //The third array/collumn is the key and the fourth when found, for 0
        String[][] randVal = {{,}, {,}, {,}, {,}};
        String[][] tempVar = {{},{}};
        //Start by guessing message = 0;
        tempVar = findRand(shortCommit, "0", randValUpTo);
        randVal[0] = tempVar[0];
        randVal[1] = tempVar[1];
        //Then by guessing message = 1;
        tempVar = findRand(shortCommit, "1", randValUpTo);
        randVal[2] = tempVar[0];
        randVal[3] = tempVar[1];
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

    protected String[][] findRand (String shortCommit, String guessMessage, int randValUpTo) throws NoSuchAlgorithmException{
        String guessRandVal;
        String guessCommit = "-1";
        //{{},{}};
        //The right way of doing this would be using a arrayList
        //Dont have time to fix this, but would hep to have an list!
        String[][] rightCommits = new String[2][randValUpTo];

        int j = 0;
        for (int i = 0; i < randValUpTo; i++) {
            guessRandVal = Integer.toBinaryString(i);

            guessCommit = CS.commit(guessMessage, guessRandVal);
            if(shortCommit.equals(guessCommit)){
                if (debugMode){
                System.out.println("Found one key in " + i + " steps.");
                System.out.println("Key: " + guessRandVal);
                }
                if (loadBarOn){
                    System.out.println("Found one key at i = " + i);
                }
                //Stores the guess key in the first array and
                //when it was found in the second array.
                rightCommits[0][j+1] = guessRandVal;
                rightCommits[1][j+1] = Integer.toString(i);
                j++;
            }
            i++;
            if (loadBarOn && Math.floorMod(i, 500000) == 0){
                System.out.println("Search index = " +  i);
            }
        }

        //Here it is not neccecary to have a if, but I only need the code to
        //work once... For now
        if (j == 0){
            //String[][] retVal = {{"Total","-1"}, {Integer.toString(j), Integer.toString(j)}};
            //return retVal;
            rightCommits[0][0] = "Total";
            rightCommits[1][0] = "0";
            return rightCommits;
        } else {
            //for (String val : rightCommits[0]) {
            //    if (val.equals("null"))
            //}
            rightCommits[0][0] = "Total";
            rightCommits[1][0] = Integer.toString(j);
            return rightCommits;
        }



    }
}
