# Certificate Framework

### Introduction

This sample shows how `@ohos.security.cert` works to implement the function of verifying signature data. 

The implementation scenario(1):

1. Signature verification scenario using correct original data and signature data: Simulate the server obtains the public key through the client certificate, verifies the signature data using the public key, and verifies the client's identity and the integrity of the original data.
2. Scenario of using incorrect original or signature data for signature verification: Simulate an attacker modifying the original or signature data. When the server uses the public key for signature verification, the attacker's identity is untrustworthy or the original data is incomplete, resulting in verification failure.

### Usage

1. Click the **Data Display** button, and the correct certificate, original, and signature data contents will be displayed in the text boxes of the page.

2. Click the **Signature Verification** button, and a pop-up window will pop up on the page, indicating that **Verification passed**.

3. Click the **Modify Original Data** button, and the page will display the modified original data and the correct certificate and signature data; Click the signature verification button, and a pop-up window will pop up on the page, indicating **Verification failed**.

4. Click the **Modify Signature Data** button, and the page will display the modified signature data, correct certificate, and original data; Click the signature verification button, and a pop-up window will pop up on the page, indicating **Verification failed**.
5. Click the **Data Display** button to restore the display of correct certificates, original and signature data on the page; Click the **Signature Verification** button, and a pop-up window will pop up on the page, indicating that **Verification passed**.


The implementation scenario(2):

1. Use certificate chain data and root certificate data for certificate chain verification scenario: Verify whether the root certificate of the certificate chain is in the trusted list.
2. Using Certificate Chain Data and Certificate Revocation List: Verify that the certificate in the certificate chain has been revoked.

### Usage

1. Click the **Data Display** button, and the correct certificate chain, root certificate and CRL data content will be displayed in the text box.

2. Click the **Certificate chain verification** button, the page pops up, indicating that **verification passed**.

3. Open the **Verification certificate revocation list**, click the **Certificate chain verification** button, the page pops up, indicating that **verification failed**.

### Dependency

* not involved.

### Constraints

1. This sample can only be run on standard-system devices.
2. This sample has been adapted to the API version 11 SDK, Applicable version: CI DailyBuild of 4.1.5.3 after 12/23/2023, or newer Beta versions, Release versions.
3. This sample requires DevEco Studio 4.0 Release (Build Version: 4.0.0.600) or higher version to compile and run. Due to the limitations of hvigor, there are some restrictions on how to synchronize hvigor in this Sample project. These restrictions can be bypassed by following these steps:

   (1) Change the compileSdkVersion and compatibleSdkVersion support versions in build-profile.json5 from 11 to 10, and then synchronize hvigor.

   (2) After hvigor is synchronized successfully, change the compileSdkVersion and compatibleSdkVersion support versions in build-profile.json5 from 10 to 11, and then you can compile.

