import 'dart:math';

import '../model/paragraph_difficulty.dart';
import '../model/urdu_paragraph.dart';

/// Built-in Urdu paragraphs for the Urdu Typing Test and PPSC Urdu
/// Practice. Real, grammatically correct Urdu passages — never
/// placeholder text, and never transliterated from English.
class UrduParagraphProvider {
  UrduParagraphProvider._();

  static const List<UrduParagraph> _easy = [
    UrduParagraph(
      title: 'روزمرہ کی زندگی',
      difficulty: ParagraphDifficulty.easy,
      text: 'میں ہر روز صبح جلدی اٹھتا ہوں۔ پھر میں ناشتہ کرتا ہوں اور '
          'اسکول جاتا ہوں۔ یہ میری روزانہ کی عادت ہے۔',
    ),
    UrduParagraph(
      title: 'پاکستان',
      difficulty: ParagraphDifficulty.easy,
      text: 'پاکستان ایک خوبصورت ملک ہے۔ یہاں پہاڑ، دریا اور سمندر سب '
          'موجود ہیں۔ لوگ محنتی اور مہمان نواز ہیں۔',
    ),
    UrduParagraph(
      title: 'اتوار کا دن',
      difficulty: ParagraphDifficulty.easy,
      text: 'میری امی بہت اچھا کھانا بناتی ہیں۔ ہر اتوار کو ہم سب مل '
          'کر کھانا کھاتے ہیں۔ یہ وقت بہت خوشگوار ہوتا ہے۔',
    ),
  ];

  static const List<UrduParagraph> _medium = [
    UrduParagraph(
      title: 'اہمیت تعلیم',
      difficulty: ParagraphDifficulty.medium,
      text: 'تعلیم ہر انسان کا بنیادی حق ہے۔ اچھی تعلیم انسان کو بہتر '
          'مستقبل بنانے میں مدد دیتی ہے۔ ہمیں چاہیے کہ ہم اپنے بچوں کو '
          'معیاری تعلیم دیں تاکہ وہ ملک اور قوم کی خدمت کر سکیں۔',
    ),
    UrduParagraph(
      title: 'جدید ٹیکنالوجی',
      difficulty: ParagraphDifficulty.medium,
      text: 'ٹیکنالوجی نے ہماری زندگی کو بہت آسان بنا دیا ہے۔ اب لوگ '
          'گھر بیٹھے دنیا بھر سے رابطہ کر سکتے ہیں۔ لیکن ہمیں اس کا '
          'استعمال احتیاط سے کرنا چاہیے۔',
    ),
    UrduParagraph(
      title: 'وقت کی قدر',
      difficulty: ParagraphDifficulty.medium,
      text: 'وقت کی پابندی کامیابی کی پہلی سیڑھی ہے۔ جو لوگ اپنا وقت '
          'ضائع نہیں کرتے وہ زندگی میں آگے بڑھتے ہیں۔ ہمیں چاہیے کہ ہم '
          'اپنے کاموں کو وقت پر مکمل کریں۔',
    ),
  ];

  static const List<UrduParagraph> _hard = [
    UrduParagraph(
      title: 'زراعت اور معیشت',
      difficulty: ParagraphDifficulty.hard,
      text: 'پاکستان کی معیشت میں زراعت کا شعبہ نہایت اہم کردار ادا '
          'کرتا ہے۔ ملک کی بیشتر آبادی دیہی علاقوں میں رہتی ہے اور اپنی '
          'روزی روٹی کے لیے کھیتی باڑی پر انحصار کرتی ہے۔ حکومت کو '
          'چاہیے کہ کسانوں کو جدید سہولیات فراہم کرے تاکہ پیداوار میں '
          'اضافہ ہو سکے۔',
    ),
    UrduParagraph(
      title: 'علم کی اہمیت',
      difficulty: ParagraphDifficulty.hard,
      text: 'علم اور حکمت انسان کو دوسری مخلوقات سے ممتاز کرتے ہیں۔ جو '
          'قومیں علم کی قدر کرتی ہیں وہ ترقی کی راہ پر گامزن رہتی ہیں، '
          'جبکہ جو قومیں اس سے غافل ہو جاتی ہیں وہ زوال پذیر ہو جاتی '
          'ہیں۔ اس لیے ہمیں علم کے حصول کو اپنی اولین ترجیح بنانا '
          'چاہیے۔',
    ),
    UrduParagraph(
      title: 'جمہوریت',
      difficulty: ParagraphDifficulty.hard,
      text: 'جمہوریت ایک ایسا نظام حکومت ہے جس میں عوام کو اپنے '
          'نمائندے منتخب کرنے کا حق حاصل ہوتا ہے۔ ایک مضبوط جمہوری '
          'نظام کے قیام کے لیے آزاد عدلیہ، خودمختار میڈیا اور باشعور '
          'عوام کا ہونا ضروری ہے۔',
    ),
  ];

  static List<UrduParagraph> byDifficulty(ParagraphDifficulty difficulty) {
    switch (difficulty) {
      case ParagraphDifficulty.easy:
        return _easy;
      case ParagraphDifficulty.medium:
        return _medium;
      case ParagraphDifficulty.hard:
        return _hard;
    }
  }

  static final Random _random = Random();

  static UrduParagraph randomOf(ParagraphDifficulty difficulty) {
    final List<UrduParagraph> list = byDifficulty(difficulty);
    return list[_random.nextInt(list.length)];
  }

  static UrduParagraph randomAny() {
    final List<UrduParagraph> all = [..._easy, ..._medium, ..._hard];
    return all[_random.nextInt(all.length)];
  }
}
