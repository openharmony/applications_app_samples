/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// [Start import_system_account_module]
import { osAccount } from '@kit.BasicServicesKit';
// [End import_system_account_module]

function strToUint8Arr(str: string): Uint8Array {
  const buffer: number[] = [];
  for (let i = 0; i < str.length; i++) {
    const char = str.charAt(i);
    const code = char.codePointAt(0)!;
    if (code < 0x80) {
      buffer.push(code);
    } else if (code < 0x800) {
      buffer.push(0xc0 + (code >> 6));
      buffer.push(0x80 + (code & 0x3f));
    } else if (code < 0x10000) {
      buffer.push(0xe0 + (code >> 12));
      buffer.push(0x80 + ((code >> 6) & 0x3f));
      buffer.push(0x80 + (code & 0x3f));
    }
  }
  return new Uint8Array(buffer);
}

@Entry
@Component
struct SystemAccount {
  @State message: string = 'Nothing';
  @State cid: number = 100;
  @State textPassword: string = ''
  @State oldTextPassword: string = ''

  private async addCred(): Promise<void> {
    try {
      this.cid = await osAccount.getAccountManager().getForegroundOsAccountLocalId();
      // [Start create_credential_management_object]
      let userIDM: osAccount.UserIdentityManager = new osAccount.UserIdentityManager();
      // [End create_credential_management_object]
      // [Start define_pin_inputer_pinData]
      let pinData: Uint8Array = new Uint8Array([31, 32, 33, 34, 35, 36]);
      // [StartExclude define_pin_inputer_pinData]
      if (this.textPassword != '') {
        pinData = strToUint8Arr(this.textPassword);
      }
      // [EndExclude define_pin_inputer_pinData]
      let inputer: osAccount.IInputer = {
        onGetData: (authSubType: osAccount.AuthSubType, callback: osAccount.IInputData) => {
          callback.onSetData(authSubType, pinData);
        }
      }
      // [End define_pin_inputer_pinData]
      // [Start define_pin_credential_information]
      let credentialInfo :osAccount.CredentialInfo = {
        // [StartExclude define_pin_credential_information]
        accountId: this.cid,
        // [EndExclude define_pin_credential_information]
        credType:osAccount.AuthType.PIN,
        credSubType:osAccount.AuthSubType.PIN_SIX,
        token:new Uint8Array([0])
      }
      // [End define_pin_credential_information]
      // [Start call_the_api_to_register_the_inputer]
      let PINAuth: osAccount.PINAuth = new osAccount.PINAuth();
      // [StartExclude call_the_api_to_register_the_inputer]
      PINAuth.unregisterInputer();
      // [EndExclude call_the_api_to_register_the_inputer]
      PINAuth.registerInputer(inputer)
      // [End call_the_api_to_register_the_inputer]
      userIDM.closeSession(this.cid);
      userIDM.openSession(this.cid).then((data)=>{
        console.info('openSession info: ' + JSON.stringify(data));
        // [Start call_the_api_to_add_the_specified_credentials]
        userIDM.addCredential(credentialInfo,{
          onResult: (err, extraInfo)=>{
            console.info('addCredential result: ' + JSON.stringify(err));
            console.info('edential info: ' + JSON.stringify(extraInfo));
            // [StartExclude call_the_api_to_add_the_specified_credentials]
            if (err == 0) {
              this.message = 'PIN code entry successful';
            } else {
              this.message = 'PIN code entry failed: ' + JSON.stringify(err);
            }
            PINAuth.unregisterInputer();
            userIDM.closeSession(this.cid);
            // [EndExclude call_the_api_to_add_the_specified_credentials]
          }})
        // [End call_the_api_to_add_the_specified_credentials]
      }).catch((err: Error)=>{
        console.error('openSession failed, error: ' + JSON.stringify(err));
        this.message = 'Failed to open session:' + JSON.stringify(err);
      })
    } catch (e) {
      console.error('getEnrolledId cur failed, error: ' + JSON.stringify(e));
    }
  }

