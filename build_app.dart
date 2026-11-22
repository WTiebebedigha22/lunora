// tool/fix_l10n_v3.dart
//
// Fixes the three remaining errors:
//   log_sheet.dart:366     - Text(...) has no positional arg (Icon was removed)
//   report_generator.dart:208 - Undefined name 'l10n'
//   report_generator.dart:304 - Undefined name 'l10n'
//
// Usage (from project root C:\Users\Ware\lunora):
//   dart run tool/fix_l10n_v3.dart

import 'dart:io';

void main() async {
  final root = Directory.current.path;
  stdout.writeln('=== fix_l10n_v3 ===');

  _fixLogSheet(root);
  _fixReportGenerator(root);

  stdout.writeln('');
  stdout.writeln('=== Rebuilding ===');
  await _run(['flutter', 'clean']);
  await _run(['flutter', 'pub', 'get']);
  await _run(['flutter', 'gen-l10n']);
  await _run(['flutter', 'run']);
}

// ===================================================================
// 1. log_sheet.dart — restore a String positional arg to Text(...)
// ===================================================================
void _fixLogSheet(String root) {
  final path = '$root/lib/features/symptoms/log_sheet.dart';
  final file = File(path);
  if (!file.existsSync()) {
    stderr.writeln('WARN: $path missing');
    return;
  }
  var c = file.readAsStringSync();
  file.copySync('$path.bak');

  // The script removed "Icon(Icons.circle, size: 8)," from inside a Text(
  // call, leaving "Text(\n ,\n )". Replace any empty-first-arg Text(...) with
  // a safe placeholder that satisfies the positional requirement.
  //
  // Pattern: "Text(" followed by only whitespace / commas before first ")".
  final emptyText = RegExp(r'Text\(\s*[\s,]*\)');
  final before = c;
  c = c.replaceAllMapped(emptyText, (m) {
    stdout.writeln('     emptied Text(...) -> Text(item.label(l10n)) '
        'in log_sheet.dart');
    return 'Text(item.label(l10n))';
  });

  // Also handle the shape:  Text(\n  ,\n  style: ...,\n)
  // where the first positional argument is empty but named args follow.
  // Strategy: replace "Text(\s*," with "Text(item.label(l10n),"
  final emptyFirstArg = RegExp(r'Text\(\s*,');
  if (emptyFirstArg.hasMatch(c)) {
    c = c.replaceAll(emptyFirstArg, 'Text(item.label(l10n),');
    stdout.writeln('     filled empty first arg of Text(...) '
        'with item.label(l10n)');
  }

  if (c != before) {
    file.writeAsStringSync(c);
    stdout.writeln('[1/2] log_sheet.dart patched');
  } else {
    stdout.writeln('[1/2] log_sheet.dart: no empty Text(...) found — '
        'inspect line 366 manually');
  }
}

