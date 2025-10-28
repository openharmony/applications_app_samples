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
// [Start eap_case_eth_module_import]
import { eap } from '@kit.NetworkKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
// [End eap_case_eth_module_import]
import { promptAction } from '@kit.ArkUI';

const BUTTON_HEIGHT = 50; // 按钮的高度
const BUTTON_FONT_SIZE = 20; // 按钮的字体大小
const BUTTON_RADIUS = 5; // 按钮的圆角半径
const TEXT_MARGIN_TOP_L = 20; // 长文本的上边距

// [Start eap_case_log_off_eth_eap]
// [Start eap_case_start_eth_eap]
const netId: number = 100;
// [StartExclude eap_case_log_off_eth_eap]
// [StartExclude eap_case_start_eth_eap]
function startEthEap() {
  // [EndExclude eap_case_start_eth_eap]
  let profile: eap.EthEapProfile = {
    eapMethod: eap.EapMethod.EAP_TTLS,
    phase2Method: eap.Phase2Method.PHASE2_AKA_PRIME,
    identity: 'identity',
    anonymousIdentity: 'anonymousIdentity',
    password: 'password',
    caCertAliases: 'caCertAliases',
    caPath: 'caPath',
    clientCertAliases: 'clientCertAliases',
    certEntry: new Uint8Array([5,6,7,8,9,10]),
    certPassword: 'certPassword',
    altSubjectMatch: 'altSubjectMatch',
    domainSuffixMatch: 'domainSuffixMatch',
    realm: 'realm',
    plmn: 'plmn',
    eapSubId: 1
  };

  try {
    eap.startEthEap(netId, profile);
    hilog.info(0x0000, 'testTag', 'startEthEap success');
    // [StartExclude eap_case_start_eth_eap]
    promptAction.showToast({
      message: '认证成功',
      duration: 4000, // 持续时间
      bottom: 300 // 与底间隔
    });
    // [EndExclude eap_case_start_eth_eap]
  } catch (err) {
    // [StartExclude eap_case_start_eth_eap]
    promptAction.showToast({
      message: '认证失败',
      duration: 4000, // 持续时间
      bottom: 300 // 与底间隔
    });
    // [EndExclude eap_case_start_eth_eap]
    hilog.error(0x0000, 'testTag', 'errCode: ' + err.code + ', errMessage: ' + err.message);
  }
  // [End eap_case_start_eth_eap]
}

function logOffEthEap() {
  // [EndExclude eap_case_log_off_eth_eap]
  try{
    eap.logOffEthEap(netId);
    hilog.error(0x0000, 'testTag', 'logOffEthEap success');
    // [StartExclude eap_case_log_off_eth_eap]
    promptAction.showToast({
      message: '退出认证成功',
      duration: 4000, // 持续时间
      bottom: 300 // 与底间隔
    });
    // [EndExclude eap_case_log_off_eth_eap]
  } catch (err) {
    // [StartExclude eap_case_log_off_eth_eap]
    promptAction.showToast({
      message: '退出认证失败',
      duration: 4000, // 持续时间
      bottom: 300 // 与底间隔
    });
    // [EndExclude eap_case_log_off_eth_eap]
    hilog.error(0x0000, 'testTag', 'errCode: ' + err.code + ', errMessage: ' + err.message);
  }
  // [End eap_case_log_off_eth_eap]
}

@Entry
@Component
struct secondPart {
  build() {
    Column(){
      Row(){
        Button($r('app.string.back_Btn'))
          .onClick(() => {
            this.getUIContext().getRouter().back(1);
          })
          .height(BUTTON_HEIGHT)
          .margin({ top: TEXT_MARGIN_TOP_L })
          .fontColor(Color.White)
          .fontSize(BUTTON_FONT_SIZE)
          .borderRadius(BUTTON_RADIUS)
      }
      .width('100%')
      .padding(20)
      Column() {
        Text($r('app.string.second_part'))
          .fontSize(24)
          .margin({bottom:50})
        // 开始认证
        Button($r('app.string.Start_authentication'))
          .onClick(() => {
            startEthEap();
          })
          .width('80%')
          .height(BUTTON_HEIGHT)
          .margin({ top: TEXT_MARGIN_TOP_L })
          .fontColor(Color.White)
          .fontSize(BUTTON_FONT_SIZE)
          .borderRadius(BUTTON_RADIUS)
        // 退出认证
        Button($r('app.string.Withdrawal_of_certification'))
          .onClick(() => {
            logOffEthEap();
          })
          .width('80%')
          .height(BUTTON_HEIGHT)
          .margin({ top: TEXT_MARGIN_TOP_L })
          .fontColor(Color.White)
          .fontSize(BUTTON_FONT_SIZE)
          .borderRadius(BUTTON_RADIUS)
      }
      .height('100%')
      .width('100%')
      .layoutWeight(1)
      .justifyContent(FlexAlign.Center)
    }
    .height('100%')
    .width('100%')
  }
}