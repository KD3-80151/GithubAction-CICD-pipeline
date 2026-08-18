public with sharing class AccountTableController {
    // Public property for VF to bind
    public List<Account> accounts { get; private set; }

    // Constructor - fetch some account fields (adjust fields/limit as needed)
    public AccountTableController() {
        // simple query - change WHERE clause / ORDER BY / LIMIT for your needs
        accounts = [
            SELECT Id, Name, Industry, Phone, AnnualRevenue
            FROM Account
            ORDER BY LastModifiedDate DESC
            LIMIT 100
        ];
    }

    // Example action method if you want to refresh data via commandButton
    public PageReference refresh() {
        accounts = [
            SELECT Id, Name, Industry, Phone, AnnualRevenue
            FROM Account
            ORDER BY LastModifiedDate DESC
            LIMIT 100
        ];
        return null;
    }
}