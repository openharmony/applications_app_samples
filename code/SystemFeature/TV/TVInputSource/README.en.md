# Input Source Project

### Introduction

The input source app is an OpenHarmony TV sample project with the following core capabilities:

- HDMI / AV / DTV source display and switching.
- Signal status detection, no-signal handling, and auto recovery.
- Lifecycle linkage for binding, unbinding, and event publishing.
- TV-specific API integration (`@ohos.tvservice.*`) and native rendering cooperation.

The application entry is located at `entry/src/main/ets/entryability/EntryAbility.ets`.
The main input source page is `entry/src/main/ets/pages/Index.ets`.
The HDMI page is `entry/src/main/ets/pages/HdmiPage.ets`.
Native extensions are under `entry/src/main/cpp`.

Usage:

1. Install and launch the app, then grant required source-related permissions.
2. Open the index page to view available sources and switch between them.
3. Enter HDMI/DTV pages to trigger signal check and playback-state handling automatically.
4. If no signal is detected, the page shows no-signal hints and supports returning to source list.

### Screenshots
![](./entry/src/main/resources/base/media/page_bg.png)

### Project Structure
```text
entry/src/main/ets/
|---entryability/
|   |---EntryAbility.ets             // Main app entry Ability
|---common
|   |---AutomatedSearch.ets          // Auto search logic
|   |---DeleteChannel.ets            // Channel deletion logic
|   |---DtvNoChannel.ets             // No-channel state
|   |---PointerUtil.ets              // Pointer style utility
|---model
|   |---BaseModel.ets                // Base business model
|   |---InputSourceModel.ets         // Input source model
|---manager
|   |---SourceManager.ets            // Source manager
|   |---PlayerManager.ets            // Playback and event manager
|   |---DtvManager.ets               // DTV business manager
|---pages
|   |---Index.ets                    // Input source index page
|   |---HdmiPage.ets                 // HDMI page
|   |---SearchPage.ets               // Search page
|   |---NoSignal.ets                 // No-signal page
|---controller
|   |---SourceListController.ets     // Source list controller
|---utils
|   |---InputSourceUtil.ets          // Input source utility
|   |---SettingUtil.ets              // Settings read/write and event publish
|   |---KeyEvent.ets                 // Key event injection
|---sdk
|   |---DtvSdk.ets                   // TV-specific declarations

entry/src/ohosTest/ets/test/
|---List.test.ets                    // Test entry
|---*.test.ets                       // Hypium unit and scenario tests
```

### Implementation Details

- Main page logic is in [Index.ets](entry/src/main/ets/pages/Index.ets), including source entrance display, focus management, and page routing.
- HDMI logic is in [HdmiPage.ets](entry/src/main/ets/pages/HdmiPage.ets):
  - Binds source and checks signal after page enters.
  - Switches among playback/search/no-signal states by signal status.
  - Handles Back key and CEC-related behavior.
- Source/device capabilities are in [SourceManager.ets](entry/src/main/ets/manager/SourceManager.ets):
  - Queries supported/available sources and timing info.
  - Manages source-related listeners.
- Playback/event publishing logic is in [PlayerManager.ets](entry/src/main/ets/manager/PlayerManager.ets):
  - Unified bind/unbind entry.
  - Unified play-start/play-end event publishing.
- DTV core logic is in [DtvManager.ets](entry/src/main/ets/manager/DtvManager.ets), including search, channel list, and channel operations.

### Permissions

| Permission | Description | Level |
|---|---|---|
| ohos.permission.MANAGE_MISSIONS | Mission stack management | system_basic |
| ohos.permission.MANAGE_SECURE_SETTINGS | Secure settings management | system_basic |
| ohos.permission.INTERNET | Network access | normal |
| ohos.permission.ACCESS_NOTIFICATION_POLICY | Notification policy access | system_basic |
| ohos.permission.MODIFY_AUDIO_SETTINGS | Audio settings modification | system_basic |
| ohos.permission.MANAGE_AUDIO_CONFIG | Audio configuration management | system_basic |

### Dependencies

- OpenHarmony APIs (ArkUI / AbilityKit / BasicServicesKit / InputKit, etc.)
- Native build chain (`CMakeLists.txt` + `libentry.so`)
- TV-specific declarations (`entry/src/main/ets/sdk/DtvSdk.ets`) for `@ohos.tvservice.*` typing
- Test framework: Hypium (`entry/src/ohosTest`)

### Constraints

1. This sample is intended for OpenHarmony TV scenarios and should run on devices/images with TV input-source capabilities.
2. This sample uses the Stage model, and the project keeps `compileSdkVersion/compatibleSdkVersion/targetSdkVersion` at 18.
3. DevEco Studio 5.0 Release or above is recommended for build and run.
4. Some system-level capabilities require local signing setup according to your device policy before deployment.

### Download

To download only this project, run:

```bash
git init
git config core.sparsecheckout true
echo code/SystemFeature/TV/TVInputSource > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```
