import 'package:pinky_eye/model/disease_model.dart';

class Constants {
  static double screenHeight = 0.0;
  static double screenWidth = 0.0;

  static int currentDrawerItem = 11;

  static int VERSION_UPDATE = 0;

  static const String SUBSCRIPTION_PAY_AND_USE =
      'com.data245.pinkyeye.app.payanduse';
  static const String SUBSCRIPTION_YEARLY = 'com.data245.pinkyeye.app.yearly';

  static const String APP_NAME = 'Pinky Eye';
  static const String IMAGE_UPLOAD_URL =
      'https://pink-eye-detection-4zwp.onrender.com/';
  static const String HOME_PAGE_TITLE = 'Pinky Eye - Home';
  static const String WELCOME_TEXT = 'Welcome To';
  static const String BY_DATA = 'by data245';
  static const String DETECT_TEXT =
      'Pinky detects pink eye (Conjunctivitis) in humans using AI.';
  static const String WHAT_IS_PINKY = 'What is Pinky Eye?';
  static const String PLEASE_LOGIN_SIGN_UP_TEXT =
      'Please login or signup to \nuse our app.';
  static const String LOGIN = 'Login';
  static const String LOGIN_NOW = 'Login Now';
  static const String SUBSCRIPTION_PLANS = 'Subscription Plans';
  static const String CHOOSE_PLAN = 'Choose your plan for your pro app.';
  static const String SIGN_UP = 'Sign Up';
  static const String FORGOT_PASSWORD = 'Forgot Password';
  static const String FORGOT_PASSWORD_HINT =
      'Please enter the email you use to login with. We will send you an email with link to reset your password.';
  static const String EMAIL_ADDRESS = 'Email Address';
  static const String PASSWORD = 'Password';
  static const String CURRENT_PASSWORD = 'Current Password';
  static const String NEW_PASSWORD = 'New Password';
  static const String CONFIRM_PASSWORD = 'Confirm New Password';
  static const String FULL_NAME = 'Full Name';
  static const String FIRST_NAME = 'First Name';
  static const String LAST_NAME = 'Last Name';
  static const String ZIP_CODE = 'Zip';
  static const String DOB = 'D.O.B';
  static const String RELATION = 'Relation';
  static const String FORGOT = 'Forgot?  ';
  static const String LOGIN_WITH = 'Or login with';
  static const String NO_ACCOUNT = 'Don\'t have an account? ';
  static const String ALREADY_ACCOUNT = 'Already have an account? ';
  static const String PLEASE_LOGIN_TEXT =
      'Please login to continue using\nour app.';
  static const String PLEASE_SIGN_UP_TEXT = 'Please signup to enter our app.';
  static const String AGREE_TEXT = 'I agree with the ';
  static const String LOCATION_AGREE = 'I agree to provide my current location';
  static const String T_AND_C = 'T & C | Legal Disclaimer';
  static const String CURRENT_LOCATION = 'Current Location';
  static const String TERMS = 'Terms And Conditions';

//  static const String TERMS = 'Terms & Conditions for data245, LLC';
  static const String LEGAL_DISCLAIMER = 'Legal Disclaimer';
//  static const String DETECT_DESC =
//      'Crossed eye, Vision loss, Lazy eye, Eye disorder, conjunctivitis by just taking a photo of that affected eyes area.';
  static const String DETECT_DESC =
      'Pinky, detects pink eye (Conjunctivitis) in humans using AI.';
  static const String HINT_TAKE_PICTURE =
      'Okay, let\'s take a picture of your eye.';
  static const String TAKE_PICTURE = 'Eye Analyze';
  static const String NO_HISTORY = 'No history record';
  static const String SAVE_REPORT = 'Save Report';
  static const String COMMON_CAUSES = 'Common Causes';
  static const String COMMON_SYMPTOMS = 'Common Symptoms';
  static const String DESCRIPTION = 'Description';
  static const String CAUSE_OF_ACTION = 'Cause of Actions';
  static const String RISK_FACTOR = 'Risk Factor:';
  static const String LIKELIHOOD = 'Disease likelihood';
  static const String MEDICAL_STORE_NEAR = 'Medical Providers near you';
  static const String RETAKE = 'Retake';
  static const String SUBMIT = 'Submit';
  static const String REPORT_FOR = 'Whose image is this? ';
  static const String CHANGE_PASS_HINT =
      'Please enter the new password to reset your password';
  static const String REPORT_AND_ANALYSIS = 'Report & Analysis';
  static const String ANALYSIS = 'Analysis';
  static const String UPDATE_PROFILE = 'Update Profile';
  static const String CHANGE_PASSWORD = 'Change Password';
  static const String ADD_DEPENDENCY = 'Add a Dependent';
  static const String VIEW_DEPENDENCY = 'View Dependent';
  static const String AboutUs = 'About Us';
  static const String Profile = 'Profile';
  static const String Logout = 'Logout';
  static const String IS_PINKY_EYE_LOGIN = 'IsPinkyEyeLogin';
  static const String IS_PINKY_SOCIAL_LOGIN = 'IsPinkySocialLogin';
  static const String LOGGED_IN_USER_ID = 'loggedInUserId';
  static const String USER_FULLNAME = 'fullname';
  static const String DEPENDENTS = 'Dependents';
  static const String ABOUT_US_DATA =
      'Pinky detects pink eye (Conjunctivitis) in humans using AI.\n\nPink eye, also known as Conjunctivitis, is the inflammation and irritation of the conjunctiva, which covers the white part of the eyeball. With more than 5 million U.S cases each year, pink eye can be caused by allergies, or a bacterial or viral infection. The latter is extremely contagious. Symptoms include redness, itching, tearing, and discharge.\n\n'
      'Our app, Pinky, is able to detect the cause of your Conjunctivitis, and even differentiate between bacterial/viral infections and allergic reactions. With Machine Learning and symptom consideration, Pinky is 96% accurate. Doctors are only 80% accurate because they usually don\'t test a swab upon your bout\'s initial clinic visit.\n\nAfter the user submits an image of the affected eye to the app, our autonomous system compares it to hundreds of thousands of confirmed cases and identifies the image accordingly. Machine Learning technology picks out very small details that human eyes miss. This is how our app can detect if a bacterial/viral infection is present versus an allergen, and visa versa.';
  static bool IS_DELETED = false;
  static bool IS_BACK = false;

