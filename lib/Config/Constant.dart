
import 'dart:convert';
import 'dart:io';
import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/View/OTPPage/OTPPage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Model/Dashbord/ExploreMoreListClass.dart';
import 'package:Repeople/Model/DrawerModal/UserrightListClass.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Helper/DeviceData.dart';

const googleMapApiKey = "AIzaSyCPYLUPMcdMC45LWtPTKdOd19eQ4ia5dXU";

const moengageAppIdDebug = "RNC6FLAC6WO5DC9329DDPT76_DEBUG";
const MOENGAGE_APP_ID = "RNC6FLAC6WO5DC9329DDPT76";
const MOENGAGE_APP_SECRET_DEBUG = "J67BDX3Z52RT";
const MOENGAGE_APP_SECRET = "VCW2GBMPQE0D";

// const API_CONSTKEY = "f6ae9e240acc761a32e7ab6dc53096f7";
const API_CONSTKEY = "f6ae9e240acc761a32e7ab6dc53096f7";
const APP_NAME = "Repeople";
const APP_CMPID = "5fae5d6e0c745720744b2fca";
// const APP_CMPID = "60549434a958c62f010daa2f";
// const APP_CMPID = "60549434a958c62f010daa2f";
const APP_ISS = "repeople-app";


//new Manager And Customer Flow Declaration
const REPEOPLE_MANAGER_CREDENTIAL="Repeople_Manager_Credential";
const REPEOPLE_CUSTOMER_CREDENTIAL="Repeople_Customer_Credential";

const IS_MANAGER_DATA_AVAILABLE ='Manager_Data_Avablity';
const IS_CUSTOMER_DATA_AVAILABLE ='Customer_Data_Avablity';
const CURRENT_LOGIN ='Current_Login_Details';

//user Base Role
const MANAGER_ACCESS ='Manager_Access';
const CUSTOMER_ACCESS ='Customer_Access';

RxString CURRENT_LOGIN_VAR = "".obs;
RxBool CURRENT_MANAGER_STATUS = false.obs;
RxBool CURRENT_CUSTMER_STATUS = false.obs;



const LOCAL_URL ="https://1c7f-27-113-255-2.ngrok-free.app/totality_project/api/repeople-app/v1.0/"; // dev - uat
const LOCAL_URL2 ="https://6b52-27-113-255-2.ngrok-free.app/totalitycrm/api/repeople-app/v1.0/"; // new ngrock


const DEV_URL ="https://worldrealty.totalityuat.com/api/repeople-app/v1.0/"; // dev - uat
const PRODUCTION_URL =""; // prod

// const BASE_URL = LOCAL_URL;
const BASE_URL = DEV_URL;
// const BASE_URL = PRODUCTION_URL;


const URL_LOGIN = BASE_URL + "login.php";
const URL_LOGOUT = BASE_URL + "logout.php";
const URL_NEWS = BASE_URL + "repeoplenews.php";
const URL_OFFERS = BASE_URL + "repeopleoffers.php";
const URL_PROJECT_LIST = BASE_URL + "project.php";
const URL_PROJECT_DETAILS = BASE_URL + "repeopleproject.php";
const URL_GRIEVANCE_LIST = BASE_URL + "grievance.php";
const URL_GRIEVANCE_DETAILS = BASE_URL + "chat.php";
const notificationSettingURL = BASE_URL +"notificationsettings.php";



const URL_AWARDS = BASE_URL +"awards.php";
const URL_NEWSS = BASE_URL +"news.php";
const URL_OFFERSSS = BASE_URL +"offers.php";
const URL_VENDORSLIST = BASE_URL +"vendors.php";
const URL_PROJECTLIST = BASE_URL +"master.php";
const URL_PROJECTLISTDASHBOARD = BASE_URL +"project.php";
const URL_PROJECTDETAILS = BASE_URL +"project.php";
const URL_PROPERTYDETAILS = BASE_URL +"myproperty.php";
const URL_USERPROFILEDETAILS = BASE_URL +"user.php";
const URL_ADDRENTAL = BASE_URL +"rental.php";
const URL_ADDRESALE = BASE_URL +"resale.php";
const URL_DEMANDSLIST = BASE_URL +"demands.php";
const URL_TERMSANDCONDITIONSLIST = BASE_URL +"termscondition.php";
const URL_FAQSLIST = BASE_URL +"faqs.php";
const URL_PRIVACYPLOICYLIST = BASE_URL +"privacypolicy.php";
const URL_DOCUMENT_CATEGORY_LIST = BASE_URL +"document.php";
const URL_COMMITTEE =BASE_URL +"committee.php";
const URL_DIRECTORY =BASE_URL +"directory.php";
const URL_REFFRAL =BASE_URL +"referral.php";
const URL_UPDATES =BASE_URL +"updates.php";
const URL_MEMBERS =BASE_URL +"member.php";
const URL_NOTIFICATION =BASE_URL +"notification.php";
const URL_TERMS_AND_CONDITION =BASE_URL +"termscondition.php";
const URL_FAQS =BASE_URL +"faqs.php";
const URL_ABOUT_US =BASE_URL +"details.php";
const URL_REDEEM_POINTS =BASE_URL +"redeem.php";
const URL_MANAGER =BASE_URL +"manager.php";
const URL_BUY_AND_SELL =BASE_URL +"investment.php";
const URL_DETAILS =BASE_URL +"details.php";
const URL_FACILITIES =BASE_URL +"facility.php";
const URL_OFFER_SLIDER =BASE_URL +"slider.php";
const redeemPointsURL = BASE_URL + "repeoplepoint.php";
const whatsAppReferral = BASE_URL + "whatsappreferral.php";
const URL_loginHistory = BASE_URL +"loginhistory.php";


