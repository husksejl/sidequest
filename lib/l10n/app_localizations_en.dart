// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'SideQuest';

  @override
  String get home => 'HOME';

  @override
  String get social => 'SOCIAL';

  @override
  String get create => 'CREATE';

  @override
  String get groups => 'GROUPS';

  @override
  String get profile => 'PROFILE';

  @override
  String get homeNav => 'HOME';

  @override
  String get socialNav => 'SOCIAL';

  @override
  String get createNav => 'CREATE';

  @override
  String get groupsNav => 'GROUPS';

  @override
  String get profileNav => 'PROFILE';

  @override
  String get login => 'LOGIN';

  @override
  String get signUp => 'SIGN UP';

  @override
  String get settings => 'Settings';

  @override
  String get loading => 'Loading...';

  @override
  String get loadingDots => 'Loading...';

  @override
  String get tryAgain => 'Try again';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get search => 'Search';

  @override
  String get send => 'Send';

  @override
  String get accept => 'ACCEPT';

  @override
  String get decline => 'DECLINE';

  @override
  String get complete => 'Complete';

  @override
  String get fail => 'Fail';

  @override
  String get notifications => 'Notifications';

  @override
  String get messages => 'Messages';

  @override
  String get activity => 'Activity';

  @override
  String get noActivitiesYet => 'No activities yet';

  @override
  String get noMessagesYet => 'No messages yet';

  @override
  String get noMessagesYetSendFirst =>
      'No messages yet.\nSend the first message.';

  @override
  String get you => 'You';

  @override
  String get unknownUser => 'Unknown User';

  @override
  String get groupChat => 'GROUP CHAT';

  @override
  String get directMessage => 'DIRECT MESSAGE';

  @override
  String get chat => 'Chat';

  @override
  String get pleaseLogIn => 'Please log in.';

  @override
  String get youNeedToBeLoggedInToPost => 'You need to be logged in to post.';

  @override
  String get youNeedToBeLoggedInToSendMessages =>
      'You need to be logged in to send messages.';

  @override
  String get youNeedToBeLoggedInToViewChat =>
      'You need to be logged in to view this chat.';

  @override
  String get youNeedToBeLoggedInToSeeActivity =>
      'You need to be logged in to see your activity.';

  @override
  String get youNeedToBeLoggedInToSeeChats =>
      'You need to be logged in to see your chats.';

  @override
  String get recordSomethingFirst => 'Record something first.';

  @override
  String get addCaption => 'Add a caption...';

  @override
  String get addComment => 'Add a comment...';

  @override
  String get typeMessage => 'Type a message...';

  @override
  String get searchUsersOrUsernames => 'Search users or usernames...';

  @override
  String get searchUsersOrConversations => 'Search users or conversations...';

  @override
  String messageCouldNotBeSent(Object error) {
    return 'Message could not be sent: $error';
  }

  @override
  String messagesCouldNotBeLoaded(Object error) {
    return 'Messages could not be loaded.\n$error';
  }

  @override
  String chatsCouldNotBeLoaded(Object error) {
    return 'Chats could not be loaded.\n$error';
  }

  @override
  String chatCouldNotBeOpened(Object error) {
    return 'Chat could not be opened: $error';
  }

  @override
  String couldNotPostSolution(Object error) {
    return 'Could not post solution: $error';
  }

  @override
  String couldNotPostAudioSolution(Object error) {
    return 'Could not post audio solution: $error';
  }

  @override
  String get welcomeBack => 'WELCOME BACK';

  @override
  String get loginToSideQuest => 'LOGIN TO\nSIDEQUEST';

  @override
  String get loginSubtitle =>
      'Continue your streak, check your quests and start the next adventure.';

  @override
  String get loginFooter => '✦   Your next SideQuest is waiting.   ✦';

  @override
  String get loginWithYourProfile => 'LOGIN WITH YOUR PROFILE';

  @override
  String get usernameOrEmail => 'USERNAME OR EMAIL';

  @override
  String get usernameOrEmailHint => 'username or email@example.com';

  @override
  String get password => 'PASSWORD';

  @override
  String get passwordHint => 'Password';

  @override
  String get rememberMe => 'Remember me';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get createProfile => 'CREATE PROFILE';

  @override
  String get enterUsernameEmailPassword =>
      'Please enter your username/email and password.';

  @override
  String get enterUsernameOrEmailFirst =>
      'Please enter your username or email address first.';

  @override
  String get noAccountFound =>
      'No account found. Please create a profile first.';

  @override
  String get wrongPasswordTryAgain => 'Wrong password. Please try again.';

  @override
  String get invalidEmailAddress => 'This email address is not valid.';

  @override
  String get invalidLoginCredentials =>
      'Username/email or password is wrong. Please try again.';

  @override
  String get accountDisabled => 'This account has been disabled.';

  @override
  String get tooManyAttempts => 'Too many attempts. Please try again later.';

  @override
  String get networkError =>
      'Network error. Please check your internet connection.';

  @override
  String get loginFailed => 'Login failed. Please try again.';

  @override
  String get somethingWentWrong => 'Something went wrong. Please try again.';

  @override
  String get passwordResetSent => 'Password reset email has been sent.';

  @override
  String get passwordResetCouldNotSend =>
      'Could not send password reset email.';

  @override
  String get joinTheQuest => 'JOIN THE QUEST';

  @override
  String get createAccountTitle => 'CREATE\nACCOUNT';

  @override
  String get createAccountSubtitle =>
      'Start your adventure and share your daily SideQuests.';

  @override
  String get signupFooter => '✦   Your next SideQuest starts here.   ✦';

  @override
  String get fullName => 'FULL NAME';

  @override
  String get username => 'USERNAME';

  @override
  String get email => 'EMAIL';

  @override
  String get confirmPassword => 'CONFIRM PASSWORD';

  @override
  String get agreeToThe => 'I agree to the ';

  @override
  String get termsPrivacyPolicy => 'Terms & Privacy Policy';

  @override
  String get createAccountButton => 'CREATE ACCOUNT';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get logInCaps => 'LOG IN';

  @override
  String get enterFullName => 'Please enter your full name.';

  @override
  String get chooseUsername => 'Please choose a username.';

  @override
  String get usernameTooShort =>
      'Your username must be at least 3 characters long.';

  @override
  String get enterEmail => 'Please enter your email address.';

  @override
  String get enterValidEmail => 'Please enter a valid email address.';

  @override
  String get enterPassword => 'Please enter a password.';

  @override
  String get passwordTooShort =>
      'Your password must be at least 6 characters long.';

  @override
  String get passwordsDoNotMatch => 'The passwords do not match.';

  @override
  String get acceptTerms => 'Please accept the Terms & Privacy Policy.';

  @override
  String get emailAlreadyInUse => 'This email is already in use.';

  @override
  String get weakPassword => 'Your password is too weak.';

  @override
  String get emailSignupDisabled => 'Email signup is not enabled in Firebase.';

  @override
  String get signupFailed => 'Signup failed. Please check your details.';

  @override
  String get todaysMissions => 'Today\'s Missions';

  @override
  String get following => 'FOLLOWING';

  @override
  String get forYou => 'FOR YOU';

  @override
  String get noPostsYet => 'No posts yet.';

  @override
  String get noFollowingPostsYet => 'No posts from people you follow yet.';

  @override
  String get noForYouPostsYet => 'No For You posts yet.';

  @override
  String get newSideQuest => 'NEW SIDEQUEST';

  @override
  String get questExpiresIn => 'QUEST EXPIRES IN';

  @override
  String get dailySideQuest => 'DAILY SIDEQUEST';

  @override
  String get dailySideQuestCompleted => 'Daily SideQuest completed';

  @override
  String get comeBackTomorrow => 'Come back tomorrow for a new quest.';

  @override
  String get loginToSolveToday => 'Log in to solve today’s SideQuest.';

  @override
  String get noDailySideQuestFound => 'No Daily SideQuest found.';

  @override
  String get uploadPhotoOrAudio =>
      'Upload a photo or audio to complete the Daily SideQuest.';

  @override
  String get audioSolution => 'Audio Solution';

  @override
  String get tapToRecord => 'Tap to record';

  @override
  String get recordingReady => 'Recording ready';

  @override
  String get recordingTapToStop => 'Recording... tap to stop';

  @override
  String get postAudioSolution => 'POST AUDIO SOLUTION';

  @override
  String get postSolution => 'POST SOLUTION';

  @override
  String get votingOpen => 'Voting open';

  @override
  String get votingClosed => 'Voting closed';

  @override
  String get notVoted => 'NOT VOTED';

  @override
  String get now => 'now';

  @override
  String get justNow => 'Just now';

  @override
  String get yesterday => 'Yesterday';

  @override
  String minutesAgo(Object minutes) {
    return '${minutes}m ago';
  }

  @override
  String hoursAgo(Object hours) {
    return '${hours}h ago';
  }

  @override
  String daysAgo(Object days) {
    return '${days}d ago';
  }

  @override
  String get yourActivityCouldNotBeLoaded =>
      'Your activity could not be loaded.';

  @override
  String get activityCouldNotBeLoaded => 'Activity could not be loaded.';

  @override
  String get youHaveANewFollower => 'You have a new follower.';

  @override
  String get follower => 'Follower';

  @override
  String get like => 'Like';

  @override
  String get yourPost => 'your post';

  @override
  String userStartedFollowingYou(Object username) {
    return '$username started following you.';
  }

  @override
  String userLikedYourPost(Object username) {
    return '$username liked your post.';
  }

  @override
  String userCommentedOnPost(Object username, Object postTitle) {
    return '$username commented on $postTitle.';
  }

  @override
  String get usersCouldNotBeLoaded => 'Users could not be loaded.';

  @override
  String get noUsersFound => 'No users found.';

  @override
  String get noConversationsYet =>
      'No conversations yet.\nSearch for a user or create a group chat.';

  @override
  String get newGroup => 'NEW GROUP';

  @override
  String get groupCreatedSendFirst => 'Group created. Send the first message.';

  @override
  String get startNewChat => 'Start a new chat';

  @override
  String get createGroup => 'CREATE GROUP';

  @override
  String get startNewGroupChat => 'START A NEW GROUP CHAT';

  @override
  String get groupName => 'GROUP NAME';

  @override
  String get groupNameHint => 'e.g. Weekend Warriors';

  @override
  String get noUsersSelectedYet => 'No users selected yet.';

  @override
  String get searchUsers => 'Search users...';

  @override
  String get searchForUsersToAddThem => 'Search for users to add them.';

  @override
  String get addToGroup => 'Add to group';

  @override
  String get createGroupChat => 'CREATE GROUP CHAT';

  @override
  String get groupChatCouldNotBeCreated => 'Group chat could not be created.';

  @override
  String get pleaseEnterGroupName => 'Please enter a group name.';

  @override
  String get pleaseSelectAtLeastOneUser => 'Please select at least one user.';

  @override
  String get inviteCouldNotBeAccepted => 'Invite could not be accepted.';

  @override
  String get inviteCouldNotBeDeclined => 'Invite could not be declined.';

  @override
  String get inviteCouldNotBeCompleted => 'Invite could not be completed.';

  @override
  String get newSideQuestInvitation => 'New SideQuest invitation';

  @override
  String get sideQuestInvite => 'SIDEQUEST INVITE';

  @override
  String get completeNow => 'Complete Now';

  @override
  String get saveForLater => 'SAVE FOR LATER';

  @override
  String get readyToStart => 'Ready to start?';

  @override
  String get readyToStartText =>
      'This quest begins in groups. Complete the task and upload your proof once your journey begins.';

  @override
  String get startGroupChallenge => 'Start Group Challenge';

  @override
  String get theBrief => 'The Brief';

  @override
  String get questIdeas => 'Quest Ideas';

  @override
  String get reward => 'Reward';

  @override
  String get time => 'Time';

  @override
  String get level => 'Level';

  @override
  String get account => 'ACCOUNT';

  @override
  String get privacyAndSafety => 'PRIVACY & SAFETY';

  @override
  String get appExperience => 'APP EXPERIENCE';

  @override
  String get support => 'SUPPORT';

  @override
  String get editProfile => 'Edit profile';

  @override
  String get editProfileSubtitle => 'Name, username, photo and bio';

  @override
  String get emailAndLogin => 'Email & login';

  @override
  String get emailAndLoginSubtitle =>
      'Manage email, password and sign-in options';

  @override
  String get createNewProfile => 'Create New Profile';

  @override
  String get createNewProfileSubtitle => 'Start A New SideQuest Streak';

  @override
  String get questPreferences => 'Quest preferences';

  @override
  String get questPreferencesSubtitle =>
      'Topics, difficulty and daily quest style';

  @override
  String get pushNotifications => 'Push notifications';

  @override
  String get pushNotificationsSubtitle => 'Receive updates from SideQuest';

  @override
  String get dailySideQuestReminder => 'Daily SideQuest reminder';

  @override
  String get dailySideQuestReminderSubtitle =>
      'Get reminded when a new quest starts';

  @override
  String get streakWarning => 'Streak warning';

  @override
  String get streakWarningSubtitle => 'Warn me before my streak expires';

  @override
  String get privateProfile => 'Private profile';

  @override
  String get privateProfileSubtitle =>
      'Only approved friends can see your quests';

  @override
  String get allowFriendRequests => 'Allow friend requests';

  @override
  String get allowFriendRequestsSubtitle =>
      'Let other adventurers send requests';

  @override
  String get locationHints => 'Location hints';

  @override
  String get locationHintsSubtitle =>
      'Use rough location for nearby quest ideas';

  @override
  String get blockedAccounts => 'Blocked accounts';

  @override
  String get blockedAccountsSubtitle => 'Review people you have blocked';

  @override
  String get hapticFeedback => 'Haptic feedback';

  @override
  String get hapticFeedbackSubtitle =>
      'Small vibrations for taps and quest actions';

  @override
  String get saveUploadedPhotos => 'Save uploaded photos';

  @override
  String get saveUploadedPhotosSubtitle =>
      'Keep a local copy after posting a quest';

  @override
  String get appearance => 'Appearance';

  @override
  String get appearanceSubtitle => 'Dark mode, accent color and app icon';

  @override
  String get dark => 'Dark';

  @override
  String get language => 'Language';

  @override
  String get languageSubtitle => 'Choose your preferred app language';

  @override
  String get english => 'English';

  @override
  String get helpCenter => 'Help center';

  @override
  String get helpCenterSubtitle => 'Get support and read common answers';

  @override
  String get reportProblem => 'Report a problem';

  @override
  String get reportProblemSubtitle => 'Tell us when something does not work';

  @override
  String get aboutSideQuest => 'About SideQuest';

  @override
  String get aboutSideQuestSubtitle => 'Version, credits and legal information';

  @override
  String get keepExploring => 'SideQuest • Keep exploring';

  @override
  String get rookieAdventurer => 'Rookie Adventurer';

  @override
  String dayStreak(Object streak) {
    return '$streak DAY STREAK';
  }

  @override
  String get dangerZone => 'Danger zone';

  @override
  String get dangerZoneSubtitle =>
      'Sign out or permanently delete your account.';

  @override
  String get deletingAccount => 'Deleting account...';

  @override
  String get logoutFailed => 'Logout failed.';

  @override
  String get logOut => 'LOG OUT';

  @override
  String get loggingOut => 'LOGGING OUT';

  @override
  String get deleteAccountButton => 'DELETE';

  @override
  String get deleting => 'DELETING';

  @override
  String get deleteAccountTitle => 'Delete account?';

  @override
  String get deleteAccountText =>
      'This will permanently delete your account and your user data. Please enter your password to confirm.';

  @override
  String get noUserLoggedIn => 'No user is logged in.';

  @override
  String get accountCannotBeDeletedWithPassword =>
      'This account cannot be deleted with password confirmation.';

  @override
  String get accountCouldNotBeDeleted => 'Account could not be deleted.';

  @override
  String wrongPassword(Object code) {
    return 'The password is incorrect. ($code)';
  }

  @override
  String invalidCredential(Object code) {
    return 'The password or login method could not be verified. ($code)';
  }

  @override
  String get requiresRecentLogin =>
      'Please log in again before deleting your account.';

  @override
  String get userMismatch =>
      'This password does not belong to the current account.';

  @override
  String get userNotFound => 'This account no longer exists.';

  @override
  String accountCouldNotBeDeletedWithCode(Object code) {
    return 'Account could not be deleted. ($code)';
  }

  @override
  String get camera => 'CAMERA';

  @override
  String get gallery => 'GALLERY';

  @override
  String get remove => 'REMOVE';

  @override
  String get followers => 'Followers';

  @override
  String get followingProfile => 'Following';

  @override
  String get editProfileCaps => 'EDIT PROFILE';

  @override
  String get checkOutMyProfile => 'Check out my SideQuest profile!';

  @override
  String levelNumber(Object level) {
    return 'LEVEL $level';
  }

  @override
  String xpUntilLevel(Object xp, Object level) {
    return '$xp XP until Level $level';
  }

  @override
  String get sideQuestPosts => 'SideQuest Posts';

  @override
  String get saveChanges => 'SAVE CHANGES';

  @override
  String get bio => 'BIO';

  @override
  String get bioHint => 'Tell people about your side quests...';

  @override
  String get location => 'LOCATION';

  @override
  String get searchYourLocation => 'Search your location...';

  @override
  String get website => 'WEBSITE';
}
