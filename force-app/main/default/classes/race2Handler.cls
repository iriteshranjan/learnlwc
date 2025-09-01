public with sharing class race2Handler {



    public static void race2Handle() {

       
        
        if(!race1Handler.flag)
        {
            race1Handler.flag=TRUE;
        List<Race1__c> race1=new List<Race1__c>();
        race1=[Select id,name from Race1__c where id='a07Hz000008ofad'];
        race1[0].name=race1[0].name+'updated';
        update race1;
        }
    



         }
}