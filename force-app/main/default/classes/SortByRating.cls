public class SortByRating implements Comparator{
    
    public Integer compare(Object a, Object b){
        ComparatorAndComparablePrac cc1 = (ComparatorAndComparablePrac) a;
        ComparatorAndComparablePrac cc2 = (ComparatorAndComparablePrac) b;
        return cc1.rating - cc2.rating;
    }
}