  static List<Diseases> diseaseList;

  static const String LINKED_IN_REDIRECT_URL = 'https://www.data245.com/';
  static const String LINKED_IN_CLIENT_ID = '813ybwgno886ic';
  static const String LINKED_IN_CLIENT_SECRET = 'nNPCYxsBfzmXQ2It';

  static const String UPDATE_DEPENDENCY = 'Update Dependent';
  static const String PLACE_API_KEY = 'AIzaSyBkGJc5LZe19WPHCaLjdeCXq_gYquzaiPM';
  static const String PLACE_GET_PHONE_API =
      'https://maps.googleapis.com/maps/api/place/details/json';
  static const String PLACE_SEARCH_API =
      'https://maps.googleapis.com/maps/api/place/nearbysearch/json';

//  static const String PLACE_SEARCH_API = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=21.2408,72.8806&radius=500&type=pharmacy&key=AIzaSyBkGJc5LZe19WPHCaLjdeCXq_gYquzaiPM&fields =name,rating,formatted_phone_number';

  static double latitude = 0.0;
  static double longitude = 0.0;
  static String terms_cond1 = "Introduction";
  static String terms_cond2 =
      "These Website/application Standard Terms and Conditions written on this webpage shall manage your use of our website, Data245 accessible at www.data245.com.";
  static String terms_cond3 =
      "These Terms will be applied fully and affect to your use of this Application. By using this Website, you agreed to accept all terms and conditions written in here. You must not use this Website if you disagree with any of these Website Standard Terms and Conditions.";
  static String terms_cond4 =
      "Minors or people below 18 years old are not allowed to use this Website.";
  static String terms_cond5 = "Intellectual Property Rights";
  static String terms_cond6 =
      "Other than the content you own, under these Terms, data245 and/or its licensors own all the intellectual property rights and materials contained in this Website. \n\nYou are granted limited license only for purposes of viewing the material contained on this Website.";
  static String terms_cond7 = "Restrictions";
  static String terms_cond8 =
      "You are specifically restricted from all of the following:";
  static String terms_cond8_1 =
      "• publishing any Website material in any other media;\n• selling, sublicensing and/or otherwise commercializing any Website material;\n• publicly performing and/or showing any Website material;\n• using this Website in any way that is or may be damaging to this Website;\n• using this Website in any way that impacts user access to this Website;\n• using this Website contrary to applicable laws and regulations, or in any way may cause harm to the Website, or to any person or business entity;\n• engaging in any data mining, data harvesting, data extracting or any other similar activity in relation to this Website;\n• using this Website to engage in any advertising or marketing.";
  static String terms_cond9 =
      "Certain areas of this Website are restricted from being access by you and data245 may further restrict access by you to any areas of this Website, at any time, in absolute discretion. Any user ID and password you may have for this Website are confidential and you must maintain confidentiality as well.";
  static String terms_cond10 = "Your Content";
  static String terms_cond11 =
      "In these Website Standard Terms and Conditions, \"Your Content\" shall mean any audio, video text, images or other material you choose to display on this Website. By displaying Your Content, you grant data245 a non-exclusive, worldwide irrevocable, sub licensable license to use, reproduce, adapt, publish, translate and distribute it in any and all media.";
  static String terms_cond12 =
      "Your Content must be your own and must not be invading any third-party’s rights. data245 reserves the right to remove any of Your Content from this Website at any time without notice.";
  static String terms_cond13 = "Your Privacy";
  static String terms_cond14 = "Please read Privacy Policy.";
  static String terms_cond15 = "No warranties";
  static String terms_cond16 =
      "This Website is provided \"as is,\" with all faults, and data245 express no representations or warranties, of any kind related to this Website or the materials contained on this Website. Also, nothing contained on this Website shall be interpreted as advising you.";
  static String terms_cond17 = "Limitation of liability";
  static String terms_cond18 =
      "In no event shall data245, nor any of its officers, directors and employees, shall be held liable for anything arising out of or in any way connected with your use of this Website whether such liability is under contract.  data245, including its officers, directors and employees shall not be held liable for any indirect, consequential or special liability arising out of or in any way related to your use of this Website.";
  static String terms_cond19 = "Indemnification";
  static String terms_cond20 =
      "You hereby indemnify to the fullest extent data245 from and against any and/or all liabilities, costs, demands, causes of action, damages and expenses arising in any way related to your breach of any of the provisions of these Terms.";
  static String terms_cond21 = "Severability";
  static String terms_cond22 =
      "If any provision of these Terms is found to be invalid under any applicable law, such provisions shall be deleted without affecting the remaining provisions herein.";
  static String terms_cond23 = "Variation of Terms";
  static String terms_cond24 =
      "data245 is permitted to revise these Terms at any time as it sees fit, and by using this Website you are expected to review these Terms on a regular basis.";
  static String terms_cond25 = "Assignment";
  static String terms_cond26 =
      "The data245 is allowed to assign, transfer, and subcontract its rights and/or obligations under these Terms without any notification. However, you are not allowed to assign, transfer, or subcontract any of your rights and/or obligations under these Terms.";
  static String terms_cond27 = "Entire Agreement";
  static String terms_cond28 =
      "These Terms constitute the entire agreement between data245 and you in relation to your use of this Website, and supersede all prior agreements and understandings.";
  static String terms_cond29 = "Governing Law & Jurisdiction";
  static String terms_cond30 =
      "These Terms will be governed by and interpreted in accordance with the laws of the State of us, and you submit to the non-exclusive jurisdiction of the state and federal courts located in us for the resolution of any disputes.";

