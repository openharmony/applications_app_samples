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
import { StyleConstants } from '../../common/constants/StyleConstants';

@Component
export default struct imageSet {
  @Link imageSrc: Array<string>;
  setList: Array<number> = [0.02, 0.03, (-0.023), 0.03];
  imageIndex: number = 0;
  @State setListData: Array<number> = [];

  aboutToAppear(): void {
    this.setListData = [];
    this.setListData = [...this.setList];
  }

  build() {
    Column() {

      Image($r(this.imageSrc[this.imageIndex]))
        .width(StyleConstants.LPX_DESIGNWIDTH * this.setListData[0] + 'lpx')
        .height(StyleConstants.LPX_DESIGNWIDTH * this.setListData[1] + 'lpx')
        .zIndex(10)
        .position({
          x: StyleConstants.LPX_DESIGNWIDTH * this.setListData[2] + 'lpx',
          y: StyleConstants.LPX_DESIGNWIDTH * this.setListData[3] + 'lpx'
        })
        .autoResize(true);
    };
  }
}

