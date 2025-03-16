import 'package:competitivecodingarena/Core_Project/Community/search_screen.dart';

(List<Institution>, List<Region>) initializeData() {
  final List<Institution> institutions = [
    Institution(
      id: 'inst1',
      name: 'Indian Institute of Technology Bombay',
      type: 'University',
      description: 'Premier engineering institute in India',
      tags: ['Research', 'Engineering', 'Technology'],
    ),
    Institution(
      id: 'inst2',
      name: 'Tata Consultancy Services',
      type: 'Company',
      description: 'Global IT services and consulting company',
      tags: ['Technology', 'Software', 'IT Services'],
    ),
    Institution(
      id: 'inst3',
      name: 'Indian Institute of Science',
      type: 'University',
      description: 'Top research institution for science and engineering',
      tags: ['Research', 'Science', 'Engineering'],
    ),
    Institution(
      id: 'inst4',
      name: 'All India Institute of Medical Sciences',
      type: 'University',
      description: 'Leading medical research and education institute',
      tags: ['Medical', 'Research', 'Healthcare'],
    ),
    Institution(
      id: 'inst5',
      name: 'Infosys',
      type: 'Company',
      description: 'Multinational IT services and consulting company',
      tags: ['Technology', 'Software', 'Cloud'],
    ),
    Institution(
      id: 'inst6',
      name: 'Indian Institute of Technology Delhi',
      type: 'University',
      description: 'One of India’s top engineering institutes',
      tags: ['Engineering', 'Technology', 'Research'],
    ),
    Institution(
      id: 'inst7',
      name: 'Wipro',
      type: 'Company',
      description: 'IT services and consulting corporation',
      tags: ['Technology', 'Software', 'IT Services'],
    ),
    Institution(
      id: 'inst8',
      name: 'National Institute of Technology Trichy',
      type: 'University',
      description: 'Top engineering institute in India',
      tags: ['Engineering', 'Research', 'Technology'],
    ),
    Institution(
      id: 'inst9',
      name: 'HCL Technologies',
      type: 'Company',
      description: 'Global IT services and software company',
      tags: ['Technology', 'Software', 'Consulting'],
    ),
    Institution(
      id: 'inst10',
      name: 'Indian Statistical Institute',
      type: 'University',
      description: 'Institute focused on statistics and data sciences',
      tags: ['Statistics', 'Mathematics', 'Research'],
    ),
    Institution(
      id: 'inst11',
      name: 'Birla Institute of Technology and Science Pilani',
      type: 'University',
      description: 'Premier private engineering and research institute',
      tags: ['Engineering', 'Research', 'Technology'],
    ),
    Institution(
      id: 'inst12',
      name: 'Reliance Industries',
      type: 'Company',
      description: 'Conglomerate with interests in telecom, energy, and retail',
      tags: ['Business', 'Technology', 'Energy'],
    ),
    Institution(
      id: 'inst13',
      name: 'Indian Institute of Management Ahmedabad',
      type: 'University',
      description: 'India’s top business and management school',
      tags: ['Management', 'Business', 'Finance'],
    ),
    Institution(
      id: 'inst14',
      name: 'Vellore Institute of Technology',
      type: 'University',
      description: 'Private university known for technology and research',
      tags: ['Engineering', 'Research', 'Technology'],
    ),
    Institution(
      id: 'inst15',
      name: 'Mahindra & Mahindra',
      type: 'Company',
      description: 'Automobile and technology corporation',
      tags: ['Automobile', 'Technology', 'Manufacturing'],
    ),
    Institution(
      id: 'inst16',
      name: 'Indian Institute of Technology Kharagpur',
      type: 'University',
      description:
          'First IIT established in India, known for engineering and research',
      tags: ['Engineering', 'Research', 'Technology'],
    ),
    Institution(
      id: 'inst17',
      name: 'Indian Space Research Organisation',
      type: 'Company',
      description:
          'Government space agency responsible for India’s space exploration',
      tags: ['Aerospace', 'Research', 'Technology'],
    ),
    Institution(
      id: 'inst18',
      name: 'Ashoka University',
      type: 'University',
      description: 'Private liberal arts university with focus on research',
      tags: ['Liberal Arts', 'Research', 'Education'],
    ),
    Institution(
      id: 'inst19',
      name: 'Amazon India',
      type: 'Company',
      description:
          'E-commerce and cloud services giant with major operations in India',
      tags: ['E-commerce', 'Cloud', 'Technology'],
    ),
    Institution(
      id: 'inst20',
      name: 'Indian Institute of Technology Madras',
      type: 'University',
      description:
          'Top IIT known for innovation, research, and entrepreneurship',
      tags: ['Engineering', 'Research', 'Entrepreneurship'],
    ),
    Institution(
      id: 'inst21',
      name: 'Thadomal Shahani Engineering College',
      type: 'University',
      description:
          'One of Mumbai’s top private engineering colleges, known for technology and innovation',
      tags: ['Engineering', 'Technology', 'Education'],
    ),
  ];

  final List<Region> regions = [
    Region(
      id: 'reg1',
      name: 'Mumbai Region',
      subregions: ['Mumbai, Maharashtra', 'Pune, Maharashtra'],
      institutions: institutions
          .where((i) =>
              i.id == 'inst1' || // IIT Bombay
              i.id == 'inst12' || // Reliance Industries
              i.id == 'inst21')
          .toList(),
    ),
    Region(
      id: 'reg2',
      name: 'Bangalore Region',
      subregions: ['Bangalore, Karnataka'],
      institutions: institutions
          .where((i) =>
                  i.id == 'inst3' || // IISc Bangalore
                  i.id == 'inst5' || // Infosys
                  i.id == 'inst7' // Wipro
              )
          .toList(),
    ),
    Region(
      id: 'reg3',
      name: 'Delhi NCR Region',
      subregions: ['New Delhi', 'Gurgaon', 'Noida'],
      institutions: institutions
          .where((i) =>
                  i.id == 'inst4' || // AIIMS Delhi
                  i.id == 'inst6' || // IIT Delhi
                  i.id == 'inst9' // HCL Technologies (Noida)
              )
          .toList(),
    ),
    Region(
      id: 'reg4',
      name: 'Chennai Region',
      subregions: ['Chennai, Tamil Nadu'],
      institutions: institutions
          .where((i) =>
                  i.id == 'inst8' || // NIT Trichy
                  i.id == 'inst14' // VIT Vellore
              )
          .toList(),
    ),
    Region(
      id: 'reg5',
      name: 'Kolkata Region',
      subregions: ['Kolkata, West Bengal'],
      institutions: institutions
          .where((i) =>
                  i.id == 'inst10' || // Indian Statistical Institute
                  i.id == 'inst16' // IIT Kharagpur
              )
          .toList(),
    ),
    Region(
      id: 'reg6',
      name: 'Ahmedabad Region',
      subregions: ['Ahmedabad, Gujarat'],
      institutions: institutions
          .where((i) => i.id == 'inst13' // IIM Ahmedabad
              )
          .toList(),
    ),
    Region(
      id: 'reg7',
      name: 'Pilani Region',
      subregions: ['Pilani, Rajasthan'],
      institutions: institutions
          .where((i) => i.id == 'inst11' // BITS Pilani
              )
          .toList(),
    ),
    Region(
      id: 'reg8',
      name: 'Hyderabad Region',
      subregions: ['Hyderabad, Telangana'],
      institutions: institutions
          .where((i) => i.id == 'inst17' // ISRO
              )
          .toList(),
    ),
    Region(
      id: 'reg9',
      name: 'Pan India',
      subregions: ['Multiple Locations'],
      institutions: institutions
          .where((i) =>
                  i.id == 'inst2' || // TCS
                  i.id == 'inst15' // Mahindra & Mahindra
              )
          .toList(),
    ),
    Region(
      id: 'reg10',
      name: 'E-commerce Hubs',
      subregions: ['Bangalore', 'Hyderabad', 'Mumbai'],
      institutions: institutions
          .where((i) => i.id == 'inst19' // Amazon India
              )
          .toList(),
    ),
  ];
  return (institutions, regions);
}
