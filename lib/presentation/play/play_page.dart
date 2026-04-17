import 'package:flutter/material.dart';
import 'package:pomodorro/common/dependencies/injector.dart';
import 'package:pomodorro/model/pomodorro_item.dart';
import 'package:pomodorro/presentation/base.dart';
import 'package:pomodorro/presentation/play/animated_background.dart';
import 'package:pomodorro/presentation/play/play_bloc.dart';

class PlayPage extends StatefulWidget {
  const PlayPage({super.key});

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  final PlayBloc bloc = PomDependencyInjector.instance.playBloc;
  late final PomodorroItem? pomItem;

  @override
  void initState() {
    super.initState();
    bloc.start();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    pomItem = getArgument<PomodorroItem>();
    if (pomItem != null) {
      bloc.sendEvent(PomodorroSetEvent(pomItem!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayState>(
      stream: bloc.stateStream,
      builder: (context, snapshot) {
        final state = snapshot.data;
        return Scaffold(
          appBar: AppBar(title: Text("Play")),
          body: SafeArea(
            child: Stack(
              children: [
                AnimatedBackground(),
                Center(
                  child: SizedBox(
                    width: 380,
                    height: 380,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      value:
                          state != null && pomItem != null && state.isPlaying
                              ? (state.currentPosition /
                                  pomItem!.concentrationMinutes)
                              : 1.0,
                      strokeWidth: 4,
                    ),
                  ),
                ),
                Center(
                  child: IconButton(
                    iconSize: 256,
                    icon: Icon(Icons.play_arrow_rounded),
                    color: Colors.white,
                    onPressed: () {
                      bloc.sendEvent(StartPomEvent());
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