RxBool Is_Login = false.obs;
RxBool Is_WhatsApp_Active = false.obs;
RxString username = "".obs;
RxString profile_pic = "".obs;
RxString email = "".obs;
RxString firstname = "".obs;
RxString lastname = "".obs;
RxString mobile = "".obs;
RxString alternate_mobile = "".obs;
RxString customer_id = "".obs;
RxString userLoginType = "".obs;
RxString customerID = "".obs;
RxString isWhatsApp = "".obs;
RxString isAlternateWSwitch = "".obs;
RxString userProffessionName = "".obs;
RxInt redeemPoints = 0.obs;

// whatsApp referral variable
RxString referralCode = "".obs;
RxString referralLink = "".obs;
RxString referralText = "".obs;
RxString referralFriendsPoints = "".obs;
double radius = 10.w;
String Commonmessage = '';
const ISUPDATENOTNOW = "updatenotnowclick";
//APPMENUNAME

const NOTIFICATION_COUNT = "notification_count";

GlobalKey<ScaffoldState> GlobalDeclaredkey = new GlobalKey<ScaffoldState>();

//THEME CONSTANT KEY

//<editor-fold desc = "DashBoard">
RxInt GetCurrentOsViewRight(MenuItemModel right){
  RxInt showmenu = 0.obs;
  if (Platform.isIOS && (right.isshowios==1 || right.isshowios==4)) {
    showmenu.value=1;
  }
  if (Platform.isAndroid && (right.isshowandroid == 1 || right.isshowandroid==4)) {
    showmenu.value=1;
  }
  return showmenu;
}

RxBool isbadgeshow=false.obs;

WALunchUrl(url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    print("Something Wrong");
    ScaffoldMessenger.of(Get.context!)
        .showSnackBar(SnackBar(content: new Text("whatsapp not installed")));
  }
}

const TITLE_1 = "title_1";
const TITLE_2 = "title_2";
const TITLE_3 = "title_3";
const TITLE_4 = "title_4";
const TITLE_5 = "title_5";
const DIVIDER = "divider";

const PROJECT_1 = "project_1";
const PROJECT_2 = "project_2";
const PROJECT_3 = "project_3";
const PROJECT_4 = "project_4";

const EXPLOREMORE_1 = "exploremore_1";
const EXPLOREMORE_2 = "exploremore_2";
const EXPLOREMORE_3 = "exploremore_3";
const EXPLOREMORE_4 = "exploremore_3";
const EXPLOREMORE_5 = "exploremore_5";

const SMARTHOME_1 = "smarthome_1";
const SMARTHOME_2 = "smarthome_2";
const SMARTHOME_3 = "smarthome_3";
const SMARTHOME_4 = "smarthome_4";
const SMARTHOME_5 = "smarthome_5";




const BOTTOMNAV_1 = "bottom_nav_1";
const BOTTOMNAV_2 = "bottom_nav_2";
const BOTTOMNAV_3 = "bottom_nav_3";
const BOTTOMNAV_4 = "bottom_nav_4";
const BOTTOMNAV_5 = "bottom_nav_5";

const BOOKSITE_1 = "booksite_1";
const BOOKSITE_2 = "booksite_2";
const BOOKSITE_3 = "booksite_3";
const BOOKSITE_4 = "booksite_4";
const BOOKSITE_5 = "booksite_5";

const REDEEMBRAND_1 = "redeembrand_1";
const REDEEMBRAND_2 = "redeembrand_2";
const REDEEMBRAND_3 = "redeembrand_3";
const REDEEMBRAND_4 = "redeembrand_4";

const REFER_FRIEND_1 = "referfriend_1";
const REFER_FRIEND_2 = "referfriend_2";
const REFER_FRIEND_3 = "referfriend_3";
const REFER_FRIEND_4 = "referfriend_4";



//</editor-fold>

const DASHBOARDOFFERLIST_1 = "dashboardofferlist_1";
const DASHBOARDOFFERLIST_2 = "dashboardofferlist_2";
const DASHBOARDOFFERLIST_3 = "dashboardofferlist_3";
const DASHBOARDOFFERLIST_4 = "dashboardofferlist_4";

//<editor-fold desc = "Project List Theme">

const PROJECT_LABEL_1 = "project_label_1";
const PROJECT_LABEL_2 = "project_label_2";

const PROJECT_SEARCH_1 = "project_search_1";
const PROJECT_SEARCH_2 = "project_search_2";
const PROJECT_SEARCH_3 = "project_search_3";
const PROJECT_SEARCH_4 = "project_search_4";

