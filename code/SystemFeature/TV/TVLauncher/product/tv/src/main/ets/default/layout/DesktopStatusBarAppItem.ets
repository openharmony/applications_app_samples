/**
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

import { Log } from '@ohos/common';
import { AppItemInfo } from '../../common/bean/AppItemInfo';
import { Want } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { LengthMetrics } from '@kit.ArkUI';
import { common, OpenLinkOptions } from '@kit.AbilityKit';
import { EventUtil } from '../../common/utils/EventUtil';

const TAG = 'DesktopStatusBarAppItem';
const SOURCE_TOOL_SEVEN = 7;

@Component
export default struct DesktopStatusBarAppItem {
  @ObjectLink app: AppItemInfo;
  @StorageProp('network_ok') isNetworkStateOk: boolean = false
  private idx: number = 0;

  getKey() {
    console.log('HmLog-->getKey', `${this.app.appName}_${this.idx}`);
    return `${this.app.appName}_${this.idx}`
  }

  openLink(url: string) {
    let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
    let link: string = url
    let openLinkOptions: OpenLinkOptions = {
      appLinkingOnly: false
    };
    console.info(TAG, 'open link str link:' + link);
    try {
      context.openLink(link, openLinkOptions).then(() => {
        console.info(TAG, 'open link success.');
      }).catch((err: BusinessError) => {
        console.error(TAG, 'open link error...' + JSON.stringify(err));
      });
    } catch (paramError) {
      console.info(TAG, 'openLink error:' + JSON.stringify(paramError));
    }
  }

  jumpPage = ()=>{
    if (this.app.appName === 'SEARCH') {
      if (this.isNetworkStateOk) {
        let url = 'funshion://com.funshion.launcher/jump_page?jump_data=action_template..search'
        this.openLink(url)
      } else {
        let want: Want = {
          bundleName: 'com.ohos.globalsearch',
          abilityName: 'SearchAbility'
        };
        Log.showInfo(TAG, `onKeyEvent want: ` + JSON.stringify(want))
        globalThis.desktopContext.startAbility(want).then(() => {
          console.log('success:');
        }).catch((error: BusinessError) => {
          console.log('failed:' + JSON.stringify(error));
        });
      }
    } else {
      let want: Want = {
        bundleName: 'com.ohos.settings',
        abilityName: 'com.ohos.settings.MainAbility',
        parameters: {
          pageUrl: this.app.appName as string
        }
      };
      Log.showInfo(TAG, `onKeyEvent want: ` + JSON.stringify(want))
      globalThis.desktopContext.startAbility(want).then(() => {
        console.log('success:');
      }).catch((error: BusinessError) => {
        console.log('failed:' + JSON.stringify(error));
      });
    }
  }

  build() {
    Column() {
      Image(this.app.isFocus ? this.app.onFocusIcon : this.app.icon)
        .width(this.app.isFocus ? 80 + 'lpx' : 60 + 'lpx')
        .aspectRatio(1)
        .key(this.getKey())
        .focusable(true)
        .focusBox({
          strokeWidth: LengthMetrics.px(0)
        })
        .onFocus(() => {
          Log.showInfo(TAG, `onFocus item: ${this.app.appName}, index: ${this.idx}`)
          this.app.isFocus = true;
        })
        .onBlur(() => {
          Log.showInfo(TAG, `onBlur item: ${this.app.appName}, index: ${this.idx}`)
          this.app.isFocus = false;
        })
        .onClick(this.jumpPage)
        .onTouch((event) => {
          if (!EventUtil.isTouchEvent(event)) {
            return;
          }
          if (event.sourceTool !== SourceTool.Pen && event.sourceTool !== SOURCE_TOOL_SEVEN) {
            return;
          }
          this.app.isFocus = true;
          this.jumpPage();
        })
        .onHover((isHover: boolean, event: HoverEvent) => {
          if (isHover) {
            this.app.isFocus = true;
          } else {
            this.app.isFocus = false;
          }
        })
    }.width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}