import 'package:flutter/material.dart';

class ResultsPage extends StatefulWidget {
  final int katiPoint;
  final List<String> players;
  final Map<int, int> playerMaal;
  final Map<int, String> seenStatus;
  final String? selectedWinner;

  ResultsPage({
    required this.katiPoint,
    required this.players,
    required this.playerMaal,
    required this.seenStatus,
    required this.selectedWinner,
  });

  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _startAnimationSequence();
  }

  void _startAnimationSequence() async {
    await Future.delayed(Duration(milliseconds: 100));
    _controller.forward();
    await Future.delayed(Duration(milliseconds: 300));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final totalMaal = widget.playerMaal.values.fold(0, (sum, value) => sum + value);
    final seenPlayers = widget.seenStatus.entries
        .where((entry) => entry.value == 'Yes')
        .map((entry) => widget.players[entry.key])
        .toList();
    final unseenPlayers = widget.seenStatus.entries
        .where((entry) => entry.value == 'No')
        .map((entry) => widget.players[entry.key])
        .toList();

    String? winner = widget.selectedWinner;
    if (winner == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Winner'),
          backgroundColor: Colors.blueAccent,
        ),
        body: Center(
          child: Text('No winner selected.'),
        ),
      );
    }

    final winnerIndex = widget.players.indexOf(winner);

    double calculateWinnerResult() {
      final toReceive = widget.playerMaal[winnerIndex]!.toDouble() * widget.players.length.toDouble();
      final toPay = totalMaal.toDouble();
      final gt = toReceive - toPay + (3 * (seenPlayers.length - 1).toDouble()) + (10 * unseenPlayers.length.toDouble());
      return gt * widget.katiPoint.toDouble();
    }

    Map<String, double> calculateSeenResults() {
      final results = <String, double>{};
      for (var i = 0; i < widget.players.length; i++) {
        if (widget.seenStatus[i] == 'Yes' && widget.players[i] != winner) {
          final toReceive = widget.playerMaal[i]!.toDouble() * widget.players.length.toDouble();
          final toPay = totalMaal.toDouble() + 3.0;  
          final gt = toReceive - toPay;
          results[widget.players[i]] = gt * widget.katiPoint.toDouble();
        }
      }
      return results;
    }

    Map<String, double> calculateUnseenResults() {
      final results = <String, double>{};
      for (var i = 0; i < widget.players.length; i++) {
        if (widget.seenStatus[i] == 'No') {
          final toPay = totalMaal.toDouble() + 10.0;  
          final gt = -toPay;
          results[widget.players[i]] = gt * widget.katiPoint.toDouble();
        }
      }
      return results;
    }

    final winnerResult = calculateWinnerResult();
    final seenResults = calculateSeenResults();
    final unseenResults = calculateUnseenResults();

    return Scaffold(
      appBar: AppBar(
        title: Text('Winner'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildSectionTitle(context, 'Winner:', Colors.black),
                  _buildResultCard(
                    context,
                    '$winner: ${winnerResult.toStringAsFixed(2)}',
                    Colors.green,
                  ),
                  SizedBox(height: 16),
                  FadeTransition(
                    opacity: _animation,
                    child: _buildSectionTitle(context, 'Seen Players Results:', Colors.black),
                  ),
                  ...seenResults.entries.map((entry) =>
                      FadeTransition(
                        opacity: _animation,
                        child: _buildResultCard(context, '${entry.key}: ${entry.value.toStringAsFixed(2)}', Colors.blue),
                      )),
                  SizedBox(height: 16),
                  FadeTransition(
                    opacity: _animation,
                    child: _buildSectionTitle(context, 'Unseen Players Results:', Colors.black),
                  ),
                  ...unseenResults.entries.map((entry) =>
                      FadeTransition(
                        opacity: _animation,
                        child: _buildResultCard(context, '${entry.key}: ${entry.value.toStringAsFixed(2)}', Colors.red),
                      )),
                ],
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  context,
                  'New Game',
                  Colors.blueAccent,
                  () {
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                  },
                ),
                _buildActionButton(
                  context,
                  'Replay',
                  Colors.orange,
                  () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8), 
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(  
              color: color,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildResultCard(BuildContext context, String result, Color color) {
    return Card(
      elevation: 4,  
      margin: EdgeInsets.symmetric(vertical: 4),  
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),  
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),  
        tileColor: color.withOpacity(0.1),
        leading: Icon(Icons.star, color: color, size: 20),  
        title: Text(
          result,
          style: TextStyle(
            color: color,
            fontSize: 14,  
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, String label, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),  
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 6,
      ),
    );
  }
}