const PROJECT_LIST_1 = "project_list_1";
const PROJECT_LIST_2 = "project_list_2";
const PROJECT_LIST_3 = "project_list_3";
const PROJECT_LIST_4 = "project_list_4";
const PROJECT_LIST_5 = "project_list_5";



const TREDING_LIST_1 = "treding_list_1";

//</editor-fold>

//<editor-fold desc = "Project List Details">
const PROJECT_DETAILS_SCROLL_IMG_1 = "project_details_scroll_img_1";
const PROJECT_DETAILS_SCROLL_IMG_2 = "project_details_scroll_img_2";
const PROJECT_DETAILS_SCROLL_IMG_3 = "project_details_scroll_img_3";
const PROJECT_DETAILS_SCROLL_IMG_4 = "project_details_scroll_img_4";
const PROJECT_DETAILS_SCROLL_IMG_5 = "project_details_scroll_img_5";

const PROJECT_DETAILS_TITLE_1 = "project_details_title_1";
const PROJECT_DETAILS_TITLE_3 = "project_details_title_3";
const PROJECT_DETAILS_TITLE_4 = "project_details_title_4";

const PROJECT_DETAILS_BLOCK_1 = "project_details_block_1";
const PROJECT_DETAILS_BLOCK_2 = "project_details_block_2";
const PROJECT_DETAILS_BLOCK_3 = "project_details_block_3";

const PROJECT_DETAILS_DESC_1 = "project_details_desc_1";
const PROJECT_DETAILS_DESC_2 = "project_details_desc_2";
const PROJECT_DETAILS_DESC_3 = "project_details_desc_3";


const PROJECT_DETAILS_LINK_DOWNLOAD_1 = "project_details_link_download_1";
const PROJECT_DETAILS_LINK_DOWNLOAD_2 = "project_details_link_download_2";
const PROJECT_DETAILS_LINK_DOWNLOAD_3 = "project_details_link_download_3";
const PROJECT_DETAILS_LINK_DOWNLOAD_4 = "project_details_link_download_4";

const PROJECT_DETAILS_BASIC_INFO_1 = "project_details_basic_info_1";
const PROJECT_DETAILS_BASIC_INFO_2 = "project_details_basic_info_2";
const PROJECT_DETAILS_BASIC_INFO_3 = "project_details_basic_info_3";
const PROJECT_DETAILS_BASIC_INFO_4 = "project_details_basic_info_4";
const PROJECT_DETAILS_BASIC_INFO_5 = "project_details_basic_info_5";

const PROJECT_DETAILS_BASIC_INFO_BLOCK_1 = "project_details_info_block_1";
const PROJECT_DETAILS_BASIC_INFO_BLOCK_2 = "project_details_info_block_2";
const PROJECT_DETAILS_BASIC_INFO_BLOCK_3 = "project_details_info_block_3";
const PROJECT_DETAILS_BASIC_INFO_BLOCK_4 = "project_details_info_block_4";
const PROJECT_DETAILS_BASIC_INFO_BLOCK_5 = "project_details_info_block_5";

const PROJECT_DETAILS_ESSENTIALS_1 = "project_details_essentials_1";
const PROJECT_DETAILS_ESSENTIALS_2 = "project_details_essentials_2";
const PROJECT_DETAILS_ESSENTIALS_3 = "project_details_essentials_3";
const PROJECT_DETAILS_ESSENTIALS_4 = "project_details_essentials_4";
const PROJECT_DETAILS_ESSENTIALS_5 = "project_details_essentials_5";

//Project Basic Info List Id
const BASIC_INFO_OVERVIEW = "overview";
const BASIC_INFO_LOCATION = "location";
const BASIC_INFO_HIGHLIGHT = "highlight";
const BASIC_INFO_AMENITIES = "amenities";
const BASIC_INFO_GALLERY = "gallery";

// Project Essentials
const ESSENTIALS_BANK = "essentials_bank";
const ESSENTIALS_COLLEGE = "essentials_collage";
const ESSENTIALS_HOSPITAL = "essentials_hospital";
const ESSENTIALS_RESTAURANT = "essentials_restaurant";
//</editor-fold>

//<editor-fold desc = "Dashboard Header">

//<editor-fold desc = "SESSION CONST">

const SESSION_IS_LOGIN = "isLogin";
const SESSION_ARRAY = "sessionarray";
const SESSION_KEY = "key";
const SESSION_UNQKEY = "unqkey";
const SESSION_ISS = "iss";
const SESSION_UID = "uid";
const SESSION_CMPID = "cmpid";
const SESSION_CMPNAME = "cmpname";
const SESSION_FULLNAME = "fullname";
const SESSION_EMAIL = "email";
const SESSION_CONTACT = "contact";
const SESSION_ALTERNATE_MOBILE = "alternatemobile";
const SESSION_CUSTOMER_ID = "customerid";

