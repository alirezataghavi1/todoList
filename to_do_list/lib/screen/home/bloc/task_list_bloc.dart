import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:to_do_list/data/data.dart';
import 'package:to_do_list/data/repo/repository.dart';

part 'task_list_event.dart';
part 'task_list_state.dart';

class TaskListBloc extends Bloc<TaskListEvent, TaskListState> {
  final Repository<TaskEntity> repository;
  TaskListBloc(this.repository) : super(TaskListInitial()) {
    on<TaskListEvent>((event, emit) async {
      if (event is TaskListSearch || event is TaskListStarted) {
        final String searchTerm;
        emit(TaskListLoading());
        await Future.delayed(const Duration(milliseconds: 250));
        if (event is TaskListSearch) {
          searchTerm = event.searchTerm;
        } else {
          searchTerm = '';
        }

        try {
          final items = await repository.getAll(searchKeyWord: searchTerm);
          if (items.isNotEmpty) {
            emit(TaskListSuccess(items));
          } else {
            emit(TaskListEmpty());
          }
        } catch (e) {
          emit(TaskListError('Unknown Error'));
        }

      }else if(event is TaskListDeleteAll){
       await repository.deleteAll();
       emit(TaskListEmpty());
      }
    });
  }
}
