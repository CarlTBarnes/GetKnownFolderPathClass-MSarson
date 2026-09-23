! HRESULT values returned by the wrapper.
KnownFolder:Success              EQUATE(0)
KnownFolder:E_Fail               EQUATE(80004005h)
KnownFolder:E_NotInitialized     EQUATE(800401F0h)
KnownFolder:E_InvalidArgument    EQUATE(80070057h)
KnownFolder:E_InsufficientBuffer EQUATE(8007007Ah)

! Values accepted by KnownFolderPath.GetFolder.
KnownFolderNo:FirstFolder          EQUATE(1)
KnownFolderNo:Desktop              EQUATE(1)
KnownFolderNo:Documents            EQUATE(2)
KnownFolderNo:Downloads            EQUATE(3)
KnownFolderNo:Music                EQUATE(4)
KnownFolderNo:Pictures             EQUATE(5)
KnownFolderNo:Videos               EQUATE(6)
KnownFolderNo:Profile              EQUATE(7)
KnownFolderNo:Public               EQUATE(8)
KnownFolderNo:ProgramData          EQUATE(9)
KnownFolderNo:LocalAppData         EQUATE(10)
KnownFolderNo:RoamingAppData       EQUATE(11)
KnownFolderNo:ProgramFiles         EQUATE(12)
KnownFolderNo:ProgramFilesX86      EQUATE(13)
KnownFolderNo:Windows              EQUATE(14)
KnownFolderNo:System               EQUATE(15)
KnownFolderNo:Startup              EQUATE(16)
KnownFolderNo:StartMenu            EQUATE(17)
KnownFolderNo:SendTo               EQUATE(18)
KnownFolderNo:Templates            EQUATE(19)
KnownFolderNo:Links                EQUATE(20)
KnownFolderNo:SavedGames           EQUATE(21)
KnownFolderNo:Contacts             EQUATE(22)
KnownFolderNo:Searches             EQUATE(23)
KnownFolderNo:LastFolder           EQUATE(23)

KNOWNFOLDERID GROUP,TYPE
Data1           ULONG
Data2           USHORT
Data3           USHORT
Data4           BYTE,DIM(8)
               END

KnownFolderPath CLASS,TYPE,MODULE('KnownFolderPath.clw'),LINK('KnownFolderPath.clw',_KFPLinkMode_),DLL(_KFPDllMode_)
Destruct            PROCEDURE
GetFolder           PROCEDURE(LONG FolderNo, *CSTRING FolderPath),LONG,PROC
GetKnownFolderPath  PROCEDURE(*KNOWNFOLDERID FolderId, *CSTRING FolderPath),LONG,PROC
LastError           PROCEDURE(),STRING
SetFolderId         PROCEDURE(LONG FolderNo, *KNOWNFOLDERID FolderId),BOOL
LoadShellApi        PROCEDURE(),BOOL,PRIVATE
ShellModule         LONG,PRIVATE
LastErrorText       STRING(255),PRIVATE
                    END