const SESSION_PROFILEPIC = "icon";
const SESSION_USERLOGINTYPE = "userlogintype";
const SESSION_USERLOGINTYPENAME = "userlogintypename";
const SESSION_ISREGISTERED = "isregistered";
const SESSION_TOTALREDEEM_POINT = "totalredeempoints";
const SESSION_PERSONNAME = "personname";
const SESSION_FIRSTNAME = "firstname";
const SESSION_LASTNAME = "lastname";
const sessionAlterNateMobile = "alternatemobile";
const SESSION_MENU = "menu";
const SESSION_USERPROFESSIONNAME = "proffession";
const IS_WHATSAPP_KEY = "iswhatsApp";
const ALTERNATE_WHATSAPP_KEY = "isalternatewhatsApp";

//DashBoard Urls Redirection
const PROJECT_CHECKLIST = "projectchecklist";
const PLACE_ANALIYSIS = "placeanalysis";
const ONLINE_MEETING_SCHEDULE = "meetingschedule";
const PLACE_AREA_CALCULATOR = "placeareacalculator";

//</editor-fold>


const DASHBOARD_HEADER_1 = "dashboard_header_1";
const DASHBOARD_HEADER_2 = "dashboard_header_2";
const DASHBOARD_HEADER_3 = "dashboard_header_3";
const DASHBOARD_HEADER_4 = "dashboard_header_4";
const DASHBOARD_HEADER_5 = "dashboard_header_5";

//</editor-fold>

//<editor-fold desc = "News List Page">

const NEWS_LIST_IMPORTANT_NEWS_1 = "important_news_1";
const NEWS_LIST_IMPORTANT_NEWS_2 = "important_news_2";
const NEWS_LIST_IMPORTANT_NEWS_3 = "important_news_3";
const NEWS_LIST_IMPORTANT_NEWS_4 = "important_news_4";
const NEWS_LIST_IMPORTANT_NEWS_5 = "important_news_5";

const NEWS_LIST_UPDATED_NEWS_1 = "updated_news_1";
const NEWS_LIST_UPDATED_NEWS_2 = "updated_news_2";
const NEWS_LIST_UPDATED_NEWS_3 = "updated_news_3";
const NEWS_LIST_UPDATED_NEWS_4 = "updated_news_4";
const NEWS_LIST_UPDATED_NEWS_5 = "updated_news_5";
//</editor-fold>

// <editor-fold desc = "News Details">

const NEWS_DETAILS_THEME_1 = "news_details_theme_1";
const NEWS_DETAILS_THEME_2 = "news_details_theme_2";
const NEWS_DETAILS_THEME_3 = "news_details_theme_3";
const NEWS_DETAILS_THEME_4 = "news_details_theme_4";
const NEWS_DETAILS_THEME_5 = "news_details_theme_5";

// </editor-fold>

//<editor-fold desc = "About">

const ABOUT_TITLE_1 = "about_title_1";
const ABOUT_TITLE_2 = "about_title_2";
const ABOUT_TITLE_3 = "about_title_3";
const ABOUT_TITLE_4 = "about_title_4";
const ABOUT_TITLE_5 = "about_title_5";

const ABOUT_LICENSES_1 = "about_licenses_1";
const ABOUT_LICENSES_2 = "about_licenses_2";
const ABOUT_LICENSES_4 = "about_licenses_4";
const ABOUT_LICENSES_5 = "about_licenses_5";

const ABOUT_RATE_US_1 = "about_rate_us_1";
const ABOUT_RATE_US_2 = "about_rate_us_2";
const ABOUT_RATE_US_4 = "about_rate_us_4";
const ABOUT_RATE_US_5 = "about_rate_us_5";

const POWERED_BY_1 = "powered_by_1";
const POWERED_BY_2 = "powered_by_2";

//</editor-fold>

const LOGIN_TITLE_1 = "login_title_1";
const LOGIN_TITLE_2 = "login_title_2";
const LOGIN_TITLE_3 = "login_title_3";
const LOGIN_TITLE_4 = "login_title_4";
const LOGIN_TITLE_5 = "login_title_5";

const LOGIN_FORM_1 = "login_form_1";
const LOGIN_FORM_2 = "login_form_2";
const LOGIN_FORM_3 = "login_form_3";
const LOGIN_FORM_4 = "login_form_4";
const LOGIN_FORM_5 = "login_form_5";
//<editor-fold desc = "Privacy Policy">

const PRIVACY_TERM_1 = "privacy_term_1";
const PRIVACY_TERM_2 = "privacy_term_2";
const PRIVACY_TERM_3 = "privacy_term_3";
const PRIVACY_TERM_4 = "privacy_term_4";
const PRIVACY_TERM_5 = "privacy_term_5";

//</editor-fold>

//<editor-fold desc = "Favourite No Data Found">

const NODATAFOUND_1 = "nodata_found_1";
const NODATAFOUND_2 = "nodata_found_2";
const NODATAFOUND_3 = "nodata_found_3";
const NODATAFOUND_4 = "nodata_found_4";
const NODATAFOUND_5 = "nodata_found_5";

const NO_DATAFOUND_TITLE = "NO DATA FOUND";

//</editor-fold>

//<editor-fold desc = "Favourite ">

const FAVOURITE_PROJECT_LIST_1 = "favourite_list_1";
const FAVOURITE_PROJECT_LIST_2 = "favourite_list_2";
const FAVOURITE_PROJECT_LIST_3 = "favourite_list_3";
const FAVOURITE_PROJECT_LIST_4 = "favourite_list_4";
const FAVOURITE_PROJECT_LIST_5 = "favourite_list_5";

