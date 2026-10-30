import '../../model/mock_question.dart';
import '../../model/paper_test.dart';

// PRACTICE MATERIAL ONLY.
// This is a practice mock test written in fresh wording for revision.
// It is not an official paper, not a verbatim reproduction of any exam,
// and it does not predict any real exam. Answers were checked against
// general reference facts at build time; where a printed key differed
// from the researched fact, the researched fact was used.

const PaperTest paper204 = PaperTest(
  id: '2025-204',
  paperNo: 204,
  year: 2025,
  post: 'Assistant Director (Stat) (BS-17)',
  department: 'Agriculture Department',
  examDate: '21.09.2025',
  questions: [
    // General Knowledge
    MockQuestion(
      id: 'p204-1', subject: MockSubject.generalKnowledge, question: 'In 1971, was the population of Bangladesh (then East Pakistan) larger or smaller than the population of West Pakistan?',
      options: ['Smaller', 'Equal', 'Greater', 'Unknown'], correctIndex: 2, topic: 'Population',
      explanation: 'In 1971 the population of East Pakistan was about 70 million, larger than the population of West Pakistan at about 58 million, so the eastern wing had the greater population.',
    ),
    MockQuestion(
      id: 'p204-2', subject: MockSubject.generalKnowledge, question: 'How many Sustainable Development Goals did the United Nations adopt in 2015?',
      options: ['15', '17', '21', '29'], correctIndex: 1, topic: 'International Organisations',
      explanation: 'The United Nations adopted 17 Sustainable Development Goals in 2015 as part of the 2030 Agenda.',
    ),
    MockQuestion(
      id: 'p204-3', subject: MockSubject.generalKnowledge, question: 'Which mathematician is regarded as the founder of modern number theory, the field that Gauss described as the queen of mathematics?',
      options: ['Carl Friedrich Gauss', 'Euclid', 'Pierre de Fermat', 'Leonhard Euler'], correctIndex: 2, topic: 'History of Science',
      explanation: 'Pierre de Fermat is regarded as the father of modern number theory, while Gauss is the one who called number theory the queen of mathematics.',
    ),
    MockQuestion(
      id: 'p204-4', subject: MockSubject.generalKnowledge, question: 'Who served as the first President of the United States of America?',
      options: ['Thomas Jefferson', 'Abraham Lincoln', 'George Washington', 'John Adams'], correctIndex: 2, topic: 'World Leaders',
      explanation: 'George Washington served as the first President of the United States, from 1789 to 1797.',
    ),
    MockQuestion(
      id: 'p204-5', subject: MockSubject.generalKnowledge, question: 'In which year was the First Battle of Panipat fought?',
      options: ['1526', '1556', '1761', '1540'], correctIndex: 0, topic: 'History',
      explanation: 'The First Battle of Panipat was fought in 1526, when Babur defeated Ibrahim Lodhi.',
    ),
    MockQuestion(
      id: 'p204-6', subject: MockSubject.generalKnowledge, question: 'Which United Nations Security Council resolution was the first non-procedural resolution passed on the Russian invasion of Ukraine, adopted on 24 February 2025?',
      options: ['Resolution 242', 'Resolution 1325', 'Resolution 2774', 'Resolution 1441'], correctIndex: 2, topic: 'Current Affairs',
      explanation: 'Security Council Resolution 2774 was adopted on 24 February 2025 and was the first non-procedural resolution on the Ukraine conflict to be passed.',
    ),
    MockQuestion(
      id: 'p204-7', subject: MockSubject.everydayScience, question: 'What is the name of the antiviral protein made by cells that have been infected by a virus?',
      options: ['Haemoglobin', 'Insulin', 'Interferon', 'Keratin'], correctIndex: 2, topic: 'Biology',
      explanation: 'Interferon is the antiviral protein produced by virus-infected cells to warn nearby cells and slow the spread of infection.',
    ),
    MockQuestion(
      id: 'p204-8', subject: MockSubject.generalKnowledge, question: 'In computing, what does overclocking mean?',
      options: ['Reducing the speed of the processor to save energy', 'Formatting the hard drive for better performance', 'Increasing the clock speed of the CPU or GPU beyond factory settings', 'Locking the computer to prevent overheating'], correctIndex: 2, topic: 'Computer',
      explanation: 'Overclocking means running a CPU or GPU at a clock speed higher than the factory setting, to gain extra performance.',
    ),
    MockQuestion(
      id: 'p204-9', subject: MockSubject.generalKnowledge, question: 'Which force did Punjab launch as its first dedicated body to fight the drug menace?',
      options: ['Anti-Drug Tribunal', 'Narcotics Control Bureau', 'Counter Narcotics Force (CNF)', 'Drug Enforcement Squad'], correctIndex: 2, topic: 'Current Affairs',
      explanation: 'Punjab launched the Counter Narcotics Force (CNF) as its dedicated force against drugs.',
    ),
    // Mathematics
    MockQuestion(
      id: 'p204-10', subject: MockSubject.mathematics, question: 'A car travels at 50 miles per hour. How far will it travel in 2.5 hours?',
      options: ['100 miles', '125 miles', '150 miles', '170 miles'], correctIndex: 1, topic: 'Speed and Distance',
      explanation: 'Distance equals speed multiplied by time, so 50 multiplied by 2.5 equals 125 miles.',
    ),
    MockQuestion(
      id: 'p204-11', subject: MockSubject.mathematics, question: 'A boy walking at 4 km per hour reaches school 30 minutes late, and walking at 5 km per hour he reaches 15 minutes early. What is the distance from his home to school?',
      options: ['5 km', '10 km', '15 km', '20 km'], correctIndex: 2, topic: 'Speed and Distance',
      explanation: 'Let the distance be d km. Then d divided by 4 minus d divided by 5 equals 0.75 hours, which gives d equal to 15 km.',
    ),
    // English
    MockQuestion(
      id: 'p204-12', subject: MockSubject.english, question: 'In the sentence "The cat ran down the stairs", what part of speech is the word "down"?',
      options: ['Noun', 'Verb', 'Adjective', 'Preposition'], correctIndex: 3, topic: 'Grammar',
      explanation: 'Here "down" shows the relation between the running and the stairs, so it works as a preposition.',
    ),
    MockQuestion(
      id: 'p204-13', subject: MockSubject.english, question: 'What does the idiom "to pay through the nose" mean?',
      options: ['To pay too much money for something', 'Speaking or writing in an ironic or insincere way', 'Be left with an unwelcome responsibility', 'None of these'], correctIndex: 0, topic: 'Idioms',
      explanation: 'To pay through the nose means to pay far too much money for something.',
    ),
    MockQuestion(
      id: 'p204-14', subject: MockSubject.english, question: 'It rained heavily. ______ the football match was cancelled. Which word fits the blank?',
      options: ['Therefore', 'Although', 'Because', 'Unless'], correctIndex: 0, topic: 'Grammar',
      explanation: 'The second sentence gives the result of the heavy rain, so "therefore" is the fitting link word.',
    ),
    MockQuestion(
      id: 'p204-15', subject: MockSubject.english, question: 'Breeze is to hurricane as swirl is to which of the following? Choose the pair with the same weak-to-strong relation.',
      options: ['Warmth is to coldness', 'Swirl is to maelstrom', 'Day is to week', 'Downpour is to drizzle'], correctIndex: 1, topic: 'Analogy',
      explanation: 'A breeze is a weak wind and a hurricane is a very strong wind, just as a swirl is a weak whirl and a maelstrom is a very strong whirl.',
    ),
    // Urdu
    MockQuestion(
      id: 'p204-16', subject: MockSubject.generalKnowledge, question: 'Urdu: Aise alfaz jin ke maani aik jaise hon magar talaffuz aur spellings mukhtalif hon, kya kehlate hain?',
      options: ['Mutradif', 'Mutazad', 'Hum Awaz', 'In mein se koi nahi'], correctIndex: 0, topic: 'Urdu Grammar',
      explanation: 'Aise alfaz mutradif kehlate hain, kyun ke un ke maani aik jaise hote hain jab ke talaffuz mukhtalif hota hai.',
    ),
    MockQuestion(
      id: 'p204-17', subject: MockSubject.generalKnowledge, question: 'Urdu: "Udas Naslain" kis ka nawal hai?',
      options: ['Abdullah Hussain', 'Mumtaz Masood', 'Mumtaz Mufti', 'Ashfaq Ahmed'], correctIndex: 0, topic: 'Urdu Literature',
      explanation: 'Udas Naslain Abdullah Hussain ka mashhoor nawal hai.',
    ),
    MockQuestion(
      id: 'p204-18', subject: MockSubject.generalKnowledge, question: 'Urdu: Istilah "Yad-e-Tula rakhna" se kya murad hai?',
      options: ['Lambe haath hona', 'Kisi kaam mein mukammal maharat ya uboor hona', 'Doosron par zulm karna', 'Tez raftari se kaam karna'], correctIndex: 1, topic: 'Urdu Idioms',
      explanation: 'Yad-e-Tula rakhna ka matlab hai kisi kaam mein mukammal maharat aur uboor rakhna.',
    ),
  ],
  latestUpdates: [],
);
