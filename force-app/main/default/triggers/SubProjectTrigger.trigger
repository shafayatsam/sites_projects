trigger SubProjectTrigger on SubProject__c (after insert, after update, after delete) {
    
    SubProjectTriggerHandler spth = new SubProjectTriggerHandler();
    
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            spth.isInsertSubProject(Trigger.new);
        }
        else if(Trigger.isUpdate){
            spth.isUpdateSubProject(Trigger.new);
        }else if(Trigger.isDelete){
            spth.isDeleteSubProject(Trigger.old);
        }
    }
}