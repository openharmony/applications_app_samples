# Certificate Framework

### Introduction

This sample shows how `@ohos.security.cert` works to implement the function of verifying signature data. The implementation scenario is as follows:

1. Signature verification scenario using correct original data and signature data: Simulate the server obtains the public key through the client certificate, verifies the signature data using the public key, and verifies the client's identity and the integrity of the original data.
2. Scenario of using incorrect original or signature data for signature verification: Simulate an attacker modifying the original or signature data. When the server uses the public key for signature verification, the attacker's identity is untrustworthy or the original data is incomplete, resulting in verification failure.

### Usage

1. Click the **Data Display** button, and the correct certificate, original, and signature data contents will be displayed in the text boxes of the page.

2. Click the **Signature Verification** button, and a pop-up window will pop up on the page, indicating that **Verification passed**.

3. Click the **Modify Original Data** button, and the page will display the modified original data and the correct certificate and signature data; Click the signature verification button, and a pop-up window will pop up on the page, indicating **Verification failed**.

4. Click the **Modify Signature Data** button, and the page will display the modified signature data, correct certificate, and original data; Click the signature verification button, and a pop-up window will pop up on the page, indicating **Verification failed**.
5. Click the **Data Display** button to restore the display of correct certificates, original and signature data on the page; Click the **Signature Verification** button, and a pop-up window will pop up on the page, indicating that **Verification passed**.

### Dependency

* [crypto framework.](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-cryptoFramework.md#ohossecuritycryptoframework-%E5%8A%A0%E8%A7%A3%E5%AF%86%E7%AE%97%E6%B3%95%E5%BA%93%E6%A1%86%E6%9E%B6)

### Constraints

1. This sample can only be run on standard-system devices.
2. This sample has been adapted to the API version 9 SDK, version number 3.2.12.2.
3. This sample requires DevEco Studio 3.1 Release(Build Version: 3.1.0.500) to compile and run.

