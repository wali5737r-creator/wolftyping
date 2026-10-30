import '../../model/mock_question.dart';
import '../../model/paper_test.dart';

// PRACTICE MATERIAL ONLY.
// This is a practice mock test written in fresh wording for revision.
// It is not an official paper, not a verbatim reproduction of any exam,
// and it does not predict any real exam. Answers were checked against
// general reference facts at build time; where a printed key differed
// from the researched fact, the researched fact was used.

const PaperTest paper187 = PaperTest(
  id: '2025-187',
  paperNo: 187,
  year: 2025,
  post: 'Assistant Executive Engineer / SDO / Assistant Design Engineer (BS-17)',
  department: 'Irrigation Department',
  examDate: '24.02.2025',
  questions: [
    // General Knowledge
    MockQuestion(
      id: 'p187-1',
      subject: MockSubject.generalKnowledge,
      question: 'Hazara University is located in which city?',
      options: ['Abbottabad', 'Mansehra', 'Peshawar', 'Swat'],
      correctIndex: 1,
      topic: 'Geography',
      explanation: 'Hazara University has its main campus at Dhodial, near Mansehra in Khyber Pakhtunkhwa.',
    ),
    MockQuestion(
      id: 'p187-2',
      subject: MockSubject.generalKnowledge,
      question: 'In which year was the zipper invented?',
      options: ['1851', '1893', '1905', '1923'],
      correctIndex: 1,
      topic: 'Inventions',
      explanation: 'Whitcomb Judson patented his clasp locker, the forerunner of the modern zipper, in 1893.',
    ),
    MockQuestion(
      id: 'p187-3',
      subject: MockSubject.generalKnowledge,
      question: 'Indra Nooyi, a renowned businesswoman and former chief executive of PepsiCo, is originally from which country?',
      options: ['United States', 'India', 'Sri Lanka', 'Bangladesh'],
      correctIndex: 1,
      topic: 'General Knowledge',
      explanation: 'Indra Nooyi was born in Chennai, India, and later became a citizen of the United States.',
    ),
    // Pakistan Affairs
    MockQuestion(
      id: 'p187-4',
      subject: MockSubject.pakistanStudies,
      question: 'The 1992 Cricket World Cup was won by which country?',
      options: ['England', 'Australia', 'Pakistan', 'India'],
      correctIndex: 2,
      topic: 'Sports',
      explanation: 'Pakistan won the 1992 Cricket World Cup in Australia and New Zealand, beating England in the final at Melbourne.',
    ),
    MockQuestion(
      id: 'p187-5',
      subject: MockSubject.pakistanStudies,
      question: 'Tarbela Dam was completed in which year?',
      options: ['1965', '1968', '1976', '1982'],
      correctIndex: 2,
      topic: 'History',
      explanation: 'Construction of Tarbela Dam began in 1968 and the dam was completed in 1976, on the Indus River in Khyber Pakhtunkhwa.',
    ),
    // General Knowledge
    MockQuestion(
      id: 'p187-6',
      subject: MockSubject.generalKnowledge,
      question: 'What is the name given to the series of mass protests that began in several Arab countries in 2010?',
      options: ['Arab Uprising', 'Arab Revolution', 'Islamic Awakening', 'Arab Spring'],
      correctIndex: 3,
      topic: 'History',
      explanation: 'The wave of protests across Arab countries from late 2010 is widely known as the Arab Spring.',
    ),
    MockQuestion(
      id: 'p187-7',
      subject: MockSubject.pakistanStudies,
      question: 'The Makran and Kharan regions were formally brought together with the Balochistan States Union in which year?',
      options: ['1947', '1948', '1952', '1957'],
      correctIndex: 2,
      topic: 'History',
      explanation: 'In 1952 the states of Kalat, Kharan, Makran and Las Bela were joined in the Baluchistan States Union, which later merged into West Pakistan.',
    ),
    MockQuestion(
      id: 'p187-8',
      subject: MockSubject.pakistanStudies,
      question: 'The Dyarchy system introduced in British India was based on which idea?',
      options: ['Centralization of power', 'Martial law', 'Religious division', 'Provincial autonomy'],
      correctIndex: 3,
      topic: 'History',
      explanation: 'Dyarchy, introduced by the Government of India Act 1919, divided provincial subjects between elected ministers and the governor, as a step toward provincial autonomy.',
    ),
    // Everyday Science
    MockQuestion(
      id: 'p187-9',
      subject: MockSubject.everydayScience,
      question: 'One nanometer is equal to how many meters?',
      options: ['10 to the power -6 meters', '10 to the power -9 meters', '10 to the power -3 meters', '10 to the power -12 meters'],
      correctIndex: 1,
      topic: 'Physics',
      explanation: 'One nanometer is one billionth of a meter, that is 10 to the power -9 meters.',
    ),
    MockQuestion(
      id: 'p187-10',
      subject: MockSubject.everydayScience,
      question: 'Selenium, a trace element, works closely with which vitamin in the body?',
      options: ['Vitamin A', 'Vitamin C', 'Vitamin E', 'Vitamin I'],
      correctIndex: 2,
      topic: 'Biology',
      explanation: 'Selenium works together with vitamin E as part of the antioxidant defences of the body.',
    ),
    MockQuestion(
      id: 'p187-11',
      subject: MockSubject.everydayScience,
      question: 'When a star starts fusing helium into carbon, it becomes what?',
      options: ['Red giant', 'Supernova', 'Neutron star', 'White Dwarf'],
      correctIndex: 0,
      topic: 'Astronomy',
      explanation: 'After hydrogen in its core runs out, a star like the Sun swells into a red giant, and helium fusion into carbon takes place in that red giant phase.',
    ),
    // Computer
    MockQuestion(
      id: 'p187-12',
      subject: MockSubject.generalKnowledge,
      question: 'The first generation of computers used which technology?',
      options: ['Transistors', 'Microprocessors', 'Vacuum Tubes', 'Integrated Circuits'],
      correctIndex: 2,
      topic: 'Computer',
      explanation: 'First generation computers, built in the 1940s and 1950s, used vacuum tubes for their circuits.',
    ),
    MockQuestion(
      id: 'p187-13',
      subject: MockSubject.generalKnowledge,
      question: 'Which memory has the shortest access time, that is, the fastest memory?',
      options: ['RAM', 'Cache memory', 'Hard Disk', 'Register'],
      correctIndex: 3,
      topic: 'Computer',
      explanation: 'Registers sit inside the processor itself, so they are faster to access than cache memory, RAM or a hard disk.',
    ),
    // Mathematics
    MockQuestion(
      id: 'p187-14',
      subject: MockSubject.mathematics,
      question: 'Complete the series: 1, 1, 8, 4, 27, 9, ?, ? Which number comes first among the two missing terms?',
      options: ['36', '64', '81', '125'],
      correctIndex: 1,
      topic: 'Sequences',
      explanation: 'Working: the odd positions 1, 8, 27 are the cubes 1, 2 and 3 cubed, so the next is 4 cubed, which is 64; the even positions 1, 4, 9 are the squares 1, 2 and 3 squared.',
    ),
    // English
    MockQuestion(
      id: 'p187-15',
      subject: MockSubject.english,
      question: 'Change the narration: He told her, "I want to meet your father."',
      options: ['He told her that I want to meet your father.', 'He told her that he wanted to meet her father.', 'He told her that he wanted to meet your father.', 'He told her that she wanted to meet her father.'],
      correctIndex: 1,
      topic: 'Narration',
      explanation: 'In indirect speech, I becomes he, want becomes wanted, and your becomes her, so he told her that he wanted to meet her father is correct.',
    ),
    MockQuestion(
      id: 'p187-16',
      subject: MockSubject.english,
      question: 'Choose the passive voice of: "Sajid gave the beggar an old shirt."',
      options: ['An old shirt was given to Sajid by the beggar.', 'An old shirt was given to the beggar by Sajid.', 'The beggar was gave an old shirt by Sajid.', 'An old shirt was gave to the beggar by Sajid.'],
      correctIndex: 1,
      topic: 'Passive Voice',
      explanation: 'In the passive form the object, an old shirt, becomes the subject, and the doer, Sajid, follows by, giving an old shirt was given to the beggar by Sajid.',
    ),
    MockQuestion(
      id: 'p187-17',
      subject: MockSubject.english,
      question: 'The teacher spoke ______ to me.',
      options: ['Gently', 'Politely', 'Rudely', 'Loudly'],
      correctIndex: 1,
      topic: 'Grammar',
      explanation: 'Politely is the idiomatic adverb for the manner of speaking to someone, so the teacher spoke politely to me is the expected answer.',
    ),
    // Islamiat
    MockQuestion(
      id: 'p187-18',
      subject: MockSubject.islamiat,
      question: 'Ramadan is the ______ month of the Islamic (Hijri) calendar.',
      options: ['7th', '8th', '9th', '12th'],
      correctIndex: 2,
      topic: 'Islamic Calendar',
      explanation: 'Ramadan is the ninth month of the Islamic Hijri calendar, the month of fasting.',
    ),
    // Urdu
    MockQuestion(
      id: 'p187-19',
      subject: MockSubject.generalKnowledge,
      question: 'Mirza Ghalib kahan paida hue?',
      options: ['Lahore', 'Calcutta', 'Agra', 'Delhi'],
      correctIndex: 2,
      topic: 'Urdu Literature',
      explanation: 'Mirza Ghalib 1797 mein Agra mein paida hue, aur baad mein Delhi mein rehne lage.',
    ),
    MockQuestion(
      id: 'p187-20',
      subject: MockSubject.generalKnowledge,
      question: '"Ye pani Multan beh gaya hai" ka kya matlab hai?',
      options: ['Pani ka zaya ho jana', 'Pani ki qillat', 'Waqt ya mauqa ka zaya ho jana', 'Pani ka door beh jana'],
      correctIndex: 2,
      topic: 'Urdu Idioms',
      explanation: 'Is muhawre ka matlab hai ke waqt ya mauqa haath se nikal gaya aur zaya ho gaya.',
    ),
  ],
);
