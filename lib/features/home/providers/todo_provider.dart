import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tiny_weather/features/home/components/switch_type_button.dart';
import 'package:tiny_weather/local/key/local_key.dart';
import 'package:tiny_weather/local/model/info.dart';
import 'package:tiny_weather/local/storage/local_storage.dart';
import 'package:tiny_weather/mock/mock.dart';
import 'package:tiny_weather/local/model/todo.dart';
part 'todo_provider.g.dart';
enum SwitchTypeEnum { todo, flow, plan }
@riverpod
class SwitchType extends _$SwitchType{
  @override
  int build() => 0;
  void change() {
    state = (state + 1)%SwitchTypeEnum.values.length;
  }
}



@riverpod
class TodoList extends _$TodoList {
  @override
  List<Todo> build() {
    /// 从本地存储中取出的时候得更新所有的Todo
    List<Todo>? todos = (LocalStorage.get<List?>(key: BoxKey.todos))?.cast<Todo>();
    if ( todos == null ){
      LocalStorage.put(key: BoxKey.todos, data: <Todo>[]);
    }
    var updateTodos = todos ?? <Todo>[];
    var length = updateTodos.length;
    for( var index = 0 ; index < length; ++index ){
      updateTodos[index].updateState();
    }
    LocalStorage.put(key: BoxKey.todos, data: updateTodos);
    return updateTodos;
  }
  
  void finishedTodo(int index) {
    final updatedList = [...state];
    updatedList[index].state = BaseState.finished();
    state = updatedList;
  }
  
  void updateTodoState(int index) {
    final updatedList = [...state];
    updatedList[index].updateState();
    state = updatedList;
  }
  Todo getTodo(String uuid){
    return state.firstWhere((e) => e.uuid == uuid);
  }
  void add(Todo todo){
    final updatedList = <Todo>[...state];
    todo.updateState();
    updatedList.add(todo);
    state = updatedList;
    save();
  }
  void save(){
    LocalStorage.put(key: BoxKey.todos,data: state);
  }
  void removeAll(List<String> todos){
    final updatedList = [...state];
    var length = todos.length;
    for(var index = 0 ; index < length; ++index){
      updatedList.removeWhere(((e) => e.uuid == todos[index]));
    }
    state = updatedList;
    save();
  }
}
@riverpod
class SelectedList extends _$SelectedList {
  @override
  List<String> build() => [];
  void add(String uuid){
    final updatedList = [...state];
    updatedList.add(uuid);
    state = updatedList;
  }
  void remove(String uuid){
    final updatedList = [...state];
    updatedList.remove(uuid);
    state = updatedList;
  }
  void clear(){
    state = [];
  }
}
@riverpod
bool isSelectedMode (Ref ref) {
  return ref.watch(selectedListProvider).isNotEmpty;
}

@riverpod
int finishedCount (Ref ref){
  var counter = 0;
  var list = ref.watch(todoListProvider);
  var length = list.length;
  for( var index = 0; index < length; ++index ){
    if(list[index].state.isFinished){
      ++counter;
    }
  }
  return counter;
}

@riverpod
int enableCount (Ref ref){
  var counter = 0;
  var list = ref.watch(todoListProvider);
  var length = list.length;
  for( var index = 0; index < length; ++index ){
    if(list[index].state.isEnabled){
      ++counter;
    }
  }
  return counter;
}

@riverpod
int failedCount (Ref ref){
  var counter = 0;
  var list = ref.watch(todoListProvider);
  var length = list.length;
  for( var index = 0; index < length; ++index ){
    if(list[index].state.isFailed){
      ++counter;
    }
  }
  return counter;
}