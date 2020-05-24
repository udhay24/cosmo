import 'package:flutter/material.dart';
import 'package:pubg/slot_registration/bloc/bloc.dart';

class SlotSelectionDialog extends StatefulWidget {
  final String selectedTiming;
  final List<int> availableSlots;
  final SlotSelectionBloc slotSelectionBloc;

  SlotSelectionDialog(
      {@required this.availableSlots,
      @required this.selectedTiming,
      @required this.slotSelectionBloc});

  @override
  _SlotSelectionDialogState createState() => _SlotSelectionDialogState();
}

class _SlotSelectionDialogState extends State<SlotSelectionDialog> {
  int slotSelected;

  @override
  void initState() {
    slotSelected = widget.availableSlots.first;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Text("Select one of the available slot"),
          DropdownButton<String>(
            value: '$slotSelected',
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (String newValue) {
              setState(() {
                slotSelected = int.parse(newValue);
              });
            },
            items: widget.availableSlots
                .map<DropdownMenuItem<String>>((int value) {
              return DropdownMenuItem<String>(
                value: "$value",
                child: Text("$value"),
              );
            }).toList(),
          ),
          RaisedButton(
            child: Text("Submit"),
            onPressed: () {
              Navigator.of(context).pop();
              widget.slotSelectionBloc.add(SlotSelected(
                  selectedSlot: slotSelected,
                  selectedTiming: widget.selectedTiming));
            },
          )
        ],
      ),
    );
  }
}
