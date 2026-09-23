  PROGRAM

  INCLUDE('KnownFolderPath.inc'),ONCE

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
FolderName      STRING(15),DIM(KnownFolder:LastFolder),OVER(FolderNames)

FolderPath      CSTRING(32767)
Report          STRING(8000)
Folders         KnownFolderPath
Folder          LONG

  CODE
  SYSTEM{PROP:FontName}='Segoe UI' ; SYSTEM{PROP:FontSize}=11
  SYSTEM{PROP:MsgModeDefault}=MSGMODE:CANCOPY
  
  !Currently  = KnownFolder:Desktop     TO KnownFolder:Searches
  LOOP Folder = KnownFolder:FirstFolder TO KnownFolder:LastFolder
    IF Folders.GetFolder(Folder, FolderPath) = KnownFolder:Success
      Report = CLIP(Report) & CLIP(FolderName[Folder]) & ': <9>' & FolderPath & '|'
    ELSE
      Report = CLIP(Report) & CLIP(FolderName[Folder]) & ': <9>Error: ' & Folders.LastError() & '|'
    END
  END
  MESSAGE(CLIP(Report), 'KnownFolderPath test')
