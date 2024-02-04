/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import mediaquery from '@ohos.mediaquery';
import window from '@ohos.window';
import { NavigationHomePage, MainPage, NewProduct, ShopCart, User } from '@ohos/navigation-component';
import { UpdateDialog } from '@ohos/updatedialog';
import { EventsDialog } from '@ohos/details-page-hsp';
import { EmitterClass, EventsData } from '@ohos/emitter';
import { Url } from '@ohos/navigation-component/src/main/ets/main/NavigationHomePage';
import { Scan } from './ScanPage';
import { SetPage } from './Setting';
import { Detail } from './Detail';
import { Live } from './LivePage';
import { DynamicLoader } from '@ohos/navigation-component';

const NOW_INDEX: string = 'nowIndex';
const SHOPPING_CART_COODS_LIST: string = 'shoppingCartGoodsList';
const CUR_BP_STR: string = 'curBp';
const SMALL_SCREEN = 'sm';
const MID_SCREEN = 'md';
const LARGE_SCREEN = 'lg';
const SMALL_WIDTH: string = '(320vp<=width<520vp)';
const MID_WIDTH: string = '(520vp<=width<840vp)';
const LARGE_WIDTH: string = '(840vp<=width)';

@Entry
@Component
struct HomePage {
  @Provide('pageStack') pageStack: NavPathStack = new NavPathStack();
  @State url: string = '';
  @State option: object | undefined = undefined;
  @State curBp: string = MID_SCREEN; // curBp指当前窗口断点，sm代表小屏，md代表中屏，lg代表大屏
  private smListener: mediaquery.MediaQueryListener | undefined = undefined;
  private mdListener: mediaquery.MediaQueryListener | undefined = undefined;
  private lgListener: mediaquery.MediaQueryListener | undefined = undefined;
  @StorageLink(SHOPPING_CART_COODS_LIST) shoppingCartGoodsList: number[] = [];
  private emitterClass: EmitterClass = new EmitterClass();
  @BuilderParam  detailPageLoader:()=> void;
  EventsDialogController: CustomDialogController = new CustomDialogController({
    builder: EventsDialog(),
    customStyle: true
  });
  UpdateDialogController: CustomDialogController = new CustomDialogController({
    builder: UpdateDialog(),
    customStyle: true
  });

  @Builder
  PageMap(name: string, param: NavPathStack) {
    if (name === 'QRCodeScanPage') {
      Scan();
    } else if (name === 'SetPage') {
      SetPage();
    } else if (name === 'DetailPage') {
      this.detailPageLoader();
    } else if (name === 'LivePage') {
      Live();
    } else if (name === 'MainPage') {
      MainPage();
    } else if (name === 'NewProductPage') {
      NewProduct();
    } else if (name === 'ShopCartPage') {
      ShopCart();
    } else if (name === 'UserPage') {
      User();
    }
  }

  build() {
    Navigation(this.pageStack) {
      NavigationHomePage(new Url(this.url));
    }.navDestination(this.PageMap)
    .hideTitleBar(true)
  }

  aboutToAppear() {
    // 注册组件
    DynamicLoader.getInstance().register(
      async (key: string) => {
        if (key === "DetailPage") {
          let obj = await import("./DetailPageLoader");
          this.detailPageLoader = obj.DetailPageLoader;
        }
      }
    )
    DynamicLoader.getInstance().fire("DetailPage");
    if (AppStorage.get<number>(NOW_INDEX) === undefined || AppStorage.get<number>(NOW_INDEX) === 0) {
      this.UpdateDialogController.open();
    }
    this.emitterClass.showEventsDialog(() => {
      if (AppStorage.get<number>(NOW_INDEX) === undefined || AppStorage.get<number>(NOW_INDEX) === 0) {
        this.EventsDialogController.open();
      }
    });
    this.emitterClass.setShoppingCartGoodsList((eventData: EventsData) => {
      this.shoppingCartGoodsList.push(eventData.data.id)
      AppStorage.setOrCreate<number[]>(SHOPPING_CART_COODS_LIST, this.shoppingCartGoodsList)
    });
    this.smListener = mediaquery.matchMediaSync(SMALL_WIDTH);
    this.smListener.on('change', this.isBreakpointSM);
    this.mdListener = mediaquery.matchMediaSync(MID_WIDTH);
    this.mdListener.on('change', this.isBreakpointMD);
    this.lgListener = mediaquery.matchMediaSync(LARGE_WIDTH);
    this.lgListener.on('change', this.isBreakpointLG);
    window.getLastWindow({ stageMode: true }).then(result => {
      result.setWindowSystemBarEnable(['status', 'navigation']);
      result.setWindowLayoutFullScreen(false)
    });
  }

  aboutToDisappear() {
    this.smListener?.off('change', this.isBreakpointSM);
    this.mdListener?.off('change', this.isBreakpointMD);
    this.lgListener?.off('change', this.isBreakpointLG);
  }

  isBreakpointSM = (mediaQueryResult: mediaquery.MediaQueryResult): void => {
    if (mediaQueryResult.matches) {
      this.curBp = SMALL_SCREEN;
      AppStorage.setOrCreate(CUR_BP_STR, this.curBp);
    }
  };
  isBreakpointMD = (mediaQueryResult: mediaquery.MediaQueryResult): void => {
    if (mediaQueryResult.matches) {
      this.curBp = MID_SCREEN;
      AppStorage.setOrCreate(CUR_BP_STR, this.curBp);
    }
  };
  isBreakpointLG = (mediaQueryResult: mediaquery.MediaQueryResult): void => {
    if (mediaQueryResult.matches) {
      this.curBp = LARGE_SCREEN;
      AppStorage.setOrCreate(CUR_BP_STR, this.curBp);
    }
  };
}