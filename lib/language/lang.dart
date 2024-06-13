import 'package:get/get.dart';

class LocaleString extends Translations {
  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'home': 'Home',
          'ongoing': 'OnGoing Trip',
          'trips': 'Trips',
          'reviews': 'Reviews',
          'coupons': 'Coupons',
          'wallet': 'Wallet',
          "notifications": "Notifications",
          'setting': 'Settings',
          'about': 'About Us',
          'share': 'Share',
          'ypuRi': 'Your Rides',
          'tick': 'Tickets',
          'help': 'Customer Support',
          'logout': 'Logout',

          //Setting
          'changelang': 'Change Language',
          'notialert': 'Notification Alert',
          'changepass': 'Change Password',
          'terms': 'Terms and Conditions',
          'privacy': 'Privacy Policy',
          'refund': 'Refund Policy',
          'visit': 'Visit Website',
          'general': "General Settings",
          'access': "Accessibility",
          'noda': "No Data",
          'legal': "Legal Section",
          'custcar': "Customer Care",

          //Notifications
          'noti': "No Notifications are available...",

          //Your Trips
          'yourtrip': "Your Trip's",
          'his': 'History',
          'upcoming': 'Upcoming Rides',
          'nouprides': "No upcoming rides are available...",
          'noonride': "No Ongoing rides are available...",
          'nohis': "No trip history available...",

          //No Wallet
          'nowallet': 'No data is available at the moment...',
          'razor': "Razor Pay",
          'wallbal': "Wallet Balance",
          'addmon': "Add Money",
          'wallethis': "Wallet History",

          //Driver Rating
          'nodriverrate': "No reviews available...",

          //Support
          'query': "Hello, OndeIndia I have a query.",
          'call': "Call",
          'whatsapp': "WhatsApp",

          //Main Screen
          'retal': "Rental",
          'outstation': "Outstation",

          //Rental Screen
          'searchdest': "Search your destination...",

          //Outstation Screen
          'selectpack': "Select Package",

          //Home Drop
          'dropLoc': "Where to go?",
          'pickLoc': "Select Pick up...",

          //Logout Alert
          'logA': "Are you sure?",
          'logDes': "You want to Logout!",
          'loLoa': "Logging you out...",
          'ok': "Ok",
          'cancel': "Cancel",

