public virtual without sharing class ObjectHandler {

    public List<SObject> Records { get; private set; }
            
    public ObjectHandler(List<SObject> sObjectList) {
        Records = sObjectList;
    }

// --------------------------------------------------------------------------------------------------------------------
// Virtual Methods
// --------------------------------------------------------------------------------------------------------------------
    
    public virtual void onBeforeInsert() { }
    public virtual void onBeforeUpdate(Map<Id, SObject> existingRecords) { }
    
    /**
     *Handler for the Apex Trigger event Before Insert, calls the onBeforeInsert method
     */ 
    public void handleBeforeInsert() { 
        onBeforeInsert();
    }
    /**
     *Handler for the Apex Trigger event Before Update, calls the onBeforeUpdate method
     **/
    public void handleBeforeUpdate(Map<Id, SObject> existingRecords) {
        onBeforeUpdate(existingRecords);
    }
    
	// --------------------------------------------------------------------------------------------------------------------
    /**
     *Interface to be implemented by 'Constructor' class in specific object handler
     **/
    public interface IConstructable {
        ObjectHandler construct(List<SObject> sObjectList);
    }

// --------------------------------------------------------------------------------------------------------------------    
    /**
     * Method constructs the given Domain class with the current Trigger context before calling the applicable override methods 
     * such as beforeInsert, beforeUpdate etc.
     */ 
    public static void triggerHandler(Type objectHandlerClass)
    {
        // Construct the domain class constructor class
        String domainClassName = objectHandlerClass.getName();
        Type constructableClass = domainClassName.endsWith('Constructor') ? Type.forName(domainClassName) : Type.forName(domainClassName+'.Constructor');
        IConstructable constructor = (IConstructable) constructableClass.newInstance();

        // Process specific object handler
        triggerHandler(
            objectHandlerClass,
            constructor, 
            Trigger.isBefore, 
            Trigger.isAfter, 
            Trigger.isInsert, 
            Trigger.isUpdate, 
            Trigger.new, 
            Trigger.oldMap);
    }

// --------------------------------------------------------------------------------------------------------------------    
    /**
     * Calls the applicable override methods
     */ 
    private static void triggerHandler(
        Type objectHandler,     
        IConstructable handlerConstructor,
        Boolean isBefore, 
        Boolean isAfter, 
        Boolean isInsert, 
        Boolean isUpdate, 
        List<SObject> newRecords, 
        Map<Id, SObject> oldRecordsMap
    ) { 
        // Execute the appropriate ObjectHandler methods 
        if(isBefore) {
                if(isInsert) {
                    handlerConstructor.construct(newRecords).handleBeforeInsert();
                } else if(isUpdate) {
                    handlerConstructor.construct(newRecords).handleBeforeUpdate(oldRecordsMap);
                }
        }              
    }    
// --------------------------------------------------------------------------------------------------------------------
}