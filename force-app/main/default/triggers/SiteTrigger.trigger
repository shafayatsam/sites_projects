trigger SiteTrigger on Site__c (before insert, before update, before delete) {
    
    if(Trigger.isInsert || Trigger.isUpdate){
        
    }
}