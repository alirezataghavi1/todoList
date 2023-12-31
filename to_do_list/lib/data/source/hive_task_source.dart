import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_list/data/data.dart';
import 'package:to_do_list/data/source/source.dart';

class hiveTaskDataSource implements DataSource<TaskEntity> {
  final Box<TaskEntity> box;

  hiveTaskDataSource(this.box);
  @override
  Future<TaskEntity> createOrUpdate(TaskEntity data) async {
    if (data.isInBox) {
      data.save();
    } else {
      data.id = await box.add(data);
    }
    return data;
  }

  @override
  Future<void> delete(TaskEntity data) async {
    return data.delete();
  }

  @override
  Future<void> deleteAll() {
    return box.clear();
  }

  @override
  Future<void> deleteById(id) {
    return box.delete(id);
  }

  @override
  Future<TaskEntity> findById(id) async {
    return box.values.firstWhere((element) => element.id == id);
  }

  @override
  Future<List<TaskEntity>> getAll({String searchKeyWord = ''}) async {
    if (searchKeyWord.isNotEmpty) {
      return box.values
          .where((element) => element.name.contains(searchKeyWord))
          .toList();
    } else {
      return box.values.toList();
    }
  }
}
