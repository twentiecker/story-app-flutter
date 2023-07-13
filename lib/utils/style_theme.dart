import 'package:flutter/material.dart';

TextStyle displaySmall(context, ratio, color) =>
    Theme.of(context).textTheme.displaySmall!.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: ratio * 48,
        );

TextStyle titleMedium(context, ratio, color, weight) =>
    Theme.of(context).textTheme.titleMedium!.copyWith(
          color: color,
          fontSize: ratio * 16,
          fontWeight: weight ?? FontWeight.w400,
        );
