public class EmailMissionSpecialist {
    
    public void sendMail(String[] address, String subject, String body){
        
        Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
        
        msg.setToAddresses(address);
        msg.setSubject('Test Email');
        msg.setPlainTextBody('This is the body of test email');
        
        Messaging.SendEmailResult[] result = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {msg});
        
        inspectResults(result);        
    }
    
    public Boolean inspectResults(Messaging.SendEmailResult[] result){
        
        Boolean sendMail = true;
        for(Messaging.SendEmailResult res : result){
            if(res.isSuccess()){
                System.debug('Mail have successfully sent');
            }else{
                sendMail = false;
                System.debug('Failed to sent : '+res.getErrors());
            }
        }
        return sendMail;
    }

}