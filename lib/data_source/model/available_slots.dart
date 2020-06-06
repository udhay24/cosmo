class AvailableSlots {
  String slotName;
  String slotDescription;

  AvailableSlots({this.slotName, this.slotDescription});

  AvailableSlots.fromJson(Map<String, dynamic> json) {
    slotName = json['slot_name'];
    slotDescription = json['slot_description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['slot_name'] = this.slotName;
    data['slot_description'] = this.slotDescription;
    return data;
  }
}
