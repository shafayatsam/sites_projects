public with sharing class ProjectTriggerClass {
    
    public void insertProjects(List<Project__c> projects){
        
        Map<ID, Site__c> flag = new Map<ID, Site__c>();        
            
        for(Project__c p : projects){
            Site__c projectCount = [SELECT Id, (SELECT Id FROM Projects__r) FROM Site__c WHERE Id = :p.Site__c];
            if(p.In_Service_A__c != null){
                if(!flag.containsKey(p.Site__c) && p.Site__r.Site_Status__c != 'On Air'){
                    flag.put(p.Site__c,new Site__c(Id=p.Site__c, Site_Status__c = 'On Air', Number_Of_Projects__c = projectCount.Projects__r.size()));
                }                                
            }
        }        
        update flag.values();
    }
    
    public void updateProjects(List<Project__c> updateP){
        
        Map<ID, Site__c> flag = new Map<ID, Site__c>();
            
        for(Project__c p : updateP){
            Site__c projectCount = [SELECT Id, (SELECT Id, In_Service_A__c FROM Projects__r) FROM Site__c WHERE Id = :p.Site__c];
            Integer count = 0;
            for(Project__c relatedP : projectCount.Projects__r){
                count++;
                if(relatedP.In_Service_A__c != null && !flag.containsKey(projectCount.id)){
                    flag.put(p.Site__c, new Site__c(Id=p.Site__c, Site_Status__c = 'On Air'));
					count--;                    
                }
                else if(count == projectCount.Projects__r.size()){
                    flag.put(p.Site__c, new Site__c(Id=p.Site__c, Site_Status__c = 'Off Air'));
                }
            }
        }        
        update flag.values();
    }
    
    public void deleteProjects(List<Project__c> deleteP){
        
        Map<ID, Site__c> flag = new Map<ID, Site__c>();
            
        for(Project__c p : deleteP){
            Site__c projectCount = [SELECT Id, (SELECT Id, In_Service_A__c FROM Projects__r) FROM Site__c WHERE Id = :p.Site__c];
            Integer count = 0;
            for(Project__c relatedP : projectCount.Projects__r){
                count++;
                if(relatedP.In_Service_A__c != null && !flag.containsKey(projectCount.id)){
                    flag.put(p.Site__c, new Site__c(Id=p.Site__c, Site_Status__c = 'On Air', Number_Of_Projects__c = projectCount.Projects__r.size()));
					count--;                    
                }
                else if(count == projectCount.Projects__r.size()){
                    flag.put(p.Site__c, new Site__c(Id=p.Site__c, Site_Status__c = 'Off Air', Number_Of_Projects__c = projectCount.Projects__r.size()));
                }
            }
        }        
        update flag.values();
    }
    
    
    
}