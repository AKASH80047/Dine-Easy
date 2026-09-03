import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/table_provider.dart';

class TableSelectScreen extends ConsumerStatefulWidget {
  const TableSelectScreen({super.key});

  @override
  ConsumerState<TableSelectScreen> createState() => _TableSelectScreenState();
}

class _TableSelectScreenState extends ConsumerState<TableSelectScreen> {
  final _controller = TextEditingController();
  bool _showScanner = false;
  bool _isScanning = false;
  MobileScannerController? _scannerController;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    _scannerController?.dispose();
    super.dispose();
  }

  void _openScanner() {
    setState(() {
      _showScanner = true;
      _isScanning = true;
      _scannerController = MobileScannerController();
    });
  }

  void _closeScanner() {
    _scannerController?.dispose();
    setState(() {
      _showScanner = false;
      _isScanning = false;
      _scannerController = null;
    });
  }

  void _onBarcodeDetected(BarcodeCapture capture) {
    if (!_isScanning) return;
    final barcode = capture.barcodes.firstOrNull;
    if (barcode?.rawValue == null) return;

    final raw = barcode!.rawValue!;
    _isScanning = false;

    // Parse TABLE_3 or just "3"
    String? tableNum;
    if (raw.toUpperCase().startsWith('TABLE_')) {
      tableNum = raw.substring(6);
    } else if (int.tryParse(raw.trim()) != null) {
      tableNum = raw.trim();
    }

    if (tableNum != null && tableNum.isNotEmpty) {
      _closeScanner();
      _setTableAndNavigate(tableNum);
    } else {
      setState(() {
        _error = 'Invalid QR. Please scan the correct table QR.';
        _isScanning = true;
      });
    }
  }

  void _setTableManually() {
    final num = _controller.text.trim();
    if (num.isEmpty) {
      setState(() => _error = 'Please enter a table number');
      return;
    }
    if (int.tryParse(num) == null) {
      setState(() => _error = 'Enter a valid number');
      return;
    }
    _setTableAndNavigate(num);
  }

  void _setTableAndNavigate(String tableNumber) {
    ref.read(tableProvider.notifier).selectTable(tableNumber);
    ref.read(cartProvider.notifier).setTableNumber(tableNumber);
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
          ),

          // Content
          SafeArea(
            child: _showScanner
                ? _buildScannerView()
                : _buildSelectionView(),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionView() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),

            // Logo
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                  )
                ],
              ),
              child: const Center(
                child: Text('🍔', style: TextStyle(fontSize: 44)),
              ),
            ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),

            const SizedBox(height: 20),

            Text(
              'Welcome to',
              style: GoogleFonts.inter(
                color: Colors.white70,
                fontSize: 16,
              ),
            ).animate().fade(delay: 200.ms),

            Text(
              'Pandey Foods',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w800,
              ),
            ).animate().fade(delay: 300.ms).slideY(begin: 0.2, delay: 300.ms),

            const SizedBox(height: 40),

            // White Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '📍 Select Your Table',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    'Scan the QR on your table or enter the number',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // QR Scan Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _openScanner,
                      icon: const Icon(Icons.qr_code_scanner, size: 22),
                      label: Text(
                        'Scan Table QR Code',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'OR',
                          style: GoogleFonts.inter(
                            color: AppColors.textHint,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Manual Entry
                  TextField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      labelText: 'Table Number',
                      hintText: 'e.g. 5',
                      prefixIcon: const Icon(Icons.table_restaurant,
                          color: AppColors.primary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: AppColors.primary, width: 2),
                      ),
                      errorText: _error,
                    ),
                    onChanged: (_) => setState(() => _error = null),
                    onSubmitted: (_) => _setTableManually(),
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: _setTableManually,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(
                            color: AppColors.primary, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        'Continue to Menu →',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().slideY(begin: 0.3, delay: 400.ms, duration: 500.ms).fade(delay: 400.ms),

            const SizedBox(height: 24),

            // Admin Access
            TextButton.icon(
              onPressed: () => context.go('/admin'),
              icon: const Icon(Icons.admin_panel_settings,
                  color: Colors.white60, size: 16),
              label: Text(
                'Admin Panel',
                style: GoogleFonts.inter(
                  color: Colors.white60,
                  fontSize: 13,
                ),
              ),
            ).animate().fade(delay: 700.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildScannerView() {
    return Stack(
      children: [
        // Scanner
        MobileScanner(
          controller: _scannerController!,
          onDetect: _onBarcodeDetected,
        ),

        // Overlay
        Container(
          color: Colors.black.withOpacity(0.5),
          child: Stack(
            children: [
              // Transparent cutout area (visual guide only)
              Center(
                child: Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: AppColors.accent, width: 3),
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.transparent,
                  ),
                ),
              ),

              // Top back button
              Positioned(
                top: 16,
                left: 16,
                child: IconButton(
                  onPressed: _closeScanner,
                  icon: const Icon(Icons.arrow_back,
                      color: Colors.white, size: 28),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black45,
                  ),
                ),
              ),

              // Instructions
              Positioned(
                bottom: 80,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Text(
                      'Point camera at the table QR code',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _error!,
                          style: GoogleFonts.inter(
                              color: Colors.white, fontSize: 13),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
