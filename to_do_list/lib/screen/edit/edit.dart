import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/data/data.dart';
import 'package:to_do_list/data/repo/repository.dart';

class EditTaskScreen extends StatefulWidget {
  final TaskEntity task;
  const EditTaskScreen({super.key, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.task.name);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Scaffold(
      backgroundColor: themeData.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: themeData.colorScheme.primary,
        foregroundColor: themeData.colorScheme.onSurface,
        title: const Text('Add New Task'),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (_controller.text.replaceAll(' ', '').isNotEmpty) {
              widget.task.name = _controller.text.trim();
              widget.task.priority = widget.task.priority;
              final repository =
                  Provider.of<Repository<TaskEntity>>(context, listen: false);
              repository.createOrUpdate(widget.task);
              Navigator.of(context).pop();
            } else {
              Fluttertoast.showToast(
                  msg: "Please enter your task",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 2,
                  backgroundColor: Color.fromARGB(255, 0, 0, 0),
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
          },
          label: const Text('Save')),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          Flex(
            direction: Axis.horizontal,
            children: [
              Flexible(
                  flex: 1,
                  child: PriorityCheckBox(
                    label: 'High',
                    color: const Color.fromARGB(248, 120, 0, 133),
                    isSelected: widget.task.priority == Priority.high,
                    onTap: () {
                      setState(() {
                        widget.task.priority = Priority.high;
                      });
                    },
                  )),
              const SizedBox(
                width: 8,
              ),
              Flexible(
                  flex: 1,
                  child: PriorityCheckBox(
                    label: 'Normal',
                    color: themeData.colorScheme.primary,
                    isSelected: widget.task.priority == Priority.normal,
                    onTap: () {
                      setState(() {
                        widget.task.priority = Priority.normal;
                      });
                    },
                  )),
              const SizedBox(
                width: 8,
              ),
              Flexible(
                  flex: 1,
                  child: PriorityCheckBox(
                    label: 'Low',
                    color: const Color(0xff3BE1F1),
                    isSelected: widget.task.priority == Priority.low,
                    onTap: () {
                      setState(() {
                        widget.task.priority = Priority.low;
                      });
                    },
                  )),
            ],
          ),
          TextField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            controller: _controller,
            decoration: const InputDecoration(label: Text('Add Your Task...')),
          ),
        ]),
      ),
    );
  }
}

class PriorityCheckBox extends StatelessWidget {
  final String label;
  final Color color;
  final bool isSelected;
  final GestureTapCallback onTap;

  const PriorityCheckBox(
      {super.key,
      required this.label,
      required this.color,
      required this.isSelected,
      required this.onTap});
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
              width: 2,
              color: themeData.colorScheme.onPrimary.withOpacity(0.1)),
        ),
        child: Stack(
          children: [
            Center(
                child: Text(
              label,
            )),
            Positioned(
              right: 8,
              bottom: 0,
              top: 0,
              child: Center(
                child: EditCheckBox(
                  value: isSelected,
                  color: color,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class EditCheckBox extends StatelessWidget {
  final bool value;
  final Color color;

  const EditCheckBox({super.key, required this.value, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: value
          ? const Icon(
              CupertinoIcons.checkmark,
              size: 12,
            )
          : null,
    );
  }
}
