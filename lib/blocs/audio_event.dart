import 'package:equatable/equatable.dart';

abstract class AudioEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class PlayAudio extends AudioEvent {}

class PauseAudio extends AudioEvent {}
