import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme/app_colors.dart';
import '../../../providers/repository_providers.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../app/i18n/app_strings.dart';

class ExcelViewScreen extends ConsumerStatefulWidget {
  const ExcelViewScreen({super.key});

  @override
  ConsumerState<ExcelViewScreen> createState() => _ExcelViewScreenState();
}

class _ExcelViewScreenState extends ConsumerState<ExcelViewScreen> {
  Map<String, dynamic>? _excelData;
  bool _loading = true;
  String? _error;
  String _activeSheet = 'Income Statement';

  static const _sheets = ['Income Statement', 'Balance Sheet', 'Cash Flow', 'Ratios'];

  static const _sheetIcons = {
    'Income Statement': Icons.trending_up_rounded,
    'Balance Sheet': Icons.account_balance_rounded,
    'Cash Flow': Icons.water_drop_rounded,
    'Ratios': Icons.pie_chart_rounded,
  };

  static const _sheetColors = {
    'Income Statement': Color(0xFF3B82F6),
    'Balance Sheet': Color(0xFF10B981),
    'Cash Flow': Color(0xFFF59E0B),
    'Ratios': Color(0xFFA78BFA),
  };

  @override
  void initState() {
    super.initState();
    _loadExcelData();
  }

  Future<void> _loadExcelData() async {
    setState(() { _loading = true; _error = null; });
    try {
      final api = ref.read(apiClientProvider);
      final response = await api.get('/excel/direct');
      if (response['success'] == true) {
        setState(() {
          _excelData = response['data'] as Map<String, dynamic>;
          _loading = false;
        });
      } else {
        setState(() {
          _error = response['error'] as String? ?? 'Failed to load';
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Could not connect to Excel service';
        _loading = false;
      });
    }
  }

  Color get _activeColor => _sheetColors[_activeSheet] ?? const Color(0xFF3B82F6);

  int _getItemCount() {
    final sheetKey = _activeSheet.toLowerCase().replaceAll(' ', '_');
    final sheetData = _excelData?[sheetKey] ?? _excelData?['data'];
    if (sheetData is List) return sheetData.length;
    if (sheetData is Map) return sheetData.length;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.backgroundGradient(context)),
        child: SafeArea(
          child: Column(
            children: [
              // Decorative header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Row(
                  children: [
                    IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.pop()),
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _activeColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.table_chart_rounded, color: _activeColor, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Consumer(builder: (context, ref, _) {
                        final s = ref.watch(stringsProvider);
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              s.tr('Financial Data Explorer', 'مستكشف البيانات المالية'),
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary(context),
                              ),
                            ),
                            Text(
                              s.tr('Real-time spreadsheet insights', 'رؤى فورية من الجداول'),
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textTertiary(context),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: _activeColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.refresh_rounded, color: _activeColor),
                        onPressed: _loadExcelData,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn().slideX(begin: -0.05, end: 0),

              const SizedBox(height: 16),

              // Styled sheet tabs
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.cardColor(context),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: _sheets.map((sheet) {
                    final isActive = sheet == _activeSheet;
                    final color = _sheetColors[sheet] ?? const Color(0xFF3B82F6);
                    final icon = _sheetIcons[sheet] ?? Icons.table_chart_rounded;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _activeSheet = sheet),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            gradient: isActive
                                ? LinearGradient(
                                    colors: [
                                      color.withValues(alpha: 0.25),
                                      const Color(0xFFA78BFA).withValues(alpha: 0.15),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                : null,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                icon,
                                size: 16,
                                color: isActive ? color : AppColors.textTertiary(context),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                sheet.split(' ').first,
                                style: TextStyle(
                                  color: isActive ? color : AppColors.textTertiary(context),
                                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                                  fontSize: 11,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ).animate().fadeIn(delay: 100.ms).slideY(begin: -0.1, end: 0),

              // Summary bar
              if (!_loading && _error == null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 4),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 16,
                        decoration: BoxDecoration(
                          color: _activeColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _activeSheet,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary(context),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _activeColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${_getItemCount()} items',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _activeColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 200.ms),

              Expanded(
                child: _loading
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 48,
                              height: 48,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                color: _activeColor,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Loading financial data...',
                              style: TextStyle(
                                color: AppColors.textTertiary(context),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn()
                    : _error != null
                        ? _buildErrorState()
                        : _buildDataTable(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.dangerLight.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cloud_off_rounded,
                size: 40,
                color: AppColors.dangerLight,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Connection Issue',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary(context),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textTertiary(context),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _activeColor,
                    const Color(0xFFA78BFA),
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _loadExcelData,
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.refresh_rounded, color: Colors.white, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Try Again',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ).animate().fadeIn().scale(begin: const Offset(0.95, 0.95)),
      ),
    );
  }

  Widget _buildDataTable() {
    final sheetKey = _activeSheet.toLowerCase().replaceAll(' ', '_');
    final sheetData = _excelData?[sheetKey] ?? _excelData?['data'];

    if (sheetData == null) {
      return _buildEmptyState();
    }

    // Handle list of rows
    if (sheetData is List) {
      if (sheetData.isEmpty) return _buildEmptyState();
      return _buildFromList(sheetData);
    }

    // Handle map of key-value
    if (sheetData is Map) {
      return _buildFromMap(sheetData.cast<String, dynamic>());
    }

    return _buildEmptyState();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: _activeColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.inbox_rounded,
              size: 36,
              color: _activeColor.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No Data Available',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary(context),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'This sheet is currently empty',
            style: TextStyle(color: AppColors.textTertiary(context), fontSize: 13),
          ),
        ],
      ).animate().fadeIn().scale(begin: const Offset(0.95, 0.95)),
    );
  }

  Widget _buildFromList(List data) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final row = data[index];
        if (row is Map) {
          final entries = row.entries.toList();
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: _activeColor, width: 3),
                  ),
                ),
                child: GlassCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: entries.asMap().entries.map<Widget>((indexedEntry) {
                      final entryIndex = indexedEntry.key;
                      final entry = indexedEntry.value;
                      final isEven = entryIndex % 2 == 0;
                      return Container(
                        color: isEven
                            ? Colors.transparent
                            : _activeColor.withValues(alpha: 0.04),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 130,
                              child: Text(
                                '${entry.key}',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.textTertiary(context),
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _formatValue(entry.value),
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 12,
                                  color: _valueColor(entry.value),
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ).animate().fadeIn(delay: (50 * index).ms).slideX(begin: 0.03, end: 0);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildFromMap(Map<String, dynamic> data) {
    final entries = data.entries.toList();
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        final isEven = index % 2 == 0;
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: _activeColor, width: 3),
                ),
              ),
              child: GlassCard(
                padding: EdgeInsets.zero,
                child: Container(
                  color: isEven
                      ? Colors.transparent
                      : _activeColor.withValues(alpha: 0.04),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 140,
                        child: Text(
                          entry.key,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _formatValue(entry.value),
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 13,
                            color: _valueColor(entry.value),
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ).animate().fadeIn(delay: (40 * index).ms).slideX(begin: 0.03, end: 0);
      },
    );
  }

  String _formatValue(dynamic value) {
    if (value == null) return '-';
    if (value is num) {
      if (value.abs() >= 1000) return '\$${(value / 1000).toStringAsFixed(1)}k';
      return value.toStringAsFixed(value == value.toInt() ? 0 : 2);
    }
    return value.toString();
  }

  Color _valueColor(dynamic value) {
    if (value is num && value < 0) return AppColors.dangerLight;
    return AppColors.primaryLight;
  }
}
