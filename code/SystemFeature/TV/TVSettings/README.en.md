# Settings Project

### Introduction

Settings is a preinstalled system application in OpenHarmony. It provides users with an entry for configuring system properties, covering common system setting capabilities such as system sound, screen brightness, wired networks, wireless networks, Bluetooth connections, device name, time, and date.

This project is a TV-form settings application sample adapted for TV remote-control interaction and large-screen UI presentation.

Usage:

1. The home page adopts TV-style focus interaction and supports switching between setting entries with the remote control.
2. The network pages support configuration and status viewing for wired networks, wireless networks, and hotspots.
3. The display pages support image parameter settings such as HDMI, HDR, color temperature, display area, and display standard.
4. System, Bluetooth, volume, input source, and factory reset capabilities can all be managed through their corresponding pages.

### Project Structure
```text
product/tv/src/main/ets/
|---Application
|   |---AbilityStage.ets                 // Application lifecycle entry
|---MainAbility
|   |---AbilityContextManager.ets        // Ability context management
|   |---BluetoothPairDialogAbility.ets   // Bluetooth pairing dialog ability
|   |---MainAbility.ets                  // Main ability
|---common
|   |---constants/                       // Constant definitions
|   |---BytesFormatManager.ets           // Data formatting utility
|   |---DateUtil.ets                     // Date utility
|   |---EventUtil.ets                    // Event utility
|   |---UserStorageManager.ets           // User storage management
|---controller
|   |---bluetooth/                       // Bluetooth control logic
|   |---password/                        // Password verification logic
|   |---restoreFactorySettings/          // Factory reset control logic
|---default
|   |---layout/                          // TV default layout components
|   |---model/                           // TV default layout models
|---enterpriseadminability
|   |---EnterpriseAdminAbility.ets       // Enterprise administration capability
|---model
|   |---aboutDeviceImpl/                 // Device information models
|   |---bluetoothImpl/                   // Bluetooth data models
|   |---display/                         // Display setting models
|   |---general/                         // General setting models
|   |---wifiImpl/                        // Wi-Fi setting models
|---pages
|   |---bluetooth/                       // Bluetooth pages
|   |---display/                         // Display pages
|   |---general/                         // General setting pages
|   |---hotspot/                         // Hotspot pages
|   |---network/                         // Network pages
|   |---system/                          // System pages
|   |---volume/                          // Volume pages
|   |---SettingList.ets                  // Settings list entry page
```

### Implementation Details

- The application entry and lifecycle management capability is encapsulated in [MainAbility.ets](product/tv/src/main/ets/MainAbility/MainAbility.ets)
    * It is responsible for main page startup, window initialization, and launching the TV-side application entry.
    * It works with [AbilityStage.ets](product/tv/src/main/ets/Application/AbilityStage.ets) to manage the Stage lifecycle.
- The settings home page and list rendering capability is encapsulated in [EntrySetting.ets](product/tv/src/main/ets/default/layout/EntrySetting.ets)
    * It provides the TV-style settings home page entry and focus-switching logic.
    * It works with `SettingItemTvComponent` and `SettingListTvComponent` to complete settings item rendering and interaction.
- The network and connectivity capability is encapsulated in [Network.ets](product/tv/src/main/ets/pages/network/Network.ets)
    * It supports network configuration pages for wired networks, Wi-Fi, hotspots, IP, gateway, and DNS.
    * Network data processing depends on model capabilities such as `WifiModel` and `WifiProvider`.
- The Bluetooth, display, and system setting capabilities are encapsulated in [BluetoothDeviceEntry.ets](product/tv/src/main/ets/pages/bluetooth/BluetoothDeviceEntry.ets), [Display.ets](product/tv/src/main/ets/pages/display/Display.ets), and [System.ets](product/tv/src/main/ets/pages/system/System.ets)
    * The Bluetooth pages support device discovery, pairing, and connection management.
    * The display pages support image capability configuration such as HDR, color temperature, HDMI, and display area.
    * The system pages support system settings such as device information, time and date, and software updates.

### Related Permissions

| Permission | Description | Level |
|------------|-------------|-------|
| ohos.permission.MANAGE_WIFI_CONNECTION | Allows the application to manage Wi-Fi connections. | - |
| ohos.permission.MANAGE_BLUETOOTH | Allows the application to manage Bluetooth devices and connections. | - |
| ohos.permission.FACTORY_RESET | Allows the application to perform factory reset related operations. | - |
| ohos.permission.MODIFY_AUDIO_SETTINGS | Allows the application to modify system audio and volume settings. | - |

### Dependencies

This project mainly depends on common modules such as `common/component`, `common/search`, `common/settingsBase`, and `common/utils`, and combines system settings related capability APIs to implement TV-side features.

### Constraints

1. This sample only supports running on the standard system and supports the following devices: RK3568 and V900.

2. This sample uses the Stage model, supports the API 10 SDK, with SDK version API Version 12 Release and image version 5.0 Release.

3. This sample requires DevEco Studio 5.0 Release or later to compile and run.

4. Some APIs used in this sample require system application signing configuration. For details, refer to [Special Permission Configuration Guide](https://gitcode.com/openharmony/docs/blob/master/zh-cn/device-dev/subsystems/subsys-app-privilege-config-guide.md), and change the `apl` field in the configuration file to `system_core`.

### Download

To download this project separately, run the following commands:

```bash
git init
git config core.sparsecheckout true
echo code/BasicFeature/TV/TVSettings > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```
