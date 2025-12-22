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

import { BasicDataSource, ColorModel } from './BasicDataSource';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

export class ColorData extends BasicDataSource<ColorModel> {
  public textColorData: Array<ColorModel> = [];
  private context: Context | undefined = undefined;

  constructor(context?: Context) {
    super();
    this.context = context;
  }

  public totalCount(): number {
    return this.textColorData.length;
  }

  public getData(index: number): ColorModel | void {
    if (index === this.textColorData.length - 1) {
      this.getColorData();
    }
    return this.textColorData[index];
  }

  public pushData(data: ColorModel): void {
    this.textColorData.push(data);
    this.notifyDataAdd(this.textColorData.length - 1);
  }

  public async getColorData(): Promise<void> {
    let color: Color[] =
      [Color.Black, Color.Blue, Color.Red, Color.Green, Color.Pink, Color.Black, Color.Blue, Color.Red, Color.Green,
        Color.Pink];
    try {
      for (let i = 0; i < 10; i++) {
        let colorModel: ColorModel = new ColorModel('', '', Color.White);
        colorModel.id = Math.floor(this.totalCount() / 10) + i.toString();
        colorModel.text =
          this.context!.resourceManager.getStringSync($r('app.string.update_component_title').id, parseInt(colorModel.id) + 1);
        colorModel.color = color[i];
        this.pushData(colorModel);
      }
    } catch (e) {
      let err = e as BusinessError;
      hilog.error(0x0000, 'testTag', `failed code=${err.code}, message=${err.message}`);
    }

  }
}