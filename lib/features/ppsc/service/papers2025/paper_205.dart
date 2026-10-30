import '../../model/mock_question.dart';
import '../../model/paper_test.dart';

// PRACTICE MATERIAL ONLY.
// This is a practice mock test written in fresh wording for revision.
// It is not an official paper, not a verbatim reproduction of any exam,
// and it does not predict any real exam. Answers were checked against
// general reference facts at build time; where a printed key differed
// from the researched fact, the researched fact was used.

const PaperTest paper205 = PaperTest(
  id: '2025-205',
  paperNo: 205,
  year: 2025,
  post: 'Junior Clerk (BS-11)',
  department: 'Punjab Public Service Commission',
  examDate: '27.09.2025',
  questions: [
    // General Knowledge
    MockQuestion(
      id: 'p205-1', subject: MockSubject.generalKnowledge, question: 'In which year was the South Asian Association for Regional Cooperation (SAARC) established?',
      options: ['1983', '1985', '1987', '1989'], correctIndex: 1, topic: 'International Organisations',
      explanation: 'SAARC was established in 1985, with its first summit held in Dhaka in December 1985.',
    ),
    MockQuestion(
      id: 'p205-2', subject: MockSubject.pakistanStudies, question: 'Who presented the Lahore Resolution at the annual session of the Muslim League in 1940?',
      options: ['Muhammad Ali Jinnah', 'Liaquat Ali Khan', 'A. K. Fazal-ul-Haq', 'Khawaja Nazimuddin'], correctIndex: 2, topic: 'Pakistan Movement',
      explanation: 'A. K. Fazlul Huq presented the Lahore Resolution on 23 March 1940, demanding separate states for Muslims in India.',
    ),
    MockQuestion(
      id: 'p205-3', subject: MockSubject.pakistanStudies, question: 'In which city was the All India Muslim League founded in December 1906?',
      options: ['Lahore', 'Karachi', 'Dhaka', 'Lucknow'], correctIndex: 2, topic: 'Pakistan Movement',
      explanation: 'The All India Muslim League was founded in Dhaka in December 1906 during the annual Muhammadan Educational Conference.',
    ),
    MockQuestion(
      id: 'p205-4', subject: MockSubject.generalKnowledge, question: 'Which country has the largest land area in the world?',
      options: ['China', 'Canada', 'Russia', 'United States'], correctIndex: 2, topic: 'Geography',
      explanation: 'Russia is the largest country in the world by land area, covering about 17 million square kilometres.',
    ),
    MockQuestion(
      id: 'p205-5', subject: MockSubject.pakistanStudies, question: 'The takeover of power in Pakistan in October 1958 is described as rule by which institution?',
      options: ['Judiciary', 'Military', 'Bureaucracy', 'Parliament'], correctIndex: 1, topic: 'Pakistan History',
      explanation: 'The takeover of October 1958 brought military rule to Pakistan, with General Ayub Khan taking power.',
    ),
    MockQuestion(
      id: 'p205-6', subject: MockSubject.generalKnowledge, question: 'In which year was the Bretton Woods Conference held, leading to the creation of the IMF and the World Bank?',
      options: ['1919', '1939', '1944', '1947'], correctIndex: 2, topic: 'World History',
      explanation: 'The Bretton Woods Conference was held in 1944 and led to the creation of the International Monetary Fund and the World Bank.',
    ),
    MockQuestion(
      id: 'p205-7', subject: MockSubject.generalKnowledge, question: 'Which city is the capital of Italy?',
      options: ['Milan', 'Naples', 'Rome', 'Venice'], correctIndex: 2, topic: 'Geography',
      explanation: 'Rome is the capital city of Italy and one of the oldest continuously inhabited cities in Europe.',
    ),
    MockQuestion(
      id: 'p205-8', subject: MockSubject.generalKnowledge, question: 'The headquarters of the United Nations is located in New York, in which country?',
      options: ['United Kingdom', 'USA', 'France', 'Switzerland'], correctIndex: 1, topic: 'International Organisations',
      explanation: 'The headquarters of the United Nations is in New York City in the United States of America.',
    ),
    MockQuestion(
      id: 'p205-9', subject: MockSubject.generalKnowledge, question: 'Which university topped the QS World University Rankings 2025?',
      options: ['Oxford University', 'Harvard University', 'MIT', 'Cambridge University'], correctIndex: 2, topic: 'Education',
      explanation: 'MIT was ranked number one in the QS World University Rankings 2025, while Oxford was ranked number one in the separate Times Higher Education World University Rankings 2025, so the answer depends on which ranking is meant.',
    ),
    MockQuestion(
      id: 'p205-10', subject: MockSubject.generalKnowledge, question: 'Who founded the Kingdom of Saudi Arabia in 1932?',
      options: ['King Faisal', 'Ibn-e-Saud', 'King Khalid', 'King Fahd'], correctIndex: 1, topic: 'World Leaders',
      explanation: 'Abdulaziz ibn Saud, known as Ibn-e-Saud, founded the Kingdom of Saudi Arabia in 1932.',
    ),
    MockQuestion(
      id: 'p205-11', subject: MockSubject.generalKnowledge, question: 'Who was the first woman to win a Nobel Prize?',
      options: ['Marie Curie', 'Mother Teresa', 'Florence Nightingale', 'Rosalind Franklin'], correctIndex: 0, topic: 'Science History',
      explanation: 'Marie Curie won the Nobel Prize in Physics in 1903, becoming the first woman to win a Nobel Prize, and later won the Nobel Prize in Chemistry in 1911.',
    ),
    MockQuestion(
      id: 'p205-12', subject: MockSubject.generalKnowledge, question: 'In which year was the Republic of China proclaimed, after the fall of the Qing dynasty?',
      options: ['1905', '1912', '1921', '1949'], correctIndex: 1, topic: 'World History',
      explanation: 'The Republic of China was proclaimed in 1912. The year 1949 is the founding of the Peoples Republic of China, a different event.',
    ),
    MockQuestion(
      id: 'p205-13', subject: MockSubject.generalKnowledge, question: 'Which city is the capital of Australia?',
      options: ['Sydney', 'Melbourne', 'Canberra', 'Perth'], correctIndex: 2, topic: 'Geography',
      explanation: 'Canberra is the capital city of Australia, although Sydney is the largest city.',
    ),
    MockQuestion(
      id: 'p205-14', subject: MockSubject.generalKnowledge, question: 'Who wrote the novels 1984 and Animal Farm?',
      options: ['Aldous Huxley', 'George Orwell', 'Charles Dickens', 'E. M. Forster'], correctIndex: 1, topic: 'Literature',
      explanation: 'George Orwell wrote Animal Farm in 1945 and 1984 in 1949.',
    ),
    MockQuestion(
      id: 'p205-15', subject: MockSubject.generalKnowledge, question: 'In which year did the Second World War begin?',
      options: ['1914', '1936', '1939', '1941'], correctIndex: 2, topic: 'World History',
      explanation: 'The Second World War began in 1939, when Germany invaded Poland on 1 September 1939.',
    ),
    MockQuestion(
      id: 'p205-16', subject: MockSubject.pakistanStudies, question: 'Which city is the capital of Khyber Pakhtunkhwa province?',
      options: ['Abbottabad', 'Peshawar', 'Mardan', 'Swat'], correctIndex: 1, topic: 'Geography of Pakistan',
      explanation: 'Peshawar is the capital city of Khyber Pakhtunkhwa province in Pakistan.',
    ),
    MockQuestion(
      id: 'p205-17', subject: MockSubject.pakistanStudies, question: 'In which country did Dr Abdul Qadeer Khan complete his PhD, at the University of Leuven?',
      options: ['Germany', 'Belgium', 'Netherlands', 'France'], correctIndex: 1, topic: 'Science Personalities',
      explanation: 'Dr Abdul Qadeer Khan completed his PhD in metallurgical engineering at the Catholic University of Leuven in Belgium.',
    ),
    MockQuestion(
      id: 'p205-18', subject: MockSubject.pakistanStudies, question: 'In which city is the General Headquarters of the Pakistan Army located?',
      options: ['Islamabad', 'Lahore', 'Rawalpindi', 'Karachi'], correctIndex: 2, topic: 'Geography of Pakistan',
      explanation: 'The General Headquarters of the Pakistan Army is located in Rawalpindi.',
    ),
    MockQuestion(
      id: 'p205-19', subject: MockSubject.pakistanStudies, question: 'Which Pakistani athlete won the Olympic gold medal in javelin throw at the Paris 2024 Olympics?',
      options: ['Arshad Nadeem', 'Haider Ali', 'Muhammad Asif', 'Inam Butt'], correctIndex: 0, topic: 'Sports',
      explanation: 'Arshad Nadeem won the gold medal in javelin throw at the Paris 2024 Olympics with a throw of 92.97 metres, an Olympic record.',
    ),
    MockQuestion(
      id: 'p205-20', subject: MockSubject.pakistanStudies, question: 'Tarbela Dam is located in which district of Khyber Pakhtunkhwa?',
      options: ['Swabi', 'Haripur', 'Abbottabad', 'Mansehra'], correctIndex: 1, topic: 'Geography of Pakistan',
      explanation: 'Tarbela Dam, built on the River Indus, is located in Haripur district of Khyber Pakhtunkhwa.',
    ),
    MockQuestion(
      id: 'p205-21', subject: MockSubject.generalKnowledge, question: 'Who composed the music for the national anthem of Pakistan?',
      options: ['Hafeez Jalandhri', 'Feroz Nizami', 'Khursheed Anwar', 'A. G. Chagla'], correctIndex: 3, topic: 'Pakistan History',
      explanation: 'Ahmed Ghulamali Chagla composed the music of the national anthem in 1949. Hafeez Jalandhri wrote the words.',
    ),
    MockQuestion(
      id: 'p205-22', subject: MockSubject.pakistanStudies, question: 'In the Senate of Pakistan, equal representation is given to which units of the federation?',
      options: ['Districts', 'Provinces', 'Divisions', 'Cities'], correctIndex: 1, topic: 'Constitution',
      explanation: 'The Senate of Pakistan gives equal representation to the provinces, unlike the National Assembly, where seats are based on population.',
    ),
    MockQuestion(
      id: 'p205-23', subject: MockSubject.generalKnowledge, question: 'In which Indian city is the Taj Mahal located?',
      options: ['Delhi', 'Agra', 'Jaipur', 'Lucknow'], correctIndex: 1, topic: 'Geography',
      explanation: 'The Taj Mahal is located in Agra, in the Indian state of Uttar Pradesh.',
    ),
    MockQuestion(
      id: 'p205-24', subject: MockSubject.pakistanStudies, question: 'How many articles did the Constitution of Pakistan of 1956 contain?',
      options: ['196', '234', '250', '280'], correctIndex: 1, topic: 'Constitution',
      explanation: 'The Constitution of Pakistan of 1956 contained 234 articles, in thirteen parts. The 1962 Constitution contained 250 articles.',
    ),
    MockQuestion(
      id: 'p205-25', subject: MockSubject.pakistanStudies, question: 'Which language is spoken by the largest number of people in Pakistan?',
      options: ['Urdu', 'Sindhi', 'Punjabi', 'Pashto'], correctIndex: 2, topic: 'Languages',
      explanation: 'Punjabi is the most widely spoken first language in Pakistan, spoken by a plurality of the population.',
    ),
    MockQuestion(
      id: 'p205-26', subject: MockSubject.pakistanStudies, question: 'Who founded Jamaat-e-Islami in 1941?',
      options: ['Abul Ala Maududi', 'Shabbir Ahmad Usmani', 'Muhammad Iqbal', 'Ashraf Ali Thanwi'], correctIndex: 0, topic: 'Religious Movements',
      explanation: 'Jamaat-e-Islami was founded by Abul Ala Maududi in Lahore in 1941.',
    ),
    MockQuestion(
      id: 'p205-27', subject: MockSubject.pakistanStudies, question: 'Which Pakistani mountaineer died during a winter expedition on K2 in February 2021?',
      options: ['Nazir Sabir', 'Muhammad Ali Sadpara', 'Hassan Sadpara', 'Ashraf Aman'], correctIndex: 1, topic: 'Sports',
      explanation: 'Muhammad Ali Sadpara went missing during a winter attempt on K2 in February 2021 and was declared dead.',
    ),
    MockQuestion(
      id: 'p205-28', subject: MockSubject.pakistanStudies, question: 'In which year did Allama Iqbal deliver the Allahabad Address, proposing a separate state for Muslims?',
      options: ['1928', '1930', '1932', '1936'], correctIndex: 1, topic: 'Pakistan Movement',
      explanation: 'Allama Iqbal delivered the Allahabad Address in 1930, presenting the idea of a separate Muslim state in north-west India.',
    ),
    MockQuestion(
      id: 'p205-29', subject: MockSubject.pakistanStudies, question: 'Which Pakistan Air Force pilot received the Nishan-e-Haider for his actions in the 1971 war?',
      options: ['M. M. Alam', 'Rashid Minhas', 'Sarfraz Rafiqui', 'Cecil Chaudhry'], correctIndex: 1, topic: 'Military History',
      explanation: 'Pilot Officer Rashid Minhas was awarded the Nishan-e-Haider after he died preventing his aircraft from being flown to India in August 1971.',
    ),
    MockQuestion(
      id: 'p205-30', subject: MockSubject.pakistanStudies, question: 'In which year did Muhammad Ali Jinnah join the All India Muslim League?',
      options: ['1906', '1910', '1913', '1916'], correctIndex: 2, topic: 'Pakistan Movement',
      explanation: 'Muhammad Ali Jinnah joined the All India Muslim League in 1913, while remaining a member of the Congress for some years after that.',
    ),
    MockQuestion(
      id: 'p205-31', subject: MockSubject.pakistanStudies, question: 'Who wrote Reconstruction of Religious Thought in Islam, a collection of lectures on Islamic philosophy?',
      options: ['Shah Waliullah', 'Allama Iqbal', 'Abul Ala Maududi', 'Sir Syed Ahmad Khan'], correctIndex: 1, topic: 'Literature',
      explanation: 'Reconstruction of Religious Thought in Islam is a collection of lectures by Allama Muhammad Iqbal, first published in 1930.',
    ),
    MockQuestion(
      id: 'p205-32', subject: MockSubject.pakistanStudies, question: 'Which is the highest mountain peak in Pakistan?',
      options: ['Nanga Parbat', 'K2', 'Rakaposhi', 'Broad Peak'], correctIndex: 1, topic: 'Geography of Pakistan',
      explanation: 'K2, at 8,611 metres, is the highest peak in Pakistan and the second highest mountain in the world.',
    ),
    MockQuestion(
      id: 'p205-33', subject: MockSubject.pakistanStudies, question: 'Who imposed the first martial law in Pakistan in October 1958?',
      options: ['Ayub Khan', 'Yahya Khan', 'Zia-ul-Haq', 'Pervez Musharraf'], correctIndex: 0, topic: 'Pakistan History',
      explanation: 'General Muhammad Ayub Khan imposed the first martial law in Pakistan in October 1958 after President Iskander Mirza abrogated the constitution.',
    ),
    MockQuestion(
      id: 'p205-34', subject: MockSubject.pakistanStudies, question: 'Who founded the Pakistan Peoples Party in 1967?',
      options: ['Zulfikar Ali Bhutto', 'Benazir Bhutto', 'Ghulam Mustafa Jatoi', 'Nusrat Bhutto'], correctIndex: 0, topic: 'Political Parties',
      explanation: 'The Pakistan Peoples Party was founded by Zulfikar Ali Bhutto in Lahore in November 1967.',
    ),
    MockQuestion(
      id: 'p205-35', subject: MockSubject.pakistanStudies, question: 'Which scholar began writing Sirat-un-Nabi, the well known biography of the Prophet Muhammad?',
      options: ['Sulaiman Nadvi', 'Shibli Naumani', 'Ashraf Ali Thanwi', 'Abul Kalam Azad'], correctIndex: 1, topic: 'Literature',
      explanation: 'Shibli Naumani began Sirat-un-Nabi, and after his death the work was completed by his disciple Sulaiman Nadvi.',
    ),
    MockQuestion(
      id: 'p205-36', subject: MockSubject.pakistanStudies, question: 'In which year were the main agreements of the China-Pakistan Economic Corridor signed during the visit of the Chinese President to Pakistan?',
      options: ['2013', '2014', '2015', '2017'], correctIndex: 2, topic: 'Economy',
      explanation: 'The main CPEC agreements, worth about 46 billion dollars, were signed in April 2015 during the visit of President Xi Jinping, although an initial memorandum of understanding had been signed in 2013.',
    ),
    MockQuestion(
      id: 'p205-37', subject: MockSubject.pakistanStudies, question: 'What is the name of the main battle tank jointly developed by Pakistan and China?',
      options: ['Al-Zarrar', 'Al-Khalid', 'Al-Haider', 'Al-Battar'], correctIndex: 1, topic: 'Defence',
      explanation: 'Al-Khalid is the main battle tank developed by Pakistan with Chinese assistance and produced at Heavy Industries Taxila.',
    ),
    MockQuestion(
      id: 'p205-38', subject: MockSubject.pakistanStudies, question: 'Which creek forms a disputed maritime boundary between Pakistan and India in the Rann of Kutch region?',
      options: ['Sir Creek', 'Keti Creek', 'Indus Creek', 'Hajjamro Creek'], correctIndex: 0, topic: 'Geography of Pakistan',
      explanation: 'Sir Creek is a disputed tidal estuary between Pakistan and India in the Rann of Kutch, and its boundary affects maritime claims in the Arabian Sea.',
    ),
    MockQuestion(
      id: 'p205-39', subject: MockSubject.pakistanStudies, question: 'Pakistan fought wars in 1948, 1965 and 1971 against which neighbouring country?',
      options: ['Afghanistan', 'India', 'Iran', 'China'], correctIndex: 1, topic: 'Pakistan History',
      explanation: 'Pakistan and India fought wars in 1948, 1965 and 1971, principally over the Kashmir dispute.',
    ),
    MockQuestion(
      id: 'p205-40', subject: MockSubject.pakistanStudies, question: 'K2 is part of which mountain range?',
      options: ['Himalayas', 'Hindu Kush', 'Karakoram', 'Pamir'], correctIndex: 2, topic: 'Geography of Pakistan',
      explanation: 'K2 lies in the Karakoram range, which runs along the border between Pakistan and China.',
    ),
    MockQuestion(
      id: 'p205-41', subject: MockSubject.pakistanStudies, question: 'Pakistan lies on the northern shore of which ocean, through the Arabian Sea?',
      options: ['Atlantic Ocean', 'Indian Ocean', 'Pacific Ocean', 'Southern Ocean'], correctIndex: 1, topic: 'Geography of Pakistan',
      explanation: 'Pakistan has a coastline on the Arabian Sea, which is part of the Indian Ocean.',
    ),
    MockQuestion(
      id: 'p205-42', subject: MockSubject.generalKnowledge, question: 'Which peak is known as the Savage Mountain because of the high death rate among climbers?',
      options: ['Mount Everest', 'K2', 'Nanga Parbat', 'Annapurna'], correctIndex: 1, topic: 'Geography',
      explanation: 'K2 is known as the Savage Mountain because of its steep slopes, severe weather and the high proportion of fatal attempts.',
    ),
    MockQuestion(
      id: 'p205-43', subject: MockSubject.generalKnowledge, question: 'The region between the Tropic of Cancer and the Tropic of Capricorn is called which zone?',
      options: ['Temperate Zone', 'Frigid Zone', 'Torrid Zone', 'Polar Zone'], correctIndex: 2, topic: 'Geography',
      explanation: 'The Torrid Zone is the region between the two tropics, where the Sun is directly overhead at some time of the year.',
    ),
    MockQuestion(
      id: 'p205-44', subject: MockSubject.generalKnowledge, question: 'Who is credited with the discovery of hydrogen as a distinct gas?',
      options: ['Joseph Priestley', 'Antoine Lavoisier', 'Henry Cavendish', 'Robert Boyle'], correctIndex: 2, topic: 'Science History',
      explanation: 'Henry Cavendish is credited with identifying hydrogen as a distinct substance in 1766, calling it inflammable air.',
    ),
    MockQuestion(
      id: 'p205-45', subject: MockSubject.generalKnowledge, question: 'Water is made of hydrogen and oxygen. Which statements are correct: water contains hydrogen, and water contains oxygen?',
      options: ['Only the first statement', 'Only the second statement', 'Both A and B', 'Neither statement'], correctIndex: 2, topic: 'Everyday Science',
      explanation: 'A water molecule contains two hydrogen atoms and one oxygen atom, so both statements are correct.',
    ),
    MockQuestion(
      id: 'p205-46', subject: MockSubject.everydayScience, question: 'The splitting of a heavy atomic nucleus into two smaller nuclei is called what?',
      options: ['Fusion', 'Fission', 'Radiation', 'Decay'], correctIndex: 1, topic: 'Physics',
      explanation: 'Nuclear fission is the splitting of a heavy nucleus, such as uranium, into smaller nuclei with the release of energy.',
    ),
    MockQuestion(
      id: 'p205-47', subject: MockSubject.everydayScience, question: 'Which substance dissolves readily in water and is used as a leavening agent in baking and as an antacid?',
      options: ['Washing Soda', 'Baking Soda', 'Common Salt', 'Lime'], correctIndex: 1, topic: 'Chemistry',
      explanation: 'Baking soda, sodium bicarbonate, is a leavening agent used in baking and is also taken as an antacid. That combination of uses identifies it: washing soda and lime are not used as antacids in this way.',
    ),
    MockQuestion(
      id: 'p205-48', subject: MockSubject.everydayScience, question: 'Which state of matter has neither a fixed shape nor a fixed volume?',
      options: ['Solid', 'Liquid', 'Gases', 'Plasma only'], correctIndex: 2, topic: 'Physics',
      explanation: 'Gases expand to fill their container, so they have neither a fixed shape nor a fixed volume.',
    ),
    MockQuestion(
      id: 'p205-49', subject: MockSubject.everydayScience, question: 'Speed in a stated direction is called what?',
      options: ['Acceleration', 'Momentum', 'Velocity', 'Force'], correctIndex: 2, topic: 'Physics',
      explanation: 'Velocity is speed with a direction, while speed alone has no direction.',
    ),
    MockQuestion(
      id: 'p205-50', subject: MockSubject.generalKnowledge, question: 'Which Microsoft Word feature is used to send the same letter to many different recipients with individual names and addresses?',
      options: ['Mail Merge', 'Macro', 'Template', 'Hyperlink'], correctIndex: 0, topic: 'Computer',
      explanation: 'Mail Merge combines a main document with a list of recipients to produce personalised letters, labels or emails.',
    ),
    MockQuestion(
      id: 'p205-51', subject: MockSubject.generalKnowledge, question: 'Which company manufactures Pentium series processors?',
      options: ['AMD', 'Intel', 'IBM', 'Apple'], correctIndex: 1, topic: 'Computer',
      explanation: 'Intel manufactures the Pentium series of microprocessors used in personal computers.',
    ),
    MockQuestion(
      id: 'p205-52', subject: MockSubject.generalKnowledge, question: 'Which shortcut key changes the case of selected text in Microsoft Word?',
      options: ['Shift+F1', 'Shift+F3', 'Ctrl+F3', 'Alt+F3'], correctIndex: 1, topic: 'Computer',
      explanation: 'Shift+F3 cycles selected text between lower case, upper case and capitalised case in Microsoft Word.',
    ),
    MockQuestion(
      id: 'p205-53', subject: MockSubject.generalKnowledge, question: 'Which of the following is a high level programming language widely used for general purpose software?',
      options: ['Python', 'HTML', 'HTTP', 'USB'], correctIndex: 0, topic: 'Computer',
      explanation: 'Python is a high level programming language. HTML is a markup language and HTTP is a protocol, not programming languages.',
    ),
    MockQuestion(
      id: 'p205-54', subject: MockSubject.generalKnowledge, question: 'Which shortcut key inserts a new slide in Microsoft PowerPoint?',
      options: ['Ctrl+N', 'Ctrl+M', 'Ctrl+S', 'Ctrl+P'], correctIndex: 1, topic: 'Computer',
      explanation: 'Ctrl+M inserts a new slide in PowerPoint. Ctrl+N creates a new presentation.',
    ),
    MockQuestion(
      id: 'p205-55', subject: MockSubject.generalKnowledge, question: 'Who proposed the stored program concept, in which instructions and data are both held in memory?',
      options: ['Charles Babbage', 'Alan Turing', 'J. V. Neumann', 'Bill Gates'], correctIndex: 2, topic: 'Computer',
      explanation: 'John von Neumann proposed the stored program architecture, in which program instructions are stored in the same memory as data.',
    ),
    MockQuestion(
      id: 'p205-56', subject: MockSubject.generalKnowledge, question: 'Which shortcut key switches between open windows on a Windows computer?',
      options: ['Alt+Tab', 'Ctrl+Tab', 'Alt+F4', 'Ctrl+Esc'], correctIndex: 0, topic: 'Computer',
      explanation: 'Alt+Tab switches between open windows, while Ctrl+Tab usually switches between tabs inside one program.',
    ),
    MockQuestion(
      id: 'p205-57', subject: MockSubject.generalKnowledge, question: 'Who invented the World Wide Web in 1989?',
      options: ['Bill Gates', 'Tim Berners-Lee', 'Steve Jobs', 'Vint Cerf'], correctIndex: 1, topic: 'Computer',
      explanation: 'Tim Berners-Lee invented the World Wide Web at CERN in 1989, proposing hypertext links between documents.',
    ),
    MockQuestion(
      id: 'p205-58', subject: MockSubject.generalKnowledge, question: 'Which of the following is written in a valid email address format?',
      options: ['username.website.com', 'username@website.com', 'username#website.com', 'username website.com'], correctIndex: 1, topic: 'Computer',
      explanation: 'A valid email address has the form username@website.com, with the at sign separating the user name from the domain.',
    ),
    MockQuestion(
      id: 'p205-59', subject: MockSubject.generalKnowledge, question: 'Which shortcut key closes the active window in Windows?',
      options: ['Alt+F4', 'Ctrl+F4', 'Alt+Esc', 'Ctrl+W'], correctIndex: 0, topic: 'Computer',
      explanation: 'Alt+F4 closes the active window or program in Windows.',
    ),
    MockQuestion(
      id: 'p205-60', subject: MockSubject.generalKnowledge, question: 'Every formula in Microsoft Excel begins with which symbol?',
      options: ['+', '=', '#', '@'], correctIndex: 1, topic: 'Computer',
      explanation: 'In Excel a formula must begin with the equals sign, followed by the expression to be calculated.',
    ),
    MockQuestion(
      id: 'p205-61', subject: MockSubject.generalKnowledge, question: 'Which bar in Excel shows the contents of the active cell?',
      options: ['Status Bar', 'Formula Bar', 'Title Bar', 'Scroll Bar'], correctIndex: 1, topic: 'Computer',
      explanation: 'The Formula Bar, below the ribbon, displays the contents of the currently selected cell.',
    ),
    MockQuestion(
      id: 'p205-62', subject: MockSubject.generalKnowledge, question: 'Which Word feature corrects common spelling errors automatically as you type?',
      options: ['Spell Check', 'AutoCorrect', 'Thesaurus', 'AutoFormat'], correctIndex: 1, topic: 'Computer',
      explanation: 'AutoCorrect fixes common typing and spelling errors automatically as text is typed. The F7 spell check is a separate manual check and is not among the options.',
    ),
    MockQuestion(
      id: 'p205-63', subject: MockSubject.generalKnowledge, question: 'Which tab in Microsoft Word is used to add tables, pictures and headers to a document?',
      options: ['Home', 'Insert', 'Design', 'Review'], correctIndex: 1, topic: 'Computer',
      explanation: 'The Insert tab contains the commands for adding tables, pictures, shapes, headers and footers.',
    ),
    MockQuestion(
      id: 'p205-64', subject: MockSubject.generalKnowledge, question: 'Which tool in a paint program is used for freehand drawing with strokes of different widths?',
      options: ['Pencil', 'Brush', 'Eraser', 'Fill'], correctIndex: 1, topic: 'Computer',
      explanation: 'The Brush tool paints freehand strokes, while the Pencil draws thin lines and the Eraser removes marks.',
    ),
    MockQuestion(
      id: 'p205-65', subject: MockSubject.generalKnowledge, question: 'Which Microsoft Office program is used to create slide presentations?',
      options: ['Word', 'Excel', 'PowerPoint', 'Access'], correctIndex: 2, topic: 'Computer',
      explanation: 'PowerPoint is the Microsoft Office program for creating presentations made of slides.',
    ),
    MockQuestion(
      id: 'p205-66', subject: MockSubject.generalKnowledge, question: 'Files created in Notepad are saved with which file extension by default?',
      options: ['.doc', '.txt', '.pdf', '.rtf'], correctIndex: 1, topic: 'Computer',
      explanation: 'Notepad saves plain text files with the .txt extension.',
    ),
    MockQuestion(
      id: 'p205-67', subject: MockSubject.generalKnowledge, question: 'Which of the following are input devices of a computer: a keyboard, a mouse and a scanner?',
      options: ['Keyboard only', 'Mouse only', 'Scanner only', 'All of these'], correctIndex: 3, topic: 'Computer',
      explanation: 'A keyboard, a mouse and a scanner are all input devices, because each feeds data into the computer.',
    ),
    MockQuestion(
      id: 'p205-68', subject: MockSubject.generalKnowledge, question: 'In a record system, metadata is used for what purpose?',
      options: ['Print documents', 'Store context for quick recall', 'Connect to the internet', 'Play sound'], correctIndex: 1, topic: 'Computer',
      explanation: 'Metadata is data that describes other data, giving its context, so it stores context for quick recall and organisation of records.',
    ),
    MockQuestion(
      id: 'p205-69', subject: MockSubject.generalKnowledge, question: 'A magnet produces which kind of field in the space around it?',
      options: ['Electric field', 'Magnetic field', 'Gravitational field', 'Light field'], correctIndex: 1, topic: 'Computer',
      explanation: 'A magnet produces a magnetic field, which exerts force on other magnets and on magnetic materials nearby.',
    ),
    MockQuestion(
      id: 'p205-70', subject: MockSubject.generalKnowledge, question: 'Which term describes the organised handling and control of the data of a firm in a database system?',
      options: ['Data Entry', 'Data Manage', 'Data Mining', 'Data Loss'], correctIndex: 1, topic: 'Computer',
      explanation: 'Data management is the organised handling and control of the data of a firm in a database system, which is what the listed answer Data Manage stands for here.',
    ),
    MockQuestion(
      id: 'p205-71', subject: MockSubject.generalKnowledge, question: 'In PowerPoint, speaker remarks for a slide are written in which pane?',
      options: ['Slide pane', 'Notes pane', 'Outline pane', 'Task pane'], correctIndex: 1, topic: 'Computer',
      explanation: 'The Notes pane, below the slide, holds the speaker notes for each slide.',
    ),
    MockQuestion(
      id: 'p205-72', subject: MockSubject.generalKnowledge, question: 'Which Word feature inserts a ready made first page, with a title and design, at the start of a document?',
      options: ['Header', 'Cover Page', 'Footer', 'Watermark'], correctIndex: 1, topic: 'Computer',
      explanation: 'The Cover Page feature on the Insert tab adds a formatted first page to a document.',
    ),
    MockQuestion(
      id: 'p205-73', subject: MockSubject.generalKnowledge, question: 'Which shortcut key decreases the font size of selected text in Microsoft Word?',
      options: ['Ctrl+[', 'Ctrl+]', 'Ctrl+-', 'Ctrl+='], correctIndex: 0, topic: 'Computer',
      explanation: 'Ctrl+[ decreases the font size by one point at a time, while Ctrl+] increases it.',
    ),
    MockQuestion(
      id: 'p205-74', subject: MockSubject.mathematics, question: 'What is the sum of all the whole numbers from 1 to 1000?',
      options: ['499500', '500000', '500500', '501000'], correctIndex: 2, topic: 'Arithmetic',
      explanation: 'The sum of the numbers from 1 to n is n times n plus 1 divided by 2, so for 1000 it is 1000 times 1001 divided by 2, which is 500500.',
    ),
    MockQuestion(
      id: 'p205-75', subject: MockSubject.mathematics, question: 'What is 0.75 expressed as a fraction in its lowest terms?',
      options: ['3/4', '2/3', '4/5', '7/10'], correctIndex: 0, topic: 'Fractions',
      explanation: '0.75 is 75 over 100, which reduces by dividing top and bottom by 25 to 3 over 4.',
    ),
    MockQuestion(
      id: 'p205-76', subject: MockSubject.mathematics, question: 'Which set of numbers includes both rational and irrational numbers?',
      options: ['Natural numbers', 'Integers', 'Real numbers', 'Prime numbers'], correctIndex: 2, topic: 'Number Systems',
      explanation: 'The real numbers include both rational numbers and irrational numbers such as the square root of 2.',
    ),
    MockQuestion(
      id: 'p205-77', subject: MockSubject.mathematics, question: 'The total weight of a set of parcels is calculated as 1235 kg. Which listed value is closest to this total?',
      options: ['1200 kg', '1300 kg', '1230 kg', '1250 kg'], correctIndex: 2, topic: 'Arithmetic',
      explanation: 'The exact total is 1235 kg, so the closest listed value is 1230 kg. The printed key listed 1250 kg, which is further from the exact total and is wrong.',
    ),
    MockQuestion(
      id: 'p205-78', subject: MockSubject.mathematics, question: 'A cone has a volume of 245 cubic cm and a base radius of 7 cm. What is its height, choosing from the listed options?',
      options: ['15 cm', '18 cm', '21 cm', '25 cm'], correctIndex: 0, topic: 'Geometry',
      explanation: 'This question is flawed. For a cone, volume equals one third of pi times radius squared times height, so the height is 3 times 245 divided by pi times 49, about 4.8 cm, which matches none of the listed options. The printed solution wrongly multiplied by 3 to reach 15 cm. The listed answer 15 cm is retained as the answer given for this item.',
    ),
    MockQuestion(
      id: 'p205-79', subject: MockSubject.mathematics, question: 'What is the value of 3 squared multiplied by 2?',
      options: ['12', '18', '24', '36'], correctIndex: 1, topic: 'Arithmetic',
      explanation: 'Three squared is 9, and 9 multiplied by 2 is 18.',
    ),
    MockQuestion(
      id: 'p205-80', subject: MockSubject.english, question: 'Which city is known as the Eternal City?',
      options: ['Athens', 'Rome', 'Paris', 'Cairo'], correctIndex: 1, topic: 'General Knowledge',
      explanation: 'Rome is called the Eternal City because of its long history as a centre of civilisation.',
    ),
    MockQuestion(
      id: 'p205-81', subject: MockSubject.english, question: 'Choose the correct preposition: The book is ___ the table.',
      options: ['In', 'On', 'At', 'Of'], correctIndex: 1, topic: 'Prepositions',
      explanation: 'On is used for something resting on a surface, so the book is on the table.',
    ),
    MockQuestion(
      id: 'p205-82', subject: MockSubject.english, question: 'A person who betrays his own country is called a:',
      options: ['Patriot', 'Traitor', 'Hero', 'Leader'], correctIndex: 1, topic: 'Vocabulary',
      explanation: 'A traitor is a person who betrays his country or a cause he owes loyalty to.',
    ),
    MockQuestion(
      id: 'p205-83', subject: MockSubject.english, question: 'Choose the word closest in meaning to steady and uniform in behaviour:',
      options: ['Changeable', 'Consistent', 'Careless', 'Sudden'], correctIndex: 1, topic: 'Vocabulary',
      explanation: 'Consistent means acting in the same way over time, steady and uniform.',
    ),
    MockQuestion(
      id: 'p205-84', subject: MockSubject.english, question: 'The word frontier is closest in meaning to:',
      options: ['Centre', 'Border', 'Capital', 'River'], correctIndex: 1, topic: 'Vocabulary',
      explanation: 'A frontier is the border or edge of a country or territory.',
    ),
    MockQuestion(
      id: 'p205-85', subject: MockSubject.english, question: 'Which pair has the same relationship as a flower placed in a vase, a thing kept in its container?',
      options: ['Vase : Flower', 'Bird : Cage', 'Fish : Water', 'Book : Cover'], correctIndex: 0, topic: 'Analogies',
      explanation: 'Vase : Flower pairs a container with the thing kept in it. This analogy is loose, because other pairs can also show a container relationship.',
    ),
    MockQuestion(
      id: 'p205-86', subject: MockSubject.english, question: 'Which word is used in the phrase go straight home, as an adverb meaning directly?',
      options: ['Long', 'Pretty', 'Straight', 'Hardly'], correctIndex: 2, topic: 'Vocabulary',
      explanation: 'Straight is used as an adverb meaning directly in go straight home. Long and pretty can also act as both adjective and adverb in other phrases, so the wording of this item is loose.',
    ),
    MockQuestion(
      id: 'p205-87', subject: MockSubject.english, question: 'Which noun has the same form in the singular and in the plural?',
      options: ['Deer', 'Child', 'Foot', 'Mouse'], correctIndex: 0, topic: 'Grammar',
      explanation: 'Deer is both singular and plural, while child, foot and mouse change form in the plural.',
    ),
    MockQuestion(
      id: 'p205-88', subject: MockSubject.english, question: 'Choose the correct verb form: My father, as well as my friends, ___ to the ceremony.',
      options: ['were invited', 'was invited', 'have invited', 'are invited'], correctIndex: 1, topic: 'Grammar',
      explanation: 'When a singular subject is joined by as well as, the verb agrees with the first subject, so was invited agrees with father.',
    ),
    MockQuestion(
      id: 'p205-89', subject: MockSubject.english, question: 'Choose the correct indirect form of: He said to me, I have been sleeping since yesterday.',
      options: ['He told me that I have been sleeping since yesterday', 'He told me that he is sleeping since yesterday', 'He told me that he has been sleeping from the previous day', 'He told me that he had been sleeping since the previous day'], correctIndex: 3, topic: 'Narration',
      explanation: 'In indirect speech, have been sleeping becomes had been sleeping and yesterday becomes the previous day.',
    ),
    MockQuestion(
      id: 'p205-90', subject: MockSubject.english, question: 'Choose the correct phrase: ___ the report, prices rose last month.',
      options: ['According to', 'In spite of', 'Instead of', 'Because of'], correctIndex: 0, topic: 'Prepositions',
      explanation: 'According to the report is the correct phrase for citing a source of information.',
    ),
    MockQuestion(
      id: 'p205-91', subject: MockSubject.english, question: 'Choose the grammatically correct sentence.',
      options: ['There was terrible storm last night', 'There was a terrible storm last night', 'There were a terrible storm last night', 'There was terrible storms last night'], correctIndex: 1, topic: 'Grammar',
      explanation: 'The correct sentence uses the article a before the singular noun storm and the singular verb was.',
    ),
    MockQuestion(
      id: 'p205-92', subject: MockSubject.english, question: 'What is the official language of Turkey?',
      options: ['Arabic', 'Persian', 'Turkish', 'Kurdish'], correctIndex: 2, topic: 'General Knowledge',
      explanation: 'Turkish is the official language of Turkey.',
    ),
    MockQuestion(
      id: 'p205-93', subject: MockSubject.generalKnowledge, question: 'Urdu: Lafz ko us ke asal mani ke bajaye dusre mani mein istemal karna kya kehlata hai?',
      options: ['Haqiqi', 'Majazi', 'Kinaya', 'Ishara'], correctIndex: 1, topic: 'Urdu Grammar',
      explanation: 'Jab lafz apne asal mani ke bajaye dusre mani mein istemal ho to use majazi kehte hain.',
    ),
    MockQuestion(
      id: 'p205-94', subject: MockSubject.generalKnowledge, question: 'Urdu: Muqaddama-e-Sher-o-Shairi ke musannif kaun hain?',
      options: ['Mir Taqi Mir', 'Altaf Hussain Hali', 'Ghalib', 'Iqbal'], correctIndex: 1, topic: 'Urdu Literature',
      explanation: 'Muqaddama-e-Sher-o-Shairi Altaf Hussain Hali ki mashhoor tanqeedi kitab hai.',
    ),
    MockQuestion(
      id: 'p205-95', subject: MockSubject.generalKnowledge, question: 'Urdu: Soch bachar se murad kya hai?',
      options: ['Jaldi faisla', 'Soch bachar', 'Be soche samjhe kaam', 'Gussa karna'], correctIndex: 1, topic: 'Urdu Vocabulary',
      explanation: 'Soch bachar se murad hai kisi baat par gehri soch aur ghaur karna.',
    ),
    MockQuestion(
      id: 'p205-96', subject: MockSubject.generalKnowledge, question: 'Urdu: Marne ke qareeb hone ke liye durust muhavra konsa hai?',
      options: ['Woh marne wala hai', 'Woh marnay ke qareeb hai', 'Woh mar raha hai', 'Woh qareeb-e-marg hai'], correctIndex: 3, topic: 'Urdu Idioms',
      explanation: 'Qareeb-e-marg hona marne ke qareeb hone ke liye durust muhavra hai, jab ke marnay ke qareeb kehna durust istemal nahi hai.',
    ),
    MockQuestion(
      id: 'p205-97', subject: MockSubject.generalKnowledge, question: 'Urdu: Khamosh rehna ya kuch na bolna ko muhavratan kya kehte hain?',
      options: ['Shor machana', 'Chup sadhna', 'Baat karna', 'Hansna'], correctIndex: 1, topic: 'Urdu Idioms',
      explanation: 'Chup sadhna ka matlab hai khamosh rehna ya kuch na bolna.',
    ),
    MockQuestion(
      id: 'p205-98', subject: MockSubject.generalKnowledge, question: 'Urdu: Ghazal ke us shair ko kya kehte hain jo matlay ke baad aaye aur jis mein qafia aur radeef ki pabandi ho?',
      options: ['Matla', 'Husn-e-Matla', 'Maqta', 'Misra'], correctIndex: 1, topic: 'Urdu Poetry',
      explanation: 'Husn-e-Matla ghazal ka woh shair hai jo matlay ke baad aata hai aur jis mein qafia aur radeef ki pabandi hoti hai.',
    ),
    MockQuestion(
      id: 'p205-99', subject: MockSubject.generalKnowledge, question: 'Urdu: Kisi ustad se taleem hasil karne wale ko kya kehte hain?',
      options: ['Shagird hona', 'Ustad hona', 'Dost hona', 'Bhai hona'], correctIndex: 0, topic: 'Urdu Vocabulary',
      explanation: 'Ustad se taleem hasil karne wala shagird kehlata hai.',
    ),
    MockQuestion(
      id: 'p205-100', subject: MockSubject.islamiat, question: 'Sabr-e-Jameel, beautiful patience on the loss of a loved one, is associated with which prophet?',
      options: ['Hazrat Yusuf (AS)', 'Hazrat Yaqub (AS)', 'Hazrat Ayyub (AS)', 'Hazrat Yunus (AS)'], correctIndex: 1, topic: 'Prophets',
      explanation: 'Hazrat Yaqub (AS) showed sabr-e-jameel, beautiful patience, on the loss of his son Hazrat Yusuf (AS).',
    ),
  ],
  latestUpdates: [],
);
