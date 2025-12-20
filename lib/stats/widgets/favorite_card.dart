import 'package:flutter/material.dart';

class FavoriteCard extends StatefulWidget {
  final String image;
  final String name;
  final String club;
  final String initialReason;
  final Function(String) onSave;
  final VoidCallback onDelete;

  const FavoriteCard({
    super.key,
    required this.image,
    required this.name,
    required this.club,
    required this.initialReason,
    required this.onSave,
    required this.onDelete,
  });

  @override
  State<FavoriteCard> createState() => _FavoriteCardState();
}

class _FavoriteCardState extends State<FavoriteCard> {
  late TextEditingController reasonCtrl;
  bool changed = false;
  bool saved = false;

  @override
  void initState() {
    super.initState();
    reasonCtrl = TextEditingController(text: widget.initialReason);
  }

  @override
  Widget build(BuildContext context) {
    const String domain = "https://raihan-maulana41-eplradar.pbp.cs.ui.ac.id";

    const String placeholder =
        "https://upload.wikimedia.org/wikipedia/commons/a/a3/Image-not-found.png";

    String resolveImage(String path) {
      if (path.isEmpty) return placeholder;
      if (path.startsWith("http")) return path;
      if (path.startsWith("/")) return "$domain$path";
      return "$domain/$path";
    }

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF2B2C2F),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              resolveImage(widget.image),
              width: 75,
              height: 75,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.network(
                  placeholder,
                  width: 75,
                  height: 75,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.club,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 10),

                TextField(
                  controller: reasonCtrl,
                  maxLength: 150,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Note (max 150 karakter)",
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: const Color(0xFF3A3B3E),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    counterText: "",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (_) {
                    setState(() {
                      changed = true;
                      saved = false;
                    });
                  },
                ),

                if (changed)
                  TextButton(
                    onPressed: () async {
                      await widget.onSave(reasonCtrl.text);
                      setState(() {
                        changed = false;
                        saved = true;
                      });
                    },
                    child: const Text("Save"),
                  ),

                if (saved)
                  const Text(
                    "Berhasil disimpan!",
                    style: TextStyle(color: Colors.green, fontSize: 12),
                  ),
              ],
            ),
          ),

          IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent),
            onPressed: widget.onDelete,
          ),
        ],
      ),
    );
  }
}
