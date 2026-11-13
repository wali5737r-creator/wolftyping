import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/services/certificate_code.dart';

/// On-device storage for the last GENERATED practice certificate, so
/// a direct visit to `#/certificate` (or a reload) after generating
/// still shows the certificate instead of "No result to certify yet".
/// The record is the result plus its WT1 verification code — the code
/// already encodes the whole result, so the stored code is re-decoded
/// on load and a tampered record is rejected, never displayed.
///
/// Only generated certificates are stored: merely opening the screen
/// with a result never overwrites a generated certificate, and
/// "Change Name" clears the record so a reload does not resurrect a
/// certificate the user went back to edit. No login, no backend, no
/// server: the record lives only on this device, like the stored
/// certificate name.
class LastCertificateStore {
  LastCertificateStore._();

  static final LastCertificateStore instance = LastCertificateStore._();

  static const String storageKey = 'wolftyping_last_certificate_v1';

  /// The last generated certificate, or null when none was ever
  /// generated on this device (or the stored record is corrupt).
  /// A corrupt blob never crashes the app and never wipes anything
  /// else: it is simply treated as "no certificate yet".
  Future<StoredCertificate?> load() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? raw = prefs.getString(storageKey);
    if (raw == null || raw.trim().isEmpty) return null;
    try {
      final Object? parsed = jsonDecode(raw);
      if (parsed is! Map) return null;
      final Map<String, dynamic> map = Map<String, dynamic>.from(parsed);
      final Object? dataRaw = map['data'];
      final Object? codeRaw = map['code'];
      if (dataRaw is! Map || codeRaw is! String) return null;
      final CertificateData data = CertificateData.fromJson(
        Map<String, dynamic>.from(dataRaw),
      );
      // The code must decode to exactly the stored result: a code
      // edited by hand (or from another result) is rejected.
      final CertificateData fromCode = decodeCertificateCode(codeRaw);
      if (fromCode.holderName != data.holderName ||
          fromCode.testLabel != data.testLabel ||
          fromCode.score != data.score ||
          fromCode.totalQuestions != data.totalQuestions ||
          fromCode.correct != data.correct ||
          fromCode.wrong != data.wrong ||
          fromCode.skipped != data.skipped) {
        return null;
      }
      return StoredCertificate(data: data, code: codeRaw);
    } catch (_) {
      return null;
    }
  }

  /// Persists a generated certificate. Never throws into the UI:
  /// a failed write only means a reload will show the empty state.
  Future<void> save(CertificateData data, String code) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        storageKey,
        jsonEncode(<String, dynamic>{'data': data.toJson(), 'code': code}),
      );
    } catch (_) {
      // Best effort only.
    }
  }

  /// Forgets the stored certificate (used by "Change Name").
  /// Never throws into the UI.
  Future<void> clear() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(storageKey);
    } catch (_) {
      // Best effort only.
    }
  }
}

/// A generated certificate read back from the device store.
class StoredCertificate {
  const StoredCertificate({required this.data, required this.code});

  final CertificateData data;
  final String code;
}