//</editor-fold>

//<editor-fold desc = "Schedule Site">

const SCHEDULE_SITE_1 = "schedule_site_1";
const SCHEDULE_SITE_2 = "schedule_site_2";
const SCHEDULE_SITE_3 = "schedule_site_3";
const SCHEDULE_SITE_4 = "schedule_site_4";
const SCHEDULE_SITE_5 = "schedule_site_5";
const SCHEDULE_SITE = "Schedule a Site Visit";

//</editor-fold>


//<editor-fold desc = " Technical Query">
const TECHNICAL_QUERY_1 = "technical_query_1";
const TECHNICAL_QUERY_2 = "technical_query_2";
const TECHNICAL_QUERY_3 = "technical_query_3";
const TECHNICAL_QUERY_4 = "technical_query_4";
const TECHNICAL_QUERY_5 = "technical_query_5";
//</editor-fold>

//<editor-fold desc = "Refer A Friend page">

const REFER_A_FRIEND_1 = "refer_a_friend_1 ";
const REFER_A_FRIEND_2 = "refer_a_friend_2 ";
const REFER_A_FRIEND_3 = "refer_a_friend_3 ";
const REFER_A_FRIEND_4 = "refer_a_friend_4 ";
const REFER_A_FRIEND_5 = "refer_a_friend_5 ";

const REFER_A_FRIEND_APPBAR = "Refer a Friend";
const TECHNICAL_QUERY = "Technical Query";
const REFERRAL = "Referral";
const REFERRAL_STATUS = "Referral Status";
const REDEEM_POINT = "Redeem Point";
const EMI_CALCULATOR = "EMI Calculator";
const PRIVACY_POLICY = "Privacy Policy";
const MANAGER_GRIEVANCE_DETAIL_LIST = "Grievance List";


//</editor-fold>

//<editor-fold desc = "Refer A Friend Form">

const REFER_FORM_1 = "refer_form_1";
const REFER_FORM_2 = "refer_form_2";
const REFER_FORM_3 = "refer_form_3";
const REFER_FORM_4 = "refer_form_4";
const REFER_FORM_5 = "refer_form_5";

//</editor-fold>

//<editor-fold desc = "ContactUs Page">

const CONTACTUS_1 = "contactus_1";
const CONTACTUS_2 = "contactus_2";
const CONTACTUS_3 = "contactus_3";
const CONTACTUS_4 = "contactus_4";
const CONTACTUS_5 = "contactus_5";
const CONTACTUS = "Contact Us";

//</editor-fold>

const FACILITIES = "Facilities";
const FACILITIES_RULESANDREGULATIONS = "Rules And Regulations";
const FACILITIES_BOOKINGHISTORY = "Facilities Booking History";

const CO_OWNER = "Co-Owner";
const VISITOR = "Visitor";
const ADD_CO_OWNER = "Add Co-Owner";
const BUY_AND_SELL = "Buy And Sell";

const NOTIFICATION = "Notifications";
const NOTIFICATION_LIST = "Notification_List";



//<editor-fold desc = "ContactUs Form Page">

const CONTACTUS_FORM_1 = "contactus_form_1";
const CONTACTUS_FORM_2 = "contactus_form_2";
const CONTACTUS_FORM_3 = "contactus_form_3";
const CONTACTUS_FORM_4 = "contactus_form_4";
const CONTACTUS_FORM_5 = "contactus_form_5";

//</editor-fold>

//<editor-fold desc = "Emi Loan Text">

const EMI_LOAN_TEXT_1 = "emi_loan_text_1";
const EMI_LOAN_TEXT_2 = "emi_loan_text_2";
const EMI_LOAN_TEXT_3 = "emi_loan_text_3";
const EMI_LOAN_TEXT_4 = "emi_loan_text_4";
const EMI_LOAN_TEXT_5 = "emi_loan_text_5";

//</editor-fold>

//<editor-fold desc = "Emi Statistic">

const EMI_STATISTIC_1 = "emi_statistic_1";
const EMI_STATISTIC_2 = "emi_statistic_2";
const EMI_STATISTIC_3 = "emi_statistic_3";
const EMI_STATISTIC_4 = "emi_statistic_4";

//</editor-fold>

//<editor-fold desc = "Emi Calculate">

const EMI_CALCULATE_1 = "emi_calculate_1";
const EMI_CALCULATE_2 = "emi_calculate_2";
const EMI_CALCULATE_3 = "emi_calculate_3";
const EMI_CALCULATE_4 = "emi_calculate_4";
const EMI_CALCULATE_5 = "emi_calculate_5";

//</editor-fold>

//BOTTOM NAVIGATION ICON STATIC KEY

const HOMEMENU = "home";
const SECONDMENU = "second";
const REFERMENU = "refer";
const FAVMENU = "favorite";
const ACCOUNTMENU = "account";
const PROFILE = "Profile";
const KEYMENU = "key";
const PROJECTMENU = "project";
const NOTIFICTIONMENU = "notification";
const EDITPROFILE = "Edit Profile";
const ADDNEWHOME = "Add New Property";

