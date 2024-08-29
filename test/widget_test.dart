import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game Points Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GameHomePage(),
    );
  }
}

class GameHomePage extends StatefulWidget {
  @override
  _GameHomePageState createState() => _GameHomePageState();
}

class _GameHomePageState extends State<GameHomePage> {
  final TextEditingController _katiPointController = TextEditingController();
  final TextEditingController _noOfPlayersController = TextEditingController();
  List<String> _players = [];
  Map<int, String> _seenStatus = {};
  Map<int, int> _playerMaal = {};
  bool _isStarted = false;
  bool _isResultsVisible = false;
  String _result = '';

  void _startGame() {
    final int noOfPlayers = int.tryParse(_noOfPlayersController.text) ?? 0;
    setState(() {
      _players = List.generate(noOfPlayers, (index) => '');
      _seenStatus = {for (var i = 0; i < noOfPlayers; i++) i: ''};
      _playerMaal = {for (var i = 0; i < noOfPlayers; i++) i: 0};
      _isStarted = true;
      _isResultsVisible = false;
      _result = '';
    });
  }

  void _calculateResults() {
    // Add your calculation logic here

    setState(() {
      _result = 'Results go here...'; // Replace with actual result
      _isResultsVisible = true;
    });
  }

  void _restartGame() {
    setState(() {
      _isStarted = false;
      _isResultsVisible = false;
      _katiPointController.clear();
      _noOfPlayersController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game Points Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!_isStarted)
              Column(
                children: [
                  TextField(
                    controller: _katiPointController,
                    decoration: InputDecoration(labelText: 'How much Point game'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: _noOfPlayersController,
                    decoration: InputDecoration(labelText: 'Enter number of players'),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _startGame,
                    child: Text('Start'),
                  ),
                ],
              ),
            if (_isStarted)
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: _players.length,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextField(
                                    decoration: InputDecoration(labelText: 'Player ${index + 1}'),
                                    onChanged: (value) {
                                      setState(() {
                                        _players[index] = value;
                                      });
                                    },
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ListTile(
                                          title: Text('Seen'),
                                          leading: Radio<String>(
                                            value: 'Yes',
                                            groupValue: _seenStatus[index],
                                            onChanged: (value) {
                                              setState(() {
                                                _seenStatus[index] = value!;
                                                if (value == 'No') {
                                                  _playerMaal[index] = 0;
                                                }
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: ListTile(
                                          title: Text('Unseen'),
                                          leading: Radio<String>(
                                            value: 'No',
                                            groupValue: _seenStatus[index],
                                            onChanged: (value) {
                                              setState(() {
                                                _seenStatus[index] = value!;
                                                _playerMaal[index] = 0;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  TextField(
                                    decoration: InputDecoration(labelText: 'Maal'),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      setState(() {
                                        _playerMaal[index] = int.tryParse(value) ?? 0;
                                      });
                                    },
                                    enabled: _seenStatus[index] == 'Yes',
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _calculateResults,
                      child: Text('Submit'),
                    ),
                    if (_isResultsVisible) 
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Results:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            Text(_result),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _restartGame,
                              child: Text('Start Again'),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

