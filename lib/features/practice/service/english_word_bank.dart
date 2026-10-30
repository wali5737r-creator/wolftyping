/// A small bank of common, short, real English words — used only to build
/// Character Practice content that contains a user's actual weak letters
/// (spec section 6 example: weak A/S/K -> "asdf ask sad desk asks"). This
/// is not typing-test content itself; it's a lookup table so Character
/// Practice drills are made of real words instead of random letters.
class EnglishWordBank {
  EnglishWordBank._();

  static const List<String> words = [
    'the', 'and', 'for', 'are', 'but', 'not', 'you', 'all', 'can', 'her',
    'was', 'one', 'our', 'out', 'day', 'get', 'has', 'him', 'his', 'how',
    'man', 'new', 'now', 'old', 'see', 'two', 'way', 'who', 'boy', 'did',
    'its', 'let', 'put', 'say', 'she', 'too', 'use', 'ask', 'sad', 'desk',
    'asks', 'dark', 'fast', 'last', 'mask', 'task', 'flask', 'salad',
    'gash', 'half', 'flags', 'fads', 'gala', 'alas', 'glass', 'dash',
    'salads', 'stack', 'skate', 'sketch', 'basket', 'ticket', 'jacket',
    'market', 'packet', 'rocket', 'cake', 'lake', 'make', 'take', 'wake',
    'rake', 'bake', 'kids', 'keys', 'kind', 'know', 'king', 'kite',
    'skip', 'skill', 'skirt', 'risk', 'disk', 'quick', 'quiet', 'write',
    'your', 'tree', 'pretty', 'wire', 'quote', 'water', 'tie', 'type',
    'require', 'zoom', 'mix', 'van', 'cab', 'mob', 'nab', 'exam', 'mean',
    'man', 'can', 'vex', 'happy', 'people', 'because', 'important',
    'different', 'possible', 'available', 'question', 'answer', 'letter',
    'number', 'better', 'never', 'always',
  ];
}
