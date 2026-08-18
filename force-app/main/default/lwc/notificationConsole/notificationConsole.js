import { LightningElement, track } from "lwc";
import { subscribe, unsubscribe, onError } from "lightning/empApi";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
export default class NotificationConsole extends LightningElement {
  @track
  notifications = [];
  async connectedCallback() {
    // this.dispatchEvent(
    //   new ShowToastEvent({
    //     variant: "success",
    //     title: "Ready to receive notifications"
    //   })
    // );
    // this.notifications = [
    //   { id: "id1", time: "00:01", message: "Greetings Trailblazer!" },
    //   { id: "id2", time: "00:02", message: "Congratulations on building this first version of the app." },
    //   { id: "id3", time: "00:03", message: "Beware of the bears." }
    // ];
    // Configure default error handler for the EMP API
    onError((error) => {
      this.dispatchEvent(
        new ShowToastEvent({
          variant: "error",
          title: "EMP API Error",
          message: "Check your browser's developer console for mode details."
        })
      );
      console.log("EMP API error reported by server: ", JSON.stringify(error));
    });
    // Subscribe to our notification platform event with the EMP API
    // listen to all new events
    // and handle them with handleNotificationEvent
    this.subscription = await subscribe(
      "/event/Notification__e",
      -1,
      (event) => this.handleNotificationEvent(event)
    );
    // Display a toast to inform the user that we're ready to receive notifications
    this.dispatchEvent(
      new ShowToastEvent({
        variant: "success",
        title: "Ready to receive notifications"
      })
    );
  }
  handleClearClick() {
    this.notifications = [];
  }
  get notificationCount() {
    return this.notifications.length;
  }

  handleNotificationEvent(event) {
    debugger;
    console.dir(event);
    // Parse event data
    const id = event.data.event.replayId;
    console.log("Notification ID: " + id);
    const message = event.data.payload.Message__c;
    const utcDate = new Date(event.data.payload.CreatedDate);
    const time = `${utcDate.getMinutes()}:${utcDate.getSeconds()}`;
    // Add notification to view
    const notification = {
      id,
      message,
      time
    };
    this.notifications.push(notification);
    // Show notification message as a toast
    this.dispatchEvent(
      new ShowToastEvent({
        variant: "info",
        title: message
      })
    );
  }

  disconnectedCallback() {
    // Unsubscribe from EMP API
    unsubscribe(this.subscription);
  }
  
}