//SHAREDPREFRENCE KEY
const API_KEY = "key_api";
const KEY_UID = "uid";
// const KEY_PROFILEPIC = "profilepic";
// const KEY_PERSONNAME = "personname";

// const KEY_CARTITEMARRAY = 'cartitemarray';
// const KEY_USERRIGHTARRAY = 'UserrightArray';
// const KEY_MOMARRAY = 'MOMArray';
// const ACCESSTOKEN_365 = 'accesstoken';

const IS_LOGIN = "islogin";

const APPBAR_HEIGHT = 70.0;

const LEFT_PADDING = 10.0;
const RIGHT_PADDING = 10.0;
RxInt downloadValue = (0).obs;
CancelToken cancelToken = CancelToken();
const HIDEDURATION = 2;

// new declaration
const NEWS_APPMENUNAME_CAP = "News";
const OFFER_APPMENUNAME_CAP = "Offers";
const AWARDS_APPMENUNAME_CAP = "Award";
const MARKETING_MATERIAL_CAP = "Marketing Material";
const UPDATES_APPMENUNAME_CAP = "Updates";
const ABOUT_APPMENUNAME_CAP = "About";
const COMMITTEE_APPMENUNAME_CAP = "Committee";
const COMPLAINT_APPMENUNAME_CAP = "Grievance";
const NOTICE_APPMENUNAME_CAP ="Notice";
const FACILITIES_APPMENUNAME_CAP ="Facilities";
const COOWNER_APPMENUNAME_CAP ="Co-owner";
const VENDOR_APPMENUNAME_CAP = "Vendor";
const MANAGER_ACCOUNT = "ManagerAccount";
const MANAGER_LOGIN = "managerlogin";
const CUSTOMER_LOGIN = "customerlogin";
const CUSTOMER_SWITCH = "switchcustomer";
const MANAGER_SWITCH = "switchmanager";
const OPEN_SOURCE_LICENCE = "Open Source Licence";


// Drawer List Id
const LOGIN_SIGNUP_APPMENUNAME = "Login / SignUp";
const LOGIN_APPMENUNAME = "Login";
const MANAGER_LOGIN_APPMENUNAME = "Manager Login";
const PROJECT_APPMENUNAME = "Projects";
const FAVORITE_APPMENUNAME = "favorite";
const REFER_FRIEND_APPMENUNAME = "Refer Friend";
const OFFER_APPMENUNAME = "offers";
const SCHEDULE_SITE_VISIT_APPMENUNAME = "sitevisit";
const EMI_CALCULATOR_APPMENUNAME = "emicalculator";
const NEWS_APPMENUNAME = "news";
const AWARDS_APPMENUNAME = "award";
const REFERRAL_APPMENUNAME = "referral";
const UPDATES_APPMENUNAME = "updates";
const CONTACT_APPMENUNAME = "contact";
const ABOUT_APPMENUNAME = "about";
const ABOUT_US_APPMENUNAME = "About Us";
const VENDOR_APPMENUNAME = "vendor";
const COMMITTEE_APPMENUNAME = "committee";
const COMPLAINT_APPMENUNAME = "grievance";
const GRIEVANCE_DETAILS_APPMENUNAME = "grievancedetails";
const DOCUMENT_APPMENUNAME ="document";
const NOTICE_APPMENUNAME ="notice";
const FACILITIES_APPMENUNAME ="facilities";
// const REDEEM_POINT ="Redeem Point";
const COOWNER_APPMENUNAME ="co-owner";
const VISITOR_APPMENUNAME ="visitor";
const BUILDING_DIRCTORY ="buildingdirectory";
const MY_ACCOUNT_PAGE ="account";

const TECHNICAL_QUERY_APPMENUNAME ="technicalquery";

const SMART_BUYER_APPMENUNAME ="smartbuyer";
const BARTER_APPMENUNAME ="barter";
const BARTER ="Barter";
const MARKETING_MATERIAL_APPMENUNAME ="marketingmaterials";
const BUYSELLRENT_APPMENUNAME ="buysellrent";
const CUSTOMER_CARE_APPMENUNAME ="customercare";
const PROJECT_CHECKLIST_APPMENUNAME ="projectchecklist";
const PLACE_AREA_CALCULATOR_APPMENUNAME ="Place Area Calculator";
const PLACE_ANALYSIS_APPMENUNAME ="placeanalysis";
const ONLINE_MEETING_SCHEDULE_APPMENUNAME ="meetingschedule";
const SESSION_ROLECODE = "rolecode";
const GUEST_USER_ROLE_CODE = "CODE01";


const APP_LINK= "https://play.google.com/store/apps/details?id=com.brokerdalal";

//sharedprefrence-constant
const IS_USER_LOGIN= "is_login";
const USER_MOBILE_NO= "mobile_no";
const USER_NAME= "name";
const USER_MAIL_ID= "mail_id";

const FAVORITE_APPNAME = "Favourites";
const SCHEDULE_SITE_VISIT_APPNAME = "Schedule Site Visit";
const ABOUT_APPNAME = "About App";
// App menu Userright array list

