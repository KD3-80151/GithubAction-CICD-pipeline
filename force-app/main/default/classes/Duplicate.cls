public class Duplicate {
    public static void printDuplicates(String str) {
        Map<String, Integer> count = new Map<String, Integer>();
      //  List<String> charArray = new List<String>();
      /*  for (Integer i = 0; i < str.length(); i++) {
            String c = String.valueOf(str.charAt(i));
            //charArray.add();
            
            if (count.containsKey(c)) {
                count.put(c, count.get(c) + 1);
            } else {
                count.put(c, 1);
            }
        }*/

for (Integer i = 0; i < str.length(); i++) {
            String c = str.substring(i, i+1);
            //charArray.add();
            if (count.containsKey(c)) {
                count.put(c, count.get(c) + 1);
            } else {
                count.put(c, 1);
            }
        }
        System.debug('Duplicate characters and their counts:' );
        for (String key : count.keySet()) {
            if (count.get(key) > 1) {
                System.debug(key + ': ' + count.get(key));
            }
        }
    }
}