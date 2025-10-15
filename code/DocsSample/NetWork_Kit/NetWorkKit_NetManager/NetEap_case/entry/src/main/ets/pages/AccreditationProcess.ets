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
// [Start eap_case_module_import]
import { eap } from '@kit.NetworkKit';
// [End eap_case_module_import]
import { promptAction } from '@kit.ArkUI';

const BUTTON_HEIGHT = 50; // 按钮的高度
const BUTTON_FONT_SIZE = 20; // 按钮的字体大小
const BUTTON_RADIUS = 5; // 按钮的圆角半径
const TEXT_MARGIN_TOP_L = 20; // 长文本的上边距

// [Start eap_case_reply_custom_eapData]
// [Start eap_case_unreg_custom_eapHandler]
let netType = 1;
let eapCode= 1; // eap request
let eapType= 25; // EAP_PEAP
let result = 1;
let eapData = (eapData:eap.EapData):void => {
  console.info('rsp result',JSON.stringify(eapData));
  // [StartExclude eap_case_unreg_custom_eapHandler]
  try{
    eap.replyCustomEapData(result, eapData);
    console.info('replyCustomEapData success');
  } catch (err) {
    console.error('errCode: ' + err.code + ' , errMessage: ' + err.message);
  }
  // [EndExclude eap_case_unreg_custom_eapHandler]
}
// [StartExclude eap_case_unreg_custom_eapHandler]
function serverReplyCustomEapData() {
  try{
    eap.regCustomEapHandler(netType, eapCode, eapType, eapData);
    console.info('regCustomEapHandler success');
    // [StartExclude eap_case_reply_custom_eapData]
    promptAction.showToast({
      message: '报文发送成功',
      duration: 4000, // 持续时间
      bottom: 300 // 与底间隔
    });
    // [EndExclude eap_case_reply_custom_eapData]
  } catch (err) {
    console.error('errCode: ' + err.code + 'errMessage: ' + err.message);
    // [StartExclude eap_case_reply_custom_eapData]
    promptAction.showToast({
      message: 'errCode: ' + err.code + 'errMessage: ' + err.message,
      duration: 4000, // 持续时间
      bottom: 300 // 与底间隔
    });
    // [EndExclude eap_case_reply_custom_eapData]
  }
  // [End eap_case_reply_custom_eapData]
}

function unregCustomEapHandler() {
  // [EndExclude eap_case_unreg_custom_eapHandler]
  try {
    eap.unregCustomEapHandler(netType, eapCode, eapType, eapData);
    console.info('unregCustomEapHandler success');
    // [StartExclude eap_case_unreg_custom_eapHandler]
    promptAction.showToast({
      message: '取消订阅成功',
      duration: 4000, // 持续时间
      bottom: 300 // 与底间隔
    });
    // [EndExclude eap_case_unreg_custom_eapHandler]
  } catch (err) {
    console.error('errCode: ' + err.code + ', errMessage: ' + err.message);
    // [StartExclude eap_case_unreg_custom_eapHandler]
    promptAction.showToast({
      message: 'errCode: ' + err.code + ', errMessage: ' + err.message,
      duration: 4000, // 持续时间
      bottom: 300 // 与底间隔
    });
    // [EndExclude eap_case_unreg_custom_eapHandler]
  }
  // [End eap_case_unreg_custom_eapHandler]
}

@Entry
@Component
struct firstPart {
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
        Text($r('app.string.first_part'))
          .fontSize(24)
          .margin({bottom:50})
        // 报文类型是由服务器发送给客户端的
        Button($r('app.string.server_sends_message'))
          .onClick(() => {
            serverReplyCustomEapData();
          })
          .width('80%')
          .height(BUTTON_HEIGHT)
          .margin({ top: TEXT_MARGIN_TOP_L })
          .fontColor(Color.White)
          .fontSize(BUTTON_FONT_SIZE)
          .borderRadius(BUTTON_RADIUS)

        // 取消定制化
        Button($r('app.string.Uncustomize'))
          .onClick(() => {
            unregCustomEapHandler();
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