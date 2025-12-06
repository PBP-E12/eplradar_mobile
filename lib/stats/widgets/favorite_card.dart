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
    const placeholder =
        "https://upload.wikimedia.org/wikipedia/commons/a/a3/Image-not-found.png";

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF2B2C2F),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              widget.image.isNotEmpty ? widget.image : placeholder,
              width: 75,
              height: 75,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 14),

          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.club,
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