  //Medical
  static String terms_cond31 = "Medical disclaimer";
  static String terms_cond32 = "1. No Advice";
  static String terms_cond33 =
      "1.1 Our App/Website contains general medical information.\n1.2 The medical information is not advice and should not be treated as such.";
  static String terms_cond34 = "2. No warranties";
  static String terms_cond35 =
      "2.1 The medical information on our website is provided without any representations or warranties, express or implied.\n\n2.2 Without limiting the scope of Section 2.1, we do not warrant or represent that the medical information on this website:\n";
  static String terms_cond36 =
      "2.2.1 will be constantly available, or available at all; or\n2.2.2 is true, accurate, complete, current or non-misleading";
  static String terms_cond37 = "3. Medical Assistance";
  static String terms_cond38 =
      "3.1 You must not rely on the information on our website as an alternative to medical advice from your doctor or other professional healthcare provider.\n3.2 If you have any specific questions about any medical matter, you should consult your doctor or other professional healthcare provider.\n 3.3 If you think you may be suffering from any medical condition, you should seek immediate medical attention.\n 3.4 You should never delay seeking medical advice, disregard medical advice or discontinue medical treatment because of information on our website.";
  static String terms_cond39 = "4. Interactive Features";
  static String terms_cond40 =
      "4.1 Our app/website includes interactive features that allow users to communicate with us.\n4.2 You acknowledge that, because of the limited nature of communication through our website's interactive features, any assistance you may receive using any such features is likely to be incomplete and even be misleading.\n4.3 Any assistance you may receive using any our app's/webite's interactive feature does not constitute specific advice and accordingly should not be relied upon without further independent confirmation.";
  static String terms_cond41 = "5. Limits upon exclusions of liability";
  static String terms_cond42 = "5.1 Nothing in this disclaimer will:";
  static String terms_cond43 =
      "5.1.1 limit or exclude any liability for death or personal injury resulting from negligence;\n5.1.2 limit or exclude any liability for fraud or fraudulent misrepresentation;\n5.1.3 limit any liabilities in any way that is not premitted under applicable law; or\n5.1.4 exclude any liabilities that may not be exluded under applicable law.";
  static String terms_cond44 =
      "Last updated January 01, 2020 \n\nThank you for choosing to be part of our community at data245 (“Company”, “we”, “us”, or “our”). We are committed to protecting your personal information and your right to privacy. If you have any questions or concerns about our policy , or our practices with regards to your personal information, please contact us at info@data245.com.\n\nWhen you visit our mobile application, and use our services, you trust us with your personal information. We take your privacy very seriously. In this privacy policy, we seek to explain to you in the clearest way possible what information we collect, how we use it and what rights you have in relation to it. We hope you take some time to read through it carefully, as it is important. If there are any terms in this privacy policy that you do not agree with, please discontinue use of our Apps and our services.\n\nThis privacy policy applies to all information collected through our mobile application, (\"Apps\"), and/or any related services, sales, marketing or events (we refer to them collectively in this privacy policy as the \"Services\").\n\nPlease read this privacy policy carefully as it will help you make informed decisions about sharing your personal information with us.";

