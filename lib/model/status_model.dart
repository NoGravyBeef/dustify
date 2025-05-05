import 'package:flutter/material.dart';

class StatusModel {
  final int level;

  final String label;

  final Color primaryColor;
  final Color darkColor;
  final Color lightColor;
  final Color fontColor;

  final String imagePath;

  final String comment;

  final double minPM10;
  final double minPM25;
  final double minO3;
  final double minNO2;
  final double minCO;
  final double minSO2;

  StatusModel({
    required this.level,
    required this.label,
    required this.primaryColor,
    required this.darkColor,
    required this.lightColor,
    required this.fontColor,
    required this.imagePath,
    required this.comment,
    required this.minPM10,
    required this.minPM25,
    required this.minO3,
    required this.minNO2,
    required this.minCO,
    required this.minSO2,
  });
}
