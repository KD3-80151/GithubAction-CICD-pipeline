public class AccountFluent {
    private Account acc;

    private AccountFluent() {
        acc = new Account();
    }

    public static AccountFluent create() {
        return new AccountFluent();
    }

    public AccountFluent name(String name) {
        acc.Name = name;
        return this;
    }

    public AccountFluent industry(String industry) {
        acc.Industry = industry;
        return this;
    }

    public AccountFluent rating(String rating) {
        acc.Rating = rating;
        return this;
    }

    public Account build() {
        return acc;
    }

    public Account insertRecord() {
        insert acc;
        return acc;
    }
}