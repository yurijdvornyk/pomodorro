import 'package:flutter/material.dart';
import 'package:pomodorro/presentation/create/duration_slider.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  late TextEditingController _titleController;
  int _concentration = 25;
  int _relax = 5;
  int _cycles = 3;

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
    return Scaffold(
      appBar: AppBar(title: const Text('Create Pomodoro')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              _buildSliderField('Concentration', _concentration, 5, 90, (value) {
                setState(() => _concentration = value);
              }),
              const SizedBox(height: 16),
              _buildSliderField('Relax', _relax, 1, 30, (value) {
                setState(() => _relax = value);
              }),
              const SizedBox(height: 16),
              _buildSliderField('Cycles', _cycles, 1, 10, (value) {
                setState(() => _cycles = value);
              }),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(onPressed: () {}, child: const Text('Save')),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Remove'),
                  ),
                ],
              ),
            ],
          ),
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
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        DurationSlider(
          value: value,
          min: min,
          max: max,
          onChanged: onChanged,
          width: 250,
        ),
      ],
    );
  }
}
