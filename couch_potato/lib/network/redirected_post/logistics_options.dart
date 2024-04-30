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

  @override
  Widget build(BuildContext context) {
    Widget logisticsTile(String text, String price) {
      Logistics value = price == 'FREE' ? Logistics.couchPotato : Logistics.user;

      return ListTile(
        title: Text(text),
        leading: Radio<Logistics>(
          value: value,
          groupValue: groupValue,
          onChanged: (Logistics? value) {
            setState(() {
              groupValue = value;
              widget.radioCallback(value!);
            });
          },
        ),
      );
    }

    return Column(
      children: [
        logisticsTile('Sort logistics myself', 'FREE'),
        logisticsTile('Couch Potato delivery system ', '\$ 3,99'),
      ],
    );
  }
}
