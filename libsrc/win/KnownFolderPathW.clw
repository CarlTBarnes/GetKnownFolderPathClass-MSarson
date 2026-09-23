  MEMBER

  INCLUDE('KnownFolderPathW.inc'),ONCE

MAX_LONG_PATH EQUATE(32767)

  MAP
    MODULE('KERNEL32.DLL')
      lstrlenW(LONG),LONG,PASCAL,RAW,NAME('lstrlenW')
      lstrcpynW(*USTRING,LONG,LONG),LONG,PASCAL,RAW,PROC,NAME('lstrcpynW')
    END
    MODULE('OLE32.DLL')
      CoTaskMemFree(LONG),PASCAL,RAW,NAME('CoTaskMemFree')
    END
  END

KnownFolderPathW.Destruct PROCEDURE()
  CODE
  IF NOT SELF.PathBufferW &= NULL
    DISPOSE(SELF.PathBufferW)
  END
  PARENT.Destruct()

KnownFolderPathW.GetFolderW PROCEDURE(LONG FolderNo, *USTRING FolderPath, LONG Flags=0)
FolderId LIKE(KNOWNFOLDERID)
  CODE
  CLEAR(FolderPath)
  IF ~SELF.SetFolderId(FolderNo, FolderId)
    SELF.LastErrorText = 'Unknown KnownFolderNo value: ' & FolderNo
    RETURN KnownFolder:E_InvalidArgument
  END
  RETURN SELF.GetKnownFolderPathW(FolderId, FolderPath, Flags)

KnownFolderPathW.GetKnownFolderPathW PROCEDURE(*KNOWNFOLDERID FolderId, *USTRING FolderPath, LONG Flags=0)
UnicodePath LONG
Result      LONG
  CODE
  CLEAR(FolderPath)
  Result = SELF.QueryFolder(FolderId, Flags, UnicodePath)
  IF Result = KnownFolder:Success
    Result = SELF.CopyWidePath(UnicodePath, FolderPath)
    CoTaskMemFree(UnicodePath)
  END
  RETURN Result

! Returns the folder as a USTRING, or blank on failure (call LastError for the
! reason). The text is kept in a buffer owned by the object.
KnownFolderPathW.GetPathW PROCEDURE(LONG FolderNo, BOOL AddBackslash=FALSE, LONG Flags=0)
Chars LONG
  CODE
  IF SELF.PathBufferW &= NULL
    SELF.PathBufferW &= NEW USTRING(MAX_LONG_PATH)
  END
  IF SELF.GetFolderW(FolderNo, SELF.PathBufferW, Flags) <> KnownFolder:Success
    RETURN U''
  END
  Chars = LEN(SELF.PathBufferW)
  IF AddBackslash AND Chars > 0 AND SELF.PathBufferW[Chars] <> U'\'
    RETURN SELF.PathBufferW & U'\'
  END
  RETURN SELF.PathBufferW

! Copies a null-terminated UTF-16 path into a USTRING without any conversion.
! USTRING(n) holds n-1 characters plus the terminator, and SIZE() is in bytes.
KnownFolderPathW.CopyWidePath PROCEDURE(LONG WidePath, *USTRING FolderPath)
Chars LONG
  CODE
  Chars = lstrlenW(WidePath)
  IF Chars >= SIZE(FolderPath) / 2
    CLEAR(FolderPath)
    SELF.LastErrorText = 'The supplied USTRING is too small for the path.'
    RETURN KnownFolder:E_InsufficientBuffer
  END
  lstrcpynW(FolderPath, WidePath, Chars + 1)
  RETURN KnownFolder:Success
