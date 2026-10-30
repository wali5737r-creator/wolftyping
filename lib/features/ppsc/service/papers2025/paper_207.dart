import '../../model/mock_question.dart';
import '../../model/paper_test.dart';

// PRACTICE MATERIAL ONLY.
// This is a practice mock test written in fresh wording for revision.
// It is not an official paper, not a verbatim reproduction of any exam,
// and it does not predict any real exam. Answers were checked against
// general reference facts at build time; where a printed key differed
// from the researched fact, the researched fact was used.

const PaperTest paper207 = PaperTest(
  id: '2025-207',
  paperNo: 207,
  year: 2025,
  post: 'Assistant PESSI (BS-16)',
  department: 'Punjab Employees Social Security Department',
  examDate: '19.10.2025',
  questions: [
    // General Knowledge
    MockQuestion(
      id: 'p207-1', subject: MockSubject.generalKnowledge, question: 'A plan of action designed to achieve a long term goal is called a:',
      options: ['Tactic', 'Strategy', 'Rule', 'Habit'], correctIndex: 1, topic: 'General Knowledge',
      explanation: 'A strategy is a broad plan of action for achieving a long term goal, while tactics are the short term steps within it.',
    ),
    MockQuestion(
      id: 'p207-2', subject: MockSubject.generalKnowledge, question: 'Which war in Europe lasted from 1618 to 1648 and ended with the Peace of Westphalia?',
      options: ['Seven Year War', '30 Year War', 'Hundred Year War', 'Napoleonic Wars'], correctIndex: 1, topic: 'World History',
      explanation: 'The Thirty Years War lasted from 1618 to 1648, fought mainly in Central Europe, and ended with the Peace of Westphalia.',
    ),
    MockQuestion(
      id: 'p207-3', subject: MockSubject.generalKnowledge, question: 'In which year was the Magna Carta sealed by King John of England?',
      options: ['1066', '1215', '1348', '1492'], correctIndex: 1, topic: 'World History',
      explanation: 'The Magna Carta was sealed in 1215, limiting the power of the king and affirming certain rights of free men.',
    ),
    MockQuestion(
      id: 'p207-4', subject: MockSubject.generalKnowledge, question: 'Which award is the highest decoration for gallantry in the British armed forces?',
      options: ['George Cross', 'Victoria Cross', 'Military Cross', 'Distinguished Service Order'], correctIndex: 1, topic: 'Awards',
      explanation: 'The Victoria Cross is the highest award for gallantry in the face of the enemy for members of the British armed forces.',
    ),
    MockQuestion(
      id: 'p207-5', subject: MockSubject.generalKnowledge, question: 'Which country invaded Poland in September 1939, starting the Second World War in Europe?',
      options: ['Italy', 'Germany', 'Japan', 'France'], correctIndex: 1, topic: 'World History',
      explanation: 'Germany invaded Poland on 1 September 1939, which led Britain and France to declare war on Germany.',
    ),
    MockQuestion(
      id: 'p207-6', subject: MockSubject.generalKnowledge, question: 'Who founded the Scout movement in 1908?',
      options: ['Lord Baden Powell', 'Lord Kitchener', 'Robert Peel', 'William Booth'], correctIndex: 0, topic: 'Personalities',
      explanation: 'Lord Robert Baden-Powell founded the Scout movement, publishing Scouting for Boys in 1908.',
    ),
    MockQuestion(
      id: 'p207-7', subject: MockSubject.pakistanStudies, question: 'The policy of taking private industries and banks under state control in Pakistan in the 1970s is called:',
      options: ['Privatization', 'Nationalization', 'Liberalization', 'Globalization'], correctIndex: 1, topic: 'Economy',
      explanation: 'Nationalization is the transfer of private assets to state ownership, carried out on a large scale in Pakistan under Zulfikar Ali Bhutto in the 1970s.',
    ),
    MockQuestion(
      id: 'p207-8', subject: MockSubject.generalKnowledge, question: 'Which country spans Eastern Europe and Northern Asia, and is the largest country in the world?',
      options: ['China', 'Russia', 'Kazakhstan', 'Mongolia'], correctIndex: 1, topic: 'Geography',
      explanation: 'Russia spans Eastern Europe and Northern Asia and is the largest country in the world by area.',
    ),
    MockQuestion(
      id: 'p207-9', subject: MockSubject.generalKnowledge, question: 'How many member states does the Organisation of Islamic Cooperation have?',
      options: ['48', '52', '57', '61'], correctIndex: 2, topic: 'International Organisations',
      explanation: 'The Organisation of Islamic Cooperation has 57 member states.',
    ),
    MockQuestion(
      id: 'p207-10', subject: MockSubject.generalKnowledge, question: 'In which city is the headquarters of NATO located?',
      options: ['Paris', 'Brussels', 'London', 'Washington'], correctIndex: 1, topic: 'International Organisations',
      explanation: 'The headquarters of the North Atlantic Treaty Organization is in Brussels, Belgium.',
    ),
    MockQuestion(
      id: 'p207-11', subject: MockSubject.generalKnowledge, question: 'Who is regarded as the founding father of modern Singapore?',
      options: ['Mahathir Mohamad', 'Lee Kuan Yew', 'Sukarno', 'Ferdinand Marcos'], correctIndex: 1, topic: 'World Leaders',
      explanation: 'Lee Kuan Yew, the first Prime Minister of Singapore, is regarded as the founding father of modern Singapore.',
    ),
    MockQuestion(
      id: 'p207-12', subject: MockSubject.generalKnowledge, question: 'Which country has no single written constitution in one document, relying instead on statutes, conventions and precedents?',
      options: ['USA', 'France', 'UK', 'India'], correctIndex: 2, topic: 'Constitutions',
      explanation: 'The United Kingdom has an unwritten constitution made up of statutes, conventions, judicial decisions and traditions, rather than a single document.',
    ),
    MockQuestion(
      id: 'p207-13', subject: MockSubject.generalKnowledge, question: 'Which group of countries lies around the Strait of Gibraltar and the western entrance to the Mediterranean Sea?',
      options: ['Spain, Portugal, Morocco', 'France, Italy, Greece', 'Turkey, Egypt, Libya', 'Algeria, Tunisia, Malta'], correctIndex: 0, topic: 'Geography',
      explanation: 'Spain and Morocco face each other across the Strait of Gibraltar, with Portugal on the Atlantic coast of the Iberian Peninsula nearby.',
    ),
    MockQuestion(
      id: 'p207-14', subject: MockSubject.pakistanStudies, question: 'Who founded the Khaksar Movement in the 1930s?',
      options: ['Inayatullah Mashriqi', 'Abul Kalam Azad', 'Muhammad Ali Jinnah', 'Chaudhry Rehmat Ali'], correctIndex: 0, topic: 'Pakistan Movement',
      explanation: 'The Khaksar Movement was founded by Inayatullah Khan Mashriqi in 1931 as a disciplined social reform movement.',
    ),
    MockQuestion(
      id: 'p207-15', subject: MockSubject.pakistanStudies, question: 'What principle does the Senate of Pakistan follow in representing the provinces of the federation?',
      options: ['Representation by population', 'Equal representation', 'Representation by area', 'Representation by revenue'], correctIndex: 1, topic: 'Constitution',
      explanation: 'The Senate gives equal representation to each province, so that smaller provinces have the same voice as larger ones in the upper house.',
    ),
    MockQuestion(
      id: 'p207-16', subject: MockSubject.generalKnowledge, question: 'The Delhi Sultanate ruled northern India during which period?',
      options: ['1000-1206', '1206-1526', '1526-1707', '1707-1857'], correctIndex: 1, topic: 'History',
      explanation: 'The Delhi Sultanate lasted from 1206, when Qutb-ud-din Aibak founded the Slave dynasty, until Babur defeated Ibrahim Lodhi in 1526.',
    ),
    MockQuestion(
      id: 'p207-17', subject: MockSubject.pakistanStudies, question: 'The All India Muslim League was founded in 1906 with which main objective?',
      options: ['To oppose the Congress', 'To safeguard Muslim rights', 'To demand complete independence', 'To promote English education'], correctIndex: 1, topic: 'Pakistan Movement',
      explanation: 'The Muslim League was founded to safeguard the political rights and interests of Muslims in India.',
    ),
    MockQuestion(
      id: 'p207-18', subject: MockSubject.pakistanStudies, question: 'Pervez Hoodbhoy is known as which of the following: an activist, a professor and a nuclear physicist?',
      options: ['Activist only', 'Professor only', 'Nuclear physicist only', 'All of these'], correctIndex: 3, topic: 'Personalities',
      explanation: 'Pervez Hoodbhoy is a Pakistani nuclear physicist, a professor, and a well known public activist on education and social issues.',
    ),
    MockQuestion(
      id: 'p207-19', subject: MockSubject.generalKnowledge, question: 'In which country is the Alhambra palace, located in the city of Granada?',
      options: ['Portugal', 'Spain', 'Morocco', 'Italy'], correctIndex: 1, topic: 'Geography',
      explanation: 'The Alhambra is a palace and fortress in Granada, Spain, built during the Muslim rule of Andalusia.',
    ),
    MockQuestion(
      id: 'p207-20', subject: MockSubject.pakistanStudies, question: 'Dr A. Q. Khan, the scientist associated with the nuclear programme of Pakistan, was trained in which field of engineering?',
      options: ['Metallurgical engineer only', 'Chemical engineer only', 'Both A and B', 'Neither'], correctIndex: 0, topic: 'Science Personalities',
      explanation: 'A. Q. Khan trained in metallurgical engineering throughout: he studied physics, then materials technology, and took his doctorate in metallurgical engineering at Leuven in 1972, with a thesis on copper-based martensites. No chemical engineering qualification is recorded for him.',
    ),
    MockQuestion(
      id: 'p207-21', subject: MockSubject.pakistanStudies, question: 'Which political party won the 1970 general elections in West Pakistan?',
      options: ['Muslim League', 'PPP', 'Awami League', 'Jamaat-e-Islami'], correctIndex: 1, topic: 'Pakistan History',
      explanation: 'The Pakistan Peoples Party won the majority of seats in West Pakistan in the 1970 elections, while the Awami League won in East Pakistan.',
    ),
    MockQuestion(
      id: 'p207-22', subject: MockSubject.pakistanStudies, question: 'Who served as Prime Minister of Pakistan immediately after the military takeover of October 1999?',
      options: ['Nawaz Sharif', 'Benazir Bhutto', 'None of these', 'Zafarullah Jamali'], correctIndex: 2, topic: 'Pakistan History',
      explanation: 'After the takeover of October 1999 there was no prime minister in office. Zafarullah Jamali became prime minister only after the 2002 elections.',
    ),
    MockQuestion(
      id: 'p207-23', subject: MockSubject.generalKnowledge, question: 'In which battle did Sher Shah Suri defeat the Mughal emperor Humayun in 1539?',
      options: ['Battle of Panipat', 'Battle of Chausa', 'Battle of Kannauj', 'Battle of Haldighati'], correctIndex: 1, topic: 'History',
      explanation: 'Sher Shah Suri defeated Humayun at the Battle of Chausa in 1539, and again at Kannauj in 1540.',
    ),
    MockQuestion(
      id: 'p207-24', subject: MockSubject.pakistanStudies, question: 'Which of the following is the name of a submarine of the Pakistan Navy?',
      options: ['Hangoor', 'Marseille', 'Toronto', 'Kyoto'], correctIndex: 0, topic: 'Military History',
      explanation: 'PNS Hangor was the Pakistan Navy submarine that sank the Indian frigate INS Khukri on 9 December 1971, during the 1971 war.',
    ),
    MockQuestion(
      id: 'p207-25', subject: MockSubject.generalKnowledge, question: 'Which Viceroy ordered the Partition of Bengal in 1905?',
      options: ['Lord Curzon', 'Lord Minto', 'Lord Irwin', 'Lord Wavell'], correctIndex: 0, topic: 'History',
      explanation: 'Lord Curzon, Viceroy of India, ordered the Partition of Bengal in 1905, a decision reversed in 1911.',
    ),
    MockQuestion(
      id: 'p207-26', subject: MockSubject.pakistanStudies, question: 'Who was the first civilian martial law administrator of Pakistan, in December 1971?',
      options: ['Ayub Khan', 'Z. A. Bhutto', 'Yahya Khan', 'Ghulam Ishaq Khan'], correctIndex: 1, topic: 'Pakistan History',
      explanation: 'Zulfikar Ali Bhutto took over as President and the first civilian martial law administrator in December 1971 after the fall of Dhaka.',
    ),
    MockQuestion(
      id: 'p207-27', subject: MockSubject.pakistanStudies, question: 'Which Pakistani businessman founded the Hashoo Group, owner of the Marriott and Pearl Continental hotel chains in Pakistan?',
      options: ['Mian Mansha', 'Sadruddin Hashwani', 'Bashir Ali Mohammad', 'Sultan Lakhani'], correctIndex: 1, topic: 'Business',
      explanation: 'Sadruddin Hashwani founded the Hashoo Group, which owns the Pearl Continental and Marriott hotels in Pakistan.',
    ),
    MockQuestion(
      id: 'p207-28', subject: MockSubject.pakistanStudies, question: 'Who first proposed the name Pakistan, in a pamphlet published in 1933?',
      options: ['Muhammad Ali Jinnah', 'Chaudhry Rehmat Ali', 'Allama Iqbal', 'Liaquat Ali Khan'], correctIndex: 1, topic: 'Pakistan Movement',
      explanation: 'Chaudhry Rehmat Ali proposed the name Pakistan in his 1933 pamphlet Now or Never.',
    ),
    MockQuestion(
      id: 'p207-29', subject: MockSubject.pakistanStudies, question: 'The Khilafat Movement aimed to prevent which outcome for the Ottoman Caliphate after the First World War?',
      options: ['Disbandment of the Ottoman Empire', 'Rise of the Ottoman Empire', 'Alliance with Britain', 'End of the Sultanate in Egypt'], correctIndex: 0, topic: 'Pakistan Movement',
      explanation: 'The Khilafat Movement aimed to prevent the dismemberment and disbandment of the Ottoman Caliphate and to protect the holy places. The wording as printed, Disband of Ottoman Empire, is corrected here to Disbandment of the Ottoman Empire.',
    ),
    MockQuestion(
      id: 'p207-30', subject: MockSubject.pakistanStudies, question: 'Which country is the only Muslim majority state to have developed nuclear weapons?',
      options: ['Iran', 'Turkey', 'Pakistan', 'Egypt'], correctIndex: 2, topic: 'Defence',
      explanation: 'Pakistan, which conducted nuclear tests in 1998, is the only Muslim majority state with nuclear weapons.',
    ),
    MockQuestion(
      id: 'p207-31', subject: MockSubject.generalKnowledge, question: 'Which constitutional body coordinates matters between the federation and the provinces in Pakistan?',
      options: ['IPPC', 'NFC', 'CCI', 'None of these'], correctIndex: 2, topic: 'Constitution',
      explanation: 'The Council of Common Interests, CCI, is the constitutional body that coordinates matters between the federation and the provinces, under Articles 153 and 154 of the Constitution. The IPPC is the plant health convention, not a constitutional body.',
    ),
    MockQuestion(
      id: 'p207-32', subject: MockSubject.generalKnowledge, question: 'In which year did the Taliban return to power in Afghanistan?',
      options: ['2001', '2014', '2021', '2023'], correctIndex: 2, topic: 'Current Affairs',
      explanation: 'The Taliban returned to power in Afghanistan in August 2021 as foreign forces withdrew from the country.',
    ),
    MockQuestion(
      id: 'p207-33', subject: MockSubject.pakistanStudies, question: 'How many administrative divisions does the province of Punjab have?',
      options: ['7', '8', '9', '10'], correctIndex: 3, topic: 'Geography of Pakistan',
      explanation: 'Punjab has ten administrative divisions, including the Gujrat division created in 2022.',
    ),
    MockQuestion(
      id: 'p207-34', subject: MockSubject.pakistanStudies, question: 'Which project connects Gwadar Port with western China through Pakistan?',
      options: ['CPEC', 'TAPI', 'IPPs', 'RCD'], correctIndex: 0, topic: 'Economy',
      explanation: 'The China-Pakistan Economic Corridor connects Gwadar Port in Balochistan with Kashgar in western China.',
    ),
    MockQuestion(
      id: 'p207-35', subject: MockSubject.pakistanStudies, question: 'Which is the longest river in Pakistan?',
      options: ['Jhelum', 'Chenab', 'Indus', 'Ravi'], correctIndex: 2, topic: 'Geography of Pakistan',
      explanation: 'The River Indus, about 3,180 kilometres long, is the longest river in Pakistan.',
    ),
    MockQuestion(
      id: 'p207-36', subject: MockSubject.pakistanStudies, question: 'The Tezgam Express runs between which two cities?',
      options: ['Karachi and Lahore', 'Karachi and Rawalpindi', 'Lahore and Peshawar', 'Karachi and Quetta'], correctIndex: 1, topic: 'Pakistan Railways',
      explanation: 'The Tezgam Express runs between Karachi Cantt and Rawalpindi.',
    ),
    MockQuestion(
      id: 'p207-37', subject: MockSubject.pakistanStudies, question: 'Which motorway connects Multan with Sukkur?',
      options: ['M-2', 'M-3', 'M-4', 'M-5'], correctIndex: 3, topic: 'Geography of Pakistan',
      explanation: 'The M-5 motorway runs from Multan to Sukkur and is part of the Karachi to Peshawar motorway route.',
    ),
    MockQuestion(
      id: 'p207-38', subject: MockSubject.pakistanStudies, question: 'Which Pakistani player won the IBSF World Snooker Championship?',
      options: ['Muhammad Asif', 'Muhammad Sajjad', 'Asjad Iqbal', 'Babar Masih'], correctIndex: 0, topic: 'Sports',
      explanation: 'Muhammad Asif won the IBSF World Snooker Championship in 2012 and again in 2019.',
    ),
    MockQuestion(
      id: 'p207-39', subject: MockSubject.pakistanStudies, question: 'What was the total budget of Pakistan for the financial year 2025-2026, according to the estimate used in this paper?',
      options: ['14.6 trillion rupees', '19 trillion rupees', '17.6 trillion rupees', '20 trillion rupees'], correctIndex: 2, topic: 'Economy',
      explanation: 'The total budget figure given in the paper for 2025-2026 is 17.6 trillion rupees. This figure is the estimate given in the paper.',
    ),
    MockQuestion(
      id: 'p207-40', subject: MockSubject.pakistanStudies, question: 'How many constitutional amendments had been passed in Pakistan by late 2025?',
      options: ['25', '26', '27', '28'], correctIndex: 2, topic: 'Constitution',
      explanation: 'The 27th Constitutional Amendment was passed in November 2025, bringing the total to 27. The printed key listed 26, which was correct before the 27th Amendment, and the book itself notes Currently 27.',
    ),
    MockQuestion(
      id: 'p207-41', subject: MockSubject.generalKnowledge, question: 'Which European country is shaped like a boot on the map?',
      options: ['Greece', 'Italy', 'Spain', 'Portugal'], correctIndex: 1, topic: 'Geography',
      explanation: 'Italy is shaped like a boot, with the peninsula extending into the Mediterranean Sea.',
    ),
    MockQuestion(
      id: 'p207-42', subject: MockSubject.generalKnowledge, question: 'Which is the deepest lake in the world?',
      options: ['Caspian Sea', 'Lake Superior', 'Lake Victoria', 'None of these'], correctIndex: 3, topic: 'Geography',
      explanation: 'Lake Baikal in Siberia is the deepest lake in the world, at over 1,600 metres. It is not listed, so None of these is correct.',
    ),
    MockQuestion(
      id: 'p207-43', subject: MockSubject.generalKnowledge, question: 'Which country has the largest Muslim population in the world?',
      options: ['Pakistan', 'India', 'Indonesia', 'Bangladesh'], correctIndex: 2, topic: 'Geography',
      explanation: 'Indonesia has the largest Muslim population of any country, with over 230 million Muslims.',
    ),
    MockQuestion(
      id: 'p207-44', subject: MockSubject.generalKnowledge, question: 'Which city is the capital of Kazakhstan?',
      options: ['Almaty', 'Astana', 'Tashkent', 'Bishkek'], correctIndex: 1, topic: 'Geography',
      explanation: 'Astana is the capital of Kazakhstan. Almaty is the largest city and the former capital.',
    ),
    MockQuestion(
      id: 'p207-45', subject: MockSubject.pakistanStudies, question: 'In which country is the mountain peak named Kuchnai Saar located, according to the listing in this paper?',
      options: ['Nepal', 'Pakistan', 'China', 'Bhutan'], correctIndex: 1, topic: 'Geography of Pakistan',
      explanation: 'The listing gives Pakistan for the peak named Kuchnai Saar. The name is garbled in the scan and could not be verified, so this item is unverified.',
    ),
    MockQuestion(
      id: 'p207-46', subject: MockSubject.generalKnowledge, question: 'Which country is the largest exporter of crude oil among OPEC members?',
      options: ['Iraq', 'Saudi Arabia', 'Iran', 'Kuwait'], correctIndex: 1, topic: 'Economy',
      explanation: 'Saudi Arabia is the largest oil exporter in OPEC and one of the largest oil producers in the world.',
    ),
    MockQuestion(
      id: 'p207-47', subject: MockSubject.generalKnowledge, question: 'Which city is the capital of New Zealand?',
      options: ['Auckland', 'Wellington', 'Christchurch', 'Hamilton'], correctIndex: 1, topic: 'Geography',
      explanation: 'Wellington is the capital of New Zealand, although Auckland is the largest city.',
    ),
    MockQuestion(
      id: 'p207-48', subject: MockSubject.everydayScience, question: 'Photosynthesis in plant cells takes place in which organelle?',
      options: ['Nucleus', 'Chloroplast', 'Mitochondrion', 'Vacuole'], correctIndex: 1, topic: 'Biology',
      explanation: 'Photosynthesis takes place in chloroplasts, the organelles that contain the green pigment chlorophyll.',
    ),
    MockQuestion(
      id: 'p207-49', subject: MockSubject.everydayScience, question: 'Which is the lightest chemical element?',
      options: ['Helium', 'Hydrogen', 'Oxygen', 'Nitrogen'], correctIndex: 1, topic: 'Chemistry',
      explanation: 'Hydrogen, with atomic number 1, is the lightest element.',
    ),
    MockQuestion(
      id: 'p207-50', subject: MockSubject.everydayScience, question: 'Which metal is the most abundant metal in the crust of the Earth?',
      options: ['Iron', 'Aluminum', 'Copper', 'Zinc'], correctIndex: 1, topic: 'Chemistry',
      explanation: 'Aluminum is the most abundant metal in the Earth crust, although oxygen and silicon are more abundant elements overall.',
    ),
    MockQuestion(
      id: 'p207-51', subject: MockSubject.everydayScience, question: 'The change of water vapour into liquid water is called what?',
      options: ['Evaporation', 'Condensation', 'Sublimation', 'Freezing'], correctIndex: 1, topic: 'Physics',
      explanation: 'Condensation is the change from gas to liquid, as when dew forms or steam cools on a cold surface.',
    ),
    MockQuestion(
      id: 'p207-52', subject: MockSubject.everydayScience, question: 'A solution with a pH slightly above 7 that only partly dissociates in water is best described as which type of base?',
      options: ['Strong base', 'Weak base', 'Neutral salt', 'Acid'], correctIndex: 1, topic: 'Chemistry',
      explanation: 'A weak base only partly dissociates in water. The word alkaline is also used for bases that dissolve in water, so the wording of this item is debatable.',
    ),
    MockQuestion(
      id: 'p207-53', subject: MockSubject.everydayScience, question: 'What is the function of a salt bridge in an electrochemical cell?',
      options: ['To produce electricity', 'To allow movement of ions and maintain charge balance', 'To heat the cell', 'To stop all current'], correctIndex: 1, topic: 'Chemistry',
      explanation: 'A salt bridge allows ions to move between the two halves of the cell, keeping each side electrically neutral so current can flow.',
    ),
    MockQuestion(
      id: 'p207-54', subject: MockSubject.generalKnowledge, question: 'In computing, the acronym VIRUS is expanded as which phrase?',
      options: ['Vital Information Resource Under Siege', 'Very Important Resource Utility System', 'Virtual Information Recovery Unit', 'Virus Infection Removal Utility'], correctIndex: 0, topic: 'Computer',
      explanation: 'VIRUS is expanded, as a backronym, as Vital Information Resource Under Siege.',
    ),
    MockQuestion(
      id: 'p207-55', subject: MockSubject.generalKnowledge, question: 'Which statement correctly distinguishes inkjet printers from laser printers?',
      options: ['Inkjet sprays liquid ink, laser uses toner', 'Inkjet uses toner, laser sprays ink', 'Both use liquid ink', 'Both use solid wax only'], correctIndex: 0, topic: 'Computer',
      explanation: 'An inkjet printer sprays tiny drops of liquid ink, while a laser printer uses dry toner powder fused onto the paper.',
    ),
    MockQuestion(
      id: 'p207-56', subject: MockSubject.generalKnowledge, question: 'Which element is the main material used to make computer chips?',
      options: ['Copper', 'Silicon', 'Carbon', 'Gold'], correctIndex: 1, topic: 'Computer',
      explanation: 'Silicon is the semiconductor material from which most computer chips are made.',
    ),
    MockQuestion(
      id: 'p207-57', subject: MockSubject.generalKnowledge, question: 'Which statement correctly distinguishes a hard disk drive from a solid state drive?',
      options: ['HDD uses flash memory, SSD uses magnetic storage', 'HDD uses magnetic storage, SSD uses flash memory', 'Both use magnetic storage', 'Both use optical discs'], correctIndex: 1, topic: 'Computer',
      explanation: 'A hard disk drive stores data magnetically on spinning platters, while a solid state drive stores data in flash memory with no moving parts.',
    ),
    MockQuestion(
      id: 'p207-58', subject: MockSubject.generalKnowledge, question: 'Which layer of the OSI model handles data formatting, compression and encryption?',
      options: ['Network Layer', 'Transport Layer', 'Presentation Layer', 'Physical Layer'], correctIndex: 2, topic: 'Computer',
      explanation: 'The Presentation Layer, layer 6 of the OSI model, formats, compresses and encrypts data for the application.',
    ),
    MockQuestion(
      id: 'p207-59', subject: MockSubject.generalKnowledge, question: 'Which language is used to structure the content of pages on the World Wide Web?',
      options: ['Python', 'HTML', 'Java', 'SQL'], correctIndex: 1, topic: 'Computer',
      explanation: 'HTML, the Hypertext Markup Language, structures the content of web pages.',
    ),
    MockQuestion(
      id: 'p207-60', subject: MockSubject.mathematics, question: 'How many sides does a hexagon have?',
      options: ['5', '6', '7', '8'], correctIndex: 1, topic: 'Geometry',
      explanation: 'A hexagon is a polygon with six sides.',
    ),
    MockQuestion(
      id: 'p207-61', subject: MockSubject.mathematics, question: 'What is the value of 4/7 multiplied by 4/9?',
      options: ['8/63', '16/63', '16/16', '4/63'], correctIndex: 1, topic: 'Fractions',
      explanation: 'Multiplying numerators gives 16 and multiplying denominators gives 63, so the result is 16 over 63.',
    ),
    MockQuestion(
      id: 'p207-62', subject: MockSubject.mathematics, question: 'What is the product of 6 and 9?',
      options: ['45', '52', '54', '63'], correctIndex: 2, topic: 'Arithmetic',
      explanation: 'Six multiplied by nine is 54.',
    ),
    MockQuestion(
      id: 'p207-63', subject: MockSubject.mathematics, question: 'What is 63 percent expressed as a decimal?',
      options: ['0.063', '0.63', '6.3', '63.0'], correctIndex: 1, topic: 'Decimals',
      explanation: '63 percent is 63 divided by 100, which is 0.63.',
    ),
    MockQuestion(
      id: 'p207-64', subject: MockSubject.mathematics, question: 'A train travels 240 km at a steady speed of 60 km per hour. How long does the journey take?',
      options: ['3 hours', '4 hours', '5 hours', '6 hours'], correctIndex: 1, topic: 'Speed and Time',
      explanation: 'Time is distance divided by speed, so 240 divided by 60 is 4 hours.',
    ),
    MockQuestion(
      id: 'p207-65', subject: MockSubject.mathematics, question: 'Two numbers add up to 80 and differ by 12. Which pair of numbers are they?',
      options: ['34 and 46', '30 and 50', '36 and 44', '28 and 52'], correctIndex: 0, topic: 'Algebra',
      explanation: '34 and 46 add up to 80 and differ by 12.',
    ),
    MockQuestion(
      id: 'p207-66', subject: MockSubject.mathematics, question: 'What is 1 divided by 0.75, expressed as a fraction?',
      options: ['3/4', '4/3', '1/3', '7/5'], correctIndex: 1, topic: 'Fractions',
      explanation: 'One divided by three quarters is four thirds, which is 1.33 as a decimal.',
    ),
    MockQuestion(
      id: 'p207-67', subject: MockSubject.mathematics, question: 'Which point is an x-intercept of the graph of y equals x squared minus 2x minus 3?',
      options: ['(3, 0)', '(0, 3)', '(1, 0)', '(2, 0)'], correctIndex: 0, topic: 'Graphs',
      explanation: 'Setting y to zero gives x squared minus 2x minus 3 equals zero, which factors to x minus 3 times x plus 1, so one intercept is (3, 0). The other intercept, (-1, 0), is not listed.',
    ),
    MockQuestion(
      id: 'p207-68', subject: MockSubject.english, question: 'A word used in place of a noun is called what?',
      options: ['Verb', 'Adjective', 'Pronoun', 'Adverb'], correctIndex: 2, topic: 'Grammar',
      explanation: 'A pronoun, such as he, she or they, is used in place of a noun.',
    ),
    MockQuestion(
      id: 'p207-69', subject: MockSubject.english, question: 'Choose the correct preposition: He arrived ___ noon.',
      options: ['In', 'At', 'On', 'By'], correctIndex: 1, topic: 'Prepositions',
      explanation: 'At is used with a precise time such as noon.',
    ),
    MockQuestion(
      id: 'p207-70', subject: MockSubject.english, question: 'Choose the word closest in meaning to postpone:',
      options: ['Delay', 'Hasten', 'Cancel', 'Begin'], correctIndex: 0, topic: 'Vocabulary',
      explanation: 'To postpone is to delay an event to a later time.',
    ),
    MockQuestion(
      id: 'p207-71', subject: MockSubject.english, question: 'Choose the correct preposition: He is ___ the room.',
      options: ['On', 'At', 'In', 'To'], correctIndex: 2, topic: 'Prepositions',
      explanation: 'In is used for being inside an enclosed space such as a room.',
    ),
    MockQuestion(
      id: 'p207-72', subject: MockSubject.english, question: 'The idiom cheek by jowl means what?',
      options: ['Far apart', 'Close together', 'Face to face in anger', 'Back to back'], correctIndex: 1, topic: 'Idioms',
      explanation: 'Cheek by jowl means very close together. The stem as printed misprints the idiom as CHECK by jowl, which is corrected here.',
    ),
    MockQuestion(
      id: 'p207-73', subject: MockSubject.english, question: 'Choose the correct indirect form of: The teacher said, He is a cheat.',
      options: ['The teacher said that he had been a cheat', 'The teacher said that he is being a cheat', 'The teacher said that he has been a cheat', 'The teacher said that he is a cheat'], correctIndex: 3, topic: 'Narration',
      explanation: 'In reported speech, a statement that is still true, or a general opinion still held, may keep the present tense, so he is a cheat is retained in the reported form. This item is debatable, since the past tense form is also often accepted.',
    ),
    MockQuestion(
      id: 'p207-74', subject: MockSubject.english, question: 'Choose the grammatically correct sentence.',
      options: ['The committee has taken its decision', 'The committee have taken its decision', 'The committee has took its decision', 'The committee have took its decision'], correctIndex: 0, topic: 'Grammar',
      explanation: 'Committee is a collective noun and takes a singular verb here, and the past participle of take is taken, so The committee has taken its decision is the correct sentence.',
    ),
    MockQuestion(
      id: 'p207-75', subject: MockSubject.english, question: 'Choose the correct preposition: She is interested ___ music.',
      options: ['At', 'On', 'In', 'Of'], correctIndex: 2, topic: 'Prepositions',
      explanation: 'Interested is followed by in, so she is interested in music.',
    ),
    MockQuestion(
      id: 'p207-76', subject: MockSubject.english, question: 'How many independent clauses does a compound sentence contain at minimum?',
      options: ['One clause', 'Two clauses', 'Three clauses', 'No clause'], correctIndex: 1, topic: 'Grammar',
      explanation: 'A compound sentence joins at least two independent clauses with a conjunction or a semicolon.',
    ),
    MockQuestion(
      id: 'p207-77', subject: MockSubject.english, question: 'The phrase go into detail means what?',
      options: ['Discuss the detail', 'Avoid the detail', 'Hide the detail', 'Forget the detail'], correctIndex: 0, topic: 'Phrases',
      explanation: 'To go into detail is to discuss the details of a subject fully.',
    ),
    MockQuestion(
      id: 'p207-78', subject: MockSubject.english, question: 'Choose the correctly punctuated sentence in direct speech.',
      options: ['Father said to his son get up early in the morning', 'Father said, to his son Get up early in the morning', "Father said, to his son, 'Get up early in the morning.'", 'Father said to his son, Get up early in the morning'], correctIndex: 2, topic: 'Punctuation',
      explanation: 'The correctly punctuated form separates the reporting clause with commas and places the spoken words in quotation marks.',
    ),
    MockQuestion(
      id: 'p207-79', subject: MockSubject.english, question: 'The word honesty, in the phrase honesty is the best policy, is which part of speech?',
      options: ['Verb', 'Adjective', 'Noun', 'Adverb'], correctIndex: 2, topic: 'Grammar',
      explanation: 'Honesty is an abstract noun, naming a quality.',
    ),
    MockQuestion(
      id: 'p207-80', subject: MockSubject.english, question: 'Choose the correct passive form of: They are painting the house.',
      options: ['The house is painted', 'The house is painting', 'The house is being painted', 'The house was painted'], correctIndex: 2, topic: 'Voice',
      explanation: 'The present continuous passive is formed with is being plus the past participle, so the house is being painted.',
    ),
    MockQuestion(
      id: 'p207-81', subject: MockSubject.english, question: 'Choose the correct word: The light was switched ___.',
      options: ['On', 'Off', 'In', 'Up'], correctIndex: 1, topic: 'Phrasal Verbs',
      explanation: 'A light that is no longer shining was switched off.',
    ),
    MockQuestion(
      id: 'p207-82', subject: MockSubject.english, question: 'Choose the sentence in which the phrase while running down the street is placed first.',
      options: ['Running down the street, the dog barked loudly', 'The dog barked loudly, running down the street', 'Down the street running, the dog barked loudly', 'While running down the street, the dog barked loudly'], correctIndex: 3, topic: 'Grammar',
      explanation: 'The listed answer is the sentence beginning with While running down the street. The placement of the modifier in this sentence is debatable, since the phrase strictly describes the dog.',
    ),
    MockQuestion(
      id: 'p207-83', subject: MockSubject.generalKnowledge, question: 'Urdu: Mustaqil ka zidd (opposite) kya hai?',
      options: ['Mustaqil', 'Ghair Mustaqil', 'Mazboot', 'Qaim'], correctIndex: 1, topic: 'Urdu Vocabulary',
      explanation: 'Mustaqil ka zidd ghair mustaqil hai, yani jo qaim aur sabit na ho.',
    ),
    MockQuestion(
      id: 'p207-84', subject: MockSubject.generalKnowledge, question: 'Urdu: Mushkil aur takleef deh kaam ko kya kehte hain?',
      options: ['Mehnat', 'Mashaqat', 'Aasani', 'Khushi'], correctIndex: 1, topic: 'Urdu Vocabulary',
      explanation: 'Mashaqat se murad hai mushkil aur takleef deh kaam, jab ke mehnat aam kaam ko kehte hain.',
    ),
    MockQuestion(
      id: 'p207-85', subject: MockSubject.generalKnowledge, question: 'Urdu: Khali jagah pur karen: Aap hi ki ____ ka sadqa hai.',
      options: ['Mehnat', 'Jootiyon', 'Kapron', 'Pagri'], correctIndex: 1, topic: 'Urdu Vocabulary',
      explanation: 'Is khali jagah ke liye paper mein Jootiyon jawab diya gaya hai. Yeh jawab paper ki fehrist par mabni hai aur is ki aazadana tasdeeq nahi ho saki.',
    ),
    MockQuestion(
      id: 'p207-86', subject: MockSubject.generalKnowledge, question: 'Urdu: Khat mein jis shakhs ko khat likha jaye use kya kehte hain?',
      options: ['Khat likhne wala', 'Jisay khat likha jaye', 'Dakiya', 'Khat parhne wala'], correctIndex: 1, topic: 'Urdu Grammar',
      explanation: 'Jis shakhs ko khat likha jaye use mukhatab kehte hain, yani jisay khat likha jaye.',
    ),
    MockQuestion(
      id: 'p207-87', subject: MockSubject.generalKnowledge, question: 'Urdu: Us nasr ko kya kehte hain jis mein qafiye ki pabandi ho?',
      options: ['Nasr-e-Musajja', 'Nasr-e-Ghair Musajja', 'Nazm', 'Ghazal'], correctIndex: 0, topic: 'Urdu Literature',
      explanation: 'Nasr-e-Musajja woh nasr hai jis mein qafiye aur saj ki pabandi hoti hai.',
    ),
    MockQuestion(
      id: 'p207-88', subject: MockSubject.generalKnowledge, question: 'Urdu: Kis cheez ko zindagi ki alamat kaha jata hai?',
      options: ['Pani', 'Hawa', 'Mitti', 'Aag'], correctIndex: 0, topic: 'Urdu Vocabulary',
      explanation: 'Pani ko zindagi ki alamat kaha jata hai, kyun ke pani ke baghair zindagi mumkin nahi.',
    ),
    MockQuestion(
      id: 'p207-89', subject: MockSubject.generalKnowledge, question: 'Urdu: Tashbeeh aur istiara ka ilm kis shobay se mutaliq hai?',
      options: ['Ilm-e-Bayan', 'Ilm-e-Badee', 'Ilm-e-Sarf', 'Ilm-e-Nahw'], correctIndex: 0, topic: 'Urdu Grammar',
      explanation: 'Tashbeeh aur istiara ilm-e-bayan se mutaliq hain, jo kalaam ki khoobsurti aur wazahat ka ilm hai.',
    ),
    MockQuestion(
      id: 'p207-90', subject: MockSubject.generalKnowledge, question: 'Urdu: Lohe ke chane chabana ka matlab kya hai?',
      options: ['Mushkil kaam sar anjam dena', 'Aasan kaam karna', 'Khana khana', 'Bhag jana'], correctIndex: 0, topic: 'Urdu Idioms',
      explanation: 'Lohe ke chane chabana ka matlab hai mushkil kaam sar anjam dena.',
    ),
    MockQuestion(
      id: 'p207-91', subject: MockSubject.generalKnowledge, question: 'Urdu: Ghazal ke matlay mein kitne misre hote hain?',
      options: ['1', '2', '3', '4'], correctIndex: 1, topic: 'Urdu Poetry',
      explanation: 'Ghazal ka matla aik shair hota hai jis mein do misre hote hain.',
    ),
    MockQuestion(
      id: 'p207-92', subject: MockSubject.generalKnowledge, question: 'Urdu: Us shakhs ko kya kehte hain jo ek hi maa baap ki aulad ho aur mard ho?',
      options: ['Bhai', 'Dost', 'Chacha', 'Mamoon'], correctIndex: 0, topic: 'Urdu Vocabulary',
      explanation: 'Ek hi maa baap ki aulad aur mard rishtedar bhai kehlata hai.',
    ),
    MockQuestion(
      id: 'p207-93', subject: MockSubject.islamiat, question: 'Which wife of the Prophet Muhammad is known for her scholarship in Hadith and Islamic law?',
      options: ['Hazrat Khadija (RA)', 'Hazrat Ayesha (RA)', 'Hazrat Hafsa (RA)', 'Hazrat Safiyya (RA)'], correctIndex: 1, topic: 'Seerat',
      explanation: 'Hazrat Ayesha (RA) narrated a large number of Hadith and was consulted on questions of Islamic law.',
    ),
    MockQuestion(
      id: 'p207-94', subject: MockSubject.islamiat, question: 'For how many years did Hazrat Usman (RA) remain Caliph?',
      options: ['10 years', '11 years', '12 years', '14 years'], correctIndex: 2, topic: 'Islamic History',
      explanation: 'Hazrat Usman (RA) was Caliph from 644 to 656 AD, a period of about twelve years.',
    ),
    MockQuestion(
      id: 'p207-95', subject: MockSubject.islamiat, question: 'According to the Quranic injunctions on modesty, men are told to lower their gaze and women are told to do what?',
      options: ['Cover themselves completely', 'Remain silent always', 'Avoid all travel', 'Wear bright colours'], correctIndex: 0, topic: 'Quran',
      explanation: 'The Quran directs believing men to lower their gaze and believing women to draw their coverings over themselves and guard their modesty.',
    ),
    MockQuestion(
      id: 'p207-96', subject: MockSubject.islamiat, question: 'In which Hijri month are the rites of Hajj performed?',
      options: ['Ramadan', 'Shawwal', 'Zilhaj', 'Muharram'], correctIndex: 2, topic: 'Worship',
      explanation: 'The rites of Hajj fall in the month of Zilhaj, also spelled Dhul-Hijjah, the twelfth month of the Islamic year. The month name is approximate in spelling.',
    ),
    MockQuestion(
      id: 'p207-97', subject: MockSubject.islamiat, question: 'Which city is the capital of Egypt, home to the historic Al-Azhar mosque and university?',
      options: ['Alexandria', 'Cairo', 'Giza', 'Luxor'], correctIndex: 1, topic: 'Islamic Geography',
      explanation: 'Cairo is the capital of Egypt and the home of Al-Azhar, one of the oldest centres of Islamic learning.',
    ),
    MockQuestion(
      id: 'p207-98', subject: MockSubject.islamiat, question: 'Which Jewish tribe of Madinah was dealt with after the Battle of the Trench for breaking its agreement with the Muslims?',
      options: ['Banu Nadir', 'Banu Quraiza', 'Banu Qaynuqa', 'Banu Hashim'], correctIndex: 1, topic: 'Seerat',
      explanation: 'Banu Quraiza, a Jewish tribe of Madinah, was dealt with after the Battle of the Trench for aiding the confederate forces against the Muslims.',
    ),
    MockQuestion(
      id: 'p207-99', subject: MockSubject.islamiat, question: 'Which historic institution of Islamic learning is located in Cairo, Egypt?',
      options: ['Al-Azhar', 'Qarawiyyin', 'Zaytuna', 'Nizamiyya'], correctIndex: 0, topic: 'Islamic History',
      explanation: 'Al-Azhar in Cairo, founded in the tenth century, is one of the oldest universities in the world and a leading centre of Sunni learning.',
    ),
    MockQuestion(
      id: 'p207-100', subject: MockSubject.islamiat, question: 'At which battle was Hazrat Hamza (RA), the uncle of the Prophet, martyred?',
      options: ['Badr', 'Uhud', 'Khandaq', 'Tabuk'], correctIndex: 1, topic: 'Seerat',
      explanation: 'Hazrat Hamza (RA) was martyred at the Battle of Uhud in 3 A.H.',
    ),
  ],
  latestUpdates: [],
);
