import 'package:flutter/material.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  late TextEditingController _titleController;
  double _concentration = 25;
  double _relax = 5;
  double _cycles = 3;

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
      body: Padding(
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
            const Spacer(),
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
    );
  }

  Widget _buildSliderField(
    String label,
    double value,
    double min,
    double max,
    Function(double) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ${value.toInt()}'),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: (max - min).toInt(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
