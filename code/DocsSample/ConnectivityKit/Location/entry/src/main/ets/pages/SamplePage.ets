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

// [Start import_geoLocation]
import geoLocationManager from '@ohos.geoLocationManager';
// [End import_geoLocation]
import {listData, heatCity, ListItem, ProvinceWithSubCities} from '../mock/LocationMock';
import hilog from '@ohos.hilog';

@Entry
@Component
export struct SamplePage {
  @State alphabetIndex: number = 0;
  @State location: boolean = true;
  @State isCity: string = '';
  @State currentLocation: string = '';
  @State latitude: number = 0;
  @State longitude: number = 0;
  @State city: string = '';
  @State isShow: boolean = true;
  private tabValue: string[] = ['A', 'B', 'C', 'F', 'G', 'H', 'J', 'L', 'N', 'Q', 'S', 'T', 'X', 'Y', 'Z'];
  private scroller: Scroller = new Scroller();
  private tag: string = 'LocationSample'; 

  async requestLocation() {
// [Start request_location]
    let requestConfig: geoLocationManager.ContinuousLocationRequest = {
      'interval': 1,
      'locationScenario': geoLocationManager.UserActivityScenario.NAVIGATION
    };

    let locationCallback = async (location: geoLocationManager.Location) => {
      hilog.info(0x0000, this.tag, 'Received Location:' + JSON.stringify(location));
// [StartExclude request_location]
// [Start off_location]
      // 该回调函数需要与on接口传入的回调函数保持一致。
      geoLocationManager.off('locationChange', locationCallback);
// [End off_location]
// [EndExclude request_location]
    };
    try {
      let isLocationEnabled = geoLocationManager.isLocationEnabled();
      if (isLocationEnabled) {
        geoLocationManager.on('locationChange', requestConfig, locationCallback);
      }
    } catch (err) {
      hilog.info(0x0000, this.tag, 'errorCode:' + err.code + ', errMsg:' + err.msg);
    }
// [End request_location]
  }

  async getCurrentLocation() {
// [Start get_current_location]
// [Start is_location_enabled]
// [Start get_address_from_location]
    try {
      let isLocationEnabled = geoLocationManager.isLocationEnabled();
// [StartExclude is_location_enabled]
      if (isLocationEnabled) {
        let requestInfo: geoLocationManager.CurrentLocationRequest = {
            priority: 0x203,
            scenario: 0x300,
            maxAccuracy: 100
        };
        let location = await geoLocationManager.getCurrentLocation(requestInfo);
        if (location !== undefined) {
// [StartExclude get_current_location]
          let request: geoLocationManager.ReverseGeoCodeRequest = {
            latitude: location.latitude,
            longitude: location.longitude
          };
          let address = await geoLocationManager.getAddressesFromLocation(request);
          if (address !== undefined && address.length >= 1 && address[0].locality !== undefined) {
            this.city = address[0].locality;
          }
          hilog.info(0x0000, this.tag, 'this city:' + JSON.stringify(this.city));
// [StartExclude get_current_location]
          hilog.info(0x0000, this.tag, 'current location:' + JSON.stringify(location));
        }
      }
// [EndExclude is_location_enabled]
    } catch (err) {
      hilog.info(0x0000, this.tag, 'errorCode:' + err.code + ', errMsg:' + err.msg);
    }
// [End get_address_from_location]
// [End is_location_enabled]
// [End get_current_location]
  }

  async getLastLocation() {
// [Start get_last_location]
    try {
      let isLocationEnabled = geoLocationManager.isLocationEnabled();
      if (isLocationEnabled) {
        let location = await geoLocationManager.getLastLocation();
        if (location !== undefined) {
          this.latitude = location.latitude;
          this.longitude = location.longitude;
          hilog.info(0x0000, this.tag, 'last location:' + JSON.stringify(location));
        }
      }
    } catch (err) {
      hilog.info(0x0000, this.tag, 'errorCode:' + err.code + ', errMsg:' + err.msg);
    }
// [End get_last_location]
  }

