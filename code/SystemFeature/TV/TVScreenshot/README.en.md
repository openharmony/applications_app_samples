# Screenshot Project

### Introduction

The Screenshot application is a TV screenshot sample project based on the OpenHarmony Stage model. It provides system-level screenshot triggering, floating preview, image saving, and test verification capabilities.

This project consists of the `product/TV` entry module and the `features/screenshot_tv` HAR feature module, and is adapted for large-screen TV scenarios and system capability invocation.

Usage:

1. The service extension receives the system screenshot action, creates a floating window, and starts the screenshot flow.
2. The HAR module encapsulates screenshot capture, image packing, media library writing, and window display logic.
3. The TV page module displays screenshot previews, prompt messages, and save result feedback.
4. Test cases cover model service, performance, compatibility, security, and usability testing scenarios.

### Screenshot Preview
![](screenshots/device/full-screenshot.png)

### Directory Structure
```text
product/TV/src/main/ets/
|---application
|   |---AbilityStage.ets                 // Stage lifecycle entry
|---common
|   |---Constants.ets                    // Preview duration, window size, and other constants
|   |---Log.ets                          // Logging wrapper
|   |---SizeCalc.ets                     // Large-screen size calculation utility
|---pages
|   |---Index.ets                        // Screenshot preview page
|   |---TipPage.ets                      // Screenshot prompt overlay
|---serviceExtAbility
|   |---ServiceExtAbility.ets            // System screenshot service entry
|---vm
|   |---ViewModel.ets                    // Page interaction and flow orchestration

features/screenshot_tv/src/main/ets/
|---common
|   |---Constants.ets                    // HAR shared constants
|   |---Log.ets                          // HAR logging wrapper
|---components
|   |---MainPage.ets                     // HAR sample page
|---model
|   |---ScreenShotModel.ets              // Screenshot core model
```

### Implementation Details

- Application entry and lifecycle management are implemented in [AbilityStage.ets](product/TV/src/main/ets/application/AbilityStage.ets)
    * Responsible for Stage lifecycle initialization
    * Serves as the entry file of the `product/TV` module and matches the `srcEntry` configured in the module file
- The system screenshot service is implemented in [ServiceExtAbility.ets](product/TV/src/main/ets/serviceExtAbility/ServiceExtAbility.ets)
    * Receives the `com.ohos.systemui.action.TOGGLE` action
    * Creates the system floating window and drives the subsequent screenshot, preview, and save flow
- The screenshot core model is implemented in [ScreenShotModel.ets](features/screenshot_tv/src/main/ets/model/ScreenShotModel.ets)
    * Invokes screenshot APIs, packs image data, and saves files into the media library
    * Exposes unified interfaces for window display, window destruction, and Ability launching
- Preview pages and interaction orchestration are implemented in [Index.ets](product/TV/src/main/ets/pages/Index.ets), [TipPage.ets](product/TV/src/main/ets/pages/TipPage.ets), and [ViewModel.ets](product/TV/src/main/ets/vm/ViewModel.ets)
    * `Index.ets` displays the screenshot preview
    * `TipPage.ets` shows save prompts and operation feedback
    * `ViewModel.ets` orchestrates preview closing, image saving, and flow completion

### Required Permissions

| Permission Name                                   | Description                                                     | Level |
|---------------------------------------------------|-----------------------------------------------------------------|-------|
| ohos.permission.MEDIA_LOCATION                    | Allows reading media location information for media library flow | -     |
| ohos.permission.GET_BUNDLE_INFO_PRIVILEGED        | Allows querying system application bundle information           | -     |
| ohos.permission.CAPTURE_SCREEN                    | Allows taking system screenshots                                | -     |
| ohos.permission.START_ABILITIES_FROM_BACKGROUND   | Allows launching related Abilities from the background          | -     |
| ohos.permission.WRITE_IMAGEVIDEO                  | Allows writing screenshot results to the system media library   | -     |
| ohos.permission.SYSTEM_FLOAT_WINDOW               | Allows creating system-level floating preview windows           | -     |
| ohos.permission.CUSTOM_SCREEN_CAPTURE             | Allows requesting customized screen capture capability          | -     |

### Dependencies

This project mainly depends on system capabilities such as `@kit.AbilityKit`, `@kit.ArkUI`, `@kit.ImageKit`, `@kit.MediaLibraryKit`, `@kit.CoreFileKit`, and `@kit.BasicServicesKit`, and reuses the screenshot core logic through the `features/screenshot_tv` HAR module.

### Constraints

1. This sample only supports running on standard systems and supports the following devices: RK3568 and V900.

2. This sample uses the Stage model, supports the API 10 SDK, SDK version (API Version 12 Release), and image version (5.0 Release).

3. This sample must be compiled and run with DevEco Studio 5.0 Release or later.

4. Some interfaces in this sample require a system application signature. For details, refer to [Special Permission Configuration Guide](https://gitcode.com/openharmony/docs/blob/master/zh-cn/device-dev/subsystems/subsys-app-privilege-config-guide.md), and change the `apl` field in the configuration file to `system_core`.

### Download

To download this project separately, run the following commands:

```bash
git init
git config core.sparsecheckout true
echo code/SystemFeature/TV/TVScreenshot > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```
