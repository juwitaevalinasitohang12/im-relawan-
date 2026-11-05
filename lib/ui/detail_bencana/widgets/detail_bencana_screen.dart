import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:im_relawan/ui/bencana/view_models/bencana_view_model.dart';

class DetailBencanaScreen extends ConsumerWidget {
  const DetailBencanaScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataBencanaList = ref.watch(bencanaViewModelProvider);
    // final bencanaId = int.tryParse(id); // hapus

    return Scaffold(
      body: dataBencanaList.maybeWhen(
        data: (list) {
          final matches = list.where((b) => b.id == id).toList();

          if (matches.isEmpty) {
            return const Center(child: Text('Data bencana tidak ditemukan'));
          }

          final bencana = matches.first;

          return Center(child: Text(bencana.name));
        },
        orElse: () => const Center(child: CircularProgressIndicator()),
      ),

      floatingActionButton: dataBencanaList.maybeWhen(
        data: (list) {
          final matches = list.where((b) => b.id == id).toList();

          if (matches.isEmpty) return null;

          final bencana = matches.first;

          return Semantics(
            label: 'Edit laporan bencana',
            button: true,
            child: FloatingActionButton(
              onPressed: () {
                context.pushNamed('edit', extra: bencana);
              },
              child: const Icon(Icons.edit),
            ),
          );
        },
        orElse: () => null,
      ),
    );
  }
}