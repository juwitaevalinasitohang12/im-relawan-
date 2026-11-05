import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:im_relawan/domain/models/bencana_list.dart';
import 'package:im_relawan/ui/bencana/view_models/bencana_view_model.dart';
import 'package:im_relawan/ui/core/themes/app_colors.dart';

class DaftarBencanaScreen extends ConsumerStatefulWidget {
  const DaftarBencanaScreen({super.key});

  @override
  ConsumerState<DaftarBencanaScreen> createState() =>
      _DaftarBencanaScreenState();
}

class _DaftarBencanaScreenState extends ConsumerState<DaftarBencanaScreen> {
  @override
  Widget build(BuildContext context) {
    final dataBencanaList = ref.watch(bencanaViewModelProvider);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 252, 244, 244),

      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 252, 244, 244),
        centerTitle: true,
        title: Text(
          'Daftar Bencana',
          style: Theme.of(context).textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
          child: Column(
            children: [
              // SEARCH DAN FILTER
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 55,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 1,
                            offset: const Offset(1, 1),
                            color: Colors.black.withAlpha(50),
                          ),
                        ],
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Type name or address...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Semantics(
                    label: 'Filter',
                    hint: 'Tombol filter daftar bencana',
                    button: true,
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        height: 55,
                        width: 55,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 1,
                              offset: const Offset(1, 1),
                              color: Colors.black.withAlpha(50),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.settings),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // DAFTAR BENCANA
              Expanded(
                child: dataBencanaList.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),

                  error: (error, stackTrace) => Center(
                    child: Text(
                      'Gagal memuat data: $error',
                      textAlign: TextAlign.center,
                    ),
                  ),

                  data: (data) {
                    if (data.isEmpty) {
                      return const Center(
                        child: Text('Belum ada data bencana'),
                      );
                    }

                    return ListView.builder(
                      // ruang agar card terakhir tidak tertutup FAB
                      padding: const EdgeInsets.only(bottom: 80),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final dataBencana = data[index];

                        return Dismissible(
                          key: ValueKey(dataBencana.id),
                          direction: DismissDirection.endToStart,

                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 24),
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.error,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Semantics(
                              label: 'Hapus laporan',
                              child: Icon(
                                Icons.delete,
                                color: Theme.of(context).colorScheme.onError,
                              ),
                            ),
                          ),

                          confirmDismiss: (direction) async {
                            final konfirmasi = await showDialog<bool>(
                              context: context,
                              builder: (dialogContext) => AlertDialog(
                                title: const Text('Hapus laporan?'),
                                content: Text(
                                  'Laporan "${dataBencana.name}" akan dihapus.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(dialogContext, false),
                                    child: const Text('Batal'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(dialogContext, true),
                                    child: const Text('Hapus'),
                                  ),
                                ],
                              ),
                            );

                            // Hapus data di sini (seperti materi), sehingga
                            // kartu hanya hilang bila penghapusan berhasil.
                            if (konfirmasi == true) {
                              final berhasil = await ref
                                  .read(bencanaViewModelProvider.notifier)
                                  .deleteBencana(dataBencana.id!);

                              if (!berhasil && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Gagal menghapus data bencana',
                                    ),
                                  ),
                                );
                              }
                              return berhasil;
                            }
                            return false;
                          },

                          onDismissed: (direction) {},

                          child: DataBencanaCard(
                            dataBencana: dataBencana,
                            onTap: () {
                              context.goNamed(
                                'detail',
                                pathParameters: {'id': dataBencana.id!},
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      // TOMBOL TAMBAH LAPORAN (sebelumnya tidak ada)
      floatingActionButton: Semantics(
        label: 'Tambah laporan bencana baru',
        button: true,
        child: FloatingActionButton(
          onPressed: () => context.goNamed('tambah'),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

// =====================================================
// CARD DATA BENCANA
// =====================================================

class DataBencanaCard extends StatelessWidget {
  const DataBencanaCard({
    super.key,
    required this.dataBencana,
    required this.onTap,
  });

  final BencanaList dataBencana;
  final VoidCallback onTap;

  // "2026-09-21T20:59:30.362823" -> "2026-09-21 20:59"
  String _formatTanggal(String iso) {
    final dt = DateTime.tryParse(iso);
    if (dt == null) return iso;
    String d(int n) => n.toString().padLeft(2, '0');
    return '${dt.year}-${d(dt.month)}-${d(dt.day)} ${d(dt.hour)}:${d(dt.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      color: scheme.primaryContainer,
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // ICON BENCANA
              Expanded(
                flex: 1,
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: Icon(
                    Icons.local_fire_department,
                    color: scheme.primary,
                    size: 45,
                  ),
                ),
              ),

              const SizedBox(width: 14),

              // INFORMASI BENCANA
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            dataBencana.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Icon(Icons.star, size: 20, color: AppColor.gold),
                      ],
                    ),
                    Divider(
                      color: Colors.grey.withAlpha(100),
                      thickness: 0.5,
                      height: 10,
                    ),
                    Text(
                      _formatTanggal(dataBencana.createdAt),
                      style: textTheme.bodySmall,
                    ),
                    Text(
                      dataBencana.location,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
