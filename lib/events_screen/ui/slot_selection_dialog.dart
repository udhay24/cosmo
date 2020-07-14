import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pubg/events_screen/bloc/cosmo_events_bloc.dart';
import 'package:pubg/events_screen/model/event_detail.dart';

class SlotSelectionDialog extends StatefulWidget {
  final int eventId;
  final CosmoEventsBloc cosmoEventsBloc;

  SlotSelectionDialog({@required this.eventId, @required this.cosmoEventsBloc});

  @override
  _SlotSelectionDialogState createState() => _SlotSelectionDialogState();
}

class _SlotSelectionDialogState extends State<SlotSelectionDialog> {
  int selectedSlot;

  @override
  void initState() {
    super.initState();
    widget.cosmoEventsBloc
        .add(EventRegistrationDialogOpened(eventID: widget.eventId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: widget.cosmoEventsBloc,
      builder: (_, state) {
        if (state is SelectedEventDetailLoading) {
          return Container(
              height: 100, child: Center(child: CircularProgressIndicator()));
        } else if (state is SelectedEventDetailFailure) {
          return Container(
              height: 100,
              child: Center(
                  child: Text(
                "Something went wrong",
                style: Theme.of(context).textTheme.headline3,
                  )));
        } else if (state is SelectedEventDetailLoaded) {
          return StreamBuilder(
            builder: (_, AsyncSnapshot<List<int>> data) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    _buildEventHeading(state.eventDetail),
                    Divider(
                      height: 20,
                      thickness: 2,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Builder(builder: (_) {
                      if ((data.data.length > 0) &&
                          (!state.eventDetail.isRegistered)) {
                        _updateSelectedSlot(data.data);
                        return _buildSlotDropDownOption(data.data);
                      } else if (state.eventDetail.isRegistered) {
                        return _buildCancelRegistrationEvent(
                            state.eventDetail.previousSelectedSlot,
                            state.eventDetail.event.eventID);
                      } else {
                        return _buildClosedEventWidget();
                      }
                    }),
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

  _updateSelectedSlot(List<int> slots) {
    if (selectedSlot != null) {
      if (!slots.contains(selectedSlot)) {
        selectedSlot = slots.first;
      }
    } else {
      selectedSlot = slots.first;
    }
  }

  Widget _buildEventHeading(SelectedEventDetail value) {
    return ListTile(
      leading: SizedBox(
          height: 32,
          width: 32,
          child: Image.asset(
            "assets/icons/pubg-helmet-64.png",
          )),
      title: Text(
        value.event.eventName,
        style: Theme
            .of(context)
            .textTheme
            .headline4,
      ),
      subtitle: Text(
        value.event.eventDescription,
        style: Theme
            .of(context)
            .textTheme
            .subtitle2,
      ),
    );
  }

  Widget _buildCancelRegistrationEvent(int selectedSlot, int eventID) {
    return Column(
      children: [
        Text(
          "You have already registered for slot - $selectedSlot",
          style: Theme.of(context).textTheme.headline4,
        ),
        SizedBox(
          height: 10,
        ),
        Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
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
                  widget.cosmoEventsBloc
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
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 8),
              child: SizedBox(
                  height: 24,
                  width: 24,
                  child: Image.asset("assets/icons/old-shop-48.png")),
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              "Available Slot :  No Slots Available",
              style: Theme
                  .of(context)
                  .textTheme
                  .headline5,
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

  Widget _buildSlotDropDownOption(List<int> availableSlots) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 8),
              child: SizedBox(
                  height: 24,
                  width: 24,
                  child: Image.asset("assets/icons/old-shop-48.png")),
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              "Available Slots: ",
              style: Theme
                  .of(context)
                  .textTheme
                  .headline5,
            ),
            SizedBox(
              width: 20,
            ),
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: '$selectedSlot',
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.blue,
                ),
                dropdownColor: Colors.white,
                iconSize: 24,
                elevation: 2,
                style: TextStyle(color: Colors.blue),
                onChanged: (String newValue) {
                  setState(() {
                    selectedSlot = int.parse(newValue);
                  });
                },
                items: availableSlots
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
        SizedBox(
          height: 15,
        ),
        Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
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
                  widget.cosmoEventsBloc
                    ..add(SlotSelected(
                        selectedSlot: selectedSlot, eventId: widget.eventId));
                }))
      ],
    );
  }
}
