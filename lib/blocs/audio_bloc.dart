import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:just_audio/just_audio.dart';
import 'audio_event.dart';
import 'audio_state.dart';

class AudioBloc extends Bloc<AudioEvent, AudioState> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  AudioBloc() : super(AudioInitial()) {
    on<PlayAudio>((event, emit) async {
      emit(AudioLoading());
      try {
        final file = await _downloadAudioFile(
            'https://codeskulptor-demos.commondatastorage.googleapis.com/descent/background%20music.mp3');

        await _audioPlayer.setFilePath(file.path);
        _audioPlayer.play();
        emit(AudioPlaying());
      } catch (e) {
        emit(AudioError(_mapErrorToMessage(e)));
      }
    });

    on<PauseAudio>((event, emit) async {
      await _audioPlayer.pause();
      emit(AudioPaused());
    });
  }

  Future<File> _downloadAudioFile(String url) async {
    try {
      final uri = Uri.parse(url);

      // Validate URL
      if (!uri.isAbsolute) {
        throw const FormatException('Invalid URL');
      }

      // HTTP Request with timeout handling
      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      // Handle HTTP errors
      if (response.statusCode == 200) {
        final directory = await getTemporaryDirectory();
        final filePath = '${directory.path}/downloaded_audio.mp3';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        return file;
      } else {
        throw HttpException(
            'HTTP Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } on SocketException {
      throw Exception('No Internet connection. Please check your network.');
    } on HttpException {
      throw Exception('Failed to fetch audio from the server.');
    } on FormatException {
      throw Exception('The provided URL is invalid.');
    } on TimeoutException {
      throw Exception('Request timed out. Please try again later.');
    }
  }

  // Maps different errors to user-friendly messages
  String _mapErrorToMessage(Object error) {
    if (error is SocketException) {
      return 'No Internet connection. Please check your network.';
    } else if (error is HttpException) {
      return 'Failed to fetch audio. Please try again later.';
    } else if (error is FormatException) {
      return 'The provided audio URL is invalid.';
    } else if (error is TimeoutException) {
      return 'Request timed out. Please try again later.';
    } else {
      return 'An unexpected error occurred: $error';
    }
  }

  @override
  Future<void> close() {
    _audioPlayer.dispose();
    return super.close();
  }
}
