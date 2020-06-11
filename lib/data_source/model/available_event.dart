class AvailableEvent {
  String slotName;
  String slotDescription;

  AvailableEvent({this.slotName, this.slotDescription});

  AvailableEvent.fromJson(Map<String, dynamic> json) {
    slotName = json['event_name'];
    slotDescription = json['event_description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['event_name'] = this.slotName;
    data['event_description'] = this.slotDescription;
    return data;
  }
}
