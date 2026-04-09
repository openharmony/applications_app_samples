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

import { KeyCode } from '@kit.InputKit';
import audioSetting from '@ohos.tvservice.audioSetting';
import LogUtil from '../../../../../../../common/utils/src/main/ets/default/baseUtil/LogUtil';
import { promptAction } from '@kit.ArkUI';

interface geqParams {
  band: number;
  gain: number;
}
const TAG = 'customizesounds'
@CustomDialog
export default struct customizesounds {
  @State focusId: string = 'list1';
  controller: CustomDialogController
  @State translatey1: number = 150
  @State value1: number = 0
  @State value01:string='63'

  @State translatey2: number = 150
  @State value2: number = 0
  @State value02:string='125'

  @State translatey3: number = 150
  @State value3: number = 0
  @State value03:string='250'

  @State translatey4: number = 150
  @State value4: number = 0
  @State value04:string='500'


  @State translatey5: number = 150
  @State value5: number = 0
  @State value05:string='1K'

  @State translatey6: number = 150
  @State value6: number = 0
  @State value06:string='2K'

  @State translatey7: number = 150
  @State value7: number = 0
  @State value07:string='4K'

  @State translatey8: number = 150
  @State value8: number = 0
  @State value08:string='8K'

  @State translatey9: number = 150
  @State value9: number = 0
  @State value09:string='16k'

  //-150(最上面)到150(最下面)
  async aboutToAppear(): Promise<void> {
    let focusId = AppStorage.get<string>('focusId') || 'list1';
    focusControl.requestFocus(focusId);
    try {
      let getAudioEffect:geqParams[]= await audioSetting.getCustomGeqParams();
      LogUtil.log(TAG + 'getCustomGeqParamsSucess=' + JSON.stringify(getAudioEffect));
      const bandZero1 = getAudioEffect[0];
      this.value1=bandZero1!.gain+10
      this.translatey1=bandZero1!.gain*(-15)
      this.value01 = bandZero1.band.toString();

      const bandZero2 = getAudioEffect[1];
      this.value2=bandZero2!.gain+10
      this.translatey2=bandZero2!.gain*(-15)
      this.value02 = bandZero2.band.toString();

      const bandZero3 = getAudioEffect[2];
      this.value3=bandZero3!.gain+10
      this.translatey3=bandZero3!.gain*(-15)
      this.value03 = bandZero3.band.toString();

      const bandZero4 = getAudioEffect[3];
      this.value4=bandZero4!.gain+10
      this.translatey4=bandZero4!.gain*(-15)
      this.value04 = bandZero4.band.toString();

      const bandZero5 = getAudioEffect[4];
      this.value5=bandZero5!.gain+10
      this.translatey5=bandZero5!.gain*(-15)
      this.value05 = bandZero5.band.toString();

      const bandZero6 = getAudioEffect[5];
      this.value6=bandZero6!.gain+10
      this.translatey6=bandZero6!.gain*(-15)
      this.value06 = bandZero6.band.toString();

      const bandZero7 = getAudioEffect[6];
      this.value7=bandZero7!.gain+10
      this.translatey7=bandZero7!.gain*(-15)
      this.value07 = bandZero7.band.toString();


      const bandZero8 = getAudioEffect[7];
      this.value8=bandZero8!.gain+10
      this.translatey8=bandZero8!.gain*(-15)
      this.value08 = bandZero8.band.toString();

      const bandZero9 = getAudioEffect[8];
      this.value9=bandZero9!.gain+10
      this.translatey9=bandZero9!.gain*(-15)
      this.value09 = bandZero9.band.toString();

    } catch (error) {
      LogUtil.log(TAG + 'getCustomGeqParamsError=' + JSON.stringify(error));
    }
  }
  aboutToDisappear(): void {
    AppStorage.setOrCreate<string>('focusId', this.focusId);
  }
  clickFocusBtn(id: string) {
    this.focusId = 'list' + id;
    AppStorage.setOrCreate<string>('focusId', 'list' + id);
    focusControl.requestFocus('list' + id);
  }

