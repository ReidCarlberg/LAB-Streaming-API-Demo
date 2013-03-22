public with sharing class LAB_StreamingPageController{

    public String topicName = 'LAB_AccountTopic';
    public Boolean topicSet { 
        get { return [Select count() from PushTopic Where Name = :topicName] > 0; } 
        }
    
        
    public void addAccountTopic() {
        List<PushTopic> current = [Select Id, Name From PushTopic Where Name = :topicName];
        if (current != null && current.size() == 0) {
            PushTopic newTopic = new PushTopic();
            newTopic.Name = topicName;
            newTopic.Query = 'SELECT Id, Name FROM Account';
            newTopic.ApiVersion = 27.0;
            newTopic.NotifyForOperations = 'All';
            newTopic.NotifyForFields = 'Referenced';
            insert newTopic;            
        }
    }
    
    static testmethod void testAddAccountTopic() {
        LAB_StreamingPageController controller = new LAB_StreamingPageController();
        controller.topicName = controller.topicName + 'Test';
        Test.startTest();
        Integer currentTopicCount = [Select count() from PushTopic Where Name = :controller.topicName];
        System.assert(currentTopicCount == 0);

        System.assert(!controller.topicSet);
        controller.addAccountTopic();
        currentTopicCount = [Select count() from PushTopic Where Name = :controller.topicName];
        System.assert(currentTopicCount == 1);
        System.assert(controller.topicSet);
        controller.addAccountTopic();
        currentTopicCount = [Select count() from PushTopic Where Name = :controller.topicName];
        System.assert(currentTopicCount == 1);
        Test.stopTest();
    }
}