  //1
  static String terms_cond45 = "1. WHAT INFORMATION DO WE COLLECT?";
  static String terms_cond46 = "Personal information you disclose to us";
  static String terms_cond47 =
      "In Short: We collect personal information that you provide to us such as name, address, contact information, passwords and security data, payment information, and social media login data.";
  static String terms_cond48 =
      "We collect personal information that you voluntarily provide to us when registering at the Apps, expressing an interest in obtaining information about us or our products and services, when participating in activities on the Apps or otherwise contacting us.\n\nThe personal information that we collect depends on the context of your interactions with us and the Apps, the choices you make and the products and features you use. The personal information we collect can include the following:\n\nPublicly Available Personal Information. We collect first name, maiden name, last name, and nickname; current and former address; phone numbers; email addresses; birth, marriage, divorce, and death records; business entity filings, corporate affiliations, and business associates; family member names and their related information; and other similar data.\n\nPersonal Information Provided by You. We collect data about health, DNA, medical records, FitBit, and similar apps; app usage; data collected from surveys; and other similar data.\n\nCredentials. We collect passwords, password hints, and similar security information used for authentication and account access.\n\nSocial Media Login Data. We provide you with the option to register using social media account details, like your Facebook, Twitter or other social media account. If you choose to register in this way, we will collect the Information described in the section called \"HOW DO WE HANDLE YOUR SOCIAL LOGINS\" below.\n\nAll personal information that you provide to us must be true, complete and accurate, and you must notify us of any changes to such personal information.";