  async setCustomGeqParams(num1:number,num2:number){
    try {
        let setAudioEffect:boolean=await audioSetting.setCustomGeqParams({ band: num1, gain: num2 });
        LogUtil.log(TAG+'setCustomGeqParams SuccessBoolean==:'+JSON.stringify(setAudioEffect));
        if(!setAudioEffect){
          promptAction.showToast({ message: `设置频段${num1}失败` })
        }
    } catch (error){
      LogUtil.log(TAG + 'setCustomGeqParamsFailed=' + JSON.stringify(error));
      promptAction.showToast({ message: $r('app.string.tips_in_development') })
    }
  }

  build() {
    Column() {
      Column() {
        // 1.标题
        Text('均衡器设置')
          .fontSize('40lpx')
          .fontWeight(500)
          .height('47lpx')
          .width('100%')
          .textAlign(TextAlign.Center)
          .fontColor('#dbffffff')
          .margin({
            top: '48lpx'
          })
          .focusable(true)
        Row() {
            Column() {
              Text('+')
                .width('24lpx')
                .height('24lpx')
                .fontSize('24lpx')
                .textAlign(TextAlign.Center)
                .fontColor('#99ffffff')
                .focusable(true)
              Stack() {
                Progress({ value: this.value1, total: 20, type: ProgressType.Linear })
                  .color(this.focusId=='list1' ? '#0a59f7' : '#f1f3f5')
                  .backgroundColor('#666666')
                  .width('10lpx')
                  .height('260lpx')
                  .borderRadius('49lpx')
                  .rotate({
                    x: 0,
                    y: 0,
                    z: 1,
                    centerX: '50%',
                    centerY: '50%',
                    angle: 180
                  })
                  .focusable(true)
                Row() {
                  Text(this.value1-10 + '')
                    .fontSize('24lpx')
                    .textAlign(TextAlign.Center)
                    .fontColor(this.focusId=='list1' ? '#db000000' : '#dbffffff')
                    .focusable(true)
                }
                .width('72lpx')
                .height('40lpx')
                .translate({ x: 0, y: this.translatey1 + 'lpx' })
                .backgroundColor(this.focusId=='list1' ? '#ececec' : '#b3b3b3')
                .justifyContent(FlexAlign.Center)
                .borderRadius('60lpx')
                .focusable(true)

                Row(){

                }.width('80lpx')
                .height('48lpx')
                .borderRadius('60lpx')
                .focusable(true)
                .border({
                  width: '2lpx',
                  color: this.focusId == 'list1' ? '#ececec' : 'transparent'
                }) .translate({ x: 0, y: this.translatey1 + 'lpx' })
              }.height('340lpx').margin({ top: '12lpx' }).focusable(true)

              Text('-')
                .width('24lpx')
                .height('24lpx')
                .fontSize('24lpx')
                .textAlign(TextAlign.Center)
                .fontColor('#99ffffff')
                .margin({ top: '12lpx' })
                .focusable(true)
              Text(this.value01)
                .height('28lpx')
                .margin({ top: '12lpx' })
                .fontSize('24lpx')
                .textAlign(TextAlign.Center)
                .fontColor('#dbffffff')
                .focusable(true)
            }
            .height('460lpx')
            .width('72lpx')
            .margin({
              top: '48lpx',
              right: '42lpx'
            })
            .focusable(true)
            .id('list1')
            .visibility(this.value01 != '0' ? Visibility.Visible : Visibility.None)
            .defaultFocus(true)

          Column() {
            Text('+')
              .width('24lpx')
              .height('24lpx')
              .fontSize('24lpx')
              .textAlign(TextAlign.Center)
              .fontColor('#99ffffff')
              .focusable(true)
            Stack() {
              Progress({ value: this.value2, total: 20, type: ProgressType.Linear })
                .color(this.focusId=='list2' ? '#0a59f7' : '#f1f3f5')
                .backgroundColor('#666666')
                .width('10lpx')
                .height('260lpx')
                .borderRadius('49lpx')
                .rotate({
                  x: 0,
                  y: 0,
                  z: 1,
                  centerX: '50%',
                  centerY: '50%',
                  angle: 180
                })
                .focusable(true)
              Row() {
                Text(this.value2-10 + '')
                  .fontSize('24lpx')
                  .textAlign(TextAlign.Center)
                  .fontColor(this.focusId=='list2' ? '#db000000' : '#dbffffff')
                  .focusable(true)
              }
              .width('72lpx')
              .height('40lpx')
              .translate({ x: 0, y: this.translatey2 + 'lpx' })
              .backgroundColor(this.focusId=='list2' ? '#ececec' : '#b3b3b3')
              .justifyContent(FlexAlign.Center)
              .borderRadius('60lpx')
              .focusable(true)
              Row(){

              }.width('80lpx')
              .height('48lpx')
              .borderRadius('60lpx')
              .focusable(true)
              .border({
                width: '2lpx',
                color: this.focusId == 'list2' ? '#ececec' : 'transparent'
              }) .translate({ x: 0, y: this.translatey2 + 'lpx' })

            }.height('340lpx').margin({ top: '12lpx' }).focusable(true)

            Text('-')
              .width('24lpx')
              .height('24lpx')
              .fontSize('24lpx')
              .textAlign(TextAlign.Center)
              .fontColor('#99ffffff')
              .margin({ top: '12lpx' })
              .focusable(true)
            Text(this.value02)
              .height('28lpx')
              .margin({ top: '12lpx' })
              .fontSize('24lpx')
              .textAlign(TextAlign.Center)
              .fontColor('#dbffffff')
              .focusable(true)
          }
          .height('460lpx')
          .width('72lpx')
          .margin({
            top: '48lpx',
            right: '42lpx'
          })
          .focusable(true)
          .id('list2')
          .visibility(this.value02 != '0' ? Visibility.Visible : Visibility.None)

          Column() {
            Text('+')
              .width('24lpx')
              .height('24lpx')
              .fontSize('24lpx')
              .textAlign(TextAlign.Center)
              .fontColor('#99ffffff')
              .focusable(true)
            Stack() {
              Progress({ value: this.value3, total: 20, type: ProgressType.Linear })
                .color(this.focusId=='list3' ? '#0a59f7' : '#f1f3f5')
                .backgroundColor('#666666')
                .width('10lpx')
                .height('260lpx')
                .borderRadius('49lpx')
                .rotate({
                  x: 0,
                  y: 0,
                  z: 1,
                  centerX: '50%',
                  centerY: '50%',
                  angle: 180
                })
                .focusable(true)
              Row() {
                Text(this.value3-10 + '')
                  .fontSize('24lpx')
                  .textAlign(TextAlign.Center)
                  .fontColor(this.focusId=='list3' ? '#db000000' : '#dbffffff')
                  .focusable(true)
              }
              .width('72lpx')
              .height('40lpx')
              .translate({ x: 0, y: this.translatey3 + 'lpx' })
              .backgroundColor(this.focusId=='list3' ? '#ececec' : '#b3b3b3')
              .justifyContent(FlexAlign.Center)
              .borderRadius('60lpx')
              .focusable(true)

              Row(){

              }.width('80lpx')
              .height('48lpx')
              .borderRadius('60lpx')
              .focusable(true)
              .border({
                width: '2lpx',
                color: this.focusId == 'list3' ? '#ececec' : 'transparent'
              }) .translate({ x: 0, y: this.translatey3 + 'lpx' })
            }.height('340lpx').margin({ top: '12lpx' }).focusable(true)

            Text('-')
              .width('24lpx')
              .height('24lpx')
              .fontSize('24lpx')
              .textAlign(TextAlign.Center)
              .fontColor('#99ffffff')
              .margin({ top: '12lpx' })
              .focusable(true)
            Text(this.value03)
              .height('28lpx')
              .margin({ top: '12lpx' })
              .fontSize('24lpx')
              .textAlign(TextAlign.Center)
              .fontColor('#dbffffff')
              .focusable(true)
          }
          .height('460lpx')
          .width('72lpx')
          .margin({
            top: '48lpx',
            right: '42lpx'
          })
          .focusable(true)
          .id('list3')
          .visibility(this.value03 != '0' ? Visibility.Visible : Visibility.None)


          Column() {
            Text('+')
              .width('24lpx')
              .height('24lpx')
              .fontSize('24lpx')
              .textAlign(TextAlign.Center)
              .fontColor('#99ffffff')
              .focusable(true)
            Stack() {
              Progress({ value: this.value4, total: 20, type: ProgressType.Linear })
                .color(this.focusId=='list4' ? '#0a59f7' : '#f1f3f5')
                .backgroundColor('#666666')
                .width('10lpx')
                .height('260lpx')
                .borderRadius('49lpx')
                .rotate({
                  x: 0,
                  y: 0,
                  z: 1,
                  centerX: '50%',
                  centerY: '50%',
                  angle: 180
                })
                .focusable(true)
              Row() {
                Text(this.value4-10 + '')
                  .fontSize('24lpx')
                  .textAlign(TextAlign.Center)
                  .fontColor(this.focusId=='list4' ? '#db000000' : '#dbffffff')
                  .focusable(true)
              }
              .width('72lpx')
              .height('40lpx')
              .translate({ x: 0, y: this.translatey4 + 'lpx' })
              .backgroundColor(this.focusId=='list4' ? '#ececec' : '#b3b3b3')
              .justifyContent(FlexAlign.Center)
              .borderRadius('60lpx')
              .focusable(true)
              Row(){

              }.width('80lpx')
              .height('48lpx')
              .borderRadius('60lpx')
              .focusable(true)
              .border({
                width: '2lpx',
                color: this.focusId == 'list4' ? '#ececec' : 'transparent'
              }) .translate({ x: 0, y: this.translatey4 + 'lpx' })
            }.height('340lpx').margin({ top: '12lpx' }).focusable(true)

            Text('-')
              .width('24lpx')
              .height('24lpx')
              .fontSize('24lpx')
              .textAlign(TextAlign.Center)
              .fontColor('#99ffffff')
              .margin({ top: '12lpx' })
              .focusable(true)
            Text(this.value04)
              .height('28lpx')
              .margin({ top: '12lpx' })
              .fontSize('24lpx')
              .textAlign(TextAlign.Center)
              .fontColor('#dbffffff')
              .focusable(true)
          }
          .height('460lpx')
          .width('72lpx')
          .margin({
            top: '48lpx',
            right: '42lpx'
          })
          .focusable(true)
          .id('list4')
          .visibility(this.value04 != '0' ? Visibility.Visible : Visibility.None)


          Column() {
            Text('+')
              .width('24lpx')
              .height('24lpx')
              .fontSize('24lpx')
              .textAlign(TextAlign.Center)
              .fontColor('#99ffffff')
              .focusable(true)
            Stack() {
              Progress({ value: this.value5, total: 20, type: ProgressType.Linear })
                .color(this.focusId=='list5' ? '#0a59f7' : '#f1f3f5')
                .backgroundColor('#666666')
                .width('10lpx')
                .height('260lpx')
                .borderRadius('49lpx')
                .rotate({
                  x: 0,
                  y: 0,
                  z: 1,
                  centerX: '50%',
                  centerY: '50%',
                  angle: 180
                })
                .focusable(true)
              Row() {
                Text(this.value5-10 + '')
                  .fontSize('24lpx')
                  .textAlign(TextAlign.Center)
                  .fontColor(this.focusId=='list5' ? '#db000000' : '#dbffffff')
                  .focusable(true)
              }
              .width('72lpx')
              .height('40lpx')
              .translate({ x: 0, y: this.translatey5 + 'lpx' })
              .backgroundColor(this.focusId=='list5' ? '#ececec' : '#b3b3b3')
              .justifyContent(FlexAlign.Center)
              .borderRadius('60lpx')
              .focusable(true)

              Row(){

              }.width('80lpx')
              .height('48lpx')
              .borderRadius('60lpx')
              .focusable(true)
              .border({
                width: '2lpx',
                color: this.focusId == 'list5' ? '#ececec' : 'transparent'
              }) .translate({ x: 0, y: this.translatey5 + 'lpx' })
            }.height('340lpx').margin({ top: '12lpx' }).focusable(true)

            Text('-')
              .width('24lpx')
              .height('24lpx')
              .fontSize('24lpx')
              .textAlign(TextAlign.Center)
              .fontColor('#99ffffff')
              .margin({ top: '12lpx' })
              .focusable(true)
            Text(this.value05)
              .height('28lpx')
              .margin({ top: '12lpx' })
              .fontSize('24lpx')
              .textAlign(TextAlign.Center)
              .fontColor('#dbffffff')
              .focusable(true)
          }
          .height('460lpx')
          .width('72lpx')
          .margin({
            top: '48lpx',
            right: '42lpx'
          })
          .focusable(true)
          .id('list5')
          .visibility(this.value05 != '0' ? Visibility.Visible : Visibility.None)


          Column() {
            Text('+')
              .width('24lpx')
              .height('24lpx')
              .fontSize('24lpx')
              .textAlign(TextAlign.Center)
              .fontColor('#99ffffff')
              .focusable(true)
            Stack() {
              Progress({ value: this.value6, total: 20, type: ProgressType.Linear })
                .color(this.focusId=='list6' ? '#0a59f7' : '#f1f3f5')
                .backgroundColor('#666666')
                .width('10lpx')
                .height('260lpx')
                .borderRadius('49lpx')
                .rotate({
                  x: 0,
                  y: 0,
                  z: 1,
                  centerX: '50%',
                  centerY: '50%',
                  angle: 180
                })
                .focusable(true)
              Row() {
                Text(this.value6 -10+ '')
                  .fontSize('24lpx')
                  .textAlign(TextAlign.Center)
                  .fontColor(this.focusId=='list6' ? '#db000000' : '#dbffffff')
                  .focusable(true)
              }
              .width('72lpx')
              .height('40lpx')
              .translate({ x: 0, y: this.translatey6 + 'lpx' })
              .backgroundColor(this.focusId=='list6' ? '#ececec' : '#b3b3b3')
              .justifyContent(FlexAlign.Center)
              .borderRadius('60lpx')
              .focusable(true)

              Row(){

              }.width('80lpx')
              .height('48lpx')
              .borderRadius('60lpx')
              .focusable(true)
              .border({
                width: '2lpx',
                color: this.focusId == 'list6' ? '#ececec' : 'transparent'
              }) .translate({ x: 0, y: this.translatey6 + 'lpx' })
            }.height('340lpx').margin({ top: '12lpx' }).focusable(true)

            Text('-')
              .width('24lpx')
              .height('24lpx')
              .fontSize('24lpx')
              .textAlign(TextAlign.Center)
              .fontColor('#99ffffff')
              .margin({ top: '12lpx' })
              .focusable(true)
            Text(this.value06)
              .height('28lpx')
              .margin({ top: '12lpx' })
              .fontSize('24lpx')
              .textAlign(TextAlign.Center)
              .fontColor('#dbffffff')
              .focusable(true)
          }
          .height('460lpx')
          .width('72lpx')
          .margin({
            top: '48lpx',
            right: '42lpx'
          })
          .focusable(true)
          .id('list6')
          .visibility(this.value06 != '0' ? Visibility.Visible : Visibility.None)

          Column() {
            Text('+')
              .width('24lpx')
              .height('24lpx')
              .fontSize('24lpx')
              .textAlign(TextAlign.Center)
              .fontColor('#99ffffff')
              .focusable(true)
            Stack() {
              Progress({ value: this.value7, total: 20, type: ProgressType.Linear })
                .color(this.focusId=='list7' ? '#0a59f7' : '#f1f3f5')
                .backgroundColor('#666666')
                .width('10lpx')
                .height('260lpx')
                .borderRadius('49lpx')
                .rotate({
                  x: 0,
                  y: 0,
                  z: 1,
                  centerX: '50%',
                  centerY: '50%',
                  angle: 180
                })
                .focusable(true)
              Row() {
                Text(this.value7-10 + '')
                  .fontSize('24lpx')
                  .textAlign(TextAlign.Center)
                  .fontColor(this.focusId=='list7' ? '#db000000' : '#dbffffff')
                  .focusable(true)
              }
              .width('72lpx')
              .height('40lpx')
              .translate({ x: 0, y: this.translatey7 + 'lpx' })
              .backgroundColor(this.focusId=='list7' ? '#ececec' : '#b3b3b3')
              .justifyContent(FlexAlign.Center)
              .borderRadius('60lpx')
              .focusable(true)

              Row(){

              }.width('80lpx')
              .height('48lpx')
              .borderRadius('60lpx')
              .focusable(true)
              .border({
                width: '2lpx',
                color: this.focusId == 'list7' ? '#ececec' : 'transparent'
              }) .translate({ x: 0, y: this.translatey7 + 'lpx' })
            }.height('340lpx').margin({ top: '12lpx' }).focusable(true)

            Text('-')
              .width('24lpx')
              .height('24lpx')
              .fontSize('24lpx')
              .textAlign(TextAlign.Center)
              .fontColor('#99ffffff')
              .margin({ top: '12lpx' })
              .focusable(true)
            Text(this.value07)
              .height('28lpx')
              .margin({ top: '12lpx' })
              .fontSize('24lpx')
              .textAlign(TextAlign.Center)
              .fontColor('#dbffffff')
              .focusable(true)
          }
          .height('460lpx')
          .width('72lpx')
          .margin({
            top: '48lpx',
            right: '42lpx'
          })
          .focusable(true)
          .id('list7')
          .visibility(this.value07 != '0' ? Visibility.Visible : Visibility.None)


          Column() {
            Text('+')
              .width('24lpx')
              .height('24lpx')
              .fontSize('24lpx')
              .textAlign(TextAlign.Center)
              .fontColor('#99ffffff')
              .focusable(true)
            Stack() {
              Progress({ value: this.value8, total: 20, type: ProgressType.Linear })
                .color(this.focusId=='list8' ? '#0a59f7' : '#f1f3f5')
                .backgroundColor('#666666')
                .width('10lpx')
                .height('260lpx')
                .borderRadius('49lpx')
                .rotate({
                  x: 0,
                  y: 0,
                  z: 1,
                  centerX: '50%',
                  centerY: '50%',
                  angle: 180
                })
                .focusable(true)
              Row() {
                Text(this.value8-10 + '')
                  .fontSize('24lpx')
                  .textAlign(TextAlign.Center)
                  .fontColor(this.focusId=='list8' ? '#db000000' : '#dbffffff')
                  .focusable(true)
              }
              .width('72lpx')
              .height('40lpx')
              .translate({ x: 0, y: this.translatey8 + 'lpx' })
              .backgroundColor(this.focusId=='list8' ? '#ececec' : '#b3b3b3')
              .justifyContent(FlexAlign.Center)
              .borderRadius('60lpx')
              .focusable(true)

              Row(){

              }.width('80lpx')
              .height('48lpx')
              .borderRadius('60lpx')
              .focusable(true)
              .border({
                width: '2lpx',
                color: this.focusId == 'list8' ? '#ececec' : 'transparent'
              }) .translate({ x: 0, y: this.translatey8+ 'lpx' })
            }.height('340lpx').margin({ top: '12lpx' }).focusable(true)

            Text('-')
              .width('24lpx')
              .height('24lpx')
              .fontSize('24lpx')
              .textAlign(TextAlign.Center)
              .fontColor('#99ffffff')
              .margin({ top: '12lpx' })
              .focusable(true)
            Text(this.value08)
              .height('28lpx')
              .margin({ top: '12lpx' })
              .fontSize('24lpx')
              .textAlign(TextAlign.Center)
              .fontColor('#dbffffff')
              .focusable(true)
          }
          .height('460lpx')
          .width('72lpx')
          .margin({
            top: '48lpx',
            right: '42lpx'
          })
          .focusable(true)
          .id('list8')
          .visibility(this.value08 != '0' ? Visibility.Visible : Visibility.None)


          Column() {
            Text('+')
              .width('24lpx')
              .height('24lpx')
              .fontSize('24lpx')
              .textAlign(TextAlign.Center)
              .fontColor('#99ffffff')
              .focusable(true)
            Stack() {
              Progress({ value: this.value9, total: 20, type: ProgressType.Linear })
                .color(this.focusId=='list9' ? '#0a59f7' : '#f1f3f5')
                .backgroundColor('#666666')
                .width('10lpx')
                .height('260lpx')
                .borderRadius('49lpx')
                .rotate({
                  x: 0,
                  y: 0,
                  z: 1,
                  centerX: '50%',
                  centerY: '50%',
                  angle: 180
                })
                .focusable(true)
              Row() {
                Text(this.value9-10 + '')
                  .fontSize('24lpx')
                  .textAlign(TextAlign.Center)
                  .fontColor(this.focusId=='list9' ? '#db000000' : '#dbffffff')
                  .focusable(true)
              }
              .width('72lpx')
              .height('40lpx')
              .translate({ x: 0, y: this.translatey9 + 'lpx' })
              .backgroundColor(this.focusId=='list9' ? '#ececec' : '#b3b3b3')
              .justifyContent(FlexAlign.Center)
              .borderRadius('60lpx')
              .focusable(true)

              Row(){

              }.width('80lpx')
              .height('48lpx')
              .borderRadius('60lpx')
              .focusable(true)
              .border({
                width: '2lpx',
                color: this.focusId == 'list9' ? '#ececec' : 'transparent'
              }) .translate({ x: 0, y: this.translatey9 + 'lpx' })
            }.height('340lpx').margin({ top: '12lpx' }).focusable(true)

            Text('-')
              .width('24lpx')
              .height('24lpx')
              .fontSize('24lpx')
              .textAlign(TextAlign.Center)
              .fontColor('#99ffffff')
              .margin({ top: '12lpx' })
              .focusable(true)
            Text(this.value09)
              .height('28lpx')
              .margin({ top: '12lpx' })
              .fontSize('24lpx')
              .textAlign(TextAlign.Center)
              .fontColor('#dbffffff')
              .focusable(true)
          }
          .height('460lpx')
          .width('72lpx')
          .margin({
            top: '48lpx',
            right: '42lpx'
          })
          .focusable(true)
          .id('list9')
          .visibility(this.value09 != '0' ? Visibility.Visible : Visibility.None)
        }
        .focusable(true)
        .onKeyEvent(e => {
          if (!e) {
            return;
          }
          if (e.keyCode == KeyCode.KEYCODE_DPAD_LEFT && e.type == KeyType.Up) {
            if (this.focusId == 'list1') {
              return
            } else if (this.focusId == 'list2') {
              this.clickFocusBtn('1')
            } else if (this.focusId == 'list3') {
              this.clickFocusBtn('2')
            } else if (this.focusId == 'list4') {
              this.clickFocusBtn('3')
            } else if (this.focusId == 'list5') {
              this.clickFocusBtn('4')
            } else if (this.focusId == 'list6') {
              this.clickFocusBtn('5')
            } else if (this.focusId == 'list7') {
              this.clickFocusBtn('6')
            } else if (this.focusId == 'list8') {
              this.clickFocusBtn('7')
            } else if (this.focusId == 'list9') {
              this.clickFocusBtn('8')
            }
          }
          if (e.keyCode == KeyCode.KEYCODE_DPAD_RIGHT && e.type == KeyType.Up) {
            if (this.focusId == 'list1') {
              this.clickFocusBtn('2')
            } else if (this.focusId == 'list2') {
              this.clickFocusBtn('3')
            } else if (this.focusId == 'list3') {
              this.clickFocusBtn('4')
            } else if (this.focusId == 'list4') {
              this.clickFocusBtn('5')
            } else if (this.focusId == 'list5') {
              this.clickFocusBtn('6')
            } else if (this.focusId == 'list6') {
              this.clickFocusBtn('7')
            } else if (this.focusId == 'list7') {
              this.clickFocusBtn('8')
            } else if (this.focusId == 'list8') {
              this.clickFocusBtn('9')
            } else if (this.focusId == 'list9') {
             return
            }
          }
          if (e.keyCode == KeyCode.KEYCODE_DPAD_UP && e.type == KeyType.Up) {
            if (this.focusId == 'list1') {
              if (this.value1 < 20) {
                this.value1 += 1
                this.translatey1 -= 15
                this.setCustomGeqParams(parseInt(this.value01),this.value1-10);
              }
            } else if (this.focusId == 'list2') {
              if (this.value2 < 20) {
                this.value2 += 1
                this.translatey2 -= 15
                this.setCustomGeqParams(parseInt(this.value02),this.value2-10);
              }
            } else if (this.focusId == 'list3') {
              if (this.value3 < 20) {
                this.value3 += 1
                this.translatey3 -= 15
                this.setCustomGeqParams(parseInt(this.value03),this.value3-10);
              }
            } else if (this.focusId == 'list4') {
              if (this.value4 < 20) {
                this.value4 += 1
                this.translatey4 -= 15
                this.setCustomGeqParams(parseInt(this.value04),this.value4-10);
              }
            } else if (this.focusId == 'list5') {
              if (this.value5 < 20) {
                this.value5 += 1
                this.translatey5 -= 15
                this.setCustomGeqParams(parseInt(this.value05),this.value5-10);
              }
            } else if (this.focusId == 'list6') {
              if (this.value6 < 20) {
                this.value6 += 1
                this.translatey6 -= 15
                this.setCustomGeqParams(parseInt(this.value06),this.value6-10);
              }
            } else if (this.focusId == 'list7') {
              if (this.value7 < 20) {
                this.value7 += 1
                this.translatey7 -= 15
                this.setCustomGeqParams(parseInt(this.value07),this.value7-10);
              }
            } else if (this.focusId == 'list8') {
              if (this.value8 < 20) {
                this.value8 += 1
                this.translatey8 -= 15
                this.setCustomGeqParams(parseInt(this.value08),this.value8-10);
              }
            } else if (this.focusId == 'list9') {
              if (this.value9 < 20) {
                this.value9 += 1
                this.translatey9 -= 15
                this.setCustomGeqParams(parseInt(this.value09),this.value9-10);
              }
            }
          }
          if (e.keyCode == KeyCode.KEYCODE_DPAD_DOWN && e.type == KeyType.Up) {
            if (this.focusId == 'list1') {
              if (this.value1>0) {
                this.value1-= 1
                this.translatey1 += 15
                this.setCustomGeqParams(parseInt(this.value01),this.value1-10);
              }
            } else if (this.focusId == 'list2') {
              if (this.value2>0) {
                this.value2-= 1
                this.translatey2 += 15
                this.setCustomGeqParams(parseInt(this.value02),this.value2-10);
              }
            } else if (this.focusId == 'list3') {
              if (this.value3>0) {
                this.value3-= 1
                this.translatey3 += 15
                this.setCustomGeqParams(parseInt(this.value03),this.value3-10);
              }
            } else if (this.focusId == 'list4') {
              if (this.value4>0) {
                this.value4-=1
                this.translatey4 += 15
                this.setCustomGeqParams(parseInt(this.value04),this.value4-10);
              }
            } else if (this.focusId == 'list5') {
              if (this.value5>0) {
                this.value5-= 1
                this.translatey5 += 15
                this.setCustomGeqParams(parseInt(this.value05),this.value5-10);
              }
            } else if (this.focusId == 'list6') {
              if (this.value6>0) {
                this.value6-= 1
                this.translatey6 += 15
                this.setCustomGeqParams(parseInt(this.value06),this.value6-10);
              }
            } else if (this.focusId == 'list7') {
              if (this.value7>0) {
                this.value7-= 1
                this.translatey7 += 15
                this.setCustomGeqParams(parseInt(this.value07),this.value7-10);
              }
            } else if (this.focusId == 'list8') {
              if (this.value8>0) {
                this.value8-= 1
                this.translatey8 += 15
                this.setCustomGeqParams(parseInt(this.value08),this.value8-10);
              }
            } else if (this.focusId == 'list9') {
              if (this.value9>0) {
                this.value9-= 1
                this.translatey9 += 15
                this.setCustomGeqParams(parseInt(this.value09),this.value9-10);
              }
            }
          }
        })
      }
      .focusable(true)
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Start)
      .width('1200lpx')
      .height('651lpx')
      .padding({
        left: '85lpx',
        right: '85lpx',
        bottom: '48lpx'
      })
      .backgroundColor('#404040')
      .borderRadius('24lpx')
    }
    .focusable(true)
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .backgroundColor('#cc000000')
  }
}
