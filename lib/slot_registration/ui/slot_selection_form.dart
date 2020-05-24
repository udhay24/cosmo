import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pubg/slot_registration/bloc/bloc.dart';
import 'package:pubg/slot_registration/bloc/slot_selection_bloc.dart';
import 'package:pubg/slot_registration/ui/slot_selection_dialog.dart';
import 'package:pubg/team_detail/ui/team_detail_screen.dart';
import 'package:pubg/util/available_slot.dart';

class SlotSelectionForm extends StatefulWidget {
  @override
  _SlotSelectionFormState createState() => _SlotSelectionFormState();
}

class _SlotSelectionFormState extends State<SlotSelectionForm> {
  SlotSelectionBloc _slotSelectionBloc;
  int slotSelected = 1;
  String timingSelected = AvailableSlots.SLOT_AT_6;

  @override
  void initState() {
    _slotSelectionBloc = BlocProvider.of<SlotSelectionBloc>(context);
  }

  @override
  Widget build(BuildContext buildContext) {
    return BlocListener<SlotSelectionBloc, SlotSelectionState>(
        listener: (context, state) {
      if (state is TeamDetailsMissing) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => TeamDetailScreen()));
      } else if (state is ShowSlotDialog) {
        showDialog(
            context: buildContext,
            child: SlotSelectionDialog(
              slotSelectionBloc: _slotSelectionBloc,
              selectedTiming: timingSelected,
              availableSlots: state.availableSlots,
            )
        );
      }
    }, child: BlocBuilder<SlotSelectionBloc, SlotSelectionState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              FlatButton(
                child: Text(AvailableSlots.SLOT_AT_6),
                onPressed: () {
                  _slotSelectionBloc.add(
                      TimingSelected(selectedTiming: AvailableSlots.SLOT_AT_6));
                  timingSelected = AvailableSlots.SLOT_AT_6;
                },
              ),
              FlatButton(
                child: Text(AvailableSlots.SLOT_AT_10),
                onPressed: () {
                  _slotSelectionBloc.add(TimingSelected(
                      selectedTiming: AvailableSlots.SLOT_AT_10));
                  timingSelected = AvailableSlots.SLOT_AT_10;
                },
              )
            ],
          ),
        );
      },
    ));
  }
}
