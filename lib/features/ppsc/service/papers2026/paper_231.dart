import '../../model/mock_question.dart';
import '../../model/paper_test.dart';

/// PRACTICE MATERIAL ONLY.
///
/// This file is a practice mock test written in fresh wording for
/// revision and self-assessment. It is NOT an official paper, NOT a
/// verbatim reproduction of any exam, and it does not predict any
/// real exam. Answers were checked independently at build time.
const PaperTest paper231 = PaperTest(
  id: '2026-231',
  paperNo: 231,
  year: 2026,
  post: 'Senior Inspector (BS-16) & Assistant Director (BS-17)',
  department: 'Punjab Environment Protection Department',
  examDate: '19.04.2026',
  questions: [
    MockQuestion(
      id: 'p231-1',
      subject: MockSubject.generalKnowledge,
      question:
          'The well-known Kund Malir beach on the Makran coast lies in which province of Pakistan?',
      options: ['Sindh', 'Balochistan', 'Punjab', 'Khyber Pakhtunkhwa'],
      correctIndex: 1,
      topic: 'Geography',
      explanation: 'Kund Malir beach lies on the Makran coast in Balochistan.',
    ),
    MockQuestion(
      id: 'p231-2',
      subject: MockSubject.pakistanStudies,
      question:
          'Which subject was the Delhi Sultan Muhammad bin Tughlaq most famous for mastering?',
      options: ['Music', 'Philosophy', 'Painting', 'Calligraphy'],
      correctIndex: 1,
      topic: 'Medieval History',
      explanation: 'Muhammad bin Tughlaq was known as a highly learned sultan, most famous for his mastery of philosophy.',
    ),
    MockQuestion(
      id: 'p231-3',
      subject: MockSubject.everydayScience,
      question:
          'Which of the following is NOT counted among physical pollutants?',
      options: ['Heat', 'Sound', 'Radiation', 'Soot'],
      correctIndex: 3,
      topic: 'Pollution',
      explanation: 'Heat, sound and radiation are forms of energy, so they are physical pollutants, while soot is particulate matter rather than a physical pollutant.',
    ),
    MockQuestion(
      id: 'p231-4',
      subject: MockSubject.everydayScience,
      question:
          'In a food chain, which group of organisms occupies the first trophic level?',
      options: ['Herbivores', 'Green plants', 'Carnivores', 'Decomposers'],
      correctIndex: 1,
      topic: 'Ecology',
      explanation: 'Green plants are producers, so they occupy the first trophic level of a food chain.',
    ),
    MockQuestion(
      id: 'p231-5',
      subject: MockSubject.mathematics,
      question:
          'If x is to y as 6 is to 5, and z is to y as 9 is to 25, what is the ratio of x to z?',
      options: ['50:33', '48:25', '10:3', '54:125'],
      correctIndex: 2,
      topic: 'Ratio',
      explanation: 'x / y = 6 / 5 and z / y = 9 / 25, so x / z = (6 / 5) / (9 / 25) = 150 / 45 = 10 / 3.',
    ),
    MockQuestion(
      id: 'p231-6',
      subject: MockSubject.mathematics,
      question:
          'A right-angled triangle has sides in the ratio 3:4:5 and an area of 216 square centimetres. What is its perimeter?',
      options: ['36 cm', '72 cm', '12 cm', '6 cm'],
      correctIndex: 1,
      topic: 'Geometry',
      explanation: 'With sides 3k, 4k and 5k, area = (1/2) x 3k x 4k = 6k squared = 216, so k = 6 and perimeter = 12k = 72 cm.',
    ),
    MockQuestion(
      id: 'p231-7',
      subject: MockSubject.mathematics,
      question:
          'In a class of 40 pupils, three-quarters pass an exam. How many pupils fail?',
      options: ['30', '25', '20', '10'],
      correctIndex: 3,
      topic: 'Percentage',
      explanation: 'Three-quarters pass, so one-quarter fail: 40 / 4 = 10 pupils.',
    ),
    MockQuestion(
      id: 'p231-8',
      subject: MockSubject.mathematics,
      question:
          'Take any prime number larger than 3, square it and subtract 1. The result is always divisible by:',
      options: ['6 but not 12', '12 but not 24', '24', 'None of these'],
      correctIndex: 2,
      topic: 'Number Theory',
      explanation: 'A prime larger than 3 is odd and not a multiple of 3, so its square minus 1 is divisible by both 8 and 3, hence by 24.',
    ),
    MockQuestion(
      id: 'p231-9',
      subject: MockSubject.islamiat,
      question:
          'According to a well-known traditional account, how many times did Angel Jibrael (AS) come to the Holy Prophet (SAW)?',
      options: ['20,000', '22,000', '24,000', '26,000'],
      correctIndex: 2,
      topic: 'Angels',
      explanation: 'The traditional account cited in this item gives 24,000 visits by Angel Jibrael to the Holy Prophet.',
    ),
    MockQuestion(
      id: 'p231-10',
      subject: MockSubject.english,
      question:
          'Which word means the opposite of "cajole" (to coax someone into doing something)?',
      options: ['Persuade', 'Dissuade', 'Lure', 'Coax'],
      correctIndex: 1,
      topic: 'Vocabulary',
      explanation: 'Cajole means to coax, so its opposite is dissuade, meaning to persuade someone not to do something.',
    ),
    MockQuestion(
      id: 'p231-11',
      subject: MockSubject.english,
      question: 'Which word is closest in meaning to "plentiful"?',
      options: ['Scarce', 'Abundant', 'Meagre', 'Limited'],
      correctIndex: 1,
      topic: 'Vocabulary',
      explanation: 'Plentiful means existing in large amounts, which is the same as abundant.',
    ),
    MockQuestion(
      id: 'p231-12',
      subject: MockSubject.english,
      question: 'Complete the saying: "Out of sight, out of ___."',
      options: ['soul', 'light', 'mind', 'thought'],
      correctIndex: 2,
      topic: 'Idioms',
      explanation: 'The complete saying is: out of sight, out of mind.',
    ),
    MockQuestion(
      id: 'p231-13',
      subject: MockSubject.english,
      question:
          'Choose the correct completion: "My father was so poor ___ buy us food."',
      options: [
        'that who could not',
        'to he could not',
        'that he could not',
        'none of these',
      ],
      correctIndex: 2,
      topic: 'Grammar',
      explanation: 'The correct structure is so poor that he could not buy food, using that plus a subject and could not.',
    ),
    MockQuestion(
      id: 'p231-14',
      subject: MockSubject.generalKnowledge,
      question:
          'لفظ "قائدِ اعظم" محمد علی جناح کے لیے گرامر کی رو سے کیا ہے؟',
      options: ['لقب', 'خطاب', 'کنیت', 'تخلص'],
      correctIndex: 0,
      topic: 'Urdu Grammar',
      explanation: 'Quaid-e-Azam is a laqab, an honorary title describing a person, rather than a khitab conferred by government.',
    ),
    MockQuestion(
      id: 'p231-15',
      subject: MockSubject.generalKnowledge,
      question:
          'محاورہ "آگے کنواں، پیچھے کھائی" کس صورتِ حال کو ظاہر کرتا ہے؟',
      options: ['ہر طرف خوشی', 'آسان راستہ', 'ہر طرف مشکلات', 'کوئی بھی نہیں'],
      correctIndex: 2,
      topic: 'Urdu Proverbs',
      explanation: 'Aage kuan, peeche khai describes being in difficulty on every side, with no easy way out.',
    ),
  ],
);
