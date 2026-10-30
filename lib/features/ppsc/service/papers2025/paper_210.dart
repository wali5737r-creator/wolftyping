import '../../model/mock_question.dart';
import '../../model/paper_test.dart';

// PRACTICE MATERIAL ONLY.
// This is a practice mock test written in fresh wording for revision.
// It is not an official paper, not a verbatim reproduction of any exam,
// and it does not predict any real exam. Answers were checked against
// general reference facts at build time; where a printed key differed
// from the researched fact, the researched fact was used.
// NOTE: One page of the source scan for the preceding paper is greyed
// out and unreadable, so the first question of this paper (source
// question 1) could not be recovered and is omitted. The header of
// this paper was not visually verified. File question 1 below is
// source question 2.

const PaperTest paper210 = PaperTest(
  id: '2025-210',
  paperNo: 210,
  year: 2025,
  post: 'Assistant (BS-16)',
  department: 'Different Departments',
  examDate: '16.11.2025',
  questions: [
    // General Knowledge
    MockQuestion(
      id: 'p210-1', subject: MockSubject.generalKnowledge, question: 'What does OIC stand for?',
      options: ['Organization of Islamic Cooperation', 'Organisation of Islamic Countries', 'Office of International Commerce', 'Organisation for Islamic Culture'], correctIndex: 0, topic: 'International Organisations',
      explanation: 'OIC stands for the Organisation of Islamic Cooperation, founded in 1969.',
    ),
    MockQuestion(
      id: 'p210-2', subject: MockSubject.generalKnowledge, question: 'Water covers about 71 percent of the surface of the Earth and is essential for life. Which statements are correct: water covers most of the surface of the Earth, and water is essential for life?',
      options: ['Only the first statement', 'Only the second statement', 'Both A and B', 'Neither statement'], correctIndex: 2, topic: 'General Knowledge',
      explanation: 'Both statements are correct: water covers about 71 percent of the surface of the Earth and is essential for all known forms of life.',
    ),
    MockQuestion(
      id: 'p210-3', subject: MockSubject.generalKnowledge, question: 'Which ancient amphitheatre in Rome hosted gladiator contests and public shows?',
      options: ['Pantheon', 'Colosseum', 'Forum', 'Circus Maximus'], correctIndex: 1, topic: 'History',
      explanation: 'The Colosseum in Rome, completed in 80 AD, was the largest amphitheatre of the ancient world and hosted gladiator contests.',
    ),
    MockQuestion(
      id: 'p210-4', subject: MockSubject.generalKnowledge, question: 'Which machine, invented by Eli Whitney in 1793, separates cotton fibres from their seeds?',
      options: ['Spinning Jenny', 'Cotton Gin', 'Power Loom', 'Seed Drill'], correctIndex: 1, topic: 'Inventions',
      explanation: 'The cotton gin, invented by Eli Whitney in 1793, quickly separated cotton fibres from seeds and transformed cotton production.',
    ),
    MockQuestion(
      id: 'p210-5', subject: MockSubject.generalKnowledge, question: 'Which city is the capital of the United Kingdom?',
      options: ['Edinburgh', 'London', 'Manchester', 'Birmingham'], correctIndex: 1, topic: 'Geography',
      explanation: 'London is the capital city of the United Kingdom and of England.',
    ),
    MockQuestion(
      id: 'p210-6', subject: MockSubject.generalKnowledge, question: 'The Alhambra palace is located in which Spanish city?',
      options: ['Seville', 'Granada', 'Cordoba', 'Toledo'], correctIndex: 1, topic: 'Geography',
      explanation: 'The Alhambra is a palace and fortress in Granada, Spain, built during Muslim rule in Andalusia.',
    ),
    MockQuestion(
      id: 'p210-7', subject: MockSubject.generalKnowledge, question: 'Which international institution lends money to countries facing balance of payments problems?',
      options: ['World Bank', 'IMF', 'WTO', 'UNESCO'], correctIndex: 1, topic: 'International Organisations',
      explanation: 'The International Monetary Fund, IMF, lends to member countries facing balance of payments difficulties.',
    ),
    MockQuestion(
      id: 'p210-8', subject: MockSubject.everydayScience, question: 'Which planet is the hottest in the solar system, despite not being the closest to the Sun?',
      options: ['Mercury', 'Venus', 'Mars', 'Jupiter'], correctIndex: 1, topic: 'Astronomy',
      explanation: 'Venus is the hottest planet, with surface temperatures around 465 degrees Celsius, because its thick atmosphere traps heat.',
    ),
    MockQuestion(
      id: 'p210-9', subject: MockSubject.generalKnowledge, question: 'Who proclaimed the Peoples Republic of China in 1949?',
      options: ['Chiang Kai-shek', 'Mao Zedong', 'Deng Xiaoping', 'Zhou Enlai'], correctIndex: 1, topic: 'World History',
      explanation: 'Mao Zedong proclaimed the Peoples Republic of China on 1 October 1949 in Beijing.',
    ),
    MockQuestion(
      id: 'p210-10', subject: MockSubject.generalKnowledge, question: 'Who wrote the novel The God of Small Things, winner of the Booker Prize in 1997?',
      options: ['Arundhati Roy', 'Salman Rushdie', 'Kiran Desai', 'Jhumpa Lahiri'], correctIndex: 0, topic: 'Literature',
      explanation: 'Arundhati Roy wrote The God of Small Things, which won the Booker Prize in 1997.',
    ),
    MockQuestion(
      id: 'p210-11', subject: MockSubject.generalKnowledge, question: 'In which century was the Mughal Empire founded in India, with the victory of Babur in 1526?',
      options: ['14th century', '15th century', '16th century', '17th century'], correctIndex: 2, topic: 'History',
      explanation: 'Babur founded the Mughal Empire in 1526, which falls in the 16th century.',
    ),
    MockQuestion(
      id: 'p210-12', subject: MockSubject.pakistanStudies, question: 'The Shaheen series of missiles of Pakistan are which type of missile?',
      options: ['Surface-to-air missiles', 'Surface-to-surface ballistic missiles', 'Air-to-air missiles', 'Anti-tank missiles'], correctIndex: 1, topic: 'Defence',
      explanation: 'The Shaheen missiles of Pakistan are surface-to-surface ballistic missiles.',
    ),
    MockQuestion(
      id: 'p210-13', subject: MockSubject.generalKnowledge, question: 'Which city is the capital of Japan?',
      options: ['Osaka', 'Kyoto', 'Tokyo', 'Nagoya'], correctIndex: 2, topic: 'Geography',
      explanation: 'Tokyo is the capital city of Japan.',
    ),
    MockQuestion(
      id: 'p210-14', subject: MockSubject.pakistanStudies, question: 'Article 370 of the Indian Constitution dealt with which matter, before it was revoked in 2019?',
      options: ['Special status of Kashmir', 'Right to education', 'Religious freedom', 'Election rules'], correctIndex: 0, topic: 'Constitution',
      explanation: 'Article 370 gave special status to Jammu and Kashmir within the Indian Constitution, until it was revoked in August 2019.',
    ),
    MockQuestion(
      id: 'p210-15', subject: MockSubject.generalKnowledge, question: 'Which type of aircraft dropped the atomic bomb on Hiroshima in August 1945?',
      options: ['B-17', 'B-24', 'B-29', 'Lancaster'], correctIndex: 2, topic: 'World History',
      explanation: 'The B-29 bomber Enola Gay dropped the atomic bomb on Hiroshima on 6 August 1945.',
    ),
    MockQuestion(
      id: 'p210-16', subject: MockSubject.generalKnowledge, question: 'Which American statesman won the Nobel Peace Prize in 1973 for his work on the Vietnam peace talks?',
      options: ['Henry Kissinger', 'Richard Nixon', 'Jimmy Carter', 'George Shultz'], correctIndex: 0, topic: 'World Leaders',
      explanation: 'Henry Kissinger, Secretary of State of the United States, shared the Nobel Peace Prize in 1973 for negotiating the Paris Peace Accords.',
    ),
    MockQuestion(
      id: 'p210-17', subject: MockSubject.pakistanStudies, question: 'On which date was Article 370 of the Indian Constitution revoked in 2019?',
      options: ['15 August 2019', '5 August 2019', '26 January 2019', '1 July 2019'], correctIndex: 1, topic: 'Current Affairs',
      explanation: 'Article 370 was revoked on 5 August 2019, ending the special status of Jammu and Kashmir.',
    ),
    MockQuestion(
      id: 'p210-18', subject: MockSubject.pakistanStudies, question: 'Which countries are partners in the TAPI gas pipeline project?',
      options: ['Turkmenistan, Afghanistan, Pakistan, India', 'Turkey, Azerbaijan, Pakistan, Iran', 'Tajikistan, Afghanistan, Pakistan, India', 'Turkmenistan, Iran, Pakistan, China'], correctIndex: 0, topic: 'Economy',
      explanation: 'TAPI stands for the Turkmenistan-Afghanistan-Pakistan-India gas pipeline, carrying natural gas from Turkmenistan to India.',
    ),
    MockQuestion(
      id: 'p210-19', subject: MockSubject.generalKnowledge, question: 'How many claimant parties are counted in the listing used here for the South China Sea dispute?',
      options: ['5', '6', '7', '8'], correctIndex: 2, topic: 'International Relations',
      explanation: 'The listing counts seven claimant parties. The dispute is usually counted as six claimants: China, Taiwan, Vietnam, the Philippines, Malaysia and Brunei, so this count follows the listing used here.',
    ),
    MockQuestion(
      id: 'p210-20', subject: MockSubject.pakistanStudies, question: 'Which Pakistani fast bowler, known as the Rawalpindi Express, bowled the fastest recorded delivery in international cricket?',
      options: ['Wasim Akram', 'Waqar Younis', 'Shoaib Akhtar', 'Mohammad Amir'], correctIndex: 2, topic: 'Sports',
      explanation: 'Shoaib Akhtar bowled a delivery recorded at 161.3 km per hour against England in the 2003 World Cup, the fastest in international cricket.',
    ),
    MockQuestion(
      id: 'p210-21', subject: MockSubject.generalKnowledge, question: 'The uprising of 1857 began with a mutiny of sepoys at which town in India?',
      options: ['Delhi', 'Meerut', 'Lucknow', 'Kanpur'], correctIndex: 1, topic: 'History',
      explanation: 'The uprising of 1857 began at Meerut on 10 May 1857, when sepoys mutinied against the East India Company.',
    ),
    MockQuestion(
      id: 'p210-22', subject: MockSubject.pakistanStudies, question: 'Which project is described as a flagship project of the Belt and Road Initiative in Pakistan?',
      options: ['CPEC', 'TAPI', 'CASA-1000', 'IPPs'], correctIndex: 0, topic: 'Economy',
      explanation: 'The China-Pakistan Economic Corridor is described as a flagship project of the Belt and Road Initiative.',
    ),
    MockQuestion(
      id: 'p210-23', subject: MockSubject.pakistanStudies, question: 'Which religious political party in Pakistan is abbreviated as TLP?',
      options: ['Tehreek-e-Labbaik Pakistan', 'Tehreek-e-Insaf Pakistan', 'Tanzim-e-Islami Pakistan', 'Tehreek-e-Taliban Pakistan'], correctIndex: 0, topic: 'Political Parties',
      explanation: 'TLP stands for Tehreek-e-Labbaik Pakistan, a religious political party founded in 2015.',
    ),
    MockQuestion(
      id: 'p210-24', subject: MockSubject.generalKnowledge, question: 'Which dynasty ruled Delhi immediately before the Mughal Empire was founded in 1526?',
      options: ['Tughlaq dynasty', 'Khalji dynasty', 'Lodhi dynasty', 'Sayyid dynasty'], correctIndex: 2, topic: 'History',
      explanation: 'The Lodhi dynasty, under Ibrahim Lodhi, ruled Delhi until Babur defeated him at Panipat in 1526.',
    ),
    MockQuestion(
      id: 'p210-25', subject: MockSubject.pakistanStudies, question: 'In which year was the 18th Constitutional Amendment passed in Pakistan?',
      options: ['2008', '2010', '2013', '2015'], correctIndex: 1, topic: 'Constitution',
      explanation: 'The 18th Constitutional Amendment, which devolved powers to the provinces and removed Article 58(2)(b), was passed in 2010.',
    ),
    MockQuestion(
      id: 'p210-26', subject: MockSubject.pakistanStudies, question: 'Who is called the founder of Pakistan?',
      options: ['Liaquat Ali Khan', 'Quaid-e-Azam Muhammad Ali Jinnah', 'Allama Iqbal', 'Khawaja Nazimuddin'], correctIndex: 1, topic: 'Pakistan History',
      explanation: 'Muhammad Ali Jinnah, the Quaid-e-Azam, led the movement for Pakistan and became its first Governor-General.',
    ),
    MockQuestion(
      id: 'p210-27', subject: MockSubject.pakistanStudies, question: 'In which year did modern excavations begin at the ruins of Mohenjo-daro?',
      options: ['1911', '1922', '1930', '1942'], correctIndex: 1, topic: 'History',
      explanation: 'Excavations at Mohenjo-daro began in 1922 under R. D. Banerji, and the discovery of the Indus Valley Civilisation was announced in 1924.',
    ),
    MockQuestion(
      id: 'p210-28', subject: MockSubject.generalKnowledge, question: 'In which year did the Second World War begin in Europe?',
      options: ['1937', '1939', '1940', '1941'], correctIndex: 1, topic: 'World History',
      explanation: 'The Second World War began in Europe in 1939, when Germany invaded Poland.',
    ),
    MockQuestion(
      id: 'p210-29', subject: MockSubject.generalKnowledge, question: 'Which of the following are natural resources found in Pakistan: coal, natural gas and water?',
      options: ['Coal only', 'Natural gas only', 'Water only', 'All of these'], correctIndex: 3, topic: 'Geography',
      explanation: 'Pakistan has reserves of coal and natural gas, and large water resources from its rivers, so all three are found in the country.',
    ),
    MockQuestion(
      id: 'p210-30', subject: MockSubject.pakistanStudies, question: 'Which former princely state in Punjab acceded to Pakistan in 1947 and is now a division of Punjab?',
      options: ['Bahawalpur', 'Khairpur', 'Swat', 'Kalat'], correctIndex: 0, topic: 'Pakistan History',
      explanation: 'The princely state of Bahawalpur acceded to Pakistan in October 1947 and later became a division of Punjab province.',
    ),
    MockQuestion(
      id: 'p210-31', subject: MockSubject.pakistanStudies, question: 'Who was the first Governor-General of Pakistan?',
      options: ['Liaquat Ali Khan', 'Khawaja Nazimuddin', 'Muhammad Ali Jinnah', 'Ghulam Muhammad'], correctIndex: 2, topic: 'Pakistan History',
      explanation: 'Muhammad Ali Jinnah was the first Governor-General of Pakistan, serving from August 1947 until his death in September 1948.',
    ),
    MockQuestion(
      id: 'p210-32', subject: MockSubject.pakistanStudies, question: 'Who founded Government College Lahore in 1864?',
      options: ['G. W. Leitner', 'Syed Ahmad Khan', 'Henry Lawrence', 'John Lawrence'], correctIndex: 0, topic: 'Education',
      explanation: 'Gottlieb Wilhelm Leitner founded Government College Lahore in 1864 and was its first principal.',
    ),
    MockQuestion(
      id: 'p210-33', subject: MockSubject.pakistanStudies, question: 'Pakistan is ranked at which position in the climate vulnerability listing used in this paper?',
      options: ['6th', '7th', '8th', '10th'], correctIndex: 2, topic: 'Environment',
      explanation: 'The listing gives 8th place for Pakistan. Vulnerability rankings vary between indexes, although Pakistan is widely cited as among the countries most affected by climate change, so this ranking follows the listing used here.',
    ),
    MockQuestion(
      id: 'p210-34', subject: MockSubject.generalKnowledge, question: 'Which river is known as Yarlung Tsangpo in Tibet, before it flows into India as the Brahmaputra?',
      options: ['Yarlung Tsangpo', 'Indus', 'Sutlej', 'Mekong'], correctIndex: 0, topic: 'Geography',
      explanation: 'The Brahmaputra is known as Yarlung Tsangpo in its upper course in Tibet.',
    ),
    MockQuestion(
      id: 'p210-35', subject: MockSubject.generalKnowledge, question: 'Which cue sport is played on a table with six pockets, using a cue to strike balls?',
      options: ['Pool', 'Chess', 'Squash', 'Bowling'], correctIndex: 0, topic: 'Sports',
      explanation: 'Pool is a cue sport played on a table with six pockets, in which balls are struck with a cue stick.',
    ),
    MockQuestion(
      id: 'p210-36', subject: MockSubject.everydayScience, question: 'A supernova is best described as what?',
      options: ['A massive stellar explosion', 'A new planet', 'A black hole only', 'A comet'], correctIndex: 0, topic: 'Astronomy',
      explanation: 'A supernova is the massive explosion of a star at the end of its life, briefly outshining its whole galaxy.',
    ),
    MockQuestion(
      id: 'p210-37', subject: MockSubject.everydayScience, question: 'The process by which green plants make food using sunlight, water and carbon dioxide is called:',
      options: ['Respiration', 'Photosynthesis', 'Fermentation', 'Transpiration'], correctIndex: 1, topic: 'Biology',
      explanation: 'Photosynthesis is the process by which green plants use sunlight to make glucose from water and carbon dioxide.',
    ),
    MockQuestion(
      id: 'p210-38', subject: MockSubject.everydayScience, question: 'Which instrument measures the purity and density of milk?',
      options: ['Barometer', 'Lactometer', 'Thermometer', 'Altimeter'], correctIndex: 1, topic: 'Physics',
      explanation: 'A lactometer measures the specific gravity of milk, which shows whether water has been added to it.',
    ),
    MockQuestion(
      id: 'p210-39', subject: MockSubject.everydayScience, question: 'The branch of physics dealing with electric and magnetic fields and their interaction is called:',
      options: ['Mechanics', 'Electromagnetism', 'Optics', 'Thermodynamics'], correctIndex: 1, topic: 'Physics',
      explanation: 'Electromagnetism is the branch of physics that studies electric and magnetic fields and the forces between charged particles.',
    ),
    MockQuestion(
      id: 'p210-40', subject: MockSubject.everydayScience, question: 'Which cells in the retina of the eye work in dim light and detect shades of grey?',
      options: ['Cones', 'Rods', 'Lens cells', 'Nerve cells'], correctIndex: 1, topic: 'Biology',
      explanation: 'Rod cells in the retina are sensitive to low light and allow vision in dim conditions, while cone cells detect colour.',
    ),
    MockQuestion(
      id: 'p210-41', subject: MockSubject.everydayScience, question: 'The order of bases that carries genetic instructions in a living organism is called the:',
      options: ['RNA sequence', 'DNA sequence', 'Protein chain', 'Cell wall'], correctIndex: 1, topic: 'Biology',
      explanation: 'Genetic information is stored in the sequence of bases in DNA, which directs the building of proteins.',
    ),
    MockQuestion(
      id: 'p210-42', subject: MockSubject.everydayScience, question: 'Which group of chemicals is mainly blamed for the depletion of the ozone layer?',
      options: ['CFCs', 'Oxides of nitrogen only', 'Methane only', 'Carbon monoxide'], correctIndex: 0, topic: 'Environment',
      explanation: 'Chlorofluorocarbons, CFCs, release chlorine in the stratosphere, which destroys ozone molecules.',
    ),
    MockQuestion(
      id: 'p210-43', subject: MockSubject.everydayScience, question: 'What is the normal range of calcium in human blood, measured in milligrams per decilitre?',
      options: ['5.5-7.5 mg/dl', '8.5-10.5 mg/dl', '11.5-13.5 mg/dl', '15.5-17.5 mg/dl'], correctIndex: 1, topic: 'Biology',
      explanation: 'The normal total calcium level in adult human blood is about 8.5 to 10.5 milligrams per decilitre.',
    ),
    MockQuestion(
      id: 'p210-44', subject: MockSubject.everydayScience, question: 'A meteoroid that survives passage through the atmosphere and lands on the Earth is called a:',
      options: ['Comet', 'Asteroid', 'Meteorite', 'Satellite'], correctIndex: 2, topic: 'Astronomy',
      explanation: 'A meteorite is a piece of rock from space that reaches the surface of the Earth, while the streak of light in the sky is a meteor.',
    ),
    MockQuestion(
      id: 'p210-45', subject: MockSubject.mathematics, question: 'A relationship whose graph is a curve rather than a straight line is called which type of relationship?',
      options: ['Linear', 'Non-linear', 'Constant', 'Proportional only'], correctIndex: 1, topic: 'Graphs',
      explanation: 'A non-linear relationship does not graph as a straight line, because its rate of change is not constant.',
    ),
    MockQuestion(
      id: 'p210-46', subject: MockSubject.everydayScience, question: 'Which instrument records the waves produced by an earthquake?',
      options: ['Barometer', 'Seismograph', 'Telescope', 'Spectrometer'], correctIndex: 1, topic: 'Physics',
      explanation: 'A seismograph records seismic waves from earthquakes, and its record is called a seismogram.',
    ),
    MockQuestion(
      id: 'p210-47', subject: MockSubject.everydayScience, question: 'Which system of the human body defends it against disease and infection?',
      options: ['Digestive system', 'Immune system', 'Nervous system', 'Respiratory system'], correctIndex: 1, topic: 'Biology',
      explanation: 'The immune system, including white blood cells and antibodies, defends the body against germs and disease.',
    ),
    MockQuestion(
      id: 'p210-48', subject: MockSubject.everydayScience, question: 'In which direction do glacial striations, the scratches left on rock by a moving glacier, run in relation to the movement of the glacier?',
      options: ['Parallel to glacier', 'Across the glacier', 'Against the glacier', 'In circles'], correctIndex: 0, topic: 'Geography',
      explanation: 'Glacial striations are scratches cut into bedrock by rocks carried in the ice, and they run parallel to the direction of glacier movement.',
    ),
    MockQuestion(
      id: 'p210-49', subject: MockSubject.generalKnowledge, question: 'Computers using artificial intelligence and very large scale integration technology belong to which generation of computers?',
      options: ['Third generation', 'Fourth generation', '5th generation', 'Second generation'], correctIndex: 2, topic: 'Computer',
      explanation: 'Fifth generation computers are based on artificial intelligence and ULSI, ultra large scale integration, technology.',
    ),
    MockQuestion(
      id: 'p210-50', subject: MockSubject.generalKnowledge, question: 'Which of the following are output devices of a computer: a monitor, a printer and a speaker?',
      options: ['Monitor only', 'Printer only', 'Speaker only', 'All of these'], correctIndex: 3, topic: 'Computer',
      explanation: 'A monitor, a printer and a speaker are all output devices, because each gives out processed data from the computer.',
    ),
    MockQuestion(
      id: 'p210-51', subject: MockSubject.generalKnowledge, question: 'Who co-founded Google with Sergey Brin in 1998?',
      options: ['Larry Page', 'Bill Gates', 'Jeff Bezos', 'Elon Musk'], correctIndex: 0, topic: 'Computer',
      explanation: 'Larry Page and Sergey Brin founded Google in 1998 while they were students at Stanford University.',
    ),
    MockQuestion(
      id: 'p210-52', subject: MockSubject.generalKnowledge, question: 'The physical parts of a computer, such as the keyboard, monitor and processor, are called:',
      options: ['Software', 'Hardware', 'Data', 'Network'], correctIndex: 1, topic: 'Computer',
      explanation: 'Hardware is the physical machinery of a computer, while software is the programs that run on it.',
    ),
    MockQuestion(
      id: 'p210-53', subject: MockSubject.generalKnowledge, question: 'Which identifier is assigned to a device on a network to identify it and route data to it?',
      options: ['IP Address', 'File name', 'Password', 'User name'], correctIndex: 0, topic: 'Computer',
      explanation: 'An IP address identifies a device on a network. Note that IP addresses can change, for example when a device uses dynamic addressing.',
    ),
    MockQuestion(
      id: 'p210-54', subject: MockSubject.generalKnowledge, question: 'The transistor was invented in 1947 at which research organisation?',
      options: ['Bell Laboratories', 'NASA', 'IBM Research', 'CERN'], correctIndex: 0, topic: 'Computer',
      explanation: 'The transistor was invented at Bell Laboratories in 1947 by John Bardeen, Walter Brattain and William Shockley.',
    ),
    MockQuestion(
      id: 'p210-55', subject: MockSubject.generalKnowledge, question: 'Sending data from a local computer up to the internet or a remote server is called:',
      options: ['Downloading', 'Uploading', 'Browsing', 'Formatting'], correctIndex: 1, topic: 'Computer',
      explanation: 'Uploading sends data from a local device to a remote system, while downloading brings data down to the local device.',
    ),
    MockQuestion(
      id: 'p210-56', subject: MockSubject.generalKnowledge, question: 'In a computer, what does PSU stand for?',
      options: ['Personal Storage Unit', 'Power Supply Unit', 'Program Support Utility', 'Processor Speed Unit'], correctIndex: 1, topic: 'Computer',
      explanation: 'PSU stands for Power Supply Unit, which converts mains electricity into power for the parts of a computer.',
    ),
    MockQuestion(
      id: 'p210-57', subject: MockSubject.mathematics, question: 'What is the product of 522 and 1000?',
      options: ['52,200', '522,000', '5,220,000', '522'], correctIndex: 1, topic: 'Arithmetic',
      explanation: 'Five hundred and twenty two multiplied by one thousand is 522,000.',
    ),
    MockQuestion(
      id: 'p210-58', subject: MockSubject.mathematics, question: 'What is the value of 2 multiplied by 9?',
      options: ['16', '18', '20', '27'], correctIndex: 1, topic: 'Arithmetic',
      explanation: 'Two multiplied by nine is eighteen.',
    ),
    MockQuestion(
      id: 'p210-59', subject: MockSubject.mathematics, question: 'What is 12X divided by X squared, in its simplest form?',
      options: ['12/X', '12X', 'X/12', '12'], correctIndex: 0, topic: 'Algebra',
      explanation: 'Twelve X divided by X squared cancels one X from top and bottom, leaving 12 divided by X.',
    ),
    MockQuestion(
      id: 'p210-60', subject: MockSubject.mathematics, question: 'What is 500 minus 25?',
      options: ['425', '450', '475', '525'], correctIndex: 2, topic: 'Arithmetic',
      explanation: 'Five hundred minus twenty five is four hundred and seventy five.',
    ),
    MockQuestion(
      id: 'p210-61', subject: MockSubject.mathematics, question: 'If X is 11 and Y is 9, what is the value of X multiplied by Y, plus 4?',
      options: ['99', '103', '107', '95'], correctIndex: 1, topic: 'Algebra',
      explanation: 'Eleven multiplied by nine is 99, and 99 plus 4 is 103. This solution takes the values X equals 11 and Y equals 9, as given in the listing.',
    ),
    MockQuestion(
      id: 'p210-62', subject: MockSubject.mathematics, question: 'A triangle has a base of 4 cm and an area of 12 square cm. What is its height?',
      options: ['3 cm', '6 cm', '8 cm', '12 cm'], correctIndex: 1, topic: 'Geometry',
      explanation: 'The area of a triangle is half the base times the height, so the height is twice the area divided by the base, which is 24 divided by 4, or 6 cm.',
    ),
    MockQuestion(
      id: 'p210-63', subject: MockSubject.mathematics, question: 'A salesman earns a fixed amount of 2000 rupees on each car that he sells. What is this earning called in the calculation?',
      options: ['Salary per month', 'Commission per car', 'Rent per car', 'Tax per car'], correctIndex: 1, topic: 'Arithmetic',
      explanation: 'The amount of 2000 rupees is the fixed commission earned on each car sold.',
    ),
    MockQuestion(
      id: 'p210-64', subject: MockSubject.mathematics, question: 'What is the volume of a sphere whose radius is 2r, in terms of pi and r?',
      options: ['(32/3) pi r cubed', '(4/3) pi r cubed', '(8/3) pi r cubed', '32 pi r cubed'], correctIndex: 0, topic: 'Geometry',
      explanation: 'The volume of a sphere is four thirds pi times the cube of the radius. With radius 2r, the cube is 8 r cubed, giving 32 over 3 times pi times r cubed.',
    ),
    MockQuestion(
      id: 'p210-65', subject: MockSubject.english, question: 'Choose the word closest in meaning to dishonour:',
      options: ['Honour', 'Disgrace', 'Praise', 'Glory'], correctIndex: 1, topic: 'Vocabulary',
      explanation: 'Disgrace means loss of honour and respect.',
    ),
    MockQuestion(
      id: 'p210-66', subject: MockSubject.english, question: 'A very deep pit or chasm is called an:',
      options: ['Abyss', 'Hill', 'Valley', 'Plain'], correctIndex: 0, topic: 'Vocabulary',
      explanation: 'An abyss is a very deep hole or chasm, often used figuratively for something immeasurably deep.',
    ),
    MockQuestion(
      id: 'p210-67', subject: MockSubject.english, question: 'Choose the correct word: Go ___ from here at once.',
      options: ['Away', 'About', 'After', 'Along'], correctIndex: 0, topic: 'Vocabulary',
      explanation: 'Go away is the command telling a person to leave.',
    ),
    MockQuestion(
      id: 'p210-68', subject: MockSubject.english, question: 'Choose the grammatically correct sentence.',
      options: ['She smiled when she sees her friend', 'She smiles when she saw her friend', 'She smiled when she saw her friend', 'She smiling when she saw her friend'], correctIndex: 2, topic: 'Grammar',
      explanation: 'Both verbs must be in the past tense for a completed past event, so she smiled when she saw her friend is correct.',
    ),
    MockQuestion(
      id: 'p210-69', subject: MockSubject.english, question: 'The word quickly, in the sentence She ran quickly, is which part of speech?',
      options: ['Adjective', 'Adverb', 'Verb', 'Noun'], correctIndex: 1, topic: 'Grammar',
      explanation: 'Quickly modifies the verb ran, describing how she ran, so it is an adverb.',
    ),
    MockQuestion(
      id: 'p210-70', subject: MockSubject.english, question: 'Choose the correct preposition: The meeting was put ___ till Monday.',
      options: ['On', 'Off', 'In', 'Up'], correctIndex: 1, topic: 'Prepositions',
      explanation: 'To put off a meeting is to postpone it, so the meeting was put off till Monday.',
    ),
    MockQuestion(
      id: 'p210-71', subject: MockSubject.english, question: 'Choose the correct preposition: She goes ___ school daily.',
      options: ['At', 'To', 'In', 'On'], correctIndex: 1, topic: 'Prepositions',
      explanation: 'Go to school is the correct phrase for attending school.',
    ),
    MockQuestion(
      id: 'p210-72', subject: MockSubject.english, question: 'The word in, in the phrase in the box, is which part of speech?',
      options: ['Noun', 'Verb', 'Preposition', 'Conjunction'], correctIndex: 2, topic: 'Grammar',
      explanation: 'In shows the relation between the box and something else, so it is a preposition.',
    ),
    MockQuestion(
      id: 'p210-73', subject: MockSubject.english, question: 'Choose the correct preposition: Islamabad is the capital ___ Pakistan.',
      options: ['In', 'At', 'Of', 'To'], correctIndex: 2, topic: 'Prepositions',
      explanation: 'The capital of Pakistan is the correct phrase, using of to show belonging.',
    ),
    MockQuestion(
      id: 'p210-74', subject: MockSubject.english, question: 'Choose the sentence that correctly expresses the sense of let alone in this context: neither milk nor even water was available.',
      options: ['What to speak of milk, water was available', 'Milk was not available, what to speak of water', 'What to speak of milk, even water was not available', 'Even milk was available, what to speak of water'], correctIndex: 2, topic: 'Idioms',
      explanation: 'The phrase what to speak of is used in the sense of let alone: what to speak of milk, even water was not available. This idiom item is loose in wording.',
    ),
    MockQuestion(
      id: 'p210-75', subject: MockSubject.english, question: 'Which pair correctly links a sense with its name: the sense of smell is called the olfactory sense?',
      options: ['Olfactory : Smell', 'Visual : Hearing', 'Auditory : Sight', 'Tactile : Taste'], correctIndex: 0, topic: 'Analogies',
      explanation: 'Olfactory relates to the sense of smell, just as visual relates to sight and auditory to hearing.',
    ),
    MockQuestion(
      id: 'p210-76', subject: MockSubject.english, question: 'Choose the correct preposition: He is addicted ___ smoking.',
      options: ['In', 'To', 'With', 'At'], correctIndex: 1, topic: 'Prepositions',
      explanation: 'Addicted is followed by to, so he is addicted to smoking.',
    ),
    MockQuestion(
      id: 'p210-77', subject: MockSubject.english, question: 'Choose the correctly punctuated sentence.',
      options: ['"Mr. Hubert, the old man, remembered, understood, and flushed with anger"', '"Mr. Hubert, the old man, remembered, understood and flushed with anger"', '"Mr. Hubert, the old man, remembered, understood and flushed with anger?"', '"Mr. Hubert, the old Man, remembered, understood and flushed with anger"'], correctIndex: 1, topic: 'Punctuation',
      explanation: 'Only the second option has the punctuation given for this item: the commas set off the appositive the old man, there is no comma before and, the statement ends with a full stop, and man is not capitalised. The first option adds a comma before and, the third wrongly ends a statement with a question mark, and the fourth wrongly capitalises Man.',
    ),
    MockQuestion(
      id: 'p210-78', subject: MockSubject.english, question: 'Choose the correct verb form: He ___ at the station yesterday.',
      options: ['Arrive', 'Arrived', 'Arriving', 'Arrives'], correctIndex: 1, topic: 'Grammar',
      explanation: 'Yesterday shows past time, so the past tense arrived is correct.',
    ),
    MockQuestion(
      id: 'p210-79', subject: MockSubject.generalKnowledge, question: 'Urdu: Kandhe ko aam bol chaal mein kya kehte hain?',
      options: ['Mundhay', 'Sar', 'Hath', 'Paon'], correctIndex: 0, topic: 'Urdu Vocabulary',
      explanation: 'Mundhay kandhe ke liye istemal hone wala lafz hai.',
    ),
    MockQuestion(
      id: 'p210-80', subject: MockSubject.generalKnowledge, question: 'Urdu: Har roz hone wale kaam ko kya kehte hain?',
      options: ['Rozmarra', 'Mahana', 'Salana', 'Kabhi kabhi'], correctIndex: 0, topic: 'Urdu Vocabulary',
      explanation: 'Rozmarra se murad hai har roz hone wala kaam ya rozana ki zindagi.',
    ),
    MockQuestion(
      id: 'p210-81', subject: MockSubject.generalKnowledge, question: 'Urdu: Khitab (vocative) wala jumla konsa hai?',
      options: ['Mere bachcho! Khuda tumhein salamat rakhe', 'Woh school jata hai', 'Us ne khana khaya', 'Kal barish hogi'], correctIndex: 0, topic: 'Urdu Grammar',
      explanation: 'Mere bachcho! Khuda tumhein salamat rakhe aik khitabi jumla hai jis mein bachchon ko pukar kar dua di gayi hai.',
    ),
    MockQuestion(
      id: 'p210-82', subject: MockSubject.generalKnowledge, question: 'Urdu: Kis lafz ka matlab shara hai?',
      options: ['Shara', 'Khair', 'Bhalai', 'Aman'], correctIndex: 0, topic: 'Urdu Vocabulary',
      explanation: 'Shara se murad hai burai ya shararat.',
    ),
    MockQuestion(
      id: 'p210-83', subject: MockSubject.generalKnowledge, question: 'Urdu: Muhavre aukhli mein sar dena mein sar se murad kya hai?',
      options: ['Sar', 'Hath', 'Paon', 'Aankh'], correctIndex: 0, topic: 'Urdu Idioms',
      explanation: 'Aukhli mein sar dena muhavre mein sar se murad hai sar, yani apne aap ko mushkil mein dalna.',
    ),
    MockQuestion(
      id: 'p210-84', subject: MockSubject.generalKnowledge, question: 'Urdu: Do doston ke darmiyan gehri aur pakki dosti ko kya kaha jata hai?',
      options: ['Gehri dosti', 'Sathi', 'Waqti talluq', 'Rasmi mulaqat'], correctIndex: 0, topic: 'Urdu Vocabulary',
      explanation: 'Gehri dosti se murad hai do doston ke darmiyan gehri aur pakki dosti.',
    ),
    MockQuestion(
      id: 'p210-85', subject: MockSubject.generalKnowledge, question: 'Urdu: Woh zamana jo guzre hue waqt ki door ki baat bataye, kya kehlata hai?',
      options: ['Mazi Baeed', 'Mazi Qareeb', 'Hal', 'Mustaqbil'], correctIndex: 0, topic: 'Urdu Grammar',
      explanation: 'Mazi baeed woh zamana hai jo guzre hue door ke waqt ki baat batata hai.',
    ),
    MockQuestion(
      id: 'p210-86', subject: MockSubject.generalKnowledge, question: 'Urdu: Kisi ki peeth peeche burai karne ko kya kehte hain?',
      options: ['Badgoi karna', 'Tareef karna', 'Madad karna', 'Khamosh rehna'], correctIndex: 0, topic: 'Urdu Vocabulary',
      explanation: 'Badgoi karna ka matlab hai kisi ki peeth peeche us ki burai karna.',
    ),
    MockQuestion(
      id: 'p210-87', subject: MockSubject.generalKnowledge, question: 'Urdu: Be sahara hone ko kya kehte hain?',
      options: ['Baghair kisi saharay ke', 'Sahara lena', 'Madad lena', 'Dosti karna'], correctIndex: 0, topic: 'Urdu Vocabulary',
      explanation: 'Baghair kisi saharay ke hona be sahara hone ko kehte hain.',
    ),
    MockQuestion(
      id: 'p210-88', subject: MockSubject.generalKnowledge, question: 'Urdu: Kisi ko tanz aur malamat karne ko kya kehte hain?',
      options: ['Lan tan karna', 'Tareef karna', 'Izzat karna', 'Madad karna'], correctIndex: 0, topic: 'Urdu Vocabulary',
      explanation: 'Lan tan karna ka matlab hai kisi ko tanz aur malamat karna.',
    ),
    MockQuestion(
      id: 'p210-89', subject: MockSubject.islamiat, question: 'Which companion of the Prophet is known as Amin of this Ummah, the trustworthy one?',
      options: ['Abu Ubaida bin Jarrah', 'Zaid bin Haritha', 'Usama bin Zaid', 'Saad bin Abi Waqqas'], correctIndex: 0, topic: 'Companions',
      explanation: 'Abu Ubaida bin Jarrah was called Amin of this Ummah by the Prophet Muhammad for his trustworthiness.',
    ),
    MockQuestion(
      id: 'p210-90', subject: MockSubject.islamiat, question: 'A Hadith falsely attributed to the Prophet Muhammad is called what in the terminology of Hadith?',
      options: ['Sahih', 'Hasan', 'Modhu', 'Daif'], correctIndex: 2, topic: 'Hadith',
      explanation: 'A fabricated Hadith is called mawdu, written here as Modhu. Sahih means authentic, Hasan means fair, and Daif means weak.',
    ),
    MockQuestion(
      id: 'p210-91', subject: MockSubject.islamiat, question: 'Which wife of the Prophet Muhammad is known as Umm al-Masakin, mother of the poor?',
      options: ['Hazrat Zainab Bint Khuzaima', 'Hazrat Khadija (RA)', 'Hazrat Ayesha (RA)', 'Hazrat Maria Qibtiyya (RA)'], correctIndex: 0, topic: 'Seerat',
      explanation: 'Hazrat Zainab bint Khuzaima was known as Umm al-Masakin because of her generosity to the poor.',
    ),
    MockQuestion(
      id: 'p210-92', subject: MockSubject.islamiat, question: 'In the Farewell Sermon, the Prophet abolished which practices of the pre-Islamic age in general terms?',
      options: ['Old customs', 'Blood feuds only', 'Usury only', 'None of these'], correctIndex: 0, topic: 'Seerat',
      explanation: 'In the Farewell Sermon the Prophet abolished the old customs of the age of ignorance in general terms, including blood feuds and usury.',
    ),
    MockQuestion(
      id: 'p210-93', subject: MockSubject.islamiat, question: 'Which grandson of the Prophet Muhammad concluded a peace agreement with Muawiya in 661 AD?',
      options: ['Hazrat Hasan (RA)', 'Hazrat Husain (RA)', 'Hazrat Abbas (RA)', 'Hazrat Ali (RA)'], correctIndex: 0, topic: 'Islamic History',
      explanation: 'Hazrat Hasan (RA) concluded a peace agreement with Muawiya in 661 AD and gave up the caliphate to avoid bloodshed.',
    ),
    MockQuestion(
      id: 'p210-94', subject: MockSubject.islamiat, question: 'Who was the second Caliph of Islam?',
      options: ['Hazrat Abu Bakr (RA)', 'Hazrat Umar (RA)', 'Hazrat Usman (RA)', 'Hazrat Ali (RA)'], correctIndex: 1, topic: 'Islamic History',
      explanation: 'Hazrat Umar (RA) was the second Caliph, succeeding Hazrat Abu Bakr (RA) in 634 AD.',
    ),
    MockQuestion(
      id: 'p210-95', subject: MockSubject.islamiat, question: 'Which wife of the Prophet Muhammad was the mother of his son Ibrahim?',
      options: ['Hazrat Khadija (RA)', 'Hazrat Maria Qibtiyya (RA)', 'Hazrat Ayesha (RA)', 'Hazrat Hafsa (RA)'], correctIndex: 1, topic: 'Seerat',
      explanation: 'Hazrat Maria Qibtiyya (RA) was the mother of Ibrahim, the son of the Prophet Muhammad.',
    ),
    MockQuestion(
      id: 'p210-96', subject: MockSubject.islamiat, question: 'A poor and needy person, deserving of charity, is called what in common Islamic usage?',
      options: ['Ghareeb', 'Ameer', 'Musafir', 'Tajir'], correctIndex: 0, topic: 'Islamic Teachings',
      explanation: 'Ghareeb means poor and needy, and the poor are among those entitled to charity in Islam.',
    ),
    MockQuestion(
      id: 'p210-97', subject: MockSubject.islamiat, question: 'The chain of narrators through which a Hadith is transmitted is called what?',
      options: ['Matan', 'Sanad', 'Riwaya', 'Kitab'], correctIndex: 1, topic: 'Hadith',
      explanation: 'Sanad is the chain of narrators of a Hadith, while matan is the text of the Hadith itself.',
    ),
  ],
  latestUpdates: [],
);
