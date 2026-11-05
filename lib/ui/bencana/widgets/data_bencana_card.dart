import 'package:flutter/material.dart';
import 'package:im_relawan/domain/models/bencana_list.dart';

class DataBencanaCard extends StatelessWidget {
  const DataBencanaCard({super.key, required this.dataBencana, this.onTap});

  final BencanaList dataBencana;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: const Color.fromARGB(255, 255, 216, 210),
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.local_fire_department,
                    size: 40,
                    color: Color.fromARGB(255, 120, 40, 30),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              dataBencana.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                        ],
                      ),
                      const Divider(height: 12),
                      Text(
                        dataBencana.createdAt,
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        dataBencana.location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}