# GetKnownFolderPathClass

An ANSI, 32-bit Clarion wrapper for the Windows `SHGetKnownFolderPath` API.
`SHGetKnownFolderPath` is looked up in `SHELL32.DLL` at runtime, so an
application can report a clear failure rather than failing during application
startup on systems without the export.

## Layout

| Path | Purpose |
| --- | --- |
| `libsrc\win\KnownFolderPath.inc` | Public API, folder equates, and the `KNOWNFOLDERID` structure |
| `libsrc\win\KnownFolderPath.clw` | Dynamic Shell API loader and ANSI conversion implementation |
| `testing\KnownFolderPathTest.clw` | Test program that lists every supported folder |
| `testing\KnownFolderPathTest.cwproj` | Clarion project definition |
| `testing\KnownFolderPathTest.sln` | Clarion solution file |
| `testing\CLARION120.RED` | Local redirection file for Clarion 12 |
| `testing\CLARION110.RED` | Local redirection file for Clarion 11 |
| `testing\CLARION100.RED` | Local redirection file for Clarion 10 |

## Installation

Copy `KnownFolderPath.inc` and `KnownFolderPath.clw` from `libsrc\win` into
your Clarion `Accessory\LIBSRC\WIN` folder, for example
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
  IF Folders.GetFolder(KnownFolder:Downloads, FolderPath) = KnownFolder:Success
    MESSAGE(FolderPath)
  ELSE
    MESSAGE(Folders.LastError())
  END
```

`GetFolder` returns an HRESULT. A return value of `KnownFolder:Success` means
the supplied `CSTRING` contains the ANSI path. Call `LastError` for a
human-readable failure reason.

Each `KnownFolderPath` object loads `SHELL32.DLL` the first time it is used
and releases it in its destructor. Windows counts these references, so the DLL
stays loaded while any object still needs it. Any number of objects can be
created and disposed in any order.

Because the wrapper is 32-bit, Windows redirects `KnownFolder:ProgramFiles` to
`C:\Program Files (x86)` on 64-bit Windows. This is normal WOW64 behaviour.

The source is ANSI, targeted at 32-bit Windows, and stored with CRLF line
endings.
