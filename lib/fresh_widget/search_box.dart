import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 8, 10),
      child: Transform.rotate(
        angle: -0.01,
        child: SizedBox(
          height: 48,
          child: Stack(
            children: [
              Positioned.fill(
                child: Transform.translate(
                  offset: const Offset(8, 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      border: Border.all(width: 2),
                    ),
                  ),
                ),
              ),
              DottedBorder(
                strokeWidth: 2,
                borderType: BorderType.RRect,
                dashPattern: const [3, 3, 1],
                strokeCap: StrokeCap.round,
                radius: const Radius.circular(2),
                child: Container(
                  decoration: const BoxDecoration(color: Colors.white),
                  child: TextField(
                    cursorColor: Theme.of(context).primaryColor,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 14),
                      hintText: 'Search here ...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
