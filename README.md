# GetKnownFolderPathClass

A 32-bit Clarion wrapper for the Windows `SHGetKnownFolderPath` API.
`SHGetKnownFolderPath` is looked up in `SHELL32.DLL` at runtime, so an
application can report a clear failure rather than failing during application
startup on systems without the export.

There are two classes:

- `KnownFolderPath` returns ANSI paths in a `CSTRING` or `STRING`. It works
  with Clarion 10, 11 and 12.
- `KnownFolderPathW` returns Unicode paths in a `USTRING`, keeping every
  character. It needs a Clarion build with `USTRING` support (the Clarion 12
  Unicode beta). See [Unicode class](#unicode-class-knownfolderpathw).

## Layout

| Path | Purpose |
| --- | --- |
| `libsrc\win\KnownFolderPath.inc` | Public API, folder equates, and the `KNOWNFOLDERID` structure |
| `libsrc\win\KnownFolderPath.clw` | Dynamic Shell API loader and ANSI conversion implementation |
| `libsrc\win\KnownFolderPathW.inc` | Unicode class, derived from `KnownFolderPath` |
| `libsrc\win\KnownFolderPathW.clw` | Unicode class implementation |
| `testing\KnownFolderPathTest.clw` | ANSI test program that lists every supported folder |
| `testing\KnownFolderPathTest.cwproj` | ANSI test project |
| `testing\KnownFolderPathTest.sln` | ANSI test solution |
| `testing\KnownFolderPathTestW.clw` | Unicode test program that lists every supported folder |
| `testing\KnownFolderPathTestW.cwproj` | Unicode test project |
| `testing\KnownFolderPathTestW.sln` | Unicode test solution |
| `testing\CLARION120.RED` | Local redirection file for Clarion 12 |
| `testing\CLARION110.RED` | Local redirection file for Clarion 11 |
| `testing\CLARION100.RED` | Local redirection file for Clarion 10 |

## Installation

Copy `KnownFolderPath.inc` and `KnownFolderPath.clw` from `libsrc\win` into
your Clarion `Accessory\LIBSRC\WIN` folder. For the Unicode class, also copy
`KnownFolderPathW.inc` and `KnownFolderPathW.clw`. For example,
`C:\Clarion\Clarion12\Accessory\LIBSRC\WIN`. Third-party classes belong in
`Accessory` rather than Clarion's own `LIBSRC\WIN`. The default redirection
file already searches that folder, so nothing else needs to be set up.

To use the class without copying it, add this repository's `libsrc\win` folder
to your redirection file instead. The test project does this with a local
redirection file:

```
[Common]
*.inc = .;..\libsrc\win
*.clw = .;..\libsrc\win

{include %REDDIR%\%REDNAME%}
```

The project system only picks up a local redirection file that has the same
name as the IDE's default one, so the test folder has a copy for each version:
`CLARION120.RED` (Clarion 12), `CLARION110.RED` (Clarion 11) and
`CLARION100.RED` (Clarion 10). If you change one, change all three.

## Use

The class uses the usual `LINK`/`DLL` flags, so the project needs these
conditional compile symbols:

```
_KFPLinkMode_=>1
_KFPDllMode_=>0
```

In a multi-DLL application, set `_KFPLinkMode_=>0` and `_KFPDllMode_=>1` in the
applications that import the class from another DLL.

```clarion
  INCLUDE('KnownFolderPath.inc'),ONCE

FolderPath CSTRING(32767)
Folders    KnownFolderPath

  CODE
  IF Folders.GetFolder(KnownFolderNo:Downloads, FolderPath) = KnownFolder:Success
    MESSAGE(FolderPath)
  ELSE
    MESSAGE(Folders.LastError())
  END
```

Folders are chosen with the `KnownFolderNo:` equates, which are plain numbers.
Results are compared against the `KnownFolder:` HRESULT equates, such as
`KnownFolder:Success`. The `KNOWNFOLDERID` GUID for each folder is handled
inside the class, and `GetKnownFolderPath` accepts one directly if you need a
folder that has no equate.

`GetFolder` returns an HRESULT. A return value of `KnownFolder:Success` means
the supplied `CSTRING` contains the ANSI path. On any failure the `CSTRING` is
left blank.

### Getting the path as a string

`GetPath` returns the path directly, or a blank string on failure. Pass `TRUE`
as the second parameter to add a trailing backslash:

```clarion
SaveFile = Folders.GetPath(KnownFolderNo:Downloads, TRUE) & 'Report.pdf'
IF Folders.GetPath(KnownFolderNo:Documents) = ''
  MESSAGE(Folders.LastError())
END
```

### Flags

`GetFolder`, `GetKnownFolderPath` and `GetPath` take an optional `Flags`
parameter. Add flags together to combine them.

| Flag | Effect |
| --- | --- |
| `KnownFolderFlag:Create` | Creates the folder if it doesn't exist yet |
| `KnownFolderFlag:DontVerify` | Returns the path without checking that the folder exists |
| `KnownFolderFlag:DefaultPath` | Returns the default location, ignoring any redirection |

Without flags, Windows checks that the folder exists and the call fails if it
doesn't. Folders such as Saved Games, Contacts or Links may not exist on a new
or managed profile.

```clarion
Rc = Folders.GetFolder(KnownFolderNo:SavedGames, FolderPath, KnownFolderFlag:Create)
```

### Errors

`LastError` returns a readable reason for the last failure. When Windows
reports the error, it includes Windows' own description and the HRESULT in hex,
for example:

```
SHGetKnownFolderPath failed: The system cannot find the file specified. (HRESULT 80070002h)
```

### Characters outside the ANSI code page

Windows returns paths in Unicode, and the class converts them to the ANSI code
page. If the path contains a character the code page can't show, such as a
Polish or Cyrillic user name on a Western European system, the class returns
the folder's short (8.3) path instead, for example `C:\Users\ADAM~1\Documents`.
That path is plain ASCII and refers to the same folder.

If the volume has no short names, the call fails with `KnownFolder:E_NoMapping`
rather than return a path with substituted characters, which would not exist.

`KnownFolderNo:FirstFolder` and `KnownFolderNo:LastFolder` mark the range of
supported folders, so you can loop over all of them:

```clarion
  LOOP Folder = KnownFolderNo:FirstFolder TO KnownFolderNo:LastFolder
    ...
  END
```

Each `KnownFolderPath` object loads `SHELL32.DLL` the first time it is used
and releases it in its destructor. Windows counts these references, so the DLL
stays loaded while any object still needs it. Any number of objects can be
created and disposed in any order.

Because the wrapper is 32-bit, Windows redirects `KnownFolderNo:ProgramFiles` to
`C:\Program Files (x86)` on 64-bit Windows. This is normal WOW64 behaviour.

## Unicode class (KnownFolderPathW)

`KnownFolderPathW` needs a Clarion build with `USTRING` support. It was tested
with the Clarion 12 Unicode beta, build 14313.

Windows returns known folder paths in UTF-16. `KnownFolderPathW` copies them
straight into a `USTRING`, so a path such as `C:\Users\Łukasz\Documents` comes
back exactly, with no code page conversion and no short-name fallback.

```clarion
  INCLUDE('KnownFolderPathW.inc'),ONCE

FolderPath USTRING(32767)
Folders    KnownFolderPathW

  CODE
  IF Folders.GetFolderW(KnownFolderNo:Downloads, FolderPath) = KnownFolder:Success
    MESSAGE(FolderPath)
  ELSE
    MESSAGE(Folders.LastError())
  END
```

`KnownFolderPathW` is derived from `KnownFolderPath`, so it uses the same
`KnownFolderNo:` equates, `KnownFolderFlag:` flags, `KnownFolder:` results and
`LastError`. It adds:

| Method | Returns |
| --- | --- |
| `GetFolderW(FolderNo, *USTRING FolderPath, Flags=0)` | HRESULT, with the path in `FolderPath` |
| `GetKnownFolderPathW(*KNOWNFOLDERID, *USTRING FolderPath, Flags=0)` | HRESULT, for any known folder GUID |
| `GetPathW(FolderNo, AddBackslash=FALSE, Flags=0)` | The path as a `USTRING`, or blank on failure |

The ANSI methods are still available on the same object.

`USTRING(n)` holds `n - 1` characters plus the terminator. If the path doesn't
fit, the call fails with `KnownFolder:E_InsufficientBuffer`.
`USTRING(32767)` fits any Windows path.

`KnownFolderPathW.inc` includes `KnownFolderPath.inc`, and both classes use the
same `_KFPLinkMode_` and `_KFPDllMode_` settings.

## Adding a folder

1. In `KnownFolderPath.inc`, add a `KnownFolderNo:` equate with the next number,
   and set `KnownFolderNo:LastFolder` to that number.
2. In `SetFolderId` in `KnownFolderPath.clw`, add an `OF` branch that calls
   `SetGuid` with the folder's `FOLDERID_` GUID from the Windows SDK header
   `KnownFolders.h`. A hex constant that starts with a letter needs a leading
   `0`, for example `0FDD39AD0h`.
3. In `testing\KnownFolderPathTest.clw` and `testing\KnownFolderPathTestW.clw`,
   add the folder's name to the `FolderNames` group, padded to 15 characters.
   The name array is sized by `KnownFolderNo:LastFolder`, so the tests won't
   compile until you do this.

`KnownFolderPathW` uses the same GUID table, so it picks up the new folder
without any change.

## Source format

The source is ANSI, targeted at 32-bit Windows, and stored with CRLF line
endings. The Clarion compiler rejects files with LF-only line endings, and the
repository's `.gitattributes` makes sure clones and ZIP downloads get CRLF.