  static String terms_cond49 = "Information automatically collected";
  static String terms_cond50 =
      "In Short: Some information – such as IP address and/or browser and device characteristics – is collected automatically when you visit our Apps.";
  static String terms_cond51 =
      "We automatically collect certain information when you visit, use or navigate the Apps. This information does not reveal your specific identity (like your name or contact information) but may include device and usage information, such as your IP address, browser and device characteristics, operating system, language preferences, referring URLs, device name, country, location, information about how and when you use our Apps and other technical information. This information is primarily needed to maintain the security and operation of our Apps, and for our internal analytics and reporting purposes.\n\nLike many businesses, we also collect information through cookies and similar technologies.\n\nOnline Identifiers. We collect device's geolocation; and other similar data.";

  static String terms_cond52 = "Information collected through our Apps";
  static String terms_cond53 =
      "In Short:  We may collect information regarding your geo-location, mobile device, push notifications, when you use our apps.";
  static String terms_cond54 =
      "If you use our Apps, we may also collect the following information:";
  static String terms_cond55 =
      "• Geo-Location Information. We may request access or permission to and track location-based information from your mobile device, either continuously or while you are using our mobile application, to provide location-based services. If you wish to change our access or permissions, you may do so in your device’s settings.\n\n• Mobile Device Access. We may request access or permission to certain features from your mobile device, including your mobile device’s camera, storage, and other features. If you wish to change our access or permissions, you may do so in your device’s settings.\n\n• Push Notifications. We may request to send you push notifications regarding your account or the mobile application. If you wish to opt-out from receiving these types of communications, you may turn them off in your device’s settings.";

  //2
  static String terms_cond56 = "2. HOW DO WE USE YOUR INFORMATION?";
  static String terms_cond57 =
      "In Short:  We process your information for purposes based on legitimate business interests, the fulfillment of our contract with you, compliance with our legal obligations, and/or your consent.";
  static String terms_cond58 =
      "We use personal information collected via our Apps for a variety of business purposes described below. We process your personal information for these purposes in reliance on our legitimate business interests, in order to enter into or perform a contract with you, with your consent, and/or for compliance with our legal obligations. We indicate the specific processing grounds we rely on next to each purpose listed below.\n\nWe use the information we collect or receive:";
  static String terms_cond59 =
      "• To send you marketing and promotional communications. We and/or our third party marketing partners may use the personal information you send to us for our marketing purposes, if this is in accordance with your marketing preferences. You can opt-out of our marketing emails at any time (see the \"WHAT ARE YOUR PRIVACY RIGHTS\" below).\n\n• Deliver targeted advertising to you. We may use your information to develop and display content and advertising (and work with third parties who do so) tailored to your interests and/or location and to measure its effectiveness.\n\n• Request Feedback. We may use your information to request feedback and to contact you about your use of our Apps.\n\n• To enforce our terms, conditions and policies for Business Purposes, Legal Reasons and Contractual.\n\n• To respond to legal requests and prevent harm. If we receive a subpoena or other legal request, we may need to inspect the data we hold to determine how to respond.\n\n• To manage user accounts. We may use your information for the purposes of managing our account and keeping it in working order.\n\n• To deliver services to the user. We may use your information to provide you with the requested service.\n\n• To respond to user inquiries/offer support to users.  We may use your information to respond to your inquiries and solve any potential issues you might have with the use of our Services.\n\n• For other Business Purposes. We may use your information for other Business Purposes, such as data analysis, identifying usage trends, determining the effectiveness of our promotional campaigns and to evaluate and improve our Apps, products, marketing and your experience. We may use and store this information in aggregated and anonymized form so that it is not associated with individual end users and does not include personal information. We will not use identifiable personal information without your consent.";