  private async auth(): Promise<void> {
    try {
      let userIDM = new osAccount.UserIdentityManager();
      let PINAuth = new osAccount.PINAuth();
      let password: Uint8Array = new Uint8Array([31, 32, 33, 34, 35, 36]);
      if (this.textPassword != '') {
        password = strToUint8Arr(this.textPassword);
      }
      PINAuth.unregisterInputer();
      PINAuth.registerInputer({
        onGetData:(authSubType, callback)=>{
          callback.onSetData(osAccount.AuthSubType.PIN_SIX, password);
        }
      })
      userIDM.closeSession(this.cid);
      userIDM.openSession(this.cid).then((data)=>{
        console.info('openSession info: ' + JSON.stringify(data));
        let authType: osAccount.AuthType = osAccount.AuthType.PIN;
        let authTrustLevel: osAccount.AuthTrustLevel = osAccount.AuthTrustLevel.ATL1;
        // [Start call_the_auth_operation_for_authentication]
        let userAuth: osAccount.UserAuth = new osAccount.UserAuth();
        userAuth.auth(data, authType, authTrustLevel, {
          onResult: (result: number, extraInfo: osAccount.AuthResult) => {
            console.info('pin auth result = ' + result);
            console.info('pin auth extraInfo = ' + JSON.stringify(extraInfo));
            let authToken = extraInfo.token;
            // [StartExclude call_the_auth_operation_for_authentication]
            if(result == 0) {
              this.message = 'PIN code entry successful';
            } else {
              this.message = 'PIN code authentication failed: ' + result;
            }
            // [EndExclude call_the_auth_operation_for_authentication]
          }
        });
        // [End call_the_auth_operation_for_authentication]
      }).catch((err: Error)=>{
        console.error('openSession failed, error: ' + JSON.stringify(err));
        this.message = 'Failed to open session:' + JSON.stringify(err);
      })
    } catch (err) {
      console.error('getEnrolledId cur failed, error: ' + JSON.stringify(err));
    }
  }

  private async addBiologyCred(): Promise<void> {
    // [Start define_facial_credential_information]
    let faceCredInfo: osAccount.CredentialInfo = {
      credType: osAccount.AuthType.FACE,
      credSubType: osAccount.AuthSubType.FACE_2D,
      token: new Uint8Array([1, 2, 3, 4, 5])
    }
    // [End define_facial_credential_information]
    // [Start define_fingerprint_credential_information]
    let fingerprintCredInfo: osAccount.CredentialInfo = {
      credType: osAccount.AuthType.FINGERPRINT,
      credSubType: osAccount.AuthSubType.FINGERPRINT_CAPACITIVE,
      token: new Uint8Array([1, 2, 3, 4, 5])
    }
    // [End define_fingerprint_credential_information]
    try {
      let userIDM = new osAccount.UserIdentityManager();
      let userAuth = new osAccount.UserAuth();
      let PINAuth = new osAccount.PINAuth();
      let password: Uint8Array = new Uint8Array([31, 32, 33, 34, 35, 36]);
      PINAuth.unregisterInputer();
      PINAuth.registerInputer({
        onGetData:(authSubType, callback)=>{
          callback.onSetData(osAccount.AuthSubType.PIN_SIX, password);
        }
      })
      userIDM.closeSession(this.cid);
      userIDM.openSession(this.cid).then((data)=>{
        console.info('openSession info: ' + JSON.stringify(data));
        let authType: osAccount.AuthType = osAccount.AuthType.PIN;
        let authTrustLevel: osAccount.AuthTrustLevel = osAccount.AuthTrustLevel.ATL1;
        userAuth.auth(data, authType, authTrustLevel, {
          onResult: (result: number, extraInfo: osAccount.AuthResult) => {
            console.info('pin auth result = ' + result);
            console.info('pin auth extraInfo = ' + JSON.stringify(extraInfo));
            faceCredInfo.token = extraInfo.token;
            fingerprintCredInfo.token = extraInfo.token;
            // [Start input_facial_credential_information]
            userIDM.addCredential(faceCredInfo, {
              onResult: (code: number, result: osAccount.RequestResult) => {
                console.info('add face credential, resultCode: ' + code);
                console.info('add face credential, request result: ' + result);
                // [StartExclude input_facial_credential_information]
                if(code == 0) {
                  this.message = 'Successfully entered facial credentials';
                } else {
                  this.message = 'Failed to enter facial credentials: ' + code;
                }
                // [EndExclude input_facial_credential_information]
              }
            });
            // [End input_facial_credential_information]
            // [Start enter_the_fingerprint_credentials]
            userIDM.addCredential(fingerprintCredInfo, {
              onResult: (code: number, result: osAccount.RequestResult) => {
                console.info('add fingerprint credential, resultCode: ' + code);
                console.info('add fingerprint credential, request result: ' + result);
                // [StartExclude enter_the_fingerprint_credentials]
                if(code == 0) {
                  this.message += 'Successfully entered fingerprint credentials';
                } else {
                  this.message = 'Failed to enter fingerprint credentials: ' + code;
                }
                // [EndExclude enter_the_fingerprint_credentials]
              }
            });
            // [End enter_the_fingerprint_credentials]
          }
        });
      }).catch((err: Error)=>{
        console.error('openSession failed, error: ' + JSON.stringify(err));
        this.message = 'Failed to open session:' + JSON.stringify(err);
      })
    } catch (err) {
      console.error('getEnrolledId cur failed, error: ' + JSON.stringify(err));
    }
  }

