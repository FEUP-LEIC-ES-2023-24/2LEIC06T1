import 'dart:async';
import 'package:couch_potato/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

Future<bool> showPopUp(
    BuildContext context, Color color, Function popUpYesMethod, Function popUpNoMethod, String text) {
  Completer<bool> completer = Completer<bool>();

  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "",
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 450),
    pageBuilder: (context, animation1, animation2) {
      return Container();
    },
    transitionBuilder: (context, a1, a2, widget) {
      // Dialog animation
      final dialogAnimation = CurvedAnimation(
        parent: a1,
        curve: const Interval(0, 0.7273),
        reverseCurve: const Interval(0.7273, 1),
      );

      // Barrier animation
      final barrierAnimation = CurvedAnimation(
        parent: a1,
        curve: const Interval(0, 0.7273),
        reverseCurve: const Interval(0.7273, 1),
      );

      return Stack(
        children: [
          // Barrier
          FadeTransition(
            opacity: Tween<double>(begin: 0, end: 1).animate(barrierAnimation),
            child: ModalBarrier(
              onDismiss: () {
                Navigator.pop(context);
                completer.complete(false); // User chose to delete the post
              },
              color: const Color(0x80000000),
              dismissible: true,
            ),
          ),

          // Dialog
          FadeTransition(
            opacity: Tween<double>(begin: 0, end: 1).animate(dialogAnimation),
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return AlertDialog(
                  title: const Center(
                    child: Text(
                      'Warning',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.8,
                      ),
                    ),
                  ),
                  contentPadding: const EdgeInsets.fromLTRB(35, 20, 35, 25),
                  content: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  actionsAlignment: MainAxisAlignment.center, // Align the buttons to the center
                  actions: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.min, // Use minimum space that is needed by children
                      children: [
                        // Yes Button
                        SizedBox(
                          width: 100,
                          height: 35,
                          child: ElevatedButton(
                            onPressed: () async {
                              popUpYesMethod();
                              completer.complete(true);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              side: BorderSide(color: color),
                            ),
                            child: Text(
                              'Yes',
                              style: TextStyle(
                                color: color,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20), // Spacing between buttons
                        // No Button
                        SizedBox(
                          width: 100,
                          height: 35,
                          child: ElevatedButton(
                            onPressed: () async {
                              popUpNoMethod();
                              completer.complete(true);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: color,
                            ),
                            child: const Text(
                              'No',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      );
    },
  );

  return completer.future;
}

void showLoadingSheet(BuildContext context, bool isImage) {
  showModalBottomSheet(
    showDragHandle: true,
    isScrollControlled: true,
    isDismissible: false,
    enableDrag: false,
    context: context,
    builder: (BuildContext context) {
      String loadingText = 'Checking for unallowed content';

      return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
        if (isImage) {
          Future.delayed(const Duration(seconds: 2), () {
            if (context.mounted) {
              setState(() {
                loadingText = 'Uploading your image';
              });
            }
          });
        }

        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: BottomSheet(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height * 0.2,
              maxHeight: MediaQuery.of(context).size.height * 0.2,
            ),
            onClosing: () {},
            builder: (context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: LoadingAnimationWidget.waveDots(
                      color: appColor,
                      size: 100,
                    ),
                  ),
                  Text(
                    loadingText,
                    style: const TextStyle(
                      color: Color(0xFF555555),
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              );
            },
          ),
        );
      });
    },
  );
}
