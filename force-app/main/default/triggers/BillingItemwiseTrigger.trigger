/*created by: IRT
 * Author: Nitya
 * Date: 14th Feb 2022
 */
trigger BillingItemwiseTrigger on Billing_Itemwise__c (after insert, after update) {
BillingItemwiseTriggerHandler.updateIOP(trigger.new);
}