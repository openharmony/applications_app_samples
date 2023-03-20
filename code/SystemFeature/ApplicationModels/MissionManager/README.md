# Mission Manager

### Introduction

This sample calls APIs related to the mission manager to lock, unlock, and clear missions, and switch them to the foreground.

### Concepts

Mission manager: You can lock, unlock, and clear missions, and switch them to the foreground.

### Required Permissions

ohos.permission.MANAGE_MISSIONS

### Usage

1. Pull down the sample app to obtain the mission information, including the bundle name, running status, locking status, mission snapshot, and whether the mission supports migration. Information about a maximum of 10 missions can be obtained.

2. Swipe left on the mission list and touch **Lock** to lock a mission.

3. If the mission is locked, touch **Unlock** to unlock it.

4. Touch **Delete** to delete a mission.

5. Touch **Move** to switch a mission to the foreground.

### Constraints

1. This sample can only be run on standard-system devices.

2. This sample supports only the SDK of API version 10 and uses the system API **@ohos.application.missionManager**. Therefore, you must manually switch to the Full SDK for successful compilation. For details about the operation, see [Guide to Switching to Full SDK](https://gitee.com/openharmony/docs/blob/master/en/application-dev/quick-start/full-sdk-switch-guide.md).

3. DevEco Studio 3.1 Canary1 (Build Version: 3.1.0.100) must be used.

4. The permission **ohos.permission.MANAGE_MISSIONS** is at the system_core level. Therefore, you must manually configure the signature for the corresponding permission level. For details about the permission level, see [Permission List](https://gitee.com/openharmony/docs/blob/master/en/application-dev/security/permission-list.md). For details about the configuration operation, see [Having Your App Automatically Signed](https://docs.openharmony.cn/pages/v3.2Beta/en/application-dev/security/hapsigntool-overview.md/).
