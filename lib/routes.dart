import 'package:coral_reef/onboarding/splash/Onboard_screen.dart';
import 'package:coral_reef/onboarding/sign_in/sign_in_screen.dart';
import 'package:coral_reef/onboarding/sign_up/signup_screen.dart';
import 'package:coral_reef/onboarding/forgotpassword/forgotpassword.dart';
import 'package:coral_reef/tracker_screens/bottom_navigation_bar.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/sections/chal_participants.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/sections/challenge_details.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/sections/coral_rewards.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/sections/create_challenge.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/sections/all_data.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/sections/challenge_page.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/sections/insight.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/sections/past_challenges.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/sections/records_activities.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/sections/save_activities.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/sections/start_community.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/sections/start_weekend.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/sections/steps.dart';
import 'package:coral_reef/tracker_screens/exercise_tracker/sections/track_activities.dart';
import 'package:coral_reef/tracker_screens/period_tracker/period_tracker_screen.dart';
import 'package:coral_reef/tracker_screens/period_tracker/sections/login_symptoms.dart';
import 'package:coral_reef/tracker_screens/pregnancy_tracker/pregnancy_tracker_screen.dart';
import 'package:coral_reef/tracker_screens/pregnancy_tracker/sections/tips.dart';
import 'package:coral_reef/tracker_screens/pregnancy_tracker/sections/your_baby.dart';
import 'package:coral_reef/tracker_screens/pregnancy_tracker/sections/your_body.dart';
import 'package:coral_reef/tracker_screens/pregnancy_tracker/sections/your_tips.dart';
import 'package:coral_reef/wallet_screen/sections/receive_token.dart';
import 'package:coral_reef/wallet_screen/sections/setup_pin.dart';
import 'package:coral_reef/wallet_screen/sections/transfer_token.dart';
import 'package:coral_reef/wellness/conceive/conceive_info.dart';
import 'package:coral_reef/wellness/diet_exercise_well_being/diet_exercise_well_being_info.dart';
import 'package:coral_reef/wellness/period/period_info.dart';
import 'package:coral_reef/wellness/pregnancy/pregnancy_info.dart';
import 'package:coral_reef/wellness/onboarding/wellness.dart';
import 'package:coral_reef/wellness/wellness_tracker_options.dart';
import 'package:flutter/widgets.dart';
import 'package:coral_reef/homescreen/Home.dart';

import 'g_chat_screen/GChatScreen.dart';
import 'g_chat_screen/sections/avatar_final_section.dart';
import 'g_chat_screen/sections/create_new_gchat.dart';
import 'g_chat_screen/sections/interested_topics.dart';
import 'tracker_screens/exercise_tracker/sections/start_weekdays.dart';



final Map<String, WidgetBuilder> routes = {
  OnboardScreen.routeName: (context) => OnboardScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  WellnessScreen.routeName: (context) => WellnessScreen(),
  // YearScreen.routeName: (context) => YearScreen(),
  // WeightScreen.routeName: (context) => WeightScreen(),
  // RequiredWeightScreen.routeName: (context) => RequiredWeightScreen(),
  // HeightScreen.routeName: (context) => HeightScreen(),
  PregnancyInfo.routeName: (context) => PregnancyInfo(),
  PeriodInfo.routeName: (context) => PeriodInfo(),
  WellnessTrackerOptions.routeName: (context) => WellnessTrackerOptions(),
  ConceiveInfo.routeName: (context) => ConceiveInfo(),
  DietExerciseWellBeingInfo.routeName: (context) => DietExerciseWellBeingInfo(),
  CoralBottomNavigationBar.routeName: (context) => CoralBottomNavigationBar(),
  GChatScreen.routeName: (context) => GChatScreen(),
  PeriodTrackerScreen.routeName: (context) => PeriodTrackerScreen(),
  LoginSymptoms.routeName: (context) => LoginSymptoms(),
  AvatarFinalSection.routeName: (context) => AvatarFinalSection(),
  InterestedTopics.routeName: (context) => InterestedTopics(),
  CreateNewGChat.routeName: (context) => CreateNewGChat(),
  SetupPin.routeName: (context) => SetupPin(),
  ReceiveWallet.routeName: (context) => ReceiveWallet(),
  TransferToken.routeName: (context) => TransferToken(),
  PregnancyTrackerScreen.routeName: (context) => PregnancyTrackerScreen(),
  YourBaby.routeName: (context) => YourBaby(),
  YourBody.routeName: (context) => YourBody(),
  TipsScreen.routeName: (context) => TipsScreen(),
  YourTips.routeName: (context) => YourTips(),
  Steps.routeName: (context) => Steps(),
  ExerciseInsight.routeName: (context) => ExerciseInsight(),
AllData.routeName: (context) => AllData(),
  TrackActivities.routeName: (context) => TrackActivities(),
  SaveActivities.routeName: (context) => SaveActivities(),
  RecordsActivities.routeName: (context) => RecordsActivities(),
  ChallengePage.routeName: (context) => ChallengePage(),
  CreateChallengePage.routeName: (context) => CreateChallengePage(),
  StartWeekend.routeName: (context) => StartWeekend(),
  StartWeekdays.routeName: (context) => StartWeekdays(),
  StartCommunity.routeName: (context) => StartCommunity(),
  PastChallenges.routeName: (context) => PastChallenges(),
  CoralRewards.routeName: (context) => CoralRewards(),
  ChallengeDetails.routeName: (context) => ChallengeDetails(),
  ChallengeParticipant.routeName: (context) => ChallengeParticipant(),
};
