import '../../model/mock_question.dart';
import '../../model/paper_test.dart';

// PRACTICE MATERIAL ONLY.
// This is a practice mock test written in fresh wording for revision.
// It is not an official paper, not a verbatim reproduction of any exam,
// and it does not predict any real exam. Answers were checked against
// general reference facts at build time; where a printed key differed
// from the researched fact, the researched fact was used.

const PaperTest paper185 = PaperTest(
  id: '2025-185',
  paperNo: 185,
  year: 2025,
  post: 'Planning Officer (BS-17)',
  department: 'Specialized Healthcare and Medical Education Department',
  examDate: '22.06.2025',
  questions: [
    // General Knowledge
    MockQuestion(
      id: 'p185-1',
      subject: MockSubject.generalKnowledge,
      question: 'Which country first developed the military tank?',
      options: ['Britain', 'Germany', 'United States', 'Russia'],
      correctIndex: 0,
      topic: 'History',
      explanation: 'Britain developed the first tanks during the First World War, using them in battle on the Somme in 1916.',
    ),
    MockQuestion(
      id: 'p185-2',
      subject: MockSubject.generalKnowledge,
      question: 'Who invented the movable type printing press?',
      options: ['Isaac Newton', 'Johannes Gutenberg', 'Leonardo da Vinci', 'Thomas Edison'],
      correctIndex: 1,
      topic: 'History',
      explanation: 'Johannes Gutenberg of Germany built the movable type printing press in the 15th century, which made books far cheaper to produce.',
    ),
    // Pakistan Affairs
    MockQuestion(
      id: 'p185-3',
      subject: MockSubject.pakistanStudies,
      question: 'Maleeha Lodhi has served as a former ambassador or representative of Pakistan to which of the following?',
      options: ['United States (US)', 'United Nations (UN)', 'United Kingdom (UK)', 'All of these'],
      correctIndex: 3,
      topic: 'History',
      explanation: 'Maleeha Lodhi served as ambassador to the United States and to the United Kingdom, and as permanent representative to the United Nations.',
    ),
    // General Knowledge
    MockQuestion(
      id: 'p185-4',
      subject: MockSubject.generalKnowledge,
      question: 'The 2025 World Aquatics Championships were held in which country?',
      options: ['Hungary', 'Singapore', 'Japan', 'Qatar'],
      correctIndex: 1,
      topic: 'Sports',
      explanation: 'The 2025 World Aquatics Championships took place in Singapore in July and August 2025.',
    ),
    MockQuestion(
      id: 'p185-5',
      subject: MockSubject.generalKnowledge,
      question: 'The Sassanid Empire was brought to an end by which power?',
      options: ['Roman Empire', 'Mongol Empire', 'Ottoman Empire', 'Rashidun Caliphate'],
      correctIndex: 3,
      topic: 'History',
      explanation: 'The Sassanid Empire fell to the armies of the Rashidun Caliphate in the 7th century, ending with the defeat of Yazdegerd III.',
    ),
    MockQuestion(
      id: 'p185-6',
      subject: MockSubject.pakistanStudies,
      question: 'Pakistan shares its longest land border with which country?',
      options: ['China', 'Afghanistan', 'Iran', 'India'],
      correctIndex: 3,
      topic: 'Geography',
      explanation: 'The border with India, about 3,323 kilometres including the Line of Control, is longer than the border with Afghanistan, about 2,640 kilometres along the Durand Line, so India is the longest land border of Pakistan.',
    ),
    MockQuestion(
      id: 'p185-7',
      subject: MockSubject.generalKnowledge,
      question: 'A loop that holds another loop inside its body is called what?',
      options: ['Infinite Loop', 'Nested Loop', 'Recursive Loop', 'Inner Loop'],
      correctIndex: 1,
      topic: 'Computer',
      explanation: 'A loop placed inside the body of another loop is called a nested loop.',
    ),
    MockQuestion(
      id: 'p185-8',
      subject: MockSubject.generalKnowledge,
      question: 'What is animation, in the sense used in computer graphics?',
      options: ['Accelerated static images', 'Print out', 'Changing the pictures in a graph', 'To make a picture'],
      correctIndex: 0,
      topic: 'Computer',
      explanation: 'Animation shows a sequence of still images in rapid succession, so the still pictures appear to move.',
    ),
    // English
    MockQuestion(
      id: 'p185-9',
      subject: MockSubject.english,
      question: 'Bill has not finished his work, but we ______.',
      options: ['have', 'has', 'did', 'have not'],
      correctIndex: 0,
      topic: 'Grammar',
      explanation: 'The short reply keeps the same auxiliary with the plural subject we, so we have is correct, with finished understood from the first clause.',
    ),
    MockQuestion(
      id: 'p185-10',
      subject: MockSubject.english,
      question: 'Select the most appropriate synonym of the word Calamity.',
      options: ['Fortune', 'Disaster', 'Windfall', 'Prosperity'],
      correctIndex: 1,
      topic: 'Vocabulary',
      explanation: 'A calamity is an event that causes great harm, so disaster is its closest synonym.',
    ),
    MockQuestion(
      id: 'p185-11',
      subject: MockSubject.english,
      question: 'Transform the sentence into indirect speech. He said to me, "May you be happy."',
      options: ['He said to me that I may be happy.', 'He wished me that I might be happy.', 'He wished me that you might be happy.', 'He said to me that I might being happy.'],
      correctIndex: 1,
      topic: 'Narration',
      explanation: 'A wish in direct speech is reported with wished, and may becomes might, with you changing to I, so he wished me that I might be happy is correct.',
    ),
    MockQuestion(
      id: 'p185-12',
      subject: MockSubject.english,
      question: 'Air is to fly as water is to:',
      options: ['Drink', 'Swim', 'Dive', 'Float'],
      correctIndex: 1,
      topic: 'Analogy',
      explanation: 'This is an analogy of medium and movement: birds fly through air, and swimmers swim through water.',
    ),
    // Urdu Literature
    MockQuestion(
      id: 'p185-13',
      subject: MockSubject.generalKnowledge,
      question: 'In 2022, which book won the Baba-i-Urdu Molvi Abdul Haq Award for Urdu Prose (Criticism and Research)?',
      options: ['Urdu Adab Maholiati Tanazur', 'Tareekh-e-Adab-e-Urdu', 'Urdu Adab aur Asri Tanazur', 'Urdu Tanqid Aur Tajziya'],
      correctIndex: 0,
      topic: 'Urdu Literature',
      explanation: 'The Pakistan Academy of Letters gave the 2022 Baba-i-Urdu Molvi Abdul Haq Award for Urdu Prose (Criticism and Research) to Dr Aurangzeb Niazi for his book Urdu Adab Maholiati Tanazur.',
    ),
    MockQuestion(
      id: 'p185-14',
      subject: MockSubject.generalKnowledge,
      question: 'Woh mazameen jin mein mizah, tanz ya mazaq paya jaye, unhein kya kaha jata hai?',
      options: ['Tanqeedi mazameen', 'Mazahiya mazameen', 'Islahi mazameen', 'Ilmi mazameen'],
      correctIndex: 1,
      topic: 'Urdu Literature',
      explanation: 'Jin mazameen mein mizah aur tanz paya jaye unhein mazahiya mazameen kaha jata hai.',
    ),
    MockQuestion(
      id: 'p185-15',
      subject: MockSubject.generalKnowledge,
      question: 'Sher mein do ya do se zyada aise alfaaz jin ki aawaz aik jaisi ho lekin mani mukhtalif hon, unhein kya kehte hain?',
      options: ['Tazad', 'Tajnees', 'Tashbeeh', 'Muraat-e-Nazeer'],
      correctIndex: 1,
      topic: 'Urdu Literature',
      explanation: 'Tajnees woh san-at hai jis mein do alfaaz ki aawaz aik jaisi ho lekin un ke mani mukhtalif hon.',
    ),
  ],
);
