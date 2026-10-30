import '../model/mock_question.dart';

/// PRACTICE SAMPLE question bank for the PPSC mock test.
///
/// HOW TO ADD YOUR OWN QUESTIONS (including a full 100-MCQ set):
/// 1. Add one `MockQuestion(...)` entry per question to [sampleQuestions]
///    below (or replace the whole list). Keep the format exactly:
///      MockQuestion(
///        id: 'gk-4',
///        subject: MockSubject.generalKnowledge,
///        question: 'Your question text?',
///        options: ['Option A', 'Option B', 'Option C', 'Option D'],
///        correctIndex: 0, // 0=A, 1=B, 2=C, 3=D
///        topic: 'Optional topic label',
///      ),
/// 2. Give every question a unique `id`.
/// 3. Keep exactly 4 options and set `correctIndex` to the correct one.
/// 4. The full mock test uses ALL questions in this list; subject-wise
///    tests use only that subject's questions. The engine and UI need no
///    other changes — they adapt to however many questions are present.
///
/// IMPORTANT: these are practice sample questions written for this app.
/// They are NOT real PPSC past papers, are not taken from any exam, and
/// do not predict the real exam. The mock-test screens label them as
/// practice samples.
const List<MockQuestion> sampleQuestions = [
  // ------------------------------------------------------------------
  // English (3 samples)
  // ------------------------------------------------------------------
  MockQuestion(
    id: 'eng-1',
    subject: MockSubject.english,
    question: 'Which word is spelled correctly?',
    options: ['Beautifull', 'Beautiful', 'Biutiful', 'Beautifel'],
    correctIndex: 1,
    topic: 'Spelling',
  ),
  MockQuestion(
    id: 'eng-2',
    subject: MockSubject.english,
    question: 'Choose the antonym of "happy".',
    options: ['Sad', 'Glad', 'Joyful', 'Cheerful'],
    correctIndex: 0,
    topic: 'Vocabulary',
  ),
  MockQuestion(
    id: 'eng-3',
    subject: MockSubject.english,
    question: 'She ___ to school every day.',
    options: ['go', 'goes', 'going', 'gone'],
    correctIndex: 1,
    topic: 'Grammar',
  ),

  // ------------------------------------------------------------------
  // General Knowledge (3 samples)
  // ------------------------------------------------------------------
  MockQuestion(
    id: 'gk-1',
    subject: MockSubject.generalKnowledge,
    question: 'What is the capital of Pakistan?',
    options: ['Karachi', 'Lahore', 'Islamabad', 'Peshawar'],
    correctIndex: 2,
    topic: 'Capitals',
  ),
  MockQuestion(
    id: 'gk-2',
    subject: MockSubject.generalKnowledge,
    question: 'How many players of one team are on the field in a cricket match?',
    options: ['9', '10', '11', '12'],
    correctIndex: 2,
    topic: 'Sports',
  ),
  MockQuestion(
    id: 'gk-3',
    subject: MockSubject.generalKnowledge,
    question: 'Which is the largest ocean in the world?',
    options: ['Atlantic Ocean', 'Indian Ocean', 'Arctic Ocean', 'Pacific Ocean'],
    correctIndex: 3,
    topic: 'Geography',
  ),

  // ------------------------------------------------------------------
  // Pakistan Studies (3 samples)
  // ------------------------------------------------------------------
  MockQuestion(
    id: 'ps-1',
    subject: MockSubject.pakistanStudies,
    question: 'Pakistan came into being on:',
    options: [
      '14 August 1947',
      '15 August 1947',
      '14 August 1948',
      '23 March 1940',
    ],
    correctIndex: 0,
    topic: 'History',
  ),
  MockQuestion(
    id: 'ps-2',
    subject: MockSubject.pakistanStudies,
    question: 'What is the national animal of Pakistan?',
    options: ['Lion', 'Markhor', 'Tiger', 'Deer'],
    correctIndex: 1,
    topic: 'National Symbols',
  ),
  MockQuestion(
    id: 'ps-3',
    subject: MockSubject.pakistanStudies,
    question: 'What is the national language of Pakistan?',
    options: ['Punjabi', 'Sindhi', 'English', 'Urdu'],
    correctIndex: 3,
    topic: 'National Symbols',
  ),

  // ------------------------------------------------------------------
  // Islamiat (3 samples)
  // ------------------------------------------------------------------
  MockQuestion(
    id: 'isl-1',
    subject: MockSubject.islamiat,
    question: 'The Holy Quran was revealed in which month?',
    options: ['Rajab', 'Shaban', 'Ramadan', 'Muharram'],
    correctIndex: 2,
    topic: 'Quran',
  ),
  MockQuestion(
    id: 'isl-2',
    subject: MockSubject.islamiat,
    question: 'How many pillars of Islam are there?',
    options: ['Four', 'Five', 'Six', 'Seven'],
    correctIndex: 1,
    topic: 'Pillars of Islam',
  ),
  MockQuestion(
    id: 'isl-3',
    subject: MockSubject.islamiat,
    question: 'Which is the first month of the Islamic calendar?',
    options: ['Ramadan', 'Shawwal', 'Safar', 'Muharram'],
    correctIndex: 3,
    topic: 'Islamic Calendar',
  ),

  // ------------------------------------------------------------------
  // Mathematics (3 samples)
  // ------------------------------------------------------------------
  MockQuestion(
    id: 'math-1',
    subject: MockSubject.mathematics,
    question: 'What is 12 × 8?',
    options: ['86', '94', '96', '108'],
    correctIndex: 2,
    topic: 'Arithmetic',
  ),
  MockQuestion(
    id: 'math-2',
    subject: MockSubject.mathematics,
    question: 'What is 25% of 200?',
    options: ['25', '40', '50', '75'],
    correctIndex: 2,
    topic: 'Percentage',
  ),
  MockQuestion(
    id: 'math-3',
    subject: MockSubject.mathematics,
    question: 'What is the square root of 144?',
    options: ['11', '12', '13', '14'],
    correctIndex: 1,
    topic: 'Square Roots',
  ),

  // ------------------------------------------------------------------
  // Everyday Science (3 samples)
  // ------------------------------------------------------------------
  MockQuestion(
    id: 'sci-1',
    subject: MockSubject.everydayScience,
    question: 'What is the chemical formula of water?',
    options: ['CO2', 'H2O', 'O2', 'NaCl'],
    correctIndex: 1,
    topic: 'Chemistry',
  ),
  MockQuestion(
    id: 'sci-2',
    subject: MockSubject.everydayScience,
    question: 'Which planet is known as the Red Planet?',
    options: ['Venus', 'Jupiter', 'Mars', 'Saturn'],
    correctIndex: 2,
    topic: 'Astronomy',
  ),
  MockQuestion(
    id: 'sci-3',
    subject: MockSubject.everydayScience,
    question: 'At sea level, water boils at:',
    options: ['90°C', '95°C', '100°C', '110°C'],
    correctIndex: 2,
    topic: 'Physics',
  ),
];
