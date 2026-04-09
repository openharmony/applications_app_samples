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

import lpx from '../../../common/Lpx';
import { SettingBackground } from '../../../default/layout/SettingBackground';
import { display, LengthMetrics, promptAction } from '@kit.ArkUI';
import { Ratio } from '../../../common/Ratio';
import { common, launcherBundleManager } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { KeyCode } from '@kit.InputKit';
import { EventUtil } from '../../../common/EventUtil';
import { SourcetoolConstants } from '../../../common/constants/StyleConstants';

const TAG = 'Application'
const CURRENT_ID = 100;

@Observed
class AppItem {
  public icon?: string
  public name?: string
  public linkTo?: string
  public bundleName?: string
  public abilityName?: string
}

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
  { bundleName: 'com.ohos.settings', abilityName: 'com.ohos.settings.MainAbility' }
]

@Entry
@Component
struct Application {
  @State apps: AppItem[] = [];
  @State displays: display.Display[] = [];
  @State imageUrl: string = Ratio.resName('icon_expansion')
  @State des: string = getContext(this).resourceManager.getStringByNameSync('screen_expansion')
  @State currentIndex: number = 0
  @State isFocusApplication: boolean = false
  @State selectDisplay: display.Display | undefined = undefined
  private scroller: Scroller = new Scroller();

  aboutToAppear(): void {
    this.loadAllApp()
    this.getAllDisplay()
  }
  // 获取全部应用
  loadAllApp(): void {
    let temp: AppItem[] = []
    launcherBundleManager.getAllLauncherAbilityInfo(CURRENT_ID).then((infos) => {
      infos.forEach(i => {
        try {
          let moduleContext: Context =
          globalThis.settingsAbilityContext.createModuleContext(i.elementName.bundleName, i.elementName.moduleName);
          let icon = moduleContext.resourceManager.getMediaContentBase64Sync(i.iconId);
          let name = moduleContext.resourceManager.getStringSync(i.labelId);
          let searchItem: AppItem = new AppItem()
          searchItem.icon = icon
          searchItem.name = name
          searchItem.bundleName = i.elementName.bundleName
          searchItem.abilityName = i.elementName.abilityName
          temp.push(searchItem);
          //过滤多余应用
          temp = temp.filter(app =>
          !appList.some(toFilter => toFilter.bundleName === app.bundleName && toFilter.abilityName === app.abilityName))
          this.apps = temp
          setTimeout(() => {
            try {
              this.getUIContext().getFocusController().requestFocus('Application' + 0)
            } catch (error) {
              console.log('Application', '定焦失败')
            }
          }, 200)

        } catch (e) {
          console.error('createModuleContext error' + JSON.stringify(e));
        }
      })
    })
  }

  getAllDisplay() {
    try {
      let defaultDisplay: display.Display = display.getDefaultDisplaySync();
      display.getAllDisplays().then((value) => {
        this.displays = value.filter((d) => d.id != defaultDisplay.id)
        if (this.displays?.length > 0) {
          this.selectDisplay = this.displays[0]
        } else {
          promptAction.showToast({ message: $r('app.string.diffdisplay_not_found_expandscreen') })
        }
      })
    } catch (err) {
      console.error(TAG + 'loadDisplay occur error. errInfo: ' + JSON.stringify(err))
      promptAction.showToast({ message: $r('app.string.diffdisplay_check_expandscreen_error', JSON.stringify(err)) })
    }
  }

