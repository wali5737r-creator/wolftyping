import '../../model/mock_question.dart';
import '../../model/paper_test.dart';

// PRACTICE MATERIAL ONLY.
// This is a practice mock test written in fresh wording for revision.
// It is not an official paper, not a verbatim reproduction of any exam,
// and it does not predict any real exam. Answers were checked against
// general reference facts at build time; where a printed key differed
// from the researched fact, the researched fact was used.

const PaperTest paper202 = PaperTest(
  id: '2025-202',
  paperNo: 202,
  year: 2025,
  post: 'Evaluation Officer (BS-17)',
  department: 'Social Welfare',
  examDate: '2025',
  questions: [
    // General Knowledge
    MockQuestion(
      id: 'p202-1',
      subject: MockSubject.generalKnowledge,
      question: 'When was the International Atomic Energy Agency (IAEA) established?',
      options: ['1956', '1957', '1958', '1960'],
      correctIndex: 1,
      topic: 'International Organisations',
      explanation: 'The statute of the International Atomic Energy Agency came into force in 1957, and the agency began work that year.',
    ),
    MockQuestion(
      id: 'p202-2',
      subject: MockSubject.generalKnowledge,
      question: 'In the word pentathlon, Penta and Athlon mean what?',
      options: ['Six and Power', 'Five and leaf', 'Five and contest', 'Four and Race'],
      correctIndex: 2,
      topic: 'Sports',
      explanation: 'Penta comes from the Greek word for five and athlon means contest, so a pentathlon is a contest of five events.',
    ),
    // Everyday Science
    MockQuestion(
      id: 'p202-3',
      subject: MockSubject.everydayScience,
      question: 'Which elements are electropositive by nature?',
      options: ['Molecules', 'Non-Molecules', 'Metals', 'Non Metals'],
      correctIndex: 2,
      topic: 'Chemistry',
      explanation: 'Metals are electropositive because their atoms readily lose electrons and form positive ions.',
    ),
    // Pakistan Studies
    MockQuestion(
      id: 'p202-4',
      subject: MockSubject.pakistanStudies,
      question: 'What did the Cripps proposals recommend?',
      options: ['Establishment of Indian Union with Dominion status', 'Establishment of three Dominion States', 'Independence of one State', 'Partial Independence'],
      correctIndex: 0,
      topic: 'History',
      explanation: 'The Cripps Mission of 1942 offered an Indian Union with dominion status after the war, with the right for provinces to opt out.',
    ),
    MockQuestion(
      id: 'p202-5',
      subject: MockSubject.pakistanStudies,
      question: 'Who said: If there is any trouble in Asia, the only country that will stand by you is Pakistan, and as long as you remember that, our friendship will grow?',
      options: ['Imran Khan', 'Ayub Khan', 'Bhutto', 'Zia ul Haq'],
      correctIndex: 1,
      topic: 'History',
      explanation: 'The printed key gives this stand-by-you assurance to Ayub Khan, in line with the assurance he gave the United States during his 1961 visit; the wording here is a paraphrase, not a verbatim quotation.',
    ),
    MockQuestion(
      id: 'p202-6',
      subject: MockSubject.pakistanStudies,
      question: 'Which of these is a Sindh party?',
      options: ['MQM', 'ALM', 'PPP', 'All of the above'],
      correctIndex: 3,
      topic: 'Politics',
      explanation: 'Is sawal ka chhapa hua jawab All of the above hai. MQM Sindh se taalluq rakhti hai aur PPP Sindh mein mazboot hai, lekin ALM ki shanakht aik siyasi jamaat ke tor par nahi ho saki aur PPP aik qomi jamaat hai, is liye is sawal ki darja bandi loose hai aur is ki dobara jaanch darkar hai.',
    ),
    // General Knowledge
    MockQuestion(
      id: 'p202-7',
      subject: MockSubject.generalKnowledge,
      question: 'Who played the hero in the film Maula Jutt?',
      options: ['Sultan Rahi', 'Muhammad Ali', 'Waheed Murad', 'Asif Khan'],
      correctIndex: 0,
      topic: 'Film',
      explanation: 'Sultan Rahi played the hero Maula Jatt in the Punjabi film Maula Jatt of 1979.',
    ),
    MockQuestion(
      id: 'p202-8',
      subject: MockSubject.generalKnowledge,
      question: 'Which city and country will host the COP30 meeting?',
      options: ['Dubai, UAE', 'Riyadh, Saudi Arabia', 'Hyderabad, India', 'Belem, Brazil'],
      correctIndex: 3,
      topic: 'Current Affairs',
      explanation: 'COP30, the 2025 United Nations climate conference, was held at Belem in Brazil.',
    ),
    MockQuestion(
      id: 'p202-9',
      subject: MockSubject.generalKnowledge,
      question: 'Which country pledged 108.91 million US dollars to the UN Loss and Damage Fund in 2023?',
      options: ['USA', 'Germany', 'Italy', 'Japan'],
      correctIndex: 2,
      topic: 'Current Affairs',
      explanation: 'At COP28 in December 2023, Italy pledged 100 million euros, equal to 108.91 million US dollars, to the Loss and Damage Fund.',
    ),
    // English
    MockQuestion(
      id: 'p202-10',
      subject: MockSubject.english,
      question: 'I enjoy ___ tennis? Choose the correct word.',
      options: ['Play', 'Playing', 'to play', 'Played'],
      correctIndex: 1,
      topic: 'Grammar',
      explanation: 'The verb enjoy is followed by a gerund, so playing is correct.',
    ),
    MockQuestion(
      id: 'p202-11',
      subject: MockSubject.english,
      question: 'Ahmad suggested, We should abide by a code of conduct, ___? Choose the correct question tag.',
      options: ['Should we', 'Shouldnt we', 'Must we', 'Can we'],
      correctIndex: 1,
      topic: 'Grammar',
      explanation: 'A positive statement with should takes the negative tag shouldnt we.',
    ),
    MockQuestion(
      id: 'p202-12',
      subject: MockSubject.english,
      question: 'He remarked that two and two made four. Which reported form is correct?',
      options: ['He remarked that two and two would make four', 'He remarked that two and two made four', 'He remarked that two and two make four', 'He advised that two and two makes four'],
      correctIndex: 2,
      topic: 'Narration',
      explanation: 'A universal truth stays in the present tense in reported speech, so two and two make four is correct.',
    ),
    MockQuestion(
      id: 'p202-13',
      subject: MockSubject.english,
      question: 'The old lady said to her son, Is it not your duty to help me in my old age? Which indirect form is correct?',
      options: ['The old lady asked her son if it was not his duty to help her in her old age.', 'The old lady asked her son if it were not his duty to have.', 'The old lady said to her son, is it not your duty to help me in my old age?', 'The old lady asked her son if it were not his duty to help her.'],
      correctIndex: 0,
      topic: 'Narration',
      explanation: 'A yes-no question becomes asked with if, the tense moves to the past, and me and my become her.',
    ),
    // General Knowledge
    MockQuestion(
      id: 'p202-14',
      subject: MockSubject.generalKnowledge,
      question: 'CAD stands for what?',
      options: ['Computer Aided Design', 'Computer Assisted Drawing', 'Computer Aided Documents', 'Computer Applied Data'],
      correctIndex: 0,
      topic: 'Computer',
      explanation: 'CAD stands for Computer Aided Design, the use of computers to create and change designs.',
    ),
    MockQuestion(
      id: 'p202-15',
      subject: MockSubject.generalKnowledge,
      question: 'Which of these does not belong to the queues used for processes?',
      options: ['PCB queue', 'Ready queue', 'Job queue', 'Device queue'],
      correctIndex: 0,
      topic: 'Computer',
      explanation: 'Ready, job and device queues are the queues used for processes; a PCB, or process control block, is a data structure that stores process details, not a queue.',
    ),
    // Mathematics
    MockQuestion(
      id: 'p202-16',
      subject: MockSubject.mathematics,
      question: 'A right-angled triangle has area 42 square cm and its perpendicular is 10 cm. Find the base.',
      options: ['4.2 cm', '8.4 cm', '10 cm', '11 cm'],
      correctIndex: 1,
      topic: 'Geometry',
      explanation: 'Working: area equals half the base times the height, so the base equals 2 times 42 divided by 10, which is 8.4 cm.',
    ),
    // Everyday Science
    MockQuestion(
      id: 'p202-17',
      subject: MockSubject.everydayScience,
      question: 'In which condition is the body unable to clot blood?',
      options: ['Haemophilia', 'Anemia', 'Leukemia', 'Scurvy'],
      correctIndex: 0,
      topic: 'Biology',
      explanation: 'Haemophilia is a condition in which the blood does not clot properly because a clotting factor is missing.',
    ),
    // Mathematics
    MockQuestion(
      id: 'p202-18',
      subject: MockSubject.mathematics,
      question: 'Two poles 6 m and 11 m high stand 12 m apart on level ground. Find the distance between their tops.',
      options: ['13 m', '14 m', '15 m', '17 m'],
      correctIndex: 0,
      topic: 'Geometry',
      explanation: 'Working: the difference in height is 5 m, so by Pythagoras the distance between the tops is the square root of 12 squared plus 5 squared, which is the square root of 169, or 13 m.',
    ),
    // Urdu
    MockQuestion(
      id: 'p202-19',
      subject: MockSubject.generalKnowledge,
      question: 'Tarkeeb zameen ka gird-o-nawah ka mafhoom bayan karen.',
      options: ['Dairay qamat', 'Tawil al-qamat', 'Bohat zyada safar karne wala', 'Zameen ka naap'],
      correctIndex: 2,
      topic: 'Urdu Vocabulary',
      explanation: 'Is sawal ka chhapa hua jawab bohat zyada safar karne wala hai; sawal aur jawab ka talluq scan mein wazeh nahi, is liye is ki dobara jaanch darkar hai.',
    ),
    MockQuestion(
      id: 'p202-20',
      subject: MockSubject.generalKnowledge,
      question: 'Jo farosh, gandum numa kise kehte hain?',
      options: ['Aazmaish karne wala', 'Kamil insan', 'Dhoke baz', 'Be-mausam fasal bechne wala'],
      correctIndex: 2,
      topic: 'Urdu Idioms',
      explanation: 'Gandum numa, jao farosh woh shakhs hai jo achhi cheez dikha kar kharab cheez de, yani dhoke baz.',
    ),
  ],
  latestUpdates: [],
);
