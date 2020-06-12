class AvailableEvent {
  String eventName;
  String eventDescription;
  String eventID;

  AvailableEvent({this.eventName, this.eventDescription});

  AvailableEvent.fromJson(Map<String, dynamic> json) {
    eventName = json['event_name'];
    eventDescription = json['event_description'];
    eventID = json['event_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['event_name'] = this.eventName;
    data['event_description'] = this.eventDescription;
    data['event_id'] = this.eventID;
    return data;
  }
}