// ===================================================================
// 2. report_generator.dart — add l10n param to the exact two methods
// ===================================================================
void _fixReportGenerator(String root) {
  final path = '$root/lib/features/settings/report_generator.dart';
  final file = File(path);
  if (!file.existsSync()) {
    stderr.writeln('WARN: $path missing');
    return;
  }
  var c = file.readAsStringSync();
  file.copySync('$path.bak');

  // Locate each method whose body contains "SymptomCatalog.labelOf(..., l10n)"
  // AND whose signature does NOT already contain "LunoraLocalizations l10n".
  //
  // We iterate *forward* via offset searches so nested braces can't confuse us.
  var searchFrom = 0;
  var patchCount = 0;

  while (true) {
    final labelOfUse =
        c.indexOf('SymptomCatalog.labelOf(', searchFrom);
    if (labelOfUse < 0) break;

    // Walk backwards to find the enclosing method's opening "{".
    var braceDepth = 0;
    var methodOpen = -1;
    for (var i = labelOfUse; i >= 0; i--) {
      if (c[i] == '}') braceDepth++;
      if (c[i] == '{') {
        braceDepth--;
        if (braceDepth < 0) {
          methodOpen = i;
          break;
        }
      }
    }
    if (methodOpen < 0) {
      searchFrom = labelOfUse + 1;
      continue;
    }

    // Walk further back to the method's "(" and its matching ")".
    var parenDepth = 0;
    var sigClose = -1;
    var sigOpen = -1;
    for (var i = methodOpen; i >= 0; i--) {
      if (c[i] == ')') parenDepth++;
      if (c[i] == '(') {
        parenDepth--;
        if (parenDepth == 0) {
          sigClose = i; // wrong direction; fix below
          break;
        }
      }
    }
    // The above finds the *first* "(" to the left. Re-scan forward from just
    // after the method name (the "(" matching the ")" before methodOpen).
    // Simpler: scan backward from methodOpen for ")" then its matching "(".
    sigClose = -1;
    for (var i = methodOpen; i >= 0; i--) {
      if (c[i] == ')') {
        sigClose = i;
        break;
      }
    }
    if (sigClose < 0) {
      searchFrom = labelOfUse + 1;
      continue;
    }
    parenDepth = 0;
    for (var i = sigClose; i >= 0; i--) {
      if (c[i] == ')') parenDepth++;
      if (c[i] == '(') {
        parenDepth--;
        if (parenDepth == 0) {
          sigOpen = i;
          break;
        }
      }
    }
    if (sigOpen < 0) {
      searchFrom = labelOfUse + 1;
      continue;
    }

    final sig = c.substring(sigOpen, sigClose + 1);
    if (sig.contains('LunoraLocalizations l10n')) {
      searchFrom = labelOfUse + 1;
      continue; // already has param
    }

    // Decide how to insert the parameter.
    final hasNamedParams = sig.contains('{');
    String newSig;
    if (hasNamedParams) {
      // Named params: insert "required LunoraLocalizations l10n," right
      // after the opening "{".
      final braceIdx = sig.indexOf('{');
      newSig = '${sig.substring(0, braceIdx + 1)}'
          '\n    required LunoraLocalizations l10n,'
          '${sig.substring(braceIdx + 1)}';
    } else {
      // No named params — unlikely for report generator. Abort with warning.
      stderr.writeln('WARN: method at offset $sigOpen has no named params; '
          'skipping. Add l10n manually.');
      searchFrom = labelOfUse + 1;
      continue;
    }

    c = c.replaceRange(sigOpen, sigClose + 1, newSig);
    patchCount++;
    stdout.writeln('     added required l10n to method at offset $sigOpen '
        '(now $sigOpen)');
    // Move past this call to avoid reprocessing.
    searchFrom = sigOpen + newSig.length;
  }

  if (patchCount > 0) {
    if (!c.contains('l10n/app_localizations.dart')) {
      c = "import 'package:lunora/l10n/app_localizations.dart';\n$c";
    }
    file.writeAsStringSync(c);
    stdout.writeln('[2/2] report_generator.dart: added l10n to '
        '$patchCount method(s)');
    stdout.writeln('');
    stdout.writeln('NOTE: if you see "named parameter required l10n is missing" '
        'errors next,');
    stdout.writeln('      add `l10n: LunoraLocalizations.of(context)` to the '
        'call sites');
    stdout.writeln('      in settings_screen.dart (or wherever these reports '
        'are generated).');
  } else {
    stdout.writeln('[2/2] report_generator.dart: no methods needed patching');
  }
}

Future<void> _run(List<String> cmd) async {
  stdout.writeln('> ${cmd.join(' ')}');
  final p = await Process.start(cmd.first, cmd.sublist(1),
      runInShell: true, mode: ProcessStartMode.inheritStdio);
  final code = await p.exitCode;
  if (code != 0) {
    stderr.writeln('Command failed (exit $code): ${cmd.join(' ')}');
    exit(code);
  }
}