! HRESULT values returned by the wrapper.
KnownFolder:Success              EQUATE(0)
KnownFolder:E_Fail               EQUATE(80004005h)
KnownFolder:E_NotInitialized     EQUATE(800401F0h)
KnownFolder:E_InvalidArgument    EQUATE(80070057h)
KnownFolder:E_InsufficientBuffer EQUATE(8007007Ah)

! Values accepted by KnownFolderPath.GetFolder.
KnownFolder:FirstFolder          EQUATE(1)
KnownFolder:Desktop              EQUATE(1)
KnownFolder:Documents            EQUATE(2)
KnownFolder:Downloads            EQUATE(3)
KnownFolder:Music                EQUATE(4)
KnownFolder:Pictures             EQUATE(5)
KnownFolder:Videos               EQUATE(6)
KnownFolder:Profile              EQUATE(7)
KnownFolder:Public               EQUATE(8)
KnownFolder:ProgramData          EQUATE(9)
KnownFolder:LocalAppData         EQUATE(10)
KnownFolder:RoamingAppData       EQUATE(11)
KnownFolder:ProgramFiles         EQUATE(12)
KnownFolder:ProgramFilesX86      EQUATE(13)
KnownFolder:Windows              EQUATE(14)
KnownFolder:System               EQUATE(15)
KnownFolder:Startup              EQUATE(16)
KnownFolder:StartMenu            EQUATE(17)
KnownFolder:SendTo               EQUATE(18)
KnownFolder:Templates            EQUATE(19)
KnownFolder:Links                EQUATE(20)
KnownFolder:SavedGames           EQUATE(21)
KnownFolder:Contacts             EQUATE(22)
KnownFolder:Searches             EQUATE(23)
KnownFolder:LastFolder           EQUATE(23)

KNOWNFOLDERID GROUP,TYPE
Data1           ULONG
Data2           USHORT
Data3           USHORT
Data4           BYTE,DIM(8)
               END

KnownFolderPath CLASS,TYPE,MODULE('KnownFolderPath.clw'),LINK('KnownFolderPath.clw',_KFPLinkMode_),DLL(_KFPDllMode_)
Destruct            PROCEDURE
GetFolder           PROCEDURE(LONG Folder, *CSTRING FolderPath),LONG,PROC
GetKnownFolderPath  PROCEDURE(*KNOWNFOLDERID FolderId, *CSTRING FolderPath),LONG,PROC
LastError           PROCEDURE(),STRING
SetFolderId         PROCEDURE(LONG Folder, *KNOWNFOLDERID FolderId),BOOL
LoadShellApi        PROCEDURE(),BOOL,PRIVATE
ShellModule         LONG,PRIVATE
LastErrorText       STRING(255),PRIVATE
                    END
