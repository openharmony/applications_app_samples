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
 
import { DesktopAppListLayout } from '../default/layout/DesktopAppListLayout';
import { DesktopStatusBarLayout } from '../default/layout/DesktopStatusBarLayout';
import { DesktopImmersiveLayout } from '../default/layout/DesktopImmersiveLayout';
import lazy { launcherAbilityManager } from '@ohos/common';
import { Log } from '@ohos/common';
import { systemParameter} from '@kit.BasicServicesKit';
import lazy PreferenceUtils, { BooleanPreferences } from '../common/baseUtil/PreferenceUtil';

import lazy  { inputConsumer } from '@kit.InputKit';
import lazy { KeyCode } from '@kit.InputKit';
import lazy { windowManager } from '@ohos/common/src/main/ets/default/manager/WindowManager';
import lazy { EventUtil } from '../common/utils/EventUtil';

import Madvise from 'libentry.so';

const TAG = "EntryView";
const KEYDOWN_DURATION: number = 300


@Entry
@Component
struct EntryView {

  madviseFile(files:string) {
    try {
      let startTime = Date.now()
      Madvise.madviseGeneralFiles(files);
      Log.showDebug( 'MadviseMemory file', `优化耗时 ${Date.now() - startTime}ms --> ${files}}`);
    } catch (error) {
      Log.showError( 'MadviseMemory', `madViseFile 执行异常: ${error}`);
    }
  }

  madviseSo(soFiles:string) {
    try {
      let startTime = Date.now();
      Madvise.madviseFiles(soFiles);
      Log.showDebug( 'MadviseMemory', `优化耗时 ${Date.now() - startTime} ms -->. ${soFiles}`);
    } catch (error) {
      Log.showError( 'MadviseMemory', `madViseSo 执行异常: ${error}`);
    }
  }

  aboutToAppear(): void {
    this.getUIContext().getFocusController().activate(true, false)
  }

  aboutToDisappear(): void {
    this.unSubscribeRecent()
    this.getUIContext().getFocusController().activate(false)
  }

  onPageShow(): void {
    let firstActivate: boolean | undefined = AppStorage.get('firstActivate');
    if (firstActivate) {
      this.voteBootEvent();
    }
    setTimeout(()=>{
      this.subscribeRecent()
      this.initInputSource()
    },200)

    const fileArr = [
      "HarmonyOS_Sans_SC.ttf",
      "HarmonyOS_Sans.ttf",
      "icudt72l.dat",
      "zoneinfo64.res",
      "tv_launcher.hap"];

    setTimeout(()=>{
      this.madviseFile(fileArr.join('/'))
    },8000)

    const soArr = [
      "libwm.z.so",
      "libskia_canvaskit.z.so",
      "libwindow_native_kit.z.so",
      "libimage_napi.z.so",
      "libcrypto_openssl.z.so",
      "libappkit_native.z.so",
      "libpointer.z.so",
      "libaccount_iam_innerkits.z.so",
      "libpinauth_framework.z.so",
      "libaccount_iam_napi.z.so",
      "libconnection_if.z.so",
      "libedm_commom.z.so",
      "libinstaller.z.so",
      "libabilitykit_native.z.so",
      "libosaccount.z.so",
      "libdomain_account_napi.z.so",
      "libdisplay_napi.z.so",
      "libark_tooling.so",
      "libcommoneventmanager.z.so",
      "libedmservice_kits.z.so",
      "libsg_collect_sdk.z.so",
      "libusbsrv_client.z.so",
      "libabilityms.z.so",
      "libappexecfwk_base.z.so",
      "libethernet_manager_if.z.so",
      "libservice_extension.z.so",
      "libwindow_napi.z.so",
      "libwifi_sdk.z.so",
      "libethernet.z.so",
      "libappexecfwk_core.z.so",
      "libuserauth_client.z.so",
      "libaccount_napi_common.z.so",
      "libssl_openssl.z.so",
      "libsettings.z.so",
      "liblauncherbundlemanager.z.so",
      "libhisysevent_napi.z.so",
      "libability_thread.z.so",
      "libdm.z.so",
      "libace_compatible.z.so",
    ];

    soArr.forEach( (each,idx) =>{
      setTimeout(()=>{
        this.madviseSo(each)
      },12000+300*idx)
    })

  }

