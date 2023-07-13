import 'package:flutter/material.dart';

import 'color_theme.dart';

TextStyle displaySmall(context, ratio, color) =>
    Theme.of(context).textTheme.displaySmall!.copyWith(
          fontSize: ratio * 48,
          color: color,
          fontWeight: FontWeight.bold,
        );

TextStyle headlineSmall(context, ratio) =>
    Theme.of(context).textTheme.headlineSmall!.copyWith(
          fontSize: ratio * 24,
          color: lightGreen,
          fontWeight: FontWeight.w500,
        );

TextStyle titleMedium(context, ratio, color, weight) =>
    Theme.of(context).textTheme.titleMedium!.copyWith(
          fontSize: ratio * 16,
          color: color,
          fontWeight: weight ?? FontWeight.w400,
        );

TextStyle titleSmall(context, ratio) =>
    Theme.of(context).textTheme.titleSmall!.copyWith(
          fontSize: ratio * 14,
          color: white,
        );

TextStyle bodyMedium(context, ratio, color) =>
    Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontSize: ratio * 14,
          color: color,
        );
