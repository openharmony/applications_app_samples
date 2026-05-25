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
import router from '@ohos.router';
import { fpChangeLpx, vpChangeLpx } from './models/IssueDetailInfo';
import { ColorMetrics, LengthMetrics } from '@kit.ArkUI';
import { preferences } from '@kit.ArkData';
import { tabClick } from '../Index';
import json from '@ohos.util.json';
import { KeyCode } from '@ohos.multimodalInput.keyCode';
import { EventUtil } from '../common/EventUtil';

const TAG = 'IssueReporterHome';
const sourceToolMouseClick: number = 7;

@Entry
@Component
export default struct IssueReporterHome {
  @State arrayList: ResourceStr[] =
    [$r('app.string.create_a_new_questionnaire'), $r('app.string.list_of_questions'), $r('app.string.instructions')];
  @State currentIndex: number = 0;
  private dataPreferences: preferences.Preferences =
    preferences.getPreferencesSync(getContext(this), { name: 'myStore' });
  @State isOpen: boolean = this.dataPreferences.getSync('openLog', false) as boolean;

  // aboutToAppear() {
  //   tabClick()
  // }

  build() {
    Column() {
      Column() {
        Text($r('app.string.EntryAbility_label'))
          .fontSize(fpChangeLpx(64))
          .fontWeight(500)
          .fontColor($r('app.color.default_white'))
          .margin({ bottom: vpChangeLpx(93) });
        ForEach(this.arrayList, (item: ResourceStr, index: number) => {
          Row() {
            Row() {
              Text(item)
                .fontSize(fpChangeLpx(36))
                .fontWeight(500)
                .fontColor(this.currentIndex === index ? $r('app.color.global_default_background') :
                $r('app.color.default_white'));
              Image($r('app.media.icon_arrow_right'))
                .width(vpChangeLpx(21))
                .height(vpChangeLpx(34))
                .fillColor(this.currentIndex === index ? $r('app.color.global_default_background') :
                $r('app.color.default_white'))
                .visibility(index === 3 ? Visibility.None : Visibility.Visible);
            }
            .id('' + index)
            .focusBox({
              margin: LengthMetrics.px(2),
              strokeColor: ColorMetrics.resourceColor($r('app.color.button_transParent')),
              strokeWidth: LengthMetrics.px(2)
            })
            .onHover(() => {
              this.currentIndex = index;
              AppStorage.setOrCreate('page', index);
              focusControl.requestFocus('' + index);
            })
            .onTouch((event) => {
              this.currentIndex = index;
              AppStorage.setOrCreate('page', index);
              focusControl.requestFocus('' + index);
              if (!EventUtil.isTouchEvent(event)) {
                return;
              }
              if (event.sourceTool !== SourceTool.Pen && event.sourceTool !== sourceToolMouseClick) {
                return;
              }
            })
            .onClick(() => {
              focusControl.requestFocus('' + index);
              switch (this.currentIndex) {
                case 0:
                  console.log('点击了创建', index, this.currentIndex);
                  AppStorage.setOrCreate('page', 0);
                  router.pushUrl({
                    url: 'pages/IssueReporter/IssueReporterAdd',
                  });
                  break;
                case 1:
                  console.log('点击了创建', index, this.currentIndex);
                  AppStorage.setOrCreate('page', 1);
                  router.pushUrl({
                    url: 'pages/IssueReporter/views/IssueReporterList',
                  });
                  break;
                case 2:
                  console.log('点击了创建', index, this.currentIndex);
                  AppStorage.setOrCreate('page', 2);
                  router.pushUrl({
                    url: 'pages/IssueReporter/UseIntroduction',
                  });
                  break;
                default:
                  break;
              }
            })
            .height(vpChangeLpx(94))
            .width('100%')
            .backgroundColor(this.currentIndex === index ? $r('app.color.default_white') :
            $r('app.color.choose_background'))
            .padding({ left: vpChangeLpx(36), right: vpChangeLpx(36) })
            .justifyContent(FlexAlign.SpaceBetween)
            .borderRadius(vpChangeLpx(18));
          }
          .margin({ bottom: vpChangeLpx(24) })
          .focusable(true)
          .onKeyEvent((item) => {
            if (item.type == 0) {
              let focus: number = AppStorage.get('page') as number;
              console.log('熊', focus, ':', this.currentIndex, ':', json.stringify(item));

              if (focus == 0) {
                if (item.keyCode == KeyCode.KEYCODE_DPAD_DOWN) {
                  this.currentIndex = 1;
                  AppStorage.setOrCreate('page', 1);
                  focusControl.requestFocus('1');
                } else if (item.keyCode == KeyCode.KEYCODE_DPAD_UP) {
                  AppStorage.setOrCreate('page', 0);
                  this.currentIndex = 0;
                  focusControl.requestFocus('0');
                }
              } else if (focus == 1) {
                if (item.keyCode == KeyCode.KEYCODE_DPAD_DOWN) {
                  AppStorage.setOrCreate('page', 2);
                  this.currentIndex = 2;
                  focusControl.requestFocus('2');
                } else if (item.keyCode == KeyCode.KEYCODE_DPAD_UP) {
                  AppStorage.setOrCreate('page', 0);
                  this.currentIndex = 0;
                  focusControl.requestFocus('0');
                }
              } else if (focus == 2) {
                if (item.keyCode == KeyCode.KEYCODE_DPAD_UP) {
                  AppStorage.setOrCreate('page', 1);
                  this.currentIndex = 1;
                  focusControl.requestFocus('1');
                } else if (item.keyCode == KeyCode.KEYCODE_DPAD_DOWN) {
                  AppStorage.setOrCreate('page', 2);
                  this.currentIndex = 2;
                  focusControl.requestFocus('2');
                }
              }
            }
          })
          .height(vpChangeLpx(118))
          .padding({ left: vpChangeLpx(10), right: vpChangeLpx(10) })
          .width('100%')
          .justifyContent(FlexAlign.Center)
          .alignItems(VerticalAlign.Center)
          .border(this.currentIndex === index ?
            { width: vpChangeLpx(2), color: $r('app.color.default_white'), radius: vpChangeLpx(24) } : null);
        });
      };
    }
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .padding({
      top: vpChangeLpx(173),
      bottom: vpChangeLpx(240),
    })
    .backgroundColor($r('app.color.global_default_background'));
  }
}