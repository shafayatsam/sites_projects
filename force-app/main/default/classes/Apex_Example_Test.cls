@isTest
public class Apex_Example_Test {
    @isTest
    static void callMeTest(){
        Apex_Example_Class aec = new Apex_Example_Class();
        aec.callMe();
        System.assertEquals('Sam', aec.name);
        System.assertEquals('Group of ABC', aec.company);
        System.assertEquals('01825266105', aec.contact);
    }
}