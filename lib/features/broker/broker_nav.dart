import 'package:flutter/material.dart';

void brokerNav(BuildContext context, int i) {
  switch (i) {
    case 0:
      Navigator.popUntil(context, (r) => r.isFirst || r.settings.name == '/broker/home');
    case 1:
      Navigator.pushNamed(context, '/broker/dashboard');
    case 2:
      Navigator.pushNamed(context, '/broker/referred');
    case 3:
      Navigator.pushNamed(context, '/broker/wallet');
    case 4:
      Navigator.pushNamed(context, '/broker/profile');
  }
}
