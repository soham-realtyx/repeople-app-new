import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/Helper/MoengageAnalyticsHandler.dart';
import 'package:Repeople/Controller/BottomNavigator/BottomNavigatorController.dart';
import 'package:Repeople/View/AboutUsPage/AboutUsScreen.dart';
import 'package:Repeople/View/AwardsPage/AwardsPage.dart';
import 'package:Repeople/View/BarterPage/BarterPage.dart';
import 'package:Repeople/View/CoOwnerMainPage/CoOwnerMainPage.dart';
import 'package:Repeople/View/ContactUsPage/ContactUsFormPage.dart';
import 'package:Repeople/View/ContactUsPage/ContactUsPage.dart';
import 'package:Repeople/View/DashboardPage/DashboardPage.dart';
import 'package:Repeople/View/Document_Screen/Document_Screen.dart';
import 'package:Repeople/View/EmiCalculatorPage/EmiCalculatorPage.dart';
import 'package:Repeople/View/FacilitiesPage/FacilitiesPage.dart';
import 'package:Repeople/View/FavoritePage/FavoritePage.dart';
import 'package:Repeople/View/GrievancePages/ComplaintListScreen.dart';
import 'package:Repeople/View/LoginPage/LoginPage.dart';
import 'package:Repeople/View/MarketingMaterialPage/MarketingMaterialPage.dart';
import 'package:Repeople/View/MyAccountPage/MyAccountPage.dart';
import 'package:Repeople/View/MyBuildingDirectoryPage/MyBuildingDirectoryPage.dart';
import 'package:Repeople/View/NewsListPage/NewsPage.dart';
import 'package:Repeople/View/NoticeBoardPage/NoticeBoardPage.dart';
import 'package:Repeople/View/OffersPage/OffersPage.dart';
import 'package:Repeople/View/ProjectListPage/ProjectListPage.dart';
import 'package:Repeople/View/ReferaFriendPage/ReferAFriendPage.dart';
import 'package:Repeople/View/ReferralPage/ReferralPage.dart';
import 'package:Repeople/View/ScheduleSitePage/ScheduleSitePage.dart';
import 'package:Repeople/View/UpdatesPage/UpdatesPage.dart';
import 'package:Repeople/View/VendorPage/VendorPage.dart';
import 'package:Repeople/View/VisitorPage/VisitorPage.dart';
import 'package:Repeople/View/committeePage/committeePage.dart';
import 'package:Repeople/View/grievance_details/grievance_details.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';



BottomNavigatorController cnt_Bottom =
Get.put(BottomNavigatorController());

int navigationclick = 0;


