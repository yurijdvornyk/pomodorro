import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pomodorro/common/constants.dart';
import 'package:pomodorro/common/dependencies/injector.dart';
import 'package:pomodorro/model/pomodorro_item.dart';
import 'package:pomodorro/presentation/details/details_bloc.dart';
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

  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    bloc = PomDependencyInjector.instance.detailsBloc(widget.pomodorroItem);
    titleController = TextEditingController(text: widget.pomodorroItem?.title);
    bloc.start();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: focusNode,
      onKeyEvent: (event) => handleKeyEvent(event),
      child: StreamBuilder(
        stream: bloc.stateStream,
        initialData: bloc.currentState,
        builder: (context, snapshot) {
          final state = snapshot.data;
          return state != null
              ? _buildEditPomWidget(state)
              : Container();
        },
      ),
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
                  onPressed: () => showCancelDialog(context, state.mode),
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
                  onPressed: () => onSaveClicked(state),
                  child: Text(
                    state.mode == DetailsMode.create ? 'Create' : 'Save',
                  ),
                ),
                SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () => showCancelDialog(context, state.mode),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: Text(
                    state.mode == DetailsMode.create ? 'Cancel' : 'Remove',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showCancelDialog(BuildContext context, DetailsMode mode) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Discard changes?"),
          content: Text("Are you sure you want to discard the changes?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () => closeDetailsPage(context, false),
              child: Text("Discard"),
            ),
          ],
        );
      },
    );
  }

  void onSaveClicked(EditState state) {
    if (state.title?.isNotEmpty == true) {
      bloc.sendEvent(SaveEvent());
      closeDetailsPage(context, true);
    } else {
      null;
    }
  }

  void closeDetailsPage(BuildContext context, bool isSuccess) {
    Navigator.of(
      context,
    ).popUntilWithResult(ModalRoute.withName('/'), isSuccess);
  }

  void handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.escape:
          showCancelDialog(context, bloc.currentState.mode);
          break;
        case LogicalKeyboardKey.enter:
          if (bloc.currentState.title?.isNotEmpty == true) {
            bloc.sendEvent(SaveEvent());
            closeDetailsPage(context, true);
          }
          break;
        default:
      }
    }
  }
}
