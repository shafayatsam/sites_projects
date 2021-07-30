public class createAccountController {
    
    public String accountName {set;get;}
    public String accountType {set;get;}
    
    public pagereference saveRecord(){
        Account newAcc = new Account(Name=accountName, Type=accountType);
        insert newAcc;
        return new pagereference('/'+newAcc.Id);
    }  

}