trigger Race1 on Race1__c (after update) {


    switch on trigger.operationtype {

        when AFTER_UPDATE {
           
            race1Handler.race1Handle();
            

        }
    }

}