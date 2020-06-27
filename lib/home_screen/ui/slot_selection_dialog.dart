import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pubg/home_screen/bloc/bloc.dart';
import 'package:pubg/home_screen/model/event_detail.dart';

class SlotSelectionDialog extends StatefulWidget {
  final int eventId;
  final HomeScreenBloc homeScreenBloc;

  SlotSelectionDialog({@required this.eventId, @required this.homeScreenBloc});

  @override
  _SlotSelectionDialogState createState() => _SlotSelectionDialogState();
}

class _SlotSelectionDialogState extends State<SlotSelectionDialog> {
  @override
  void initState() {
    super.initState();
    widget.homeScreenBloc
        .add(EventRegistrationDialogOpened(eventID: widget.eventId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: widget.homeScreenBloc,
      builder: (_, state) {
        if (state is SelectedEventDetailLoading) {
          return Container(
              height: 100, child: Center(child: CircularProgressIndicator()));
        } else if (state is SelectedEventDetailFailure) {
          return Container(
              height: 100, child: Center(child: Text("Something went wrong")));
        } else if (state is SelectedEventDetailLoaded) {
          return StreamBuilder(
            builder: (_, AsyncSnapshot<List<int>> data) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(child: _buildEventHeading(state.eventDetail)),
                    Divider(
                      height: 20,
                      thickness: 2,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Builder(builder: (_) {
                      if ((data.data.length > 0) &&
                          (!state.eventDetail.isRegistered)) {
                        return SlotRegistrationWidget(
                          availableSlots: data.data,
                          eventID: state.eventDetail.event.eventID,
                          bloc: widget.homeScreenBloc,
                        );
                      } else if (state.eventDetail.isRegistered) {
                        return _buildCancelRegistrationEvent(
                            state.eventDetail.previousSelectedSlot,
                            state.eventDetail.event.eventID);
                      } else {
                        return _buildClosedEventWidget();
                      }
                    }),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              );
            },
            stream: state.eventDetail.availableSlots,
            initialData: <int>[],
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildEventHeading(SelectedEventDetail value) {
    return ListTile(
      leading: Icon(FontAwesomeIcons.accusoft),
      title: Text(value.event.eventName),
      subtitle: Text(value.event.eventDescription),
    );
  }

  Widget _buildCancelRegistrationEvent(int selectedSlot, int eventID) {
    return Column(
      children: [
        Text("You have already registered for slot $selectedSlot"),
        SizedBox(
          height: 10,
        ),
        Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: FlatButton(
                textColor: Colors.white,
                color: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Text(
                  "Cancel Registration",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                onPressed: () {
                  widget.homeScreenBloc
                    ..add(RegistrationCancelled(eventID: eventID));
                }))
      ],
    );
  }

  Widget _buildClosedEventWidget() {
    return Column(
      children: [
        Row(
          children: <Widget>[
            Transform.rotate(
              angle: 125,
              child: Icon(
                FontAwesomeIcons.ticketAlt,
                color: Colors.grey,
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              "Available Slot :  No Slots Available",
              style:
                  GoogleFonts.abel(fontWeight: FontWeight.w600, fontSize: 15),
            ),
          ],
        ),
        Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: FlatButton(
                textColor: Colors.white,
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Text(
                  "Register",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                onPressed: null))
      ],
    );
  }
}

class SlotRegistrationWidget extends StatefulWidget {
  final List<int> availableSlots;
  final int eventID;
  final HomeScreenBloc bloc;

  SlotRegistrationWidget(
      {@required this.availableSlots,
      @required this.eventID,
      @required this.bloc});

  @override
  _SlotRegistrationWidgetState createState() => _SlotRegistrationWidgetState();
}

class _SlotRegistrationWidgetState extends State<SlotRegistrationWidget> {
  int selectedSlot;

  @override
  initState() {
    selectedSlot = widget.availableSlots.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Transform.rotate(
              angle: 125,
              child: Icon(
                FontAwesomeIcons.ticketAlt,
                color: Colors.grey,
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Text("Available Slots: "),
            SizedBox(
              width: 20,
            ),
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: '$selectedSlot',
                icon: Icon(Icons.arrow_drop_down),
                dropdownColor: Colors.white,
                iconSize: 24,
                elevation: 2,
                style: TextStyle(color: Colors.blue),
                onChanged: (String newValue) {
                  setState(() {
                    selectedSlot = int.parse(newValue);
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
            ),
          ],
        ),
        Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: FlatButton(
                textColor: Colors.white,
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Text(
                  "Register",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                onPressed: () {
                  widget.bloc
                    ..add(SlotSelected(
                        selectedSlot: selectedSlot, eventId: widget.eventID));
                }))
      ],
    );
  }
}
