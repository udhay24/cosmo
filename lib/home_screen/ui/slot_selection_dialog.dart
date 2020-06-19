import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pubg/data_source/user_repository.dart';
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
  int slotSelected;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: RepositoryProvider.of<UserRepository>(context)
            .getEventDetailFromId(widget.eventId),
        builder: (context, AsyncSnapshot<EventDetail> value) {
          if ((value != null) && (value.hasData)) {
            slotSelected = value.data.availableSlots.first;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(child: _buildEventHeading(value.data)),
                  Divider(
                    height: 20,
                    thickness: 2,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  _buildSlotOption(),
                  SizedBox(
                    height: 20,
                  ),
                  _buildSelectSlotButton(context, value.data.event.eventID)
                ],
              ),
            );
          } else {
            return Container(
              height: 100,
                child: Center(child: CircularProgressIndicator()));
          }
        });
  }

  Widget _buildSlotOption() {
    return Row(
      children: <Widget>[
        Transform.rotate(angle: 125, child: Icon(FontAwesomeIcons.ticketAlt, color: Colors.grey,),),
        SizedBox(width: 20,),
        Text(
          "Available Slot :    $slotSelected",
          style: GoogleFonts.abel(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ],
    );
  }

  Widget _buildEventHeading(EventDetail value) {
    return ListTile(
      leading: Icon(FontAwesomeIcons.accusoft),
      title: Text(value.event.eventName),
      subtitle: Text(value.event.eventDescription),
    );
  }

  Widget _buildSelectSlotButton(BuildContext context, int eventID) {
    return Container(
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
            widget.homeScreenBloc
              ..add(SlotSelected(selectedSlot: slotSelected, eventId: eventID));
          }),
    );
  }

  DropdownButton<String> _buildDropdownButton(List<int> availableSlots) {
    return DropdownButton<String>(
      value: '$slotSelected',
      icon: Icon(Icons.arrow_downward),
      dropdownColor: Colors.white,
      iconSize: 24,
      elevation: 2,
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
      items: availableSlots.map<DropdownMenuItem<String>>((int value) {
        return DropdownMenuItem<String>(
          value: "$value",
          child: Text("$value"),
        );
      }).toList(),
    );
  }
}