  build () {
    Scroll() {
      Column() {
        Column() {
          Text($r('app.string.deliver_to'))
              .fontSize(25)
              .margin({ bottom: 30})
              .alignSelf(ItemAlign.Start);
          if (this.currentLocation) {
            Text('${this.currentLocation}' || $r('app.string.xian'))
              .fontSize(20)
              .alignSelf(ItemAlign.Start)
              .id('currentLoc');
          } else {
            Text($r('app.string.current_positioning'))
              .fontSize(20)
              .opacity(0.6)
              .alignSelf(ItemAlign.Start);
          }
        }
        .width('100%')
        .height(100)
        .margin({ top: 20});
            
        Row() {
          Image($r('app.media.location'))
            .width(22)
            .height(22)
            .aspectRatio(1)
            .padding({ left: 4 });
          Text(this.city === '' ? $r('app.string.xian') : this.city)
            .fontSize(20)
            .fontColor('#E92F4F')
            .margin({ left: 12 })
            .padding({right: 5, top: 2 });
        }
        .alignSelf(ItemAlign.Start)
        .justifyContent(FlexAlign.Center)
        .width(110)
        .height(40)
        .borderRadius(20)
        .borderWidth(1)
        .borderColor('#E92F4F')
        .onClick(async () => {
          await this.getCurrentLocation();
        });

        Button($r('app.string.continuous_location_request'))
          .type(ButtonType.Normal)
          .width(110)
          .height(40)
          .backgroundColor(Color.Transparent)
          .borderRadius(20)
          .borderWidth(1)
          .margin({ top: 12 })
          .borderColor('#E92F4F')
          .fontColor('#E92F4F')
          .fontSize(18)
          .alignSelf(ItemAlign.Start)
          .onClick(async () => {
            await this.requestLocation()
          });
                
        Column() {
          Stack({ alignContent: Alignment.End }) {
            Column() {
              Row() {
                  Text($r('app.string.domestic_hot_city'))
                      .fontSize(20)
                      .fontColor('#000000')
                      .opacity(0.6);
              }
              .alignSelf(ItemAlign.Start)
              .margin({ top: 10, bottom: 15 });

              Grid() {
                ForEach(heatCity, (item: string, index: number) => {
                  GridItem() {
                    Text(item)
                      .margin({ bottom: 20})
                      .fontSize(20)
                      .maxLines(1)
                      .fontColor('#000000')
                      .onClick(() => {
                          this.currentLocation = item;
                      });
                  }
                  .id('city${idex + 1}');
                });
              }
              .margin({ right: 60, top: 10 })
              .width('100%')
              .height(130)
              .columnsTemplate('1fr 1fr 1fr 1fr');
              
              List({ space: 15, initialIndex: 0, scroller: this.scroller }) {
                ForEach(listData, (firstItem: ListItem) => {
                  ListItem() {
                      this.buildListItem(firstItem);
                  }
                });
              }
              .height(500)
              .width('100%')
              .edgeEffect(EdgeEffect.None)
              .listDirection(Axis.Vertical)
              .onScrollIndex((firstIndex: number) => {
                this.alphabetIndex = firstIndex;
              });
            }

            Column() {
              AlphabetIndexer({ arrayValue: this.tabValue, selected: this.alphabetIndex })
                .height('100%')
                .font({ size: 16 })
                .popupColor('#FFFFFF') // 弹出框颜色
                .selectedBackgroundColor(0xCCCCCC) // 选中背景颜色
                .popupBackground(0xCCCCCC) // 弹出框背景颜色
                .usingPopup(true) // 是否显示弹出框
                .selectedFont({ size: 16, style: FontStyle.Normal }) // 选中的样式
                .selectedColor('#969494') // 选中颜色
                .popupFont({ size: 30, weight: FontWeight.Bolder }) // 弹出框的演示
                .alignStyle(this.location ? IndexerAlign.Right : IndexerAlign.Left)
                .onSelect((tabIndex: number) => {
                  this.scroller.scrollToIndex(tabIndex);
                });
            }
            .position({ x: '97%' })
            .margin({ top: 4 });
          }
        }
      }
      .width('100%');
    }
    .width('100%')
    .padding({ left: '6.7%', right: '6.7%', top: 20})
    .backgroundColor('#F1F3F5')
    .borderRadius({ topLeft: 40, topRight: 40 });
  }

  @Builder
  buildListItem(firstItem:ListItem) {
    Column() {
      Text(firstItem.name)
        .height(30)
        .fontSize(24)
        .fontColor('#000000')
        .width('100%')
        .margin({ top: 10 });
      
      Divider()
        .strokeWidth(0.8)
        .color('#000000')
        .opacity(0.2)
        .margin({ right: 10, top: 12 });

      ForEach(firstItem.city, (item: string | ProvinceWithSubCities, index:number) => {
        if (typeof item !== 'string') {
          this.buildProvinceItem(item, index);
        } else {
          this.buildCityItem(item, index);
        }
      });
    }
  }

  @Builder
  buildProvinceItem(item:ProvinceWithSubCities, index: number) {
    Text(item.name)
      .height(30)
      .fontSize(20)
      .width('100%')
      .margin({ top: 16})
      .onClick(() => {
        this.currentLocation = item.name;
        this.isCity = this.isCity === item.name ? '' : item.name;
      })
      .id('cityFirst${index + 1}');
  
    if (this.isCity === item.name) {
      List() {
        ForEach(item.city, (secondCity: string, subIndex: number) => {
          ListItem() {
            Column() {
              Text(secondCity)
              .width('100%')
              .height(30)
              .fontSize(18)
              .margin({ top: 4 })
              .id('regiion${subIndex + 1}')
              .onClick(() => {
                this.currentLocation = '${item.name/${secondCity}}';
              });
            }
          }
        })
      }
      .height('9%')
      .width('100%');
    }
  }

  @Builder
  buildCityItem(item:string, index: number) {
    Text(item)
      .height(30)
      .fontSize(20)
      .width('100%')
      .margin({ top: 16 })
      .onClick(() => {
        this.currentLocation = item;
        this.isCity = this.isCity === item ? '' :item;
      })
      .id('cityFirst${index + 1}');
  }
}