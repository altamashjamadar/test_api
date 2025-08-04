import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tic Tac Toe',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF6200EE),
          secondary: Color(0xFFFF9800),
        ),
        fontFamily: 'Roboto',
      ),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  // Game state
  List<List<String?>> board = List.generate(3, (i) => List.generate(3, (j) => null));
  String currentPlayer = 'X';
  bool gameOver = false;
  String? winner;
  List<List<int>>? winningCells; // Store winning positions for animation

  // Handle cell tap
  void makeMove(int row, int col) {
    if (board[row][col] != null || gameOver) return;

    setState(() {
      board[row][col] = currentPlayer;

      if (checkWinner()) {
        winner = currentPlayer;
        gameOver = true;
        winningCells = getWinningLine();
      } else if (isBoardFull()) {
        gameOver = true;
        winner = null;
      } else {
        currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
      }
    });
  }

  bool checkWinner() {
    var b = board;

    for (int i = 0; i < 3; i++) {
      if (b[i][0] == b[i][1] && b[i][1] == b[i][2] && b[i][0] != null) return true;
    }

    for (int j = 0; j < 3; j++) {
      if (b[0][j] == b[1][j] && b[1][j] == b[2][j] && b[0][j] != null) return true;
    }

    if (b[0][0] == b[1][1] && b[1][1] == b[2][2] && b[0][0] != null) return true;
    if (b[0][2] == b[1][1] && b[1][1] == b[2][0] && b[0][2] != null) return true;

    return false;
  }

 
  List<List<int>> getWinningLine() {
    var b = board;

    for (int i = 0; i < 3; i++) {
      if (b[i][0] == b[i][1] && b[i][1] == b[i][2] && b[i][0] != null) {
        return [[i, 0], [i, 1], [i, 2]];
      }
    }

    // Columns
    for (int j = 0; j < 3; j++) {
      if (b[0][j] == b[1][j] && b[1][j] == b[2][j] && b[0][j] != null) {
        return [[0, j], [1, j], [2, j]];
      }
    }

    // Diagonals
    if (b[0][0] == b[1][1] && b[1][1] == b[2][2] && b[0][0] != null) {
      return [[0, 0], [1, 1], [2, 2]];
    }
    if (b[0][2] == b[1][1] && b[1][1] == b[2][0] && b[0][2] != null) {
      return [[0, 2], [1, 1], [2, 0]];
    }

    return [];
  }

  // Check if board is full
  bool isBoardFull() {
    return board.every((row) => row.every((cell) => cell != null));
  }

  // Reset game
  void resetGame() {
    setState(() {
   List<List<String?>> board = List.generate(
  3,
  (i) => List.generate(3, (j) => null),
);

      currentPlayer = 'X';
      winner = null;
      gameOver = false;
      winningCells = null;
    });
  }

  Color getPlayerColor(String player) {
    return player == 'X' ? Colors.deepPurple : Colors.teal;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFC),
      appBar: AppBar(
        title: const Text(
          'Tic Tac Toe',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // Status Indicator
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              decoration: BoxDecoration(
                color: gameOver
                    ? (winner != null ? Colors.green.withOpacity(0.15) : Colors.orange.withOpacity(0.15))
                    : Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: gameOver
                      ? (winner != null ? Colors.green : Colors.orange)
                      : Colors.blue,
                  width: 2,
                ),
              ),
              child: Text(
                gameOver
                    ? (winner != null ? '🎉 Winner: $winner!' : '🟰 It’s a Draw!')
                    : '🎮 Player $currentPlayer’s Turn',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: gameOver
                      ? (winner != null ? Colors.green[800] : Colors.orange[700])
                      : Colors.blue[700],
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: 300,
              height: 300,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemCount: 9,
                itemBuilder: (context, index) {
                  int row = index ~/ 3;
                  int col = index % 3;
                  String? value = board[row][col];
                  bool isWinningCell = winningCells?.any((cell) => cell[0] == row && cell[1] == col) ?? false;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: isWinningCell ? Colors.yellow[100] : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: isWinningCell
                          ? Border.all(color: getPlayerColor(value!), width: 3)
                          : null,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.25),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => makeMove(row, col),
                        borderRadius: BorderRadius.circular(12),
                        child: Center(
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: value != null ? getPlayerColor(value) : Colors.grey,
                              shadows: isWinningCell
                                  ? [
                                      const Shadow(
                                        blurRadius: 10,
                                        color: Colors.yellow,
                                        offset: Offset(0, 0),
                                      )
                                    ]
                                  : null,
                            ),
                            child: Text(value ?? ''),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton.icon(
              onPressed: resetGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 4,
              ),
              icon: const Icon(Icons.refresh, size: 20),
              label: const Text(
                'Restart Game',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}