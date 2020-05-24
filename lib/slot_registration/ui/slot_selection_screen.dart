import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pubg/slot_registration/bloc/bloc.dart';
import 'package:pubg/slot_registration/ui/slot_selection_form.dart';

class SlotSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Slot Selection")
      ),
      body: BlocProvider<SlotSelectionBloc>(
        create: (context) => SlotSelectionBloc(),
        child: SlotSelectionForm(),
      ),
    );
  }
}
