import '../../model/mock_question.dart';
import '../../model/paper_test.dart';

// PRACTICE MATERIAL ONLY.
// This is a practice mock test written in fresh wording for revision.
// It is not an official paper, not a verbatim reproduction of any exam,
// and it does not predict any real exam. Answers were checked against
// general reference facts at build time; where a printed key differed
// from the researched fact, the researched fact was used.

const PaperTest paper206 = PaperTest(
  id: '2025-206',
  paperNo: 206,
  year: 2025,
  post: 'Assistant Registrar Cooperative Societies (BS-17)',
  department: 'Cooperative Societies',
  examDate: '28.09.2025',
  questions: [
    // General Knowledge
    MockQuestion(
      id: 'p206-1', subject: MockSubject.generalKnowledge, question: 'Which city is the capital of Austria?',
      options: ['Vienna', 'Salzburg', 'Graz', 'Innsbruck'], correctIndex: 0, topic: 'Geography',
      explanation: 'Vienna is the capital and largest city of Austria.',
    ),
    MockQuestion(
      id: 'p206-2', subject: MockSubject.generalKnowledge, question: 'The day observed to encourage public interest in the study of stars and planets is called which day?',
      options: ['Science Day', 'Astronomy Day', 'Space Day', 'Earth Day'], correctIndex: 1, topic: 'Observances',
      explanation: 'Astronomy Day is observed to encourage public interest in astronomy, the study of stars, planets and the universe.',
    ),
    MockQuestion(
      id: 'p206-3', subject: MockSubject.generalKnowledge, question: 'What is the main objective of the International Atomic Energy Agency (IAEA)?',
      options: ['To make nuclear weapons', 'To use atomic energy for peaceful purpose', 'To ban all nuclear research', 'To trade in uranium'], correctIndex: 1, topic: 'International Organisations',
      explanation: 'The IAEA was set up to promote the peaceful use of atomic energy and to prevent its use for military purposes.',
    ),
    MockQuestion(
      id: 'p206-4', subject: MockSubject.generalKnowledge, question: 'On which date did the United States begin military action in Afghanistan in 2001?',
      options: ['11 September 2001', '7 October 2001', '1 November 2001', '25 December 2001'], correctIndex: 1, topic: 'World History',
      explanation: 'The United States began military action in Afghanistan on 7 October 2001, after the attacks of 11 September 2001.',
    ),
    MockQuestion(
      id: 'p206-5', subject: MockSubject.generalKnowledge, question: 'In which city is the headquarters of the World Health Organization located?',
      options: ['New York', 'Paris', 'Geneva', 'London'], correctIndex: 2, topic: 'International Organisations',
      explanation: 'The headquarters of the World Health Organization is in Geneva, Switzerland.',
    ),
    MockQuestion(
      id: 'p206-6', subject: MockSubject.generalKnowledge, question: 'Which country launched the Apollo missions that first landed humans on the Moon?',
      options: ['USA', 'Russia', 'China', 'United Kingdom'], correctIndex: 0, topic: 'Space',
      explanation: 'The Apollo programme of the United States landed the first humans on the Moon in 1969.',
    ),
    MockQuestion(
      id: 'p206-7', subject: MockSubject.generalKnowledge, question: 'Which city is the capital of Iraq?',
      options: ['Basra', 'Mosul', 'Baghdad', 'Erbil'], correctIndex: 2, topic: 'Geography',
      explanation: 'Baghdad is the capital city of Iraq.',
    ),
    MockQuestion(
      id: 'p206-8', subject: MockSubject.pakistanStudies, question: 'Which airline was the predecessor of Pakistan International Airlines, founded before independence?',
      options: ['Orient Airways', 'Shaheen Air', 'Air Blue', 'PIA Cargo'], correctIndex: 0, topic: 'Pakistan History',
      explanation: 'Orient Airways, founded in 1946, became the basis of Pakistan International Airlines after independence.',
    ),
    MockQuestion(
      id: 'p206-9', subject: MockSubject.pakistanStudies, question: 'Who was the first Governor of Punjab after the independence of Pakistan?',
      options: ['Francis Mudie', 'Mushtaq Gurmani', 'Aminuddin', 'Iftikhar Hussain'], correctIndex: 0, topic: 'Pakistan History',
      explanation: 'Sir Francis Mudie served as the first Governor of Punjab in Pakistan from 1947 to 1949.',
    ),
    MockQuestion(
      id: 'p206-10', subject: MockSubject.pakistanStudies, question: 'Which former Pakistan captain and fast bowler later served as head coach of the Pakistan cricket team?',
      options: ['Wasim Akram', 'Waqar Younis', 'Imran Khan', 'Shoaib Akhtar'], correctIndex: 1, topic: 'Sports',
      explanation: 'Waqar Younis, one of the leading fast bowlers of Pakistan, served as head coach of the Pakistan team in later years.',
    ),
    MockQuestion(
      id: 'p206-11', subject: MockSubject.pakistanStudies, question: 'Which senior civil servant served as Principal Secretary to President Ayub Khan and later wrote memoirs about Pakistan politics?',
      options: ['Roedad Khan', 'Ghulam Ishaq Khan', 'Qudrat Ullah Shahab', 'Altaf Gauhar'], correctIndex: 2, topic: 'Pakistan History',
      explanation: 'Qudrat Ullah Shahab served as Principal Secretary to Governor General Ghulam Muhammad and to Presidents Iskander Mirza and Ayub Khan, and later wrote the memoir Shahab Nama. Roedad Khan served under Ayub Khan as Secretary of Industries and Production, not as Principal Secretary.',
    ),
    MockQuestion(
      id: 'p206-12', subject: MockSubject.generalKnowledge, question: 'In which year did the Cabinet Mission visit India to discuss the transfer of power?',
      options: ['1942', '1944', '1946', '1947'], correctIndex: 2, topic: 'World History',
      explanation: 'The Cabinet Mission arrived in India in 1946 to propose a plan for the transfer of power from Britain.',
    ),
    MockQuestion(
      id: 'p206-13', subject: MockSubject.generalKnowledge, question: 'Which Mughal emperor built the Taj Mahal at Agra?',
      options: ['Akbar', 'Jahangir', 'Shahjahan', 'Aurangzeb'], correctIndex: 2, topic: 'History',
      explanation: 'The Taj Mahal was built by the Mughal emperor Shah Jahan in memory of his wife Mumtaz Mahal.',
    ),
    MockQuestion(
      id: 'p206-14', subject: MockSubject.pakistanStudies, question: 'Which is the name of the first electric car of Pakistan, unveiled in 2022?',
      options: ['HVI 07', 'NUR-G75', 'EVI 75', 'NUR-E-75'], correctIndex: 3, topic: 'Science and Technology',
      explanation: 'The NUR-E-75, unveiled by the DICE Foundation in August 2022, is described as the first electric car of Pakistan. It was a prototype, with the name marking the 75th anniversary of Pakistan.',
    ),
    MockQuestion(
      id: 'p206-15', subject: MockSubject.pakistanStudies, question: 'In which year did Muhammad bin Qasim arrive in Sindh?',
      options: ['700', '712', '725', '750'], correctIndex: 1, topic: 'Pakistan History',
      explanation: 'Muhammad bin Qasim arrived in Sindh in 712 AD and defeated Raja Dahir.',
    ),
    MockQuestion(
      id: 'p206-16', subject: MockSubject.pakistanStudies, question: 'Who composed the music of the national anthem of Pakistan?',
      options: ['Ahmad Chagla', 'Hafeez Jalandhari', 'Allama Iqbal', 'Faiz Ahmad Faiz'], correctIndex: 0, topic: 'Pakistan Studies',
      explanation: 'Ahmed Ghulamali Chagla composed the music of the national anthem of Pakistan, whose words were written by Hafeez Jalandhari.',
    ),
    MockQuestion(
      id: 'p206-17', subject: MockSubject.pakistanStudies, question: 'The repeated dismissal of governments and assemblies in Pakistan during the 1990s is most often described as a period of what?',
      options: ['Economic growth', 'Constitutional crises', 'Military rule', 'Foreign invasion'], correctIndex: 1, topic: 'Pakistan History',
      explanation: 'The 1990s in Pakistan saw repeated dismissals of elected governments under Article 58(2)(b), a period widely described as one of constitutional crises.',
    ),
    MockQuestion(
      id: 'p206-18', subject: MockSubject.generalKnowledge, question: 'Which autonomous region of China has a large Muslim Uighur population?',
      options: ['Tibet', 'Xinjiang', 'Inner Mongolia', 'Guangxi'], correctIndex: 1, topic: 'Geography',
      explanation: 'Xinjiang, in north-west China, is home to a large Uighur Muslim population.',
    ),
    MockQuestion(
      id: 'p206-19', subject: MockSubject.generalKnowledge, question: 'The martyrdom of the younger sons of Guru Gobind Singh took place at which historic town in Punjab, India?',
      options: ['Amritsar', 'Sirhind', 'Ludhiana', 'Jalandhar'], correctIndex: 1, topic: 'History',
      explanation: 'The younger sons of Guru Gobind Singh, Zorawar Singh and Fateh Singh, were martyred at Sirhind in 1704.',
    ),
    MockQuestion(
      id: 'p206-20', subject: MockSubject.generalKnowledge, question: 'Sir Edmund Hillary, who first climbed Mount Everest with Tenzing Norgay, is best described as a:',
      options: ['Sailor', 'Mountaineer', 'Pilot', 'Swimmer'], correctIndex: 1, topic: 'Personalities',
      explanation: 'Edmund Hillary was a New Zealand mountaineer who, with Tenzing Norgay, made the first confirmed ascent of Mount Everest in 1953.',
    ),
    MockQuestion(
      id: 'p206-21', subject: MockSubject.generalKnowledge, question: 'In which year was the Dominion of Canada formed?',
      options: ['1861', '1867', '1871', '1885'], correctIndex: 1, topic: 'World History',
      explanation: 'The Dominion of Canada was formed in 1867 through the confederation of three British North American colonies.',
    ),
    MockQuestion(
      id: 'p206-22', subject: MockSubject.pakistanStudies, question: 'Which Pakistani scientist won the Nobel Prize in Physics in 1979?',
      options: ['Dr Abdul Qadeer Khan', 'Dr Abdul Salam', 'Dr Atta-ur-Rahman', 'Dr Samar Mubarakmand'], correctIndex: 1, topic: 'Science Personalities',
      explanation: 'Dr Abdus Salam shared the Nobel Prize in Physics in 1979 for his work on the electroweak theory.',
    ),
    MockQuestion(
      id: 'p206-23', subject: MockSubject.generalKnowledge, question: 'In which year was the Simon Commission appointed to review constitutional reforms in India?',
      options: ['1925', '1927', '1929', '1931'], correctIndex: 1, topic: 'World History',
      explanation: 'The Simon Commission was appointed in 1927 to review the working of the Government of India Act 1919.',
    ),
    MockQuestion(
      id: 'p206-24', subject: MockSubject.pakistanStudies, question: 'On which date did Pakistan become a full member of the Shanghai Cooperation Organisation?',
      options: ['9 June 2017', '9 June 2016', '15 August 2017', '1 January 2018'], correctIndex: 0, topic: 'Foreign Policy',
      explanation: 'Pakistan and India became full members of the Shanghai Cooperation Organisation at the Astana summit on 9 June 2017.',
    ),
    MockQuestion(
      id: 'p206-25', subject: MockSubject.pakistanStudies, question: 'Who was the first Commander-in-Chief of the Pakistan Army?',
      options: ['Ayub Khan', 'Frank Messervy', 'Muhammad Musa', 'Tikka Khan'], correctIndex: 1, topic: 'Military History',
      explanation: 'General Frank Messervy, a British officer, was the first Commander-in-Chief of the Pakistan Army, serving from 1947 to 1948.',
    ),
    MockQuestion(
      id: 'p206-26', subject: MockSubject.pakistanStudies, question: 'Who was the first Permanent Representative of Pakistan to the United Nations?',
      options: ['Zafarullah Khan', 'A. S. Bukhari', 'Agha Shahi', 'Patras Bokhari'], correctIndex: 1, topic: 'Foreign Policy',
      explanation: 'Ahmed Shah Bokhari, known as Patras Bokhari and listed as A. S. Bukhari, was the first Permanent Representative of Pakistan to the United Nations.',
    ),
    MockQuestion(
      id: 'p206-27', subject: MockSubject.pakistanStudies, question: 'Which scholar is known by the title Mujaddid Alf Sani, the reviver of the second millennium?',
      options: ['Shah Waliullah', 'Ahmad Sirhindi', 'Abdul Qadir Jilani', 'Moinuddin Chishti'], correctIndex: 1, topic: 'Islamic History',
      explanation: 'Sheikh Ahmad Sirhindi is known as Mujaddid Alf Sani for his efforts to revive Islam in India in the time of Akbar and Jahangir.',
    ),
    MockQuestion(
      id: 'p206-28', subject: MockSubject.generalKnowledge, question: 'Which ruler of Delhi was defeated by Babur in the First Battle of Panipat in 1526?',
      options: ['Sher Shah Suri', 'Ibrahim Lodhi', 'Alauddin Khalji', 'Muhammad Tughlaq'], correctIndex: 1, topic: 'History',
      explanation: 'Babur defeated Ibrahim Lodhi, the Sultan of Delhi, in the First Battle of Panipat in 1526.',
    ),
    MockQuestion(
      id: 'p206-29', subject: MockSubject.generalKnowledge, question: 'How many member states does SAARC, the South Asian Association for Regional Cooperation, have?',
      options: ['6', '7', '8', '9'], correctIndex: 2, topic: 'International Organisations',
      explanation: 'SAARC has eight member states: Afghanistan, Bangladesh, Bhutan, India, Maldives, Nepal, Pakistan and Sri Lanka.',
    ),
    MockQuestion(
      id: 'p206-30', subject: MockSubject.pakistanStudies, question: 'In which year did Pakistan first receive economic aid from the United States?',
      options: ['1947', '1948', '1950', '1954'], correctIndex: 1, topic: 'Foreign Policy',
      explanation: 'The United States has provided economic assistance to Pakistan since 1948, and aid records show economic assistance of about 0.8 million dollars in that year.',
    ),
    MockQuestion(
      id: 'p206-31', subject: MockSubject.pakistanStudies, question: 'In which year were general elections held in Pakistan under the Legal Framework Order of General Musharraf?',
      options: ['1997', '2002', '2008', '2013'], correctIndex: 1, topic: 'Pakistan History',
      explanation: 'General elections were held in Pakistan in October 2002 under the Legal Framework Order issued by General Pervez Musharraf.',
    ),
    MockQuestion(
      id: 'p206-32', subject: MockSubject.pakistanStudies, question: 'Who administered the oath of office to Liaquat Ali Khan, the first Prime Minister of Pakistan?',
      options: ['Quaid-e-Azam Muhammad Ali Jinnah', 'Lord Mountbatten', 'Justice Abdul Rashid', 'Khawaja Nazimuddin'], correctIndex: 0, topic: 'Pakistan History',
      explanation: 'Quaid-e-Azam Muhammad Ali Jinnah, as Governor-General, administered the oath to Liaquat Ali Khan as the first Prime Minister in 1947.',
    ),
    MockQuestion(
      id: 'p206-33', subject: MockSubject.generalKnowledge, question: 'Gandhara art, with its Greco-Buddhist style of sculpture, is associated with which religion?',
      options: ['Hinduism', 'Buddhism', 'Jainism', 'Zoroastrianism'], correctIndex: 1, topic: 'History',
      explanation: 'Gandhara art developed in the north-west of the subcontinent and is associated with Buddhism, showing the Buddha in Greek influenced style.',
    ),
    MockQuestion(
      id: 'p206-34', subject: MockSubject.pakistanStudies, question: 'On which date did Pakistan conduct its nuclear tests at Chagai in 1998?',
      options: ['11 May 1998', '28 May 1998', '30 May 1998', '1 June 1998'], correctIndex: 1, topic: 'Pakistan History',
      explanation: 'Pakistan conducted nuclear tests at Chagai on 28 May 1998, a day observed as Youm-e-Takbeer.',
    ),
    MockQuestion(
      id: 'p206-35', subject: MockSubject.generalKnowledge, question: 'Which incident in 1922 led Gandhi to call off the Non-Cooperation Movement?',
      options: ['Jallianwala Bagh', 'Chauri Chaura', 'Dandi March', 'Quit India'], correctIndex: 1, topic: 'History',
      explanation: 'The Chauri Chaura incident, in which policemen were killed by a mob in February 1922, led Gandhi to suspend the Non-Cooperation Movement. The stem as printed wrongly linked the incident with the Civil Disobedience Movement, which began later.',
    ),
    MockQuestion(
      id: 'p206-36', subject: MockSubject.pakistanStudies, question: 'Mangla Dam is built on which river?',
      options: ['Indus', 'Jhelum', 'Chenab', 'Ravi'], correctIndex: 1, topic: 'Geography of Pakistan',
      explanation: 'Mangla Dam is built on the River Jhelum in Azad Jammu and Kashmir.',
    ),
    MockQuestion(
      id: 'p206-37', subject: MockSubject.pakistanStudies, question: 'What is the approximate length of the Line of Control between Pakistan and India?',
      options: ['400 km', '740 km', '1200 km', '1800 km'], correctIndex: 1, topic: 'Geography of Pakistan',
      explanation: 'The Line of Control is about 740 kilometres long, running from Sangam to point NJ9842. Some sources give a longer figure of up to about 776 kilometres.',
    ),
    MockQuestion(
      id: 'p206-38', subject: MockSubject.generalKnowledge, question: 'Who ordered the firing on the crowd at Jallianwala Bagh in Amritsar in 1919?',
      options: ['Lord Curzon', 'General Dyer', 'Lord Chelmsford', 'Michael O Dwyer'], correctIndex: 1, topic: 'History',
      explanation: 'Brigadier General Reginald Dyer ordered troops to fire on the unarmed crowd at Jallianwala Bagh on 13 April 1919.',
    ),
    MockQuestion(
      id: 'p206-39', subject: MockSubject.generalKnowledge, question: 'Who is known as the Grand Old Man of India for his work on the drain of wealth theory?',
      options: ['Gopal Krishna Gokhale', 'Dadabhai Naoroji', 'Bal Gangadhar Tilak', 'Lala Lajpat Rai'], correctIndex: 1, topic: 'History',
      explanation: 'Dadabhai Naoroji, called the Grand Old Man of India, argued in his drain theory that Britain was draining wealth from India.',
    ),
    MockQuestion(
      id: 'p206-40', subject: MockSubject.pakistanStudies, question: 'Who wrote The Murder of History, a critical study of history textbooks in Pakistan?',
      options: ['K. K. Aziz', 'Ayesha Jalal', 'I. H. Qureshi', 'Mubarak Ali'], correctIndex: 0, topic: 'Literature',
      explanation: 'The Murder of History, published in 1993, was written by the historian K. K. Aziz.',
    ),
    MockQuestion(
      id: 'p206-41', subject: MockSubject.pakistanStudies, question: 'Who is the Governor of Punjab in Pakistan?',
      options: ['Saleem Haider', 'Balighur Rehman', 'Chaudhry Sarwar', 'Rafique Rajwana'], correctIndex: 0, topic: 'Current Affairs',
      explanation: 'Sardar Saleem Haider Khan is the Governor of Punjab. See the latest update note at the end of this paper.',
    ),
    MockQuestion(
      id: 'p206-42', subject: MockSubject.generalKnowledge, question: 'Which world health organisation declared COVID-19 a pandemic in March 2020?',
      options: ['UNICEF', 'WHO', 'Red Cross', 'UNESCO'], correctIndex: 1, topic: 'International Organisations',
      explanation: 'The World Health Organization, WHO, declared COVID-19 a pandemic on 11 March 2020.',
    ),
    MockQuestion(
      id: 'p206-43', subject: MockSubject.generalKnowledge, question: 'Who is the President of Syria?',
      options: ['Bashar al-Assad', 'Ahmad al-Sharaa', 'Riyad Hijab', 'Farouk al-Sharaa'], correctIndex: 1, topic: 'Current Affairs',
      explanation: 'Ahmad al-Sharaa became President of Syria after the fall of the Assad government in December 2024. See the latest update note at the end of this paper.',
    ),
    MockQuestion(
      id: 'p206-44', subject: MockSubject.generalKnowledge, question: 'Who commanded the SpaceX Crew-9 mission that returned from the International Space Station in March 2025?',
      options: ['Sunita Williams', 'Nick Hague', 'Butch Wilmore', 'Jasmin Moghbeli'], correctIndex: 1, topic: 'Space',
      explanation: 'Nick Hague commanded the Crew-9 mission, which returned to Earth in March 2025 after an extended stay. Sunita Williams was a crew member on the mission, not its commander.',
    ),
    MockQuestion(
      id: 'p206-45', subject: MockSubject.pakistanStudies, question: 'Which fighter aircraft did Pakistan state it used in the Marka-e-Haq operations of May 2025?',
      options: ['F-16', 'JF-17', 'J-10C', 'Mirage III'], correctIndex: 2, topic: 'Current Affairs',
      explanation: 'Pakistan stated that its J-10C fighter aircraft took part in the May 2025 operations. This is presented as the stated claim of Pakistan, and the claim is contested.',
    ),
    MockQuestion(
      id: 'p206-46', subject: MockSubject.generalKnowledge, question: 'Which African country became a BRICS partner country in January 2025?',
      options: ['Egypt', 'Ethiopia', 'Nigeria', 'South Africa'], correctIndex: 2, topic: 'International Organisations',
      explanation: 'Nigeria became a BRICS partner country in January 2025. Indonesia became a full member at the same time, while Egypt and Ethiopia had joined as full members in 2024.',
    ),
    MockQuestion(
      id: 'p206-47', subject: MockSubject.generalKnowledge, question: 'In 2025, what percentage of people in Pakistan were living below the poverty line, according to the estimate used in this paper?',
      options: ['41%', '44.7%', '25.7%', '35%'], correctIndex: 1, topic: 'General Knowledge',
      explanation: 'The estimate used in this paper puts the share of people living below the poverty line in 2025 at 44.7 percent. This figure is the estimate given in the paper and could not be confirmed as an official figure.',
    ),
    MockQuestion(
      id: 'p206-48', subject: MockSubject.generalKnowledge, question: 'The international exhibition held in Osaka in 2025 is known as which event?',
      options: ['World Expo', 'Olympic Games', 'World Cup', 'G20 Summit'], correctIndex: 0, topic: 'General Knowledge',
      explanation: 'Expo 2025 in Osaka, Japan, was a World Expo, a large international exhibition held every five years.',
    ),
    MockQuestion(
      id: 'p206-49', subject: MockSubject.everydayScience, question: 'During a solar eclipse, which body comes between the Sun and the Earth?',
      options: ['Mars', 'Moon', 'Venus', 'Mercury'], correctIndex: 1, topic: 'Astronomy',
      explanation: 'In a solar eclipse the Moon passes between the Sun and the Earth, blocking sunlight.',
    ),
    MockQuestion(
      id: 'p206-50', subject: MockSubject.everydayScience, question: 'Which temperature scale was introduced by Daniel Gabriel Fahrenheit?',
      options: ['Celsius scale', 'Fahrenheit scale', 'Kelvin scale', 'Rankine scale'], correctIndex: 1, topic: 'Physics',
      explanation: 'Fahrenheit introduced the Fahrenheit temperature scale in the early 18th century. Galileo had built an earlier thermoscope, but the Fahrenheit scale is the one named for Fahrenheit.',
    ),
    MockQuestion(
      id: 'p206-51', subject: MockSubject.generalKnowledge, question: 'In email, what does BCC stand for?',
      options: ['Blind Carbon Copy', 'Basic Carbon Copy', 'Business Copy Control', 'Blank Copy Card'], correctIndex: 0, topic: 'Computer',
      explanation: 'BCC stands for Blind Carbon Copy, used to send a copy of an email to recipients whose addresses are hidden from other recipients.',
    ),
    MockQuestion(
      id: 'p206-52', subject: MockSubject.generalKnowledge, question: 'What does UNIVAC, the name of an early commercial computer, stand for?',
      options: ['Universal Automatic Computer', 'Unified Analog Computer', 'United Automatic Calculator', 'Universal Array Computer'], correctIndex: 0, topic: 'Computer',
      explanation: 'UNIVAC stands for Universal Automatic Computer, one of the earliest commercial computers, delivered in 1951.',
    ),
    MockQuestion(
      id: 'p206-53', subject: MockSubject.generalKnowledge, question: 'Which phrase best describes what a database management system does with data: it helps to organise and describe it for storage and retrieval?',
      options: ['Organize and Describe', 'Store only', 'Delete only', 'None of these'], correctIndex: 0, topic: 'Computer',
      explanation: 'A database system organises and describes data so that it can be stored, found and used. The printed key listed None of these, which is wrong on the researched facts.',
    ),
    MockQuestion(
      id: 'p206-54', subject: MockSubject.generalKnowledge, question: 'In Microsoft Word, the extra space added on the binding side of a page is called what?',
      options: ['Header margin', 'Gutter margin', 'Footer margin', 'Page margin'], correctIndex: 1, topic: 'Computer',
      explanation: 'The gutter margin is extra space on the side of the page that will be bound, so text is not hidden in the binding.',
    ),
    MockQuestion(
      id: 'p206-55', subject: MockSubject.generalKnowledge, question: 'Receiving data from the internet onto a local computer is called what?',
      options: ['Uploading', 'Downloading', 'Browsing', 'Streaming only'], correctIndex: 1, topic: 'Computer',
      explanation: 'Downloading is the transfer of data from a remote system, such as a web server, to a local computer.',
    ),
    MockQuestion(
      id: 'p206-56', subject: MockSubject.generalKnowledge, question: 'The name by which a person is identified when logging into a computer system is called what?',
      options: ['Password', 'User name', 'Domain', 'Server'], correctIndex: 1, topic: 'Computer',
      explanation: 'A user name identifies a person to a system at login, while the password proves the identity.',
    ),
    MockQuestion(
      id: 'p206-57', subject: MockSubject.generalKnowledge, question: 'Surena, developed in Iran, is an example of what kind of machine?',
      options: ['Satellite', 'Robot', 'Drone', 'Computer chip'], correctIndex: 1, topic: 'Computer',
      explanation: 'Surena is a humanoid robot developed in Iran, capable of walking and moving its arms.',
    ),
    MockQuestion(
      id: 'p206-58', subject: MockSubject.generalKnowledge, question: 'Which shortcut key aligns text to the left in Microsoft Word?',
      options: ['Ctrl+R', 'Ctrl+L', 'Ctrl+E', 'Ctrl+J'], correctIndex: 1, topic: 'Computer',
      explanation: 'Ctrl+L aligns the paragraph to the left, Ctrl+R to the right and Ctrl+E to the centre.',
    ),
    MockQuestion(
      id: 'p206-59', subject: MockSubject.generalKnowledge, question: 'In Excel, what happens when a cell is removed with the Delete Cells command?',
      options: ['Row is deleted', 'Cell is deleted', 'Column is deleted', 'Sheet is deleted'], correctIndex: 1, topic: 'Computer',
      explanation: 'The Delete Cells command removes the selected cell, with surrounding cells shifting to fill the gap.',
    ),
    MockQuestion(
      id: 'p206-60', subject: MockSubject.generalKnowledge, question: 'Data fed into a computer for processing is called what?',
      options: ['Output', 'Input', 'Storage', 'Feedback'], correctIndex: 1, topic: 'Computer',
      explanation: 'Input is data entered into a computer, which is then processed and may be given out as output.',
    ),
    MockQuestion(
      id: 'p206-61', subject: MockSubject.generalKnowledge, question: 'Which text effect raises characters above the baseline, as in a power such as x squared?',
      options: ['Regular', 'Bold', 'Superscript', 'Italic'], correctIndex: 2, topic: 'Computer',
      explanation: 'Superscript is a text effect that raises characters above the baseline. Regular is a font style, not an effect, so the printed key listing Regular is wrong.',
    ),
    MockQuestion(
      id: 'p206-62', subject: MockSubject.generalKnowledge, question: 'Which protocol is used to transfer web pages, as listed among the options in this question?',
      options: ['FTP', 'HTTP', 'SMTP', 'TCP'], correctIndex: 1, topic: 'Computer',
      explanation: 'HTTP, the Hypertext Transfer Protocol, transfers web pages. The secure version, HTTPS, is not listed among the options.',
    ),
    MockQuestion(
      id: 'p206-63', subject: MockSubject.generalKnowledge, question: 'Which key deletes the character to the left of the cursor?',
      options: ['Delete', 'Backspace', 'Space', 'Enter'], correctIndex: 1, topic: 'Computer',
      explanation: 'The Backspace key deletes the character to the left of the cursor, while the Delete key removes the character to the right.',
    ),
    MockQuestion(
      id: 'p206-64', subject: MockSubject.generalKnowledge, question: 'In Microsoft Word, data arranged in rows and columns is presented using what?',
      options: ['Tables', 'Charts', 'Text boxes', 'Shapes'], correctIndex: 0, topic: 'Computer',
      explanation: 'Tables arrange text and numbers in rows and columns in a Word document.',
    ),
    MockQuestion(
      id: 'p206-65', subject: MockSubject.generalKnowledge, question: 'Which shortcut key opens Find and Replace in Microsoft Word?',
      options: ['Ctrl+F', 'Ctrl+H', 'Ctrl+R', 'Ctrl+G'], correctIndex: 1, topic: 'Computer',
      explanation: 'Ctrl+H opens the Find and Replace dialog box in Word, while Ctrl+F opens Find only.',
    ),
    MockQuestion(
      id: 'p206-66', subject: MockSubject.generalKnowledge, question: 'Which shortcut key centres text in Microsoft Word?',
      options: ['Ctrl+L', 'Ctrl+R', 'Ctrl+E', 'Ctrl+J'], correctIndex: 2, topic: 'Computer',
      explanation: 'Ctrl+E centres the paragraph, Ctrl+L aligns it left, Ctrl+R aligns it right and Ctrl+J justifies it.',
    ),
    MockQuestion(
      id: 'p206-67', subject: MockSubject.generalKnowledge, question: 'Which tool copies formatting from one part of a document and applies it to another part in Microsoft Word?',
      options: ['Painter', 'Copier', 'Formatter', 'Styler'], correctIndex: 0, topic: 'Computer',
      explanation: 'The Format Painter tool, listed here as Painter, copies formatting from selected text and applies it elsewhere.',
    ),
    MockQuestion(
      id: 'p206-68', subject: MockSubject.generalKnowledge, question: 'Newly received emails arrive in which folder of a mail program?',
      options: ['Sent Items', 'Drafts', 'Inbox', 'Trash'], correctIndex: 2, topic: 'Computer',
      explanation: 'Incoming mail is delivered to the Inbox folder.',
    ),
    MockQuestion(
      id: 'p206-69', subject: MockSubject.generalKnowledge, question: 'Which Microsoft Office program is used for spreadsheets?',
      options: ['Word', 'Excel', 'PowerPoint', 'Outlook'], correctIndex: 1, topic: 'Computer',
      explanation: 'Microsoft Excel is the spreadsheet program of the Office suite.',
    ),
    MockQuestion(
      id: 'p206-70', subject: MockSubject.generalKnowledge, question: 'Which line spacing option sets the space between lines to one and a half times the single spacing in Word?',
      options: ['Single', 'Double', '1.5 line spacing', 'At least'], correctIndex: 2, topic: 'Computer',
      explanation: 'The 1.5 line spacing option sets line spacing to one and a half times single spacing.',
    ),
    MockQuestion(
      id: 'p206-71', subject: MockSubject.generalKnowledge, question: 'Who is known as the father of the supercomputer?',
      options: ['Seymour Cray', 'Charles Babbage', 'John von Neumann', 'Alan Turing'], correctIndex: 0, topic: 'Computer',
      explanation: 'Seymour Cray designed a series of the fastest computers of their time and is known as the father of the supercomputer.',
    ),
    MockQuestion(
      id: 'p206-72', subject: MockSubject.generalKnowledge, question: 'A computer monitor is also called which of the following: a visual display unit (VDU) and a visual display terminal (VDT)?',
      options: ['VDU only', 'VDT only', 'Both A and B', 'Neither'], correctIndex: 2, topic: 'Computer',
      explanation: 'A monitor is called both a visual display unit and a visual display terminal, so both names apply.',
    ),
    MockQuestion(
      id: 'p206-73', subject: MockSubject.generalKnowledge, question: 'Which office suite, available without cost in a basic version, can convert a DOC file into other formats?',
      options: ['Adobe Acrobat Reader', 'WPS Office', 'Notepad', 'Paint'], correctIndex: 1, topic: 'Computer',
      explanation: 'WPS Office can open and convert DOC files. The free Adobe Acrobat Reader does not convert DOC files, so the printed key listing it is wrong.',
    ),
    MockQuestion(
      id: 'p206-74', subject: MockSubject.generalKnowledge, question: 'Which of the following is the default file format in which modern Microsoft Word saves documents?',
      options: ['Text', 'Rich Text', 'Plain Text', 'None of these'], correctIndex: 3, topic: 'Computer',
      explanation: 'Modern Word saves documents in the .docx format, which is none of the formats listed, so None of these is correct. The printed key listing Text is wrong.',
    ),
    MockQuestion(
      id: 'p206-75', subject: MockSubject.generalKnowledge, question: 'The letters after the dot in a file name, showing the type of file, are called what?',
      options: ['File Name', 'File Extension', 'File Path', 'File Size'], correctIndex: 1, topic: 'Computer',
      explanation: 'The file extension, such as .docx or .txt, follows the dot in a file name and shows the file type.',
    ),
    MockQuestion(
      id: 'p206-76', subject: MockSubject.generalKnowledge, question: 'Which bar at the top of a window shows the name of the document or program?',
      options: ['Menu Bar', 'Title Bar', 'Status Bar', 'Tool Bar'], correctIndex: 1, topic: 'Computer',
      explanation: 'The Title Bar at the top of a window shows the name of the document or program.',
    ),
    MockQuestion(
      id: 'p206-77', subject: MockSubject.english, question: 'The word divulge means what?',
      options: ['To hide', 'To reveal secretly', 'To deny', 'To forget'], correctIndex: 1, topic: 'Vocabulary',
      explanation: 'To divulge is to reveal secret or private information.',
    ),
    MockQuestion(
      id: 'p206-78', subject: MockSubject.english, question: 'A person who pretends to have virtues that he does not possess is called what?',
      options: ['Hypocrite', 'Honest man', 'Saint', 'Scholar'], correctIndex: 0, topic: 'Vocabulary',
      explanation: 'A hypocrite claims moral standards or beliefs that his own behaviour does not match.',
    ),
    MockQuestion(
      id: 'p206-79', subject: MockSubject.islamiat, question: 'What is the prescribed punishment for a false accusation of adultery (qazf) under Islamic law?',
      options: ['40 lashes', '80 lashes', '100 lashes', 'Fine only'], correctIndex: 1, topic: 'Islamic Law',
      explanation: 'The Quran prescribes eighty lashes for those who falsely accuse chaste women of adultery, in Surah An-Nur.',
    ),
    MockQuestion(
      id: 'p206-80', subject: MockSubject.islamiat, question: 'The compilation and writing down of Hadith in book form is called what?',
      options: ['Tadveen', 'Tafseer', 'Tajweed', 'Tasawwuf'], correctIndex: 0, topic: 'Hadith',
      explanation: 'Tadveen means compilation, and in Hadith studies it refers to the writing down and compiling of Hadith in books.',
    ),
    MockQuestion(
      id: 'p206-81', subject: MockSubject.islamiat, question: 'To whom did the Prophet Muhammad return the keys of the Kaaba after the conquest of Makkah?',
      options: ['Usman Bin Talha', 'Abbas Bin Abdul Muttalib', 'Ali Bin Abi Talib', 'Khalid Bin Walid'], correctIndex: 0, topic: 'Seerat',
      explanation: 'After the conquest of Makkah, the Prophet returned the keys of the Kaaba to Usman bin Talha, whose family had been its keepers.',
    ),
    MockQuestion(
      id: 'p206-82', subject: MockSubject.islamiat, question: 'Which prophet was given command over the jinn and the winds, and understood the speech of birds?',
      options: ['Hazrat Dawood (AS)', 'Hazrat Suleman (AS)', 'Hazrat Moosa (AS)', 'Hazrat Isa (AS)'], correctIndex: 1, topic: 'Prophets',
      explanation: 'Hazrat Suleman (AS) was given a kingdom in which the winds and the jinn were subject to him, and he understood the language of birds.',
    ),
    MockQuestion(
      id: 'p206-83', subject: MockSubject.islamiat, question: 'Which prophet is associated with the well of Zamzam as a child, when water sprang forth near him and his mother Hajra?',
      options: ['Hazrat Ishaq (AS)', 'Hazrat Ismail (AS)', 'Hazrat Yusuf (AS)', 'Hazrat Yahya (AS)'], correctIndex: 1, topic: 'Prophets',
      explanation: 'Hazrat Ismail (AS) was the infant child of Hajra when the well of Zamzam sprang forth near Makkah.',
    ),
    MockQuestion(
      id: 'p206-84', subject: MockSubject.islamiat, question: 'Slow and measured recitation of the Quran, with clear pronunciation, is called what?',
      options: ['Tarteel', 'Hadr', 'Tadweer', 'Quail'], correctIndex: 0, topic: 'Tajweed',
      explanation: 'Tarteel is slow and measured recitation of the Quran. The printed key listed Quail, which is not a term of recitation and is wrong.',
    ),
    MockQuestion(
      id: 'p206-85', subject: MockSubject.islamiat, question: 'Which qazi is remembered for judging a dispute involving Caliph Ali without favour, and deciding against him on the evidence?',
      options: ['Qazi Shurayh', 'Qazi Abu Yusuf', 'Qazi Iyaz', 'Qazi Abdul Jabbar'], correctIndex: 0, topic: 'Islamic History',
      explanation: 'Qazi Shurayh, judge of Kufa, is famous for deciding a case about a coat of armour against Caliph Ali because the evidence did not support the claim.',
    ),
    MockQuestion(
      id: 'p206-86', subject: MockSubject.islamiat, question: 'In which Hijri year was the Treaty of Hudaybiyyah signed between the Muslims of Madinah and the Quraysh of Makkah?',
      options: ['5 A.H.', '6 A.H.', '7 A.H.', '8 A.H.'], correctIndex: 1, topic: 'Seerat',
      explanation: 'The Treaty of Hudaybiyyah was signed in 6 A.H. (628 AD). The key listing 5 A.H. is wrong.',
    ),
    MockQuestion(
      id: 'p206-87', subject: MockSubject.islamiat, question: 'Who introduced the Hijri calendar, counting years from the migration to Madinah?',
      options: ['Hazrat Abu Bakr (RA)', 'Hazrat Umar (RA)', 'Hazrat Usman (RA)', 'Hazrat Ali (RA)'], correctIndex: 1, topic: 'Islamic History',
      explanation: 'The Hijri calendar was introduced during the caliphate of Hazrat Umar (RA), with years counted from the Hijrah.',
    ),
    MockQuestion(
      id: 'p206-88', subject: MockSubject.islamiat, question: 'The mother of the Prophet Muhammad, Amina bint Wahb, belonged to which tribe of Quraysh?',
      options: ['Bani Hashim', 'Bani Zahra', 'Bani Umayya', 'Bani Makhzum'], correctIndex: 1, topic: 'Seerat',
      explanation: 'Amina bint Wahb belonged to Banu Zuhrah, listed here as Bani Zahra, a clan of the Quraysh.',
    ),
    MockQuestion(
      id: 'p206-89', subject: MockSubject.islamiat, question: 'Which title, meaning mother of cities, is given to Makkah?',
      options: ['Umm Al Qura', 'Baitullah', 'Haram Sharif', 'Darussalam'], correctIndex: 0, topic: 'Islamic Geography',
      explanation: 'Makkah is called Umm Al Qura, the mother of cities, in the Quran.',
    ),
    MockQuestion(
      id: 'p206-90', subject: MockSubject.islamiat, question: 'In which battle was Hazrat Jafar Tayyar martyred while carrying the banner of the Muslim army?',
      options: ['Battle of Badr', 'Battle of Uhud', 'Battle of Mutah', 'Battle of Khandaq'], correctIndex: 2, topic: 'Islamic History',
      explanation: 'Hazrat Jafar ibn Abi Talib, known as Tayyar, was martyred at the Battle of Mutah in 8 A.H.',
    ),
    MockQuestion(
      id: 'p206-91', subject: MockSubject.islamiat, question: 'On the occasion of the expedition against Banu Qaynuqa, who was appointed guardian of Madinah?',
      options: ['Ali', 'Abdul Asma', 'Abdul Mandir', 'Abuzar'], correctIndex: 2, topic: 'Islamic History',
      explanation: 'The name given for this appointment is Abdul Mandir. This is the name as listed for this item and it could not be independently confirmed.',
    ),
    MockQuestion(
      id: 'p206-92', subject: MockSubject.islamiat, question: 'By which name is the assassin of Hazrat Umar (RA) known?',
      options: ['Fayruz', 'Ibn Muljam', 'Ibn Saba', 'Marwan'], correctIndex: 0, topic: 'Islamic History',
      explanation: 'Hazrat Umar (RA) was assassinated by Abu Lulu Fayruz, a Persian slave, in 644 AD.',
    ),
    MockQuestion(
      id: 'p206-93', subject: MockSubject.islamiat, question: 'Which Surah contains the verses on modesty and on the false accusation against Hazrat Ayesha (RA)?',
      options: ['Surah Noor', 'Surah Ahzab', 'Surah Baqarah', 'Surah Nisa'], correctIndex: 0, topic: 'Quran',
      explanation: 'Surah An-Nur contains the verses on modesty, the veil, and the incident of the false accusation against Hazrat Ayesha (RA).',
    ),
    MockQuestion(
      id: 'p206-94', subject: MockSubject.islamiat, question: 'In the terminology of Hadith classification, which of the listed words is given for the category discussed in this question?',
      options: ['Sad', 'Happy', 'Disputed', 'None of these'], correctIndex: 1, topic: 'Hadith',
      explanation: 'This item is unverified. The options as printed are nonsensical for Hadith terminology, and the listed value Happy could not be confirmed.',
    ),
    MockQuestion(
      id: 'p206-95', subject: MockSubject.islamiat, question: 'How many articles of faith (Iman) are there in Islam?',
      options: ['4', '5', '6', '7'], correctIndex: 2, topic: 'Beliefs',
      explanation: 'There are six articles of faith: belief in Allah, His angels, His books, His messengers, the Day of Judgement, and divine decree.',
    ),
    MockQuestion(
      id: 'p206-96', subject: MockSubject.islamiat, question: 'Which prophet confronted Pharaoh and received the Torah on Mount Sinai?',
      options: ['Hazrat Haroon (AS)', 'Hazrat Moosa (AS)', 'Hazrat Dawood (AS)', 'Hazrat Isa (AS)'], correctIndex: 1, topic: 'Prophets',
      explanation: 'Hazrat Moosa (AS) confronted Pharaoh in Egypt and received the Torah on Mount Sinai.',
    ),
    MockQuestion(
      id: 'p206-97', subject: MockSubject.islamiat, question: 'How many additional days of fasting completed the forty days of Hazrat Moosa (AS) on the mountain, after the first thirty days?',
      options: ['5 fasts', '7 fasts', '10 fasts', '15 fasts'], correctIndex: 2, topic: 'Prophets',
      explanation: 'The Quran states that thirty nights were appointed for Moosa and completed with ten more, making forty in all.',
    ),
    MockQuestion(
      id: 'p206-98', subject: MockSubject.islamiat, question: 'Which act spoils charity, by reminding the receiver of the favour that was done?',
      options: ['Giving openly', 'Reminding others of favour', 'Giving secretly', 'Giving regularly'], correctIndex: 1, topic: 'Islamic Teachings',
      explanation: 'Reminding the receiver of a favour, called mann, spoils charity, as warned in the Quran.',
    ),
    MockQuestion(
      id: 'p206-99', subject: MockSubject.islamiat, question: 'Which pact did the young Muhammad join in Makkah to help the oppressed and protect travellers?',
      options: ['Hilf Al Fudul', 'Treaty of Hudaybiyyah', 'Pact of Aqaba', 'Charter of Madinah'], correctIndex: 0, topic: 'Seerat',
      explanation: 'Hilf Al Fudul was a pact of Makkan tribes to help victims of injustice, which the young Muhammad joined and later praised.',
    ),
    MockQuestion(
      id: 'p206-100', subject: MockSubject.islamiat, question: 'Who was the second Caliph of Islam?',
      options: ['Hazrat Abu Bakr (RA)', 'Hazrat Umar (RA)', 'Hazrat Usman (RA)', 'Hazrat Ali (RA)'], correctIndex: 1, topic: 'Islamic History',
      explanation: 'Hazrat Umar (RA) succeeded Hazrat Abu Bakr (RA) as the second Caliph, ruling from 634 to 644 AD.',
    ),
  ],
  latestUpdates: [
    'Latest update (late October 2026): Sardar Saleem Haider Khan is still the Governor of Punjab, Pakistan.',
    'Latest update (late October 2026): Ahmad al-Sharaa is still the President of Syria.',
  ],
);
