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
        return state != null
            ? _buildEditPomWidget(state)
            : SizedBox(width: 0.0, height: 0.0);
      },
    );
  }

  Widget _buildEditPomWidget(EditState state) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.arrow_back),
                ),
                Spacer(),
                Text(
                  widget.pomodorroItem == null
                      ? "Create pomodorro"
                      : "Edit pomodorro",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Spacer(),
              ],
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
          Text("Concentration"),
          Text(
            "${state.concentration}",
            style: TextStyle(
              fontSize: 24,
              color: Colors.deepOrange,
              fontWeight: FontWeight.bold,
            ),
          ),
          Slider(
            value: state.concentration.toDouble(),
            divisions: UiUtils.getSliderDivisionsCount(
              PomConstants.concentrationMin.toDouble(),
              PomConstants.concentrationMax.toDouble(),
              PomConstants.concentrationStep.toDouble(),
            ),
            min: PomConstants.concentrationMin,
            max: PomConstants.concentrationMax,
            onChanged:
                (x) => bloc.sendEvent(UpdateConcentrationEvent(x.toInt())),
          ),
          Text("Relax"),
          Text(
            "${state.relax}",
            style: TextStyle(
              fontSize: 24,
              color: Colors.deepOrange,
              fontWeight: FontWeight.bold,
            ),
          ),
          Slider(
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
          Text("Cycles"),
          Text(
            "${state.cycles}",
            style: TextStyle(
              fontSize: 24,
              color: Colors.deepOrange,
              fontWeight: FontWeight.bold,
            ),
          ),
          Slider(
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
                  child: Text(state.mode == DetailsMode.create ? 'Create' : 'Save'),
                ),
                SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: Text(state.mode == DetailsMode.create ? 'Cancel' : 'Remove'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