  private async biologyAuth(): Promise<void> {
    try {
      let userIDM = new osAccount.UserIdentityManager();
      let PINAuth = new osAccount.PINAuth();
      let password: Uint8Array = new Uint8Array([31, 32, 33, 34, 35, 36]);
      PINAuth.unregisterInputer();
      PINAuth.registerInputer({
        onGetData:(authSubType, callback)=>{
          callback.onSetData(osAccount.AuthSubType.PIN_SIX, password);
        }
      })
      userIDM.closeSession(this.cid);
      userIDM.openSession(this.cid).then((data)=>{
        console.info('openSession info: ' + JSON.stringify(data));
        let authType: osAccount.AuthType = osAccount.AuthType.FACE;
        let authTrustLevel: osAccount.AuthTrustLevel = osAccount.AuthTrustLevel.ATL1;
        // [Start call_the_auth_operation_for_face_authentication]
        let userAuth: osAccount.UserAuth = new osAccount.UserAuth();
        userAuth.auth(data, authType, authTrustLevel, {
          onResult: (result: number, extraInfo: osAccount.AuthResult) => {
            console.info('face auth result = ' + result);
            console.info('face auth extraInfo = ' + JSON.stringify(extraInfo));
            // [StartExclude call_the_auth_operation_for_face_authentication]
            if(result == 0) {
              this.message = 'Successfully authenticated biometric credentials';
            } else {
              this.message = 'Failed to authenticate biometric credentials: ' + result;
            }
            // [EndExclude call_the_auth_operation_for_face_authentication]
          }
        });
        // [End call_the_auth_operation_for_face_authentication]
      }).catch((err: Error)=>{
        console.error('openSession failed, error: ' + JSON.stringify(err));
        this.message = 'Failed to open session:' + JSON.stringify(err);
      })
    } catch (err) {
      console.error('getEnrolledId cur failed, error: ' + JSON.stringify(err));
    }
  }

  private async updateCred(): Promise<void> {
    let userIDM = new osAccount.UserIdentityManager();
    let userAuth = new osAccount.UserAuth();
    let PINAuth = new osAccount.PINAuth();
    let oldPassword: Uint8Array = new Uint8Array([31, 32, 33, 34, 35, 36]);
    if (this.oldTextPassword != '') {
      oldPassword = strToUint8Arr(this.oldTextPassword);
    }
    let password: Uint8Array = new Uint8Array([0x31, 0x31, 0x31, 0x31, 0x31, 0x31]);
    if (this.textPassword != '') {
      password = strToUint8Arr(this.textPassword);
    }
    // [Start define_the_credential_information_to_be_updated]
    let credentialInfo :osAccount.CredentialInfo = {
      // [StartExclude define_the_credential_information_to_be_updated]
      accountId:this.cid,
      // [EndExclude define_the_credential_information_to_be_updated]
      credType:osAccount.AuthType.PIN,
      credSubType:osAccount.AuthSubType.PIN_SIX,
      token:new Uint8Array([1, 2, 3, 4, 5])
    }
    // [End define_the_credential_information_to_be_updated]
    PINAuth.unregisterInputer();
    PINAuth.registerInputer({
      onGetData:(authSubType, callback)=>{
        callback.onSetData(osAccount.AuthSubType.PIN_SIX, oldPassword);
      }
    })
    userIDM.openSession(this.cid).then((data)=>{
      console.info('openSession info: ' + JSON.stringify(data));
      userAuth.authUser(this.cid, data, osAccount.AuthType.PIN,
        osAccount.AuthTrustLevel.ATL1, {
        onResult:(err, authResult)=>{
          console.info('authUser err: ' + JSON.stringify(err));
          console.info('authUser info: ' + JSON.stringify(authResult));
          console.info('authUser info.userId: ' + authResult.accountId);
          credentialInfo.token = authResult.token;
          PINAuth.unregisterInputer();
          PINAuth.registerInputer({
            onGetData:(subType, callback) =>{
              callback.onSetData(osAccount.AuthSubType.PIN_SIX, password)
            }
          })
          // [Start update_your_credentials]
          userIDM.updateCredential(credentialInfo, {
            onResult:(result: number, extraInfo: osAccount.RequestResult)=>{
              console.info('updateCredential result: ' + JSON.stringify(result));
              console.info('updateCredential extraInfo: ' + JSON.stringify(extraInfo));
              // [StartExclude update_your_credentials]
              if(result == 0) {
                this.message = 'Successfully updated PIN code credentials';
              } else {
                this.message = 'Failed to update PIN code credentials: ' + JSON.stringify(result);
              }
              PINAuth.unregisterInputer();
              userIDM.closeSession(this.cid);
              // [EndExclude update_your_credentials]
            }
          })
          // [End update_your_credentials]
        }
      })
    }).catch((err: Error)=>{
      console.error('openSession failed, error: ' + JSON.stringify(err));
      this.message = 'Failed to open session:' + JSON.stringify(err);
    })
  }

