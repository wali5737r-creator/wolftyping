/// Result of validating a paragraph form (spec section 2). Both error
/// fields are null when valid.
class ParagraphValidationResult {
  const ParagraphValidationResult({this.titleError, this.textError});

  final String? titleError;
  final String? textError;

  bool get isValid => titleError == null && textError == null;
}

/// Pure validation — no GetX, no widgets — so it can be unit tested
/// directly (see test/paragraphs_test.dart).
class ParagraphValidation {
  ParagraphValidation._();

  static ParagraphValidationResult validate({
    required String title,
    required String text,
  }) {
    final String trimmedTitle = title.trim();
    final String trimmedText = text.trim();
    return ParagraphValidationResult(
      titleError: trimmedTitle.isEmpty ? 'Title cannot be empty.' : null,
      textError:
          trimmedText.isEmpty ? 'Paragraph text cannot be empty.' : null,
    );
  }
}
