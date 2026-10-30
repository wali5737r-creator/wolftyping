import '../../model/mock_question.dart';
import '../../model/paper_test.dart';

// PRACTICE MATERIAL ONLY.
// This is a practice mock test written in fresh wording for revision.
// It is not an official paper, not a verbatim reproduction of any exam,
// and it does not predict any real exam. Answers were checked against
// general reference facts at build time; where a printed key differed
// from the researched fact, the researched fact was used.

const PaperTest paper166 = PaperTest(
  id: '2025-166',
  paperNo: 166,
  year: 2025,
  post: 'Statistical Officer (BS-17)',
  department: 'Social Welfare & Bait-ul-Maal Department',
  examDate: '24.02.2025',
  questions: [
    // General Knowledge
    MockQuestion(
      id: 'p166-1',
      subject: MockSubject.generalKnowledge,
      question: 'Who is the author of the Harry Potter series?',
      options: ['J. R. R. Tolkien', 'George R. R. Martin', 'C. S. Lewis', 'J. K. Rowling'],
      correctIndex: 3,
      topic: 'Literature',
      explanation: 'The Harry Potter books were written by J. K. Rowling.',
    ),
    MockQuestion(
      id: 'p166-2',
      subject: MockSubject.generalKnowledge,
      question: 'What is the main job of the International Monetary Fund (IMF)?',
      options: ['Lending to private individuals', 'Setting world oil prices', 'Controlling world trade', 'Giving member countries financial help and backing economic stability'],
      correctIndex: 3,
      topic: 'International Organisations',
      explanation: 'The IMF gives financial assistance to member countries and works for their economic stability.',
    ),
    MockQuestion(
      id: 'p166-3',
      subject: MockSubject.generalKnowledge,
      question: 'In a hockey match, how is play restarted when the ball gets stuck in the goalkeeper pads by accident?',
      options: ['Penalty stroke', 'Free hit', 'Bully', 'Penalty corner'],
      correctIndex: 3,
      topic: 'Sports',
      explanation: 'When the ball is accidentally trapped in the goalkeeper pads, the game restarts with a penalty corner; a deliberate trap gives a penalty stroke.',
    ),
    // Pakistan Studies
    MockQuestion(
      id: 'p166-4',
      subject: MockSubject.pakistanStudies,
      question: 'In which year was the first agricultural reform introduced in Pakistan?',
      options: ['1948', '1959', '1951', '1972'],
      correctIndex: 1,
      topic: 'History',
      explanation: 'The first land reforms in Pakistan were introduced in 1959 under Ayub Khan.',
    ),
    MockQuestion(
      id: 'p166-5',
      subject: MockSubject.pakistanStudies,
      question: 'In which year was the Pakistan-China border agreement signed?',
      options: ['1963', '1956', '1971', '1982'],
      correctIndex: 0,
      topic: 'History',
      explanation: 'Pakistan and China signed their border agreement in 1963, settling the boundary in the north.',
    ),
    MockQuestion(
      id: 'p166-6',
      subject: MockSubject.pakistanStudies,
      question: 'In which year was the All-Parties Conference held that led to the Nehru Report?',
      options: ['1928', '1930', '1940', '1946'],
      correctIndex: 0,
      topic: 'History',
      explanation: 'The All-Parties Conference met in 1928 in response to the Simon Commission and produced the Nehru Report.',
    ),
    // Everyday Science
    MockQuestion(
      id: 'p166-7',
      subject: MockSubject.everydayScience,
      question: 'About what share of the land surface of the Earth is covered by sedimentary rocks?',
      options: ['75%', '50%', '65%', '85%'],
      correctIndex: 0,
      topic: 'Geology',
      explanation: 'Sedimentary rocks cover about 75 percent of the land surface of the Earth.',
    ),
    MockQuestion(
      id: 'p166-8',
      subject: MockSubject.everydayScience,
      question: 'In which year was Sputnik 1, the first artificial satellite, launched?',
      options: ['1947', '1957', '1953', '1963'],
      correctIndex: 1,
      topic: 'Space',
      explanation: 'The Soviet Union launched Sputnik 1, the first artificial satellite, in 1957.',
    ),
    MockQuestion(
      id: 'p166-9',
      subject: MockSubject.everydayScience,
      question: 'What is the chemical formula of sucrose, the sugar used in the home?',
      options: ['C2H6O', 'C6H12O6', 'CH4', 'C12H22O11'],
      correctIndex: 3,
      topic: 'Chemistry',
      explanation: 'Sucrose has the formula C12H22O11; C6H12O6 is glucose and C2H6O is ethanol.',
    ),
    MockQuestion(
      id: 'p166-10',
      subject: MockSubject.everydayScience,
      question: 'The mole is the unit of which quantity?',
      options: ['Temperature', 'Amount of substance', 'Mass', 'Light intensity'],
      correctIndex: 1,
      topic: 'Physics',
      explanation: 'The mole is the SI unit for amount of substance, counting a fixed number of particles.',
    ),
    // Computer
    MockQuestion(
      id: 'p166-11',
      subject: MockSubject.generalKnowledge,
      question: 'What is the source of the data a computer works on?',
      options: ['Both hardware and software', 'Hardware only', 'Software only', 'Neither hardware nor software'],
      correctIndex: 0,
      topic: 'Computer',
      explanation: 'Computer data comes from both the hardware that feeds it in and the software that handles it, so both are the source.',
    ),
    // English
    MockQuestion(
      id: 'p166-12',
      subject: MockSubject.english,
      question: 'Cat is to kitten as woman is to what, in the same young-one relation?',
      options: ['Baby', 'Puppy', 'Colt', 'Cub'],
      correctIndex: 0,
      topic: 'Analogy',
      explanation: 'A kitten is the young of a cat, and a baby is the young of a woman, so baby matches the relation.',
    ),
    MockQuestion(
      id: 'p166-13',
      subject: MockSubject.english,
      question: 'Which word is closest in meaning to defer, in the sense of putting something off?',
      options: ['Postpone', 'Defy', 'Differ', 'Indifferent'],
      correctIndex: 0,
      topic: 'Vocabulary',
      explanation: 'To defer, in this sense, is to put off to a later time, so postpone is the closest in meaning.',
    ),
    // Urdu Literature
    MockQuestion(
      id: 'p166-14',
      subject: MockSubject.generalKnowledge,
      question: 'Sir Syed Ahmed Khan ka kirdar kis novel mein dikhaya gaya hai?',
      options: ['Aag Ka Darya', 'Raja Gidh', 'Alif', 'Khas-o-Khashak Zamanay'],
      correctIndex: 3,
      topic: 'Urdu Literature',
      explanation: 'Khas-o-Khashak Zamanay is Mustansar Hussain Tarar\'s long novel spanning Punjab from 1939 to 2009.',
    ),
    MockQuestion(
      id: 'p166-15',
      subject: MockSubject.generalKnowledge,
      question: 'Aag Ka Darya kis ka novel hai?',
      options: ['Naseem Hijazi', 'Bano Qudsia', 'Intizar Hussain', 'Qurratulain Hyder'],
      correctIndex: 3,
      topic: 'Urdu Literature',
      explanation: 'Aag Ka Darya is the celebrated novel by Qurratulain Hyder, first published in 1959.',
    ),
  ],
  latestUpdates: [],
);
