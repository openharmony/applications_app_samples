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
import LogManager from '../../common/Log/LogManager';
import { ColorMetrics, LengthMetrics } from '@kit.ArkUI';
import { systemParameter } from '@kit.BasicServicesKit';
import { preferences } from '@kit.ArkData';
import { fpChangeLpx, vpChangeLpx } from '../IssueReporter/models/IssueDetailInfo';

const TAG = 'NavigationBar';

@Component
export default struct NavigationBar {
  title: ResourceStr = '';
  rightItemImage: Resource = $r('app.media.icon_add');
  isHiddenBack: boolean = false;
  isHiddenRight: boolean = true;
  isHiddenTitle: boolean = false;
  onClickBackHandle?: () => void;
  onClickRightItemHandle?: () => void;
  private dataPreferences: preferences.Preferences =
    preferences.getPreferencesSync(getContext(this), { name: 'myStore' });
  @State isOpen: boolean = this.dataPreferences.getSync('openLog', false) as boolean;

  build() {
    Column() {
      Row() {
        Text(this.title)
          .fontSize(fpChangeLpx(54))
          .fontColor($r('app.color.default_white'))
          .visibility(!this.isHiddenTitle ? Visibility.Visible : Visibility.Hidden);
      }
      .focusable(false)
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .height('100%');

    }
    .width('100%')
    .height(vpChangeLpx(100))
    .alignItems(HorizontalAlign.Center)
    .margin({ top: vpChangeLpx(76) });
  }
}