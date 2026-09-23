  MEMBER

  INCLUDE('KnownFolderPath.inc'),ONCE

CP_ACP                        EQUATE(0)
WC_NO_BEST_FIT_CHARS          EQUATE(00000400h)
FORMAT_MESSAGE_IGNORE_INSERTS EQUATE(00000200h)
FORMAT_MESSAGE_FROM_SYSTEM    EQUATE(00001000h)
MAX_LONG_PATH                 EQUATE(32767)

! Filled by GetProcAddress. The DLL attribute on the SHGetKnownFolderPath
! prototype makes the compiler call through this variable, so its NAME must
! match the prototype's NAME exactly.
! Every object holds its own LoadLibrary reference to SHELL32, so the address
! stays valid until the last object frees its reference. It is never cleared,
! because another object may still be using it.
fpSHGetKnownFolderPath LONG,NAME('SHGetKnownFolderPath')

  MAP
    SetGuid(*KNOWNFOLDERID FolderId, ULONG D1, USHORT D2, USHORT D3, BYTE B1, BYTE B2, BYTE B3, BYTE B4, BYTE B5, BYTE B6, BYTE B7, BYTE B8)
    WideToAnsi(LONG WidePath, *CSTRING FolderPath),LONG
    HResultFromWin32(LONG ErrorCode),LONG
    HexLong(LONG Value),STRING
    BufferAddress(*STRING Source),LONG
    MODULE('KERNEL32.DLL')
      LoadLibraryA(*CSTRING),LONG,PASCAL,RAW,NAME('LoadLibraryA')
      GetProcAddress(LONG,*CSTRING),LONG,PASCAL,RAW,NAME('GetProcAddress')
      FreeLibrary(LONG),BOOL,PASCAL,RAW,PROC,NAME('FreeLibrary')
      WideCharToMultiByte(LONG,LONG,LONG,LONG,LONG,LONG,LONG,LONG),LONG,PASCAL,RAW,NAME('WideCharToMultiByte')
      GetShortPathNameW(LONG,LONG,LONG),LONG,PASCAL,RAW,NAME('GetShortPathNameW')
      FormatMessageA(LONG,LONG,LONG,LONG,LONG,LONG,LONG),LONG,PASCAL,RAW,NAME('FormatMessageA')
      GetLastError(),LONG,PASCAL,NAME('GetLastError')
    END
    MODULE('OLE32.DLL')
      CoTaskMemFree(LONG),PASCAL,RAW,NAME('CoTaskMemFree')
    END
    MODULE('SHELL32.DLL')
      SHGetKnownFolderPath(*KNOWNFOLDERID,LONG,LONG,*LONG),LONG,PASCAL,RAW,DLL(1),NAME('SHGetKnownFolderPath')
    END
  END

KnownFolderPath.Destruct PROCEDURE()
  CODE
  IF SELF.ShellModule
    FreeLibrary(SELF.ShellModule)
    SELF.ShellModule = 0
  END
  IF NOT SELF.PathBuffer &= NULL
    DISPOSE(SELF.PathBuffer)
  END

KnownFolderPath.GetFolder PROCEDURE(LONG FolderNo, *CSTRING FolderPath, LONG Flags=0)
FolderId LIKE(KNOWNFOLDERID)
  CODE
  CLEAR(FolderPath)
  IF ~SELF.SetFolderId(FolderNo, FolderId)
    SELF.LastErrorText = 'Unknown KnownFolderNo value: ' & FolderNo
    RETURN KnownFolder:E_InvalidArgument
  END
  RETURN SELF.GetKnownFolderPath(FolderId, FolderPath, Flags)

KnownFolderPath.GetKnownFolderPath PROCEDURE(*KNOWNFOLDERID FolderId, *CSTRING FolderPath, LONG Flags=0)
UnicodePath LONG
Result      LONG
  CODE
  CLEAR(FolderPath)
  SELF.LastErrorText = ''
  IF ~SELF.LoadShellApi()
    RETURN KnownFolder:E_NotInitialized
  END

  UnicodePath = 0
  Result = SHGetKnownFolderPath(FolderId, Flags, 0, UnicodePath)
  IF Result <> KnownFolder:Success
    ! The API may still return a buffer on failure; freeing NULL is harmless.
    CoTaskMemFree(UnicodePath)
    SELF.SetApiError('SHGetKnownFolderPath failed', Result)
    RETURN Result
  END

  Result = SELF.ConvertWidePath(UnicodePath, FolderPath)
  CoTaskMemFree(UnicodePath)
  RETURN Result

