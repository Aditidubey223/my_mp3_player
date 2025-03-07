import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/audio_bloc.dart';
import '../blocs/audio_event.dart';
import '../blocs/audio_state.dart';

class AudioControls extends StatelessWidget {
  const AudioControls({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioBloc, AudioState>(
      builder: (context, state) {
        final isPlaying = state is AudioPlaying;

        return GestureDetector(
          onTap: () {
            context
                .read<AudioBloc>()
                .add(isPlaying ? PauseAudio() : PlayAudio());
          },
          child: CircleAvatar(
            radius: 40, 
            backgroundColor: Colors.white,  
            child: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow, 
              color: Colors.black,  
              size: 40, 
            ),
          ),
        );
      },
    );
  }
}