ClickHandler(String alias, int click, {String id = ""}) async{
   int position = cnt_Bottom.arrBottomnavigationList
      .indexWhere((element) => element.alias == alias);
  cnt_Bottom.selectedIndex.value = position;
  cnt_Bottom.selectedIndex.refresh();
   SharedPreferences sp = await SharedPreferences.getInstance();
  navigationclick = click;
  switch (alias) {
    case LOGIN_SIGNUP_APPMENUNAME:
      Get.to(LoginPage());
      break;
    case PROJECT_APPMENUNAME:
      Get.to(ProjectListPage());
      break;
    case FAVORITE_APPMENUNAME:
      MoengageAnalyticsHandler().track_event(("favourite_list"));
      Get.to(FavoritePage());
      break;
    case REFER_FRIEND_APPMENUNAME:
      MoengageAnalyticsHandler().track_event("refer_a_friend");
      Get.to(ReferAFriendPage());
      break;
    case OFFER_APPMENUNAME:
      // Get.to(committeePage());
      // Get.to(MyBuildingDirectoryPage());
      // Get.to(CoOwnerMainPage());
      MoengageAnalyticsHandler().track_event("offer");
      Get.to(OffersPage());
      // Get.to(ExamplePageForSearch());
      break;
    case SCHEDULE_SITE_VISIT_APPMENUNAME:
      Get.to(ScheduleSitePage());
      break;
    case EMI_CALCULATOR_APPMENUNAME:
      MoengageAnalyticsHandler().track_event("emi_calculator");
        Get.to(EmiCalculatorPage());
      break;
    case NEWS_APPMENUNAME:
      MoengageAnalyticsHandler().track_event("news");
      Get.to(NewsListPage());
      break;
     case AWARDS_APPMENUNAME:
       Get.to(AwardsPage());
      break;
    case REFERRAL_APPMENUNAME:
      MoengageAnalyticsHandler().track_event("referral_page");
      Get.to(ReferralPage());
      break;
    case UPDATES_APPMENUNAME:
      MoengageAnalyticsHandler().track_event("update_page");
      Get.to(UpdatesPage());
      break;
    case DOCUMENT_APPMENUNAME:
      Get.to(Document_Screen());
      break;
    case CONTACT_APPMENUNAME:
      MoengageAnalyticsHandler().track_event("contact_us");
      Get.to(ContactUsPage());
      break;
    case VENDOR_APPMENUNAME:
      Get.to(VendorPage());
      break;
    case COMMITTEE_APPMENUNAME:
     Get.to(committeePage());
      break;
    case ABOUT_APPMENUNAME:
      //Get.to(AboutPage());
      Get.to(AboutUsPage());
      break;
    case NOTICE_APPMENUNAME:
      MoengageAnalyticsHandler().track_event("notice_page");
      Get.to(NoticeBoardPage());
      break;
    case FACILITIES_APPMENUNAME:
      MoengageAnalyticsHandler().track_event("facilities_page");
      Get.to(FacilitiesPage());
      break;
    case COMPLAINT_APPMENUNAME:
      MoengageAnalyticsHandler().track_event("grievance_page");
      Get.to(ComplaintListScreen());
      break;
    case GRIEVANCE_DETAILS_APPMENUNAME:
      Get.to(grievance_details(id: id,));
      break;
    case SMART_BUYER_APPMENUNAME:
      MoengageAnalyticsHandler().track_event("facilities_page");
      Get.to(FacilitiesPage());
      break;
    case BARTER_APPMENUNAME:
      MoengageAnalyticsHandler().track_event("barter_page");
      Get.to(BarterPage());
      break;
    case MARKETING_MATERIAL_APPMENUNAME:
      Get.to(MarketingMaterialPage());
      break;
    case BUYSELLRENT_APPMENUNAME:
      MoengageAnalyticsHandler().track_event("facilities_page");
      Get.to(FacilitiesPage());
      break;
    case CUSTOMER_CARE_APPMENUNAME:
      Get.to(ContactUsFormPage());
      break;
    case COOWNER_APPMENUNAME:
      MoengageAnalyticsHandler().track_event("co_owner_page");
      Get.to(CoOwnerMainPage());
      break;
    case PROJECT_CHECKLIST_APPMENUNAME:
      // Get.to(ContactPage());
      break;
    case PLACE_AREA_CALCULATOR_APPMENUNAME:
      // Get.to(ContactPage());
      break;
    case PLACE_ANALYSIS_APPMENUNAME:
      // Get.to(ContactPage());
      break;
    case ONLINE_MEETING_SCHEDULE_APPMENUNAME:
      // Get.to(ContactPage());
      break;
    case BUILDING_DIRCTORY:
      MoengageAnalyticsHandler().track_event("my_directory_page");
      Get.to(MyBuildingDirectoryPage());
      break;
    case VISITOR_APPMENUNAME:
      MoengageAnalyticsHandler().track_event("visitor_page");
      Get.to(VisitorPage(visitorid: id,));
      break;
    case MY_ACCOUNT_PAGE:
      MoengageAnalyticsHandler().track_event("profile_page");
      Get.to(MyAccountPage());
      break;
    case PROJECT_CHECKLIST:
     var url= sp.getString(PROJECT_CHECKLIST);
     await launchUrl(Uri.parse(url ?? ""),mode: LaunchMode.externalApplication);
    break;
    case PLACE_ANALIYSIS:
      var url= sp.getString(PLACE_ANALIYSIS);
      await launchUrl(Uri.parse(url ?? ""),mode: LaunchMode.externalApplication);
      break;
    case PLACE_AREA_CALCULATOR:
      var url= sp.getString(PLACE_AREA_CALCULATOR);
      await launchUrl(Uri.parse(url ?? ""),mode: LaunchMode.externalApplication);
      break;
    case ONLINE_MEETING_SCHEDULE:
      var url= sp.getString(ONLINE_MEETING_SCHEDULE);
      await launchUrl(Uri.parse(url ?? ""),mode: LaunchMode.externalApplication);
      break;

    default:
      MoengageAnalyticsHandler().track_event("dashboard_page");
      Get.offAll(DashboardPage());
      break;
  }
}

