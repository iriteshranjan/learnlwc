trigger contactCount on Contact (after insert,after update, after delete, after undelete) {

    switch on trigger.operationType{

        when AFTER_INSERT,AFTER_UNDELETE {
            set<Id> ids=new set<Id>();
            for(Contact c:Trigger.new)
            {
                ids.add(c.AccountId);
            } 
            if (!ids.isEmpty())
            {
                List<Account> accountToUpdate =new List<Account>();
                Map<Id,Integer> accIdToCount=new Map<Id,Integer>();
                for(AggregateResult ar:[Select AccountId accId,count(Id) cnt from Contact where AccountId IN:ids GROUP BY AccountId])
                {
                    accIdToCount.put((Id)ar.get('accId'),(Integer)ar.get('cnt'));
                }
                for(Id accId:ids)
                {
                   if(accIdToCount.containsKey(accId))
                   {
                    Integer count=accIdToCount.get(accId);
                    accountToUpdate.add(new Account(Id=accId,Description=String.valueOf(count)));
                   }
                }
                update accountToUpdate;

            // for(Account a:[Select id,(select id from contacts) from account where id IN: ids])
            // {
            //     a.description=String.valueOf(a.contacts.size());
            //     accountToUpdate.add(a);
            // }
            // update accountToUpdate;
        }

        


        }

         When AFTER_UPDATE {
            set<Id> ids=new set<Id>();
            for(Contact c:Trigger.new)
            {
                ids.add(c.AccountId);
            } 
            for(Contact c:Trigger.old)
            {
                ids.add(c.AccountId);
            } 

            if (!ids.isEmpty())
              {
                List<Account> accountToUpdate =new List<Account>();
            for(Account a:[Select id,(select id from contacts) from account where id IN: ids])
            {
                a.description=String.valueOf(a.contacts.size());
                accountToUpdate.add(a);
            }
            update accountToUpdate;
        }


         } 
       
    }

}