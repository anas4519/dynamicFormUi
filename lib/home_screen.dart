import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> _dynamicWidgets = [];
  final List<TextEditingController> _labelcontrollers = [];
  final List<TextEditingController> _infoTextControllers = [];
  final List<List<bool>> _checkboxValues = [];
  final List<GlobalKey<FormState>> _formKeys = [];

  @override
  void initState() {
    super.initState();
    _addInitialDynamicComponent();
  }

  void _addInitialDynamicComponent() {
    TextEditingController labelcontroller = TextEditingController();
    TextEditingController infoTextController = TextEditingController();
    _labelcontrollers.add(labelcontroller);
    _infoTextControllers.add(infoTextController);
    _checkboxValues.add([false, false, false]);
    _formKeys.add(GlobalKey<FormState>());

    int index = _dynamicWidgets.length;
    _dynamicWidgets.add(
      _buildDynamicComponent(
          labelcontroller, infoTextController, index, _formKeys[index]),
    );
  }

  Widget _buildDynamicComponent(
      TextEditingController labelController,
      TextEditingController infoController,
      int index,
      GlobalKey<FormState> formKey) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.check_box_outlined, color: Colors.green),
                      const SizedBox(width: 8),
                      const Text(
                        'Checkbox',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () => _removeDynamicComponent(index),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Remove'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          formKey.currentState!.validate();
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Done'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Label'),
                  ),
                  TextFormField(
                    controller: labelController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.text,
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Label field cannot be empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Info-Text'),
                  ),
                  TextFormField(
                    controller: infoController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Settings'),
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: _checkboxValues[index][0],
                        onChanged: (bool? value) {
                          setState(() {
                            _checkboxValues[index][0] = value!;
                          });
                        },
                      ),
                      const Text('Required'),
                      const SizedBox(width: 15),
                      Checkbox(
                        value: _checkboxValues[index][1],
                        onChanged: (bool? value) {
                          setState(() {
                            _checkboxValues[index][1] = value!;
                          });
                        },
                      ),
                      const Text('Read-only'),
                      const SizedBox(width: 15),
                      Checkbox(
                        value: _checkboxValues[index][2],
                        onChanged: (bool? value) {
                          setState(() {
                            _checkboxValues[index][2] = value!;
                          });
                        },
                      ),
                      const Text('Hidden Field'),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: _addDynamicComponent,
                        child: const Text('Add Field'),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _addDynamicComponent() {
    TextEditingController labelcontroller = TextEditingController();
    TextEditingController infoTextController = TextEditingController();
    _labelcontrollers.add(labelcontroller);
    _infoTextControllers.add(infoTextController);
    _checkboxValues.add([false, false, false]);
    _formKeys.add(GlobalKey<FormState>());

    int index = _dynamicWidgets.length;
    setState(() {
      _dynamicWidgets.add(_buildDynamicComponent(
          labelcontroller, infoTextController, index, _formKeys[index]));
    });
  }

  void _removeDynamicComponent(int index) {
    if (index == 0) return;
    setState(() {
      _labelcontrollers.removeAt(index);
      _infoTextControllers.removeAt(index);
      _checkboxValues.removeAt(index);
      _dynamicWidgets.removeAt(index);
      _formKeys.removeAt(index);
      _dynamicWidgets = List.generate(
        _labelcontrollers.length,
        (i) => _buildDynamicComponent(
            _labelcontrollers[i], _infoTextControllers[i], i, _formKeys[i]),
      );
    });
  }

  void _showResults() {
    List<String> labels =
        _labelcontrollers.map((controller) => controller.text).toList();
    List<String> infoTexts =
        _infoTextControllers.map((controller) => controller.text).toList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Submitted Data'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                for (int i = 0; i < labels.length; i++) ...[
                  Text(
                    'Component ${i + 1} : ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Label: ${labels[i]}'),
                  Text('Info-Text: ${infoTexts[i]}'),
                  Text('Required: ${_checkboxValues[i][0]}'),
                  Text('Read-only: ${_checkboxValues[i][1]}'),
                  Text('Hidden Field: ${_checkboxValues[i][2]}'),
                  const SizedBox(height: 10),
                ]
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Watermeter Quality Check',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          
          ElevatedButton(
            onPressed: _showResults,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Submit'),
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 237, 216, 241),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(children: _dynamicWidgets),
        ),
      ),
    );
  }
}
