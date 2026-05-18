// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'SideQuest';

  @override
  String get home => 'START';

  @override
  String get social => 'SOZIAL';

  @override
  String get create => 'ERSTELLEN';

  @override
  String get groups => 'GRUPPEN';

  @override
  String get profile => 'PROFIL';

  @override
  String get homeNav => 'START';

  @override
  String get socialNav => 'SOZIAL';

  @override
  String get createNav => 'ERSTELLEN';

  @override
  String get groupsNav => 'GRUPPEN';

  @override
  String get profileNav => 'PROFIL';

  @override
  String get login => 'LOGIN';

  @override
  String get signUp => 'SIGN UP';

  @override
  String get settings => 'Einstellungen';

  @override
  String get loading => 'Lädt...';

  @override
  String get loadingDots => 'Lädt...';

  @override
  String get tryAgain => 'Erneut versuchen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get save => 'Speichern';

  @override
  String get delete => 'Löschen';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get search => 'Suchen';

  @override
  String get send => 'Senden';

  @override
  String get accept => 'ANNEHMEN';

  @override
  String get decline => 'ABLEHNEN';

  @override
  String get complete => 'Geschafft';

  @override
  String get fail => 'Nicht geschafft';

  @override
  String get notifications => 'Benachrichtigungen';

  @override
  String get messages => 'Nachrichten';

  @override
  String get activity => 'Aktivität';

  @override
  String get noActivitiesYet => 'Noch keine Aktivitäten';

  @override
  String get noMessagesYet => 'Noch keine Nachrichten';

  @override
  String get noMessagesYetSendFirst =>
      'Noch keine Nachrichten.\nSchreib die erste Nachricht.';

  @override
  String get you => 'Du';

  @override
  String get unknownUser => 'Unbekannter User';

  @override
  String get groupChat => 'GRUPPENCHAT';

  @override
  String get directMessage => 'DIREKTNACHRICHT';

  @override
  String get chat => 'Chat';

  @override
  String get pleaseLogIn => 'Bitte logge dich ein.';

  @override
  String get youNeedToBeLoggedInToPost =>
      'Du musst eingeloggt sein, um etwas zu posten.';

  @override
  String get youNeedToBeLoggedInToSendMessages =>
      'Du musst eingeloggt sein, um Nachrichten zu senden.';

  @override
  String get youNeedToBeLoggedInToViewChat =>
      'Du musst eingeloggt sein, um diesen Chat zu sehen.';

  @override
  String get youNeedToBeLoggedInToSeeActivity =>
      'Du musst eingeloggt sein, um deine Aktivitäten zu sehen.';

  @override
  String get youNeedToBeLoggedInToSeeChats =>
      'Du musst eingeloggt sein, um deine Chats zu sehen.';

  @override
  String get recordSomethingFirst => 'Nimm zuerst etwas auf.';

  @override
  String get addCaption => 'Beschreibung hinzufügen...';

  @override
  String get addComment => 'Kommentar hinzufügen...';

  @override
  String get typeMessage => 'Nachricht schreiben...';

  @override
  String get searchUsersOrUsernames => 'User oder Usernamen suchen...';

  @override
  String get searchUsersOrConversations => 'User oder Chats suchen...';

  @override
  String messageCouldNotBeSent(Object error) {
    return 'Nachricht konnte nicht gesendet werden: $error';
  }

  @override
  String messagesCouldNotBeLoaded(Object error) {
    return 'Nachrichten konnten nicht geladen werden.\n$error';
  }

  @override
  String chatsCouldNotBeLoaded(Object error) {
    return 'Chats konnten nicht geladen werden.\n$error';
  }

  @override
  String chatCouldNotBeOpened(Object error) {
    return 'Chat konnte nicht geöffnet werden: $error';
  }

  @override
  String couldNotPostSolution(Object error) {
    return 'Lösung konnte nicht gepostet werden: $error';
  }

  @override
  String couldNotPostAudioSolution(Object error) {
    return 'Audio-Lösung konnte nicht gepostet werden: $error';
  }

  @override
  String get welcomeBack => 'WILLKOMMEN ZURÜCK';

  @override
  String get loginToSideQuest => 'BEI SIDEQUEST\nEINLOGGEN';

  @override
  String get loginSubtitle =>
      'Setze deine Streak fort, checke deine Quests und starte das nächste Abenteuer.';

  @override
  String get loginFooter => '✦   Deine nächste SideQuest wartet.   ✦';

  @override
  String get loginWithYourProfile => 'MIT DEINEM PROFIL EINLOGGEN';

  @override
  String get usernameOrEmail => 'USERNAME ODER E-MAIL';

  @override
  String get usernameOrEmailHint => 'username oder email@example.com';

  @override
  String get password => 'PASSWORT';

  @override
  String get passwordHint => 'Passwort';

  @override
  String get rememberMe => 'Eingeloggt bleiben';

  @override
  String get forgotPassword => 'Passwort vergessen?';

  @override
  String get createProfile => 'PROFIL ERSTELLEN';

  @override
  String get enterUsernameEmailPassword =>
      'Bitte gib Username/E-Mail und Passwort ein.';

  @override
  String get enterUsernameOrEmailFirst =>
      'Bitte gib zuerst deinen Username oder deine E-Mail-Adresse ein.';

  @override
  String get noAccountFound =>
      'Kein Account gefunden. Bitte erstelle zuerst ein Profil.';

  @override
  String get wrongPasswordTryAgain =>
      'Falsches Passwort. Bitte versuche es erneut.';

  @override
  String get invalidEmailAddress => 'Diese E-Mail-Adresse ist ungültig.';

  @override
  String get invalidLoginCredentials =>
      'Username/E-Mail oder Passwort ist falsch. Bitte versuche es erneut.';

  @override
  String get accountDisabled => 'Dieser Account wurde deaktiviert.';

  @override
  String get tooManyAttempts =>
      'Zu viele Versuche. Bitte später erneut versuchen.';

  @override
  String get networkError =>
      'Netzwerkfehler. Bitte prüfe deine Internetverbindung.';

  @override
  String get loginFailed => 'Login fehlgeschlagen. Bitte versuche es erneut.';

  @override
  String get somethingWentWrong =>
      'Etwas ist schiefgelaufen. Bitte versuche es erneut.';

  @override
  String get passwordResetSent =>
      'E-Mail zum Zurücksetzen des Passworts wurde gesendet.';

  @override
  String get passwordResetCouldNotSend =>
      'E-Mail zum Zurücksetzen konnte nicht gesendet werden.';

  @override
  String get joinTheQuest => 'JOIN THE QUEST';

  @override
  String get createAccountTitle => 'ACCOUNT\nERSTELLEN';

  @override
  String get createAccountSubtitle =>
      'Starte dein Abenteuer und teile deine täglichen SideQuests.';

  @override
  String get signupFooter => '✦   Deine nächste SideQuest startet hier.   ✦';

  @override
  String get fullName => 'VOLLSTÄNDIGER NAME';

  @override
  String get username => 'USERNAME';

  @override
  String get email => 'E-MAIL';

  @override
  String get confirmPassword => 'PASSWORT BESTÄTIGEN';

  @override
  String get agreeToThe => 'Ich akzeptiere die ';

  @override
  String get termsPrivacyPolicy => 'AGB & Datenschutzrichtlinie';

  @override
  String get createAccountButton => 'ACCOUNT ERSTELLEN';

  @override
  String get alreadyHaveAccount => 'Du hast schon einen Account? ';

  @override
  String get logInCaps => 'EINLOGGEN';

  @override
  String get enterFullName => 'Bitte gib deinen vollständigen Namen ein.';

  @override
  String get chooseUsername => 'Bitte wähle einen Username.';

  @override
  String get usernameTooShort =>
      'Dein Username muss mindestens 3 Zeichen lang sein.';

  @override
  String get enterEmail => 'Bitte gib deine E-Mail-Adresse ein.';

  @override
  String get enterValidEmail => 'Bitte gib eine gültige E-Mail-Adresse ein.';

  @override
  String get enterPassword => 'Bitte gib ein Passwort ein.';

  @override
  String get passwordTooShort =>
      'Dein Passwort muss mindestens 6 Zeichen lang sein.';

  @override
  String get passwordsDoNotMatch => 'Die Passwörter stimmen nicht überein.';

  @override
  String get acceptTerms => 'Bitte akzeptiere die AGB & Datenschutzrichtlinie.';

  @override
  String get emailAlreadyInUse => 'Diese E-Mail wird bereits verwendet.';

  @override
  String get weakPassword => 'Dein Passwort ist zu schwach.';

  @override
  String get emailSignupDisabled =>
      'E-Mail-Registrierung ist in Firebase nicht aktiviert.';

  @override
  String get signupFailed =>
      'Registrierung fehlgeschlagen. Bitte prüfe deine Angaben.';

  @override
  String get todaysMissions => 'Heutige Missionen';

  @override
  String get following => 'FOLGE ICH';

  @override
  String get forYou => 'FÜR DICH';

  @override
  String get noPostsYet => 'Noch keine Beiträge.';

  @override
  String get noFollowingPostsYet =>
      'Noch keine Beiträge von Personen, denen du folgst.';

  @override
  String get noForYouPostsYet => 'Noch keine Für-dich-Beiträge.';

  @override
  String get newSideQuest => 'NEUE SIDEQUEST';

  @override
  String get questExpiresIn => 'QUEST LÄUFT AB IN';

  @override
  String get dailySideQuest => 'TÄGLICHE SIDEQUEST';

  @override
  String get dailySideQuestCompleted => 'Tägliche SideQuest abgeschlossen';

  @override
  String get comeBackTomorrow => 'Komm morgen für eine neue Quest zurück.';

  @override
  String get loginToSolveToday =>
      'Logge dich ein, um die heutige SideQuest zu lösen.';

  @override
  String get noDailySideQuestFound => 'Keine tägliche SideQuest gefunden.';

  @override
  String get uploadPhotoOrAudio =>
      'Lade ein Foto oder Audio hoch, um die tägliche SideQuest abzuschließen.';

  @override
  String get audioSolution => 'Audio-Lösung';

  @override
  String get tapToRecord => 'Zum Aufnehmen tippen';

  @override
  String get recordingReady => 'Aufnahme bereit';

  @override
  String get recordingTapToStop => 'Aufnahme läuft... zum Stoppen tippen';

  @override
  String get postAudioSolution => 'AUDIO-LÖSUNG POSTEN';

  @override
  String get postSolution => 'LÖSUNG POSTEN';

  @override
  String get votingOpen => 'Voting offen';

  @override
  String get votingClosed => 'Voting geschlossen';

  @override
  String get notVoted => 'NICHT ABGESTIMMT';

  @override
  String get now => 'jetzt';

  @override
  String get justNow => 'Gerade eben';

  @override
  String get yesterday => 'Gestern';

  @override
  String minutesAgo(Object minutes) {
    return 'vor $minutes Min.';
  }

  @override
  String hoursAgo(Object hours) {
    return 'vor $hours Std.';
  }

  @override
  String daysAgo(Object days) {
    return 'vor $days Tg.';
  }

  @override
  String get yourActivityCouldNotBeLoaded =>
      'Deine Aktivitäten konnten nicht geladen werden.';

  @override
  String get activityCouldNotBeLoaded =>
      'Aktivitäten konnten nicht geladen werden.';

  @override
  String get youHaveANewFollower => 'Du hast einen neuen Follower.';

  @override
  String get follower => 'Follower';

  @override
  String get like => 'Like';

  @override
  String get yourPost => 'dein Beitrag';

  @override
  String userStartedFollowingYou(Object username) {
    return '$username folgt dir jetzt.';
  }

  @override
  String userLikedYourPost(Object username) {
    return '$username gefällt dein Beitrag.';
  }

  @override
  String userCommentedOnPost(Object username, Object postTitle) {
    return '$username hat $postTitle kommentiert.';
  }

  @override
  String get usersCouldNotBeLoaded => 'User konnten nicht geladen werden.';

  @override
  String get noUsersFound => 'Keine User gefunden.';

  @override
  String get noConversationsYet =>
      'Noch keine Unterhaltungen.\nSuche nach einem User oder erstelle einen Gruppenchat.';

  @override
  String get newGroup => 'NEUE GRUPPE';

  @override
  String get groupCreatedSendFirst =>
      'Gruppe erstellt. Schreib die erste Nachricht.';

  @override
  String get startNewChat => 'Neuen Chat starten';

  @override
  String get createGroup => 'GRUPPE ERSTELLEN';

  @override
  String get startNewGroupChat => 'NEUEN GRUPPENCHAT STARTEN';

  @override
  String get groupName => 'GRUPPENNAME';

  @override
  String get groupNameHint => 'z. B. Weekend Warriors';

  @override
  String get noUsersSelectedYet => 'Noch keine User ausgewählt.';

  @override
  String get searchUsers => 'User suchen...';

  @override
  String get searchForUsersToAddThem =>
      'Suche nach Usern, um sie hinzuzufügen.';

  @override
  String get addToGroup => 'Zur Gruppe hinzufügen';

  @override
  String get createGroupChat => 'GRUPPENCHAT ERSTELLEN';

  @override
  String get groupChatCouldNotBeCreated =>
      'Gruppenchat konnte nicht erstellt werden.';

  @override
  String get pleaseEnterGroupName => 'Bitte gib einen Gruppennamen ein.';

  @override
  String get pleaseSelectAtLeastOneUser =>
      'Bitte wähle mindestens einen User aus.';

  @override
  String get inviteCouldNotBeAccepted =>
      'Einladung konnte nicht angenommen werden.';

  @override
  String get inviteCouldNotBeDeclined =>
      'Einladung konnte nicht abgelehnt werden.';

  @override
  String get inviteCouldNotBeCompleted =>
      'Einladung konnte nicht abgeschlossen werden.';

  @override
  String get newSideQuestInvitation => 'Neue SideQuest-Einladung';

  @override
  String get sideQuestInvite => 'SIDEQUEST-EINLADUNG';

  @override
  String get completeNow => 'Jetzt abschließen';

  @override
  String get saveForLater => 'FÜR SPÄTER SPEICHERN';

  @override
  String get readyToStart => 'Bereit zum Start?';

  @override
  String get readyToStartText =>
      'Diese Quest startet in Gruppen. Erledige die Aufgabe und lade deinen Beweis hoch, sobald die Reise beginnt.';

  @override
  String get startGroupChallenge => 'Gruppen-Challenge starten';

  @override
  String get theBrief => 'Die Aufgabe';

  @override
  String get questIdeas => 'Quest-Ideen';

  @override
  String get reward => 'Belohnung';

  @override
  String get time => 'Zeit';

  @override
  String get level => 'Level';

  @override
  String get account => 'ACCOUNT';

  @override
  String get privacyAndSafety => 'PRIVATSPHÄRE & SICHERHEIT';

  @override
  String get appExperience => 'APP-ERLEBNIS';

  @override
  String get support => 'SUPPORT';

  @override
  String get editProfile => 'Profil bearbeiten';

  @override
  String get editProfileSubtitle => 'Name, Username, Foto und Bio';

  @override
  String get emailAndLogin => 'E-Mail & Login';

  @override
  String get emailAndLoginSubtitle =>
      'E-Mail, Passwort und Anmeldeoptionen verwalten';

  @override
  String get createNewProfile => 'Neues Profil erstellen';

  @override
  String get createNewProfileSubtitle => 'Starte eine neue SideQuest-Streak';

  @override
  String get questPreferences => 'Quest-Einstellungen';

  @override
  String get questPreferencesSubtitle =>
      'Themen, Schwierigkeit und täglicher Quest-Stil';

  @override
  String get pushNotifications => 'Push-Benachrichtigungen';

  @override
  String get pushNotificationsSubtitle => 'Erhalte Updates von SideQuest';

  @override
  String get dailySideQuestReminder => 'Tägliche SideQuest-Erinnerung';

  @override
  String get dailySideQuestReminderSubtitle =>
      'Lass dich erinnern, wenn eine neue Quest startet';

  @override
  String get streakWarning => 'Streak-Warnung';

  @override
  String get streakWarningSubtitle => 'Warne mich, bevor meine Streak abläuft';

  @override
  String get privateProfile => 'Privates Profil';

  @override
  String get privateProfileSubtitle =>
      'Nur akzeptierte Freunde können deine Quests sehen';

  @override
  String get allowFriendRequests => 'Freundschaftsanfragen erlauben';

  @override
  String get allowFriendRequestsSubtitle =>
      'Andere Abenteurer können dir Anfragen senden';

  @override
  String get locationHints => 'Standort-Hinweise';

  @override
  String get locationHintsSubtitle =>
      'Ungefähren Standort für Quest-Ideen in der Nähe nutzen';

  @override
  String get blockedAccounts => 'Blockierte Accounts';

  @override
  String get blockedAccountsSubtitle =>
      'Überprüfe Personen, die du blockiert hast';

  @override
  String get hapticFeedback => 'Haptisches Feedback';

  @override
  String get hapticFeedbackSubtitle =>
      'Kleine Vibrationen bei Taps und Quest-Aktionen';

  @override
  String get saveUploadedPhotos => 'Hochgeladene Fotos speichern';

  @override
  String get saveUploadedPhotosSubtitle =>
      'Nach dem Posten einer Quest lokale Kopie behalten';

  @override
  String get appearance => 'Darstellung';

  @override
  String get appearanceSubtitle => 'Dark Mode, Akzentfarbe und App-Icon';

  @override
  String get dark => 'Dunkel';

  @override
  String get language => 'Sprache';

  @override
  String get languageSubtitle => 'Wähle deine bevorzugte App-Sprache';

  @override
  String get english => 'Englisch';

  @override
  String get helpCenter => 'Hilfe-Center';

  @override
  String get helpCenterSubtitle =>
      'Support erhalten und häufige Antworten lesen';

  @override
  String get reportProblem => 'Problem melden';

  @override
  String get reportProblemSubtitle => 'Sag uns, wenn etwas nicht funktioniert';

  @override
  String get aboutSideQuest => 'Über SideQuest';

  @override
  String get aboutSideQuestSubtitle =>
      'Version, Credits und rechtliche Informationen';

  @override
  String get keepExploring => 'SideQuest • Weiter entdecken';

  @override
  String get rookieAdventurer => 'Rookie Adventurer';

  @override
  String dayStreak(Object streak) {
    return '$streak TAGE STREAK';
  }

  @override
  String get dangerZone => 'Gefahrenzone';

  @override
  String get dangerZoneSubtitle =>
      'Melde dich ab oder lösche deinen Account dauerhaft.';

  @override
  String get deletingAccount => 'Account wird gelöscht...';

  @override
  String get logoutFailed => 'Logout fehlgeschlagen.';

  @override
  String get logOut => 'ABMELDEN';

  @override
  String get loggingOut => 'WIRD ABGEMELDET';

  @override
  String get deleteAccountButton => 'LÖSCHEN';

  @override
  String get deleting => 'WIRD GELÖSCHT';

  @override
  String get deleteAccountTitle => 'Account löschen?';

  @override
  String get deleteAccountText =>
      'Dadurch werden dein Account und deine Nutzerdaten dauerhaft gelöscht. Bitte gib dein Passwort zur Bestätigung ein.';

  @override
  String get noUserLoggedIn => 'Es ist kein User eingeloggt.';

  @override
  String get accountCannotBeDeletedWithPassword =>
      'Dieser Account kann nicht mit Passwortbestätigung gelöscht werden.';

  @override
  String get accountCouldNotBeDeleted =>
      'Account konnte nicht gelöscht werden.';

  @override
  String wrongPassword(Object code) {
    return 'Das Passwort ist falsch. ($code)';
  }

  @override
  String invalidCredential(Object code) {
    return 'Das Passwort oder die Login-Methode konnte nicht bestätigt werden. ($code)';
  }

  @override
  String get requiresRecentLogin =>
      'Bitte logge dich erneut ein, bevor du deinen Account löschst.';

  @override
  String get userMismatch =>
      'Dieses Passwort gehört nicht zum aktuellen Account.';

  @override
  String get userNotFound => 'Dieser Account existiert nicht mehr.';

  @override
  String accountCouldNotBeDeletedWithCode(Object code) {
    return 'Account konnte nicht gelöscht werden. ($code)';
  }

  @override
  String get camera => 'KAMERA';

  @override
  String get gallery => 'GALERIE';

  @override
  String get remove => 'ENTFERNEN';

  @override
  String get followers => 'Follower';

  @override
  String get followingProfile => 'Folgt';

  @override
  String get editProfileCaps => 'PROFIL BEARBEITEN';

  @override
  String get checkOutMyProfile => 'Schau dir mein SideQuest-Profil an!';

  @override
  String levelNumber(Object level) {
    return 'LEVEL $level';
  }

  @override
  String xpUntilLevel(Object xp, Object level) {
    return '$xp XP bis Level $level';
  }

  @override
  String get sideQuestPosts => 'SideQuest-Beiträge';

  @override
  String get saveChanges => 'ÄNDERUNGEN SPEICHERN';

  @override
  String get bio => 'BIO';

  @override
  String get bioHint => 'Erzähl anderen etwas über deine SideQuests...';

  @override
  String get location => 'STANDORT';

  @override
  String get searchYourLocation => 'Standort suchen...';

  @override
  String get website => 'WEBSITE';
}
