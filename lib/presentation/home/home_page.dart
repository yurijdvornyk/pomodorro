import 'package:flutter/material.dart';
import 'package:pomodorro/common/dependencies/injector.dart';
import 'package:pomodorro/model/pomodorro_item.dart';
import 'package:pomodorro/presentation/edit/edit_page.dart';
import 'package:pomodorro/presentation/home/home_bloc.dart';
import 'package:pomodorro/presentation/home/home_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeBloc bloc = PomDependencyInjector.instance.homeBloc;

  @override
  void initState() {
    super.initState();
    bloc.start();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<HomeState>(
      stream: bloc.stateStream,
      builder: (context, snapshot) {
        final state = snapshot.data;
        return Scaffold(
          appBar: AppBar(title: Text("Home")),
          body: SafeArea(
            child: Center(
              child:
                  state == null
                      ? CircularProgressIndicator()
                      : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (state.pomodorros.isEmpty) ...[
                              Text("No pomodorros. Let's create one!"),
                            ] else ...[
                              _buildPomsList(state.pomodorros),
                            ],
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (BuildContext context) {
                                    return _buildHomeBottomSheet(state);
                                  },
                                );
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
    );
  }

  Widget _buildPomsList(List<PomodorroItem> poms) {
    return SizedBox(
      height: 200,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(poms.length * 2 - 1, (index) {
            if (index.isEven) {
              final itemIndex = index ~/ 2;
              return HomeCard(
                pomodorroItem: poms[itemIndex],
                onTap: (item) {
                  onCreateTapped();
                },
              );
            } else {
              return SizedBox(width: 20);
            }
          }),
        ),
      ),
    );
  }

  Widget _buildHomeBottomSheet(HomeState? state) {
    return EditPage(pomodorroItem: state?.editingItem);
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  void onCreateTapped() {
    bloc.sendEvent(CreateTappedEvent());
  }
}
