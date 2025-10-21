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

//[Start create_customHeader_start]
@Builder
function customHeader() {
  Column() {
    Text($r('app.string.ArcListCrown_set'))
      .fontColor('#FFFFFFFF')
      .fontSize('19fp')
  }
}

//[End create_customHeader_start]

@Entry
@Component
export struct ArcListStyles {
  //[Start componentContent_start]
  context: UIContext = this.getUIContext();
  arcListHeader: ComponentContent<Object> = new ComponentContent(this.context, wrapBuilder(customHeader));

  //[End componentContent_start]

  build() {
    NavDestination() {
      Column({ space: 12 }) {
        List() {
          ListItem() {
            ComponentCard({ title: $r('app.string.ArcListStyles_head') }) {
              //[Start arcListHeader_start]
              ArcList({ header: this.arcListHeader }) {
                ArcListItem() {
                  // [StartExclude arcListHeader_start]
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

                  // [EndExclude arcListHeader_start]
                }
                // [StartExclude arcListHeader_start]
                .borderRadius('65px')
                .width('414px')
                .height('129px')
                .backgroundColor('#26FFFFFF')

                // [EndExclude arcListHeader_start]

                ArcListItem() {
                  // [StartExclude arcListHeader_start]
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

                  // [EndExclude arcListHeader_start]
                }
                // [StartExclude arcListHeader_start]
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

                // [EndExclude arcListHeader_start]
              }
              //[End arcListHeader_start]
              .width('466px')
              .height('466px')
              .space(LengthMetrics.px(10))
              .borderRadius('233px')
              .backgroundColor(Color.Black)
            }
          }

          ListItem() {
            ComponentCard({ title: $r('app.string.ArcListStyles_titleSpacing') }) {
              // [Start arcListSpace_start]
              ArcList({ initialIndex: 2 }) {
                // [StartExclude arcListSpace_start]
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
                // [EndExclude arcListSpace_start]
              }
              .space(LengthMetrics.px(30))
              // [End arcListSpace_start]
              .width('466px')
              .height('466px')
              .borderRadius('233px')
              .backgroundColor(Color.Black)
            }
          }

          ListItem() {
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
                // [Start arcListScale_start]
                ArcListItem() {
                  // [StartExclude arcListScale_start]
                  Row() {
                    Image($r('app.media.mobileData')).width('99px').height('99px')
                      .borderRadius('50px').margin({ left: 7 })
                    Column() {
                      Text($r('app.string.ArcListStyles_net')).fontSize('38px').fontColor('#FFFFFFFF')
                    }.width('190px')

                    Image($r('app.media.ic_settings_arrow')).width('92px').height('92px')
                      .borderRadius('50px')
                  }
                  // [EndExclude arcListScale_start]
                }
                .autoScale(false)
                // [End arcListScale_start]
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