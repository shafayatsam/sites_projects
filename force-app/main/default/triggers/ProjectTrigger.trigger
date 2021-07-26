trigger ProjectTrigger on Project__c (after insert, after update, after delete) {
    
    ProjectTriggerClass ptc = new ProjectTriggerClass();
    
    if(Trigger.isInsert){
        ptc.insertProjects(Trigger.new);
    }else if(Trigger.isUpdate){
        ptc.updateProjects(Trigger.new);
    }else if(Trigger.isDelete){
        ptc.deleteProjects(Trigger.old);
    }
}