          //Change Alert
          "changeAle":
              "Please enter your old Password for verification and after that you can change your password...",
          'changeinfo':
              "*Note: If you can't remember your old password please logout and hit ",
          'changefor': "Forgot Password",
          'changeold': "Old Password",
          'changehint': "pass: 123456",
          'changeverify': "Verify Old Password",
          'chnageafTe':
              "Please Fill below fields to change your password...This step will change your current password for this app",
          'changenewnote':
              'Note:- We recommend you to logout nad relogin with new credential for better experience',
          'changenew': 'New Password',
          'changenewcon': 'Confirm New Password',
          'changepwd': 'Change Password',
        },
        'hi_IN': {
          'home': 'घर',
          'ongoing': 'चल रही यात्रा',
          'trips': 'ट्रिप्स',
          'reviews': 'समीक्षा',
          'coupons': 'कूपन',
          'wallet': 'बटुआ',
          "notifications": "सूचनाएं",
          'setting': 'समायोजन',
          'about': 'हमारे बारे में',
          'share': 'शेयर करना',
          'ypuRi': 'आपकी सवारी',
          'tick': 'टिकट',
          'help': 'ग्राहक सहेयता',
          'logout': 'लॉग आउट',

          //Setting
          'changelang': 'भाषा बदलो',
          'notialert': 'अधिसूचना चेतावनी',
          'changepass': 'पासवर्ड बदलें',
          'terms': 'नियम और शर्तें',
          'privacy': 'गोपनीयता नीति',
          'refund': 'भुगतान वापसी की नीति',
          'visit': 'वेबसाइट देखें',
          'general': "सामान्य सेटिंग्स",
          'access': "सरल उपयोग",
          'noda': "कोई डेटा नहीं",
          'legal': "कानूनी अनुभाग",
          'custcar': "ग्राहक देखभाल",

          //Notifications
          'noti': "कोई सूचना उपलब्ध नहीं है...",

          //Your Trips
          'yourtrip': 'आपकी यात्रा',
          'his': 'आपकी यात्रा का इतिहास',
          'upcoming': 'आपकी आने वाली सवारी',
          'nouprides': "कोई आगामी सवारी उपलब्ध नहीं है...",
          'noonride': "कोई चालू सवारी उपलब्ध नहीं है...",
          'nohis': "कोई यात्रा इतिहास उपलब्ध नहीं है...",

          //No Wallet
          'nowallet': 'इस समय कोई डेटा उपलब्ध नहीं है...',
          'razor': "रेजर पे",
          'wallbal': "वॉलेट बैलेंस",
          'addmon': "पैसे जोड़ें",
          'wallethis': "वॉलेट इतिहास",

          //Driver Rating
          'nodriverrate': "कोई समीक्षा उपलब्ध नहीं है...",

          //Support
          'query': "हैलो, ओन्डेइंडिया मेरा एक प्रश्न है।",
          'call': "फ़ोन कॉल",
          'whatsapp': "व्हाट्स एप",

          //Main Screen
          'retal': "किराये पर लेना",
          'outstation': "आउटस्टेशन",

          //Rental Screen
          'searchdest': "अपनी मंजिल खोजें...",

          //Outstation Screen
          'selectpack': "पैकेज का चयन करें",

          //Home Drop
          'dropLoc': "आप कहाँ जाना चाहते हैं?",
          'pickLoc': "पिक अप चुनें...",

          //Logout Alert
          'logA': "क्या आपको यकीन है?",
          'logDes': "आप लॉगआउट करना चाहते हैं!",
          'loLoa': "आपको लॉग आउट कर रहा है...",
          'ok': "ठीक",
          'cancel': "रद्द करना",

          //Change Alert
          "changeAle":
              "कृपया सत्यापन के लिए अपना पुराना पासवर्ड दर्ज करें और उसके बाद आप अपना पासवर्ड बदल सकते हैं...",
          'changeinfo':
              "*नोट: यदि आपको अपना पुराना पासवर्ड याद नहीं है तो कृपया लॉगआउट करें और हिट करें",
          'changefor': "पासवर्ड भूल गए",
          'changeold': "पुराना पासवर्ड",
          'changehint': "पास: 123456",
          'changeverify': "पुराना पासवर्ड सत्यापित करें",
          'chnageafTe':
              "अपना पासवर्ड बदलने के लिए कृपया नीचे दिए गए फ़ील्ड भरें... यह चरण इस ऐप के लिए आपके वर्तमान पासवर्ड को बदल देगा",
          'changenewnote':
              'नोट:- हम आपको बेहतर अनुभव के लिए नए क्रेडेंशियल के साथ लॉग आउट करने की सलाह देते हैं',
          'changenew': 'नया पासवर्ड',
          'changenewcon': 'नए पासवर्ड की पुष्टि करें',
          'changepwd': 'पासवर्ड बदलें',
        },
        'tl_IN': {
          'home': 'హోమ్',
          'ongoing': 'కొనసాగుతున్న యాత్ర',
          'trips': 'ప్రయాణాలు',
          'reviews': 'సమీక్షలు',
          'coupons': 'కూపన్లు',
          'wallet': 'వాలెట్',
          "notifications": "నోటిఫికేషన్‌లు",
          'setting': 'సెట్టింగ్‌లు',
          'about': 'మా గురించి',
          'share': 'షేర్ చేయండి',
          'ypuRi': 'మీ రైడ్స్',
          'tick': 'టిక్కెట్లు',
          'help': 'వినియోగదారుని మద్దతు',
          'logout': 'లాగ్అవుట్',

          //Setting
          'changelang': 'భాష మార్చు',
          'notialert': 'నోటిఫికేషన్ హెచ్చరిక',
          'changepass': 'పాస్‌వర్డ్ మార్చండి',
          'terms': 'నిబంధనలు మరియు షరతులు',
          'privacy': 'గోప్యతా విధానం',
          'refund': 'వాపసు విధానం',
          'visit': 'వెబ్‌సైట్‌ను వీక్షించండి',
          'general': "సాధారణ సెట్టింగులు",
          'access': "సౌలభ్యాన్ని",
          'noda': "సమాచారం లేదు",
          'legal': "చట్టపరమైన విభాగం",
          'custcar': "వినియోగదారుల సహాయ కేంద్రం",

          //Notifications
          'noti': "నోటిఫికేషన్‌లు ఏవీ అందుబాటులో లేవు...",

          //Your Trips
          'yourtrip': 'మీ యాత్ర',
          'his': 'పర్యటనల చరిత్ర',
          'upcoming': 'మీ రాబోయే రైడ్‌లు',
          'nouprides': "రాబోయే రైడ్‌లు ఏవీ అందుబాటులో లేవు...",
          'noonride': "కొనసాగుతున్న రైడ్‌లు ఏవీ అందుబాటులో లేవు...",
          'nohis': "పర్యటన చరిత్ర అందుబాటులో లేదు...",

          //No Wallet
          'nowallet': 'ప్రస్తుతం డేటా అందుబాటులో లేదు...',
          'razor': "రేజర్ పే",
          'wallbal': "వాలెట్ బ్యాలెన్స్",
          'addmon': "డబ్బు జోడించండి",
          'wallethis': "వాలెట్ చరిత్ర",

          //Driver Rating
          'nodriverrate': "సమీక్షలు ఏవీ అందుబాటులో లేవు...",

          //Support
          'query': "హలో, ఒండేఇండియా నాకు ఒక ప్రశ్న ఉంది.",
          'call': "ఫోన్ కాల్",
          'whatsapp': "వాట్స్ యాప్",

          //Main Screen
          'retal': "అద్దె",
          'outstation': "అవుట్‌స్టేషన్",

          //Rental Screen
          'searchdest': "మీ గమ్యాన్ని శోధించండి...",

          //Outstation Screen
          'selectpack': "ప్యాకేజీని ఎంచుకోండి",

          //Home Drop
          'dropLoc': "మీరు ఎక్కడికి వెళ్లాలి?",
          'pickLoc': "పికప్ ఎంచుకోండి...",

          //Logout Alert
          'logA': "మీరు చెప్పేది నిజమా?",
          'logDes': "మీరు లాగ్ అవుట్ చేయాలనుకుంటున్నారు!",
          'loLoa': "మిమ్మల్ని లాగ్ అవుట్ చేస్తున్నాను...",
          'ok': "అలాగే",
          'cancel': "రద్దు చేయండి",

          //Change Alert
          "changeAle":
              "దయచేసి ధృవీకరణ కోసం మీ పాత పాస్‌వర్డ్‌ని నమోదు చేయండి మరియు ఆ తర్వాత మీరు మీ పాస్‌వర్డ్‌ని మార్చవచ్చు...",
          'changeinfo':
              "*గమనిక: మీకు మీ పాత పాస్‌వర్డ్ గుర్తులేకపోతే లాగ్ అవుట్ చేసి నొక్కండి",
          'changefor': "పాస్‌వర్డ్ మర్చిపోయాను",
          'changeold': "పాత పాస్‌వర్డ్",
          'changehint': "పాస్: 123456",
          'changeverify': "పాత పాస్‌వర్డ్‌ను ధృవీకరించండి",
          'chnageafTe':
              "దయచేసి మీ పాస్‌వర్డ్‌ని మార్చడానికి దిగువ ఫీల్డ్‌లను పూరించండి...ఈ దశ ఈ యాప్ కోసం మీ ప్రస్తుత పాస్‌వర్డ్‌ని మారుస్తుంది",
          'changenewnote':
              'గమనిక:- మెరుగైన అనుభవం కోసం కొత్త క్రెడెన్షియల్‌తో మళ్లీ లాగిన్ అవ్వమని మేము మీకు సిఫార్సు చేస్తున్నాము',
          'changenew': 'కొత్త పాస్వర్డ్',
          'changenewcon': 'కొత్త పాస్‌వర్డ్‌ని నిర్ధారించండి',
          'changepwd': 'పాస్‌వర్డ్ మార్చండి',
        }
      };
}
