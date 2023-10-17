import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:provider/provider.dart';
import 'package:to_do_list/data/repo/repository.dart';
import 'package:to_do_list/main.dart';
import 'package:to_do_list/screen/edit/edit.dart';
import 'package:to_do_list/screen/home/bloc/task_list_bloc.dart';
import 'package:to_do_list/widgets.dart';

import '../../data/data.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
      
      
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EditTaskScreen(
                      task: TaskEntity(),
                    )));
          },
          label: const Row(
            children: [
              Text(
                'Add New Task',
              ),
              SizedBox(
                width: 4,
              ),
              Icon(Icons.add)
            ],
          )),
      body: BlocProvider<TaskListBloc>(
        create: (context) =>
            TaskListBloc(context.read<Repository<TaskEntity>>()),
        child: Builder(builder: (context) {
          return SafeArea(
            child: Column(
              children: [
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                        themeData.colorScheme.primary,
                        themeData.colorScheme.primaryContainer,
                      ])),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'To Do List',
                              style: themeData.textTheme.titleLarge,
                            ),
                           
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Container(
                          height: 38,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(19),
                            color: themeData.colorScheme.background,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: controller,
                            onChanged: (value) {
                              context
                                  .read<TaskListBloc>()
                                  .add(TaskListSearch(value));
                            },
                            decoration: const InputDecoration(
                              label: Text('Search Task'),
                              prefixIcon: Icon(CupertinoIcons.search),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(child: Consumer<Repository<TaskEntity>>(
                  builder: (context, model, child) {
                    context.read<TaskListBloc>().add(TaskListStarted());
                    return BlocBuilder<TaskListBloc, TaskListState>(
                      builder: (context, state) {
                        if (state is TaskListSuccess) {
                          return TaskList(
                              items: state.items, themeData: themeData);
                        } else if (state is TaskListEmpty) {
                          return const EmptyState();
                        } else if (state is TaskListLoading ||
                            state is TaskListInitial) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is TaskListError) {
                          return Center(
                            child: Text(state.errorMessage),
                          );
                        } else {
                          throw Exception('State is Not Valid');
                        }
                      },
                    );
                  },
                )),
              ],
            ),
          );
         
        }),),
    );
  }
}

class TaskList extends StatelessWidget {
  const TaskList({
    super.key,
    required this.items,
    required this.themeData,
  });

  final List<TaskEntity> items;
  final ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(bottom: 80),
      physics: BouncingScrollPhysics(),
      itemCount: items.length + 1,
      itemBuilder: ((context, index) {
        if (index == 0) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Today',
                    style: themeData.textTheme.bodyLarge,
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Container(
                    width: 60,
                    height: 3,
                    decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(1.5)),
                  )
                ],
              ),
              MaterialButton(
                textColor: secondaryTextColor,
                elevation: 0,
                color: const Color(0xffEAEFF5),
                onPressed: () {
                  context.read<TaskListBloc>().add(TaskListDeleteAll());
                },
                child: const Row(
                  children: [
                    Text('Delete All'),
                    SizedBox(
                      width: 4,
                    ),
                    Icon(
                      CupertinoIcons.delete_solid,
                      size: 16,
                    )
                  ],
                ),
              )
            ],
          );
        } else {
          final TaskEntity task = items.toList()[index - 1];
          return TaskItem(task: task );
          
        }
      }),
    );
  }
}

class TaskItem extends StatefulWidget {
  const TaskItem({
    super.key,
    required this.task,
  });

  final TaskEntity task;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final Color priorityColor;
    switch (widget.task.priority) {
      case Priority.low:
        priorityColor = const Color(0xff3BE1F1);
        break;
      case Priority.high:
        priorityColor = const Color.fromARGB(248, 120, 0, 133);
        break;
      case Priority.normal:
        priorityColor = themeData.colorScheme.primary;
        break;
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 4.5, 10, 4.5),
      child: Container(
        height: 84,
        padding: const EdgeInsets.only(
          left: 16,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: themeData.colorScheme.surface,
            boxShadow: [
              BoxShadow(
                  blurRadius: 20,
                  color: themeData.colorScheme.onPrimary.withOpacity(0.2))
            ]),
        child: Row(
          children: [
            MyCheckBox(
              value: widget.task.isComplete,
              onTap: () {
                setState(() {
                  widget.task.isComplete = !widget.task.isComplete;
                });
              },
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EditTaskScreen(task: widget.task)));
                },
                child: Text(
                  widget.task.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 18,
                      decoration: widget.task.isComplete
                          ? TextDecoration.lineThrough
                          : null),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12, left: 12),
              child: InkWell(
                onTap: () {
                  final iconRepository = Provider.of<Repository<TaskEntity>>(
                      context,
                      listen: false);
                  iconRepository.delete(widget.task);
                },
                child: const Icon(
                  CupertinoIcons.delete_solid,
                  size: 22,
                  color: Color(0xff1D2830),
                ),
              ),
            ),
            Container(
              height: 84,
              width: 6,
              decoration: BoxDecoration(
                  color: priorityColor,
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8))),
            )
          ],
        ),
      ),
    );
  }
}
