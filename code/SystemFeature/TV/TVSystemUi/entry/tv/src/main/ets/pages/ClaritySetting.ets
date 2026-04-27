/**
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { SettingListTvComponent } from '../components/SettingListTvComponent'
import { SettingItemTvModel } from '../model/SettingItemTvModel'
import { SettingItemStyle } from '../utils/StyleConstants'
import { Duration } from '../utils/Duration';
import { promptAction } from '@kit.ArkUI';
import { inputEventClient } from '@kit.InputKit';
import { router } from '@kit.ArkUI';
import { KeyCode } from '@kit.InputKit';
import displaySetting from '@ohos.tvservice.displaySetting';


const TAG = 'ClaritySettingIndex'
const getNR: Record<number, string> = {
  0: '关闭',
  1: '低',
  2: '中',
  3: '高',
  4: '自动',
};
const getMpegNR: Record<number, string> = {
  0: '关闭',
  1: '低',
  2: '中',
  3: '高',
  4: '自动',
};

const getMemcLevelMap: Record<number, string> = {
  0: '关闭',
  1: '低',
  2: '中',
  3: '高',
  4: '自动',
};

/**
 * 显示设置
 */

@Entry
@Component
struct ClaritySetting {
  @State imageUrl: string = ''
  @State des: string = ''
  @State settingList: SettingItemTvModel[] = []
  @State settingListCareful: SettingItemTvModel[] = []
  @State focusIndex: number = -1
  // 锐利度
  @State sharpnessValue: number = 50;
  // 随机降噪
  @State denoise: string = '关闭';
  @State denoiseIndex: number = 0;
  // MPEG降噪
  @State mpegdEnoise: string = '关闭';
  @State mpegdEnoiseIndex: number = 0;
  //流畅度
  @State fluency: string = '低';
  @State fluencyIndex: number = 1;
  outPutNRMap: Map<string, number> = new Map();

