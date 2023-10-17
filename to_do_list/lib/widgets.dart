
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/main.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/image/es.png',
          width: 300,
          height: 300,
        ),
        const SizedBox(
          height: 8,
        ),
        const Text('Your Task List Is Empty!')
      ],
    );
  }
}
class MyCheckBox extends StatelessWidget {
  final bool value;
  final Function() onTap;

  const MyCheckBox({super.key, required this.value, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: value ? primaryColor : null,
          borderRadius: BorderRadius.circular(12),
          border:
              !value ? Border.all(color: secondaryTextColor, width: 2) : null,
        ),
        child: value
            ? const Icon(
                CupertinoIcons.checkmark,
                size: 18,
              )
            : null,
      ),
    );
  }
}
