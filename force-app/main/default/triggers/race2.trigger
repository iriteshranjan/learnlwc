trigger race2 on Race2__c (after update) {

    switch on trigger.operationtype{

        when AFTER_UPDATE{
            race2Handler.race2Handle();

        }
    }

}