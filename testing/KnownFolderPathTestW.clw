  PROGRAM

  INCLUDE('KnownFolderPathW.inc'),ONCE

  MAP
  END

! One name per KnownFolder: equate, in equate order.
FolderNames     GROUP
                  STRING('Desktop        ')
                  STRING('Documents      ')
                  STRING('Downloads      ')
                  STRING('Music          ')
                  STRING('Pictures       ')
                  STRING('Videos         ')
                  STRING('Profile        ')
                  STRING('Public         ')
                  STRING('ProgramData    ')
                  STRING('LocalAppData   ')
                  STRING('RoamingAppData ')
                  STRING('ProgramFiles   ')
                  STRING('ProgramFilesX86')
                  STRING('Windows        ')
                  STRING('System         ')
                  STRING('Startup        ')
                  STRING('StartMenu      ')
                  STRING('SendTo         ')
                  STRING('Templates      ')
                  STRING('Links          ')
                  STRING('SavedGames     ')
                  STRING('Contacts       ')
                  STRING('Searches       ')
                END
FolderName      STRING(15),DIM(KnownFolderNo:LastFolder),OVER(FolderNames)


FolderPath      USTRING(32767)
Report          USTRING(8000)
Folders         KnownFolderPathW
Folder          LONG

  CODE
  SYSTEM{PROP:FontName}='Segoe UI' ; SYSTEM{PROP:FontSize}=11
  SYSTEM{PROP:MsgModeDefault}=MSGMODE:CANCOPY

  LOOP Folder = KnownFolderNo:FirstFolder TO KnownFolderNo:LastFolder
    IF Folders.GetFolderW(Folder, FolderPath) = KnownFolder:Success
      Report = Report & CLIP(FolderName[Folder]) & ': <9>' & FolderPath & '|'
    ELSE
      Report = Report & CLIP(FolderName[Folder]) & ': <9>Error: ' & Folders.LastError() & '|'
    END
  END
  Report = Report & '|GetPathW with backslash: <9>' & Folders.GetPathW(KnownFolderNo:Downloads, TRUE)
  MESSAGE(Report, 'KnownFolderPathW test')