  //3
  static String terms_cond60 =
      "3. WILL YOUR INFORMATION BE SHARED WITH ANYONE?";
  static String terms_cond61 =
      "In Short:  We only share information with your consent, to comply with laws, to provide you with services, to protect your rights, or to fulfill business obligations.";
  static String terms_cond62 =
      "We may process or share data based on the following legal basis:";
  static String terms_cond63 =
      "• Consent: We may process your data if you have given us specific consent to use your personal information in a specific purpose.\n\n• Legitimate Interests: We may process your data when it is reasonably necessary to achieve our legitimate business interests.\n\n• Performance of a Contract: Where we have entered into a contract with you, we may process your personal information to fulfill the terms of our contract.\n\n• Legal Obligations: We may disclose your information where we are legally required to do so in order to comply with applicable law, governmental requests, a judicial proceeding, court order, or legal process, such as in response to a court order or a subpoena (including in response to public authorities to meet national security or law enforcement requirements).\n\n• Vital Interests: We may disclose your information where we believe it is necessary to investigate, prevent, or take action regarding potential violations of our policies, suspected fraud, situations involving potential threats to the safety of any person and illegal activities, or as evidence in litigation in which we are involved.";
  static String terms_cond64 =
      "More specifically, we may need to process your data or share your personal information in the following situations:";
  static String terms_cond65 =
      "• Vendors, Consultants and Other Third-Party Service Providers. We may share your data with third party vendors, service providers, contractors or agents who perform services for us or on our behalf and require access to such information to do that work. Examples include: payment processing, data analysis, email delivery, hosting services, customer service and marketing efforts. We may allow selected third parties to use tracking technology on the Apps, which will enable them to collect data about how you interact with the Apps over time. This information may be used to, among other things, analyze and track data, determine the popularity of certain content and better understand online activity. Unless described in this Policy, we do not share, sell, rent or trade any of your information with third parties for their promotional purposes.\n\n• Business Transfers. We may share or transfer your information in connection with, or during negotiations of, any merger, sale of company assets, financing, or acquisition of all or a portion of our business to another company.\n\n• Third-Party Advertisers. We may use third-party advertising companies to serve ads when you visit the Apps. These companies may use information about your visits to our Website(s) and other websites that are contained in web cookies and other tracking technologies in order to provide advertisements about goods and services of interest to you.";

  //4
  static String terms_cond66 =
      "4. DO WE USE COOKIES AND OTHER TRACKING TECHNOLOGIES?";
  static String terms_cond67 =
      "In Short:  We may use cookies and other tracking technologies to collect and store your information.";
  static String terms_cond68 =
      "We may use cookies and similar tracking technologies (like web beacons and pixels) to access or store information. Specific information about how we use such technologies and how you can refuse certain cookies is set out in our Cookie Policy.";

  //5
  static String terms_cond69 = "5. HOW DO WE HANDLE YOUR SOCIAL LOGINS?";
  static String terms_cond70 =
      "In Short:  If you choose to register or log in to our services using a social media account, we may have access to certain information about you.";
  static String terms_cond71 =
      "Our Apps offer you the ability to register and login using your third party social media account details (like your Facebook or Twitter logins). Where you choose to do this, we will receive certain profile information about you from your social media provider. The profile Information we receive may vary depending on the social media provider concerned, but will often include your name, e-mail address, friends list, profile picture as well as other information you choose to make public.\n\nWe will use the information we receive only for the purposes that are described in this privacy policy or that are otherwise made clear to you on the Apps. Please note that we do not control, and are not responsible for, other uses of your personal information by your third party social media provider. We recommend that you review their privacy policy to understand how they collect, use and share your personal information, and how you can set your privacy preferences on their sites and apps.";

