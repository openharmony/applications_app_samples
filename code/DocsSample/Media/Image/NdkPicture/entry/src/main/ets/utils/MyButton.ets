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
import { AppLog } from '../utils/Logger'

const TAG: string = "DEBUG TEST";

@Component
export struct myButton {
  //自定义button 回调函数目前只支持void和无参
  public logger = new AppLog(TAG);
  public fun: () => void = () => {
  };
  public text = "This is a button";
  @State returnMessage: string = "No";

  build() {
    Row() {
      Column() {
        Blank().height(40);
        Button(`${this.text}`)
          .labelStyle({
            overflow: TextOverflow.Clip,
            maxLines: 2,
            minFontSize: 20,
            maxFontSize: 20,
            font: {
              size: 20,
              weight: FontWeight.Bolder,
              family: 'cursive',
              style: FontStyle.Italic
            }
          })
          .onClick(() => {
            this.logger.log("\n start->>>>>>>>>>>>>>>>>>>>>>");
            this.fun();
            this.logger.log((this.fun.toString()) + "\n end:->>>>>>>>>>>>>>>>>>>>>>");
            this.returnMessage = "Yes";
          })
        Blank().height(40);
        Divider();
      }
    }
  }
}