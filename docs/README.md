## KnownFolders.h from the Windows SDK


The [Known Folder Table on MSDN](https://learn.microsoft.com/en-us/windows/win32/shell/knownfolderid) shows 100+ vertical tables of 7 items (Constant, Display Name, Folder Type, Default Path, CSIDL Equivalent, Legacy Display Name, Legacy Default Path)) for each of the 100+ Folder ID's. 

Click on this link to view a [single markdown table transposed into colmums](MsdnKnownFoldFormatted.md) a sample of four rows appears below:

| Constant           | Display Name| Folder Type | Default Path                                     | CSIDL Equivalent                       | Legacy Display Name | Legacy Default Path                |
| :------------------| :-----------| :---------- | :------------------------------------------------| :--------------------------------------| :-------------------| :----------------------------------|
|`FOLDERID_Desktop`  | Desktop     | PerUser     | `%USERPROFILE%\Desktop`                          | `CSIDL_DESKTOP, CSIDL\DESKTOPDIRECTORY`| Desktop             | `%USERPROFILE%\Desktop`            |
|`FOLDERID_Programs` | Programs    | PerUser     | `%APPDATA%\Microsoft\Windows\Start Menu\Programs`| `CSIDL_PROGRAMS`                       | Programs            | `%USERPROFILE%\Start Menu\Programs`|
|`FOLDERID_StartMenu`| Start Menu  | PerUser     | `%APPDATA%\Microsoft\Windows\Start Menu`         | `CSIDL_STARTMENU`                      | Start Menu          | `%USERPROFILE%\Start Menu`         |
|`FOLDERID_Documents`| Documents   | PerUser     | `%USERPROFILE%\Documents`                        | `CSIDL_MYDOCUMENTS, CSIDL\PERSONAL`    | My Documents        | `%USERPROFILE%\My Documents`       |

___
## KnownFolders.h
In this Repo Docs folder are two SDK files you can view:
* [KnownFolders_SDK_81.h](KnownFolders_SDK_81.h) from the Windows SDK for Version 8.1 dated 9/14/2014
* [KnownFolders_SDK_11.h](KnownFolders_SDK_81.h) from the Windows SDK for Version 11 (10.0.28000) dated 8/12/2026

KnownFolders.h in the SDK has the code to define the ID's from the GUID's for C Code. It defines the ID's for use with this kind of code on two lines with a `\\comment` then macro with the GUID.

```cpp
// {B4BFCC3A-DB2C-424C-B029-7FE99A87C641}
DEFINE_KNOWN_FOLDER(FOLDERID_Desktop,     0xB4BFCC3A, 0xDB2C, 0x424C, 0xB0, 0x29, 0x7F, 0xE9, 0x9A, 0x87, 0xC6, 0x41);
// {A77F5D77-2E2B-44C3-A6A2-ABA601054A51}
DEFINE_KNOWN_FOLDER(FOLDERID_Programs,    0xA77F5D77, 0x2E2B, 0x44C3, 0xA6, 0xA2, 0xAB, 0xA6, 0x01, 0x05, 0x4A, 0x51);
// {625B53C3-AB48-4EC1-BA1F-A1EF4146FC19}
DEFINE_KNOWN_FOLDER(FOLDERID_StartMenu,   0x625B53C3, 0xAB48, 0x4EC1, 0xBA, 0x1F, 0xA1, 0xEF, 0x41, 0x46, 0xFC, 0x19);
// {FDD39AD0-238F-46AF-ADB4-6C85480369C7}
DEFINE_KNOWN_FOLDER(FOLDERID_Documents,   0xFDD39AD0, 0x238F, 0x46AF, 0xAD, 0xB4, 0x6C, 0x85, 0x48, 0x03, 0x69, 0xC7);
```

To make that easier to review the [KnownFolders_ID_Guid.md](KnownFolders_ID_Guid.md) markdown file organizes that into a single row like below:
| Known Folder Define  | GUID Split into Integer Parameters C/C++ Style                   | GUID                                   |
|----------------------|------------------------------------------------------------------|----------------------------------------|
|`FOLDERID_Desktop`    |`0xB4BFCC3A 0xDB2C 0x424C 0xB0 0x29 0x7F 0xE9 0x9A 0x87 0xC6 0x41`|`{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}`|
|`FOLDERID_Programs`   |`0xA77F5D77 0x2E2B 0x44C3 0xA6 0xA2 0xAB 0xA6 0x01 0x05 0x4A 0x51`|`{A77F5D77-2E2B-44C3-A6A2-ABA601054A51}`|
|`FOLDERID_StartMenu`  |`0x625B53C3 0xAB48 0x4EC1 0xBA 0x1F 0xA1 0xEF 0x41 0x46 0xFC 0x19`|`{625B53C3-AB48-4EC1-BA1F-A1EF4146FC19}`|
|`FOLDERID_Documents`  |`0xFDD39AD0 0x238F 0x46AF 0xAD 0xB4 0x6C 0x85 0x48 0x03 0x69 0xC7`|`{FDD39AD0-238F-46AF-ADB4-6C85480369C7}`|

Down farther is another list with the C Hex 0x### in Clarion ###h format. These Hex values were used in the Known Folders class to call SetGuid().

| Known Folder Define  | GUID Split into Integer Parameters Clarion Syntax                          | GUID                                   |
|--------------------- |----------------------------------------------------------------------------|----------------------------------------|
|`FOLDERID_Desktop`    |`0B4BFCC3Ah, 0DB2Ch, 0424Ch, 0B0h, 029h, 07Fh, 0E9h, 09Ah, 087h, 0C6h, 041h`|`{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}`|
|`FOLDERID_Programs`   |`0A77F5D77h, 02E2Bh, 044C3h, 0A6h, 0A2h, 0ABh, 0A6h, 001h, 005h, 04Ah, 051h`|`{A77F5D77-2E2B-44C3-A6A2-ABA601054A51}`|
|`FOLDERID_StartMenu`  |`0625B53C3h, 0AB48h, 04EC1h, 0BAh, 01Fh, 0A1h, 0EFh, 041h, 046h, 0FCh, 019h`|`{625B53C3-AB48-4EC1-BA1F-A1EF4146FC19}`|
|`FOLDERID_Documents`  |`0FDD39AD0h, 0238Fh, 046AFh, 0ADh, 0B4h, 06Ch, 085h, 048h, 003h, 069h, 0C7h`|`{FDD39AD0-238F-46AF-ADB4-6C85480369C7}`|

___
## CSIDL to Known Folder Map and Reverse
Finaly check out the mapping of the old CSIDL to Known Folders (and the opposite) made by Gemini theh editted in [CSIDL_to_KnownFolders.md](CSIDL_to_KnownFolders.md)

| Legacy CSIDL     | Known Folder  |
| --- | --- |
| `CSIDL_DESKTOP`  | `FOLDERID_Desktop` |
| `CSIDL_PROGRAMS` | `FOLDERID_Programs` |
| `CSIDL_STARTMENU`| `FOLDERID_StartMenu` |
| `CSIDL_PERSONAL` | `FOLDERID_Documents` |

| Known Folder         | Legacy CSIDL       | Duplicate CSIDL |
| --- | --- | --- |
| `FOLDERID_Desktop`   | `CSIDL_DESKTOP`    |`CSIDL_DESKTOPDIRECTORY`|
| `FOLDERID_Programs`  | `CSIDL_PROGRAMS`   |
| `FOLDERID_StartMenu` | `CSIDL_STARTMENU`  |
| `FOLDERID_Documents` | `CSIDL_MYDOCUMENTS`| `CSIDL_PERSONAL` |
