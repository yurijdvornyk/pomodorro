import 'package:flutter/material.dart';
import 'package:pomodorro/presentation/create/create_page.dart';
import 'package:pomodorro/presentation/home/home_bloc.dart';
import 'package:pomodorro/presentation/home/home_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required HomeBloc homeBloc})
    : _homeBloc = homeBloc;

  final HomeBloc _homeBloc;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    widget._homeBloc.start();
    // widget._homeBloc.stateStream.listen((state) {
    //   if (state is OpenCreatePageState) {
    //     openCreatePage();
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: SafeArea(
        child: Center(
          child: StreamBuilder<HomeState>(
            stream: widget._homeBloc.stateStream,
            builder: (context, snapshot) {
              final state = snapshot.data;
              if (state == null) {
                return CircularProgressIndicator();
              } else if (state.pomodorros.isEmpty) {
                return Text("No pomodorros. Let's create one!");
              }
              return SizedBox(
                height: 200,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(state.pomodorros.length * 2 - 1, (index) {
                      if (index.isEven) {
                        final itemIndex = index ~/ 2;
                        return HomeCard(
                          pomodorroItem: state.pomodorros[itemIndex],
                          onTap: (item) {
                            openCreatePage();
                          },
                        );
                      } else {
                        return SizedBox(width: 20);
                      }
                    }),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget._homeBloc.dispose();
    super.dispose();
  }

  void openCreatePage() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (ctx, animation, secondaryAnimation) => const CreatePage(),
        transitionsBuilder: (ctx, animation, secondaryAnimation, child) {
          final tween = Tween<Offset>(
            begin: const Offset(0, 1), // start just below the screen
            end: Offset.zero,
          );
          final offsetAnimation = animation
              .drive(CurveTween(curve: Curves.ease))
              .drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  }
}