  //6
  static String terms_cond72 = "6. WHAT IS OUR STANCE ON THIRD-PARTY WEBSITES?";
  static String terms_cond73 =
      "In Short:  We are not responsible for the safety of any information that you share with third-party providers who advertise, but are not affiliated with, our websites.";
  static String terms_cond74 =
      "The Apps may contain advertisements from third parties that are not affiliated with us and which may link to other websites, online services or mobile applications. We cannot guarantee the safety and privacy of data you provide to any third parties. Any data collected by third parties is not covered by this privacy policy. We are not responsible for the content or privacy and security practices and policies of any third parties, including other websites, services or applications that may be linked to or from the Apps. You should review the policies of such third parties and contact them directly to respond to your questions.";

  //7
  static String terms_cond75 = "7. HOW LONG DO WE KEEP YOUR INFORMATION";
  static String terms_cond76 =
      "In Short:  We keep your information for as long as necessary to fulfill the purposes outlined in this privacy policy unless otherwise required by law";
  static String terms_cond77 =
      "We will only keep your personal information for as long as it is necessary for the purposes set out in this privacy policy, unless a longer retention period is required or permitted by law (such as tax, accounting or other legal requirements). No purpose in this policy will require us keeping your personal information for longer than the period of time in which users have an account with us.\n\nWhen we have no ongoing legitimate business need to process your personal information, we will either delete or anonymize it, or, if this is not possible (for example, because your personal information has been stored in backup archives), then we will securely store your personal information and isolate it from any further processing until deletion is possible.";

  //8
  static String terms_cond78 = "8. HOW DO WE KEEP YOUR INFORMATION SAFE?";
  static String terms_cond79 =
      "In Short:  We aim to protect your personal information through a system of organizational and technical security measures.";
  static String terms_cond80 =
      "We have implemented appropriate technical and organizational security measures designed to protect the security of any personal information we process. However, please also remember that we cannot guarantee that the internet itself is 100% secure. Although we will do our best to protect your personal information, transmission of personal information to and from our Apps is at your own risk. You should only access the services within a secure environment.";

  //9
  static String terms_cond81 = "9. DO WE COLLECT INFORMATION FROM MINORS?";
  static String terms_cond82 =
      "In Short:  We do not knowingly collect data from or market to children under 18 years of age.";
  static String terms_cond83 =
      "We do not knowingly solicit data from or market to children under 18 years of age. By using the Apps, you represent that you are at least 18 or that you are the parent or guardian of such a minor and consent to such minor dependent’s use of the Apps. If we learn that personal information from users less than 18 years of age has been collected, we will deactivate the account and take reasonable measures to promptly delete such data from our records. If you become aware of any data we have collected from children under age 18, please contact us at info@data245.com.";

  //10
  static String terms_cond84 = "10. WHAT ARE YOUR PRIVACY RIGHTS?";
  static String terms_cond85 =
      "In Short:  You may review, change, or terminate your account at any time.";
  static String terms_cond86 =
      "If you are resident in the European Economic Area and you believe we are unlawfully processing your personal information, you also have the right to complain to your local data protection supervisory authority. You can find their contact details here: http://ec.europa.eu/justice/data-protection/bodies/authorities/index_en.htm\n\nIf you have questions or comments about your privacy rights, you may email us at info@data245.com.";
  static String terms_cond87 = "Account Information";
  static String terms_cond88 =
      "If you would at any time like to review or change the information in your account or terminate your account, you can:";
  static String terms_cond89 =
      "■ Log into your account settings and update your user account.\n\n■ Contact us using the contact information provided.";
  static String terms_cond90 =
      "Upon your request to terminate your account, we will deactivate or delete your account and information from our active databases. However, some information may be retained in our files to prevent fraud, troubleshoot problems, assist with any investigations, enforce our Terms of Use and/or comply with legal requirements.\n\nOpting out of email marketing: You can unsubscribe from our marketing email list at any time by clicking on the unsubscribe link in the emails that we send or by contacting us using the details provided below. You will then be removed from the marketing email list – however, we will still need to send you service-related emails that are necessary for the administration and use of your account. To otherwise opt-out, you may:";
  static String terms_cond91 =
      "■ Access your account settings and update preferences.\n\n■ Note your preferences when you register an account with the site.\n\n■ Contact us using the contact information provided.";

