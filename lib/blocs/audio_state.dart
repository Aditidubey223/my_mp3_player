import 'package:equatable/equatable.dart';

abstract class AudioState extends Equatable {
  @override
  List<Object> get props => [];
}

class AudioInitial extends AudioState {}

class AudioLoading extends AudioState {}

class AudioPlaying extends AudioState {}

class AudioPaused extends AudioState {}

class AudioError extends AudioState {
  final String message;

  AudioError(this.message);

  @override
  List<Object> get props => [message];
}