  private async getCred(): Promise<void> {
    let userIDM = new osAccount.UserIdentityManager();
    try {
      userIDM.getAuthInfo((err, data)=>{
        console.info('getAuthInfo err: ' + JSON.stringify(err));
        console.info('getAuthInfo data: ' + JSON.stringify(data));
        this.message = 'Query information length: ' + data.length;
      })
      // [Start obtain_credential_information_of_the_specified_type]
      let enrolledFingerCredInfoList: osAccount.EnrolledCredInfo[] =
        await userIDM.getAuthInfo(osAccount.AuthType.PIN);
      // [End obtain_credential_information_of_the_specified_type]
    } catch (err) {
      console.error('getAuthInfo failed: ' + JSON.stringify(err));
      this.message = 'Query information failed: ' + JSON.stringify(err);
    }
  }

  private async deleteBiologyCred(): Promise<void> {
    let userIDM = new osAccount.UserIdentityManager();
    let userAuth = new osAccount.UserAuth();
    let PINAuth = new osAccount.PINAuth();
    // [Start obtain_the_credential_information_of_the_fingerprint_type]
    let credentialId: Uint8Array = new Uint8Array([1, 2, 3, 4, 5]);
    let token: Uint8Array = new Uint8Array([1, 2, 3, 4, 5])
    let credInfoList: osAccount.EnrolledCredInfo[] = 
      await userIDM.getAuthInfo(osAccount.AuthType.FINGERPRINT);
    if (credInfoList.length != 0) {
      credentialId = credInfoList[0].credentialId;
    }
    // [End obtain_the_credential_information_of_the_fingerprint_type]
    PINAuth.unregisterInputer();
    PINAuth.registerInputer({
      onGetData:(authSubType, callback)=>{
        callback.onSetData(osAccount.AuthSubType.PIN_SIX,
          new Uint8Array([0x31, 0x31, 0x31, 0x31, 0x31, 0x31]));
      }
    })
    userIDM.closeSession(this.cid)
    userIDM.openSession(this.cid).then((data)=>{
      console.info('openSession info: ' + JSON.stringify(data));
      userAuth.authUser(this.cid, data, osAccount.AuthType.PIN,
        osAccount.AuthTrustLevel.ATL1, {
        onResult:(err, authResult)=>{
          console.info('authUser err: ' + JSON.stringify(err));
          console.info('authUser info: ' + JSON.stringify(authResult));
          console.info('authUser info.userId: ' + authResult.accountId);
          try {
            // [Start delete_specified_credentials]
            userIDM.delCred(credentialId, authResult.token, {
              onResult: (result: number, extraInfo: osAccount.RequestResult) => {
                console.info('delCred result = ' + result);
                console.info('delCred extraInfo = ' + JSON.stringify(extraInfo));
                // [StartExclude delete_specified_credentials]
                if(result == 0) {
                  this.message = 'Successfully deleted credentials';
                } else {
                  this.message = 'Failed to delete credentials: ' + result;
                }
                // [EndExclude delete_specified_credentials]
              }
            });
            // [End delete_specified_credentials]
          } catch (e) {
            console.error('delUser exception = ' + JSON.stringify(e));
            this.message = 'Failed to delete credentials: ' + JSON.stringify(e);
          }
          // [Start deactivate_pin_input_device]
          PINAuth.unregisterInputer();
          // [End deactivate_pin_input_device]
          // [Start close_the_session_and_end_credential_management]
          userIDM.closeSession(this.cid);
          // [End close_the_session_and_end_credential_management]
        }
      })
    }).catch((err: Error)=>{
      console.error('openSession failed, error: ' + JSON.stringify(err));
      this.message = 'Failed to open session:' + JSON.stringify(err);
    })
  }

