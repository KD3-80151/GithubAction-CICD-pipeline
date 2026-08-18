/**
 * ----------------------------------------------------------------------------------------------------
 * @description         : Strategy Design Pattern
 * @author              : Sagar Kumar
 * @last modified on    : 29/07/2024
 * @last modified date  :  
 * -----------------------------------------------------------------------------------------------------
 **/

public class SortByFirstName implements ContactSortStrategy {
    public List<Contact> sort(List<Contact> contacts) {
        contacts.sort(new Comparator());
        return contacts;
    }

    private class Comparator implements System.Comparator<Contact> {
        public Integer compare(Contact a, Contact b) {
            if (a.FirstName == b.FirstName) {
                return 0;
            }
            return a.FirstName > b.FirstName ? 1 : -1;
        }
    }
}