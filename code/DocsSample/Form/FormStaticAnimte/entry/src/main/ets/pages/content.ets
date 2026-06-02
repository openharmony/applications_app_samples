'use static'

// xxx.ets


import { ComponentContent, UIContext } from '@kit.ArkUI';

import { Entry, Text, Row, Column, Component, FontWeight, ComponentContent, TabsOptions, Color, SubTabBarStyle, BarPosition, TabContent, Tabs, TabsController, Button, ClickEvent } from '@ohos.arkui.component'
import { State } from '@ohos.arkui.stateManagement'
import hilog from '@ohos.hilog'
import { UIContext } from '@ohos.arkui.UIContext';
import { WrappedBuilder} from '@ohos.arkui.component';

class Params {
  text: string = '';

  constructor(text: string) {
    this.text = text;
  }
}

@Builder
function buildText(params: Params) {
  Column() {
    Text(params.text)
      .fontSize(20)
      .fontWeight(FontWeight.Bold)
      .margin(20)
  }
}

@Entry
@Component
struct Index2 {
  @State message1: string = 'tabBar1';
  @State message2: string = 'tabBar2';
  context: UIContext = this.getUIContext();
  private count1: int = 0;
  private count2: int = 0;
  private controller: TabsController = new TabsController();
  // tabBar1: ComponentContent<Params> = new ComponentContent<Params>(this.context, wrapBuilder<[Params]>(buildText), new Params(this.message1));
  // tabBar2: ComponentContent<Params> = new ComponentContent<Params>(this.context, wrapBuilder<[Params]>(buildText), new Params(this.message2));

  build() {
    Row() {
      Column() {
        // Button('更新tabBar1').width('90%').margin(20)
        //   .onClick((event?: ClickEvent) => {
        //     this.count1 += 1;
        //     const message1 = 'Update 1_' + this.count1.toString();
        //     this.tabBar1.update(new Params(message1));
        //   })
        // Button('更新tabBar2').width('90%').margin(20)
        //   .onClick((event?: ClickEvent) => {
        //     this.count2 += 1;
        //     const message2 = 'Update 2_' + this.count2.toString();
        //     this.tabBar2.update(new Params(message2));
        //   })
        Tabs({ barPosition: BarPosition.Start, controller: this.controller } as TabsOptions) {
          TabContent() {
            Column().width('100%').height('100%').backgroundColor(Color.Pink).borderRadius('12vp')
          }
          // .tabBar(new SubTabBarStyle(this.tabBar1))
          TabContent() {
            Column().width('100%').height('100%').backgroundColor(Color.Blue).borderRadius('12vp')
          }
          // .tabBar(SubTabBarStyle.of(this.tabBar2))
        }
        .vertical(false)
        .barWidth(414)
        .barHeight(96)
        .width(414)
        .height(414)
        .backgroundColor('#F1F3F5')
        .margin({ top: 20 })
      }
      .width('100%')
      .height('100%')
    }
    .height('100%')
  }
}