// <editor-fold desc = "common Header">

const COMMON_HEADER_1 = "common_header_1";
const COMMON_HEADER_2 = "common_header_2";
const COMMON_HEADER_3 = "common_header_3";
const COMMON_HEADER_4 = "common_header_4";
const COMMON_HEADER_5 = "common_header_5";

// </editor-fold>

// <editor-fold desc = "Drawer">

RxList<MenuItemModel> arrDrawerListTile = RxList<MenuItemModel>(); // this use for listing drawerList Data
RxList<UserrightListClass> arrDrawerFooterListTile = RxList<UserrightListClass>(); // this use for listing drawerList Data

const DRAWER_1 = "drawer_1";
const DRAWER_2 = "drawer_2";
const DRAWER_3 = "drawer_3";
const DRAWER_4 = "drawer_4";
const DRAWER_5 = "drawer_5";
// </editor-fold>

// <editor-fold desc = "Referral Page">

const REFERRAL_BUTTON_1 = "referral_button_1";
const REFERRAL_BUTTON_2 = "referral_button_2";
const REFERRAL_BUTTON_3 = "referral_button_3";
const REFERRAL_BUTTON_4 = "referral_button_4";
const REFERRAL_BUTTON_5 = "referral_button_5";

const REFERRAL_DESC_1 = "referral_desc_1";
const REFERRAL_DESC_2 = "referral_desc_2";
const REFERRAL_DESC_3 = "referral_desc_3";
const REFERRAL_DESC_4 = "referral_desc_4";
const REFERRAL_DESC_5 = "referral_desc_5";

const REFERRAL_FAQ_QUESTION_1 = "referral_faqs_question_1";
const REFERRAL_FAQ_QUESTION_2 = "referral_faqs_question_2";
const REFERRAL_FAQ_QUESTION_3 = "referral_faqs_question_3";
const REFERRAL_FAQ_QUESTION_4 = "referral_faqs_question_4";

//</editor-fold>

const APPDEVICE_APPMENUNAME = "appdevice";
const SESSION_CREDIT = "credit";
const SESSION_POINTS = "points";
const SESSION_DISCREDIT = "dis_credit";
const SESSION_DISPOINTS = "dis_points";

const ISLOGIN = "isLogin";

//<editor-fold desc = "Awards">

const AWARDS_1 = "awards_1";
const AWARDS_2 = "awards_2";
const AWARDS_3 = "awards_3";
const AWARDS_4 = "awards_4";
const AWARDS_5 = "awards_5";

//</editor-fold>
const String ACTION_RAISED = "Raised";
const String ACTION_TIMELINE = "time-line-set";
const String TIMELINE = "time-line";
const String ACTION_ASSIGNED = "Assigned";
const String ACTION_ASSIGNED_MESSAGE = "assignee-message";
const String ACTION_USER_MESSAGE = "user-message";
const String ACTION_CLOSED = "Closed";
const String ACTION_REOPEN = "Re-Opened";
const String ACTION_NOTIFIED = "Notified";
//</editor-fold>


const String TECHNICAL_QUERY_CONTACT_NUMBER = "tel:+99364921507";

Rx<Country> countryIndia = Country(
  name: "India",
  flag: "🇮🇳",
  code: "IN",
  dialCode: "91",
  minLength: 10,
  maxLength: 10, nameTranslations: {},
).obs;

OpenGusetUserRestricationDialog(){
  //GusetUserRestrictionDialog();
  Fluttertoast.showToast(
      msg: "You should login first to proceed further.",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0
  );
}

bool isBottomPageNavigate = false;

// drawer scaffold globalKey
var openDrawerKey = GlobalKey<ScaffoldState>();

bool? iswLogin = false;
callLinkOpen(var event) async {
  print(event);
  print("event===> *****");
  SharedPreferences sp = await SharedPreferences.getInstance();
  iswLogin = sp.getBool(ISLOGIN) ?? false;
  bool isContainsWaba = event.contains("/waba-login/");
  bool isContainsWhatsapp = event.contains("/whatsapp-login/");
  bool isContainsInvitee = event.contains("/invitee/");
  bool isContainsBinvitee = event.contains("/binvitee/");
  String invitee = "";

  if (isContainsWaba) {
    invitee = "/waba-login/";
  } else if (isContainsWhatsapp) {
    invitee = "/whatsapp-login/";
  }
  print("object222222");
  if (isContainsInvitee) {
    invitee = "/invitee/";
    print(invitee);
  } else if (isContainsBinvitee) {
    invitee = "/binvitee/";
    print(invitee);
  }

  if (isContainsWaba || isContainsWhatsapp) {
    var data = event.split(invitee);
    print(data);
    if (data[1] != null && data[1].isNotEmpty) {
      // WhatsappLogin(data[1].toString().replaceAll("?data=", ""));
    }
  } else if ((isContainsInvitee || isContainsBinvitee) && !iswLogin!) {
    var data = event.split(invitee);
    if (data[1] != null && data[1].isNotEmpty /*&& !isLogin!*/) {
      Get.to(OTPPage(
        // referral_code: data[1].toString().replaceAll("?data=", ""),
      ));
    }
  }
  else {
    // checkLoginOrNot();
  }
}


