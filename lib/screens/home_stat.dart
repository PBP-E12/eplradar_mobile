import 'dart:async';
import 'package:flutter/material.dart';
import '../stats/models/stats_model.dart';
import '../stats/screens/stats_home_screen.dart';

class HomeStat extends StatefulWidget {
  final Stats stats;

  const HomeStat({super.key, required this.stats});

  @override
  State<HomeStat> createState() => _HomeStatState();
}

class _HomeStatState extends State<HomeStat> {
  @override
  Widget build(BuildContext context) {
    const String domain = "https://raihan-maulana41-eplradar.pbp.cs.ui.ac.id";

    String resolveImage(String path) {
      if (path.startsWith("http")) {
        return path;
      }
      return "$domain$path";
    }

    final stats = widget.stats;

    final clubTopScorer = stats.club.topScorer.first;
    final clubTopAssist = stats.club.topAssist.first;
    final clubClean = stats.club.cleanSheet.first;

    final playerTopScorer = stats.player.topScorer.first;
    final playerTopAssist = stats.player.topAssist.first;
    final playerClean = stats.player.cleanSheet.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 4),
          child: Text(
            "Statistik",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 12),

        _MarqueeRow(
          items: [
            _clubItem(
              label: "Top Scorer Club",
              name: clubTopScorer.club,
              value: clubTopScorer.totalGoals,
              image: resolveImage(clubTopScorer.clubLogo),
            ),
            _clubItem(
              label: "Top Assist Club",
              name: clubTopAssist.club,
              value: clubTopAssist.totalAssists,
              image: resolveImage(clubTopAssist.clubLogo),
            ),
            _clubItem(
              label: "Clean Sheet Club",
              name: clubClean.club,
              value: clubClean.totalCleansheet,
              image: resolveImage(clubClean.clubLogo),
            ),
          ],
        ),

        const SizedBox(height: 16),

        _MarqueeRow(
          reverse: true,
          items: [
            _playerItem(
              label: "Top Scorer",
              name: playerTopScorer.name,
              value: playerTopScorer.goals,
              image: resolveImage(playerTopScorer.photo),
            ),
            _playerItem(
              label: "Top Assist",
              name: playerTopAssist.name,
              value: playerTopAssist.assists,
              image: resolveImage(playerTopAssist.photo),
            ),
            _playerItem(
              label: "Clean Sheet",
              name: playerClean.name,
              value: playerClean.cleanSheet,
              image: resolveImage(playerClean.photo),
            ),
          ],
        ),

        Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StatsHomeScreen(),
                  ),
                );
              },
              child: const Text("Lihat Statistik Lengkap"),
            ),
          ),
      ],
    );
  }
}

class _MarqueeRow extends StatefulWidget {
  final List<Widget> items;
  final bool reverse;

  const _MarqueeRow({required this.items, this.reverse = false});

  @override
  State<_MarqueeRow> createState() => _MarqueeRowState();
}

class _MarqueeRowState extends State<_MarqueeRow> {
  final ScrollController _controller = ScrollController();
  Timer? _timer;

  late final List<Widget> loopItems;

  @override
  void initState() {
    super.initState();
    loopItems = [...widget.items, ...widget.items, ...widget.items];
    WidgetsBinding.instance.addPostFrameCallback((_) => _start());
  }

  void _start() {
    _timer = Timer.periodic(const Duration(milliseconds: 30), (_) {
      if (!_controller.hasClients) return;

      final max = _controller.position.maxScrollExtent;
      final min = _controller.position.minScrollExtent;

      double offset = _controller.offset + (widget.reverse ? -1 : 1);

      if (offset >= max || offset <= min) {
        offset = max / 2; 
      }

      _controller.jumpTo(offset);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 86,
      child: ListView.separated(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: loopItems.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (_, i) => loopItems[i],
      ),
    );
  }
}

Widget _clubItem({
  required String label,
  required String name,
  required int value,
  required String image,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      color: const Color(0xFF333438), 
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        ClipRRect(
          child: Image.network(
            image,
            width: 50,
            height: 50,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Image.network(
                "https://upload.wikimedia.org/wikipedia/commons/a/a3/Image-not-found.png",
                width: 50,
                height: 50,
                fit: BoxFit.contain,
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 15),
            ),
            Text(
              "$name  |  $value",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _playerItem({
  required String label,
  required String name,
  required int value,
  required String image,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      color: const Color(0xFF333438), 
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        ClipRRect(
          child: Image.network(
            image,
            width: 50,
            height: 50,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Image.network(
                "https://upload.wikimedia.org/wikipedia/commons/a/a3/Image-not-found.png",
                width: 50,
                height: 50,
                fit: BoxFit.contain,
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 15),
            ),
            Text(
              "$name  |  $value",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
