trigger testcontact on Contact (after insert) {
    
    switch on trigger.operationType {
        when After_Insert {
            Set<Id> idd=new set<Id>();
            for(Contact i:trigger.new)
            {
                idd.add(i.AccountId);
            }
           Map<Id, Integer> accountContactCounts = new Map<Id, Integer>();
            for(AggregateResult ar:[Select AccountId,Count(Id) cnt from Contact where AccountId in :idd group by AccountId])
            {
                accountContactCounts.put((Id)ar.get('AccountId'),(integer)ar.get('cnt'));
            }
            List<Account> accountsToUpdate = new List<Account>();
            for(Id ac:idd)
            {
                accountsToUpdate.add(new Account(id=ac,description=String.valueof(accountContactCounts.get(ac))));
            }
            update accountsToUpdate;
            
        }
    }

}