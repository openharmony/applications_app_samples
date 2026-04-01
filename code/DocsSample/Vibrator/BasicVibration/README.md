# Vibrator

### Introduction

This sample simulates the countdown scenario to show the use of the vibrator APIs. Below shows the sample app.

![](./screenshots/device/vibratorTime.jpeg)

### Functions

You can trigger a vibrator to vibrate by duration or vibration effect.

### Required Permissions

ohos.permission.VIBRATE

### Usage

1. Touch the countdown text. A time picker is displayed. Select any time and touch **OK**. The selected time is displayed as the countdown text.

2. Touch **start**. The countdown starts, and the round progress bar and countdown text start changing. When the countdown ends, the device vibrates, the progress bar returns to the initial state, and a vibration dialog box is displayed.

3. Touch **reset**. The countdown ends, and the round progress bar and countdown text are restored to the initial state.

### Constraints

1. This sample can only be run on standard-system devices.

2. This sample requires a device with a vibrator.

3. This sample requires DevEco Studio 3.1 Canary1 (Build Version: 3.1.0.100) to compile and run. 

