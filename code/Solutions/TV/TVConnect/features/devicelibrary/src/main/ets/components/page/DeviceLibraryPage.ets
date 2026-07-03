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
import {
  DeviceLibraryManager,
  DeviceSelectEnum,
  TabBarDataSource,
  TopTabItemInfo
} from '../../viewmodel/DeviceLibraryManager';
import { DetailMultipleComponent, DetailSingComponent } from '../library/DetailComponent';
import { HMPageParam, HMParamType, HMRouter, HMRouterMgr } from '@hadss/hmrouter';
import { Logger, PageViewUtils } from '@ohos/common';
import { ColorMetrics, LengthMetrics } from '@kit.ArkUI';
import { KeyCode } from '@kit.InputKit';

/*
 * 设备库页面
 * */
@Builder
export function DeviceLibraryPage() {
  DeviceLibraryPageComponent();
}

const MENU_PREFIX = 'menuLevel_';
const ICON_SEARCH = 'iconSearch';
const TAG = 'device_menu';

export enum FocusLayerType {
  MAIN_MENU = 0, SUB_MENU = 1, DEVICE_LIST = 2
}

const TAB_CLICK_DELAY = 100;

/*
 * 设备库页面UI组件
 * */
@HMRouter({ pageUrl: 'DeviceLibraryPage', singleton: true, lifecycle: 'DeviceLibraryPageLifecycle' })
@Component
export struct DeviceLibraryPageComponent {
  @Provide scrollerIndex: number = 0; //二级菜单索引
  private tabBarDataSource = new TabBarDataSource();
  private swiperController = new SwiperController();
  private tabScroller = new Scroller();
  @StorageLink('currentBreakpoint') currentBreakpoint: string = 'sm';
  @State newS: Length = 0;
  @Provide isFou: boolean = false;
  @Provide @Watch('focusLayerChange') focusLayers: FocusLayerType = FocusLayerType.MAIN_MENU;
  @State focusIndex: number = -1;
  @State title: ResourceStr = '';
  @State dataInited: boolean = false;

  aboutToAppear(): void {
    const params = HMRouterMgr.getCurrentParam(HMParamType.all) as HMPageParam;
    this.title = params.data['title'];
    DeviceLibraryManager.getInstance().registerInitCallback((inited) => {
      if (inited) {
        this.dataInited = inited;
        setTimeout(() => {
          PageViewUtils.tabClick();
        }, TAB_CLICK_DELAY);
      }
    });
    DeviceLibraryManager.getInstance().updateData();
  }

  focusLayerChange() {
    if (this.focusLayers === FocusLayerType.MAIN_MENU) {
      this.requestFocusBtn(this.scrollerIndex);
    }
  }

  searchKeyEvent(e: KeyEvent): boolean {
    if (e.keyCode == KeyCode.KEYCODE_DPAD_DOWN && e.type == KeyType.Down) {
      this.requestFocusBtn(this.scrollerIndex);
      return true;
    }
    return false;
  }

  directionKeyEvent(e: KeyEvent, index: number): boolean {
    if (e.keyCode == KeyCode.KEYCODE_DPAD_LEFT && e.type == KeyType.Down) {
      if (index > 0) {
        index--;
        this.requestFocusBtn(index);
        return true;
      }
    }
    if (e.keyCode == KeyCode.KEYCODE_DPAD_RIGHT && e.type == KeyType.Down) {
      if (index < this.tabBarDataSource.totalCount() - 1) {
        index++;
        this.requestFocusBtn(index);
        return true;
      }
    }
    if (e.keyCode == KeyCode.KEYCODE_DPAD_UP && e.type == KeyType.Down) {
      focusControl.requestFocus(ICON_SEARCH);
      return true;
    }

    if (e.keyCode == KeyCode.KEYCODE_DPAD_DOWN && e.type == KeyType.Down) {
      if (index == DeviceSelectEnum.CERTIFIED) {
        this.focusLayers = FocusLayerType.DEVICE_LIST;
      } else {
        this.focusLayers = FocusLayerType.SUB_MENU;
      }
      return true;
    }
    return false;
  }

  requestFocusBtn(index: number): boolean {
    let isSuccess = focusControl.requestFocus(`${MENU_PREFIX}${index}`);
    if (isSuccess) {
    } else {
      Logger.error(TAG, `requestFocus is failed , focusIndex = ${MENU_PREFIX}${index}`);
    }
    return isSuccess;
  }

  /*
   * 设备库页面标题
   * */
  @Builder
  //通用互联标题
  getTitle() {
    Stack({ alignContent: Alignment.End }) {
      Text(this.title)
        .fontSize(px2vp(36))
        .fontColor(Color.White)
        .width('100%')
        .height('100%')
        .textAlign(TextAlign.Start);
      Image($r('app.media.ic_public_input_search'))
        .id(ICON_SEARCH)
        .width($r('app.string.20_vp'))
        .height($r('app.string.20_vp'))
        .objectFit(ImageFit.Contain)
        .margin(px2vp(10))
        .focusBox({
          margin: LengthMetrics.px(2),
          strokeColor: ColorMetrics.resourceColor($r('app.color.text_color_white')),
          strokeWidth: LengthMetrics.px(2)
        })
        .onClick(() => {
          //跳转到设备详情页
          HMRouterMgr.push({ pageUrl: 'DeviceSearchPage' });
        })
        .onKeyEvent((e) => {
          if (this.searchKeyEvent(e)) {
            e.stopPropagation();
          }
        });
    }.width('100%').height($r('app.string.page_toolbar_height'));
  }

