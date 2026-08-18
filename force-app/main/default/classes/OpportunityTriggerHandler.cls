public class OpportunityTriggerHandler {
    public static void OpportunityClosed(List<Opportunity> oppoList){
        
        Profile prof = [Select Id From Profile where Name = 'System Administrator' LIMIT 1];
        
        for(Opportunity oppo: oppoList){
            if(System.UserInfo.getProfileId() != prof.Id && (oppo.StageName =='Closed Won' || oppo.StageName =='Closed Lost')){
                oppo.addError('You are not admin and so you cannot delete it ');
                
            }
        }
        
    }
    
    private static boolean isExecuting = false; //prevent recursive trigger executions
    public static void updateAccountRollup(Set<Id> opportunityIds){
        if(isExecuting || opportunityIds.isEmpty()) return;
        isExecuting = true;
        try{
            //getRelateds ids of an account
            Set<Id> accntIds = new Set<Id>();
            List<Opportunity> oppList = [select Id, AccountId from Opportunity where Id IN :opportunityIds];
            for(Opportunity opp : oppList){
                if(opp.AccountId != null) accntIds.add(opp.AccountId);
            }
            if(accntIds.isEmpty()) return;
            
            //query aggregate data for each account
            AggregateResult[] ar = [select SUM(Amount) sAmt, COUNT(Id) cId, AccountId from Opportunity where AccountId IN: accntIds group by AccountId, StageName];
            Map<Id, Decimal> totalClosWonOpp = new Map<Id, Decimal>();
            Map<Id, Integer> totaOpenCount =  new Map<Id, Integer>();
            
            for(AggregateResult ar1: ar){
                Id accId = (Id)ar1.get('AccountId'); //The get() method of AggregateResult always returns an Object type. so typecaste
                //ar1.get('AccountId') → returns an Object (e.g. "001XXXXXXXXXXXX").
                //(Id) → tells Apex: “Treat this Object as an Id type.”
                //Now accId is strongly typed as Id, so you can use it in queries, sets, or comparisons.
                String stage = (String)ar1.get('StageName');
                
                if(stage == 'Closed Won'){ totalClosWonOpp.put(accId, (Decimal)ar1.get('sAmt')); }
                else{ Integer currentCount = totaOpenCount.containsKey(accId) ? totaOpenCount.get(accId) : 0;
                     totaOpenCount.put(accId, currentCount + Integer.valueOf(ar1.get('cId')));
                    }
                
                //to fetch parent hierarchy
                Map<Id, Account> fetchParent = new Map<Id, Account>([select Id, ParentId from Account where Id IN :accntIds]);
                //prepare accounts for update
                List<Account> acntsToUpdate = new List<Account>();
                for(Id acId : accntIds){
                    Account acc = new Account(Id = acId);
                    acc.Total_Closed_Won_Amount__c = totalClosWonOpp.containsKey(acId) ? totalClosWonOpp.get(acId) : 0;
                    acc.Total_Open_Opportunity_Count__c = totaOpenCount.containsKey(acId) ? totaOpenCount.get(acId) : 0;
                    acntsToUpdate.add(acc);
                    
                    //update parent hierarchy 
                    if(fetchParent.get(acId).ParentId != null){
                        Id parent = fetchParent.get(acId).ParentId;
                        Account parentAccount = new Account(Id = acId);
                        parentAccount.Total_Closed_Won_Amount__c = acc.Total_Closed_Won_Amount__c;//totalClosWonOpp.containsKey(acId) ? totalClosWonOpp.get(acId) : 0;
                        parentAccount.Total_Open_Opportunity_Count__c = acc.Total_Open_Opportunity_Count__c; //totaOpenCount.containsKey(acId) ? totaOpenCount(acId) : 0;
                        acntsToUpdate.add(parentAccount);
                    }
                    
                    
                }
                if(!acntsToUpdate.isEmpty()){
                    update acntsToUpdate;
                }
                
            }
            
        }
        catch(Exception e){
            System.debug('At line issue ::>>' + e.getLineNumber() + 'stacktrace::>>' + e.getStackTraceString());
        }
        
        finally {
            isExecuting = false;
        }
    }
    
    private static boolean isExecuted = false;
    public static void handleOpportunityStageChange(List<Opportunity> oldOpp, map<Id,Opportunity> oldOppMap){
        
        Set<Id> setOfAccntIds = new Set<Id>();
        List<Opportunity_History__c> listOfOHToUpdate = new List<Opportunity_History__c>();
        
        //for(Opportunity opp: old) 
    }
    
    private static boolean isDupName = false;
    public static void ceckDupName(List<Opportunity> newList, map<Id,Opportunity> oldOppMap){
        
        set<Id> newOppSet = new set<Id>();
        for(Opportunity opp: newList){
            
        }
    }
    
    public static void maintainTEmpCountStage(List<Opportunity> newOppList){
        set<Id> newSetOfIds = new Set<Id>();
        
    }
    
    //to populate the field with OLI product name
    private static boolean isNewOpp = false;
    public static void updateSelfLookupProductName(List<Opportunity> newList, Map<Id, Opportunity> oldMap){
        system.debug('newListOppIds::>>' + newList);
        system.debug('oldMapIds:::>>' + oldMap);
        if(isNewOpp) return;
        isNewOpp = true;
        try{
            if(newList == null || newList.isEmpty()) return;
            
            Map<Id,Id> targetToProcess = new Map<Id,Id>(); 
            set<Id> refOppIdNeedToQuery = new set<Id>();
            
            //to loop through all updated opportunities
            for(Opportunity opp: newList){
                Opportunity oldOpp = oldMap.get(opp.Id);
                system.debug('oldOpp::::>>' + oldOpp);
                system.debug('opp.Opportunity__c::'+ opp.Opportunity__c);
                system.debug('oldOpp.Opportunity__c::>>' + oldOpp.Opportunity__c);
                if(oldOpp == null || opp.Opportunity__c != oldOpp.Opportunity__c){
                    targetToProcess.put(opp.Id, opp.Opportunity__c);
                    if(opp.Opportunity__c != null){
                        refOppIdNeedToQuery.add(opp.Opportunity__c);
                    }
                }
            }
            
            map<Id,set<String>> prodNamesByOpp = new map<Id,set<String>>();
            list<OpportunityLineItem> oliList = [select OpportunityId , PricebookEntry.Product2.Name from OpportunityLineItem where OpportunityId IN :refOppIdNeedToQuery];
            if(!refOppIdNeedToQuery.isEmpty()){
                for(OpportunityLineItem oli: oliList){
                    if(!prodNamesByOpp.containsKey(oli.OpportunityId)){
                        prodNamesByOpp.put(oli.OpportunityId, new Set<String>());
                    }
                    String prodNames =(oli.PricebookEntry != null && oli.PricebookEntry.Product2 != null) ? oli.PricebookEntry.Product2.Name : null;
                    if(prodNames != null){
                        prodNamesByOpp.get(oli.OpportunityId).add(prodNames);
                    }
                }
            }
            
            list<Opportunity> oppToUpdate = new list<Opportunity>();
            for(Id targetId : targetToProcess.keySet()){
                Id refId = targetToProcess.get(targetId);
                Opportunity oppToUpd = new Opportunity(Id = targetId);
                
                if(refId == null){
                    oppToUpd.Self_Opp_Prod_Name__c = null;
                }
                else{
                    set<String> names = prodNamesByOpp.get(refId);
                    if(names == null || names.isEmpty()){
                        oppToUpd.Self_Opp_Prod_Name__c = null;
                    }
                    else{
                        list<String> nameList = new list<String>();
                        nameList.addAll(names);
                        oppToUpd.Self_Opp_Prod_Name__c = String.join(nameList, ', ');
                    }
                }
                oppToUpdate.add(oppToUpd);
            }
            
            if(!oppToUpdate.isEmpty()){
                update oppToUpdate;
            }
            
        }
        catch(Exception e){
            system.debug('Error at line ::' + e.getLineNumber() + 'error message :::' + e.getMessage());
        }
        
        finally{
            isNewOpp = false;
        }
        
    }
    
    
    public static void updateAccountFromOpp(list<Opportunity> newOppAccount){
        
    }
    
    public static void sendEmailToOpp(list<Id> newOppToSend, Map<Id, Opportunity> oldOpp){
        set<Id> oppIds = new set<Id>();
        if(oppIds != null){
            
        //for(Opportunity opp : newOppToSend)
        //}
    }
    
    }
    
    public static void preventOppToCloseLostWhenCOntractIsActive(list<Opportunity> newOpp){
        system.debug('newOPp::' + newOpp);
        set<Id> accntIds = new Set<Id>();
        for(Opportunity opp : newOpp){
            if(opp.AccountId != null){
				accntIds.add(opp.AccountId);
            }
        }
        
        Map<Id,Contract> contractWithOpp = new Map<Id, Contract>([select Id, AccountId from Contract where AccountId IN : accntIds and Status = 'Activated']);
        system.debug('contractWithOpp::' + contractWithOpp);
        for(Opportunity contMapOpp : newOpp){
            system.debug('contMapOpp.StageName::' + contMapOpp.StageName);
            system.debug('contractWithOpp.containsKey(contMapOpp.AccountId)::' + contractWithOpp.containsKey(contMapOpp.AccountId));
            if(contMapOpp.StageName == 'Closed Lost' && contractWithOpp.containsKey(contMapOpp.AccountId)){
                system.debug('enter the condition');
                contMapOpp.addError('You can\'t delete this Opportunity');
            }
        }
    }
    
    private static boolean isAccntNotMoreTwentyOpp = false;
    public static void accntNotMoreTwentyOpp(list<Opportunity> newOpp, Map<Id, Opportunity> oldMap){
        if(isAccntNotMoreTwentyOpp) return;
        isAccntNotMoreTwentyOpp = true;
        Set<Id> accntIds = new Set<Id>();
        for(Opportunity opp : newOpp){
            if(opp.AccountId != null){
                accntIds.add(opp.AccountId);
            }
            
            //we need to handle update case also
            if(oldMap != null && oldMap.containsKey(opp.Id)){
                Opportunity oldOpp = oldMap.get(opp.Id);
                if(oldOpp.AccountId != opp.AccountId && oldOpp.AccountId != null){
                    accntIds.add(oldOpp.AccountId);
                }
            }
        }
        if (accntIds.isEmpty()) return;
        
        Map<Id,List<Opportunity>> accountOppMap = new Map<Id,List<Opportunity>>();
        for(Opportunity oppInMap : [select Id, Name, AccountId, CreatedDate from Opportunity where AccountId IN : accntIds order by CreatedDate]){
            if(!accountOppMap.containsKey(oppInMap.AccountId)){
                accountOppMap.put(oppInMap.AccountId, new list<Opportunity>());
            }
            accountOppMap.get(oppInMap.AccountId).add(oppInMap);
        }
        
        list<Account> newAccountToInsert = new List<Account>();
        Map<Id, List<Opportunity>> oppToMovesMap = new Map<Id, List<Opportunity>>();
        Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id, Name FROM Account WHERE Id IN :accountOppMap.keySet()]);
        
        for(Id accntId : accountOppMap.keySet()){
            List<Opportunity> oppList = accountOppMap.get(accntId);
            if(oppList.size() > 20){
                Integer extraCount = oppList.size() - 20;
                Account originalAccount = [select Id, Name from Account where Id = :accntId limit 1];
                Integer version = 1;
                
                Account newAcc = originalAccount.clone(false, true, false, false);
				newAcc.Name = originalAccount.Name + 'v'+ version;
                newAccountToInsert.add(newAcc);
                
                list<Opportunity> extraOpp = new List<Opportunity>();
                for(Integer i = 0; i < oppList.size(); i++){
                    extraOpp.add(oppList[i]);
                }
                oppToMovesMap.put(accntId, extraOpp);
            }
        }
        
        if(!newAccountToInsert.isEmpty()){
            insert newAccountToInsert;
        }
        
        List<Opportunity> oppToUpdate = new List<Opportunity>();
        Integer index = 0;
        
                
    }
    
    //====================

    private static Boolean isRunning = false;

    public static void handleOpportunityLimit(List<Opportunity> newList, Map<Id, Opportunity> oldMap){

        if(isRunning) return;
        isRunning = true;

        Set<Id> accountIds = new Set<Id>();

        // Collect AccountIds (including old ones in update)
        for(Opportunity opp : newList){
            if(opp.AccountId != null){
                accountIds.add(opp.AccountId);
            }

            if(oldMap != null && oldMap.containsKey(opp.Id)){
                Opportunity oldOpp = oldMap.get(opp.Id);
                if(oldOpp.AccountId != null){
                    accountIds.add(oldOpp.AccountId);
                }
            }
        }

        if(accountIds.isEmpty()) return;

        Map<Id, List<Opportunity>> accountOppMap = new Map<Id, List<Opportunity>>(); // this map is used to map account with theeir related opp

        for(Opportunity opp : [SELECT Id, Name, AccountId, CreatedDate FROM Opportunity WHERE AccountId IN :accountIds ORDER BY CreatedDate ASC]){
            if(!accountOppMap.containsKey(opp.AccountId)){
                accountOppMap.put(opp.AccountId, new List<Opportunity>());
            }
            accountOppMap.get(opp.AccountId).add(opp);
        }

        Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id, Name FROM Account WHERE Id IN :accountIds]);

        List<Account> newAccountsToInsert = new List<Account>();
        Map<Id, List<Opportunity>> accountToExtraOpps = new Map<Id, List<Opportunity>>();

        for(Id accId : accountOppMap.keySet()){
            List<Opportunity> oppList = accountOppMap.get(accId);
            system.debug('OPplist to map with more than 20' + oppList);
            if(oppList.size() > 20){
                List<Opportunity> extraOpps = new List<Opportunity>();
                for(Integer i = 20; i < oppList.size(); i++){
                    extraOpps.add(oppList[i]);
                }
                accountToExtraOpps.put(accId, extraOpps);
            }
        }

        if(accountToExtraOpps.isEmpty()) return;

        Map<Id, List<Account>> accIdToNewAccounts = new Map<Id, List<Account>>();

        for(Id accId : accountToExtraOpps.keySet()){

            List<Opportunity> extraOpps = accountToExtraOpps.get(accId);
            Account originalAcc = accountMap.get(accId);

            Integer version = 1;
            Integer index = 0;

            while(index < extraOpps.size()){

                Account newAcc = originalAcc.clone(false, true, false, false);
                newAcc.Name = originalAcc.Name + ' v' + version;

                newAccountsToInsert.add(newAcc);

                if(!accIdToNewAccounts.containsKey(accId)){
                    accIdToNewAccounts.put(accId, new List<Account>());
                }
                accIdToNewAccounts.get(accId).add(newAcc);

                version++;
                index += 20;
            }
        }

        insert newAccountsToInsert;

        List<Opportunity> oppsToUpdate = new List<Opportunity>();

        for(Id accId : accountToExtraOpps.keySet()){

            List<Opportunity> extraOpps = accountToExtraOpps.get(accId);
            List<Account> newAccList = accIdToNewAccounts.get(accId);

            Integer oppIndex = 0;
            Integer accIndex = 0;

            for(Opportunity opp : extraOpps){

                Account targetAcc = newAccList[accIndex];

                opp.AccountId = targetAcc.Id;
                oppsToUpdate.add(opp);

                oppIndex++;

                if(oppIndex == 20){
                    oppIndex = 0;
                    accIndex++;
                }
            }
        }

        if(!oppsToUpdate.isEmpty()){
            update oppsToUpdate;
        }
    }
    
    private static boolean isStillRunning = false;
    public static void checkTwenOpportunity(List<Opportunity> newListOpp, Map<Id, Opportunity> oldMap){
        Set<Id> accntIds = new Set<Id>(); //add all the account ids here 
        if(newListOpp.isEmpty()) return;
        
        for(Opportunity opp: newListOpp){
            if(opp.AccountId != null){
                accntIds.add(opp.AccountId);
            }
            if(oldMap != null && oldMap.containsKey(opp.Id)){
                Opportunity oppOld = oldMap.get(opp.Id);
                system.debug('oppOld::>>' + oppOld);
                if(oppOld.AccountId != null){
                    accntIds.add(oppOld.AccountId); 
                }
            }
        }
        
        Map<Id, List<Opportunity>> accountOppMap = new Map<Id, List<Opportunity>>(); //
        for(Opportunity opp : [select Id, Name, CreatedDate, AccountId from Opportunity where AccountId IN :accntIds order by CreatedDate desc]){
            if(!accountOppMap.containsKey(opp.AccountId)){
                accountOppMap.put(opp.AccountId, new List<Opportunity>());
            }
            accountOppMap.get(opp.AccountId).add(opp); 
        }
        
        list<Account> accntToInsert = new List<Account>();
        Map<Id, Account> accountMap = new Map<Id,Account>([select Id, Name from Account where Id IN :accntIds]);
        Map<Id, List<Opportunity>> extraOpps = new Map<Id, List<Opportunity>>(); 
        
        
        for(Id accntIdsOpp : accountOppMap.keySet()){
            List<Opportunity> oppList = accountOppMap.get(accntIdsOpp);
            if(oppList.size() > 20){
                List<Opportunity> extraOppsNew = new List<Opportunity>();
                for(Integer i = 20; i < oppList.size(); i++){
                        extraOppsNew.add(oppList[i]);
                }
                extraOpps.put(accntIdsOpp, extraOppsNew);
            }
        }
        
        Map<Id, List<Account>> mapAccntId = new Map<Id,List<Account>>();
        
    }
    
    public static void updateMaxOppAmountOnAcnt(List<Opportunity> newList, Map<Id,Opportunity> oldMap){
        if(newList.isEmpty()) return;
        set<Id> acntIds = new Set<Id>();
        for(Opportunity opp : newList){
           /* if(opp.AccountId != null){
                acntIds.add(opp.AccountId);
            }
         system.debug('acntIds::' + acntIds);
            
            //handle on updatee
            if(oldMap != null){
                Opportunity oldOpp = oldMap.get(opp.Id);
                Boolean amountChanged  	= opp.Amount != oldOpp.Amount;
                Boolean accountChanged 	= opp.AccountId != oldOpp.AccountId;
                system.debug('amountChanged::'  + amountChanged);
                system.debug('accountChanged::'  + accountChanged);
                if(!amountChanged && !accountChanged){
                    acntIds.remove(opp.AccountId);
                }
                
                if(accountChanged && oldOpp.AccountId != null){
                    acntIds.add(oldOpp.AccountId);
                }
                
                
            }*/
            if(oldMap == null){
                // Insert case
                if(opp.AccountId != null){
                    acntIds.add(opp.AccountId);
                }
            }else{
                Opportunity oldOpp = oldMap.get(opp.Id);
                
                Boolean amountChanged   = opp.Amount != oldOpp.Amount;
                Boolean accountChanged  = opp.AccountId != oldOpp.AccountId;
                
                if(amountChanged || accountChanged){
                    if(opp.AccountId != null){
                        acntIds.add(opp.AccountId);
                    }
                    if(accountChanged && oldOpp.AccountId != null){
                        acntIds.add(oldOpp.AccountId);
                    }
                }
            }
        }
        
        if(acntIds.isEmpty()) return;
        list<Opportunity> oppToFind = [select Id, Amount, AccountId from Opportunity where AccountId IN: acntIds AND Amount != null order by Amount desc];
        system.debug('oppToFind::' + oppToFind);
        Map<Id, Id> mapToAssocOppToAcnt = new Map<Id,Id>();
        for(Opportunity opp : oppToFind){
            if(opp.AccountId != null && !mapToAssocOppToAcnt.containsKey(opp.AccountId)){
                mapToAssocOppToAcnt.put(opp.AccountId, opp.Id);
            }
        }
        system.debug('mapToAssocOppToAcnt::' + mapToAssocOppToAcnt);
        
        List<Account> acntToUpdate = new List<Account>();
        for(Id accntIdToUpdate : acntIds){
            Account acntInstance = new Account();
            acntInstance.Id = accntIdToUpdate;
            acntInstance.Max_Amount_Opportunity__c = mapToAssocOppToAcnt.containsKey(accntIdToUpdate) ? mapToAssocOppToAcnt.get(accntIdToUpdate) : null;
            acntToUpdate.add(acntInstance);
        }
        system.debug('acntToUpdate::>>' +acntToUpdate);
        
        if(!acntToUpdate.isEmpty()){
            update acntToUpdate;
        }
        
    }
    
    public static void toRestrictMoreThan2InNegotiation(List<Opportunity> newList, Map<Id,Opportunity> oldMap){
        if(newList.isEmpty()) return;
        set<Id> acntIds = new Set<Id>();
        
        
        for(Opportunity opp : newList){
            Opportunity oldOpp = oldMap.get(opp.Id);
            system.debug('oldOpp:::' + oldOpp);
            if(opp.AccountId != null && opp.StageName == 'Negotiation/Review'){
                if((oldMap != null || oldMap == null) && (opp.StageName != oldMap.get(opp.Id).StageName) && (opp.AccountId != oldMap.get(opp.Id).AccountId)) {
                    acntIds.add(opp.AccountId);
                }
            }
        }
        if(acntIds.isEmpty()) return;
        
        Map<Id,Integer> existingOppCount = new Map<Id,Integer>();
        for(Aggregateresult agr : [select AccountId accId, count(Id) total from Opportunity where AccountId IN : acntIds and StageName = 'Negotiation/Review' Group by AccountId]){
            existingOppCount.put((Id) agr.get('accId'), (Integer) agr.get('total'));
        }
        
        Map<Id,Integer> countIncomingRecords = new Map<Id,Integer>();
        for(Opportunity opp : newList){
            if(opp.StageName == 'Negotiation/Review' && opp.AccountId != null){
                
            	Integer count = countIncomingRecords.containsKey(opp.AccountId) ? countIncomingRecords.get(opp.AccountId) : 0;
                countIncomingRecords.put(opp.AccountId, count + 1);
            }
        }
        
        for(Opportunity opp: newList){
            if(opp.StageName == 'Negotiation/Review' && opp.AccountId != null){
                Integer existing = existingOppCount.containsKey(opp.AccountId) ? existingOppCount.get(opp.AccountId) : 0;
                Integer incoming = countIncomingRecords.get(opp.AccountId);
                if(existing + incoming >2){
                    opp.addError('Negotiaion stage should be less than 2');
                }
            }
        }
    }
    
    public static void mergeDuplicateRecords(List<Sobject> newList, Map<Id,Sobject> oldSobjMap){
        
        if (newList.isEmpty()) return;
        Set<Id> newRecordSetValues = new Set<Id>();
        Set<Id> duplicateValues = new Set<Id>();
        Map<Id, Set<Id>> mapNewDup = new Map<Id, Set<Id>>();
        
        for(Sobject sObj : newList){
            //if(){
                
            //}
        }
    }
    
}