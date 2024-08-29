import 'package:flutter/material.dart';
import 'status_page.dart';

class EnterNamesPage extends StatefulWidget {
  final int katiPoint;
  final int noOfPlayers;

  EnterNamesPage({required this.katiPoint, required this.noOfPlayers});

  @override
  _EnterNamesPageState createState() => _EnterNamesPageState();
}

class _EnterNamesPageState extends State<EnterNamesPage> {
  List<String> _players = [];
  final _playerControllers = <TextEditingController>[];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _players = List.generate(widget.noOfPlayers, (index) => '');
    _playerControllers.addAll(List.generate(
      widget.noOfPlayers,
      (index) => TextEditingController(),
    ));
  }

  void _navigateToStatusPage() {
    if (_players.any((player) => player.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter all player names'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    Future.delayed(Duration(seconds: 1), () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StatusPage(
            katiPoint: widget.katiPoint,
            players: _players,
            playerControllers: _playerControllers,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Player Names'),
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
                itemCount: widget.noOfPlayers,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: Colors.teal.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _playerControllers[index],
                        decoration: InputDecoration(
                          labelText: 'Player ${index + 1}',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _players[index] = value;
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            AnimatedOpacity(
              opacity: _isLoading ? 0.5 : 1.0,
              duration: Duration(milliseconds: 300),
              child: ElevatedButton(
                onPressed: _navigateToStatusPage,
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Next'),
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.teal), 
                  foregroundColor: WidgetStateProperty.all(Colors.white), 
                  padding: WidgetStateProperty.all(EdgeInsets.symmetric(vertical: 15)),
                  textStyle: WidgetStateProperty.all(TextStyle(fontSize: 16)),
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