  build() {
    Flex({ direction: FlexDirection.Column }) {
      this.getTitle();
      if (this.dataInited) {
        //横向列表 第一层
        List({ scroller: this.tabScroller }) {
          LazyForEach(this.tabBarDataSource, (item: TopTabItemInfo, index: number) => {
            ListItem() {
              if (this.currentBreakpoint == 'lg') {
                Column() {
                  Text(item.title)
                    .fontColor(this.focusIndex == index ? $r('app.color.text_color_focus') :
                    $r('app.color.default_text_color'))
                    .fontSize(this.focusIndex == index ? 18 : 16)
                    .onAreaChange((oldS, newS) => {
                      this.newS = Number(newS.width) + 20;
                    })
                    .focusable(true)
                    .tabIndex(index + 1)
                    .focusBox({
                      strokeWidth: LengthMetrics.px(0)
                    })
                    .onFocus(() => {
                      this.focusIndex = index;
                    })
                    .onBlur(() => {
                      this.focusIndex = -1;
                    })
                    .onHover(() => {
                      this.focusIndex = index;
                      this.getUIContext().getFocusController().requestFocus(`${MENU_PREFIX}${index}`);
                    })
                    .id(`${MENU_PREFIX}${index}`)
                    .onKeyEvent((e) => {
                      if (this.directionKeyEvent(e, index)) {
                        e.stopPropagation();
                      }
                    });
                }
                .padding({ bottom: px2vp(10) })
                .borderWidth({ bottom: this.scrollerIndex == index ? 3 : 0 })
                .borderStyle(BorderStyle.Solid)
                .borderColor(this.focusIndex == index ? $r('app.color.text_color_focus') :
                $r('app.color.default_text_color'));
              } else {
                Column() {
                  Text(item.title)
                    .fontColor(this.focusIndex == index ? $r('app.color.text_color_focus') :
                    $r('app.color.default_text_color'))
                    .fontSize(this.focusIndex == index ? 18 : 16)
                    .fontWeight(600)
                    .focusable(true)
                    .tabIndex(index + 1)
                    .focusBox({
                      strokeWidth: LengthMetrics.px(0)
                    })
                    .onFocus(() => {
                      this.focusIndex = index;
                    })
                    .onBlur(() => {
                      this.focusIndex = -1;
                    })
                    .onHover(() => {
                      this.focusIndex = index;
                      this.getUIContext().getFocusController().requestFocus(`${MENU_PREFIX}${index}`);
                    })
                    .id(`${MENU_PREFIX}${index}`)
                    .onKeyEvent((e) => {
                      if (this.directionKeyEvent(e, index)) {
                        e.stopPropagation();
                      }
                    });
                }
                .padding({ bottom: px2vp(10) })
                .borderWidth({ bottom: this.scrollerIndex == index ? 3 : 0 })
                .borderStyle(BorderStyle.Solid)
                .borderColor(this.focusIndex == index ? $r('app.color.text_color_focus') :
                $r('app.color.default_text_color'));
              }
            }
            .align(Alignment.Start)
            .width('16.66%')
            .height('80%')
            .onFocus(() => {
              this.scrollerIndex = index;
              this.swiperController.changeIndex(index);
            })
            .onClick(() => {
              this.scrollerIndex = index;
              this.swiperController.changeIndex(index);
            });
          }, (item: TopTabItemInfo, index: number) => JSON.stringify(item) + index);
        }
        .listDirection(Axis.Horizontal)
        .scrollBar(BarState.Off)
        .height(px2vp(80))
        .width('100%')
        .alignListItem(ListItemAlign.Center)
        .focusScopeId('TitleList', true);

        //竖向列表 第二层
        Swiper(this.swiperController) {
          LazyForEach(this.tabBarDataSource, (_: TopTabItemInfo, index: number) => {
            Row() {
              if (index == DeviceSelectEnum.CERTIFIED) {
                //互通认证
                DetailSingComponent({ currentTab: index });
              } else {
                DetailMultipleComponent({ currentTab: index });
              }
            };
          }, (_: TopTabItemInfo, index: number) => index.toString());
        }
        .flexGrow(1)
        .width('100%')
        .flexShrink(1)
        .margin({ top: 12 })
        .loop(false)
        .indicator(false)
        .onChange((index) => {
          this.scrollerIndex = index;
          this.tabScroller.scrollToIndex(index, true, ScrollAlign.CENTER);
        })
        .cachedCount(1)
        .disableSwipe(true)
        .focusable(true);
      } else {
        Stack() {
          Text($r('app.string.loading', this.title))
            .fontSize(px2vp(36))
            .fontColor(Color.White);
        }.width('100%').flexGrow(1);
      }
    }
    .width('100%')
    .height('100%')
    .padding({
      top: px2vp(54),
      bottom: px2vp(54),
      right: px2vp(76),
      left: px2vp(76),
    })
    .backgroundColor($r('app.color.page_background'));
  }
}