  pageTransition() {
    PageTransitionEnter({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
      .slide(SlideEffect.Right)
    PageTransitionExit({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
      .slide(SlideEffect.Right)
  }

  async aboutToAppear() {

    let item1 = new SettingItemTvModel();
    item1.name = '锐利度';
    item1.style = SettingItemStyle.valueChange;
    item1.value = this.sharpnessValue.toString();


    let item2 = new SettingItemTvModel();
    item2.name = '随机降噪';
    item2.style = SettingItemStyle.valueChange;
    item2.value = this.denoise;


    let item3 = new SettingItemTvModel();
    item3.name = 'MPEG降噪';
    item3.style = SettingItemStyle.valueChange;
    item3.value = this.mpegdEnoise;

    let item4 = new SettingItemTvModel();
    item4.name = '流畅度';
    item4.style = SettingItemStyle.valueChange;
    item4.value = this.fluency;
    // 底层不支持，屏蔽 item4
    this.settingList.push(item1, item2, item3);
  }
  onPageShow(): void {
    this.initOutputOption();
    this.getSharpness();
    this.getDenoise();
    this.getmpegdEnoise();
    this.getfluency();
  }
onBackPress() {
  // setTimeout(()=>{
    this.getUIContext().getRouter().back()
  // },500)
  // return true
}
  async getSharpness() {
    try {
      let getSharpness: number = await displaySetting.getSharpness();
      this.sharpnessValue=getSharpness
      this.settingList[0].setValue(getSharpness + '')
    } catch (error) {
      promptAction.showToast({ message: $r('app.string.tips_in_development') })
      console.debug('getSharpness',JSON.stringify(error))
    }
  }

  async getDenoise() {
    try {
      let mode: displaySetting.CommonLevel = await displaySetting.getNR();
      console.debug(TAG + 'getNRSuccess=' + JSON.stringify(mode));
      console.debug(TAG + 'getNRSuccess11=' + JSON.stringify(getNR[mode]));
      this.settingList[1].setValue(getNR[mode])
    } catch (error) {
      console.debug(TAG + 'getNR=' + JSON.stringify(error));
    }
  }

  async getmpegdEnoise() {
    try {
      let mode: displaySetting.CommonLevel = await displaySetting.getMpegNR();
      console.debug(TAG + 'getMpegNRSuccess=' + JSON.stringify(mode));
      console.debug(TAG + 'getMpegNRSuccess11=' + JSON.stringify(getMpegNR[mode]));
      this.settingList[2].setValue(getMpegNR[mode])
    } catch (error) {
      console.debug(TAG + 'getMpegNR=' + JSON.stringify(error));
    }
  }

  async getfluency() {
    try {
      let level: displaySetting.CommonLevel = await displaySetting.getMemcLevel();
      if (level == displaySetting.CommonLevel.COMMON_LEVEL_BUTT) {
        this.settingList[3].setIsEnable(false);
        this.settingList[3].setIsDisableFocus(true);
        level = displaySetting.CommonLevel.COMMON_LEVEL_OFF;
      }
      console.debug(TAG + 'getfluencySuccess=' + JSON.stringify(level));
      console.debug(TAG + 'getfluencySuccess11=' + JSON.stringify(getMemcLevelMap[level]));
      this.settingList[3].setValue(getMemcLevelMap[level])
    } catch (error) {
      console.debug(TAG + 'getfluency=' + JSON.stringify(error));
    }
  }

  initOutputOption() {
    this.outPutNRMap.set('关闭', 0);
    this.outPutNRMap.set('低', 1);
    this.outPutNRMap.set('中', 2);
    this.outPutNRMap.set('高', 3);
    this.outPutNRMap.set('自动', 4);
  }

  // 数字设置
  sharpnessSetting(value: number,  min: number, max100: number,event?: KeyEvent,isLeft?:boolean) {
    if(event!==undefined){
      if ((event.keyCode == KeyCode.KEYCODE_DPAD_LEFT) && value > min) {
        return --value;
      }
      if ((event.keyCode == KeyCode.KEYCODE_DPAD_RIGHT) && value < max100) {
        return ++value;
      }
    }
    // 必须加!==undefined，不然遥控器的其他按键会让其执行
    if(isLeft!==undefined){
      if(isLeft&& value > min){
        return --value;
      }
      if ((!isLeft) && value < max100) {
        return ++value;
      }
    }
    return value
  }

  // 左右键控制事件
  stringChange( index: number,event?: KeyEvent,isLeft?:boolean) {
    if(event!==undefined){
      if (event.keyCode == KeyCode.KEYCODE_DPAD_LEFT && index >= 0) {
        index--;
      }
      if (event.keyCode == KeyCode.KEYCODE_DPAD_LEFT && index < 0) {
        index = 4;
      }
      if (event.keyCode == KeyCode.KEYCODE_DPAD_RIGHT && index <= 4) {
        index++;
      }
      if (event.keyCode == KeyCode.KEYCODE_DPAD_RIGHT && index > 4) {
        index = 0;
      }
    }
    if(isLeft!==undefined){
      if(isLeft&& index >= 0){
        index--;
      }
      if(isLeft&& index < 0){
        index = 4;
      }
      if (!isLeft && index <= 4) {
        index++;
      }
      if (!isLeft && index > 4) {
        index = 0;
      }
    }
    return index
  }

  stringChangefluency(event: KeyEvent, index: number) {
    if (event.keyCode == KeyCode.KEYCODE_DPAD_LEFT) {
      index--;
    }
    if (event.keyCode == KeyCode.KEYCODE_DPAD_RIGHT) {
      index++;
    }
    index = (index + 5) % 5;
    return index;
  }

  async setSharpness() {
    try {
      console.debug(TAG + 'this.sharpnessValue==:' + JSON.stringify(this.sharpnessValue));
      let setSharpness: boolean = await displaySetting.setSharpness(this.sharpnessValue); // 调用厂商api
      console.debug(TAG + 'setSharpness SuccessBoolean==:' + JSON.stringify(setSharpness));
      if (!setSharpness) {
        promptAction.showToast({ message: '设置锐利度失败' })
      }
    } catch (error) {
      console.debug(TAG + 'setSharpness=' + JSON.stringify(error));
      promptAction.showToast({ message: $r('app.string.tips_in_development') })
    }
  }

  async setNR() {
    try {
      let setNR: boolean = await displaySetting.setNR(this.denoiseIndex); // 调用厂商api
      console.debug(TAG + 'setNR SuccessBoolean==:' + JSON.stringify(setNR));
      if (!setNR) {
        promptAction.showToast({ message: '设置随机降噪失败' })
      }
    } catch (error) {
      console.debug(TAG + 'setNR=' + JSON.stringify(error));
      promptAction.showToast({ message: $r('app.string.tips_in_development') })
    }
  }

  async setMpegNR() {
    try {
      let setMpegNR: boolean = await displaySetting.setMpegNR(this.mpegdEnoiseIndex); // 调用厂商api
      console.debug(TAG + 'setMpegNR SuccessBoolean==:' + JSON.stringify(setMpegNR));
      if (!setMpegNR) {
        promptAction.showToast({ message: '设置MPEG降噪失败' })
      }
    } catch (error) {
      console.debug(TAG + 'setMpegNR=' + JSON.stringify(error));
      promptAction.showToast({ message: $r('app.string.tips_in_development') })
    }
  }

  async setfluency() {
    console.debug(TAG + 'setgetfluency:' + JSON.stringify(this.fluencyIndex));
    try {
      let result: boolean = await displaySetting.setMemcLevel(this.fluencyIndex); // 调用厂商api
      console.debug(TAG + 'setgetfluency SuccessBoolean==:' + JSON.stringify(result));
      if (!result) {
        promptAction.showToast({ message: '设置流畅度失败' })
      }
    } catch (error) {
      console.debug(TAG + 'setgetfluency=' + JSON.stringify(error));
      promptAction.showToast({ message: $r('app.string.tips_in_development') })
    }
  }
 tabClick() {
  let keyDownOpt: inputEventClient.KeyEvent = {
    isPressed: true,
    keyCode: KeyCode.KEYCODE_TAB,
    keyDownDuration: 0,
    isIntercepted: false
  };
  let keyUpOpt: inputEventClient.KeyEvent = {
    isPressed: false,
    keyCode: KeyCode.KEYCODE_TAB,
    keyDownDuration: 0,
    isIntercepted: false
  };

  class KeyEventWrapper {
    public keyEvent: inputEventClient.KeyEvent | null = null
  }

   let eventDown: KeyEventWrapper = { keyEvent: keyDownOpt };
   let eventUp: KeyEventWrapper = { keyEvent: keyUpOpt };

  try {
    // 触发tab点击，使默认焦点组件多态样式生效
    inputEventClient.injectEvent({ KeyEvent: eventDown.keyEvent });
    inputEventClient.injectEvent({ KeyEvent: eventUp.keyEvent });
  } catch (err) {
    console.error('settingList inputEventClient' + err)
  }
}
  build() {
    Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.End }) {
      Row() {
        SettingListTvComponent({
          settingList: this.settingList,
          title: '清晰度与流畅度',
          onKeyEventHandle: (item: SettingItemTvModel, event: KeyEvent) => {
            if (event.type === KeyType.Down) {
              if (item.name === '锐利度') {
                this.sharpnessValue = this.sharpnessSetting(this.sharpnessValue,  0, 100,event,undefined);
                item.setValue(this.sharpnessValue.toString());
                this.setSharpness()
              } else if (item.name === '随机降噪') {
                let origins: string[] = ['关闭', '低', '中', '高', '自动']
                origins.forEach((originItem, index) => {
                  if (item.value === originItem) {
                    this.denoiseIndex = this.stringChange( index,event,undefined);
                  }
                })
                // 实现页面静态交互
                this.denoise = origins[this.denoiseIndex]
                item.setValue(origins[this.denoiseIndex]);
                this.setNR()
              } else if (item.name === 'MPEG降噪') {
                let origins: string[] = ['关闭', '低', '中', '高', '自动']
                origins.forEach((originItem, index) => {
                  if (item.value === originItem) {
                    this.mpegdEnoiseIndex = this.stringChange(index,event,undefined);
                  }
                })
                // 实现页面静态交互
                this.mpegdEnoise = origins[this.mpegdEnoiseIndex]
                item.setValue(origins[this.mpegdEnoiseIndex]);
                this.setMpegNR()
              }
            }
          },
          onValueChangeLeftHandle:  (item: SettingItemTvModel) => {//为了灵犀的点击事件与触控事件
            if (item.name === '锐利度') {
              this.sharpnessValue = this.sharpnessSetting(this.sharpnessValue, 0, 100, undefined,true);
              item.setValue(this.sharpnessValue.toString());
              this.setSharpness()
            } else if (item.name === '随机降噪') {
              let origins: string[] = ['关闭', '低', '中', '高', '自动']
              origins.forEach((originItem, index) => {
                if (item.value === originItem) {
                  this.denoiseIndex = this.stringChange( index,undefined,true);
                }
              })
              // 实现页面静态交互
              this.denoise = origins[this.denoiseIndex]
              item.setValue(origins[this.denoiseIndex]);
              this.setNR()
            } else if (item.name === 'MPEG降噪') {
              let origins: string[] = ['关闭', '低', '中', '高', '自动']
              origins.forEach((originItem, index) => {
                if (item.value === originItem) {
                  this.mpegdEnoiseIndex = this.stringChange( index,undefined,true);
                }
              })
              // 实现页面静态交互
              this.mpegdEnoise = origins[this.mpegdEnoiseIndex]
              item.setValue(origins[this.mpegdEnoiseIndex]);
              this.setMpegNR()
            }
          },
          onValueChangeRightHandle: (item: SettingItemTvModel) => { //为了灵犀的点击事件与触控事件
            if (item.name === '锐利度') {
              this.sharpnessValue = this.sharpnessSetting(this.sharpnessValue, 0, 100, undefined,false);
              item.setValue(this.sharpnessValue.toString());
              this.setSharpness()
            } else if (item.name === '随机降噪') {
              let origins: string[] = ['关闭', '低', '中', '高', '自动']
              origins.forEach((originItem, index) => {
                if (item.value === originItem) {
                  this.denoiseIndex = this.stringChange( index,undefined,false);
                }
              })
              // 实现页面静态交互
              this.denoise = origins[this.denoiseIndex]
              item.setValue(origins[this.denoiseIndex]);
              this.setNR()
            } else if (item.name === 'MPEG降噪') {
              let origins: string[] = ['关闭', '低', '中', '高', '自动']
              origins.forEach((originItem, index) => {
                if (item.value === originItem) {
                  this.mpegdEnoiseIndex = this.stringChange(index,undefined,false);
                }
              })
              // 实现页面静态交互
              this.mpegdEnoise = origins[this.mpegdEnoiseIndex]
              item.setValue(origins[this.mpegdEnoiseIndex]);
              this.setMpegNR()
            }
          }
        })
          .width('100%')
          .height('100%')
          .padding({ left: '2lpx' })
          .onTouch((event: TouchEvent) => {
            if (event.type === TouchType.Down) {
              this.tabClick()
            }
          })
      }
      .backgroundColor('#000000')
      .borderRadius({ topLeft: '16lpx', bottomLeft: '16lpx' })
      .opacity(0.85)
      .padding('48lpx')
      .width('33.33%')
      .height('100%')
    }
    .backgroundColor(Color.Transparent)
    .width('100%')
    .height('100%')
  }
}
