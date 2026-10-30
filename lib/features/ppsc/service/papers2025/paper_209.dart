import '../../model/mock_question.dart';
import '../../model/paper_test.dart';

// PRACTICE MATERIAL ONLY.
// This is a practice mock test written in fresh wording for revision.
// It is not an official paper, not a verbatim reproduction of any exam,
// and it does not predict any real exam. Answers were checked against
// general reference facts at build time; where a printed key differed
// from the researched fact, the researched fact was used.
// NOTE: One page of the source scan for this paper is greyed out and
// unreadable, so source questions 81 and 91 to 100 could not be recovered
// and are omitted. File positions 81 to 89 below are source questions
// 82 to 90.

const PaperTest paper209 = PaperTest(
  id: '2025-209',
  paperNo: 209,
  year: 2025,
  post: 'Labour Officer (BS-16)',
  department: 'Labour and Human Resources Department',
  examDate: '16.11.2025',
  questions: [
    // General Knowledge
    MockQuestion(
      id: 'p209-1', subject: MockSubject.generalKnowledge, question: 'Which state of the United States has the largest number of lakes?',
      options: ['Minnesota', 'Alaska', 'Florida', 'Michigan'], correctIndex: 1, topic: 'Geography',
      explanation: 'Alaska has by far the largest number of lakes in the United States, well over three million. Minnesota is nicknamed the Land of 10,000 Lakes, but Alaska has far more.',
    ),
    MockQuestion(
      id: 'p209-2', subject: MockSubject.generalKnowledge, question: 'For how many years did Angela Merkel remain Chancellor of Germany?',
      options: ['12 years', '14 years', '16 years', '20 years'], correctIndex: 2, topic: 'World Leaders',
      explanation: 'Angela Merkel was Chancellor of Germany from 2005 to 2021, a period of 16 years.',
    ),
    MockQuestion(
      id: 'p209-3', subject: MockSubject.generalKnowledge, question: 'Who made the first powered aeroplane flight in 1903 at Kitty Hawk?',
      options: ['Wright Brothers', 'Charles Lindbergh', 'Alberto Santos-Dumont', 'Louis Bleriot'], correctIndex: 0, topic: 'Inventions',
      explanation: 'Orville and Wilbur Wright, the Wright brothers, made the first sustained powered aeroplane flight in December 1903.',
    ),
    MockQuestion(
      id: 'p209-4', subject: MockSubject.generalKnowledge, question: 'In which city is the Eiffel Tower located?',
      options: ['London', 'Paris', 'Rome', 'Berlin'], correctIndex: 1, topic: 'Geography',
      explanation: 'The Eiffel Tower is located in Paris, the capital of France.',
    ),
    MockQuestion(
      id: 'p209-5', subject: MockSubject.pakistanStudies, question: 'On which date did India revoke the special status of Jammu and Kashmir under Article 370 in 2019?',
      options: ['5 August 2019', '15 August 2019', '5 August 2018', '1 September 2019'], correctIndex: 0, topic: 'Current Affairs',
      explanation: 'On 5 August 2019 India revoked Articles 370 and 35A, ending the special status of Jammu and Kashmir.',
    ),
    MockQuestion(
      id: 'p209-6', subject: MockSubject.generalKnowledge, question: 'A large open ground for sports, surrounded by seating for spectators, is called a:',
      options: ['Stadium', 'Museum', 'Theatre', 'Library'], correctIndex: 0, topic: 'Vocabulary',
      explanation: 'A stadium is a large sports ground with tiers of seating for spectators.',
    ),
    MockQuestion(
      id: 'p209-7', subject: MockSubject.generalKnowledge, question: 'Which city is the capital of Syria?',
      options: ['Aleppo', 'Damascus', 'Homs', 'Beirut'], correctIndex: 1, topic: 'Geography',
      explanation: 'Damascus is the capital city of Syria and one of the oldest continuously inhabited cities in the world.',
    ),
    MockQuestion(
      id: 'p209-8', subject: MockSubject.generalKnowledge, question: 'How many permanent members does the United Nations Security Council have, each with the power of veto?',
      options: ['3 countries', '5 countries', '7 countries', '10 countries'], correctIndex: 1, topic: 'International Organisations',
      explanation: 'The Security Council has five permanent members: the United States, the United Kingdom, France, Russia and China.',
    ),
    MockQuestion(
      id: 'p209-9', subject: MockSubject.generalKnowledge, question: 'Who became the first President of South Africa elected in fully democratic elections in 1994?',
      options: ['Nelson Mandela', 'F. W. de Klerk', 'Thabo Mbeki', 'Desmond Tutu'], correctIndex: 0, topic: 'World Leaders',
      explanation: 'Nelson Mandela became President of South Africa in 1994 after the first elections in which all races could vote.',
    ),
    MockQuestion(
      id: 'p209-10', subject: MockSubject.english, question: 'A person who follows another in an office or position is called a:',
      options: ['Predecessor', 'Successor', 'Founder', 'Rival'], correctIndex: 1, topic: 'Vocabulary',
      explanation: 'A successor follows another person in an office, while a predecessor held the office before.',
    ),
    MockQuestion(
      id: 'p209-11', subject: MockSubject.generalKnowledge, question: 'Which power brought an end to the Abbasid Caliphate in Baghdad in 1258?',
      options: ['The Romans', 'The Persians', 'The Byzantines', 'None of these'], correctIndex: 3, topic: 'History',
      explanation: 'The Mongols under Hulagu Khan sacked Baghdad in 1258 and ended the Abbasid Caliphate. The Mongols are not listed among the options, so None of these is correct. The stem as printed is garbled and this item is unverified.',
    ),
    MockQuestion(
      id: 'p209-12', subject: MockSubject.generalKnowledge, question: 'Which Formula One driver shares the record of seven world championship titles with Michael Schumacher?',
      options: ['Lewis Hamilton', 'Max Verstappen', 'Sebastian Vettel', 'Fernando Alonso'], correctIndex: 0, topic: 'Sports',
      explanation: 'Lewis Hamilton won seven Formula One world championships between 2008 and 2020, equalling the record of Michael Schumacher.',
    ),
    MockQuestion(
      id: 'p209-13', subject: MockSubject.generalKnowledge, question: 'Which agreement, signed in 2020, allows India and the United States to share geospatial intelligence for defence purposes?',
      options: ['Basic Exchange and Cooperation Agreement', 'Logistics Exchange Memorandum', 'Communications Compatibility Agreement', 'Defence Framework Agreement'], correctIndex: 0, topic: 'International Relations',
      explanation: 'The Basic Exchange and Cooperation Agreement, BECA, signed in October 2020, allows India and the United States to share geospatial data.',
    ),
    MockQuestion(
      id: 'p209-14', subject: MockSubject.pakistanStudies, question: 'In which city is Minar-e-Pakistan located?',
      options: ['Karachi', 'Lahore', 'Islamabad', 'Multan'], correctIndex: 1, topic: 'Geography of Pakistan',
      explanation: 'Minar-e-Pakistan is located in Iqbal Park, Lahore, near the site where the Lahore Resolution was passed in 1940.',
    ),
    MockQuestion(
      id: 'p209-15', subject: MockSubject.pakistanStudies, question: 'Which Prime Minister presented the constitutional formula of 1953 known by his name?',
      options: ['Muhammad Ali Bogra', 'Khawaja Nazimuddin', 'Chaudhry Muhammad Ali', 'H. S. Suhrawardy'], correctIndex: 0, topic: 'Pakistan History',
      explanation: 'Muhammad Ali Bogra, Prime Minister from 1953 to 1955, presented the Bogra Formula for the constitution of Pakistan.',
    ),
    MockQuestion(
      id: 'p209-16', subject: MockSubject.pakistanStudies, question: 'Miranshah is the main town of which district in Khyber Pakhtunkhwa?',
      options: ['South Waziristan', 'North Waziristan', 'Kurram', 'Orakzai'], correctIndex: 1, topic: 'Geography of Pakistan',
      explanation: 'Miranshah is the headquarters town of North Waziristan district.',
    ),
    MockQuestion(
      id: 'p209-17', subject: MockSubject.pakistanStudies, question: 'Who founded the Muhammadan Anglo-Oriental College at Aligarh, later Aligarh Muslim University?',
      options: ['Sir Syed Ahmad Khan', 'Muhammad Ali Jinnah', 'Allama Iqbal', 'Abul Kalam Azad'], correctIndex: 0, topic: 'Pakistan Movement',
      explanation: 'Sir Syed Ahmad Khan founded the Muhammadan Anglo-Oriental College at Aligarh in 1875.',
    ),
    MockQuestion(
      id: 'p209-18', subject: MockSubject.pakistanStudies, question: 'Who launched the journal Tahzib-ul-Akhlaq to promote social and educational reform among Muslims?',
      options: ['Abul Ala Maududi', 'Sir Syed Ahmad Khan', 'Shibli Naumani', 'Altaf Hussain Hali'], correctIndex: 1, topic: 'Pakistan Movement',
      explanation: 'Sir Syed Ahmad Khan launched Tahzib-ul-Akhlaq in 1870 as part of the Aligarh movement for reform.',
    ),
    MockQuestion(
      id: 'p209-19', subject: MockSubject.pakistanStudies, question: 'In which year were the first general elections held in Pakistan on the basis of adult franchise?',
      options: ['1956', '1962', '1970', '1977'], correctIndex: 2, topic: 'Pakistan History',
      explanation: 'The first general elections in Pakistan on the basis of adult franchise were held in December 1970.',
    ),
    MockQuestion(
      id: 'p209-20', subject: MockSubject.pakistanStudies, question: 'In which year was the first census conducted in Pakistan after independence?',
      options: ['1948', '1951', '1961', '1972'], correctIndex: 1, topic: 'Pakistan Studies',
      explanation: 'The first census of Pakistan after independence was conducted in 1951.',
    ),
    MockQuestion(
      id: 'p209-21', subject: MockSubject.pakistanStudies, question: 'In which year was the One Unit scheme introduced, merging the provinces of West Pakistan into a single province?',
      options: ['1952', '1955', '1958', '1962'], correctIndex: 1, topic: 'Pakistan History',
      explanation: 'The One Unit scheme was introduced in 1955 and remained in force until 1970.',
    ),
    MockQuestion(
      id: 'p209-22', subject: MockSubject.generalKnowledge, question: 'In which year was the Battle of Plassey fought, in which the East India Company defeated the Nawab of Bengal?',
      options: ['1748', '1757', '1761', '1764'], correctIndex: 1, topic: 'History',
      explanation: 'The Battle of Plassey was fought in June 1757, giving the East India Company control over Bengal.',
    ),
    MockQuestion(
      id: 'p209-23', subject: MockSubject.generalKnowledge, question: 'Which Mughal emperor introduced the Din-i-Ilahi, a new religious order, in 1582?',
      options: ['Babur', 'Humayun', 'Akbar', 'Jahangir'], correctIndex: 2, topic: 'History',
      explanation: 'The emperor Akbar introduced the Din-i-Ilahi in 1582 as an ethical order bringing together elements of different faiths.',
    ),
    MockQuestion(
      id: 'p209-24', subject: MockSubject.generalKnowledge, question: 'Which country launched Sputnik 1, the first artificial satellite, in 1957?',
      options: ['USA', 'USSR', 'United Kingdom', 'France'], correctIndex: 1, topic: 'Space',
      explanation: 'The Soviet Union, USSR, launched Sputnik 1 in October 1957, the first artificial satellite to orbit the Earth.',
    ),
    MockQuestion(
      id: 'p209-25', subject: MockSubject.pakistanStudies, question: 'Who wrote the poems Shikwa and Jawab-e-Shikwa?',
      options: ['Faiz Ahmad Faiz', 'Allama Iqbal', 'Mir Taqi Mir', 'Josh Malihabadi'], correctIndex: 1, topic: 'Literature',
      explanation: 'Shikwa (Complaint) and Jawab-e-Shikwa (Reply to the Complaint) are famous Urdu poems by Allama Muhammad Iqbal.',
    ),
    MockQuestion(
      id: 'p209-26', subject: MockSubject.pakistanStudies, question: 'Which body is named in this paper as the authority responsible for environmental matters?',
      options: ['Health Authority', 'Environment Authority', 'Education Authority', 'Finance Authority'], correctIndex: 1, topic: 'Environment',
      explanation: 'The listed answer is Environment Authority. This item is unverified, because the printed stem is unclear and the federal body in Pakistan is the Pakistan Environmental Protection Agency.',
    ),
    MockQuestion(
      id: 'p209-27', subject: MockSubject.pakistanStudies, question: 'Which article of the Constitution of Pakistan empowered the President to dissolve the National Assembly at his discretion?',
      options: ['Article 58(2)(b)', 'Article 62', 'Article 184', 'Article 199'], correctIndex: 0, topic: 'Constitution',
      explanation: 'Article 58(2)(b), inserted by the Eighth Amendment in 1985, empowered the President to dissolve the National Assembly. It was removed by the Eighteenth Amendment in 2010.',
    ),
    MockQuestion(
      id: 'p209-28', subject: MockSubject.pakistanStudies, question: 'Which sector is the main focus of the energy project discussed in this question?',
      options: ['Power Generation', 'Textile Exports', 'Road Building', 'Fisheries'], correctIndex: 0, topic: 'Economy',
      explanation: 'The listed focus is power generation. The stem is unclear in the scan, so this item is unverified.',
    ),
    MockQuestion(
      id: 'p209-29', subject: MockSubject.pakistanStudies, question: 'Which economic corridor project links Gwadar Port with western China through Pakistan?',
      options: ['CPEC', 'TAPI', 'ECO Corridor', 'Karakoram Highway only'], correctIndex: 0, topic: 'Economy',
      explanation: 'The China-Pakistan Economic Corridor, CPEC, is a network of roads, railways and energy projects linking Gwadar with western China.',
    ),
    MockQuestion(
      id: 'p209-30', subject: MockSubject.pakistanStudies, question: 'Which group of countries is listed for the CASA-1000 electricity transmission project, apart from Kyrgyzstan?',
      options: ['Tajikistan, Pakistan, Afghanistan', 'India, Pakistan, Bangladesh', 'Iran, Iraq, Turkey', 'China, Nepal, Bhutan'], correctIndex: 0, topic: 'Economy',
      explanation: 'CASA-1000 links Kyrgyzstan and Tajikistan with Afghanistan and Pakistan for the export of surplus hydroelectricity. Kyrgyzstan is the fourth partner and is not listed among the options.',
    ),
    MockQuestion(
      id: 'p209-31', subject: MockSubject.pakistanStudies, question: 'Which Pakistani javelin thrower set an Olympic record at the Paris 2024 Olympics?',
      options: ['Arshad Nadeem', 'Haider Ali', 'Muhammad Yasir', 'Shajar Abbas'], correctIndex: 0, topic: 'Sports',
      explanation: 'Arshad Nadeem won gold at Paris 2024 with a throw of 92.97 metres, a new Olympic record.',
    ),
    MockQuestion(
      id: 'p209-32', subject: MockSubject.pakistanStudies, question: 'Which community was declared a non-Muslim minority by the Second Constitutional Amendment of 1974 in Pakistan?',
      options: ['Ahmadiya community', 'Christian community', 'Hindu community', 'Sikh community'], correctIndex: 0, topic: 'Constitution',
      explanation: 'The Second Amendment of 1974 declared the Ahmadiya community to be non-Muslim for constitutional purposes in Pakistan.',
    ),
    MockQuestion(
      id: 'p209-33', subject: MockSubject.pakistanStudies, question: 'Who is the Chief Justice of Pakistan?',
      options: ['Yahya Afridi', 'Qazi Faez Isa', 'Umar Ata Bandial', 'Gulzar Ahmed'], correctIndex: 0, topic: 'Current Affairs',
      explanation: 'Justice Yahya Afridi is the Chief Justice of Pakistan. See the latest update note at the end of this paper, including the note about the acting arrangement while he was abroad.',
    ),
    MockQuestion(
      id: 'p209-34', subject: MockSubject.pakistanStudies, question: 'Justice Ayesha Malik holds which distinction in the judiciary of Pakistan?',
      options: ['First woman judge in the Supreme Court', 'First woman Chief Justice of Pakistan', 'First woman judge of the Lahore High Court', 'First woman Attorney General'], correctIndex: 0, topic: 'Judiciary',
      explanation: 'Justice Ayesha Malik became the first woman judge of the Supreme Court of Pakistan in January 2022.',
    ),
    MockQuestion(
      id: 'p209-35', subject: MockSubject.generalKnowledge, question: 'Who is the President of the International Court of Justice?',
      options: ['Yuji Iwasawa', 'Joan Donoghue', 'Antonio Guterres', 'Karim Khan'], correctIndex: 0, topic: 'Current Affairs',
      explanation: 'Judge Yuji Iwasawa of Japan is the President of the International Court of Justice, serving until 5 February 2027. See the latest update note at the end of this paper.',
    ),
    MockQuestion(
      id: 'p209-36', subject: MockSubject.pakistanStudies, question: 'The Roshan Digital Account and related branding for banking services are aimed at which group?',
      options: ['Overseas Pakistanis', 'Local farmers', 'Students abroad only', 'Foreign tourists'], correctIndex: 0, topic: 'Economy',
      explanation: 'Roshan Digital Accounts were introduced for overseas Pakistanis to open bank accounts in Pakistan remotely.',
    ),
    MockQuestion(
      id: 'p209-37', subject: MockSubject.generalKnowledge, question: 'For which term was Pakistan elected to the United Nations Human Rights Council in October 2025?',
      options: ['2024-2026', '2026-2028', '2028-2030', '2025-2027'], correctIndex: 1, topic: 'General Knowledge',
      explanation: 'The United Nations General Assembly elected Pakistan to the Human Rights Council on 14 October 2025 for the term 2026 to 2028, with 178 votes. It was the sixth time Pakistan was elected to the Council.',
    ),
    MockQuestion(
      id: 'p209-38', subject: MockSubject.pakistanStudies, question: 'Who served as the Permanent Representative of Pakistan to the United Nations until October 2026?',
      options: ['Munir Akram', 'Asim Iftikhar Ahmad', 'Maleeha Lodhi', 'Abdullah Hussain Haroon'], correctIndex: 1, topic: 'Current Affairs',
      explanation: 'Asim Iftikhar Ahmad served as Permanent Representative from April 2025 until October 2026. See the latest update note at the end of this paper: he became Foreign Secretary on 12 October 2026.',
    ),
    MockQuestion(
      id: 'p209-39', subject: MockSubject.pakistanStudies, question: 'Which country announced in April 2025 that it would welcome up to 150,000 skilled workers from Pakistan?',
      options: ['Belarus', 'Russia', 'Poland', 'Romania'], correctIndex: 0, topic: 'Current Affairs',
      explanation: 'During talks in Minsk in April 2025, Belarus announced it would welcome up to 150,000 skilled Pakistani workers. The announcement was a commitment in principle, and later reporting says the programme largely did not materialise.',
    ),
    MockQuestion(
      id: 'p209-40', subject: MockSubject.pakistanStudies, question: 'According to the estimate discussed in this question, real GDP growth of Pakistan for 2025 was about what percent?',
      options: ['1%', '3%', '5%', '7%'], correctIndex: 1, topic: 'Economy',
      explanation: 'Growth for the financial year 2025 was recorded at about 3 percent: the IMF country report of December 2025 records 3.0 percent, and the National Accounts Committee approved 3.09 percent. The option 3 percent is the closest listed value.',
    ),
    MockQuestion(
      id: 'p209-41', subject: MockSubject.pakistanStudies, question: 'Which European country did the Chief of the Air Staff of Pakistan visit in 2025 for meetings with its air force leadership?',
      options: ['Romania', 'Poland', 'Hungary', 'Bulgaria'], correctIndex: 0, topic: 'Current Affairs',
      explanation: 'Air Chief Marshal Zaheer Ahmed Baber Sidhu visited Romania for meetings with the Romanian Air Force leadership. Reports place the visit after May 2025, not in April 2025 as the stem states, so the April date should not be asserted.',
    ),
    MockQuestion(
      id: 'p209-42', subject: MockSubject.generalKnowledge, question: 'Which is the highest mountain in Africa?',
      options: ['Mount Kenya', 'Kilimanjaro', 'Mount Stanley', 'Mount Meru'], correctIndex: 1, topic: 'Geography',
      explanation: 'Mount Kilimanjaro in Tanzania, at 5,895 metres, is the highest mountain in Africa.',
    ),
    MockQuestion(
      id: 'p209-43', subject: MockSubject.generalKnowledge, question: 'Lake Malawi is shared by Malawi and Tanzania and which other country?',
      options: ['Mozambique', 'Zambia', 'Zimbabwe', 'Kenya'], correctIndex: 0, topic: 'Geography',
      explanation: 'Lake Malawi, also called Lake Nyasa, is shared by Malawi, Tanzania and Mozambique. Mozambique is the only bordering country listed among the options.',
    ),
    MockQuestion(
      id: 'p209-44', subject: MockSubject.generalKnowledge, question: 'In which city is the headquarters of the United Nations located?',
      options: ['Geneva', 'New York', 'Vienna', 'Paris'], correctIndex: 1, topic: 'International Organisations',
      explanation: 'The headquarters of the United Nations is in New York City.',
    ),
    MockQuestion(
      id: 'p209-45', subject: MockSubject.everydayScience, question: 'Which imaginary line divides the Earth into the northern and southern hemispheres at zero degrees latitude?',
      options: ['Tropic of Cancer', 'Equator', 'Prime Meridian', 'Arctic Circle'], correctIndex: 1, topic: 'Geography',
      explanation: 'The Equator, at zero degrees latitude, divides the Earth into northern and southern hemispheres.',
    ),
    MockQuestion(
      id: 'p209-46', subject: MockSubject.everydayScience, question: 'Lines on a weather map joining places of equal atmospheric pressure are called:',
      options: ['Isotherms', 'Isobars', 'Isohyets', 'Contours'], correctIndex: 1, topic: 'Physics',
      explanation: 'Isobars join places with the same atmospheric pressure at a given time.',
    ),
    MockQuestion(
      id: 'p209-47', subject: MockSubject.everydayScience, question: 'The process by which fertile land gradually turns into desert is called:',
      options: ['Deforestation', 'Desertification', 'Erosion', 'Salinization'], correctIndex: 1, topic: 'Environment',
      explanation: 'Desertification is the degradation of land in dry areas, turning fertile land into desert, often through climate change and poor land use.',
    ),
    MockQuestion(
      id: 'p209-48', subject: MockSubject.everydayScience, question: 'Who discovered penicillin in 1928?',
      options: ['Alexander Fleming', 'Louis Pasteur', 'Joseph Lister', 'Robert Koch'], correctIndex: 0, topic: 'Science History',
      explanation: 'Alexander Fleming discovered penicillin in 1928, when he noticed that Penicillium mould killed bacteria in a culture dish.',
    ),
    MockQuestion(
      id: 'p209-49', subject: MockSubject.everydayScience, question: 'Who developed the first vaccine against smallpox?',
      options: ['Edward Jenner', 'Louis Pasteur', 'Jonas Salk', 'Alexander Fleming'], correctIndex: 0, topic: 'Science History',
      explanation: 'Edward Jenner developed the smallpox vaccine in 1796, using material from cowpox lesions.',
    ),
    MockQuestion(
      id: 'p209-50', subject: MockSubject.everydayScience, question: 'The amount of matter in an object is called its:',
      options: ['Weight', 'Mass', 'Volume', 'Density'], correctIndex: 1, topic: 'Physics',
      explanation: 'Mass is the amount of matter in an object, while weight is the force of gravity on that mass.',
    ),
    MockQuestion(
      id: 'p209-51', subject: MockSubject.everydayScience, question: 'The Manhattan Project of the Second World War developed which weapon?',
      options: ['Atomic Bomb', 'Hydrogen Bomb only', 'Poison Gas', 'Biological Weapon'], correctIndex: 0, topic: 'History of Science',
      explanation: 'The Manhattan Project was the American programme that developed the first atomic bombs, used in 1945.',
    ),
    MockQuestion(
      id: 'p209-52', subject: MockSubject.everydayScience, question: 'The natural home of a plant or animal, whose loss is the leading driver of species decline, is called its:',
      options: ['Habitat', 'Climate', 'Territory', 'Shelter'], correctIndex: 0, topic: 'Biology',
      explanation: 'A habitat is the natural environment of a plant or animal. Habitat loss is the leading driver of species decline, although deforestation and global warming are also major causes.',
    ),
    MockQuestion(
      id: 'p209-53', subject: MockSubject.everydayScience, question: 'Which form of energy is transferred from a hot object to a cooler one when they are in contact?',
      options: ['Light', 'Sound', 'Heat', 'Magnetism'], correctIndex: 2, topic: 'Physics',
      explanation: 'Heat is the form of energy transferred because of a difference in temperature. The stem of this item is garbled in the scan and this item is unverified.',
    ),
    MockQuestion(
      id: 'p209-54', subject: MockSubject.everydayScience, question: 'A substance that can act both as an acid and as a base is called:',
      options: ['Neutral', 'Amphoteric', 'Alkaline', 'Acidic'], correctIndex: 1, topic: 'Chemistry',
      explanation: 'An amphoteric substance, such as water or aluminium oxide, can react as either an acid or a base.',
    ),
    MockQuestion(
      id: 'p209-55', subject: MockSubject.everydayScience, question: 'Which gas do humans need for respiration and which supports combustion?',
      options: ['Carbon', 'Oxygen', 'Nitrogen', 'Hydrogen'], correctIndex: 1, topic: 'Chemistry',
      explanation: 'Oxygen is the gas needed for respiration and for combustion. The source option printed as Corban is evidently a misprint for Carbon, a distractor, and is written here as Carbon.',
    ),
    MockQuestion(
      id: 'p209-56', subject: MockSubject.generalKnowledge, question: 'Which company operates the most widely used internet search engine in the world?',
      options: ['Google', 'Microsoft', 'Yahoo', 'Baidu'], correctIndex: 0, topic: 'Computer',
      explanation: 'Google operates the most widely used search engine in the world.',
    ),
    MockQuestion(
      id: 'p209-57', subject: MockSubject.generalKnowledge, question: 'Which interface carries high definition video and audio through a single cable to a television or monitor?',
      options: ['VGA', 'HDMI', 'USB', 'Ethernet'], correctIndex: 1, topic: 'Computer',
      explanation: 'HDMI, the High Definition Multimedia Interface, carries both high definition video and audio in one cable.',
    ),
    MockQuestion(
      id: 'p209-58', subject: MockSubject.generalKnowledge, question: 'In a computer form, a small square that can be ticked to select an option is called a:',
      options: ['Radio button', 'Check box', 'Text box', 'Menu'], correctIndex: 1, topic: 'Computer',
      explanation: 'A check box is a small square control that is ticked to select an option, and several check boxes can be selected at once.',
    ),
    MockQuestion(
      id: 'p209-59', subject: MockSubject.generalKnowledge, question: 'Who wrote the first web browser and set up the first web server?',
      options: ['Tim Berners-Lee', 'Bill Gates', 'Steve Jobs', 'Larry Page'], correctIndex: 0, topic: 'Computer',
      explanation: 'Tim Berners-Lee wrote the first web browser and the first web server at CERN around 1990.',
    ),
    MockQuestion(
      id: 'p209-60', subject: MockSubject.mathematics, question: 'How many degrees are there in a right angle?',
      options: ['45', '90', '180', '360'], correctIndex: 1, topic: 'Geometry',
      explanation: 'A right angle measures 90 degrees.',
    ),
    MockQuestion(
      id: 'p209-61', subject: MockSubject.mathematics, question: 'How many degrees do the interior angles of a triangle add up to?',
      options: ['90', '180', '270', '360'], correctIndex: 1, topic: 'Geometry',
      explanation: 'The interior angles of any triangle add up to 180 degrees.',
    ),
    MockQuestion(
      id: 'p209-62', subject: MockSubject.mathematics, question: 'What is the ratio 66:56 in its simplest form?',
      options: ['33:28', '33:26', '11:9', '22:19'], correctIndex: 0, topic: 'Ratio',
      explanation: 'Dividing both terms of 66:56 by 2 gives 33:28 in simplest form.',
    ),
    MockQuestion(
      id: 'p209-63', subject: MockSubject.mathematics, question: 'What fraction of 60 is 20?',
      options: ['1/2', '1/3', '1/4', '2/3'], correctIndex: 1, topic: 'Fractions',
      explanation: 'Twenty is one third of sixty, so the fraction is 1 over 3.',
    ),
    MockQuestion(
      id: 'p209-64', subject: MockSubject.mathematics, question: 'What is 6 minus 40?',
      options: ['34', '-34', '46', '-46'], correctIndex: 1, topic: 'Integers',
      explanation: 'Six minus forty is negative thirty four.',
    ),
    MockQuestion(
      id: 'p209-65', subject: MockSubject.mathematics, question: 'What is negative 0.28 expressed as a fraction in its lowest terms?',
      options: ['-7/25', '-7/20', '-1/4', '-2/7'], correctIndex: 0, topic: 'Fractions',
      explanation: 'Negative 0.28 is negative 28 over 100, which reduces by dividing by 4 to negative 7 over 25.',
    ),
    MockQuestion(
      id: 'p209-66', subject: MockSubject.mathematics, question: 'The lines given by x + y = 5 and 2x + 2y = 10 meet at how many points, choosing from the listed options?',
      options: ['No points', 'One point', 'Two points', 'Four points'], correctIndex: 0, topic: 'Algebra',
      explanation: 'This question is flawed. The two equations describe the same line, so the lines coincide and have infinitely many points in common, not a single unique point. No listed option is strictly correct. The answer No points is retained as the listed answer, in the sense of no single unique meeting point.',
    ),
    MockQuestion(
      id: 'p209-67', subject: MockSubject.mathematics, question: 'Two numbers add up to 28 and differ by 10. Which pair of numbers are they?',
      options: ['19 and 9', '18 and 10', '20 and 8', '16 and 12'], correctIndex: 0, topic: 'Algebra',
      explanation: 'Nineteen and nine add up to 28 and differ by 10.',
    ),
    MockQuestion(
      id: 'p209-68', subject: MockSubject.english, question: 'Choose the word closest in meaning to keen and enthusiastic:',
      options: ['Reluctant', 'Eager', 'Lazy', 'Bored'], correctIndex: 1, topic: 'Vocabulary',
      explanation: 'Eager means keen and enthusiastic about doing something.',
    ),
    MockQuestion(
      id: 'p209-69', subject: MockSubject.english, question: 'Which of the following is an exclamation calling for silence?',
      options: ['Quiet!', 'Silence is golden', 'Please sit down', 'Go now'], correctIndex: 0, topic: 'Vocabulary',
      explanation: 'Quiet! is an exclamation used to call for silence.',
    ),
    MockQuestion(
      id: 'p209-70', subject: MockSubject.english, question: 'Choose the correct preposition: He wrote a preface ___ his book.',
      options: ['To', 'For', 'With', 'By'], correctIndex: 0, topic: 'Prepositions',
      explanation: 'A preface is written to a book, in the idiomatic sense of an introduction addressed to the reader.',
    ),
    MockQuestion(
      id: 'p209-71', subject: MockSubject.english, question: 'Choose the correct phrasal verb: He ___ at the meeting very late.',
      options: ['Turned down', 'Turned up', 'Turned off', 'Turned out'], correctIndex: 1, topic: 'Phrasal Verbs',
      explanation: 'To turn up is to arrive at a place, so he turned up at the meeting.',
    ),
    MockQuestion(
      id: 'p209-72', subject: MockSubject.english, question: 'Which pair shows the same relationship as an antidote counteracting poison?',
      options: ['Antidote : Counteract', 'Poison : Cure', 'Doctor : Patient', 'Medicine : Disease'], correctIndex: 0, topic: 'Analogies',
      explanation: 'An antidote counteracts the effect of a poison, so the pair names the agent and its action.',
    ),
    MockQuestion(
      id: 'p209-73', subject: MockSubject.english, question: 'A group of lions is called a:',
      options: ['Lion : Pride', 'Lion : Herd', 'Lion : Pack', 'Lion : Flock'], correctIndex: 0, topic: 'Vocabulary',
      explanation: 'A group of lions is called a pride.',
    ),
    MockQuestion(
      id: 'p209-74', subject: MockSubject.english, question: 'Choose the word closest in meaning to dishonest and misleading:',
      options: ['Honest', 'Deceitful', 'Frank', 'Loyal'], correctIndex: 1, topic: 'Vocabulary',
      explanation: 'Deceitful means dishonest and intended to mislead.',
    ),
    MockQuestion(
      id: 'p209-75', subject: MockSubject.english, question: 'In the sentence Ali and Ahmed went home, which word is the conjunction joining the two names?',
      options: ['Ali', 'And', 'Went', 'Home'], correctIndex: 1, topic: 'Grammar',
      explanation: 'And is the coordinating conjunction joining Ali and Ahmed.',
    ),
    MockQuestion(
      id: 'p209-76', subject: MockSubject.english, question: 'The proverb do not put all your eggs in one basket means what?',
      options: ['Do not rely on one choice', 'Carry eggs carefully', 'Buy many baskets', 'Keep eggs at home'], correctIndex: 0, topic: 'Idioms',
      explanation: 'Do not put all your eggs in one basket means do not risk everything on a single plan or choice.',
    ),
    MockQuestion(
      id: 'p209-77', subject: MockSubject.english, question: 'The word higgledy-piggledy means what?',
      options: ['In order', 'In disorder', 'In silence', 'In haste'], correctIndex: 1, topic: 'Vocabulary',
      explanation: 'Higgledy-piggledy means in a confused and disorderly manner.',
    ),
    MockQuestion(
      id: 'p209-78', subject: MockSubject.english, question: 'The word Alas, in the exclamation Alas! He is dead, belongs to which part of speech?',
      options: ['Noun', 'Verb', 'Interjection', 'Adverb'], correctIndex: 2, topic: 'Grammar',
      explanation: 'Alas is an interjection, a word expressing sudden feeling such as grief.',
    ),
    MockQuestion(
      id: 'p209-79', subject: MockSubject.english, question: 'The word beautiful, in the phrase a beautiful garden, is which part of speech?',
      options: ['Noun', 'Verb', 'Adjective', 'Adverb'], correctIndex: 2, topic: 'Grammar',
      explanation: 'Beautiful describes the noun garden, so it is an adjective.',
    ),
    MockQuestion(
      id: 'p209-80', subject: MockSubject.english, question: 'Choose the correct verb form: She ___ the baby every day.',
      options: ['Feed', 'Feeds', 'Feeding', 'Fed'], correctIndex: 1, topic: 'Grammar',
      explanation: 'With the third person singular subject she, the present simple verb takes an s, so she feeds the baby.',
    ),
    // Urdu (source questions 82 to 90; source question 81 was unreadable in the scan)
    MockQuestion(
      id: 'p209-81', subject: MockSubject.generalKnowledge, question: 'Urdu: Kleer ka faqeer hona ka matlab kya hai?',
      options: ['Ameer hona', 'Kheer khana', 'Mohtaj hona', 'None of these'], correctIndex: 3, topic: 'Urdu Idioms',
      explanation: 'Yeh sawal ghair tasdeeq shuda hai. Kleer ka faqeer hona aik ghair pehchani janay wali tarkeeb hai aur diye gaye maani mein se koi bhi durust nahi lagta.',
    ),
    MockQuestion(
      id: 'p209-82', subject: MockSubject.generalKnowledge, question: 'Urdu: Gali galoch aur bura bhala kehne wale ravayye ko kya kaha jata hai?',
      options: ['Bura bhala kehna', 'Izzat karna', 'Khamoshi', 'Dosti'], correctIndex: 0, topic: 'Urdu Idioms',
      explanation: 'Bura bhala kehna se murad hai kisi ko bura kehna aur gali galoch karna.',
    ),
    MockQuestion(
      id: 'p209-83', subject: MockSubject.generalKnowledge, question: 'Urdu: Har roz hone wale kaam ko kya kehte hain?',
      options: ['Rozmarra', 'Mahana', 'Salana', 'Haftawar'], correctIndex: 0, topic: 'Urdu Vocabulary',
      explanation: 'Rozmarra se murad hai har roz hone wala kaam ya rozana ki zindagi.',
    ),
    MockQuestion(
      id: 'p209-84', subject: MockSubject.generalKnowledge, question: 'Urdu: Jis jumlay mein hairat ya khushi ka izhar ho use kya kehte hain?',
      options: ['Fajaiya', 'Khabriya', 'Istifhamiya', 'Amriya'], correctIndex: 0, topic: 'Urdu Grammar',
      explanation: 'Fajaiya woh jumla hai jis mein hairat, khushi ya afsos ka izhar hota hai.',
    ),
    MockQuestion(
      id: 'p209-85', subject: MockSubject.generalKnowledge, question: 'Urdu: Mehnat aur waqt ko be faida guzar dene ko kya kehte hain?',
      options: ['Zaya karna', 'Bachana', 'Istamal karna', 'Bhool jana'], correctIndex: 0, topic: 'Urdu Vocabulary',
      explanation: 'Zaya karna ka matlab hai kisi cheez ko be faida guzar dena ya barbad karna.',
    ),
    MockQuestion(
      id: 'p209-86', subject: MockSubject.generalKnowledge, question: 'Urdu: Qaidiyon ko rakhne ki jagah ko kya kehte hain?',
      options: ['Qaid khane', 'Daftar', 'School', 'Hospital'], correctIndex: 0, topic: 'Urdu Vocabulary',
      explanation: 'Qaid khana woh jagah hai jahan qaidiyon ko rakha jata hai.',
    ),
    MockQuestion(
      id: 'p209-87', subject: MockSubject.generalKnowledge, question: 'Urdu: Aapas mein jhagra karne ko kya kehte hain?',
      options: ['Larai karna', 'Sulh karna', 'Dosti karna', 'Madad karna'], correctIndex: 0, topic: 'Urdu Vocabulary',
      explanation: 'Larai karna ka matlab hai aapas mein jhagra karna. Is sawal ka stem scan mein ghair wazeh hai, is liye yeh jawab ghair tasdeeq shuda hai.',
    ),
    MockQuestion(
      id: 'p209-88', subject: MockSubject.generalKnowledge, question: 'Urdu: Jumlay mein fiil ki madad karne wala lafz konsa hai: Us ne ghar bana rakha hai?',
      options: ['Rakha', 'Bana', 'Ghar', 'Ne'], correctIndex: 0, topic: 'Urdu Grammar',
      explanation: 'Is jumlay mein rakha imdadi fiil hai jo bana fiil ki madad karta hai.',
    ),
    MockQuestion(
      id: 'p209-89', subject: MockSubject.generalKnowledge, question: 'Urdu: Faqa karna ya bhook mein sabr karna ko kya kehte hain?',
      options: ['Bhook bardasht karna', 'Khana khana', 'Pani peena', 'Sona'], correctIndex: 0, topic: 'Urdu Vocabulary',
      explanation: 'Bhook bardasht karna ka matlab hai bhook ko sabr se bardasht karna.',
    ),
  ],
  latestUpdates: [
    'Latest update (late October 2026): Justice Yahya Afridi is still the Chief Justice of Pakistan. Justice Munib Akhtar took oath as Acting Chief Justice only during Justice Afridi\'s absences abroad in October 2026.',
    'Latest update (late October 2026): Judge Yuji Iwasawa is still the President of the International Court of Justice, with his term running until 5 February 2027.',
    'Latest update (late October 2026): Asim Iftikhar Ahmad is no longer the Permanent Representative of Pakistan to the United Nations. He became Foreign Secretary of Pakistan on 12 October 2026, and Syed Haider Shah was appointed as his successor, due to assume charge on 31 October 2026.',
  ],
);
