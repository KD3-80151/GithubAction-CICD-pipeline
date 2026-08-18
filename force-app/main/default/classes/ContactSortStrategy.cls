/**
 * ----------------------------------------------------------------------------------------------------
 * @description         : Strategy Design Pattern
 * @author              : Sagar Kumar
 * @last modified on    : 29/07/2024
 * @last modified date  :  
 * -----------------------------------------------------------------------------------------------------
 **/


//different strategies for sorting a list of contacts.
public interface ContactSortStrategy {
    List<Contact> sort(List<Contact> contacts);
    
}