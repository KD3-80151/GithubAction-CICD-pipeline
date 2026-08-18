public class ReturnMaxAcntFromOppAndSize {
    /*
public class resulTWrapper{
public Integer oppCount;
public Account acntName;
}

public static resulTWrapper countMaxNoOfOppOnAcnt(){

AggregateResult agRexult =[select AccountId, count(Id) opCnt from Opportunity where AccountId != null order by count(Id) desc];
Id topAccntId = (Id) agRexult.get('AccountId');
Integer opCnt = (Integer) agRexult.get('opCnt');

Account topCount = [select Id, Name from Account where Id =:topAccntId limit 1];

resulTWrapper r = new resulTWrapper();
r.acntName = topCount;
r.oppCount = opCnt;
return r;
}*/
    
    public class resulTWrapper{
        public Integer oppCount;
        public Account acntName;
    }
    
    public static resulTWrapper countMaxNoOfOppOnAcnt(){
        list<Opportunity> oppList = [select Id, AccountId from Opportunity where AccountId !=null];
        map<Id, Integer> acntOppCountMap = new map<Id, Integer>();
        for(Opportunity opp : oppList){
            if(acntOppCountMap.containsKey(opp.AccountId)){
                acntOppCountMap.put(opp.AccountId, acntOppCountMap.get(opp.AccountId) + 1);
            }
            else{
                acntOppCountMap.put(opp.AccountId, 1);
            }
        }
        
        Id topAcntId;
        Integer macCountOfOpp = 0;
        
        for(Id acntId : acntOppCountMap.keySet()){
            Integer count = acntOppCountMap.get(acntId);
            if(count > macCountOfOpp){
                macCountOfOpp = count;
                topAcntId = acntId;
            }
        }
        
        Account topAccnt = [select Id, Name from Account where Id =:topAcntId limit 1];
        
        resulTWrapper rturnOutput = new resulTWrapper();
        rturnOutput.acntName = topAccnt;
        rturnOutput.oppCount = macCountOfOpp;
        return rturnOutput;
    }
    
    
}