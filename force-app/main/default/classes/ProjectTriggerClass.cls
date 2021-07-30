public with sharing class ProjectTriggerClass {
    
    public void insertProjects(List<Project__c> projects){
        
        Map<ID, Site__c> flag = new Map<ID, Site__c>();
        
        Set<ID> siteId = new Set<ID>();        
        For(Project__c project : projects){
            siteId.add(project.Site__c);
        }        
        List<Site__c> parentSites = [SELECT Id, Site_Status__c, (SELECT Site__c, In_Service_A__c, Site__r.Site_Status__c FROM Projects__r) FROM Site__c WHERE Id IN :siteId];        
        
        for(Site__c s : parentSites){
            Site__c siteAdd = new Site__c();
            for(Project__c p : s.Projects__r){            
                if(p.In_Service_A__c != null){
                    if(!flag.containsKey(p.Site__c) && p.Site__r.Site_Status__c != 'On Air'){
                        siteAdd = new Site__c(Site_Status__c = 'On Air');
                    }                    
                    break;
                }
            }
            siteAdd.Id = s.Id;
            siteAdd.Number_of_Projects__c = s.Projects__r.size();
            flag.put(s.Id, siteAdd);
        }        
        update flag.values();
    }
    
    public void updateProjects(List<Project__c> updateP){
        Map<ID, Site__c> flag = new Map<ID, Site__c>();
        
        Set<ID> siteId = new Set<ID>();     //A = Old->InService  B = Old->Null **** A = New->Null B = New->inService   
        For(Project__c project : updateP){
            if(project.In_Service_A__c != ((Project__c)(Trigger.oldMap.get(project.Id))).In_Service_A__c){
            	siteId.add(project.Site__c);
            }
        }        
        List<Site__c> parentSites = [SELECT Id, Site_Status__c, (SELECT Site__c, In_Service_A__c FROM Projects__r) FROM Site__c WHERE Id IN :siteId];        
        
        for(Site__c s : parentSites){
            
            Boolean hasDate = false;
            
            for(Project__c p : s.Projects__r){  
                if(p.In_Service_A__c != null){
                    hasDate = true;
                    if(!flag.containsKey(p.Site__c) && s.Site_Status__c != 'On Air'){
                        flag.put(p.Site__c,new Site__c(Id=p.Site__c, Site_Status__c = 'On Air', Number_Of_Projects__c = s.Projects__r.size()));
                    }                    
                    break;
                }
            }
            if(!hasDate){
            	flag.put(s.Id,new Site__c(Id=s.Id, Site_Status__c = 'Off Air', Number_Of_Projects__c = s.Projects__r.size()));               
            }
        }        
        update flag.values();
       
    }
    
    public void deleteProjects(List<Project__c> deleteP){
        
        Map<ID, Site__c> flag = new Map<ID, Site__c>();
        Set<ID> siteId = new Set<ID>();        
        For(Project__c project : deleteP){
            siteId.add(project.Site__c);
        }
		System.debug(siteId);        
        List<Site__c> parentSite = [SELECT Id, Site_Status__c, (SELECT Id, Site__c, In_Service_A__c FROM Projects__r) FROM Site__c WHERE Id IN :siteId];            
        for(Site__c s : parentSite){
            System.debug(s);
            Boolean hasDate = false;                
            for(Project__c p : s.Projects__r){ 
                System.debug(p);
                if(p.In_Service_A__c != null){
                    hasDate = true;
                    System.debug(s.Projects__r.size());
                    if(!flag.containsKey(s.Id)){
                        flag.put(p.Site__c,new Site__c(Id=p.Site__c, Site_Status__c = 'On Air', Number_Of_Projects__c = s.Projects__r.size()));
                    }                    
                    break;
                }
            }
            if(!hasDate || s.Projects__r.isEmpty()){
                flag.put(s.Id, new Site__c(Id=s.Id, Site_Status__c = 'Off Air', Number_Of_Projects__c = s.Projects__r.size()));               
            }
        }
        System.debug(JSON.serializePretty(flag));
        update flag.values();        
    }
               
}