extension StringExtension on String {
  String capitalizestring() {
    return this.isNotEmpty?"${this[0].toUpperCase()}${this.substring(1).toLowerCase()}":"";
  }
}
extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
  bool isNumberOnly() {
    return RegExp(
        r'^[0-9]+$').hasMatch(this);
  }

  bool isLettersOnly() {
    return RegExp(
        r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$")
        .hasMatch(this);
  }

  bool isValidGSTNO() {
    return RegExp(r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$')
        .hasMatch(this);
  }
}

String newsdate(d){
  String date=
  DateFormat('dd MMMM yyyy').format(DateTime.parse(d));
  return date;
}

String dateFormate(d){
  var inputFormat = DateFormat.yMd().add_jm();
  var inputDate = inputFormat.parse(d);
  var outputFormat = DateFormat('dd MMM yyyy');
  return outputFormat.format(inputDate);
}

newdateFormate(d){
  var inputFormat = DateFormat('dd/MM/yyyy HH:mm');
  var inputDate = inputFormat.parse(d); // <-- dd/MM 24H format

  var outputFormat = DateFormat('yyyy-MM-dd hh:m');
  var outputDate = outputFormat.format(inputDate);
  print(outputDate);
}

//<editor-fold desc="Text Style">

Future<Rx<UserrightsModal>> GetUserRights(String alias) async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  Rx<UserrightsModal> arrUserRightsList=UserrightsModal().obs;
  var sessionmenu=sp.getString(SESSION_MENU);
  if(sessionmenu != null && sessionmenu !=''){
    arrUserRightsList.value = UserrightsModal.fromJson(json.decode(sessionmenu));
    arrUserRightsList.refresh();
  }
  return arrUserRightsList;
}

const TextStyle smallTextStyle = TextStyle(
    fontSize: 12
);
TextStyle smallBoldFontStyle=TextStyle(fontWeight: FontWeight.w500,color: APP_FONT_COLOR.withOpacity(0.7),fontSize: 12);
//title with normal style
TextStyle normalTitleStyle([double fontsize=16])=>TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: fontsize,
    color: APP_FONT_COLOR
);

//title with normal style with color
TextStyle normalTitleStyleWithColor({MaterialColor? color,double fontsize=16})=>TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: fontsize,
    color: color ?? APP_FONT_COLOR
);

// News
TextStyle descTitleStyle(MaterialColor color) => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: color
);

TextStyle descTextStyle = TextStyle(
  fontSize: 15,
);

// About
TextStyle titleStyle([MaterialColor? color]) => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: color??APP_FONT_COLOR
);

TextStyle darkMediumTextStyle() => TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold
);

TextStyle normalTextStyle() => TextStyle(
    fontSize: 14
);

TextStyle darkBigTextStyle() => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold
);

TextStyle darkLargeTextStyle([double fontSize = 18,]) => TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: fontSize,
    color: APP_FONT_COLOR
);

//</editor-fold>

typedef void OnChanged(double value);
DeviceData deviceData = DeviceData();
RxInt GLOBAL_THEME_INDEX = 0.obs;


//device session related item store

const TOKEN_DETAILS="token_details";
const TOKEN="token";
const TOKEN_DATA="token_data";
const USER_ID="user_id";
const TOKEN_USER_NAME="username";
const TOKEN_EXP="exp";
const TOKEN_EMAIL="email";
const TOKEN_MOBILE="mobile_no";
const TOKEN_GUEST_STATUS="guest";
const TOKEN_USER_TYPE="user_type";
const TOKEN_USER_TYPE_ID="user_type_id";


const REPP_USER_DETAILS="user_details";
const REPP_USER="reapp_user";
const REPP_USER_ID="reapp_user_id";
const REPP_MOBILE_NO="mobile_no";
const REPP_SCOPE="scope";
const REPP_EXPIRES_IN="expires_in";
const REPP_REFRESH_TOKEN="refresh_token";
const REPP_ACCESS_TOKEN="access_token";
const REPP_TOKEN_TYPE="token_type";
const REPP_STATUS="status";
const REPP_EMAIL="email";



// constant api related declaration
const JWT_TOKEN="JWT eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJ1c2VybmFtZSI6IjkxNjc4NzYwMjgiLCJleHAiOjE5MjkwOTkyMzUsImVtYWlsIjpudWxsLCJtb2JpbGVfbm8iOiI5MTY3ODc2MDI4Iiwib3JpZ19pYXQiOjE2MTM3MzkyMzUsImRldmljZV9pZCI6ImFiYyIsImJ1aWxkZXJfaWQiOiJyYXVuYWstZ3JvdXAiLCJndWVzdCI6ZmFsc2UsInVzZXJfdHlwZSI6Ik1hc3RlciBBZG1pbiIsInVzZXJfdHlwZV9pZCI6LTF9.oEqoeFWiljm6pylULqBL7IHzm1IJOHFh8xKJk1_TTKU";
const LOGIN_TYPE="customer";

//image related declaration
String LOADER_ICON = "assets/images/loading.gif";


//api related declaration



