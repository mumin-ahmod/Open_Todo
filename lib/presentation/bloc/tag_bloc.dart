import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/utils/result.dart';
import '../../domain/repositories/tag_repository.dart';
import 'tag_event.dart';
import 'tag_state.dart';

class TagBloc extends Bloc<TagEvent, TagState> {
  TagBloc(this._repository) : super(const TagState()) {
    on<TagStarted>(_onStarted);
    on<TagAdded>(_onAdded);
    on<TagRemoved>(_onRemoved);
  }

  final TagRepository _repository;

  Future<void> _onStarted(TagStarted event, Emitter<TagState> emit) async {
    emit(state.copyWith(status: TagStatus.loading, clearMessage: true));
    final result = await _repository.getTags();
    switch (result) {
      case Success(:final value):
        emit(state.copyWith(status: TagStatus.success, tags: value));
      case Error(:final failure):
        emit(state.copyWith(status: TagStatus.failure, message: failure.message));
    }
  }

  Future<void> _onAdded(TagAdded event, Emitter<TagState> emit) async {
    final result = await _repository.addTag(event.name);
    switch (result) {
      case Success(:final value):
        emit(
          state.copyWith(
            tags: [...state.tags, value],
            clearMessage: true,
          ),
        );
      case Error(:final failure):
        emit(state.copyWith(message: failure.message));
    }
  }

  Future<void> _onRemoved(TagRemoved event, Emitter<TagState> emit) async {
    final result = await _repository.deleteTag(event.id);
    switch (result) {
      case Success():
        emit(
          state.copyWith(
            tags: state.tags.where((t) => t.id != event.id).toList(),
            clearMessage: true,
          ),
        );
      case Error(:final failure):
        emit(state.copyWith(message: failure.message));
    }
  }
}