import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pubg/bloc/navigation/bloc.dart';

class CreateAccountButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        BlocProvider.of<NavigationBloc>(context)
            .add(RegistrationNavigateEvent());
      },
      child: Text(
        'SIGN UP NOW',
        style: GoogleFonts.openSansCondensed(
            color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
