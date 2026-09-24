#### Mapping between the legacy `CSIDL` identifiers and their modern `FOLDERID` (Known Folder) equivalents Created by Gemini.

Link to CSIDL https://learn.microsoft.com/en-us/windows/win32/shell/csidl

[CSIDL Table on MSDN](https://learn.microsoft.com/en-us/windows/win32/shell/csidl)
[Known Folder Table on MSDN](https://learn.microsoft.com/en-us/windows/win32/shell/knownfolderid)

| Legacy CSIDL | Known Folder (FOLDERID) |
| --- | --- |
| `CSIDL_ADMINTOOLS` | `FOLDERID_AdminTools` |
| `CSIDL_APPDATA` | `FOLDERID_RoamingAppData` |
| `CSIDL_BITBUCKET` | `FOLDERID_RecycleBinFolder` |
| `CSIDL_CDBURN_AREA` | `FOLDERID_CDBurning` |
| `CSIDL_COMMON_ADMINTOOLS` | `FOLDERID_CommonAdminTools` |
| `CSIDL_COMMON_APPDATA` | `FOLDERID_ProgramData` |
| `CSIDL_COMMON_DESKTOPDIRECTORY` | `FOLDERID_PublicDesktop` |
| `CSIDL_COMMON_DOCUMENTS` | `FOLDERID_PublicDocuments` |
| `CSIDL_COMMON_MUSIC` | `FOLDERID_PublicMusic` |
| `CSIDL_COMMON_OEM_LINKS` | `FOLDERID_CommonOEMLinks` |
| `CSIDL_COMMON_PICTURES` | `FOLDERID_PublicPictures` |
| `CSIDL_COMMON_PROGRAMS` | `FOLDERID_CommonPrograms` |
| `CSIDL_COMMON_STARTMENU` | `FOLDERID_CommonStartMenu` |
| `CSIDL_COMMON_STARTUP` | `FOLDERID_CommonStartup` |
| `CSIDL_COMMON_TEMPLATES` | `FOLDERID_CommonTemplates` |
| `CSIDL_COMMON_VIDEO` | `FOLDERID_PublicVideos` |
| `CSIDL_CONNECTIONS` | `FOLDERID_ConnectionsFolder` |
| `CSIDL_CONTROLS` | `FOLDERID_ControlPanelFolder` |
| `CSIDL_COOKIES` | `FOLDERID_Cookies` |
| `CSIDL_DESKTOP` | `FOLDERID_Desktop` |
| `CSIDL_DESKTOPDIRECTORY` | `FOLDERID_Desktop` |
| `CSIDL_DRIVES` | `FOLDERID_ComputerFolder` |
| `CSIDL_FONTS` | `FOLDERID_Fonts` |
| `CSIDL_HISTORY` | `FOLDERID_History` |
| `CSIDL_INTERNET` | `FOLDERID_InternetFolder` |
| `CSIDL_INTERNET_CACHE` | `FOLDERID_InternetCache` |
| `CSIDL_LOCAL_APPDATA` | `FOLDERID_LocalAppData` |
| `CSIDL_MYDOCUMENTS` | `FOLDERID_Documents` |
| `CSIDL_MYMUSIC` | `FOLDERID_Music` |
| `CSIDL_MYPICTURES` | `FOLDERID_Pictures` |
| `CSIDL_MYVIDEO` | `FOLDERID_Videos` |
| `CSIDL_NETHOOD` | `FOLDERID_NetHood` |
| `CSIDL_NETWORK` | `FOLDERID_NetworkFolder` |
| `CSIDL_PERSONAL` | `FOLDERID_Documents` |
| `CSIDL_PRINTERS` | `FOLDERID_PrintersFolder` |
| `CSIDL_PRINTHOOD` | `FOLDERID_PrintHood` |
| `CSIDL_PROFILE` | `FOLDERID_Profile` |
| `CSIDL_PROFILES` | `FOLDERID_UserProfiles` |
| `CSIDL_PROGRAM_FILES` | `FOLDERID_ProgramFiles` |
| `CSIDL_PROGRAM_FILES_COMMON` | `FOLDERID_ProgramFilesCommon` |
| `CSIDL_PROGRAM_FILESX86` | `FOLDERID_ProgramFilesX86` |
| `CSIDL_PROGRAM_FILES_COMMONX86` | `FOLDERID_ProgramFilesCommonX86` |
| `CSIDL_PROGRAMS` | `FOLDERID_Programs` |
| `CSIDL_RECENT` | `FOLDERID_Recent` |
| `CSIDL_RESOURCES` | `FOLDERID_ResourceDir` |
| `CSIDL_RESOURCES_LOCALIZED` | `FOLDERID_LocalizedResourcesDir` |
| `CSIDL_SENDTO` | `FOLDERID_SendTo` |
| `CSIDL_STARTMENU` | `FOLDERID_StartMenu` |
| `CSIDL_STARTUP` | `FOLDERID_Startup` |
| `CSIDL_SYSTEM` | `FOLDERID_System` |
| `CSIDL_SYSTEMX86` | `FOLDERID_SystemX86` |
| `CSIDL_TEMPLATES` | `FOLDERID_Templates` |
| `CSIDL_WINDOWS` | `FOLDERID_Windows` |

*(Note: `CSIDL_PERSONAL` and `CSIDL_MYDOCUMENTS` both map to `FOLDERID_Documents`. Similarly, `CSIDL_DESKTOP` and `CSIDL_DESKTOPDIRECTORY` both map to `FOLDERID_Desktop` in the Known Folders system.)*
___
| Known Folder (FOLDERID) | Legacy CSIDL |
| --- | --- |
| `FOLDERID_AdminTools` | `CSIDL_ADMINTOOLS` |
| `FOLDERID_CDBurning` | `CSIDL_CDBURN_AREA` |
| `FOLDERID_CommonAdminTools` | `CSIDL_COMMON_ADMINTOOLS` |
| `FOLDERID_CommonOEMLinks` | `CSIDL_COMMON_OEM_LINKS` |
| `FOLDERID_CommonPrograms` | `CSIDL_COMMON_PROGRAMS` |
| `FOLDERID_CommonStartMenu` | `CSIDL_COMMON_STARTMENU` |
| `FOLDERID_CommonStartup` | `CSIDL_COMMON_STARTUP` |
| `FOLDERID_CommonTemplates` | `CSIDL_COMMON_TEMPLATES` |
| `FOLDERID_ComputerFolder` | `CSIDL_DRIVES` |
| `FOLDERID_ConnectionsFolder` | `CSIDL_CONNECTIONS` |
| `FOLDERID_ControlPanelFolder` | `CSIDL_CONTROLS` |
| `FOLDERID_Cookies` | `CSIDL_COOKIES` |
| `FOLDERID_Desktop` | `CSIDL_DESKTOP` or `CSIDL_DESKTOPDIRECTORY` |
| `FOLDERID_Documents` | `CSIDL_MYDOCUMENTS` or `CSIDL_PERSONAL` |
| `FOLDERID_Fonts` | `CSIDL_FONTS` |
| `FOLDERID_History` | `CSIDL_HISTORY` |
| `FOLDERID_InternetCache` | `CSIDL_INTERNET_CACHE` |
| `FOLDERID_InternetFolder` | `CSIDL_INTERNET` |
| `FOLDERID_LocalAppData` | `CSIDL_LOCAL_APPDATA` |
| `FOLDERID_LocalizedResourcesDir` | `CSIDL_RESOURCES_LOCALIZED` |
| `FOLDERID_Music` | `CSIDL_MYMUSIC` |
| `FOLDERID_NetHood` | `CSIDL_NETHOOD` |
| `FOLDERID_NetworkFolder` | `CSIDL_NETWORK` |
| `FOLDERID_Pictures` | `CSIDL_MYPICTURES` |
| `FOLDERID_PrintersFolder` | `CSIDL_PRINTERS` |
| `FOLDERID_PrintHood` | `CSIDL_PRINTHOOD` |
| `FOLDERID_Profile` | `CSIDL_PROFILE` |
| `FOLDERID_ProgramData` | `CSIDL_COMMON_APPDATA` |
| `FOLDERID_ProgramFiles` | `CSIDL_PROGRAM_FILES` |
| `FOLDERID_ProgramFilesCommon` | `CSIDL_PROGRAM_FILES_COMMON` |
| `FOLDERID_ProgramFilesCommonX86` | `CSIDL_PROGRAM_FILES_COMMONX86` |
| `FOLDERID_ProgramFilesX86` | `CSIDL_PROGRAM_FILESX86` |
| `FOLDERID_Programs` | `CSIDL_PROGRAMS` |
| `FOLDERID_PublicDesktop` | `CSIDL_COMMON_DESKTOPDIRECTORY` |
| `FOLDERID_PublicDocuments` | `CSIDL_COMMON_DOCUMENTS` |
| `FOLDERID_PublicMusic` | `CSIDL_COMMON_MUSIC` |
| `FOLDERID_PublicPictures` | `CSIDL_COMMON_PICTURES` |
| `FOLDERID_PublicVideos` | `CSIDL_COMMON_VIDEO` |
| `FOLDERID_Recent` | `CSIDL_RECENT` |
| `FOLDERID_RecycleBinFolder` | `CSIDL_BITBUCKET` |
| `FOLDERID_ResourceDir` | `CSIDL_RESOURCES` |
| `FOLDERID_RoamingAppData` | `CSIDL_APPDATA` |
| `FOLDERID_SendTo` | `CSIDL_SENDTO` |
| `FOLDERID_StartMenu` | `CSIDL_STARTMENU` |
| `FOLDERID_Startup` | `CSIDL_STARTUP` |
| `FOLDERID_System` | `CSIDL_SYSTEM` |
| `FOLDERID_SystemX86` | `CSIDL_SYSTEMX86` |
| `FOLDERID_Templates` | `CSIDL_TEMPLATES` |
| `FOLDERID_UserProfiles` | `CSIDL_PROFILES` |
| `FOLDERID_Videos` | `CSIDL_MYVIDEO` |
| `FOLDERID_Windows` | `CSIDL_WINDOWS` |