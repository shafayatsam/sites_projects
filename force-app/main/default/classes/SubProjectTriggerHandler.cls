public with sharing class SubProjectTriggerHandler {
    
    //I Assume that the oldest date among sub project start will be the project start date
    //if any of the oldest date gets deleted then the 2nd oldest date among sub project start would be the project start date
    //If any update happens on sub project start date then the project start date will be recalculated to the oldest.
    
    //Insert Handler
    public void isInsertSubProject(List<SubProject__c> subProject){
        
        List<Project__c> psa = new List<Project__c>();
        
        Set<ID> projectId = new Set<ID>();
        For(SubProject__c subP : subProject){
            projectId.add(subP.Project__c);
        }
        
        List<Project__c> subProsList = [SELECT Id, Project_Start_A__c,
                                        (SELECT Id, SubProjectStart__c FROM Sub_Projects__r ORDER BY SubProjectStart__c NULLS LAST) 
                                        FROM Project__c WHERE Id IN :projectId];
        for(Project__c spl : subProsList){
            if(spl.Sub_Projects__r[0].SubProjectStart__c != null){
                psa.add(new Project__c(Id = spl.Id, Project_Start_A__c = spl.Sub_Projects__r[0].SubProjectStart__c));
            }
        }
        
        update psa;
    }
    
    //Update Handler
    public void isUpdateSubProject(List<SubProject__c> subProject){
        
        List<Project__c> psa = new List<Project__c>();
        Set<ID> projectId = new Set<ID>();
        for(SubProject__c subP : subProject){
            if(subP.SubProjectStart__c != Trigger.OldMap.get(subP.Id).get('SubProjectStart__c')){
                projectId.add(subp.Project__c);
            }
        }
        List<Project__c> subProsList = [SELECT Id, Project_Start_A__c,
                                        (SELECT Id, SubProjectStart__c FROM Sub_Projects__r ORDER BY SubProjectStart__c NULLS LAST) 
                                        FROM Project__c WHERE Id IN :projectId];
        for(Project__c spl : subProsList){
            if(spl.Sub_Projects__r[0].SubProjectStart__c != null){
                psa.add(new Project__c(Id = spl.Id, Project_Start_A__c = spl.Sub_Projects__r[0].SubProjectStart__c));
            }else{
                psa.add(new Project__c(Id = spl.Id, Project_Start_A__c = null));
            }
        }
      	update psa;        
    }
       
    //Delete Handler
    public void isDeleteSubProject(List<SubProject__c> subProject){
        List<Project__c> psa = new List<Project__c>();
        Set<ID> projectId = new Set<ID>();
        
        for(SubProject__c subP : subProject){
            projectId.add(subP.Project__c);
        }
        List<Project__c> subProsList = [SELECT Id, Project_Start_A__c,
                                        (SELECT Id, SubProjectStart__c FROM Sub_Projects__r ORDER BY SubProjectStart__c NULLS LAST) 
                                        FROM Project__c WHERE Id IN :projectId];
        for(Project__c spl : subProsList){
            if(!spl.Sub_Projects__r.isEmpty() && spl.Sub_Projects__r[0].SubProjectStart__c != null){
                psa.add(new Project__c(Id = spl.Id, Project_Start_A__c = spl.Sub_Projects__r[0].SubProjectStart__c));
            }else if((!spl.Sub_Projects__r.isEmpty() && spl.Sub_Projects__r[0].SubProjectStart__c == null) || spl.Sub_Projects__r.isEmpty()){
                psa.add(new Project__c(Id = spl.Id, Project_Start_A__c = null));
            }
        }
      	update psa;        
    }
    
    
}