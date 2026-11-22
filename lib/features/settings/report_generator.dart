import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../shared/models/cycle.dart';
import '../../shared/models/lunora_state.dart';
import '../../shared/models/symptom_catalog.dart';
import '../cycle/cycle_stats.dart';

import 'package:lunora/l10n/app_localizations.dart';

/// Generates a doctor-ready PDF report.
///
/// Rules:
///  - Descriptive only. No interpretations, no recommendations.
///  - No ovulation prediction, no fertile window, no likely-window band.
///  - Includes medical disclaimer on every page footer.
class ReportGenerator {
  ReportGenerator._();

  static const _disclaimer = 'Lunora is a tracking tool, not a medical device. '
      'This report is for discussion with a clinician and is not a diagnosis. '
      'Cycle ranges shown are descriptive statistics of user-logged data. '
      'Lunora does not predict ovulation, fertile windows, or future period dates.';

  static Future<void> generateAndShare({
    required LunoraState state,
    required int windowDays,
    required LunoraLocalizations l10n,
  }) async {
    final bytes = await _buildPdf(
      state: state,
      windowDays: windowDays,
      l10n: l10n,
    );
    await Printing.sharePdf(
      bytes: bytes,
      filename:
          'lunora-report-${windowDays}d-${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
  }

  static Future<void> preview({
    required LunoraState state,
    required int windowDays,
    required LunoraLocalizations l10n,
  }) async {
    await Printing.layoutPdf(
      onLayout: (_) => _buildPdf(
        state: state,
        windowDays: windowDays,
        l10n: l10n,
      ),
    );
  }

  static Future<Uint8List> _buildPdf({
    required LunoraState state,
    required int windowDays,
    required LunoraLocalizations l10n,
  }) async {
    final cutoff = DateTime.now().subtract(Duration(days: windowDays));
    bool inWindow(String date) {
      final d = DateTime.tryParse(date);
      if (d == null) return false;
      return d.isAfter(cutoff) || d.isAtSameMomentAs(cutoff);
    }

    final doc = pw.Document();
    final generated = DateTime.now().toIso8601String().substring(0, 19);

    // ── Filters ─────────────────────────────────────────────
    final logs = state.logs.entries
        .where((e) => inWindow(e.key) && !e.value.isEmpty)
        .toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    final cycles = state.cycles.where((c) => inWindow(c.startDate)).toList()
      ..sort((a, b) => a.startDate.compareTo(b.startDate));

    final stats = CycleStats.compute(cycles);

    // Symptom counts across window.
    final symptomCounts = <String, int>{};
    final severityTotals = <String, int>{};
    for (final e in logs) {
      for (final s in e.value.symptoms) {
        symptomCounts[s] = (symptomCounts[s] ?? 0) + 1;
        severityTotals[s] = (severityTotals[s] ?? 0) + e.value.severity;
      }
    }
    final topSymptoms = symptomCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Medication adherence.
    final medRows = state.meds.map((m) {
      var taken = 0;
      for (final e in logs) {
        if (e.value.meds.contains(m.id)) taken++;
      }
      return (med: m, taken: taken);
    }).toList();

    // ── Page 1: summary ─────────────────────────────────────
    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (ctx) => pw.Container(
          padding: const pw.EdgeInsets.only(bottom: 8),
          decoration: const pw.BoxDecoration(
            border: pw.Border(
              bottom: pw.BorderSide(color: PdfColors.grey400, width: 0.5),
            ),
          ),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Lunora Health Summary',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                'Generated $generated',
                style: const pw.TextStyle(
                  fontSize: 9,
                  color: PdfColors.grey700,
                ),
              ),
            ],
          ),
        ),
        footer: (ctx) => pw.Container(
          padding: const pw.EdgeInsets.only(top: 8),
          decoration: const pw.BoxDecoration(
            border: pw.Border(
              top: pw.BorderSide(color: PdfColors.grey400, width: 0.5),
            ),
          ),
          child: pw.Text(
            _disclaimer,
            style: const pw.TextStyle(
              fontSize: 7,
              color: PdfColors.grey700,
            ),
          ),
        ),
        build: (ctx) => [
          pw.Text(
            'Reporting window: last $windowDays days',
            style: const pw.TextStyle(
              fontSize: 11,
              color: PdfColors.grey700,
            ),
          ),
          pw.SizedBox(height: 16),

          // Cycle summary
          _sectionTitle('Cycle summary'),
          pw.SizedBox(height: 6),
          if (cycles.isEmpty)
            _mutedText('No cycles logged in this window.')
          else ...[
            if (stats != null && stats.completedCount >= 2) ...[
              pw.Row(
                children: [
                  _stat('Average', '${stats.averageLength} days'),
                  _stat('Shortest', '${stats.minLength} days'),
                  _stat('Longest', '${stats.maxLength} days'),
                ],
              ),
              pw.SizedBox(height: 8),
              _mutedText(
                'Based on ${stats.completedCount} completed cycle lengths. '
                'Descriptive statistics only.',
              ),
              pw.SizedBox(height: 8),
            ] else
              _mutedText(
                'Not enough completed cycles for a range. '
                'Cycle lengths require at least 2 completed cycles.',
              ),
            pw.SizedBox(height: 10),
            pw.TableHelper.fromTextArray(
              headers: const ['Start', 'End', 'Length', 'Flow'],
              data: cycles
                  .map((c) => [
                        c.startDate,
                        c.endDate ?? 'ongoing',
                        c.lengthDays != null ? '${c.lengthDays} d' : '\u2014',
                        c.flow ?? '\u2014',
                      ])
                  .toList(),
              headerStyle: pw.TextStyle(
                fontSize: 9,
                fontWeight: pw.FontWeight.bold,
              ),
              cellStyle: const pw.TextStyle(fontSize: 9),
              cellAlignment: pw.Alignment.centerLeft,
            ),
          ],

          pw.SizedBox(height: 20),

          // Symptoms
          _sectionTitle('Symptoms'),
          pw.SizedBox(height: 6),
          if (topSymptoms.isEmpty)
            _mutedText('No symptoms recorded in this window.')
          else
            pw.TableHelper.fromTextArray(
              headers: const ['Symptom', 'Days logged', 'Avg severity'],
              data: topSymptoms.take(15).map((e) {
                final avg = severityTotals[e.key]! / e.value;
                return [
                  SymptomCatalog.labelOf(e.key, l10n),
                  e.value.toString(),
                  avg.toStringAsFixed(1),
                ];
              }).toList(),
              headerStyle: pw.TextStyle(
                fontSize: 9,
                fontWeight: pw.FontWeight.bold,
              ),
              cellStyle: const pw.TextStyle(fontSize: 9),
              cellAlignment: pw.Alignment.centerLeft,
            ),

          pw.SizedBox(height: 20),

          // Adherence
          _sectionTitle('Medication adherence'),
          pw.SizedBox(height: 6),
          if (medRows.isEmpty)
            _mutedText('No medications tracked.')
          else
            pw.TableHelper.fromTextArray(
              headers: const [
                'Medication',
                'Dose',
                'Days taken',
                'Days in window',
              ],
              data: medRows
                  .map((r) => [
                        r.med.name,
                        r.med.dose.isEmpty ? '\u2014' : r.med.dose,
                        r.taken.toString(),
                        windowDays.toString(),
                      ])
                  .toList(),
              headerStyle: pw.TextStyle(
                fontSize: 9,
                fontWeight: pw.FontWeight.bold,
              ),
              cellStyle: const pw.TextStyle(fontSize: 9),
              cellAlignment: pw.Alignment.centerLeft,
            ),
        ],
      ),
    );

    // ── Page 2: daily log detail ────────────────────────────
    if (logs.isNotEmpty) {
      doc.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          header: (ctx) => pw.Container(
            padding: const pw.EdgeInsets.only(bottom: 8),
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(color: PdfColors.grey400, width: 0.5),
              ),
            ),
            child: pw.Text(
              'Lunora \u2014 Daily log detail',
              style: pw.TextStyle(
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          footer: (ctx) => pw.Container(
            padding: const pw.EdgeInsets.only(top: 8),
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                top: pw.BorderSide(color: PdfColors.grey400, width: 0.5),
              ),
            ),
            child: pw.Text(
              _disclaimer,
              style: const pw.TextStyle(
                fontSize: 7,
                color: PdfColors.grey700,
              ),
            ),
          ),
          build: (ctx) => [
            pw.TableHelper.fromTextArray(
              headers: const ['Date', 'Symptoms', 'Sev', 'Meds', 'Notes'],
              columnWidths: {
                0: const pw.FixedColumnWidth(55),
                1: const pw.FlexColumnWidth(3),
                2: const pw.FixedColumnWidth(24),
                3: const pw.FixedColumnWidth(30),
                4: const pw.FlexColumnWidth(3),
              },
              data: logs.map((e) {
                final log = e.value;
                final sym = log.symptoms
                    .map((id) => SymptomCatalog.labelOf(id, l10n))
                    .join(', ');
                final notes = log.notes.length > 200
                    ? '${log.notes.substring(0, 200)}\u2026'
                    : log.notes;
                final medNames = log.meds.map((id) {
                  final m = state.meds.where((x) => x.id == id).toList();
                  return m.isEmpty ? id : m.first.name;
                }).join(', ');
                return [
                  e.key,
                  sym.isEmpty ? '\u2014' : sym,
                  log.severity.toString(),
                  medNames.isEmpty ? '\u2014' : medNames,
                  notes.isEmpty ? '\u2014' : notes,
                ];
              }).toList(),
              headerStyle: pw.TextStyle(
                fontSize: 8,
                fontWeight: pw.FontWeight.bold,
              ),
              cellStyle: const pw.TextStyle(fontSize: 8),
              cellAlignment: pw.Alignment.topLeft,
            ),
          ],
        ),
      );
    }

    return doc.save();
  }

  static pw.Widget _sectionTitle(String t) => pw.Text(
        t.toUpperCase(),
        style: pw.TextStyle(
          fontSize: 10,
          fontWeight: pw.FontWeight.bold,
          letterSpacing: 1,
          color: PdfColors.grey800,
        ),
      );

  static pw.Widget _mutedText(String t) => pw.Text(
        t,
        style: const pw.TextStyle(
          fontSize: 9,
          color: PdfColors.grey700,
        ),
      );

  static pw.Widget _stat(String label, String value) => pw.Expanded(
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              label.toUpperCase(),
              style: const pw.TextStyle(
                fontSize: 8,
                color: PdfColors.grey700,
                letterSpacing: 0.5,
              ),
            ),
            pw.SizedBox(height: 2),
            pw.Text(
              value,
              style: pw.TextStyle(
                fontSize: 13,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ],
        ),
      );
}