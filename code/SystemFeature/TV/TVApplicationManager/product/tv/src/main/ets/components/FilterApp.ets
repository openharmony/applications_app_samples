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
interface filterApp {
  bundleName: string,
  abilityName: string,
  icon?: ResourceStr
}

const appList: filterApp[] = [
  { bundleName: 'com.ohos.camera', abilityName: 'com.ohos.camera.MainAbility' },
  { bundleName: 'com.ohos.callui', abilityName: 'com.ohos.callui.MainAbility' },
  { bundleName: 'com.ohos.contacts', abilityName: 'com.ohos.contacts.MainAbility' },
  { bundleName: 'com.ohos.mms', abilityName: 'com.ohos.mms.MainAbility' },
  { bundleName: 'com.ohos.updateapp', abilityName: 'com.ohos.updateapp.MainAbility' },
  { bundleName: 'com.ohos.note', abilityName: 'MainAbility' },
  { bundleName: 'com.ohos.photos', abilityName: 'com.ohos.photos.MainAbility' },
  { bundleName: 'ohos.samples.distributedcalc', abilityName: 'MainAbility' },
  { bundleName: 'ohos.samples.etsclock', abilityName: 'MainAbility' },
  { bundleName: 'com.ohos.dtvplayer', abilityName: 'MainAbility' },
  { bundleName: 'com.ohos.launcher', abilityName: 'MainAbility' },
  { bundleName: 'com.ohos.launcher', abilityName: 'AppDetailAbility' },
  { bundleName: 'com.ohos.setupwizard', abilityName: 'EntryAbility' },
  { bundleName: 'com.ohos.smartperf', abilityName: 'MainAbility' },
  { bundleName: 'com.qcode.jsviewapp', abilityName: 'EntryAbility' },
  { bundleName: 'com.ohos.globalsearch', abilityName: 'SearchAbility' },
];
const iconList: filterApp[] = [

  { bundleName: 'com.ohos.note', abilityName: 'MainAbility', icon: 'app.media.bwl' }, //备忘录
  { bundleName: 'com.ohos.demandplayer', abilityName: 'MainAbility', icon: 'app.media.spbfq1' }, //视频播放器
  { bundleName: 'com.ohos.aiface', abilityName: 'MainAbility', icon: 'app.media.rl' }, //ai人脸
  { bundleName: 'com.ohos.dtvplayer', abilityName: 'MainAbility', icon: 'app.media.db' }, //点播'
  { bundleName: 'com.samples.album', abilityName: 'MainAbility', icon: 'app.media.tuku' }, //图库
  { bundleName: 'ohos.samples.browser1', abilityName: 'MainAbility', icon: 'app.media.llq' }, //浏览器
  {
    bundleName: 'ohos.samples.distributedmusicplayer',
    abilityName: 'ohos.samples.distributedmusicplayer.MainAbility',
    icon: 'app.media.yy'
  }, //音乐
  { bundleName: 'com.ohos.inputsource', abilityName: 'EntryAbility', icon: 'app.media.sry1' }, //输入源
  { bundleName: 'com.samples.camera', abilityName: 'EntryAbility', icon: 'app.media.xj' }, //相机
  { bundleName: 'com.ohos.settings', abilityName: 'com.ohos.settings.MainAbility', icon: 'app.media.shezhi' }, //设置
  { bundleName: 'com.laval.betaclub', abilityName: 'EntryAbility', icon: 'app.media.td' }, // 提单应用
  { bundleName: 'tv.fun.appstore', abilityName: 'EntryAbility', icon: 'app.media.sc' }, // 橙子市场
  { bundleName: 'com.funshion.launcher', abilityName: 'EntryAbility', icon: 'app.media.xf' }, // 风行
  { bundleName: 'com.funshion.launcher.edu', abilityName: 'EntryAbility', icon: 'app.media.lx' }, // 乐学
  { bundleName: 'com.funshion.launcher.movie', abilityName: 'EntryAbility', icon: 'app.media.bb' }, // 瓣瓣
  { bundleName: 'com.funshion.launcher.child', abilityName: 'EntryAbility', icon: 'app.media.sr' },// 少儿
];

export default class FilterAppList {
  handleFilter(app: string) {
    let target = appList.filter(e => JSON.stringify(e) === app);
    if (target.length > 0) {
      return false;
    }
    return true;
  }

  handleIcon(app: string) {
    let target = iconList.filter(e => JSON.stringify(e.bundleName) === app);
    if (target.length > 0) {
      return target[0].icon;
    }
    return false;
  }
};