! Returns the folder as a string, or blank on failure (call LastError for the
! reason). The text is kept in a buffer owned by the object.
KnownFolderPath.GetPath PROCEDURE(LONG FolderNo, BOOL AddBackslash=FALSE, LONG Flags=0)
  CODE
  IF SELF.PathBuffer &= NULL
    SELF.PathBuffer &= NEW CSTRING(MAX_LONG_PATH)
  END
  IF SELF.GetFolder(FolderNo, SELF.PathBuffer, Flags) <> KnownFolder:Success
    RETURN ''
  END
  IF AddBackslash AND SUB(SELF.PathBuffer, LEN(SELF.PathBuffer), 1) <> '\'
    RETURN SELF.PathBuffer & '\'
  END
  RETURN SELF.PathBuffer

KnownFolderPath.LastError PROCEDURE()
  CODE
  RETURN CLIP(SELF.LastErrorText)

! Converts a UTF-16 path to the ANSI code page. When a character has no ANSI
! equivalent, falls back to the short (8.3) path, which is plain ASCII. Never
! returns a path with substituted characters, because it would not exist.
KnownFolderPath.ConvertWidePath PROCEDURE(LONG WidePath, *CSTRING FolderPath)
Result     LONG
ShortPath  &STRING
ShortChars LONG
  CODE
  Result = WideToAnsi(WidePath, FolderPath)
  IF Result = KnownFolder:E_NoMapping
    ShortChars = GetShortPathNameW(WidePath, 0, 0)
    IF ShortChars > 0
      ShortPath &= NEW STRING(ShortChars * 2)
      IF INRANGE(GetShortPathNameW(WidePath, BufferAddress(ShortPath), ShortChars), 1, ShortChars - 1)
        Result = WideToAnsi(BufferAddress(ShortPath), FolderPath)
      END
      DISPOSE(ShortPath)
    END
  END

  CASE Result
  OF KnownFolder:Success
    RETURN Result
  OF KnownFolder:E_NoMapping
    SELF.LastErrorText = 'The path contains characters that the ANSI code page cannot show, and it has no short (8.3) name.'
  OF KnownFolder:E_InsufficientBuffer
    SELF.LastErrorText = 'The supplied CSTRING is too small for the path.'
  ELSE
    SELF.SetApiError('Could not convert the path to ANSI', Result)
  END
  CLEAR(FolderPath)
  RETURN Result

! Sets LastError to the context, Windows' description of the HRESULT and the
! HRESULT in hex.
KnownFolderPath.SetApiError PROCEDURE(STRING Context, LONG HResult)
MsgText CSTRING(512)
Chars   LONG
  CODE
  Chars = FormatMessageA(FORMAT_MESSAGE_FROM_SYSTEM + FORMAT_MESSAGE_IGNORE_INSERTS, 0, HResult, 0, ADDRESS(MsgText), SIZE(MsgText), 0)
  LOOP WHILE Chars > 0 AND INLIST(VAL(MsgText[Chars]), 10, 13, 32)
    Chars -= 1
  END
  IF Chars > 0
    SELF.LastErrorText = Context & ': ' & SUB(MsgText, 1, Chars) & ' (HRESULT ' & HexLong(HResult) & 'h)'
  ELSE
    SELF.LastErrorText = Context & ' (HRESULT ' & HexLong(HResult) & 'h)'
  END

