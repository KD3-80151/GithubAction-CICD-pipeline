public with sharing class NewOppClass {
    public static void updateCountValue(List<OpportunityLineItem> newOppList){
        if(newOppList == null && newOppList.isEmpty()) return;
        //1.collect the orders which is toucehd--------------------------------------------
        set<Id> incmigOprdt = new set<Id>();
        for(OpportunityLineItem op1 : newOppList){
            if(op1.OpportunityId != null && op1.IntegerCountTen__c == null){
                incmigOprdt.add(op1.OpportunityId);
            }
        }
        
        if(incmigOprdt.isEmpty()) return;

		set<Id> setOfNewIncomingOpp = new set<Id>();        
        for(OpportunityLineItem op2: newOppList){
            if(op2.OpportunityId != null && op2.IntegerCountTen__c == null){
                setOfNewIncomingOpp.add(op2.OpportunityId);
            }
        }
        
        if(setOfNewIncomingOpp.isEmpty()) return;
        //2-- walk up to find each order's root -------------------------------------- go up to find each order's root
        map<Id,Id> oppKaSelfLookupParent = new map<Id,Id>(); //parent //Opportunity id -> Opportunity__c
        map<Id,Id> oppToRoot = new map<Id,Id>(); // fetch each parent opp and if not then its root and we need to traverse from here 
        //if there is parent push that parent it to root
        //consider breath-first-search_pattern for parent hierarchy -- upward traverse --
        set<Id> frontDekho = new set<Id>(incmigOprdt); // opportunity jaha se upar traverse // nodes to process 
        set<Id> vistDone = new set<Id>(); // opp jo already visited // to prevent requerying 
       	
        while(!frontDekho.isEmpty()){
            set<Id> newToQury = new set<Id>(); // visted stored here 
            for(Id old : frontDekho){
                if(!vistDone.contains(old)) newToQury.add(old); }
            frontDekho.clear(); // to remove all the data stored in nodes
            if(newToQury.isEmpty()) break;
            //Opportunity__c - self lookup-----------------------------------------------------------------------
            for(Opportunity opp : [select Id, Opportunity__c from Opportunity where Id IN : newToQury]){
                vistDone.add(opp.Id);
                oppKaSelfLookupParent.put(opp.Id, opp.Opportunity__c);
                if(opp.Opportunity__c == null){
                    //to traverse to root if there is no parent
					oppToRoot.put(opp.Id, opp.Id);
                }
                else{
                    frontDekho.add(opp.Opportunity__c); //to climb one more level up
                }
            }        
        }
        
        //while()
        
        
        
        //now need to propagate the root to all vistDone opportunity ----------------------------fill opportunity root 
        //3. fill in roots for non-root order
        //we can propoagte opp root w/o more soql----------------
        for(Id oppId : vistDone){
            if(!oppToRoot.containsKey(oppId)){
                Id current = oppId;
                list<Id> path = new list<Id>(); //
                while(current != null && oppToRoot.containsKey(current)){
                    path.add(current);
                    current = oppKaSelfLookupParent.get(current);
                }
                
                Id root = (current == null) ? oppId : oppToRoot.get(current);
                for(Id neaarPath : path) oppToRoot.put(neaarPath, root);
            }
        }
        
        //4 now we need to build families i.e from root to all descendannts -------------------------------
        //bfs down logic i.e from each root gather all children 
        set<Id> rootSet = new set<Id>();
        for(Id bfsOpp : incmigOprdt){
            rootSet.add(oppToRoot.get(bfsOpp) == null ? bfsOpp : oppToRoot.get(bfsOpp));
            
            Map<Id, Set<Id>> familyOrdersMap = new Map<Id, Set<Id>>();
            //todo - need to traverse each node -------------- from down to parents
            set<Id> setOpp = new set<Id>();
            
        }
    }

}