import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter/rendering.dart' show ViewportOffset;

class CarouselFlowDelegate extends FlowDelegate {
  CarouselFlowDelegate({
    required this.viewportOffset,
    required this.filtersPerScreen,
  }) : super(repaint: viewportOffset);

  final ViewportOffset viewportOffset;
  final int filtersPerScreen;

  @override
  void paintChildren(FlowPaintingContext context) {
    final count = context.childCount;

    // Total lebar yang tersedia
    final size = context.size.width;

    // Ukuran tiap item dalam carousel
    final itemExtent = size / filtersPerScreen;

    // Posisi scroll dalam bentuk fraksi item (misal: 1.3 berarti sedang menuju item 2)
    final active = viewportOffset.pixels / itemExtent;

    // Indeks item pertama yang perlu dirender
    final min = math.max(0, active.floor() - 3).toInt();

    // Indeks item terakhir yang perlu dirender
    final max = math.min(count - 1, active.ceil() + 3).toInt();

    // Loop untuk menggambar item yang terlihat
    for (var index = min; index <= max; index++) {
      final itemXFromCenter = itemExtent * index - viewportOffset.pixels;
      final percentFromCenter = (1.0 - (itemXFromCenter / (size / 2)).abs()).clamp(0.0, 1.0);
      final itemScale = 0.7 + (percentFromCenter * 0.3);
      final opacity = 0.3 + (percentFromCenter * 0.7);

      final itemTransform = Matrix4.identity()
        ..translate((size - itemExtent) / 2)
        ..translate(itemXFromCenter)
        ..translate(itemExtent / 2, itemExtent / 2)
        ..scale(itemScale)
        ..translate(-itemExtent / 2, -itemExtent / 2);

      context.paintChild(
        index,
        transform: itemTransform,
        opacity: opacity,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CarouselFlowDelegate oldDelegate) {
    return oldDelegate.viewportOffset != viewportOffset || oldDelegate.filtersPerScreen != filtersPerScreen;
  }
}
