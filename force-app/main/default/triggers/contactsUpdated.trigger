trigger contactsUpdated on Contact (after update) {
  
    switch on trigger.operationType{
        when AFTER_Update {
            set<Id> idss =new set<Id>();
            for(Contact ids:trigger.new)
            {
                idss.add(ids.AccountId);
            }
            Map<Id,Integer> con =new Map<Id,Integer>();
            for(contact conn:trigger.new)
            {
                if(con.containsKey(conn.AccountId))
                {
                    con.put(conn.AccountId,con.get(conn.AccountId)+1);
                }
                else
                {
                     con.put(conn.AccountId,1);
                }
            }
            List<Account> acc=[Select id,description from account where id in:idss];
            for(Account ac:acc)
            {
                ac.description=String.valueOf(con.get(ac.id)+Integer.valueOf(ac.description));
            }
            update acc;

                        }
                    }

}