import 'package:couch_potato/utils/utils.dart';
import 'package:flutter/material.dart';

enum Logistics { couchPotato, user }

class LogisticsOptions extends StatefulWidget {
  final Function(Logistics) radioCallback;
  const LogisticsOptions({super.key, required this.radioCallback});

  @override
  State<LogisticsOptions> createState() => _LogisticsOptionsState();
}

class _LogisticsOptionsState extends State<LogisticsOptions> {
  Logistics? groupValue = Logistics.user;


  final TextStyle textStyle = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    fontFamily: 'Montserrat',
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              groupValue = Logistics.user;
              widget.radioCallback(Logistics.user);
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Transform.scale(
                scale: 1.35,
                child: Radio<Logistics>(
                  activeColor: appColor,
                  value: Logistics.user,
                  groupValue: groupValue,
                  onChanged: (Logistics? value) {
                    setState(() {
                      groupValue = value;
                      widget.radioCallback(value!);
                    });
                  },
                ),
              ),
              Text(
                "Sort logistics myself",
                textAlign: TextAlign.left,
                style: textStyle.copyWith(fontWeight: FontWeight.w400),
              ),
              const SizedBox(width: 120),
              Text(
                "FREE",
                textAlign: TextAlign.left,
                style: textStyle,
              ),
            ],
          ),
        ),
        const SizedBox(width: 50),
        GestureDetector(
          onTap: () {
            setState(() {
              groupValue = Logistics.couchPotato;
              widget.radioCallback(Logistics.couchPotato);
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Transform.scale(
                scale: 1.35,
                child: Radio<Logistics>(
                  activeColor: appColor,
                  value: Logistics.couchPotato,
                  groupValue: groupValue,
                  onChanged: (Logistics? value) {
                    setState(() {
                      groupValue = value;
                      widget.radioCallback(value!);
                    });
                  },
                ),
              ),
              Text(
                "Couch Potato delivery system",
                textAlign: TextAlign.left,
                style: textStyle.copyWith(fontWeight: FontWeight.w400),
              ),
              const SizedBox(width: 55),
              Text(
                "\$ 3,99",
                textAlign: TextAlign.left,
                style: textStyle,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
