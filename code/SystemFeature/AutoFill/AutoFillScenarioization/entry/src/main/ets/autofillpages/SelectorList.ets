/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { nameList, phoneList } from '../application/ItemListData';
import { common, autoFillManager } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

let storage = LocalStorage.getShared();
let fillCallback = storage.get<autoFillManager.FillRequestCallback>('fillCallback');
let viewData: autoFillManager.ViewData | undefined = storage.get<autoFillManager.ViewData>('viewData');
let type: number | undefined = storage.get<number>('autoFillType');
let context = AppStorage.get('contextEvent') as common.UIAbilityContext;
let itemList: Array<string> | undefined;
let typeToDataMap: Map<number, Array<string>> = new Map();
const TAG: string = 'autoFill';
const DOMAIN_NUMBER: number = 0xFF00;
const FULL_PHONE_NUMBER: number = 15;
const PERSON_FULL_NAME: number = 10;

typeToDataMap.set(PERSON_FULL_NAME, nameList);
typeToDataMap.set(FULL_PHONE_NUMBER, phoneList);

function successFunc(index: number, item: string) {
  if (viewData && index >= 0 && type != undefined) {
    itemList = typeToDataMap.get(type);
    if (itemList) {
      for (let i = 0; i < viewData.pageNodeInfos.length; i++) {
        if (viewData.pageNodeInfos[i].isFocus === true) {
          viewData.pageNodeInfos[i].value = item;
          break;
        }
      }
    }
    if (fillCallback) {
      let response: autoFillManager.FillResponse = { viewData: viewData };
      fillCallback.onSuccess(response);
    }
  }
}

@Entry
@Component
struct SelectorList {
  @State itemListData: Array<string> = [];

  aboutToAppear(): void {
    if (type != undefined) {
      let maybeUndefined: Array<string> | undefined = typeToDataMap.get(type);
      if (maybeUndefined != undefined) {
        this.itemListData = maybeUndefined;
      }
    }
    context.eventHub.on('updateRequestData', (eventData: Array<string>) => {
      hilog.info(DOMAIN_NUMBER, TAG, 'eventHub called' + eventData);
      this.itemListData = eventData;
    });
  }

  build() {
    Row() {
      Column() {
        List({ space: 10, initialIndex: 0 }) {
          ForEach(this.itemListData, (item: string, index: number) => {
            ListItem() {
              Text(item ? item : '')
                .width('100%')
                .height(40)
                .fontSize($r('sys.float.ohos_id_text_size_body1'))
                .fontColor($r('sys.color.ohos_id_color_text_primary'))
                .textAlign(TextAlign.Start)
                .margin({ left: '4.8%' })
                .borderRadius($r('sys.float.ohos_id_corner_radius_card'))
            }
            .onClick(() => {
              hilog.info(DOMAIN_NUMBER, TAG, 'click item: ', item);
              successFunc(index, item);
            })
          })
        }
        .listDirection(Axis.Vertical)
        .scrollBar(BarState.Off)
        .friction(0.6)
        .divider({ strokeWidth: 1, color: $r('app.color.placeholderColor'), startMargin: 20, endMargin: 20 })
        .edgeEffect(EdgeEffect.Spring)
        .onScrollIndex((firstIndex: number, lastIndex: number, centerIndex: number) => {
          hilog.info(DOMAIN_NUMBER, TAG, 'first' + firstIndex);
          hilog.info(DOMAIN_NUMBER, TAG, 'last' + lastIndex);
          hilog.info(DOMAIN_NUMBER, TAG, 'center' + centerIndex);
        })
        .onScroll((scrollOffset: number, scrollState: ScrollState) => {
          hilog.info(DOMAIN_NUMBER, TAG, `onScroll scrollState = ScrollState` + scrollState + `, scrollOffset = ` +
            scrollOffset);
        })
      }
      .width('100%')
      .shadow(ShadowStyle.OUTER_FLOATING_SM)
    }
    .height('100%')
    .shadow(ShadowStyle.OUTER_FLOATING_SM)
  }
}