KnownFolderPath.SetFolderId PROCEDURE(LONG FolderNo, *KNOWNFOLDERID FolderId)
  CODE
  CLEAR(FolderId)
  CASE FolderNo
  OF KnownFolderNo:Desktop
    SetGuid(FolderId, 0B4BFCC3Ah, 0DB2Ch, 0424Ch, 0B0h, 029h, 07Fh, 0E9h, 09Ah, 087h, 0C6h, 041h)
  OF KnownFolderNo:Documents
    SetGuid(FolderId, 0FDD39AD0h, 0238Fh, 046AFh, 0ADh, 0B4h, 06Ch, 085h, 048h, 003h, 069h, 0C7h)
  OF KnownFolderNo:Downloads
    SetGuid(FolderId, 0374DE290h, 0123Fh, 04565h, 091h, 064h, 039h, 0C4h, 092h, 05Eh, 046h, 07Bh)
  OF KnownFolderNo:Music
    SetGuid(FolderId, 04BD8D571h, 06D19h, 048D3h, 0BEh, 097h, 042h, 022h, 020h, 008h, 00Eh, 043h)
  OF KnownFolderNo:Pictures
    SetGuid(FolderId, 033E28130h, 04E1Eh, 04676h, 083h, 05Ah, 098h, 039h, 05Ch, 03Bh, 0C3h, 0BBh)
  OF KnownFolderNo:Videos
    SetGuid(FolderId, 018989B1Dh, 099B5h, 0455Bh, 084h, 01Ch, 0ABh, 07Ch, 074h, 0E4h, 0DDh, 0FCh)
  OF KnownFolderNo:Profile
    SetGuid(FolderId, 05E6C858Fh, 00E22h, 04760h, 09Ah, 0FEh, 0EAh, 033h, 017h, 0B6h, 071h, 073h)
  OF KnownFolderNo:Public
    SetGuid(FolderId, 0DFDF76A2h, 0C82Ah, 04D63h, 090h, 06Ah, 056h, 044h, 0ACh, 045h, 073h, 085h)
  OF KnownFolderNo:ProgramData
    SetGuid(FolderId, 062AB5D82h, 0FDC1h, 04DC3h, 0A9h, 0DDh, 007h, 00Dh, 01Dh, 049h, 05Dh, 097h)
  OF KnownFolderNo:LocalAppData
    SetGuid(FolderId, 0F1B32785h, 06FBAh, 04FCFh, 09Dh, 055h, 07Bh, 08Eh, 07Fh, 015h, 070h, 091h)
  OF KnownFolderNo:RoamingAppData
    SetGuid(FolderId, 03EB685DBh, 065F9h, 04CF6h, 0A0h, 03Ah, 0E3h, 0EFh, 065h, 072h, 09Fh, 03Dh)
  OF KnownFolderNo:ProgramFiles
    SetGuid(FolderId, 0905E63B6h, 0C1BFh, 0494Eh, 0B2h, 09Ch, 065h, 0B7h, 032h, 0D3h, 0D2h, 01Ah)
  OF KnownFolderNo:ProgramFilesX86
    SetGuid(FolderId, 07C5A40EFh, 0A0FBh, 04BFCh, 087h, 04Ah, 0C0h, 0F2h, 0E0h, 0B9h, 0FAh, 08Eh)
  OF KnownFolderNo:Windows
    SetGuid(FolderId, 0F38BF404h, 01D43h, 042F2h, 093h, 005h, 067h, 0DEh, 00Bh, 028h, 0FCh, 023h)
  OF KnownFolderNo:System
    SetGuid(FolderId, 01AC14E77h, 002E7h, 04E5Dh, 0B7h, 044h, 02Eh, 0B1h, 0AEh, 051h, 098h, 0B7h)
  OF KnownFolderNo:Startup
    SetGuid(FolderId, 0B97D20BBh, 0F46Ah, 04C97h, 0BAh, 010h, 05Eh, 036h, 008h, 043h, 008h, 054h)
  OF KnownFolderNo:StartMenu
    SetGuid(FolderId, 0625B53C3h, 0AB48h, 04EC1h, 0BAh, 01Fh, 0A1h, 0EFh, 041h, 046h, 0FCh, 019h)
  OF KnownFolderNo:SendTo
    SetGuid(FolderId, 08983036Ch, 027C0h, 0404Bh, 08Fh, 008h, 010h, 02Dh, 010h, 0DCh, 0FDh, 074h)
  OF KnownFolderNo:Templates
    SetGuid(FolderId, 0A63293E8h, 0664Eh, 048DBh, 0A0h, 079h, 0DFh, 075h, 09Eh, 005h, 009h, 0F7h)
  OF KnownFolderNo:Links
    SetGuid(FolderId, 0BFB9D5E0h, 0C6A9h, 0404Ch, 0B2h, 0B2h, 0AEh, 06Dh, 0B6h, 0AFh, 049h, 068h)
  OF KnownFolderNo:SavedGames
    SetGuid(FolderId, 04C5C32FFh, 0BB9Dh, 043B0h, 0B5h, 0B4h, 02Dh, 072h, 0E5h, 04Eh, 0AAh, 0A4h)
  OF KnownFolderNo:Contacts
    SetGuid(FolderId, 056784854h, 0C6CBh, 0462Bh, 081h, 069h, 088h, 0E3h, 050h, 0ACh, 0B8h, 082h)
  OF KnownFolderNo:Searches
    SetGuid(FolderId, 07D1D3A04h, 0DEBBh, 04115h, 095h, 0CFh, 02Fh, 029h, 0DAh, 029h, 020h, 0DAh)
  ELSE
    RETURN FALSE
  END
  RETURN TRUE

