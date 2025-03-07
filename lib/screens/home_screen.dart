import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/audio_bloc.dart';
import '../blocs/audio_state.dart';
import '../widgets/audio_controls.dart';
import '../widgets/equalizer_visualizer.dart';
import '../theme/colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const _BackgroundImage(),
          const _Overlay(),
          const _AudioPlayerUI(),
          _ErrorListener(),
        ],
      ),
    );
  }
}

// Background Image Widget
class _BackgroundImage extends StatelessWidget {
  const _BackgroundImage();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Image.asset(
        'assets/music_cover.jpg',
        fit: BoxFit.cover,
      ),
    );
  }
}

// Overlay Widget
class _Overlay extends StatelessWidget {
  const _Overlay();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: AppColors.overlay,
      ),
    );
  }
}

// Main UI for Audio Player
class _AudioPlayerUI extends StatelessWidget {
  const _AudioPlayerUI();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              AppColors.primary,
              AppColors.secondary,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.7),
              blurRadius: 10,
              spreadRadius: 5,
            ),
          ],
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SongDetails(),
            SizedBox(height: 20),
            _AudioVisualizer(),
            SizedBox(height: 20),
            Center(child: Text("2:49", style: TextStyle(color: AppColors.textPrimary))),
            SizedBox(height: 20),
            Center(child: AudioControls()),
          ],
        ),
      ),
    );
  }
}

// Song Details Widget
class _SongDetails extends StatelessWidget {
  const _SongDetails();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Instant Crush",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 5),
        Text(
          "feat. Julian Casablancas",
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

// Audio Visualizer 
class _AudioVisualizer extends StatelessWidget {
  const _AudioVisualizer();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioBloc, AudioState>(
      builder: (context, state) {
        if (state is AudioLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.textPrimary),
          );
        }
        return EqualizerVisualizer(isPlaying: state is AudioPlaying);
      },
    );
  }
}

// Error Listener 
class _ErrorListener extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AudioBloc, AudioState>(
      listenWhen: (previous, current) => current is AudioError,
      listener: (context, state) {
        if (state is AudioError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      child: const SizedBox.shrink(),
    );
  }
}