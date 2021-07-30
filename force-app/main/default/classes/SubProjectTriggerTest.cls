@isTest
public class SubProjectTriggerTest {
    
    @testSetup
    static void DataFactory(){
        Site__c site = new Site__c(Name='WDC', Site_Status__c = 'Off Air', Number_of_Projects__c = 0);
        insert site;        
        Site__c siteId = [select Id from Site__c WHERE Name = 'WDC' LIMIT 1];
        
        Project__c newProject = new Project__c(Name='Test Project for Sub Project', Site__c = siteId.Id);
        insert newProject;
        Project__c projectId = [SELECT Id FROM Project__c WHERE Name = 'Test Project for Sub Project'];
        List<SubProject__c> listOfSubProjects = new List<SubProject__c>();
        for(Integer i = 1; i <= 5; i++){
            listOfSubProjects.add(new SubProject__c(Name='Test SubProject '+i, Project__c = projectId.Id));
        }
        
        insert listOfSubProjects;
    }
    
	@isTest
    static void insertTest(){
        
        Project__c ProjectsWithSubProject = [SELECT Id,Project_Start_A__c, 
                                             (SELECT Id, SubProjectStart__c FROM Sub_Projects__r) 
                                             FROM Project__c WHERE Name = 'Test Project for Sub Project' LIMIT 1];
        
        System.assertEquals(null, ProjectsWithSubProject.Project_Start_A__c);
        
        //==================== New record With Date to check =============================
        SubProject__c newSubProject = new SubProject__c(Name='test Sub project', Project__c = ProjectsWithSubProject.Id, SubProjectStart__c = Date.today());
        insert newSubProject;
        
        Project__c ProjectsWithSubProject2 = [SELECT Id,Project_Start_A__c, (SELECT Id, SubProjectStart__c FROM Sub_Projects__r) 
                                             FROM Project__c WHERE Name = 'Test Project for Sub Project' LIMIT 1];
        
        System.assertEquals(Date.today(), ProjectsWithSubProject2.Project_Start_A__c);        
    }
    
    @isTest
    static void updateTest(){
        
        SubProject__c subProject = [SELECT Id FROM SubProject__c WHERE Name='Test SubProject 2'];
        subProject.SubProjectStart__c = Date.today();
        
        update subProject;
        Project__c ProjectsWithSubProject = [SELECT Id,Project_Start_A__c, 
                                             (SELECT Id, SubProjectStart__c FROM Sub_Projects__r) 
                                             FROM Project__c WHERE Name = 'Test Project for Sub Project' LIMIT 1];        
        System.assertEquals(Date.today(), ProjectsWithSubProject.Project_Start_A__c);
        
        //======================= Add an erlier date =================
        SubProject__c subProject2 = [SELECT Id FROM SubProject__c WHERE Name='Test SubProject 3'];
        subProject2.SubProjectStart__c = Date.today().addDays(-7);
        
        update subProject2;
        Project__c ProjectsWithSubProject2 = [SELECT Id,Project_Start_A__c, 
                                             (SELECT Id, SubProjectStart__c FROM Sub_Projects__r) 
                                             FROM Project__c WHERE Name = 'Test Project for Sub Project' LIMIT 1];        
        System.assertEquals(Date.today().addDays(-7), ProjectsWithSubProject2.Project_Start_A__c);
        
        //==================== Remove Both dates ===========================
        subProject.SubProjectStart__c = null;
        update subProject;
        
        subProject2.SubProjectStart__c = null;
        update subProject2;
        
        Project__c ProjectsWithSubProject3 = [SELECT Id,Project_Start_A__c, 
                                             (SELECT Id, SubProjectStart__c FROM Sub_Projects__r) 
                                             FROM Project__c WHERE Name = 'Test Project for Sub Project' LIMIT 1];
        
        System.assertEquals(null, ProjectsWithSubProject3.Project_Start_A__c);        
    }
    
    @isTest
    static void deleteTest(){
        
        SubProject__c subProject = [SELECT Id FROM SubProject__c WHERE Name='Test SubProject 2'];
        subProject.SubProjectStart__c = Date.today();        
        update subProject;
        
        SubProject__c subProject2 = [SELECT Id FROM SubProject__c WHERE Name='Test SubProject 3'];
        subProject2.SubProjectStart__c = Date.today().addDays(-7);        
        update subProject2;        
        
        Project__c ProjectsWithSubProject = [SELECT Id,Project_Start_A__c, 
                                             (SELECT Id, SubProjectStart__c FROM Sub_Projects__r) 
                                             FROM Project__c WHERE Name = 'Test Project for Sub Project' LIMIT 1];        
        System.assertEquals(Date.today().addDays(-7), ProjectsWithSubProject.Project_Start_A__c);
        
        //=================== Delete the second Date ================
        delete subProject2;
        Project__c ProjectsWithSubProject2 = [SELECT Id,Project_Start_A__c, 
                                             (SELECT Id, SubProjectStart__c FROM Sub_Projects__r) 
                                             FROM Project__c WHERE Name = 'Test Project for Sub Project' LIMIT 1];        
        System.assertEquals(Date.today(), ProjectsWithSubProject2.Project_Start_A__c);
        
    }
    
    @isTest
    static void deleteAll(){
        Project__c ProjectsWithSubProject3 = [SELECT Id,Project_Start_A__c, 
                                             (SELECT Id, SubProjectStart__c FROM Sub_Projects__r) 
                                             FROM Project__c WHERE Name = 'Test Project for Sub Project' LIMIT 1];
        
        List<SubProject__c> toDelete = [Select Id, Project__r.Name FROM SubProject__c WHERE Project__r.Name = 'Test Project for Sub Project'];
        
        delete ProjectsWithSubProject3.Sub_Projects__r;
               
        System.assertEquals(null, ProjectsWithSubProject3.Project_Start_A__c);
    }
    
}