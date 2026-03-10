import 'package:flutter/material.dart';
import 'package:pomodorro/common/dependencies/injector.dart';
import 'package:pomodorro/model/pomodorro_item.dart';
import 'package:pomodorro/presentation/edit/duration_slider.dart';
import 'package:pomodorro/presentation/edit/edit_bloc.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key, this.pomodorroItem});

  final PomodorroItem? pomodorroItem;

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final bloc = PomDependencyInjector.instance.editBloc;

  late TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              bloc.toString(),
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            TextField(
              controller: _titleController,
              onChanged: (value) => bloc.sendEvent(UpdateTitleEvent(value)),
              decoration: InputDecoration(
                hintText: 'Your pom title here',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _buildSliderField(
              'Concentration',
              state.concentration,
              5,
              90,
              (value) => bloc.sendEvent(UpdateConcentrationEvent(value)),
            ),
            const SizedBox(height: 16),
            _buildSliderField(
              'Relax',
              state.relax,
              1,
              30,
              (value) => bloc.sendEvent(UpdateRelaxEvent(value)),
            ),
            const SizedBox(height: 16),
            _buildSliderField(
              'Cycles',
              state.cycles,
              1,
              10,
              (value) => bloc.sendEvent(UpdateCyclesEvent(value)),
            ),
            const SizedBox(height: 24),
            Row(
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
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderField(
    String label,
    int value,
    int min,
    int max,
    Function(int) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        DurationSlider(value: value, min: min, max: max, onChanged: onChanged),
      ],
    );
  }
}
