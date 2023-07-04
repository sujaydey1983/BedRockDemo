public class PolicyBulkUpdate implements Database.Batchable<sObject>,Database.Stateful{
    public static List<string> policyIds = new List<string>();
    public Database.QueryLocator start(Database.BatchableContext BC){
      	string query = 'select Id,Effective_Date__c,Contact_Email__c,Name,Expiration_Date__c,Issuing_Date__c,Premium__c,Premium_Frequency__c,Status__c from Insurance_Policy__c';     
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext BC, List<sObject> scope){
        List<Insurance_Policy__c> ips = new List<Insurance_Policy__c>();
        for(sObject sc : scope){
            Insurance_Policy__c ip = (Insurance_Policy__c)sc;
            Date today = Date.valueOf(system.now());
            if(ip.Expiration_Date__c < today){
                ip.Status__c = 'Terminated';
                ips.add(ip);
                policyIds.add(ip.Id);//Comment
            }
        }
        update ips;
    }
	public void finish(Database.BatchableContext BC){
       
        List<string> emailIds = new List<string>();
        If(!policyIds.isEmpty() && policyIds.size() > 0){
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            List<Insurance_policy__c> ips = [select name, contact_email__c from insurance_policy__c where Id IN :policyIds];
            for(Insurance_policy__c ip : ips){
                emailIds.add(ip.contact_email__c);
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new List<string>{ip.contact_email__c});
                mail.setSubject('Your Policy ' + ip.name + 'has be expired');
                mail.setPlainTextBody('Your Policy ' + ip.name + 'has be expired');
                mails.add(mail);
            }
			Messaging.sendEmail(mails);
        }
        
    }
}