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
   /*
    if(Trigger.isInsert || Trigger.isUpdate){
		
        List<Site__c> updateStatus = new List<Site__c>();
        for(Project__c p : [SELECT Id, In_Service_A__c, Site__c, Site__r.Site_Status__c FROM Project__c WHERE Id IN :Trigger.new]){
            
            Site__c sites = [SELECT Id, (SELECT Id, Name FROM Projects__r) FROM Site__c WHERE Id = :p.Site__c];
            if(p.In_Service_A__c != Null && p.Site__r.Site_Status__c != 'On Air'){                
            	Site__c s = new Site__c();
                s.Id = p.Site__c;
            	s.Site_Status__c = 'On Air';
                s.Number_of_Projects__c = sites.Projects__r.size();
            	updateStatus.add(s);
            }else{
            	Site__c s = new Site__c();
                s.Id = p.Site__c;
                s.Number_of_Projects__c = sites.Projects__r.size();
            	updateStatus.add(s);
            }
        }
        
        if(updateStatus.size() > 0){
        	update updateStatus;    
    	}
    }

    
    if(Trigger.isAfter && Trigger.isDelete){        
        List<Site__c> updateStatusDelete = new List<Site__c>();
        for(Project__c dp : Trigger.old){
            for(Project__c sp : [SELECT Site__c, Site__r.Site_Status__c, In_Service_A__c FROM Project__c WHERE Site__c=:dp.Site__c]){
                
                Site__c sites = [SELECT Id, (SELECT Id, Name FROM Projects__r) FROM Site__c WHERE Id = :sp.Site__c]; 
                if(sp.In_Service_A__c != Null && sp.Site__r.Site_Status__c == 'On Air'){                                       
                    Site__c updateSite = new Site__c();
                    updateSite.Id = sp.Site__c;
                    updateSite.Number_of_Projects__c = sites.Projects__r.size();
                    if(!updateStatusDelete.contains(updateSite)){
	                    updateStatusDelete.add(updateSite);
                    }                    
                    break;
                }
                else{					                  
                    Site__c updateSite = new Site__c();
                    updateSite.Id = sp.Site__c;
                    updateSite.Site_Status__c = 'Off Air';
                    updateSite.Number_of_Projects__c = sites.Projects__r.size();
                    if(!updateStatusDelete.contains(updateSite)){
	                    updateStatusDelete.add(updateSite);
                    }
                    
                }
            }
            
            if([SELECT Site__c FROM Project__c WHERE Site__c=:dp.Site__c] == null){
                Site__c updateSite = new Site__c();
                updateSite.Id = dp.Site__c;
                updateSite.Site_Status__c = 'Off Air';
                updateSite.Number_of_Projects__c = 0;
                if(!updateStatusDelete.contains(updateSite)){
                    updateStatusDelete.add(updateSite);
                }
            }            
        }       
        
        if(updateStatusDelete.size() > 0){
            update updateStatusDelete;
        }
    }    
    
}*/

/*
List<Id> site_statuses = new List<Id>();
    	
		List<Id> updateNumbers = new List<Id>(); 
        
        for(Project__c project : Trigger.new){
            if(project.In_Service_A__c != null){
                site_statuses.add(project.Id);
            }else{
                updateNumbers.add(project.Id);
            }
        }
*/