import { LightningElement } from 'lwc';
import { NavigationMixin } from "lightning/navigation";
import { encodeDefaultFieldValues } from "lightning/pageReferenceUtils";

export default class PopulateDefaultValues extends NavigationMixin(LightningElement) {

    navigateToNewContactWithDefaults(){
        const defaultValues = encodeDefaultFieldValues({
            FirstName : "Krishna",
            LastName: "Teja",
            LeadSource: "Web"
        });

        console.log('defaultValues::' , defaultValues);

        this[NavigationMixin.Navigate]({
            type: "standard__objectPage",
            attributes: {
                objectApiName: "Contact",
                actionName: "new",
            },
            state:{
                defaultFieldValues: defaultValues,
            }
        });
    }


}