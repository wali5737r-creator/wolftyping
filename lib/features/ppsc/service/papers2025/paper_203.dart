import '../../model/mock_question.dart';
import '../../model/paper_test.dart';

// PRACTICE MATERIAL ONLY.
// This is a practice mock test written in fresh wording for revision.
// It is not an official paper, not a verbatim reproduction of any exam,
// and it does not predict any real exam. Answers were checked against
// general reference facts at build time; where a printed key differed
// from the researched fact, the researched fact was used.

const PaperTest paper203 = PaperTest(
  id: '2025-203',
  paperNo: 203,
  year: 2025,
  post: 'Planning Officer (BS-17)',
  department: 'Specialized Healthcare & Medical Education Department',
  examDate: '2025',
  questions: [
    // General Knowledge
    MockQuestion(
      id: 'p203-1',
      subject: MockSubject.generalKnowledge,
      question: 'Which is the largest stock exchange in the world?',
      options: ['New York Stock Exchange', 'NASDAQ', 'Nippon Stock Exchange', 'Sydney Stock Exchange'],
      correctIndex: 0,
      topic: 'Economics',
      explanation: 'The New York Stock Exchange is the largest stock exchange in the world by the market value of the companies listed on it.',
    ),
    // English
    MockQuestion(
      id: 'p203-2',
      subject: MockSubject.english,
      question: 'John loves flying but we ___ . Choose the correct word.',
      options: ['are not', 'did not', 'Do not', 'also'],
      correctIndex: 2,
      topic: 'Grammar',
      explanation: 'The contrast needs do not: John loves flying, but we do not love flying.',
    ),
    MockQuestion(
      id: 'p203-3',
      subject: MockSubject.english,
      question: 'Each one ___ a pen. Choose the correct verb.',
      options: ['have', 'is having', 'Has', 'having'],
      correctIndex: 2,
      topic: 'Grammar',
      explanation: 'Each one is singular, so it takes the singular verb has.',
    ),
    MockQuestion(
      id: 'p203-4',
      subject: MockSubject.english,
      question: 'The saying Big is beautiful means what?',
      options: ['Big is adventurous', 'Large size is attractive', 'Big things are always better', 'Bigger is stronger'],
      correctIndex: 1,
      topic: 'Idioms',
      explanation: 'Big is beautiful is used to say that large size can itself be attractive and admirable; it does not mean adventurous.',
    ),
    // General Knowledge
    MockQuestion(
      id: 'p203-5',
      subject: MockSubject.generalKnowledge,
      question: 'What is the name for religious violence in which terrorism is used to reach religious goals?',
      options: ['Spiritual Extremism', 'Religious Terrorism', 'Holy Terrorism', 'Faith Terrorism'],
      correctIndex: 1,
      topic: 'World Knowledge',
      explanation: 'Terrorism used as a strategy to achieve goals shaped by religious beliefs or identity is called religious terrorism.',
    ),
    // Everyday Science
    MockQuestion(
      id: 'p203-6',
      subject: MockSubject.everydayScience,
      question: 'The muscles at the back of the thigh are together known as what?',
      options: ['Quadriceps', 'Adductors', 'Gluteals', 'Hamstring'],
      correctIndex: 3,
      topic: 'Biology',
      explanation: 'The hamstring muscles form the posterior compartment of the thigh; the quadriceps are at the front.',
    ),
    MockQuestion(
      id: 'p203-7',
      subject: MockSubject.everydayScience,
      question: 'Which element is found in the greatest amount in sea water?',
      options: ['Chlorine', 'Sodium', 'Magnesium', 'Potassium'],
      correctIndex: 0,
      topic: 'Chemistry',
      explanation: 'Chloride is the most plentiful dissolved ion in sea water, ahead of sodium, so chlorine is the element present in the greatest amount.',
    ),
    // Pakistan Studies
    MockQuestion(
      id: 'p203-8',
      subject: MockSubject.pakistanStudies,
      question: 'F. E. Chaudhry was a Pakistani what?',
      options: ['Scientist', 'Architect', 'Photographer', 'Historian'],
      correctIndex: 2,
      topic: 'History',
      explanation: 'F. E. Chaudhry was a pioneering Pakistani press photographer, the first serious full-time press photographer of Pakistan, who worked for The Pakistan Times.',
    ),
    MockQuestion(
      id: 'p203-9',
      subject: MockSubject.pakistanStudies,
      question: 'Who was the Viceroy at the time of the Shimla Conference?',
      options: ['Lord Linlithgow', 'Lord Mountbatten', 'Lord Wavell', 'Lord Chelmsford'],
      correctIndex: 2,
      topic: 'History',
      explanation: 'Lord Wavell was Viceroy when he called the Shimla Conference in June 1945 to discuss the future government of India.',
    ),
    // General Knowledge
    MockQuestion(
      id: 'p203-10',
      subject: MockSubject.generalKnowledge,
      question: 'Who founded Microsoft?',
      options: ['Bill Gates', 'Paul Allen', 'Bill Gates and Paul Allen', 'Bill Gates and Steve Wozniak'],
      correctIndex: 2,
      topic: 'Computer',
      explanation: 'Bill Gates and Paul Allen founded Microsoft together in 1975; Steve Wozniak co-founded Apple, not Microsoft.',
    ),
    // Everyday Science
    MockQuestion(
      id: 'p203-11',
      subject: MockSubject.everydayScience,
      question: 'Silicon is used to make what?',
      options: ['Plastic', 'Semiconductors', 'Rubber', 'Fertilizers'],
      correctIndex: 1,
      topic: 'Chemistry',
      explanation: 'Silicon is the main material used to make semiconductor chips for computers and other electronics.',
    ),
    // Mathematics
    MockQuestion(
      id: 'p203-12',
      subject: MockSubject.mathematics,
      question: 'Salaries of A, B and C are in the ratio 2:3:5. Rises of 15 percent, 10 percent and 20 percent are given in that order. What is the new ratio?',
      options: ['20 : 30 : 50', '23 : 30 : 59', '23:33:60', '22 : 33 : 58'],
      correctIndex: 2,
      topic: 'Ratio and Percentage',
      explanation: 'Working: the new salaries are 2 times 1.15, 3 times 1.10 and 5 times 1.20, which is 2.3, 3.3 and 6, giving the ratio 23:33:60.',
    ),
    // Urdu
    MockQuestion(
      id: 'p203-13',
      subject: MockSubject.generalKnowledge,
      question: 'Kisi cheez ki chhoti surat ko zahir karne wala ism kya kehlata hai?',
      options: ['Ism-e-Masghar', 'Ism-e-Kaifiyat', 'Ism-e-Aala', 'Ism-e-Saut'],
      correctIndex: 0,
      topic: 'Urdu Grammar',
      explanation: 'Chhoti surat zahir karne wala ism, ism-e-masghar kehlata hai.',
    ),
  ],
  latestUpdates: [],
);
