public with sharing class race1Handler {

    public static boolean flag=FALSE;

    public static void race1Handle() {

        List<Race2__c> race2=new List<Race2__c>();

       if(!flag){
           flag=TRUE;
        race2=[Select id,name from Race2__c where id='a08Hz00000A0c6y'];
        race2[0].name=race2[0].name+'updated';
        update race2;
        
        
       



         }
}
}