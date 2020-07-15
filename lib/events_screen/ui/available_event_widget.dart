import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pubg/bloc/navigation/bloc.dart';
import 'package:pubg/data_source/model/available_event.dart';
import 'package:pubg/events_screen/bloc/cosmo_events_bloc.dart';
import 'package:pubg/events_screen/model/event_detail.dart';
import 'package:pubg/util/widget_util.dart';

import '../../home_screen/ui/no_internet_Screen.dart';
import 'slot_selection_dialog.dart';

class AvailableEventWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CosmoEventsBloc, CosmoEventsState>(
      buildWhen: (CosmoEventsState previous, CosmoEventsState current) {
        if ((current is AvailableEventsLoading) ||
            (current is AvailableEventsFailure) ||
            (current is AvailableEventsSuccess)) {
          return true;
        } else {
          return false;
        }
      },
      builder: (context, state) {
        if (state is AvailableEventsSuccess) {
          return Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                    itemCount: state.availableEvents.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, position) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _getEventCard(
                            context, state.availableEvents[position]),
                      );
                    }),
              ),
            ],
          );
        } else if (state is AvailableEventsLoading) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Center(
            child: NoInternetWidget(),
          );
        }
      },
      listener: (listenerContext, state) {
        if (state is MissingUserDetails) {
          BlocProvider.of<NavigationBloc>(listenerContext)
              .add(UserProfileNavigateEvent());
        } else if (state is ShowSlotDialog) {
          showModalBottomSheet(
              context: context,
              builder: (buildContext) {
                return SlotSelectionDialog(
                  cosmoEventsBloc: BlocProvider.of<CosmoEventsBloc>(context),
                  eventId: state.eventID,
                );
              });
        } else if (state is EventRegistrationSuccess) {
          Scaffold.of(context)
              .showSnackBar(buildSnackBar("Registration success"));
          Navigator.of(listenerContext).pop();
          BlocProvider.of<CosmoEventsBloc>(context)
              .add(LoadAvailableEvents()); //refresh the screen
        } else if (state is EventRegistrationFailure) {
          Scaffold.of(context).showSnackBar(
              buildSnackBar("Registration Failed Try Again Later"));
        } else if (state is CancellationSuccess) {
          Scaffold.of(context).showSnackBar(
              buildSnackBar("Cancelled Registration successfully"));
          Navigator.of(listenerContext).pop();
          BlocProvider.of<CosmoEventsBloc>(context)
              .add(LoadAvailableEvents()); //refresh the screen
        } else if (state is CancellationFailure) {
          Scaffold.of(context).showSnackBar(
              buildSnackBar("Unable to cancel registration try again later"));
        } else if (state is CancellationFailure) {
          Scaffold.of(context).showSnackBar(
              buildSnackBar("Unable to cancel registration try again later"));
        } else if (state is RoomDetailsAvailable) {
          _showRoomDetails(context, state.roomDetail);
        } else if (state is RoomDetailsNotAvailable) {
          _showRoomDetailsNotAvailable(context);
        }
      },
    );
  }

  Widget _getEventCard(BuildContext context, CosmoEventUIModel event) {
    return Card(
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Container(
          height: 200,
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/images/pubg_player.jpg"),
                  colorFilter:
                  ColorFilter.mode(Colors.grey, BlendMode.darken))),
          child: Stack(
            children: [
              Positioned(
                bottom: 20,
                left: 20,
                child: Column(
                  children: [
                    SizedBox(
                      width: 150,
                      child: Text(
                        event.event.eventName,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 20,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 150,
                      child: Text(
                        event.event.eventDescription,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 20,
                bottom: 10,
                child: FlatButton(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  onPressed: () {
                    BlocProvider.of<CosmoEventsBloc>(context)
                        .add(EventSelected(eventID: event.event.eventID));
                  },
                  child: event.isRegistered
                      ? Text("Selected slot - ${event.previousSelectedSlot}")
                      : Text("Register"),
                  textColor: Colors.blueAccent,
                ),
              ),
            ],
          ),
        ));
  }

  Future<void> _showRoomDetails(BuildContext context,
      RoomDetail roomDetail) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Room Details'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Room Id - ${roomDetail.roomID}"),
                Text("Room Password - ${roomDetail.roomPassword}"),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showRoomDetailsNotAvailable(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Room Details'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Room Details are not available. check again later"),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}
