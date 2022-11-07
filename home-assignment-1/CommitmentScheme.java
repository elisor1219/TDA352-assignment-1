import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.HashMap;

class CommitmentScheme{
    private int X;

    public CommitmentScheme(int X){
        this.X = X;
    }

    public void setX(int X){
        this.X = X;
    }

    public int getX(){
        return this.X;
    }

    private static String truncate(String hashString, int length) {
        if(hashString.length() <= length){
            return hashString;
        }
        return hashString.substring(0, length);
    }

    protected String commit(String message, String randString) throws NoSuchAlgorithmException{
        return truncate(hashSHA256(message, randString), X);
    }

    private static String hashSHA256(String messageString, String randString) throws NoSuchAlgorithmException{
        MessageDigest digest = MessageDigest.getInstance("SHA-256");
        String stringToHash = messageString + randString;
        byte[] encodedhash = digest.digest(stringToHash.getBytes(StandardCharsets.UTF_8));
        String hexString = bytesToHex(encodedhash);
        return hexToBinary(hexString);  
    }

    private static String bytesToHex(byte[] hash) {
        StringBuilder hexString = new StringBuilder(2 * hash.length);
        for (int i = 0; i < hash.length; i++) {
            String hex = Integer.toHexString(0xff & hash[i]);
            if(hex.length() == 1) {
                hexString.append('0');
            }
            hexString.append(hex);
        }
        return hexString.toString();
    }





    // declaring the method to convert
    // Hexadecimal to Binary
    private static String hexToBinary(String hex)
    {
 
        // variable to store the converted
        // Binary Sequence
        String binary = "";
 
        // converting the accepted Hexadecimal
        // string to upper case
        hex = hex.toUpperCase();
 
        // initializing the HashMap class
        HashMap<Character, String> hashMap
            = new HashMap<Character, String>();
 
        // storing the key value pairs
        hashMap.put('0', "0000");
        hashMap.put('1', "0001");
        hashMap.put('2', "0010");
        hashMap.put('3', "0011");
        hashMap.put('4', "0100");
        hashMap.put('5', "0101");
        hashMap.put('6', "0110");
        hashMap.put('7', "0111");
        hashMap.put('8', "1000");
        hashMap.put('9', "1001");
        hashMap.put('A', "1010");
        hashMap.put('B', "1011");
        hashMap.put('C', "1100");
        hashMap.put('D', "1101");
        hashMap.put('E', "1110");
        hashMap.put('F', "1111");
 
        int i;
        char ch;
 
        // loop to iterate through the length
        // of the Hexadecimal String
        for (i = 0; i < hex.length(); i++) {
            // extracting each character
            ch = hex.charAt(i);
 
            // checking if the character is
            // present in the keys
            if (hashMap.containsKey(ch))
 
                // adding to the Binary Sequence
                // the corresponding value of
                // the key
                binary += hashMap.get(ch);
 
            // returning Invalid Hexadecimal
            // String if the character is
            // not present in the keys
            else {
                binary = "Invalid Hexadecimal String";
                return binary;
            }
        }
 
        // returning the converted Binary
        return binary;
    }
}