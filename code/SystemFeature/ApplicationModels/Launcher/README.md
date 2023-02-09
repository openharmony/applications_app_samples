# Home Screen App

### Introduction

This sample demonstrates a simple home screen app that provides the following functions:

1. Shows all applications installed in the system. You can touch an application icon to launch the application, swipe up an application icon to display a widget, add a widget to the home screen, and remove a widget from the home screen.

2. Implements persistent storage of home screen data. You can uninstall applications, and listen for application installation and uninstall events, and view the home screen changes.

3. Manages recent missions, including locking, unlocking, and clearing a mission, and clearing all missions.

### Concepts

1. The APIs provided by the innerBundleManager module (system capability: SystemCapability.BundleManager.BundleFramework) are used to obtain information about all applications and information about a specific application based on a given bundle name. In this way, all installed applications can be displayed on the home screen. The **on** API is used to listen for application installation and uninstall events, so the home screen refreshes based on the listened events.

2. The **getBundleInstaller** API of the bundle module is used to obtain the bundle installer (system capability: SystemCapability.BundleManager.BundleFramework). The **uninstall** API is used to uninstall an application.

3. The APIs provided by the formHost module (system capability: SystemCapability.Ability.Form) are used to obtain widget information. The **\<FormComponent>** component is used to display the widget content. In this way, widgets can be added to the home screen.

4. The relational database (RDB) APIs (system capability: SystemCapability.DistributedDataManager.RelationalStore.Core) are used to implement persistent storage of home screen data, application location information, and widget information.

5. The APIs provided by the missionManager module (system capability: SystemCapability.Ability.AbilityRuntime.Mission) are used to obtain the latest mission information and implement the functions of locking, unlocking, and clearing background missions.

### Required Permissions

| Permission                                    | Description                                        | Level        |
| ------------------------------------------ | ------------------------------------------------ | ------------ |
| ohos.permission.GET_BUNDLE_INFO_PRIVILEGED | Allows a non-system application to obtain information about other applications.                    | system_basic |
| ohos.permission.LISTEN_BUNDLE_CHANGE       | Allows an application to listen for changes in other applications, when they are installed, updated, or uninstalled.| system_basic |
| ohos.permission.INSTALL_BUNDLE             | Allows an application to install and uninstall other applications.                    | system_core  |
| ohos.permission.MANAGE_MISSIONS            | Allows an application to manage ability mission stacks.                      | system_core  |
| ohos.permission.REQUIRE_FORM               | Allows an application to obtain widgets.                      | system_basic |

### Usage

1. Install the hap file and run the **hdc shell aa start -b ohos.samples.launcher -a MainAbility** command to start the sample app. After the sample app is started, all the applications installed in the system are displayed.

2. Touch an application icon on the home screen to start the application. Alternatively, touch and hold an application icon, and touch **Open** to start the application.

3. For an app that supports widgets, such as **Gallery**, touch and hold the application icon, and touch **Snippets** to enter the widget preview page. Touch **Add to hone screen** to return to the home screen and add the widget to the home screen.

4. For an app that supports widgets, such as **Gallery**, swipe up the application icon to display the default widget. Touch the **+** icon in the upper right corner of the widget to add the widget to the home screen.

5. On the home screen, run the **hdc install** command to install an application. The home screen app listens for the application installation event and displays the application on the home screen when the installation is complete.

6. On the home screen, run the **hdc uninstall** command to uninstall the application installed in Step 5. The home screen app listens for the application uninstall event and removes the application from the home screen when the uninstall is complete.

7. Swipe up in a blank area on the home screen to access the **Recents** page. Swipe down on a mission widget to lock or unlock the widget. Swipe up on a mission widget to clear the background mission. Touch the trash can to clear all the background missions. (Locked apps will not be cleared.)

### Constraints

1. This sample can only be run on standard-system devices.

2. This sample is based on the stage model, which is supported from API version 9.

3. DevEco Studio 3.0 Beta4 (Build version: 3.0.0.992, built on July 14, 2022) must be used.

4. The permissions configured in this sample are at the system_basic or system_core level. Therefore, you must manually configure the signature for the corresponding permission level. For details about the permission level, see [Permission List](https://gitee.com/openharmony/docs/blob/master/en/application-dev/security/permission-list.md). For details about the configuration operation, see [Having Your App Automatically Signed](https://docs.openharmony.cn/pages/v3.2Beta/en/application-dev/security/hapsigntool-overview.md/).

5. This sample uses system APIs, and the Full SDK must be used for compilation. To use the Full SDK, you must manually obtain it from the mirror and switch to it in DevEco Studio. For details, see [Guide to Switching to Full SDK](https://gitee.com/openharmony/docs/blob/master/en/application-dev/quick-start/full-sdk-switch-guide.md).

6. Currently, this sample supports the functions described in Steps 1-6 only.
