import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pomodorro/common/dependencies/injector.dart';
import 'package:pomodorro/model/pomodorro_item.dart';
import 'package:pomodorro/presentation/details/details_page.dart';
import 'package:pomodorro/presentation/home/home_bloc.dart';
import 'package:pomodorro/presentation/home/home_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _RefreshIntent extends Intent {}

class _HomePageState extends State<HomePage> {
  final HomeBloc bloc = PomDependencyInjector.instance.homeBloc;

  final CarouselController pomsController = CarouselController();

  @override
  void initState() {
    super.initState();
    bloc.start();
  }

  @override
  Widget build(BuildContext context) {
    return buildKeyboardShortcutWrapper(
      StreamBuilder<HomeState>(
        stream: bloc.stateStream,
        builder: (context, snapshot) {
          final state = snapshot.data;
          return Scaffold(
            appBar: AppBar(title: Text("Home")),
            body: SafeArea(
              child: Center(
                child:
                    state == null || state.isLoading
                        ? CircularProgressIndicator()
                        : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (state.pomodorros.isEmpty) ...[
                                Text("No pomodorros. Let's create one!"),
                              ] else ...[
                                _buildPomsList(state),
                              ],
                              SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  openPomBottomSheet(context, null);
                                },
                                child: Text("Create Pomodorro"),
                              ),
                            ],
                          ),
                        ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPomsList(HomeState state) {
    return SizedBox(
      height: 200.0,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: state.pomodorros.length,
        separatorBuilder: (context, index) => SizedBox(width: 16),
        shrinkWrap: true,
        itemBuilder:
            (context, index) => HomeCard(
              pomodorroItem: state.pomodorros[index],
              onTap: (item) => openPomBottomSheet(context, item),
            ),
      ),
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  Widget buildKeyboardShortcutWrapper(Widget child) {
    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyR):
            _RefreshIntent(),
      },
      child: Actions(
        actions: {
          _RefreshIntent: CallbackAction<_RefreshIntent>(
            onInvoke: (intent) {
              bloc.sendEvent(RefreshEvent());
              return null;
            },
          ),
        },
        child: Focus(autofocus: true, child: child),
      ),
    );
  }

  void openPomBottomSheet(BuildContext context, PomodorroItem? item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      useSafeArea: true,
      builder: (BuildContext context) {
        return DetailsPage(pomodorroItem: item);
      },
    ).then(
      (isSuccess) => {
        if (isSuccess == true) {showSnackBar("Pomodorro saved successfully!")},
      },
    );
  }

  void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message), duration: duration));
  }
}