  //11
  static String terms_cond92 = "11. CONTROLS FOR DO-NOT-TRACK FEATURES";
  static String terms_cond93 =
      "Most web browsers and some mobile operating systems and mobile applications include a Do-Not-Track (“DNT”) feature or setting you can activate to signal your privacy preference not to have data about your online browsing activities monitored and collected. No uniform technology standard for recognizing and implementing DNT signals has been finalized. As such, we do not currently respond to DNT browser signals or any other mechanism that automatically communicates your choice not to be tracked online. If a standard for online tracking is adopted that we must follow in the future, we will inform you about that practice in a revised version of this privacy policy.";

  //12
  static String terms_cond94 =
      "12. DO CALIFORNIA RESIDENTS HAVE SPECIFIC PRIVACY RIGHTS?";
  static String terms_cond95 =
      "In Short:  Yes, if you are a resident of California, you are granted specific rights regarding access to your personal information.";
  static String terms_cond96 =
      "California Civil Code Section 1798.83, also known as the “Shine The Light” law, permits our users who are California residents to request and obtain from us, once a year and free of charge, information about categories of personal information (if any) we disclosed to third parties for direct marketing purposes and the names and addresses of all third parties with which we shared personal information in the immediately preceding calendar year. If you are a California resident and would like to make such a request, please submit your request in writing to us using the contact information provided below.\n\nIf you are under 18 years of age, reside in California, and have a registered account with the Apps, you have the right to request removal of unwanted data that you publicly post on the Apps. To request removal of such data, please contact us using the contact information provided below, and include the email address associated with your account and a statement that you reside in California. We will make sure the data is not publicly displayed on the Apps, but please be aware that the data may not be completely or comprehensively removed from our systems.";

  //13
  static String terms_cond97 = "13. DO WE MAKE UPDATES TO THIS POLICY?";
  static String terms_cond98 =
      "In Short:  Yes, we will update this policy as necessary to stay compliant with relevant laws.";
  static String terms_cond99 =
      "We may update this privacy policy from time to time. The updated version will be indicated by an updated “Revised” date and the updated version will be effective as soon as it is accessible. If we make material changes to this privacy policy, we may notify you either by prominently posting a notice of such changes or by directly sending you a notification. We encourage you to review this privacy policy frequently to be informed of how we are protecting your information.";

  //14
  static String terms_cond100 = "14. HOW CAN YOU CONTACT US ABOUT THIS POLICY?";
  static String terms_cond101 =
      "If you have questions or comments about this policy, you may email us at info@data245.com or by post to:\n\nData245 LLC.\n\n2345 Waukegan Rd\n\nSuite 140\n\nBannockburn, IL 60015\n\nUnited States";

  //last
  static String terms_cond102 =
      "HOW CAN YOU REVIEW, UPDATE, OR DELETE THE DATA WE COLLECT FROM YOU?";
  static String terms_cond103 =
      "Based on the laws of some countries, you may have the right to request access to the personal information we collect from you, change that information, or delete it in some circumstances. To request to review, update, or delete your personal information, please submit a request to info@data245.com. We will respond to your request within 30 days.";

  static String error_page_text1 = "The image is inconclusive";
  static String error_page_text2 =
      "You can submit the image again for reprocessing or take a new eye picture.";
  static String error_page_text3 =
      "Know how to take a picture.";
  static String error_page_text4 =
      "Proceed below, or tap CANCEL to\nreturn to the home screen.";
  static const String CONTINUE = 'Continue';
  static const String NO_THANK_YOU = 'No Thank You';
  static const String CANCEL = 'Cancel';

  //Eyes Decision
  static const String EYES_DECISION = 'Pinky Eye';
}
