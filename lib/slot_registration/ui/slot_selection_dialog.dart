import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pubg/data_source/user_repository.dart';
import 'package:pubg/home_screen/bloc/bloc.dart';

class SlotSelectionDialog extends StatefulWidget {
  final DocumentReference selectedEvent;
  final List<int> availableSlots;

  SlotSelectionDialog({@required this.selectedEvent, @required this.availableSlots});

  @override
  _SlotSelectionDialogState createState() => _SlotSelectionDialogState();
}

class _SlotSelectionDialogState extends State<SlotSelectionDialog> {
  int slotSelected;

  @override
  void initState() {
    super.initState();
    slotSelected = widget.availableSlots.first;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeScreenBloc, HomeScreenState>(
      listener: (context, state) {
        if (state is EventRegistrationSuccess) {
          Navigator.of(context).pop();
          BlocProvider.of<HomeScreenBloc>(context).add(HomeScreenStarted());
        }
      },
      child: Center(
        child: Wrap(
          children: <Widget>[
            Card(
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
                    BlocProvider.of<HomeScreenBloc>(context)..add(SlotSelected(selectedSlot: slotSelected, selectedEvent: widget.selectedEvent));
                  }
                )
              ],
            ),
          )
        ]
        ),
      ),
    );
  }
}
