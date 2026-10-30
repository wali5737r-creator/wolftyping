import '../../model/mock_question.dart';
import '../../model/paper_test.dart';

// PRACTICE MATERIAL ONLY.
// This is a practice mock test written in fresh wording for revision.
// It is not an official paper, not a verbatim reproduction of any exam,
// and it does not predict any real exam. Answers were checked against
// general reference facts at build time; where a printed key differed
// from the researched fact, the researched fact was used.

const PaperTest paper188 = PaperTest(
  id: '2025-188',
  paperNo: 188,
  year: 2025,
  post: 'Planning Officer (BS-17)',
  department: 'Primary and Secondary Healthcare Department',
  examDate: '28.06.2025',
  questions: [
    // General Knowledge
    MockQuestion(
      id: 'p188-1',
      subject: MockSubject.generalKnowledge,
      question: 'Which is the largest stock exchange in the world by market capitalization?',
      options: ['London Stock Exchange', 'Tokyo Stock Exchange', 'NASDAQ', 'New York Stock Exchange (NYSE)'],
      correctIndex: 3,
      topic: 'Finance',
      explanation: 'The New York Stock Exchange is the largest stock exchange in the world by the total market value of the companies listed on it.',
    ),
    MockQuestion(
      id: 'p188-2',
      subject: MockSubject.generalKnowledge,
      question: 'F. E. Chaudhary was a renowned Pakistani in which field?',
      options: ['Painter', 'Poet', 'Photographer', 'Journalist'],
      correctIndex: 2,
      topic: 'History',
      explanation: 'F. E. Chaudhary, known as Chacha Chaudhry, was a pioneering press photographer of Pakistan, whose pictures form a pictorial record of the early years of the country.',
    ),
    MockQuestion(
      id: 'p188-3',
      subject: MockSubject.generalKnowledge,
      question: 'Who founded Microsoft?',
      options: ['Steve Jobs', 'Larry Page and Sergey Brin', 'Bill Gates and Paul Allen', 'Mark Zuckerberg'],
      correctIndex: 2,
      topic: 'Computer',
      explanation: 'Microsoft was founded in 1975 by Bill Gates and Paul Allen.',
    ),
    MockQuestion(
      id: 'p188-4',
      subject: MockSubject.generalKnowledge,
      question: 'What is the term for a type of religious violence in which terrorism is used as a strategy to achieve religious goals, or which is shaped by religious beliefs or identity?',
      options: ['Ethnic cleansing', 'Religious terrorism', 'Political extremism', 'Cultural conflict'],
      correctIndex: 1,
      topic: 'General Knowledge',
      explanation: 'Religious terrorism means violence carried out as a strategy for religious ends, or driven by religious beliefs and identity.',
    ),
    // Pakistan Affairs
    MockQuestion(
      id: 'p188-5',
      subject: MockSubject.pakistanStudies,
      question: 'Who was the Chairman of the National Disaster Management Authority (NDMA) in Pakistan at the time of this paper?',
      options: ['Lieutenant General Akhtar Nawaz Satti', 'Major General Saeed Aleem', 'Lieutenant General Inam Haider Malik', 'Lieutenant General Muhammad Afzal'],
      correctIndex: 2,
      topic: 'Current Affairs',
      explanation: 'Lieutenant General Inam Haider Malik was the Chairman of the NDMA in 2025. In October 2026 he was succeeded as Chairman by Lieutenant General Muhammad Hassan Khattak.',
    ),
    MockQuestion(
      id: 'p188-6',
      subject: MockSubject.pakistanStudies,
      question: 'Who was the Viceroy of India at the time of the Shimla Conference (1945)?',
      options: ['Lord Mountbatten', 'Lord Curzon', 'Lord Wavell', 'Lord Irwin'],
      correctIndex: 2,
      topic: 'History',
      explanation: 'Lord Wavell was Viceroy of India from 1943 to 1947, and he called the Shimla Conference in 1945.',
    ),
    // Everyday Science
    MockQuestion(
      id: 'p188-7',
      subject: MockSubject.everydayScience,
      question: 'Which element is present in abundance in seawater?',
      options: ['Chlorine', 'Oxygen', 'Calcium', 'Iron'],
      correctIndex: 0,
      topic: 'Chemistry',
      explanation: 'Chloride, the dissolved form of chlorine, is the most abundant dissolved ion in seawater, making up over half of the dissolved salts.',
    ),
    MockQuestion(
      id: 'p188-8',
      subject: MockSubject.everydayScience,
      question: 'The muscles in the back compartment of the thigh are collectively known as what?',
      options: ['Quadriceps', 'Adductors', 'Calf muscles', 'Hamstrings'],
      correctIndex: 3,
      topic: 'Biology',
      explanation: 'The hamstrings are the group of muscles at the back of the thigh, while the quadriceps sit at the front.',
    ),
    MockQuestion(
      id: 'p188-9',
      subject: MockSubject.everydayScience,
      question: 'Silicon is used to make what?',
      options: ['Semiconductors', 'Bus', 'Rod', 'None of these'],
      correctIndex: 0,
      topic: 'Chemistry',
      explanation: 'Silicon is the main material used to make semiconductor chips for computers and other electronics.',
    ),
    // Planning
    MockQuestion(
      id: 'p188-10',
      subject: MockSubject.generalKnowledge,
      question: 'Planning is a ______ process.',
      options: ['Goal oriented', 'Flexible', 'Time bound', 'All of these'],
      correctIndex: 3,
      topic: 'Management',
      explanation: 'Planning is goal oriented, flexible enough to adapt, and bound to a time frame, so all of these describe it.',
    ),
    MockQuestion(
      id: 'p188-11',
      subject: MockSubject.generalKnowledge,
      question: 'Strategic planning is which kind of planning?',
      options: ['Long term planning', 'Medium term planning', 'Short term planning', 'Annual planning'],
      correctIndex: 0,
      topic: 'Management',
      explanation: 'Strategic planning sets the long term direction of an organisation, typically over several years.',
    ),
    MockQuestion(
      id: 'p188-12',
      subject: MockSubject.generalKnowledge,
      question: 'The assumptions about the future drawn from forecasting and used in planning are known as what?',
      options: ['Planning premises', 'Freehold premises', 'Business premises', 'Corporate premises'],
      correctIndex: 0,
      topic: 'Management',
      explanation: 'Planning premises are the assumptions about the future, built from forecasting, on which plans are based.',
    ),
    // Mathematics
    MockQuestion(
      id: 'p188-13',
      subject: MockSubject.mathematics,
      question: 'The salaries of A, B and C are in the ratio 2:3:5. If their salaries rise by 15%, 10% and 20% respectively, what will the new ratio of their salaries be?',
      options: ['23 : 33 : 60', '21 : 33 : 55', '24 : 30 : 60', '23 : 30 : 58'],
      correctIndex: 0,
      topic: 'Ratio and Percentage',
      explanation: 'Working: the new salaries are 2 times 1.15, which is 2.30; 3 times 1.10, which is 3.30; and 5 times 1.20, which is 6.00. Multiplying by 10 gives 23 : 33 : 60.',
    ),
    // English
    MockQuestion(
      id: 'p188-14',
      subject: MockSubject.english,
      question: 'Choose the correct verb to complete the sentence: Each one of us ______ a pen.',
      options: ['has', 'have', 'are', 'were'],
      correctIndex: 0,
      topic: 'Grammar',
      explanation: 'Each one is singular, so it takes the singular verb has, giving each one of us has a pen.',
    ),
    MockQuestion(
      id: 'p188-15',
      subject: MockSubject.english,
      question: 'Complete the sentence with the correct auxiliary verb: John loves flying, but we ______.',
      options: ['does not', 'are not', 'has not', 'do not'],
      correctIndex: 3,
      topic: 'Grammar',
      explanation: 'The short reply for the plural subject we with the present simple verb love is do not, with love understood from the first clause.',
    ),
    // Urdu
    MockQuestion(
      id: 'p188-16',
      subject: MockSubject.generalKnowledge,
      question: 'Dubai kis qism ka ism hai?',
      options: ['Ism Nakira', 'Ism Masdar', 'Ism Sifat', 'Ism Marfa'],
      correctIndex: 3,
      topic: 'Urdu Grammar',
      explanation: 'Dubai aik khaas jagah ka naam hai, is liye yeh ism marfa hai, jo kisi khaas shakhs, jagah ya cheez ka naam hota hai.',
    ),
  ],
  latestUpdates: [
    'Latest update (late October 2026): Lieutenant General Inam Haider Malik is no longer the Chairman of the NDMA; he was succeeded in October 2026 by Lieutenant General Muhammad Hassan Khattak.',
  ],
);
