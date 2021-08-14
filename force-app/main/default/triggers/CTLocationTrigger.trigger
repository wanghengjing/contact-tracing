trigger CTLocationTrigger on Location__c (before insert) {
    switch on Trigger.operationType {
        when  AFTER_UPDATE{
            CTLocationTriggerHander.afterUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}