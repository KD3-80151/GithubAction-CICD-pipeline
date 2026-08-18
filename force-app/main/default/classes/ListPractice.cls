public class ListPractice {
List<Integer> list1 = new List<Integer>();
    
    public String ListPr(String o, Integer n) {
        if (o == 'add') {
            list1.add(n);
            return 'number ' + n + ' added';
        } else if (o == 'remove') {
            if (list1.contains(n)) {
                list1.remove(list1.indexOf(n));
                return 'number ' + n + ' removed';
            } else {
                return 'number ' + n + ' does not exist';
            }
            
        } else if (o == 'check') {
            Integer index = list1.indexOf(n);
            if (index != -1) {
                return 'Number ' + n + ' at index ' + index + '.';
            } else {
                return 'Number ' + n + ' does not exist';
            }
        } else {
            return 'Invalid operation.';
        }
    }
    public List<Integer> getList() {
        return list1;
    }
}