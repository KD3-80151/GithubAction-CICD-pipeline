/**
 * ----------------------------------------------------------------------------------------------------
 * @description         : to get and set Account Name
 * @author              : Sagar Kumar
 * @last modified on    : 20/06/2024
 * @last modified date  :  
 * -----------------------------------------------------------------------------------------------------
 **/

 
public class AccountContactShow {
    public class AccountContact {
        public String accName { get; set; }
        public String cFname { get; set; }
        public String cLname { get; set; }
//      public String typeOfData { get; set; }

        public AccountContact(String accName, String cFname, String cLname) {
            this.accName = accName;
            this.cFname = cFname;
            this.cLname = cLname;
        }
    }
    // To search Account and related contact name 
    public static List<AccountContact> searchName(String searchList) {
        List<AccountContact> results = new List<AccountContact>();
        
        List<Account> accountList = [select Name, Type from Account where Name like :('%' + searchList + '%')];
        for (Account acc : accountList) {
            
            results.add(new AccountContact('Account', acc.Name, acc.Type));
        }

        List<Contact> contactList = [select FirstName, LastName from Contact where FirstName like :('%' + searchList + '%') ];
        for (Contact con : contactList) {
            results.add(new AccountContact('Contact', con.FirstName, con.LastName));
        }

        return results;
    }
}