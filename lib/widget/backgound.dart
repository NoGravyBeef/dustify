import 'package:dustify/model/status_model.dart';
import 'package:flutter/material.dart';

class StatusBackground extends StatelessWidget {
  final StatusModel status;

  const StatusBackground({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [status.lightColor, status.primaryColor],
        ),
      ),
    );
  }
}
