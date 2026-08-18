public class ComparatorAndComparablePrac implements Comparable{
   
    public String name;
    public Integer rating;

     public ComparatorAndComparablePrac(String name, Integer rating) {
        this.name = name;
        this.rating = rating;
    }

    public Integer compareTo(Object other){
        ComparatorAndComparablePrac cpI = (ComparatorAndComparablePrac) other;
        return this.name.compareTo(cpI.name);
    }
}

/*

List<ComparatorAndComparablePrac> accList = new List<ComparatorAndComparablePrac>{
    new ComparatorAndComparablePrac('Zeta Corp', 5),
    new ComparatorAndComparablePrac('Alpha Inc', 8),
    new ComparatorAndComparablePrac('Beta Ltd', 2)
};

accList.sort(); 

for (ComparatorAndComparablePrac acc : accList) {
    System.debug(acc.name);
}

*/