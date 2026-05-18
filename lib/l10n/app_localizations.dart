import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'SideQuest'**
  String get appTitle;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'HOME'**
  String get home;

  /// No description provided for @social.
  ///
  /// In en, this message translates to:
  /// **'SOCIAL'**
  String get social;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'CREATE'**
  String get create;

  /// No description provided for @groups.
  ///
  /// In en, this message translates to:
  /// **'GROUPS'**
  String get groups;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'PROFILE'**
  String get profile;

  /// No description provided for @homeNav.
  ///
  /// In en, this message translates to:
  /// **'HOME'**
  String get homeNav;

  /// No description provided for @socialNav.
  ///
  /// In en, this message translates to:
  /// **'SOCIAL'**
  String get socialNav;

  /// No description provided for @createNav.
  ///
  /// In en, this message translates to:
  /// **'CREATE'**
  String get createNav;

  /// No description provided for @groupsNav.
  ///
  /// In en, this message translates to:
  /// **'GROUPS'**
  String get groupsNav;

  /// No description provided for @profileNav.
  ///
  /// In en, this message translates to:
  /// **'PROFILE'**
  String get profileNav;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'LOGIN'**
  String get login;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'SIGN UP'**
  String get signUp;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @loadingDots.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loadingDots;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'ACCEPT'**
  String get accept;

  /// No description provided for @decline.
  ///
  /// In en, this message translates to:
  /// **'DECLINE'**
  String get decline;

  /// No description provided for @complete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get complete;

  /// No description provided for @fail.
  ///
  /// In en, this message translates to:
  /// **'Fail'**
  String get fail;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @messages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// No description provided for @activity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get activity;

  /// No description provided for @noActivitiesYet.
  ///
  /// In en, this message translates to:
  /// **'No activities yet'**
  String get noActivitiesYet;

  /// No description provided for @noMessagesYet.
  ///
  /// In en, this message translates to:
  /// **'No messages yet'**
  String get noMessagesYet;

  /// No description provided for @noMessagesYetSendFirst.
  ///
  /// In en, this message translates to:
  /// **'No messages yet.\nSend the first message.'**
  String get noMessagesYetSendFirst;

  /// No description provided for @you.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get you;

  /// No description provided for @unknownUser.
  ///
  /// In en, this message translates to:
  /// **'Unknown User'**
  String get unknownUser;

  /// No description provided for @groupChat.
  ///
  /// In en, this message translates to:
  /// **'GROUP CHAT'**
  String get groupChat;

  /// No description provided for @directMessage.
  ///
  /// In en, this message translates to:
  /// **'DIRECT MESSAGE'**
  String get directMessage;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @pleaseLogIn.
  ///
  /// In en, this message translates to:
  /// **'Please log in.'**
  String get pleaseLogIn;

  /// No description provided for @youNeedToBeLoggedInToPost.
  ///
  /// In en, this message translates to:
  /// **'You need to be logged in to post.'**
  String get youNeedToBeLoggedInToPost;

  /// No description provided for @youNeedToBeLoggedInToSendMessages.
  ///
  /// In en, this message translates to:
  /// **'You need to be logged in to send messages.'**
  String get youNeedToBeLoggedInToSendMessages;

  /// No description provided for @youNeedToBeLoggedInToViewChat.
  ///
  /// In en, this message translates to:
  /// **'You need to be logged in to view this chat.'**
  String get youNeedToBeLoggedInToViewChat;

  /// No description provided for @youNeedToBeLoggedInToSeeActivity.
  ///
  /// In en, this message translates to:
  /// **'You need to be logged in to see your activity.'**
  String get youNeedToBeLoggedInToSeeActivity;

  /// No description provided for @youNeedToBeLoggedInToSeeChats.
  ///
  /// In en, this message translates to:
  /// **'You need to be logged in to see your chats.'**
  String get youNeedToBeLoggedInToSeeChats;

  /// No description provided for @recordSomethingFirst.
  ///
  /// In en, this message translates to:
  /// **'Record something first.'**
  String get recordSomethingFirst;

  /// No description provided for @addCaption.
  ///
  /// In en, this message translates to:
  /// **'Add a caption...'**
  String get addCaption;

  /// No description provided for @addComment.
  ///
  /// In en, this message translates to:
  /// **'Add a comment...'**
  String get addComment;

  /// No description provided for @typeMessage.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get typeMessage;

  /// No description provided for @searchUsersOrUsernames.
  ///
  /// In en, this message translates to:
  /// **'Search users or usernames...'**
  String get searchUsersOrUsernames;

  /// No description provided for @searchUsersOrConversations.
  ///
  /// In en, this message translates to:
  /// **'Search users or conversations...'**
  String get searchUsersOrConversations;

  /// No description provided for @messageCouldNotBeSent.
  ///
  /// In en, this message translates to:
  /// **'Message could not be sent: {error}'**
  String messageCouldNotBeSent(Object error);

  /// No description provided for @messagesCouldNotBeLoaded.
  ///
  /// In en, this message translates to:
  /// **'Messages could not be loaded.\n{error}'**
  String messagesCouldNotBeLoaded(Object error);

  /// No description provided for @chatsCouldNotBeLoaded.
  ///
  /// In en, this message translates to:
  /// **'Chats could not be loaded.\n{error}'**
  String chatsCouldNotBeLoaded(Object error);

  /// No description provided for @chatCouldNotBeOpened.
  ///
  /// In en, this message translates to:
  /// **'Chat could not be opened: {error}'**
  String chatCouldNotBeOpened(Object error);

  /// No description provided for @couldNotPostSolution.
  ///
  /// In en, this message translates to:
  /// **'Could not post solution: {error}'**
  String couldNotPostSolution(Object error);

  /// No description provided for @couldNotPostAudioSolution.
  ///
  /// In en, this message translates to:
  /// **'Could not post audio solution: {error}'**
  String couldNotPostAudioSolution(Object error);

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'WELCOME BACK'**
  String get welcomeBack;

  /// No description provided for @loginToSideQuest.
  ///
  /// In en, this message translates to:
  /// **'LOGIN TO\nSIDEQUEST'**
  String get loginToSideQuest;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Continue your streak, check your quests and start the next adventure.'**
  String get loginSubtitle;

  /// No description provided for @loginFooter.
  ///
  /// In en, this message translates to:
  /// **'✦   Your next SideQuest is waiting.   ✦'**
  String get loginFooter;

  /// No description provided for @loginWithYourProfile.
  ///
  /// In en, this message translates to:
  /// **'LOGIN WITH YOUR PROFILE'**
  String get loginWithYourProfile;

  /// No description provided for @usernameOrEmail.
  ///
  /// In en, this message translates to:
  /// **'USERNAME OR EMAIL'**
  String get usernameOrEmail;

  /// No description provided for @usernameOrEmailHint.
  ///
  /// In en, this message translates to:
  /// **'username or email@example.com'**
  String get usernameOrEmailHint;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'PASSWORD'**
  String get password;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordHint;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @createProfile.
  ///
  /// In en, this message translates to:
  /// **'CREATE PROFILE'**
  String get createProfile;

  /// No description provided for @enterUsernameEmailPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your username/email and password.'**
  String get enterUsernameEmailPassword;

  /// No description provided for @enterUsernameOrEmailFirst.
  ///
  /// In en, this message translates to:
  /// **'Please enter your username or email address first.'**
  String get enterUsernameOrEmailFirst;

  /// No description provided for @noAccountFound.
  ///
  /// In en, this message translates to:
  /// **'No account found. Please create a profile first.'**
  String get noAccountFound;

  /// No description provided for @wrongPasswordTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Wrong password. Please try again.'**
  String get wrongPasswordTryAgain;

  /// No description provided for @invalidEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'This email address is not valid.'**
  String get invalidEmailAddress;

  /// No description provided for @invalidLoginCredentials.
  ///
  /// In en, this message translates to:
  /// **'Username/email or password is wrong. Please try again.'**
  String get invalidLoginCredentials;

  /// No description provided for @accountDisabled.
  ///
  /// In en, this message translates to:
  /// **'This account has been disabled.'**
  String get accountDisabled;

  /// No description provided for @tooManyAttempts.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please try again later.'**
  String get tooManyAttempts;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your internet connection.'**
  String get networkError;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed. Please try again.'**
  String get loginFailed;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get somethingWentWrong;

  /// No description provided for @passwordResetSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset email has been sent.'**
  String get passwordResetSent;

  /// No description provided for @passwordResetCouldNotSend.
  ///
  /// In en, this message translates to:
  /// **'Could not send password reset email.'**
  String get passwordResetCouldNotSend;

  /// No description provided for @joinTheQuest.
  ///
  /// In en, this message translates to:
  /// **'JOIN THE QUEST'**
  String get joinTheQuest;

  /// No description provided for @createAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'CREATE\nACCOUNT'**
  String get createAccountTitle;

  /// No description provided for @createAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start your adventure and share your daily SideQuests.'**
  String get createAccountSubtitle;

  /// No description provided for @signupFooter.
  ///
  /// In en, this message translates to:
  /// **'✦   Your next SideQuest starts here.   ✦'**
  String get signupFooter;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'FULL NAME'**
  String get fullName;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'USERNAME'**
  String get username;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'EMAIL'**
  String get email;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'CONFIRM PASSWORD'**
  String get confirmPassword;

  /// No description provided for @agreeToThe.
  ///
  /// In en, this message translates to:
  /// **'I agree to the '**
  String get agreeToThe;

  /// No description provided for @termsPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Terms & Privacy Policy'**
  String get termsPrivacyPolicy;

  /// No description provided for @createAccountButton.
  ///
  /// In en, this message translates to:
  /// **'CREATE ACCOUNT'**
  String get createAccountButton;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @logInCaps.
  ///
  /// In en, this message translates to:
  /// **'LOG IN'**
  String get logInCaps;

  /// No description provided for @enterFullName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your full name.'**
  String get enterFullName;

  /// No description provided for @chooseUsername.
  ///
  /// In en, this message translates to:
  /// **'Please choose a username.'**
  String get chooseUsername;

  /// No description provided for @usernameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Your username must be at least 3 characters long.'**
  String get usernameTooShort;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email address.'**
  String get enterEmail;

  /// No description provided for @enterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get enterValidEmail;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter a password.'**
  String get enterPassword;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Your password must be at least 6 characters long.'**
  String get passwordTooShort;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'The passwords do not match.'**
  String get passwordsDoNotMatch;

  /// No description provided for @acceptTerms.
  ///
  /// In en, this message translates to:
  /// **'Please accept the Terms & Privacy Policy.'**
  String get acceptTerms;

  /// No description provided for @emailAlreadyInUse.
  ///
  /// In en, this message translates to:
  /// **'This email is already in use.'**
  String get emailAlreadyInUse;

  /// No description provided for @weakPassword.
  ///
  /// In en, this message translates to:
  /// **'Your password is too weak.'**
  String get weakPassword;

  /// No description provided for @emailSignupDisabled.
  ///
  /// In en, this message translates to:
  /// **'Email signup is not enabled in Firebase.'**
  String get emailSignupDisabled;

  /// No description provided for @signupFailed.
  ///
  /// In en, this message translates to:
  /// **'Signup failed. Please check your details.'**
  String get signupFailed;

  /// No description provided for @todaysMissions.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Missions'**
  String get todaysMissions;

  /// No description provided for @following.
  ///
  /// In en, this message translates to:
  /// **'FOLLOWING'**
  String get following;

  /// No description provided for @forYou.
  ///
  /// In en, this message translates to:
  /// **'FOR YOU'**
  String get forYou;

  /// No description provided for @noPostsYet.
  ///
  /// In en, this message translates to:
  /// **'No posts yet.'**
  String get noPostsYet;

  /// No description provided for @noFollowingPostsYet.
  ///
  /// In en, this message translates to:
  /// **'No posts from people you follow yet.'**
  String get noFollowingPostsYet;

  /// No description provided for @noForYouPostsYet.
  ///
  /// In en, this message translates to:
  /// **'No For You posts yet.'**
  String get noForYouPostsYet;

  /// No description provided for @newSideQuest.
  ///
  /// In en, this message translates to:
  /// **'NEW SIDEQUEST'**
  String get newSideQuest;

  /// No description provided for @questExpiresIn.
  ///
  /// In en, this message translates to:
  /// **'QUEST EXPIRES IN'**
  String get questExpiresIn;

  /// No description provided for @dailySideQuest.
  ///
  /// In en, this message translates to:
  /// **'DAILY SIDEQUEST'**
  String get dailySideQuest;

  /// No description provided for @dailySideQuestCompleted.
  ///
  /// In en, this message translates to:
  /// **'Daily SideQuest completed'**
  String get dailySideQuestCompleted;

  /// No description provided for @comeBackTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Come back tomorrow for a new quest.'**
  String get comeBackTomorrow;

  /// No description provided for @loginToSolveToday.
  ///
  /// In en, this message translates to:
  /// **'Log in to solve today’s SideQuest.'**
  String get loginToSolveToday;

  /// No description provided for @noDailySideQuestFound.
  ///
  /// In en, this message translates to:
  /// **'No Daily SideQuest found.'**
  String get noDailySideQuestFound;

  /// No description provided for @uploadPhotoOrAudio.
  ///
  /// In en, this message translates to:
  /// **'Upload a photo or audio to complete the Daily SideQuest.'**
  String get uploadPhotoOrAudio;

  /// No description provided for @audioSolution.
  ///
  /// In en, this message translates to:
  /// **'Audio Solution'**
  String get audioSolution;

  /// No description provided for @tapToRecord.
  ///
  /// In en, this message translates to:
  /// **'Tap to record'**
  String get tapToRecord;

  /// No description provided for @recordingReady.
  ///
  /// In en, this message translates to:
  /// **'Recording ready'**
  String get recordingReady;

  /// No description provided for @recordingTapToStop.
  ///
  /// In en, this message translates to:
  /// **'Recording... tap to stop'**
  String get recordingTapToStop;

  /// No description provided for @postAudioSolution.
  ///
  /// In en, this message translates to:
  /// **'POST AUDIO SOLUTION'**
  String get postAudioSolution;

  /// No description provided for @postSolution.
  ///
  /// In en, this message translates to:
  /// **'POST SOLUTION'**
  String get postSolution;

  /// No description provided for @votingOpen.
  ///
  /// In en, this message translates to:
  /// **'Voting open'**
  String get votingOpen;

  /// No description provided for @votingClosed.
  ///
  /// In en, this message translates to:
  /// **'Voting closed'**
  String get votingClosed;

  /// No description provided for @notVoted.
  ///
  /// In en, this message translates to:
  /// **'NOT VOTED'**
  String get notVoted;

  /// No description provided for @now.
  ///
  /// In en, this message translates to:
  /// **'now'**
  String get now;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{minutes}m ago'**
  String minutesAgo(Object minutes);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{hours}h ago'**
  String hoursAgo(Object hours);

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{days}d ago'**
  String daysAgo(Object days);

  /// No description provided for @yourActivityCouldNotBeLoaded.
  ///
  /// In en, this message translates to:
  /// **'Your activity could not be loaded.'**
  String get yourActivityCouldNotBeLoaded;

  /// No description provided for @activityCouldNotBeLoaded.
  ///
  /// In en, this message translates to:
  /// **'Activity could not be loaded.'**
  String get activityCouldNotBeLoaded;

  /// No description provided for @youHaveANewFollower.
  ///
  /// In en, this message translates to:
  /// **'You have a new follower.'**
  String get youHaveANewFollower;

  /// No description provided for @follower.
  ///
  /// In en, this message translates to:
  /// **'Follower'**
  String get follower;

  /// No description provided for @like.
  ///
  /// In en, this message translates to:
  /// **'Like'**
  String get like;

  /// No description provided for @yourPost.
  ///
  /// In en, this message translates to:
  /// **'your post'**
  String get yourPost;

  /// No description provided for @userStartedFollowingYou.
  ///
  /// In en, this message translates to:
  /// **'{username} started following you.'**
  String userStartedFollowingYou(Object username);

  /// No description provided for @userLikedYourPost.
  ///
  /// In en, this message translates to:
  /// **'{username} liked your post.'**
  String userLikedYourPost(Object username);

  /// No description provided for @userCommentedOnPost.
  ///
  /// In en, this message translates to:
  /// **'{username} commented on {postTitle}.'**
  String userCommentedOnPost(Object username, Object postTitle);

  /// No description provided for @usersCouldNotBeLoaded.
  ///
  /// In en, this message translates to:
  /// **'Users could not be loaded.'**
  String get usersCouldNotBeLoaded;

  /// No description provided for @noUsersFound.
  ///
  /// In en, this message translates to:
  /// **'No users found.'**
  String get noUsersFound;

  /// No description provided for @noConversationsYet.
  ///
  /// In en, this message translates to:
  /// **'No conversations yet.\nSearch for a user or create a group chat.'**
  String get noConversationsYet;

  /// No description provided for @newGroup.
  ///
  /// In en, this message translates to:
  /// **'NEW GROUP'**
  String get newGroup;

  /// No description provided for @groupCreatedSendFirst.
  ///
  /// In en, this message translates to:
  /// **'Group created. Send the first message.'**
  String get groupCreatedSendFirst;

  /// No description provided for @startNewChat.
  ///
  /// In en, this message translates to:
  /// **'Start a new chat'**
  String get startNewChat;

  /// No description provided for @createGroup.
  ///
  /// In en, this message translates to:
  /// **'CREATE GROUP'**
  String get createGroup;

  /// No description provided for @startNewGroupChat.
  ///
  /// In en, this message translates to:
  /// **'START A NEW GROUP CHAT'**
  String get startNewGroupChat;

  /// No description provided for @groupName.
  ///
  /// In en, this message translates to:
  /// **'GROUP NAME'**
  String get groupName;

  /// No description provided for @groupNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Weekend Warriors'**
  String get groupNameHint;

  /// No description provided for @noUsersSelectedYet.
  ///
  /// In en, this message translates to:
  /// **'No users selected yet.'**
  String get noUsersSelectedYet;

  /// No description provided for @searchUsers.
  ///
  /// In en, this message translates to:
  /// **'Search users...'**
  String get searchUsers;

  /// No description provided for @searchForUsersToAddThem.
  ///
  /// In en, this message translates to:
  /// **'Search for users to add them.'**
  String get searchForUsersToAddThem;

  /// No description provided for @addToGroup.
  ///
  /// In en, this message translates to:
  /// **'Add to group'**
  String get addToGroup;

  /// No description provided for @createGroupChat.
  ///
  /// In en, this message translates to:
  /// **'CREATE GROUP CHAT'**
  String get createGroupChat;

  /// No description provided for @groupChatCouldNotBeCreated.
  ///
  /// In en, this message translates to:
  /// **'Group chat could not be created.'**
  String get groupChatCouldNotBeCreated;

  /// No description provided for @pleaseEnterGroupName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a group name.'**
  String get pleaseEnterGroupName;

  /// No description provided for @pleaseSelectAtLeastOneUser.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one user.'**
  String get pleaseSelectAtLeastOneUser;

  /// No description provided for @inviteCouldNotBeAccepted.
  ///
  /// In en, this message translates to:
  /// **'Invite could not be accepted.'**
  String get inviteCouldNotBeAccepted;

  /// No description provided for @inviteCouldNotBeDeclined.
  ///
  /// In en, this message translates to:
  /// **'Invite could not be declined.'**
  String get inviteCouldNotBeDeclined;

  /// No description provided for @inviteCouldNotBeCompleted.
  ///
  /// In en, this message translates to:
  /// **'Invite could not be completed.'**
  String get inviteCouldNotBeCompleted;

  /// No description provided for @newSideQuestInvitation.
  ///
  /// In en, this message translates to:
  /// **'New SideQuest invitation'**
  String get newSideQuestInvitation;

  /// No description provided for @sideQuestInvite.
  ///
  /// In en, this message translates to:
  /// **'SIDEQUEST INVITE'**
  String get sideQuestInvite;

  /// No description provided for @completeNow.
  ///
  /// In en, this message translates to:
  /// **'Complete Now'**
  String get completeNow;

  /// No description provided for @saveForLater.
  ///
  /// In en, this message translates to:
  /// **'SAVE FOR LATER'**
  String get saveForLater;

  /// No description provided for @readyToStart.
  ///
  /// In en, this message translates to:
  /// **'Ready to start?'**
  String get readyToStart;

  /// No description provided for @readyToStartText.
  ///
  /// In en, this message translates to:
  /// **'This quest begins in groups. Complete the task and upload your proof once your journey begins.'**
  String get readyToStartText;

  /// No description provided for @startGroupChallenge.
  ///
  /// In en, this message translates to:
  /// **'Start Group Challenge'**
  String get startGroupChallenge;

  /// No description provided for @theBrief.
  ///
  /// In en, this message translates to:
  /// **'The Brief'**
  String get theBrief;

  /// No description provided for @questIdeas.
  ///
  /// In en, this message translates to:
  /// **'Quest Ideas'**
  String get questIdeas;

  /// No description provided for @reward.
  ///
  /// In en, this message translates to:
  /// **'Reward'**
  String get reward;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @level.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get level;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'ACCOUNT'**
  String get account;

  /// No description provided for @privacyAndSafety.
  ///
  /// In en, this message translates to:
  /// **'PRIVACY & SAFETY'**
  String get privacyAndSafety;

  /// No description provided for @appExperience.
  ///
  /// In en, this message translates to:
  /// **'APP EXPERIENCE'**
  String get appExperience;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'SUPPORT'**
  String get support;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfile;

  /// No description provided for @editProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Name, username, photo and bio'**
  String get editProfileSubtitle;

  /// No description provided for @emailAndLogin.
  ///
  /// In en, this message translates to:
  /// **'Email & login'**
  String get emailAndLogin;

  /// No description provided for @emailAndLoginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage email, password and sign-in options'**
  String get emailAndLoginSubtitle;

  /// No description provided for @createNewProfile.
  ///
  /// In en, this message translates to:
  /// **'Create New Profile'**
  String get createNewProfile;

  /// No description provided for @createNewProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start A New SideQuest Streak'**
  String get createNewProfileSubtitle;

  /// No description provided for @questPreferences.
  ///
  /// In en, this message translates to:
  /// **'Quest preferences'**
  String get questPreferences;

  /// No description provided for @questPreferencesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Topics, difficulty and daily quest style'**
  String get questPreferencesSubtitle;

  /// No description provided for @pushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push notifications'**
  String get pushNotifications;

  /// No description provided for @pushNotificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Receive updates from SideQuest'**
  String get pushNotificationsSubtitle;

  /// No description provided for @dailySideQuestReminder.
  ///
  /// In en, this message translates to:
  /// **'Daily SideQuest reminder'**
  String get dailySideQuestReminder;

  /// No description provided for @dailySideQuestReminderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get reminded when a new quest starts'**
  String get dailySideQuestReminderSubtitle;

  /// No description provided for @streakWarning.
  ///
  /// In en, this message translates to:
  /// **'Streak warning'**
  String get streakWarning;

  /// No description provided for @streakWarningSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Warn me before my streak expires'**
  String get streakWarningSubtitle;

  /// No description provided for @privateProfile.
  ///
  /// In en, this message translates to:
  /// **'Private profile'**
  String get privateProfile;

  /// No description provided for @privateProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Only approved friends can see your quests'**
  String get privateProfileSubtitle;

  /// No description provided for @allowFriendRequests.
  ///
  /// In en, this message translates to:
  /// **'Allow friend requests'**
  String get allowFriendRequests;

  /// No description provided for @allowFriendRequestsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Let other adventurers send requests'**
  String get allowFriendRequestsSubtitle;

  /// No description provided for @locationHints.
  ///
  /// In en, this message translates to:
  /// **'Location hints'**
  String get locationHints;

  /// No description provided for @locationHintsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use rough location for nearby quest ideas'**
  String get locationHintsSubtitle;

  /// No description provided for @blockedAccounts.
  ///
  /// In en, this message translates to:
  /// **'Blocked accounts'**
  String get blockedAccounts;

  /// No description provided for @blockedAccountsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Review people you have blocked'**
  String get blockedAccountsSubtitle;

  /// No description provided for @hapticFeedback.
  ///
  /// In en, this message translates to:
  /// **'Haptic feedback'**
  String get hapticFeedback;

  /// No description provided for @hapticFeedbackSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Small vibrations for taps and quest actions'**
  String get hapticFeedbackSubtitle;

  /// No description provided for @saveUploadedPhotos.
  ///
  /// In en, this message translates to:
  /// **'Save uploaded photos'**
  String get saveUploadedPhotos;

  /// No description provided for @saveUploadedPhotosSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Keep a local copy after posting a quest'**
  String get saveUploadedPhotosSubtitle;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @appearanceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Dark mode, accent color and app icon'**
  String get appearanceSubtitle;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred app language'**
  String get languageSubtitle;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @helpCenter.
  ///
  /// In en, this message translates to:
  /// **'Help center'**
  String get helpCenter;

  /// No description provided for @helpCenterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get support and read common answers'**
  String get helpCenterSubtitle;

  /// No description provided for @reportProblem.
  ///
  /// In en, this message translates to:
  /// **'Report a problem'**
  String get reportProblem;

  /// No description provided for @reportProblemSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tell us when something does not work'**
  String get reportProblemSubtitle;

  /// No description provided for @aboutSideQuest.
  ///
  /// In en, this message translates to:
  /// **'About SideQuest'**
  String get aboutSideQuest;

  /// No description provided for @aboutSideQuestSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Version, credits and legal information'**
  String get aboutSideQuestSubtitle;

  /// No description provided for @keepExploring.
  ///
  /// In en, this message translates to:
  /// **'SideQuest • Keep exploring'**
  String get keepExploring;

  /// No description provided for @rookieAdventurer.
  ///
  /// In en, this message translates to:
  /// **'Rookie Adventurer'**
  String get rookieAdventurer;

  /// No description provided for @dayStreak.
  ///
  /// In en, this message translates to:
  /// **'{streak} DAY STREAK'**
  String dayStreak(Object streak);

  /// No description provided for @dangerZone.
  ///
  /// In en, this message translates to:
  /// **'Danger zone'**
  String get dangerZone;

  /// No description provided for @dangerZoneSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out or permanently delete your account.'**
  String get dangerZoneSubtitle;

  /// No description provided for @deletingAccount.
  ///
  /// In en, this message translates to:
  /// **'Deleting account...'**
  String get deletingAccount;

  /// No description provided for @logoutFailed.
  ///
  /// In en, this message translates to:
  /// **'Logout failed.'**
  String get logoutFailed;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'LOG OUT'**
  String get logOut;

  /// No description provided for @loggingOut.
  ///
  /// In en, this message translates to:
  /// **'LOGGING OUT'**
  String get loggingOut;

  /// No description provided for @deleteAccountButton.
  ///
  /// In en, this message translates to:
  /// **'DELETE'**
  String get deleteAccountButton;

  /// No description provided for @deleting.
  ///
  /// In en, this message translates to:
  /// **'DELETING'**
  String get deleting;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete account?'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountText.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete your account and your user data. Please enter your password to confirm.'**
  String get deleteAccountText;

  /// No description provided for @noUserLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'No user is logged in.'**
  String get noUserLoggedIn;

  /// No description provided for @accountCannotBeDeletedWithPassword.
  ///
  /// In en, this message translates to:
  /// **'This account cannot be deleted with password confirmation.'**
  String get accountCannotBeDeletedWithPassword;

  /// No description provided for @accountCouldNotBeDeleted.
  ///
  /// In en, this message translates to:
  /// **'Account could not be deleted.'**
  String get accountCouldNotBeDeleted;

  /// No description provided for @wrongPassword.
  ///
  /// In en, this message translates to:
  /// **'The password is incorrect. ({code})'**
  String wrongPassword(Object code);

  /// No description provided for @invalidCredential.
  ///
  /// In en, this message translates to:
  /// **'The password or login method could not be verified. ({code})'**
  String invalidCredential(Object code);

  /// No description provided for @requiresRecentLogin.
  ///
  /// In en, this message translates to:
  /// **'Please log in again before deleting your account.'**
  String get requiresRecentLogin;

  /// No description provided for @userMismatch.
  ///
  /// In en, this message translates to:
  /// **'This password does not belong to the current account.'**
  String get userMismatch;

  /// No description provided for @userNotFound.
  ///
  /// In en, this message translates to:
  /// **'This account no longer exists.'**
  String get userNotFound;

  /// No description provided for @accountCouldNotBeDeletedWithCode.
  ///
  /// In en, this message translates to:
  /// **'Account could not be deleted. ({code})'**
  String accountCouldNotBeDeletedWithCode(Object code);

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'CAMERA'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'GALLERY'**
  String get gallery;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'REMOVE'**
  String get remove;

  /// No description provided for @followers.
  ///
  /// In en, this message translates to:
  /// **'Followers'**
  String get followers;

  /// No description provided for @followingProfile.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get followingProfile;

  /// No description provided for @editProfileCaps.
  ///
  /// In en, this message translates to:
  /// **'EDIT PROFILE'**
  String get editProfileCaps;

  /// No description provided for @checkOutMyProfile.
  ///
  /// In en, this message translates to:
  /// **'Check out my SideQuest profile!'**
  String get checkOutMyProfile;

  /// No description provided for @levelNumber.
  ///
  /// In en, this message translates to:
  /// **'LEVEL {level}'**
  String levelNumber(Object level);

  /// No description provided for @xpUntilLevel.
  ///
  /// In en, this message translates to:
  /// **'{xp} XP until Level {level}'**
  String xpUntilLevel(Object xp, Object level);

  /// No description provided for @sideQuestPosts.
  ///
  /// In en, this message translates to:
  /// **'SideQuest Posts'**
  String get sideQuestPosts;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'SAVE CHANGES'**
  String get saveChanges;

  /// No description provided for @bio.
  ///
  /// In en, this message translates to:
  /// **'BIO'**
  String get bio;

  /// No description provided for @bioHint.
  ///
  /// In en, this message translates to:
  /// **'Tell people about your side quests...'**
  String get bioHint;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'LOCATION'**
  String get location;

  /// No description provided for @searchYourLocation.
  ///
  /// In en, this message translates to:
  /// **'Search your location...'**
  String get searchYourLocation;

  /// No description provided for @website.
  ///
  /// In en, this message translates to:
  /// **'WEBSITE'**
  String get website;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
