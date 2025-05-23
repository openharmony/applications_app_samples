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

import {
  ArcList,
  ArcListItem,
  ArcListAttribute,
  ArcListItemAttribute,
  LengthMetrics,
  ComponentContent
} from '@kit.ArkUI';
import { ComponentCard } from '../../common/Card';

@Builder
function customHeader() {
  Column() {
    Text($r('app.string.ArcListCrown_set'))
      .fontColor('#FFFFFFFF')
      .fontSize('19fp')
  }
}


@Entry
@Component
export struct ArcListStyles {
  context: UIContext = this.getUIContext();
  arcListHeader: ComponentContent<Object> = new ComponentContent(this.context, wrapBuilder(customHeader));

  build() {
    NavDestination() {
      Column({ space: 12 }) {
        List(){
          ListItem(){
            ComponentCard({ title: $r('app.string.ArcListStyles_head') }) {
              ArcList({ header: this.arcListHeader }) {
                ArcListItem() {
                  Row() {
                    Image($r('app.media.wlan')).width('99px').height('99px')
                      .borderRadius('50px').margin({ left: 7 })
                    Column() {
                      Text($r('app.string.ArcListStyles_waln')).fontSize('38px').fontColor('#FFFFFFFF')
                      Text($r('app.string.ArcListStyles_open')).fontSize('20px').fontColor('#FFFFFFFF')
                    }.width('190px')

                    Image($r('app.media.ic_settings_arrow')).width('92px').height('92px')
                      .borderRadius('50px')
                  }
                }
                .borderRadius('65px')
                .width('414px')
                .height('129px')
                .backgroundColor('#26FFFFFF')

                ArcListItem() {
                  Row() {
                    Image($r('app.media.blueTooth')).width('99px').height('99px')
                      .borderRadius('50px').margin({ left: 7 })
                    Column() {
                      Text($r('app.string.ArcListStyles_blue')).fontSize('38px').fontColor('#FFFFFFFF')
                      Text($r('app.string.ArcListStyles_open')).fontSize('20px').fontColor('#FFFFFFFF')
                    }.width('190px')

                    Image($r('app.media.ic_settings_arrow')).width('92px').height('92px')
                      .borderRadius('50px')
                  }
                }
                .borderRadius('65px')
                .width('414px')
                .height('129px')
                .backgroundColor('#26FFFFFF')

                ArcListItem() {
                  Row() {
                    Image($r('app.media.mobileData')).width('99px').height('99px')
                      .borderRadius('50px').margin({ left: 7 })
                    Column() {
                      Text($r('app.string.ArcListStyles_net')).fontSize('38px').fontColor('#FFFFFFFF')
                    }.width('190px')

                    Image($r('app.media.ic_settings_arrow')).width('92px').height('92px')
                      .borderRadius('50px')
                  }
                }
                .borderRadius('65px')
                .width('414px')
                .height('129px')
                .backgroundColor('#26FFFFFF')

                ArcListItem() {
                  Row() {
                    Image($r('app.media.ic_settings_more_connections')).width('99px').height('99px')
                      .borderRadius('50px').margin({ left: 7 })
                    Column() {
                      Text($r('app.string.ArcListStyles_connect')).fontSize('38px').fontColor('#FFFFFFFF')
                    }.width('190px')

                    Image($r('app.media.ic_settings_arrow')).width('92px').height('92px')
                      .borderRadius('50px')
                  }
                }
                .borderRadius('65px')
                .width('414px')
                .height('129px')
                .backgroundColor('#26FFFFFF')

                ArcListItem() {
                  Row() {
                    Image($r('app.media.displayAndBrightness')).width('99px').height('99px')
                      .borderRadius('50px').margin({ left: 7 })
                    Column() {
                      Text($r('app.string.ArcListStyles_light')).fontSize('38px').fontColor('#FFFFFFFF')
                    }.width('190px')

                    Image($r('app.media.ic_settings_arrow')).width('92px').height('92px')
                      .borderRadius('50px')
                  }
                }
                .borderRadius('65px')
                .width('414px')
                .height('129px')
                .backgroundColor('#26FFFFFF')
              }
              .width('466px')
              .height('466px')
              .space(LengthMetrics.px(10))
              .borderRadius('233px')
              .backgroundColor(Color.Black)
            }
          }

          ListItem(){
            ComponentCard({ title: $r('app.string.ArcListStyles_titleSpacing') }) {
              ArcList({ initialIndex: 2 }) {
                ArcListItem() {
                  Row() {
                    Image($r('app.media.wlan')).width('99px').height('99px')
                      .borderRadius('50px').margin({ left: 7 })
                    Column() {
                      Text($r('app.string.ArcListStyles_waln')).fontSize('38px').fontColor('#FFFFFFFF')
                      Text($r('app.string.ArcListStyles_open')).fontSize('20px').fontColor('#FFFFFFFF')
                    }.width('190px')

                    Image($r('app.media.ic_settings_arrow')).width('92px').height('92px')
                      .borderRadius('50px')
                  }
                }
                .borderRadius('65px')
                .width('414px')
                .height('129px')
                .backgroundColor('#26FFFFFF')

                ArcListItem() {
                  Row() {
                    Image($r('app.media.blueTooth')).width('99px').height('99px')
                      .borderRadius('50px').margin({ left: 7 })
                    Column() {
                      Text($r('app.string.ArcListStyles_blue')).fontSize('38px').fontColor('#FFFFFFFF')
                      Text($r('app.string.ArcListStyles_open')).fontSize('20px').fontColor('#FFFFFFFF')
                    }.width('190px')

                    Image($r('app.media.ic_settings_arrow')).width('92px').height('92px')
                      .borderRadius('50px')
                  }
                }
                .borderRadius('65px')
                .width('414px')
                .height('129px')
                .backgroundColor('#26FFFFFF')

                ArcListItem() {
                  Row() {
                    Image($r('app.media.mobileData')).width('99px').height('99px')
                      .borderRadius('50px').margin({ left: 7 })
                    Column() {
                      Text($r('app.string.ArcListStyles_net')).fontSize('38px').fontColor('#FFFFFFFF')
                    }.width('190px')

                    Image($r('app.media.ic_settings_arrow')).width('92px').height('92px')
                      .borderRadius('50px')
                  }
                }
                .borderRadius('65px')
                .width('414px')
                .height('129px')
                .backgroundColor('#26FFFFFF')

                ArcListItem() {
                  Row() {
                    Image($r('app.media.ic_settings_more_connections')).width('99px').height('99px')
                      .borderRadius('50px').margin({ left: 7 })
                    Column() {
                      Text($r('app.string.ArcListStyles_connect')).fontSize('38px').fontColor('#FFFFFFFF')
                    }.width('190px')

                    Image($r('app.media.ic_settings_arrow')).width('92px').height('92px')
                      .borderRadius('50px')
                  }
                }
                .borderRadius('65px')
                .width('414px')
                .height('129px')
                .backgroundColor('#26FFFFFF')

                ArcListItem() {
                  Row() {
                    Image($r('app.media.displayAndBrightness')).width('99px').height('99px')
                      .borderRadius('50px').margin({ left: 7 })
                    Column() {
                      Text($r('app.string.ArcListStyles_light')).fontSize('38px').fontColor('#FFFFFFFF')
                    }.width('190px')

                    Image($r('app.media.ic_settings_arrow')).width('92px').height('92px')
                      .borderRadius('50px')
                  }
                }
                .borderRadius('65px')
                .width('414px')
                .height('129px')
                .backgroundColor('#26FFFFFF')
              }
              .width('466px')
              .height('466px')
              .space(LengthMetrics.px(30))
              .borderRadius('233px')
              .backgroundColor(Color.Black)

            }
          }

          ListItem(){
            ComponentCard({ title: $r('app.string.ArcListStyles_titleScale') }) {
              ArcList({ initialIndex: 2 }) {
                ArcListItem() {
                  Row() {
                    Image($r('app.media.wlan')).width('99px').height('99px')
                      .borderRadius('50px').margin({ left: 7 })
                    Column() {
                      Text($r('app.string.ArcListStyles_waln')).fontSize('38px').fontColor('#FFFFFFFF')
                      Text($r('app.string.ArcListStyles_open')).fontSize('20px').fontColor('#FFFFFFFF')
                    }.width('190px')

                    Image($r('app.media.ic_settings_arrow')).width('92px').height('92px')
                      .borderRadius('50px')
                  }
                }
                .borderRadius('65px')
                .width('414px')
                .height('129px')
                .backgroundColor('#26FFFFFF')

                ArcListItem() {
                  Row() {
                    Image($r('app.media.blueTooth')).width('99px').height('99px')
                      .borderRadius('50px').margin({ left: 7 })
                    Column() {
                      Text($r('app.string.ArcListStyles_blue')).fontSize('38px').fontColor('#FFFFFFFF')
                      Text($r('app.string.ArcListStyles_open')).fontSize('20px').fontColor('#FFFFFFFF')
                    }.width('190px')

                    Image($r('app.media.ic_settings_arrow')).width('92px').height('92px')
                      .borderRadius('50px')
                  }
                }
                .borderRadius('65px')
                .width('414px')
                .height('129px')
                .backgroundColor('#26FFFFFF')

                ArcListItem() {
                  Row() {
                    Image($r('app.media.mobileData')).width('99px').height('99px')
                      .borderRadius('50px').margin({ left: 7 })
                    Column() {
                      Text($r('app.string.ArcListStyles_net')).fontSize('38px').fontColor('#FFFFFFFF')
                    }.width('190px')

                    Image($r('app.media.ic_settings_arrow')).width('92px').height('92px')
                      .borderRadius('50px')
                  }
                }
                .borderRadius('65px')
                .width('414px')
                .height('129px')
                .backgroundColor('#26FFFFFF')
                .autoScale(false)

                ArcListItem() {
                  Row() {
                    Image($r('app.media.ic_settings_more_connections')).width('99px').height('99px')
                      .borderRadius('50px').margin({ left: 7 })
                    Column() {
                      Text($r('app.string.ArcListStyles_connect')).fontSize('38px').fontColor('#FFFFFFFF')
                    }.width('190px')

                    Image($r('app.media.ic_settings_arrow')).width('92px').height('92px')
                      .borderRadius('50px')
                  }
                }
                .borderRadius('65px')
                .width('414px')
                .height('129px')
                .backgroundColor('#26FFFFFF')

                ArcListItem() {
                  Row() {
                    Image($r('app.media.displayAndBrightness')).width('99px').height('99px')
                      .borderRadius('50px').margin({ left: 7 })
                    Column() {
                      Text($r('app.string.ArcListStyles_light')).fontSize('38px').fontColor('#FFFFFFFF')
                    }.width('190px')

                    Image($r('app.media.ic_settings_arrow')).width('92px').height('92px')
                      .borderRadius('50px')
                  }
                }
                .borderRadius('65px')
                .width('414px')
                .height('129px')
                .backgroundColor('#26FFFFFF')
                .autoScale(false)
              }
              .width('466px')
              .height('466px')
              .space(LengthMetrics.px(30))
              .borderRadius('233px')
              .backgroundColor(Color.Black)
            }
          }
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.ArcListStyles_title'))
  }
}