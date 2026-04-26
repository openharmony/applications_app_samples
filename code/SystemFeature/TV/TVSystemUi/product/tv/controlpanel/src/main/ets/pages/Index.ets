/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
 

import { i18n } from '@kit.LocalizationKit';
import { emitter } from '@kit.BasicServicesKit';
import { inputEventClient } from '@kit.InputKit';
import { KeyCode } from '@kit.InputKit';
import { common } from '@kit.AbilityKit';
import { BrightnessDialog } from '../components/Brightness';
import { wifiManager } from '@kit.ConnectivityKit';
import { promptAction } from '@kit.ArkUI';
import MiraCastModel from '../controlPanelModel/MiraCastModel'

class MenuItem {
  public name: string = ''
}

class KeyEvent {
  public keyEvent: inputEventClient.KeyEvent | null = null
}

@Entry
@Component
struct Index {

  controller: TextClockController = new TextClockController() // 鏂囨湰鏃堕挓鎺у埗鍣?  // 浜害瀵硅瘽妗?  mBrightnessDialog: CustomDialogController = new CustomDialogController({
    // 鑷畾涔夊脊绐楀唴瀹规瀯閫犲櫒銆?    builder: BrightnessDialog({
      isShowBrightness: $isShowBrightness
    }),
    alignment: DialogAlignment.CenterStart, // 寮圭獥鍦ㄧ珫鐩存柟鍚戜笂鐨勫榻愭柟寮忎负闈犲乏涓婁笅灞呬腑銆?    isModal: false, // 寮圭獥鏄惁涓烘ā鎬佺獥鍙ｏ紝妯℃€佺獥鍙ｆ湁钂欏眰锛岄潪妯℃€佺獥鍙ｆ棤钂欏眰銆?    customStyle: true, // 寮圭獥瀹瑰櫒鏍峰紡鏄惁鑷畾涔夈€?  })
  @State isShow: boolean = true // 鎺у埗涓績鏄惁鏄剧ず
  @State wifiIsOn: boolean = true // wifi寮€鍏虫槸鍚︽墦寮€
  @State miraCastIsOn: boolean = false // 鎶曞睆寮€鍏虫槸鍚︽墦寮€
  @State bleIsOn: boolean = true // 钃濈墮寮€鍏虫槸鍚︽墦寮€
  @State isShowBrightness: boolean = false // 浜害鏉℃槸鍚︽樉绀?  @State hasClickTab: boolean = false // tab鐐瑰嚮鏄惁鎵ц杩?  @State accumulateTime: number = 0 // 褰撳墠鏃堕棿
  @State menuArray: MenuItem[] = [] // 鑿滃崟椤规暟缁?  @State focusIndex: number = 0 //鑱氱劍鐨勭储寮?  @State wifiName: string = '' //wifi鍚嶇О
  @State timerId: number | null = null // 瀹氭椂鍣?  @State timeFormat: string = ''

  // onPageShow 姣忔鎺у埗闈㈡澘鏄剧ず鏃堕兘閲嶆柊鎷夊彇 WiFi 鍜屾姇灞忕姸鎬侊紝
  // 鑰岄潪缂撳瓨锛屾槸鍥犱负鐢ㄦ埛鍙兘鍦ㄨ缃簲鐢ㄤ腑淇敼浜?WiFi/鎶曞睆鐘舵€佸悗鍐嶈繑鍥炴帶鍒堕潰鏉匡紝
  // 閲嶆柊鎷夊彇纭繚灞曠ず鐨勭姸鎬佷笌绯荤粺瀹為檯鐘舵€佷竴鑷达紝閬垮厤閿欒鍙嶉缁欑敤鎴枫€?  async onPageShow(): Promise<void> {
    this.getTimeFormat()
    this.isShow = true
    if (!this.hasClickTab) {
      setTimeout(() => {
        this.hasClickTab = true
        this.tabClick()
      }, 500)
    }

    // 鑾峰彇宸茶繛鎺iFi鍚嶇О
    try {
      const res: wifiManager.WifiLinkedInfo = await wifiManager.getLinkedInfo()
      this.wifiName = res!.ssid && res!.ssid.includes('unknown ssid') ? '鏈繛鎺? : res!.ssid
      Logger.info('systemui connected WiFi:', JSON.stringify(res), this.wifiName);
    } catch (e) {
      this.wifiName = '';
      Logger.info('systemui connected WiFi err:', JSON.stringify(e));
    }

    // 鑾峰彇鎶曞睆鐘舵€?    const miraCastStatus: string = MiraCastModel.getMiraCastStatus()
    this.miraCastIsOn = miraCastStatus === '1' ? true : false
  }

  onPageHide(): void {

    // focusControl.requestFocus('璁剧疆')
    if (this.mBrightnessDialog) {
      this.isShowBrightness = false
      this.mBrightnessDialog.close()
    }
  }

  // aboutToAppear 涓敞鍐?emitter 浜嬩欢鑰岄潪鍦ㄦ瀯閫犲嚱鏁伴噷娉ㄥ唽锛?  // 鏄洜涓?ArkUI 缁勪欢鐨?emitter 鍙湪缁勪欢鎸傝浇鍒伴〉闈㈡爲鍚庢墠鑳芥甯告帴鏀朵簨浠讹紝
  // 鎻愬墠娉ㄥ唽浼氬鑷翠寒搴﹀脊绐楀叧闂簨浠舵棤娉曡姝ｇ‘鍝嶅簲銆?  aboutToAppear(): void {
    this.wifiName = '';
    // 鎺ユ敹浜害缁勪欢閫氱煡鍏抽棴浜害鏉?    emitter.on('BRIGHTNESS_DIALOG_TIMER_EVENT', () => {
      if (this.mBrightnessDialog) {
        this.isShowBrightness = false
        this.mBrightnessDialog.close()
      }
    })

    this.menuArray = [
      { name: '璁剧疆' },
      { name: 'WIFI' },
      { name: '钃濈墮' },
      { name: '杈撳叆婧? },
      { name: '鎴睆' },
      { name: '褰曞埗' },
      { name: '浜害' },
      { name: '鎶曞睆' }]

    // 鍚姩鏂囨湰鏃堕挓
    this.controller.start()
  }


  // 鎺у埗涓績绐楀彛鎵撳紑鍚庯紝闇€瑕佹墜鍔ㄦ寜涓媡ab閿縺娲荤劍鐐癸紝姝ゆ柟娉曞彲浠ユā鎷熸墜鍔ㄦ寜tab閿殑鎿嶄綔
  // 鎺у埗闈㈡澘鐢?ServiceExtensionAbility 鎵樼鐨勭郴缁熺獥鍙ｆ壙杞斤紝绐楀彛寮瑰嚭鏃剁劍鐐逛笉浼氳嚜鍔ㄥ垎閰嶇粰鍐呴儴缁勪欢锛?  // 鍥犳闇€瑕佸欢杩?500ms 鍚庢敞鍏ヨ櫄鎷?Tab 閿潵婵€娲荤劍鐐瑰紩鎿庯紝璁╅仴鎺у櫒鏂瑰悜閿珛鍗冲彲鐢ㄣ€?  tabClick() {
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
    let eventDown: KeyEvent = { KeyEvent: keyDownOpt }
    let eventUp: KeyEvent = { KeyEvent: keyUpOpt }

    try {
      // 瑙﹀彂tab鐐瑰嚮锛屼娇榛樿鐒︾偣缁勪欢澶氭€佹牱寮忕敓鏁?      inputEventClient.injectEvent(eventDown);
      inputEventClient.injectEvent(eventUp);
    } catch (e) {
    }
  }

  getTimeFormat() {
    let is24HourClock: boolean = i18n.System.is24HourClock()
    console.log('鑾峰彇鏃堕棿 ',`is24HourClock锛?{is24HourClock}`);
    if (is24HourClock) {
      this.timeFormat =  'HH:mm'
      console.log('HmLog--> 鑾峰彇鏃堕棿 24');
    } else {
      this.timeFormat = 'aa hh:mm'
      console.log('HmLog--> 鑾峰彇鏃堕棿 12');
    }
  }

  // 鑿滃崟椤圭偣鍑讳簨浠?  // clickMenuItem 鐢?switch-case 缁熶竴澶勭悊鑿滃崟椤圭偣鍑伙紝姣忎釜鍔熻兘鎷夎捣瀵瑰簲 Ability 鍚庣珛鍗冲叧闂帶鍒堕潰鏉匡紝
  // 鏄负浜嗛伒寰?TV 鍗曚换鍔′氦浜掓ā鍨嬶細鎺у埗涓績涓嶅簲涓庤鎷夎捣鐨勫簲鐢ㄥ悓鏃跺崰鐢ㄥ睆骞曠劍鐐广€?  // 鎴睆鐗规畩澶勭悊寤惰繜 1 绉掑叧闂紝鏄负浜嗙粰鎴浘鏈嶅姟鐣欏嚭鎹曡幏灞忓箷鐨勬椂闂寸獥鍙ｏ紝閬垮厤鎴埌鎺у埗闈㈡澘鑷韩銆?  clickMenuItem(item: MenuItem) {
    switch (item.name) {
      case '璁剧疆': {
        // 鎷夎捣璁剧疆搴旂敤
        (getContext() as common.UIAbilityContext).startAbility({
          bundleName: 'com.ohos.settings',
          abilityName: 'com.ohos.settings.MainAbility'
        }).then(() => {
          // 璁剧疆鎷夎捣鍚庡彂閫侀€氱煡鍏抽棴鎺у埗涓績绐楀彛
          emitter.emit('CONTROLLER_CENTER_EVENT');
        }).catch((e: string) => {
        })
        break;
      }
      case 'WIFI': {

        (getContext() as common.UIAbilityContext).startAbility({
          bundleName: 'com.ohos.settings',
          abilityName: 'com.ohos.settings.MainAbility',
          parameters: {
            pageUrl: 'WIFI'
          },
        }).then(() => {
          // 鎴睆鎷夎捣鍚庡彂閫氱煡鍏抽棴鎺у埗涓績绐楀彛
          emitter.emit('CONTROLLER_CENTER_EVENT');
        }).catch((e: string) => {
          console.log('systemui111-->item.name', item.name + '鎷夎捣澶辫触', e);
        })
        break;
      }
      case '钃濈墮': {

        (getContext() as common.UIAbilityContext).startAbility({
          bundleName: 'com.ohos.settings',
          abilityName: 'com.ohos.settings.MainAbility',
          parameters: {
            pageUrl: 'BLUETOOTH'
          },
        }).then(() => {
          // 鎴睆鎷夎捣鍚庡彂閫氱煡鍏抽棴鎺у埗涓績绐楀彛
          emitter.emit('CONTROLLER_CENTER_EVENT');
        }).catch((e: string) => {
          console.log('systemui111-->item.name', item.name + '鎷夎捣澶辫触', e);
        })
        break;
      }
      case '鎴睆': {
        // 鎷夎捣鎴睆搴旂敤
        (getContext() as common.UIAbilityContext).startAbility({
          bundleName: 'com.ohos.screenshot',
          abilityName: 'com.ohos.screenshot.ServiceExtAbility'
        }).then(() => {
          this.isShow = false;
          this.hasClickTab = false
          setTimeout(() => {
            // 鎴睆鎷夎捣鍚庡彂閫氱煡鍏抽棴鎺у埗涓績绐楀彛
            emitter.emit('CONTROLLER_CENTER_EVENT');
          }, 1000)
        }).catch((e: string) => {
        })
        break;
      }
      case '褰曞埗': {
        // 鎷夎捣褰曞埗搴旂敤
        (getContext() as common.UIAbilityContext).startAbility({
          bundleName: 'ohos.samples.screenrecorder',
          abilityName: 'ScreenRecorderAbility'
        }).then(() => {
          // 褰曞埗鎷夎捣鎴愬姛鍚庡彂閫氱煡鍏抽棴鎺у埗涓績绐楀彛
          emitter.emit('CONTROLLER_CENTER_EVENT');
        }).catch((e: string) => {
        })
        break;
      }
      case '杈撳叆婧?: {
        // 鎷夎捣杈撳叆婧愬簲鐢?        (getContext() as common.UIAbilityContext).startAbility({
          bundleName: 'com.ohos.inputsource',
          abilityName: 'EntryAbility'
        }).then(() => {
          // 杈撳叆婧愭媺璧锋垚鍔熷悗鍙戦€氱煡鍏抽棴鎺у埗涓績绐楀彛
          emitter.emit('CONTROLLER_CENTER_EVENT');
        }).catch((e: string) => {
        })
        break;
      }
      case '浜害': {
        // 鎵撳紑浜害鏉?        this.isShowBrightness = true
        this.mBrightnessDialog.open()
        // 灏嗘帶鍒朵腑蹇冭彍鍗曢」闅愯棌
        this.isShow = false
        this.hasClickTab = false
        break;
      }
      case '鎶曞睆': {
        this.miraCastIsOn = !this.miraCastIsOn
        MiraCastModel.setMiraCastStatus(this.miraCastIsOn ? '1' : '0')
        promptAction.showToast({ message: this.miraCastIsOn ? '鎶曞睆宸叉墦寮€' : '鎶曞睆宸插叧闂? })
        break;
      }
      default: {
        break;
      }
    }
  }

  build() {
    Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.End }) {
      Column({ space: '48lpx' }) {
        Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
          // 浠?2灏忔椂鍒舵樉绀轰笢鍏尯鐨勭郴缁熸椂闂达紝绮剧‘鍒版湀鏃ユ槦鏈?          TextClock({ timeZoneOffset: -8, controller: this.controller })
            .format('M鏈坉鏃? EEEE')
            .onDateChange((value: number) => {
              this.accumulateTime = value
            })
            .fontSize('36lpx')
            .fontColor('#FFFFFF')
            .fontWeight(FontWeight.Medium)
          // 浠?2灏忔椂鍒舵樉绀轰笢鍏尯鐨勭郴缁熸椂闂达紝绮剧‘鍒版椂鍒?          TextClock({ timeZoneOffset: -8, controller: this.controller })
            .format(this.timeFormat)
            .fontSize('36lpx')
            .fontWeight(FontWeight.Medium)
            .onDateChange((value: number) => {
              this.accumulateTime = value
            })
            .fontColor('#FFFFFF')
        }
        .padding(5)

        List({ space: '24lpx' }) {
          ForEach(this.menuArray, (item: MenuItem, index: number) => {
            ListItem() {
              Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
                Text(item.name)
                  .fontSize('30lpx')
                  .fontColor(this.focusIndex === index ? '#000000' : '#FFFFFF')
                  .fontWeight(FontWeight.Medium)
                  .focusable(true)
                  .stateStyles({
                    focused: {
                      .border({
                        color: Color.Transparent
                      })
                    }
                  })
                Row() {
                  if (item.name === 'WIFI') {
                    Text(this.wifiName || '鏈繛鎺?)
                      .fontSize('25lpx')
                      .fontColor(this.focusIndex === index ? '#000000' : '#FFFFFF')
                      .fontWeight(FontWeight.Medium)
                      .textOverflow({ overflow: TextOverflow.MARQUEE })
                      .width('200lpx')
                      .textAlign(TextAlign.End)
                  } else if (item.name === '钃濈墮') {
                    // Text(this.bleName || '鏈繛鎺?)
                    //   .fontSize('25lpx')
                    //   .fontColor(this.focusIndex === index ? '#000000' : '#FFFFFF')
                    //   .fontWeight(FontWeight.Medium)
                  }
                  if (!['鎴睆', '褰曞埗', '浜害', '鎶曞睆'].includes(item.name)) {
                    Image(this.focusIndex === index ? $r('app.media.chevron_right_black') :
                    $r('app.media.chevron_right_white'))
                      .width('24lpx')
                      .height('36lpx')
                      .margin({ left: '12lpx' })
                      .focusable(false)
                  }
                }

                //
                //     $r('app.media.chevron_right_white'))
              }
              .padding('24lpx')
              .backgroundColor(this.focusIndex === index ? '#FFFFFF' : '#20FFFFFF')
              .borderRadius('18lpx')
            }
            .backgroundColor(this.focusIndex === index ? '#333333' : Color.Transparent)
            .border({ width: 2, radius: '24lpx', color: this.focusIndex === index ? '#FFFFFF' : Color.Transparent })
            .padding(2.5)
            .onClick(() => {
              this.clickMenuItem(item)
            })
            .onFocus(() => {
              this.focusIndex = index
            })
            // .onKeyEvent((event) => {

            // })
            .key(item.name)
          },
            (item: MenuItem, index: number) => item.name + index.toString())
        }
        .width('100%')
        .constraintSize({ maxHeight: '85%' })

        // .scrollBar(BarState.Off)
      }
      .backgroundColor('#000000')
      .borderRadius({ topLeft: '16lpx', bottomLeft: '16lpx' })
      .opacity(0.85)
      .padding('48lpx')
      .width('33.33%')
      .height('100%')
      .visibility(this.isShow ? Visibility.Visible : Visibility.Hidden)
    }
    .backgroundColor(Color.Transparent)
    .width('100%')
    .height('100%')
  }
}
