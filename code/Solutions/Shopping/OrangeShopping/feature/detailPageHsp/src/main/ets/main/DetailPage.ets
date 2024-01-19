/*
* Copyright (c) 2023 Huawei Device Co., Ltd.
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

import common from '@ohos.app.ability.common';
import { Location } from '../components/Location';
import { Information } from '../components/Information';
import { Choice } from '../components/Choice';
import { AddressService } from '../components/AddressService';
import { Valuation } from '../components/Valuation';
import { BottomNavigation } from '../components/BottomNavigation';
import { VideoPage } from '../components/VideoPage';
import { SmallVideo } from '../components/SmallVideo';
import { SWIPER_PICTURE_DATA } from '../mock/DetailData';
import { ButtonDialogBuilder } from '@ohos/sharecomponent';
import { ProductDataModel } from '../../../../../navigationHome/src/main/ets/model/GoodsModel'
import { logger } from '../utils/Logger';

const SRC_IMG: string = 'https://res5.vmallres.com/pimages/uomcdn/CN/pms/202207/gbom/6941487270880/428_428_1142FAB7EA4DCBDD8C64BF54486A7D4Bmp.png';
let context = getContext(this) as common.UIAbilityContext;

function getResourceString(resourceData: Resource): string {
  let stringData: string = context.resourceManager.getStringSync(resourceData);
  logger.info(`getResourceString start`);
  logger.info(`getResourceString stringData ${stringData}`);
  return stringData;
}

@Component
export struct DetailPage {
  @State sOpacity: number = 1;
  @State isPanel: boolean = false;
  @State goodDetailData: ProductDataModel = new ProductDataModel(0, '', '', '', '', '');
  @State currentLocation: string = '';
  @State recommend: string = '';
  @State commodity: string = '';
  @State swiperIndex: number = 0;
  // Video组件
  @State isHidden: boolean = false;
  @State isState: boolean = true;
  @State isCancel: boolean = true;
  @State activeVideo: number = 0;
  @State openFirst: boolean = false;
  @Provide('playTime') playNum: number = 20;
  @StorageProp('curBp') curBp: string = 'md';
  private shareDialog?: CustomDialogController;
  private scroller: Scroller = new Scroller();
  @State isShowImage: boolean = true;
  @State animateAppear: boolean = false;
  @State animateScale: boolean = false;
  @State animatePath: boolean = false;
  @State breakPoints: string | undefined = AppStorage.get('breakPoint');
  @Consume('pageStack') pageStack: NavPathStack;

  build() {
    Stack({ alignContent: Alignment.Top }) {
      Stack() {
        Scroll(this.scroller) {
          Column({ space: 12 }) {
            Stack({ alignContent: Alignment.BottomEnd }) {
              Swiper() {
                VideoPage({ isStart: $openFirst, coverUrl: this.goodDetailData.uri as string })
                  .id('VideoPage')
                ForEach(SWIPER_PICTURE_DATA, () => {
                  Column() {
                    Image(this.goodDetailData.uri)
                      .objectFit(ImageFit.Contain);
                  }
                  .aspectRatio(1.12)
                  .backgroundColor('#ffffff')
                  .width('100%');
                })
              }
              .height(this.breakPoints === 'sm' ? 400 : 300)
              .index(this.swiperIndex)
              .indicator(false)
              .onChange((index: number) => {
                this.swiperIndex = index;
              });

              Row() {
                Text(`${this.swiperIndex + 1}/${SWIPER_PICTURE_DATA.length + 1}`)
                  .fontSize(12)
                  .fontColor($r('app.color.white'));
              }
              .width(46)
              .height(24)
              .borderRadius(12)
              .justifyContent(FlexAlign.Center)
              .backgroundColor($r('app.color.bg3'))
              .margin({ right: 16, bottom: 16 });
            }
            .width('100%')
            .height(this.breakPoints === 'sm' ? 400 : 300)
            .backgroundColor($r('app.color.white'));

            Column() {
              Information({ goodDetailData: $goodDetailData })
                .margin({ top: 12 });
              Choice()
                .margin({ top: 12 });
              AddressService({ currentLocation: $currentLocation, isPanel: $isPanel })
                .margin({ top: 12 });
              Valuation()
                .margin({ top: 12 });
            }
            .padding({ left: 12, right: 12 });
          }
          .id('goodsDetail' + this.goodDetailData.id)
          .width('100%');
        }
        .width('100%')
        .align(Alignment.Top)
        .scrollBar(BarState.Off)
        .padding({ bottom: this.curBp === 'sm' ? 86 : 106 })
        .onScroll(() => {
          if (this.activeVideo === 0 && this.openFirst) {
            if (this.scroller.currentOffset().yOffset > 450) {
              if (this.isState) {
                this.isHidden = true;
                this.isState = false;
              }
            } else {
              this.isHidden = false;
              this.isState = true;
            }
          }
        });

        Image($r('app.media.back'))
          .width(32)
          .aspectRatio(1)
          .position({ x: 20, y: 20 })
          .onClick(() => {
            this.pageStack.pop();
          });

        Image($r("app.media.share"))
          .width(32)
          .aspectRatio(1)
          .position({ x: '100%', y: 20 })
          .translate({ x: -62, y: 0 })
          .onClick(() => {
            this.shareDialog = new CustomDialogController({
              builder: ButtonDialogBuilder({
                controller: this.shareDialog,
                detailTitleText: this.recommend,
                detailPriceText: '9800',
                title: this.commodity,
                srcImage: SRC_IMG
              }),
              cancel: undefined,
              autoCancel: true,
              alignment: DialogAlignment.Bottom,
              customStyle: true
            });
            this.shareDialog?.open();
          });

        Column({ space: 12 }) {
          Image($r('app.media.broadcast'))
            .width(32)
            .height(32);

          Text($r('app.string.broadcast'))
            .fontSize(14)
            .fontColor($r('app.color.blank'));
        }
        .id('directVideo')
        .width(62)
        .height(78)
        .borderWidth(0.5)
        .borderColor($r('app.color.border'))
        .borderRadius(16)
        .padding(6)
        .backgroundColor($r('app.color.light_white'))
        .position({ x: '100%', y: 160 })
        .translate({ x: -82, y: 0 })
        .onClick(() => {
          this.pageStack.pushPath({ name: 'LivePage' })
        });

        BottomNavigation({
          goodItemData: $goodDetailData,
          animateAppear: $animateAppear,
          animateScale: $animateScale,
          animatePath: $animatePath
        })
          .position({ x: 0, y: '100%' })
          .translate({ x: 0, y: -56 });
        SmallVideo({ isHidden: $isHidden, isCancel: $isCancel })
          .position({ x: '100%', y: '60%' })
          .translate({ x: -180, y: 0 });
        Panel(this.isPanel) {
          Location({ isPanel: $isPanel, currentLocation: $currentLocation });
        }
        .mode(PanelMode.Half)
        .dragBar(false)
        .halfHeight(this.curBp === 'sm' ? 650 : 530)
        .miniHeight(0)
        .onChange(() => {
          this.isPanel = false;
        });

        Column() {
          Image(this.goodDetailData.uri)
            .borderRadius(this.animateScale ? 1000 : 0)
            .transition(TransitionEffect.OPACITY);
        }
        .width('100%')
        .height(300)
        .enabled(this.animatePath)
        .visibility(this.animateAppear ? 0 : 1)
        .scale(this.animateScale ? (this.animatePath ? { x: 0.1, y: 0.1, centerY: '50%' } : {
          x: 0.2,
          y: 0.2,
          centerY: '50%'
        }) : { x: 1, y: 1, centerY: '100%' })
        .opacity(this.animatePath ? 0.3 : 1)
        .translate(this.animatePath ? { x: -80, y: 100 } : { x: 0 })
        .motionPath({
          path: 'Mstart.x start.y C -200 50, -150 200, end.x end.y',
          from: 0.0,
          to: 1.0,
          rotatable: false
        });
      }
      .height('100%')
      .width('100%')
      .backgroundColor($r('app.color.divider'))
      .align(this.animatePath ? Alignment.Bottom : Alignment.Top);

      // 通过isShowImage变量开关控制页面跳转动效，默认为true
      if (this.isShowImage) {
        Column() {
          Image(this.goodDetailData.uri)
            .objectFit(ImageFit.Contain)
            .sharedTransition('goods' + this.goodDetailData.id, { duration: 600, curve: Curve.Linear, delay: 100 })
            .onComplete(() => {
              setTimeout(() => {
                this.isShowImage = false;
              }, 800);
            });
        }
        .width('100%')
        .aspectRatio(1.12)
        .backgroundColor('#ffffff');
      }
    }
  }

  aboutToAppear() {
    this.goodDetailData = this.pageStack.getParamByName('DetailPage')[0] as ProductDataModel;
    logger.info('-------------------');
    logger.info(`Get AllPathName: ${JSON.stringify(this.pageStack.getAllPathName())}`);
    logger.info(`Get params by Index:${JSON.stringify(this.pageStack.getParamByIndex(0))}`);
    logger.info(`Get params by Name: ${JSON.stringify(this.pageStack.getParamByName('DetailPage'))}`);
    logger.info(`Get index by Name: ${JSON.stringify(this.pageStack.getIndexByName('DetailPage'))}`);
    logger.info(`Get stack size: ${JSON.stringify(this.pageStack.size())}`);
    let context: Context = getContext(this);
    this.currentLocation = context.resourceManager.getStringSync($r('app.string.address'));
    this.recommend = context.resourceManager.getStringSync($r('app.string.recommend'));
    this.commodity = context.resourceManager.getStringSync($r('app.string.commodity'));
  }
}