trigger newOppTrigger on OpportunityLineItem (before insert, after Insert) {
	NewOppClass.updateCountValue(trigger.new);
}