@isTest
public class ProjectTriggerTest {
    
    @testSetup
    static void DataFactory(){
        
        Site__c site = new Site__c(Name='WDC', Site_Status__c = 'Off Air', Number_of_Projects__c = 0);
        insert site;
        
        Site__c siteId = [select Id from Site__c WHERE Name = 'WDC' LIMIT 1];
        
        List<Project__c> listOfProject = new List<Project__c>();
        for(Integer i = 1; i <= 5; i++){
            listOfProject.add(new Project__c(Name='Test Project '+i, Site__c = siteId.Id));
        }
        insert listOfProject;
    
    }
	
    @isTest
    static void insertTestWithoutDate(){
                        
        Site__c siteWithProjects = [select Id, Site_Status__c, Number_of_Projects__c, 
                                    (select Id, In_Service_A__c from Projects__r) from Site__c where name = 'WDC' LIMIT 1];
        
        System.assertEquals(siteWithProjects.Number_of_Projects__c , siteWithProjects.Projects__r.size());
        System.assertEquals('Off Air', siteWithProjects.Site_Status__c);
    }
    
    @isTest
    static void insertTestWithDate(){
        Site__c siteId = [select Id from Site__c WHERE Name = 'WDC' LIMIT 1];
        
        Project__c projectWithDate = new Project__C(Name='Test Project X', In_Service_A__c = Date.newInstance(2021, 8, 5), Site__c = siteId.Id);
        insert projectWithDate;
        
        Site__c siteWithProjects = [select Id, Site_Status__c, Number_of_Projects__c, 
                                    (select Id, In_Service_A__c from Projects__r) from Site__c where name = 'WDC' LIMIT 1];
        
        System.assertEquals(siteWithProjects.Number_of_Projects__c , siteWithProjects.Projects__r.size());
        System.assertEquals('On Air', siteWithProjects.Site_Status__c);       
    }
    
    @isTest
    static void updateTest(){
               
        Project__c ap = [SELECT Id, In_Service_A__c FROM Project__c WHERE Name='Test Project 5'];
        ap.In_Service_A__c = Date.newInstance(2021, 9, 9);
        update ap;
        
        Site__c siteWithProjects = [select Id, Site_Status__c, Number_of_Projects__c,
                                    (select Id, In_Service_A__c from Projects__r) from Site__c where name = 'WDC' LIMIT 1];
        
        System.assertEquals(siteWithProjects.Number_of_Projects__c , siteWithProjects.Projects__r.size());        
        System.assertEquals('On Air', siteWithProjects.Site_Status__c);  
        
        //=================== Remove the Date =========================
        Project__c ap2 = [SELECT Id, In_Service_A__c FROM Project__c WHERE Name='Test Project 5'];
        ap2.In_Service_A__c = null;
        update ap2;
        
        Site__c siteWithProjects2 = [select Id, Site_Status__c, Number_of_Projects__c,
                                    (select Id, In_Service_A__c from Projects__r) from Site__c where name = 'WDC' LIMIT 1];
        
        System.assertEquals(siteWithProjects2.Number_of_Projects__c , siteWithProjects2.Projects__r.size());        
        System.assertEquals('Off Air', siteWithProjects2.Site_Status__c);  
    }
    
    @isTest
    static void deleteTest(){
        
        Project__c ap = [SELECT Id, In_Service_A__c FROM Project__c WHERE Name='Test Project 5'];
        ap.In_Service_A__c = Date.newInstance(2021, 9, 9);
        update ap;
        
        
        Project__c deleteProject = [SELECT Id FROM Project__c WHERE Name='Test Project 2'];        
        delete deleteProject;
        
        Site__c ProjectsAfterDelete = [select Id, Site_Status__c, Number_of_Projects__c,
                                    (select Id, In_Service_A__c from Projects__r) from Site__c where name = 'WDC' LIMIT 1];
        
        System.assertEquals(ProjectsAfterDelete.Number_of_Projects__c , ProjectsAfterDelete.Projects__r.size());        
        System.assertEquals('On Air', ProjectsAfterDelete.Site_Status__c);
        
        //================== Detele the record which have In Service Date ==================
        delete ap;
        
        Site__c siteWithProjects = [select Id, Site_Status__c, Number_of_Projects__c,
                                    (select Id, In_Service_A__c from Projects__r) from Site__c where name = 'WDC' LIMIT 1];
        
        System.assertEquals(siteWithProjects.Number_of_Projects__c , siteWithProjects.Projects__r.size());        
        System.assertEquals('Off Air', siteWithProjects.Site_Status__c);
        
        
    }
    
}