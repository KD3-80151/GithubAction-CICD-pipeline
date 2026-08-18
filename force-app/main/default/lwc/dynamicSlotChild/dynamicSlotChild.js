//!Dynamic slots in Lightning Web Components (LWC) are like flexible placeholders—letting you 
//! design reusable, customizable, and dynamic components without hardcoding.

//!slots as gaps in a component that can be filled with custom content when the component is used. 
//!By default, slots in LWC are named or default slots, but with dynamic slots, you can go one step further by adding dynamic flexibility!

//! The slot element is a placeholder inside a web component that you can fill with your own markup, 
//! which lets you create separate DOM trees and present them together.
//!
//!
//!

import { LightningElement, api } from 'lwc';

export default class DynamicSlotChild extends LightningElement {
    @api dynamicSlotName = 'default';
    
    get isDefaultSlot(){
        return this.dynamicSlotName === 'default';
    }

    get isCustomSlot(){
        return this.dynamicSlotName === 'custom';
    }
}