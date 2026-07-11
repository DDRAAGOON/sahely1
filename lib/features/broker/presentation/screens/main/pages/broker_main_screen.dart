import 'package:flutter/material.dart';
import 'package:sahely/features/broker/presentation/screens/home/pages/broker_home_page.dart';

class BrokerMainScreen extends StatefulWidget {
  const BrokerMainScreen({super.key});

  @override
  State<BrokerMainScreen> createState() => _BrokerMainScreenState();
}

class _BrokerMainScreenState extends State<BrokerMainScreen> {
  @override
  Widget build(BuildContext context) {
    // With StatefulShellRoute, this screen just returns the main home content.
    return const BrokerHomePage();
  }
}
