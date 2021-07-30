public class AccountCustomController {
    public Account accobj {set;get;}
    
    public AccountCustomController(){
        accobj=new Account();
    }
    
    public pagereference saveAccount(){
        insert accobj;
        return new pagereference('/'+accobj.Id);
    }
}