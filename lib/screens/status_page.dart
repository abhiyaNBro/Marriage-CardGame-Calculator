import 'package:flutter/material.dart';
import 'results_page.dart';

class StatusPage extends StatefulWidget {
  final int katiPoint;
  final List<String> players;
  final List<TextEditingController> playerControllers;

  StatusPage({
    required this.katiPoint,
    required this.players,
    required this.playerControllers,
  });

  @override
  _StatusPageState createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  Map<int, String> _seenStatus = {};
  Map<int, int> _playerMaal = {};
  String? _selectedWinner;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _seenStatus = {for (var i = 0; i < widget.players.length; i++) i: 'Yes'};
    _playerMaal = {for (var i = 0; i < widget.players.length; i++) i: 0};
  }

  List<String> _getVisiblePlayers() {
    return widget.players
        .asMap()
        .entries
        .where((entry) => _seenStatus[entry.key] == 'Yes')
        .map((entry) => entry.value)
        .toList();
  }

  void _navigateToResultsPage() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(Duration(seconds: 1), () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultsPage(
            katiPoint: widget.katiPoint,
            players: widget.players,
            playerMaal: _playerMaal,
            seenStatus: _seenStatus,
            selectedWinner: _selectedWinner,
          ),
        ),
      ).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Player Status and Maal'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.players.length,
                itemBuilder: (context, index) {
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.players[index],
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  color: Colors.teal,
                                  fontWeight: FontWeight.bold,
                                ),
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
                          AnimatedOpacity(
                            opacity: _seenStatus[index] == 'Yes' ? 1.0 : 0.5,
                            duration: Duration(milliseconds: 300),
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: 'Maal',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  _playerMaal[index] = int.tryParse(value) ?? 0;
                                });
                              },
                              enabled: _seenStatus[index] == 'Yes',
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Select Winner:',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: 10),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.teal, width: 1),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedWinner,
                  hint: Text('Choose winner'),
                  isExpanded: true,
                  items: _getVisiblePlayers().map((player) {
                    return DropdownMenuItem<String>(
                      value: player,
                      child: Row(
                        children: [
                          Icon(Icons.person, color: Colors.teal),
                          SizedBox(width: 10),
                          Text(player),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedWinner = value;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 16.0),
            AnimatedOpacity(
              opacity: _isLoading ? 0.5 : 1.0,
              duration: Duration(milliseconds: 300),
              child: ElevatedButton(
                onPressed: _isLoading ? null : _navigateToResultsPage,
                child: Text('Calculate Results'),
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.teal),
                  foregroundColor: WidgetStateProperty.all(Colors.white),
                  padding: WidgetStateProperty.all(EdgeInsets.symmetric(vertical: 15)),
                  textStyle: WidgetStateProperty.all(TextStyle(fontSize: 16)),
                  minimumSize: WidgetStateProperty.all(Size(150, 0)),
                  shape: WidgetStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
