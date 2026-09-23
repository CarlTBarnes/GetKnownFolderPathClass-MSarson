! Unicode (USTRING) version of KnownFolderPath. Requires a Clarion build with
! USTRING support (Clarion 12 Unicode beta). Paths are copied from Windows as
! UTF-16, so every character is kept, whatever the ANSI code page.
!
! The folder equates, flags, HRESULT values, KNOWNFOLDERID and the ANSI
! methods all come from KnownFolderPath.inc.

  INCLUDE('KnownFolderPath.inc'),ONCE

KnownFolderPathW CLASS(KnownFolderPath),TYPE,MODULE('KnownFolderPathW.clw'),LINK('KnownFolderPathW.clw',_KFPLinkMode_),DLL(_KFPDllMode_)
Destruct             PROCEDURE,DERIVED
GetFolderW           PROCEDURE(LONG FolderNo, *USTRING FolderPath, LONG Flags=0),LONG,PROC
GetKnownFolderPathW  PROCEDURE(*KNOWNFOLDERID FolderId, *USTRING FolderPath, LONG Flags=0),LONG,PROC
GetPathW             PROCEDURE(LONG FolderNo, BOOL AddBackslash=FALSE, LONG Flags=0),USTRING
CopyWidePath         PROCEDURE(LONG WidePath, *USTRING FolderPath),LONG,PROTECTED
PathBufferW          &USTRING,PRIVATE
                     END
