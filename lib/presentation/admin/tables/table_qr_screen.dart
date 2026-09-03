import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/restaurant_table.dart';
import '../../../providers/table_provider.dart';
import 'package:uuid/uuid.dart';

class TableQRScreen extends ConsumerWidget {
  const TableQRScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tableState = ref.watch(tableProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Tables & QR Codes',
            style: GoogleFonts.poppins(
                color: Colors.white, fontWeight: FontWeight.w700)),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () => _showAddTableDialog(context, ref),
            icon: const Icon(Icons.add, color: Colors.white),
            tooltip: 'Add Table',
          ),
        ],
      ),
      body: tableState.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary))
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: tableState.tables.length,
              itemBuilder: (ctx, i) {
                final table = tableState.tables[i];
                return _TableQRCard(
                  table: table,
                  onToggle: () => ref
                      .read(tableProvider.notifier)
                      .toggleTableActive(table.id),
                  onViewQR: () => _showQRDialog(context, table),
                  onDelete: () => _confirmDelete(context, ref, table),
                );
              },
            ),
    );
  }

  void _showAddTableDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    int capacity = 4;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text('Add New Table',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Table Number',
                  prefixIcon: Icon(Icons.table_restaurant),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text('Capacity:',
                      style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                  const Spacer(),
                  DropdownButton<int>(
                    value: capacity,
                    items: [2, 4, 6, 8]
                        .map((v) => DropdownMenuItem(
                            value: v, child: Text('$v persons')))
                        .toList(),
                    onChanged: (v) =>
                        setState(() => capacity = v ?? 4),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                final num = controller.text.trim();
                if (num.isNotEmpty) {
                  ref.read(tableProvider.notifier).addTable(
                        RestaurantTable(
                          id: const Uuid().v4(),
                          number: num,
                          capacity: capacity,
                        ),
                      );
                  Navigator.pop(ctx);
                }
              },
              child: const Text('Add Table'),
            ),
          ],
        ),
      ),
    );
  }

  void _showQRDialog(BuildContext context, RestaurantTable table) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Table ${table.number} QR Code',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                'Customer scans this QR to order',
                style: GoogleFonts.inter(
                    fontSize: 13, color: AppColors.textHint),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 12,
                    )
                  ],
                ),
                child: QrImageView(
                  data: table.qrData,
                  version: QrVersions.auto,
                  size: 200,
                  foregroundColor: AppColors.primaryDark,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'QR Data: ${table.qrData}',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.textHint,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(ctx),
                icon: const Icon(Icons.close),
                label: const Text('Close'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 44),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(
      BuildContext context, WidgetRef ref, RestaurantTable table) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete Table ${table.number}?',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              ref
                  .read(tableProvider.notifier)
                  .deleteTable(table.id);
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _TableQRCard extends StatelessWidget {
  final RestaurantTable table;
  final VoidCallback onToggle;
  final VoidCallback onViewQR;
  final VoidCallback onDelete;

  const _TableQRCard({
    required this.table,
    required this.onToggle,
    required this.onViewQR,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
          )
        ],
        border: table.isActive
            ? null
            : Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          // QR Code preview
          GestureDetector(
            onTap: onViewQR,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: table.isActive
                    ? AppColors.primarySurface
                    : Colors.grey[100],
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16)),
              ),
              child: QrImageView(
                data: table.qrData,
                version: QrVersions.auto,
                size: 100,
                foregroundColor:
                    table.isActive ? AppColors.primaryDark : Colors.grey,
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Table ${table.number}',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: table.isActive
                              ? AppColors.textPrimary
                              : AppColors.textHint,
                        ),
                      ),
                      Switch.adaptive(
                        value: table.isActive,
                        onChanged: (_) => onToggle(),
                        activeColor: AppColors.primary,
                      ),
                    ],
                  ),
                  Text(
                    '${table.capacity} persons',
                    style: GoogleFonts.inter(
                        fontSize: 11, color: AppColors.textHint),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: onViewQR,
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primarySurface,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                'View QR',
                                style: GoogleFonts.inter(
                                  color: AppColors.primary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: onDelete,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.error.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.delete_outline,
                              color: AppColors.error, size: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