  private async deleteCred(): Promise<void> {
    let userIDM = new osAccount.UserIdentityManager();
    let userAuth = new osAccount.UserAuth();
    let PINAuth = new osAccount.PINAuth();
    let password: Uint8Array = new Uint8Array([0x31, 0x31, 0x31, 0x31, 0x31, 0x31]);
    if (this.textPassword != '') {
      password = strToUint8Arr(this.textPassword);
    }
    PINAuth.unregisterInputer();
    PINAuth.registerInputer({
      onGetData:(authSubType, callback)=>{
        callback.onSetData(osAccount.AuthSubType.PIN_SIX, password);
      }
    })
    userIDM.closeSession(this.cid)
    userIDM.openSession(this.cid).then((data)=>{
      console.info('openSession info: ' + JSON.stringify(data));
      userAuth.authUser(this.cid, data, osAccount.AuthType.PIN,
        osAccount.AuthTrustLevel.ATL1, {
        onResult:(err, authResult)=>{
          console.info('authUser err: ' + JSON.stringify(err));
          console.info('authUser info: ' + JSON.stringify(authResult));
          console.info('authUser info.userId: ' + authResult.accountId);
          console.info('authUser info.token: ' + authResult.token);
          try {
            userIDM.delUser(authResult.token, {
              onResult: (result: number, extraInfo: osAccount.RequestResult) => {
                console.info('delUser result = ' + result);
                console.info('delUser extraInfo = ' + JSON.stringify(extraInfo));
                if(result == 0) {
                  this.message = 'Successfully deleted PIN code credentials';
                } else {
                  this.message = 'Failed to delete PIN code credentials: ' + JSON.stringify(result);
                }

                PINAuth.unregisterInputer();
                userIDM.closeSession(this.cid);
              }
            });
          } catch (e) {
            console.error('delUser exception = ' + JSON.stringify(e));
          }
        }
      })
    }).catch((err: Error)=>{
      console.error('openSession failed, error: ' + JSON.stringify(err));
      this.message = 'Failed to open session:' + JSON.stringify(err);
    })
  }

  build() {
    Column() {
      TextInput({ text: this.textPassword, placeholder: 'input password...'})
        .placeholderColor(Color.Grey)
        .placeholderFont({ size: 14, weight: 400 })
        .caretColor(Color.Blue)
        .width(200)
        .height(40)
        .margin(10)
        .fontSize(14)
        .fontColor(Color.Black)
        .onChange((value: string) => {
          this.textPassword = value;
        })
      TextInput({ text: this.oldTextPassword, placeholder: 'old password...'})
        .placeholderColor(Color.Grey)
        .placeholderFont({ size: 14, weight: 400 })
        .caretColor(Color.Blue)
        .width(200)
        .height(40)
        .margin(10)
        .fontSize(14)
        .fontColor(Color.Black)
        .onChange((value: string) => {
          this.oldTextPassword = value;
        })
      Text(this.message)
        .id('show')
        .fontSize(36)
        .fontWeight(FontWeight.Bold)
      Button($r('app.string.ManageSystemAccountCredentials1'))
        .margin(10)
        .id('button1')
        .onClick(() => this.addCred())
      Button($r('app.string.ManageSystemAccountCredentials2'))
        .margin(10)
        .id('button2')
        .onClick(() => this.auth())
      Button($r('app.string.ManageSystemAccountCredentials3'))
        .margin(10)
        .id('button3')
        .onClick(() => this.addBiologyCred())
      Button($r('app.string.ManageSystemAccountCredentials4'))
        .margin(10)
        .id('button4')
        .onClick(() => this.biologyAuth())
      Button($r('app.string.ManageSystemAccountCredentials5'))
        .margin(10)
        .id('button5')
        .onClick(() => this.updateCred())
      Button($r('app.string.ManageSystemAccountCredentials6'))
        .margin(10)
        .id('button6')
        .onClick(() => this.getCred())
      Button($r('app.string.ManageSystemAccountCredentials7'))
        .margin(10)
        .id('button8')
        .onClick(() => this.deleteBiologyCred())
      Button($r('app.string.ManageSystemAccountCredentials8'))
        .margin(10)
        .id('button7')
        .onClick(() => this.deleteCred())
    }
    .height('100%')
    .width('100%')
  }
}