  build() {
    Stack() {
      SettingBackground()
        .position({ x: 0, y: 0 })
        .height('100%')
        .width('100%')

      Row() {
        Column() {
          Column() {
            Text($r('app.string.application_to_be_launched'))
              .height(lpx(75))
              .lineHeight(lpx(75))
              .fontColor(Color.White)
              .fontSize(lpx(64))
              .fontWeight(500)
              .textAlign(TextAlign.Start)
              .focusable(false)
              .margin({
                top: lpx(48),
                bottom: lpx(48),
                left: lpx(12)
              })

            List({scroller:this.scroller}) {
              ForEach(this.apps, (item: AppItem, index: number) => {
                ListItem() {
                  Row() {
                    Row() {
                      Stack({ alignContent: Alignment.Center }) {
                        Image($r(this.currentIndex == index ? 'app.media.white' : 'app.media.grey'))
                          .zIndex(5)
                          .borderRadius('18lpx')
                          .width('72lpx')
                          .height('72lpx')
                        Image(item.icon)
                          .height('44lpx')
                          .aspectRatio(1)
                          .objectFit(ImageFit.Contain)
                          .interpolation(ImageInterpolation.High)
                          .syncLoad(true)
                          .zIndex(5)
                          .grayscale(this.currentIndex == index ? 0 : 1)
                      }
                      .padding('5lpx')
                      .margin({ left: lpx(24) })

                      Text(item.name)
                        .height(lpx(98))
                        .fontColor(this.currentIndex == index ? Color.Black : Color.White)
                        .fontSize(lpx(36))
                        .align(Alignment.Center)
                        .textAlign(TextAlign.Start)
                        .margin({
                          left: lpx(24)
                        })

                    }
                    .width(this.currentIndex == index ? lpx(846) : lpx(840))
                    .height(lpx(98))
                    .backgroundColor(this.currentIndex == index ? 'rgba(255, 255, 255, 0.86)' :
                      'rgba(255, 255, 255, 0.2)')
                    .borderRadius(lpx(18))
                  }
                  .height(lpx(118))
                  .width(lpx(868))
                  .borderRadius(lpx(18))
                  .border({
                    width: this.currentIndex == index ? lpx(2) : 0,
                    color: Color.White,
                    radius: lpx(22),
                    style: BorderStyle.Solid
                  })
                  .justifyContent(FlexAlign.Center)
                  .alignItems(VerticalAlign.Center)
                  .onClick(()=>{
                    if (!this.selectDisplay) {
                      promptAction.showToast({ message: $r('app.string.diffdisplay_connect_expand') })
                      return
                    }
                    if (!item) {
                      promptAction.showToast({ message: $r('app.string.diffdisplay_app_notset') })
                      return
                    }
                    let context = getContext(this) as common.UIAbilityContext;
                    let want: Want = {
                      bundleName: item.bundleName,
                      abilityName: item.abilityName
                    }
                    console.log(TAG, 'startApplication want = ' + JSON.stringify(want));
                    context.startAbility(want, {
                      displayId: this.selectDisplay?.id
                    }
                    ).then(() => {
                      console.log(TAG, 'startApplication promise success');
                    }, (err: BusinessError) => {
                      promptAction.showToast({ message: $r('app.string.diffdisplay_start_fail', JSON.stringify(err)) })
                      console.error(TAG, `startApplication promise error: ${JSON.stringify(err)}`);
                    });
                  })
                  .focusBox({
                    strokeWidth: LengthMetrics.px(0)
                  })
                  .id('Application'+index)
                }
                .height(lpx(118))
                .width(lpx(868))
                .onFocus(() => {
                  console.log('===',index)
                  this.currentIndex = index
                  this.imageUrl = item.icon as string
                  this.des = item.name as string
                })
                .onHover(()=>{
                  try {
                    this.getUIContext().getFocusController().requestFocus('Application'+index)
                  } catch (error) {
                    console.log('Application','定焦失败')
                  }
                  this.currentIndex = index
                  this.imageUrl = item.icon as string
                  this.des = item.name as string
                  this.scroller.scrollTo({ xOffset: 10, yOffset: 50 * index })
                })
                .onTouch((event) => {
                  try {
                    this.getUIContext().getFocusController().requestFocus('Application'+index)
                  } catch (error) {
                    console.log('Application','定焦失败')
                  }
                  if (!EventUtil.isTouchEvent(event)) {
                    return;
                  }
                  if (event.sourceTool !== SourceTool.Pen &&
                    event.sourceTool !== SourcetoolConstants.SOURCE_TOOL_MOUSE_CLICK) {
                    return;
                  }
                  if (!this.selectDisplay) {
                    promptAction.showToast({ message: $r('app.string.diffdisplay_connect_expand') })
                    return
                  }
                  if (!item) {
                    promptAction.showToast({ message: $r('app.string.diffdisplay_app_notset') })
                    return
                  }
                  let context = getContext(this) as common.UIAbilityContext;
                  let want: Want = {
                    bundleName: item.bundleName,
                    abilityName: item.abilityName
                  }
                  console.log(TAG, 'startApplication want = ' + JSON.stringify(want));
                  context.startAbility(want, {
                    displayId: this.selectDisplay?.id
                  }
                  ).then(() => {
                    console.log(TAG, 'startApplication promise success');
                  }, (err: BusinessError) => {
                    promptAction.showToast({ message: $r('app.string.diffdisplay_start_fail', JSON.stringify(err)) })
                    console.error(TAG, `startApplication promise error: ${JSON.stringify(err)}`);
                  });
                })
                .onKeyEvent((event) => {
                  if (event.keyCode == KeyCode.KEYCODE_ENTER && event.type == KeyType.Up) {
                    if (!this.selectDisplay) {
                      promptAction.showToast({ message: $r('app.string.diffdisplay_connect_expand') })
                      return
                    }
                    if (!item) {
                      promptAction.showToast({ message: $r('app.string.diffdisplay_app_notset') })
                      return
                    }
                    let context = getContext(this) as common.UIAbilityContext;
                    let want: Want = {
                      bundleName: item.bundleName,
                      abilityName: item.abilityName
                    }
                    console.log(TAG, 'startApplication want = ' + JSON.stringify(want));
                    context.startAbility(want, {
                      displayId: this.selectDisplay?.id
                    }
                    ).then(() => {
                      console.log(TAG, 'startApplication promise success');
                    }, (err: BusinessError) => {
                      promptAction.showToast({ message: $r('app.string.diffdisplay_start_fail', JSON.stringify(err)) })
                      console.error(TAG, `startApplication promise error: ${JSON.stringify(err)}`);
                    });
                  }
                })
              })
            }
            .layoutWeight(1)
          }
          .alignItems(HorizontalAlign.Start)
          .justifyContent(FlexAlign.Start)
        }
        .width('48%')
        .height('100%')
        .margin({ left: lpx(84) })

        Column() {
          Image(this.imageUrl)
            .width('40%')
            .objectFit(ImageFit.Contain)
            .aspectRatio(1)
            .colorFilter([
              0.2, 0.2, 0.2, 0, 0,
              0.2, 0.2, 0.2, 0, 0,
              0.2, 0.2, 0.2, 0, 0,
              0, 0, 0, 0.5, 0
            ])

          Text(this.des)
            .fontColor('rgba(255, 255, 255, 0.2)')
            .fontSize(lpx(36))
            .margin({
              top: lpx(24)
            })
        }
        .width('48%')
        .height('100%')
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)
      }
    }
    .height('100%')
    .width('100%')
  }
}
