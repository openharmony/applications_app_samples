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
import { Router } from '@kit.ArkUI';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { Hypium } from '@ohos/hypium';
import testsuite from '../../../ohosTest/ets/test/List.test';

let router: Router;

const pageArray: string[] = [
  'pages/PrivateCustomConstructor',
  'pages/GlobalCustomConstructor',
  'pages/ParameterValue',
  'pages/ParameterReference',
  'pages/InCustomComponent',
  'pages/GlobalCustomBuilder',
  'pages/ChangingByDecorator',
  'pages/AsCustomBuilder',
  'pages/NestedBuilderFunctions',
  'pages/BuilderCombined',
  'pages/BuilderCombinedLocal',
  'pages/AcrossComponents',
  'pages/BuilderSupports',
  'pages/MultipleIncorrectUsage1',
  'pages/MultipleIncorrectUsage2',
  'pages/MultipleCorrectUsage',
  'pages/DynamicIncorrectUsage',
  'pages/DynamicCorrectUsage',
  'pages/BuilderIncorrectUsage',
  'pages/BuilderCorrectUsage',
  'pages/OutsideIncorrectUsage',
  'pages/OutsideCorrectUsage',
  'pages/AccessorIncorrectUsage',
  'pages/AccessorCorrectUsage',
  'pages/ChangingIncorrectUsage',
  'pages/ChangingCorrectUsage',
  'pages/WatchIncorrectUsage',
  'pages/WatchCorrectUsage'
];

export const buttonArray: string[] = [
  'ButtonOne',
  'ButtonTwo',
  'ButtonThree',
  'ButtonTwentyEight',
  'ButtonFour',
  'ButtonFive',
  'ButtonSix',
  'ButtonSeven',
  'ButtonEight',
  'ButtonNine',
  'ButtonTen',
  'ButtonEleven',
  'ButtonTwelve',
  'ButtonThirteen',
  'ButtonFourteen',
  'ButtonFifteen',
  'ButtonSixteen',
  'ButtonSeventeen',
  'ButtonEighteen',
  'ButtonNineteen',
  'ButtonTwenty',
  'ButtonTwentyOne',
  'ButtonTwentyTwo',
  'ButtonTwentyThree',
  'ButtonTwentyFour',
  'ButtonTwentyFive',
  'ButtonTwentySix',
  'ButtonTwentySeven',
];

@Extend(Button)
function buttonCustomStyle(id: string, page: string) {
  .fontWeight(FontWeight.Bold)
  .borderColor('#FF8040')
  .borderWidth($r('sys.float.corner_radius_level1'))
  .id(id)
  .onClick(() => {
    router.pushUrl({
      url: page
    })
  })
}

@Entry
@Component
struct Index {

  aboutToAppear(): void {
    router = this.getUIContext().getRouter();
    if (globalThis.autoTest) {
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      let abilityDelegatorArguments = AbilityDelegatorRegistry.getArguments();
      console.info('start run testcase!!!');
      Hypium.hypiumTest(abilityDelegator, abilityDelegatorArguments, testsuite);
    }
  }

  build() {
    Scroll() {
      Column() {
        ForEach(pageArray, (item: string, index: number) => {
          Button($r(`app.string.${buttonArray[index]}`))
            .buttonCustomStyle(`${buttonArray[index]}`, item)
        }, (item: string) => item)
      }
      .width('100%')
    }
    .size({ width: '100%', height: '100%' })
    .scrollBarWidth('5vp')
    .id('rootScroll')
  }
}