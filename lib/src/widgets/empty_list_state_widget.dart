import 'package:flutter/material.dart';

import '../constants/color.dart';
import '../constants/icon.dart';

class EmptyListStateWidget extends StatelessWidget {
  const EmptyListStateWidget({
    String? iconSource,
    String? text,
    Key? key,
  })  : _iconSource = iconSource ?? ic_empty_data,
        _text = text ?? '',
        super(key: key);

  final String _iconSource;
  final String _text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(width: double.infinity),
            Image.asset(
              _iconSource,
              height: 150,
              width: 150,
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                _text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: gray600,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
