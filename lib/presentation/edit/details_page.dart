import 'package:flutter/material.dart';
import 'package:pomodorro/common/constants.dart';
import 'package:pomodorro/common/dependencies/injector.dart';
import 'package:pomodorro/model/pomodorro_item.dart';
import 'package:pomodorro/presentation/edit/details_bloc.dart';
import 'package:pomodorro/presentation/helpers/ui_utils.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key, this.pomodorroItem});

  final PomodorroItem? pomodorroItem;

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late final DetailsBloc bloc;

  late TextEditingController titleController;

  @override
  void initState() {
    super.initState();
    bloc = PomDependencyInjector.instance.detailsBloc(widget.pomodorroItem);
    titleController = TextEditingController();
    bloc.start();
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.stateStream,
      initialData: bloc.currentState,
      builder: (context, snapshot) {
        final state = snapshot.data;
        return state != null ? _buildEditPomWidget(state) : Container();
      },
    );
  }

  Widget _buildEditPomWidget(EditState state) {
    return Column(
      children: [
        AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_new),
          ),
          title: Text(
            widget.pomodorroItem != null ? 'Pom details' : 'Create new pom',
          ),
        ),
        Padding(
          padding: EdgeInsets.all(16.0),
          child: TextField(
            controller: titleController,
            onChanged: (value) => bloc.sendEvent(UpdateTitleEvent(value)),
            decoration: InputDecoration(
              hintText: 'Your pom title here',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Slider(
          label: "Concentration",
          value: state.concentration.toDouble(),
          divisions: UiUtils.getSliderDivisionsCount(
            PomConstants.concentrationMin.toDouble(),
            PomConstants.concentrationMax.toDouble(),
            PomConstants.concentrationStep.toDouble(),
          ),
          min: PomConstants.concentrationMin,
          max: PomConstants.concentrationMax,
          onChanged: (x) => bloc.sendEvent(UpdateConcentrationEvent(x.toInt())),
        ),
        Slider(
          label: "Relax",
          value: state.relax.toDouble(),
          divisions: UiUtils.getSliderDivisionsCount(
            PomConstants.relaxMin.toDouble(),
            PomConstants.relaxMax.toDouble(),
            PomConstants.relaxStep.toDouble(),
          ),
          min: PomConstants.relaxMin,
          max: PomConstants.relaxMax,
          onChanged: (x) => bloc.sendEvent(UpdateRelaxEvent(x.toInt())),
        ),
        Slider(
          label: "Cycles",
          value: state.cycles.toDouble(),
          divisions: UiUtils.getSliderDivisionsCount(
            PomConstants.cyclesMin.toDouble(),
            PomConstants.cyclesMax.toDouble(),
            PomConstants.cyclesStep.toDouble(),
          ),
          min: PomConstants.cyclesMin.toDouble(),
          max: PomConstants.cyclesMax.toDouble(),
          onChanged: (x) => bloc.sendEvent(UpdateCyclesEvent(x.toInt())),
        ),
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => bloc.sendEvent(SaveEvent()),
                child: const Text('Save'),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text('Remove'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
