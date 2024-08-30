import 'package:flutter/material.dart';
import 'enter_names_page.dart';

class EnterPointsPage extends StatefulWidget {
  @override
  _EnterPointsPageState createState() => _EnterPointsPageState();
}

class _EnterPointsPageState extends State<EnterPointsPage> {
  final TextEditingController _katiPointController = TextEditingController();
  final TextEditingController _noOfPlayersController = TextEditingController();
  bool _isLoading = false;

  void _navigateToEnterNamesPage() async {
    if (_katiPointController.text.isEmpty || _noOfPlayersController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter all fields'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

  
    await Future.delayed(Duration(seconds: 1));

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EnterNamesPage(
          katiPoint: int.tryParse(_katiPointController.text) ?? 0,
          noOfPlayers: int.tryParse(_noOfPlayersController.text) ?? 0,
        ),
      ),
    );

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Points and Player Count'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _katiPointController,
                decoration: InputDecoration(
                  labelText: 'Kati रु point?',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(height: 16.0),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _noOfPlayersController,
                decoration: InputDecoration(
                  labelText: 'Enter number of players',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _navigateToEnterNamesPage,
              child: _isLoading
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(color: Colors.white),
                        SizedBox(width: 10),
                        Text('Loading...'),
                      ],
                    )
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
          ],
        ),
      ),
    );
  }
}
