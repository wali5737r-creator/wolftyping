import '../../model/mock_question.dart';
import '../../model/paper_test.dart';

// PRACTICE MATERIAL ONLY.
// This is a practice mock test written in fresh wording for revision.
// It is not an official paper, not a verbatim reproduction of any exam,
// and it does not predict any real exam. Answers were checked against
// general reference facts at build time; where a printed key differed
// from the researched fact, the researched fact was used.

const PaperTest paper183 = PaperTest(
  id: '2025-183',
  paperNo: 183,
  year: 2025,
  post: 'Internal Audit Specialist (BS-18)',
  department: 'Punjab Revenue Authority, Finance Department',
  examDate: '31.05.2025',
  questions: [
    // General Knowledge
    MockQuestion(
      id: 'p183-1',
      subject: MockSubject.generalKnowledge,
      question: 'In which city is the Potala Palace situated?',
      options: ['Lhasa, Tibet', 'Kathmandu, Nepal', 'Thimphu, Bhutan', 'New Delhi, India'],
      correctIndex: 0,
      topic: 'Geography',
      explanation: 'The Potala Palace stands in Lhasa, Tibet, where it was the winter home of the Dalai Lamas.',
    ),
    MockQuestion(
      id: 'p183-2',
      subject: MockSubject.generalKnowledge,
      question: 'Capital budgeting deals mainly with which kind of assets?',
      options: ['Long term assets', 'Short term assets', 'Long term and short term assets', 'Fixed assets only'],
      correctIndex: 0,
      topic: 'Finance',
      explanation: 'Capital budgeting is the planning of long term investment in assets such as plant and machinery, so long term assets are its main concern.',
    ),
    MockQuestion(
      id: 'p183-3',
      subject: MockSubject.generalKnowledge,
      question: 'In the convention used in this paper, how often are dividends paid to shareholders?',
      options: ['Monthly', 'Quarterly', 'Half yearly', 'Yearly'],
      correctIndex: 3,
      topic: 'Finance',
      explanation: 'In the convention used in this paper, dividends are treated as a yearly payment, although in practice companies may also pay interim dividends during a year.',
    ),
    // Pakistan Affairs
    MockQuestion(
      id: 'p183-4',
      subject: MockSubject.pakistanStudies,
      question: 'Shaista Ikramullah is best described as which of the following?',
      options: ['A politician only', 'An author only', 'A diplomat only', 'A politician, author and diplomat'],
      correctIndex: 3,
      topic: 'History',
      explanation: 'Shaista Ikramullah was a politician, an author, and a diplomat, serving as a member of the Constituent Assembly and as ambassador to Morocco and other countries.',
    ),
    // Current Affairs
    MockQuestion(
      id: 'p183-5',
      subject: MockSubject.generalKnowledge,
      question: 'What was the official theme of World Environment Day 2025?',
      options: ['Ecosystem Restoration', 'Only One Earth', 'Putting an End to Plastic Pollution', 'Solutions to Biodiversity Loss'],
      correctIndex: 2,
      topic: 'Current Affairs',
      explanation: 'World Environment Day 2025, marked on 5 June, had the theme of ending plastic pollution, expressed as putting an end to plastic pollution.',
    ),
    // Geography
    MockQuestion(
      id: 'p183-6',
      subject: MockSubject.generalKnowledge,
      question: 'Pakistan lies in which region of the world?',
      options: ['Middle East', 'South Asia', 'Central Asia', 'East Asia'],
      correctIndex: 1,
      topic: 'Geography',
      explanation: 'Pakistan is a country of South Asia, sharing borders with India, Afghanistan, Iran and China.',
    ),
    // Everyday Science
    MockQuestion(
      id: 'p183-7',
      subject: MockSubject.everydayScience,
      question: 'Which river is most widely known for severe pollution and the environmental problems it causes?',
      options: ['Amazon River', 'Nile River', 'Thames River', 'Ganges River'],
      correctIndex: 3,
      topic: 'Environment',
      explanation: 'The Ganges is widely reported as one of the most polluted rivers in the world, carrying large loads of sewage and industrial waste.',
    ),
    MockQuestion(
      id: 'p183-8',
      subject: MockSubject.everydayScience,
      question: 'Marie Curie is best known for her work in which field?',
      options: ['Electricity', 'Radioactivity', 'Thermodynamics', 'Genetics'],
      correctIndex: 1,
      topic: 'Science',
      explanation: 'Marie Curie pioneered research on radioactivity, a term she helped to coin, and won Nobel Prizes in physics and chemistry for that work.',
    ),
    // Mathematics
    MockQuestion(
      id: 'p183-9',
      subject: MockSubject.mathematics,
      question: 'What is the nth term of the sequence 5, 25, 125, 625, ...?',
      options: ['5 raised to the power n', '25 raised to the power n', 'n raised to the power 5', '5 times n'],
      correctIndex: 0,
      topic: 'Sequences',
      explanation: 'Each term is a power of 5: 5 is 5 to the power 1, 25 is 5 to the power 2, 125 is 5 to the power 3, and 625 is 5 to the power 4, so the nth term is 5 raised to the power n.',
    ),
    // English
    MockQuestion(
      id: 'p183-10',
      subject: MockSubject.english,
      question: 'Choose the correct indirect narration: Diana said, "Hurrah! We have won the match."',
      options: ['Diana said with joy that they have won the match.', 'Diana exclaimed with sorrow that they had won the match.', 'Diana said that they had won the match.', 'Diana exclaimed with joy that they had won the match.'],
      correctIndex: 3,
      topic: 'Narration',
      explanation: 'Hurrah expresses joy, so said becomes exclaimed with joy, and the present perfect have won shifts back to the past perfect had won in indirect speech.',
    ),
    MockQuestion(
      id: 'p183-11',
      subject: MockSubject.english,
      question: 'Choose the correct indirect narration of the sentence: She said, "The Earth revolves around the Sun."',
      options: ['She said that the Earth revolved around the Sun.', 'She said that the Earth had revolved around the Sun.', 'She said that the Earth revolves around the Sun.', 'She said that the Earth is revolving around the Sun.'],
      correctIndex: 2,
      topic: 'Narration',
      explanation: 'A universal truth keeps its present tense in indirect speech, so revolves stays as revolves.',
    ),
    // Urdu
    MockQuestion(
      id: 'p183-12',
      subject: MockSubject.generalKnowledge,
      question: 'Allama Iqbal ki pehli shaya hone wali nazm kaun si thi?',
      options: ['Khizr-e-Rah', 'Shikwa', 'Himala', 'Lab pe aati hai dua'],
      correctIndex: 2,
      topic: 'Urdu Literature',
      explanation: 'Iqbal ki pehli shaya hone wali nazm Himala thi, jo 1901 mein shaya hui.',
    ),
    MockQuestion(
      id: 'p183-13',
      subject: MockSubject.generalKnowledge,
      question: 'Shaukat Siddiqui ke mashhoor novel Khuda Ki Basti ka taalluq kis sheher se hai?',
      options: ['Lahore', 'Lucknow', 'Delhi', 'Karachi'],
      correctIndex: 3,
      topic: 'Urdu Literature',
      explanation: 'Khuda Ki Basti ki kahani Karachi ke ghareeb mohallon ki zindagi par mabni hai, is liye is ka taalluq Karachi se hai.',
    ),
    MockQuestion(
      id: 'p183-14',
      subject: MockSubject.generalKnowledge,
      question: 'Shibli Nomani ne Darul Musannifin Academy kis sheher mein qaim ki thi?',
      options: ['Delhi', 'Lucknow', 'Azamgarh', 'Aligarh'],
      correctIndex: 2,
      topic: 'Urdu Literature',
      explanation: 'Shibli Nomani ne Darul Musannifin Shibli Academy Azamgarh mein qaim ki thi, jo Urdu tehqeeq ka aik aham markaz bana.',
    ),
    MockQuestion(
      id: 'p183-15',
      subject: MockSubject.generalKnowledge,
      question: 'Tifl-e-Maktab se kya murad hai?',
      options: ['Karigar', 'Mahir', 'Natajurbah kar', 'Honhaar bacha'],
      correctIndex: 2,
      topic: 'Urdu Vocabulary',
      explanation: 'Tifl-e-Maktab se murad woh shakhs hai jo abhi seekhne ke marhale mein ho, yani natajurbah kar.',
    ),
  ],
);
