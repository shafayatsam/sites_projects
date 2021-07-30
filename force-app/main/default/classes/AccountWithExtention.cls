public class AccountWithExtention {
    
    private ApexPages.StandardSetController setController;
    
    public AccountWithExtention(ApexPages.StandardSetController setController){
        this.setController = setController;
        
        List<Account> accList = [SELECT Name, Type, Rating FROM Account LIMIT 10];
        setController.setSelected(accList);
        
    }
}