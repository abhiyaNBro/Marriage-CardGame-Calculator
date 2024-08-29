import 'package:flutter/material.dart';

class ResultsPage extends StatelessWidget {
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
  Widget build(BuildContext context) {
   
    final totalMaal = playerMaal.values.fold(0, (sum, value) => sum + value);
    final seenPlayers = seenStatus.entries.where((entry) => entry.value == 'Yes').map((entry) => players[entry.key]).toList();
    final unseenPlayers = seenStatus.entries.where((entry) => entry.value == 'No').map((entry) => players[entry.key]).toList();

    String? winner = selectedWinner;
    if (winner == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Results'),
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: Text('No winner selected.'),
        ),
      );
    }

    final winnerIndex = players.indexOf(winner);

   
    double calculateWinnerResult() {
      final toReceive = players.length * playerMaal[winnerIndex]!.toDouble();
      final toPay = totalMaal.toDouble();
      final gt = toReceive - toPay + (3 * (seenPlayers.length - 1).toDouble()) + (10 * unseenPlayers.length.toDouble());
      return gt * katiPoint.toDouble();
    }

    Map<String, double> calculateSeenResults() {
      final results = <String, double>{};
      for (var i = 0; i < players.length; i++) {
        if (seenStatus[i] == 'Yes' && players[i] != winner) {
          final toReceive = playerMaal[i]!.toDouble() * players.length.toDouble();
          final toPay = totalMaal.toDouble() + 3.0;
          final gt = toReceive - toPay;
          results[players[i]] = gt * katiPoint.toDouble();
        }
      }
      return results;
    }

    Map<String, double> calculateUnseenResults() {
      final results = <String, double>{};
      for (var i = 0; i < players.length; i++) {
        if (seenStatus[i] == 'No') {
          final toPay = totalMaal.toDouble() + 10.0;
          final gt = -toPay;
          results[players[i]] = gt * katiPoint.toDouble();
        }
      }
      return results;
    }

    final winnerResult = calculateWinnerResult();
    final seenResults = calculateSeenResults();
    final unseenResults = calculateUnseenResults();

    return Scaffold(
      appBar: AppBar(
        title: Text('Results'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildSectionTitle(context, 'Results:', Colors.black),
            _buildResultCard(
              context,
              '$winner: ${winnerResult.toStringAsFixed(2)}',
              Colors.green,
            ),
            SizedBox(height: 16),
            _buildSectionTitle(context, 'Seen Players Results:', Colors.black),
            ...seenResults.entries.map((entry) =>
              _buildResultCard(context, '${entry.key}: ${entry.value.toStringAsFixed(2)}', Colors.blue)
            ),
            SizedBox(height: 16),
            _buildSectionTitle(context, 'Unseen Players Results:', Colors.black),
            ...unseenResults.entries.map((entry) =>
              _buildResultCard(context, '${entry.key}: ${entry.value.toStringAsFixed(2)}', Colors.red)
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                },
                child: Text('New Game?'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  textStyle: TextStyle(fontSize: 16),
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, Color color) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildResultCard(BuildContext context, String result, Color color) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.5),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        result,
        style: TextStyle(
          color: color,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