  subscribeRecent() {
    inputConsumer.on("key", {
      preKeys: [],
      finalKey: KeyCode.KEYCODE_MOVE_HOME,
      isFinalKeyDown: true,
      finalKeyDownDuration: KEYDOWN_DURATION
    }, (data) => {
      let isNoComplete = AppStorage.get('isNoCompleteHomePress') as boolean
      let isSetup = AppStorage.get('isSetupHomePress') as boolean
      if(!(isSetup || isNoComplete)){
        windowManager.createRecentWindow()
      }
    })

    // 增加蓝牙模式
    inputConsumer.on("key", {
      preKeys: [],
      finalKey: KeyCode.KEYCODE_HOME,
      isFinalKeyDown: true,
      finalKeyDownDuration: KEYDOWN_DURATION
    }, (data) => {
      let isNoComplete = AppStorage.get('isNoCompleteHomePress') as boolean
      let isSetup = AppStorage.get('isSetupHomePress') as boolean
      if(!(isSetup || isNoComplete)){
        windowManager.createRecentWindow()
      }
    })

    inputConsumer.on("key", {
      preKeys: [],
      finalKey: KeyCode.KEYCODE_DAGGER_LONG_PRESS,
      isFinalKeyDown: true,
      finalKeyDownDuration: 0
    }, (data) => {
      let isNoComplete = AppStorage.get('isNoCompleteHomePress') as boolean
      let isSetup = AppStorage.get('isSetupHomePress') as boolean
      if (!(isSetup || isNoComplete)) {
        windowManager.createRecentWindow()
      }
    })
  }

  unSubscribeRecent() {
    inputConsumer.off("key", {
      preKeys: [],
      finalKey: KeyCode.KEYCODE_MOVE_HOME,
      isFinalKeyDown: true,
      finalKeyDownDuration: KEYDOWN_DURATION
    })

    inputConsumer.off("key", {
      preKeys: [],
      finalKey: KeyCode.KEYCODE_DAGGER_LONG_PRESS,
      isFinalKeyDown: true,
      finalKeyDownDuration: 0
    })
  }

  initInputSource() {
    let preInstance = new PreferenceUtils<boolean>(getContext(), false)
    let pre = new  PreferenceUtils<string>(getContext(), "")
    // 是否为开机状态
    const isReboot = AppStorage.get('isReboot') as boolean
    // 是否打开输入源
    const defaultInputSource = preInstance.getPreValue('defaultInputSource')
    // 默认输入源
    const item = pre.getPreValue('InputSourceType')
    Log.showInfo(TAG, 'isRebooted: ' + isReboot + ' defaultInputSource: ' + defaultInputSource,'InputSourceType',item)
    if (defaultInputSource && isReboot) {
      try {
        launcherAbilityManager.startLauncherAbility('EntryAbility','com.ohos.inputsource', '',[item]);
      } catch (e) {
        Log.showInfo(TAG, 'fail to openAppLink' + `${e}`);
      }
    }
  }

  private voteBootEvent(): void {
    Log.showInfo(TAG, 'voteBootEvent for launcher begin');
    try {
      AppStorage.setOrCreate('firstActivate', false);
      AppStorage.setOrCreate('loaded', true);
      systemParameter.setSync('bootevent.launcher.ready', 'true');
    } catch (err) {
      Log.showError(TAG, `set voteBootEvent err, ${JSON.stringify(err)}`);
    }
    Log.showInfo(TAG, 'voteBootEvent for launcher end');
  }

  build() {
    Column() {
      DesktopStatusBarLayout()
        .position({ x: 0, y: 0 })
        .zIndex(3)

      DesktopImmersiveLayout()
        .position({ x: 0, y: 0 })
        .size({ width: '100%', height: '100%' })

      DesktopAppListLayout()
        .position({ x: 0, y: '62%' })
        .size({ width: '100%', height: '33%' })

    }
    .width('100%')
    .height('100%')
    .onTouch((event) => {
      EventUtil.isTouchEvent(event);
    })
  }
}