! Takes this object's reference to SHELL32 on first use; Destruct releases it.
KnownFolderPath.LoadShellApi PROCEDURE()
DllName  CSTRING(32)
ProcName CSTRING(32)
ProcAddr LONG
  CODE
  IF SELF.ShellModule
    RETURN TRUE
  END
  DllName = 'SHELL32.DLL'
  SELF.ShellModule = LoadLibraryA(DllName)
  IF ~SELF.ShellModule
    SELF.LastErrorText = 'Could not load SHELL32.DLL.'
    RETURN FALSE
  END
  ProcName = 'SHGetKnownFolderPath'
  ProcAddr = GetProcAddress(SELF.ShellModule, ProcName)
  IF ~ProcAddr
    FreeLibrary(SELF.ShellModule)
    SELF.ShellModule = 0
    SELF.LastErrorText = 'SHELL32.DLL does not export SHGetKnownFolderPath.'
    RETURN FALSE
  END
  fpSHGetKnownFolderPath = ProcAddr
  RETURN TRUE

SetGuid PROCEDURE(*KNOWNFOLDERID FolderId, ULONG D1, USHORT D2, USHORT D3, BYTE B1, BYTE B2, BYTE B3, BYTE B4, BYTE B5, BYTE B6, BYTE B7, BYTE B8)
  CODE
  FolderId.Data1 = D1
  FolderId.Data2 = D2
  FolderId.Data3 = D3
  FolderId.Data4[1] = B1
  FolderId.Data4[2] = B2
  FolderId.Data4[3] = B3
  FolderId.Data4[4] = B4
  FolderId.Data4[5] = B5
  FolderId.Data4[6] = B6
  FolderId.Data4[7] = B7
  FolderId.Data4[8] = B8

! Converts with WC_NO_BEST_FIT_CHARS so that a character with no exact ANSI
! equivalent is reported as unmappable instead of silently becoming a
! look-alike letter (Polish L-with-stroke becoming a plain L, for example).
WideToAnsi PROCEDURE(LONG WidePath, *CSTRING FolderPath)
UsedDefault LONG
Bytes       LONG
  CODE
  Bytes = WideCharToMultiByte(CP_ACP, WC_NO_BEST_FIT_CHARS, WidePath, -1, 0, 0, 0, ADDRESS(UsedDefault))
  IF Bytes = 0
    RETURN HResultFromWin32(GetLastError())
  END
  IF UsedDefault
    RETURN KnownFolder:E_NoMapping
  END
  IF Bytes > SIZE(FolderPath)
    RETURN KnownFolder:E_InsufficientBuffer
  END
  IF WideCharToMultiByte(CP_ACP, WC_NO_BEST_FIT_CHARS, WidePath, -1, ADDRESS(FolderPath), SIZE(FolderPath), 0, ADDRESS(UsedDefault)) = 0
    RETURN HResultFromWin32(GetLastError())
  END
  IF UsedDefault
    RETURN KnownFolder:E_NoMapping
  END
  RETURN KnownFolder:Success

HResultFromWin32 PROCEDURE(LONG ErrorCode)
  CODE
  IF ErrorCode = 0
    RETURN KnownFolder:E_Fail
  END
  IF ErrorCode < 0
    RETURN ErrorCode
  END
  RETURN BOR(BAND(ErrorCode, 0FFFFh), 80070000h)

HexLong PROCEDURE(LONG Value)
Digits STRING('0123456789ABCDEF')
Hex    STRING(8)
I      LONG
  CODE
  LOOP I = 8 TO 1 BY -1
    Hex[I] = Digits[BAND(Value, 0Fh) + 1]
    Value = BSHIFT(Value, -4)
  END
  RETURN Hex

! ADDRESS() of a &STRING reference is ambiguous, so take the address of the
! data through a *STRING parameter instead.
BufferAddress PROCEDURE(*STRING Source)
  CODE
  RETURN ADDRESS(Source)
