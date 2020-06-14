import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pubg/data_source/model/available_event.dart';
import 'package:pubg/data_source/user_repository.dart';
import 'package:pubg/home_screen/bloc/bloc.dart';

class SlotSelectionDialog extends StatefulWidget {
  final DocumentReference eventRef;
  final List<int> availableSlots;

  SlotSelectionDialog({@required this.eventRef, @required this.availableSlots});

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
          }
        },
        child: FutureBuilder(
            future: RepositoryProvider.of<UserRepository>(context)
                .getEventFromRef(widget.eventRef),
            builder: (context, AsyncSnapshot<AvailableEvent> value) {
              if ((value != null) && (value.hasData)) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          width: MediaQuery.of(context).size.width,
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Slot Selection",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Text("${value.data.eventName}"),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text("Available Slots"),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    _buildDropdownButton(),
                                  ],
                                )
                              ],
                            ),
                          )),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _buildSelectSlotButton(context),
                      )
                    ],
                  ),
                );
              } else {
                return Container();
              }
            }));
  }

  Widget _buildSelectSlotButton(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: RaisedButton(
          color: Colors.white,
          textColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text("Submit",
          style: TextStyle(
            fontWeight: FontWeight.w600
          ),),
          onPressed: () {
            BlocProvider.of<HomeScreenBloc>(context)
              ..add(SlotSelected(
                  selectedSlot: slotSelected, selectedEvent: widget.eventRef));
          }),
    );
  }

  DropdownButton<String> _buildDropdownButton() {
    return DropdownButton<String>(
      value: '$slotSelected',
      icon: Icon(Icons.arrow_downward),
      dropdownColor: Colors.white,
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
      items: widget.availableSlots.map<DropdownMenuItem<String>>((int value) {
        return DropdownMenuItem<String>(
          value: "$value",
          child: Text("$value"),
        );
      }).toList(),
    );
  }
}
