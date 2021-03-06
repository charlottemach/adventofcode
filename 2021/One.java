import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

public class One {
    public static void main(String[] args) throws IOException {
        String file = readFile("one.txt");
        String[] lines = file.split("\n");
        Integer[] nums = new Integer[lines.length];
        for(int i=0; i<lines.length; i++) {
            nums[i] = Integer.parseInt(lines[i]);
        }

        // A
        int cntA = 0;
        for(int i =0; i < lines.length - 1; i++){
            if (nums[i] < nums[i+1]) {
                cntA++;
            }
        }
        System.out.println("CountA: " + cntA);

        // B
        int cntB = 0;
        for (int i =0; i < lines.length - 3; i++){
            Integer curSum = nums[i] + nums[i+1] + nums[i+2];
            Integer nxtSum = nums[i+1] + nums[i+2] + nums[i+3];
            if (curSum < nxtSum){
                cntB++;
            }
        }
        System.out.println("CountB: " + cntB);
    }

    private static String readFile(String inputFile) throws IOException {

        StringBuffer buffer = new StringBuffer();
        BufferedReader reader = new BufferedReader(new FileReader(inputFile));
        try{
            String line;
            while ((line = reader.readLine()) != null) {
                buffer.append(line + "\n");
            } 
        }
        catch(IOException e) {  
            e.printStackTrace(); 
        } finally {
            reader.close();
        }
        return buffer.toString();
    }
}
