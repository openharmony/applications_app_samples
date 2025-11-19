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

// [Start import_the_aip_module]
import { intelligence } from '@kit.ArkData';
// [End import_the_aip_module]
// [Start import_the_common_module]
import { BusinessError } from '@kit.BasicServicesKit';
// [End import_the_common_module]

// [Start aip_getTextEmbeddingModel_operating_parameter]
let textConfig:intelligence.ModelConfig = {
  version:intelligence.ModelVersion.BASIC_MODEL,
  isNpuAvailable:false,
  cachePath:"/data"
}
let textEmbedding:intelligence.TextEmbedding;
// [End aip_getTextEmbeddingModel_operating_parameter]

// [Start aip_getImageEmbeddingModel_operating_parameter]
let imageConfig:intelligence.ModelConfig = {
  version:intelligence.ModelVersion.BASIC_MODEL,
  isNpuAvailable:false,
  cachePath:"/data"
}
let imageEmbedding:intelligence.ImageEmbedding;
// [End aip_getImageEmbeddingModel_operating_parameter]

@Entry
@Component
struct Index {
  @State message: string = 'aip';

  private getTextEmbeddingModel(): void {
    // [Start aip_getTextEmbeddingModel_operating]
    intelligence.getTextEmbeddingModel(textConfig)
      .then((data:intelligence.TextEmbedding) => {
        console.info('Succeeded in getting TextModel');
        textEmbedding = data;
        // [StartExclude aip_getTextEmbeddingModel_operating]
        this.message = 'aip getTextEmbeddingModel';
        // [EndExclude aip_getTextEmbeddingModel_operating]
      })
      .catch((err:BusinessError) => {
        console.error('Failed to get TextModel and code is ' + err.code);
        // [StartExclude aip_getTextEmbeddingModel_operating]
        this.message = 'aip getTextEmbeddingModel';
        // [EndExclude aip_getTextEmbeddingModel_operating]
      })
    // [End aip_getTextEmbeddingModel_operating]
  }

  private loadTextModel(): void {
    if (textEmbedding == undefined) {
      this.message = 'aip loadTextModel';
    } else {
      // [Start aip_loadTextModel_operating]
      textEmbedding.loadModel()
        .then(() => {
          console.info('Succeeded in loading Model');
          // [StartExclude aip_loadTextModel_operating]
          this.message = 'aip loadTextModel';
          // [EndExclude aip_loadTextModel_operating]
        })
        .catch((err:BusinessError) => {
          console.error('Failed to load Model and code is ' + err.code);
          // [StartExclude aip_loadTextModel_operating]
          this.message = 'aip loadTextModel';
          // [EndExclude aip_loadTextModel_operating]
        })
      // [End aip_loadTextModel_operating]
    }
  }

  private getTextEmbedding(): void {
    if (textEmbedding == undefined) {
      this.message = 'aip getTextEmbedding';
    } else {
      // [Start aip_getTextEmbedding_operating]
      let text = 'text';
      textEmbedding.getEmbedding(text)
        .then((data:Array<number>) => {
          console.info('Succeeded in getting Embedding');
          // [StartExclude aip_getTextEmbedding_operating]
          this.message = 'aip getTextEmbedding';
          // [EndExclude aip_getTextEmbedding_operating]
        })
        .catch((err:BusinessError) => {
          console.error('Failed to get Embedding and code is ' + err.code);
          // [StartExclude aip_getTextEmbedding_operating]
          this.message = 'aip getTextEmbedding';
          // [EndExclude aip_getTextEmbedding_operating]
        })

      let batchTexts = ['text1','text2'];
      textEmbedding.getEmbedding(batchTexts)
        .then((data:Array<Array<number>>) => {
          console.info('Succeeded in getting Embedding');
          // [StartExclude aip_getTextEmbedding_operating]
          this.message = 'aip getTextEmbedding';
          // [EndExclude aip_getTextEmbedding_operating]
        })
        .catch((err:BusinessError) => {
          console.error('Failed to get Embedding and code is ' + err.code);
          // [StartExclude aip_getTextEmbedding_operating]
          this.message = 'aip getTextEmbedding';
          // [EndExclude aip_getTextEmbedding_operating]
        })
      // [End aip_getTextEmbedding_operating]
    }
  }

  private releaseTextModel(): void {
    if (textEmbedding == undefined) {
      this.message = 'aip releaseTextModel';
    } else {
      // [Start aip_releaseTextModel_operating]
      textEmbedding.releaseModel()
        .then(() => {
          console.info('Succeeded in releasing Model');
          // [StartExclude aip_releaseTextModel_operating]
          this.message = 'aip releaseTextModel';
          // [EndExclude aip_releaseTextModel_operating]
        })
        .catch((err:BusinessError) => {
          console.error('Failed to release Model and code is ' + err.code);
          // [StartExclude aip_releaseTextModel_operating]
          this.message = 'aip releaseTextModel';
          // [EndExclude aip_releaseTextModel_operating]
        })
      // [End aip_releaseTextModel_operating]
    }
  }

  private splitText(): void {
    // [Start aip_splitText_operating]
    let splitConfig:intelligence.SplitConfig = {
      size:10,
      overlapRatio:0.1
    }
    let splitText = 'text';

    intelligence.splitText(splitText, splitConfig)
      .then((data:Array<string>) => {
        console.info('Succeeded in splitting Text');
        // [StartExclude aip_splitText_operating]
        this.message = 'aip splitText';
        // [EndExclude aip_splitText_operating]
      })
      .catch((err:BusinessError) => {
        console.error('Failed to split Text and code is ' + err.code);
        // [StartExclude aip_splitText_operating]
        this.message = 'aip splitText';
        // [EndExclude aip_splitText_operating]
      })
    // [End aip_splitText_operating]
  }

  private getImageEmbeddingModel(): void {
    // [Start aip_getImageEmbeddingModel_operating]
    intelligence.getImageEmbeddingModel(imageConfig)
      .then((data:intelligence.ImageEmbedding) => {
        console.info('Succeeded in getting ImageModel');
        imageEmbedding = data;
        // [StartExclude aip_getImageEmbeddingModel_operating]
        this.message = 'aip getImageEmbeddingModel';
        // [EndExclude aip_getImageEmbeddingModel_operating]
      })
      .catch((err:BusinessError) => {
        console.error('Failed to get ImageModel and code is ' + err.code);
        // [StartExclude aip_getImageEmbeddingModel_operating]
        this.message = 'aip getImageEmbeddingModel';
        // [EndExclude aip_getImageEmbeddingModel_operating]
      })
    // [End aip_getImageEmbeddingModel_operating]
  }

  private loadImageModel(): void {
    if (imageEmbedding == undefined) {
      this.message = 'aip loadImageModel';
    } else {
      // [Start aip_loadImageModel_operating]
      imageEmbedding.loadModel()
        .then(() => {
          console.info('Succeeded in loading Model');
          // [StartExclude aip_loadImageModel_operating]
          this.message = 'aip loadImageModel';
          // [EndExclude aip_loadImageModel_operating]
        })
        .catch((err:BusinessError) => {
          console.error('Failed to load Model and code is ' + err.code);
          // [StartExclude aip_loadImageModel_operating]
          this.message = 'aip loadImageModel';
          // [EndExclude aip_loadImageModel_operating]
        })
      // [End aip_loadImageModel_operating]
    }
  }

  private getImageEmbedding(): void {
    if (imageEmbedding == undefined) {
      this.message = 'aip getImageEmbedding';
    } else {
      // [Start aip_getImageEmbedding_operating]
      let image = 'file://<packageName>/data/storage/el2/base/haps/entry/files/xxx.jpg';
      imageEmbedding.getEmbedding(image)
        .then((data:Array<number>) => {
          console.info('Succeeded in getting Embedding');
          // [StartExclude aip_getImageEmbedding_operating]
          this.message = 'aip getImageEmbedding';
          // [EndExclude aip_getImageEmbedding_operating]
        })
        .catch((err:BusinessError) => {
          console.error('Failed to get Embedding and code is ' + err.code);
          // [StartExclude aip_getImageEmbedding_operating]
          this.message = 'aip getImageEmbedding';
          // [EndExclude aip_getImageEmbedding_operating]
        })
      // [End aip_getImageEmbedding_operating]
    }
  }

  private releaseImageModel(): void {
    if (imageEmbedding == undefined) {
      this.message = 'aip releaseImageModel';
    } else {
      // [Start aip_releaseImageModel_operating]
      imageEmbedding.releaseModel()
        .then(() => {
          console.info('Succeeded in releasing Model');
          // [StartExclude aip_releaseImageModel_operating]
          this.message = 'aip releaseImageModel';
          // [EndExclude aip_releaseImageModel_operating]
        })
        .catch((err:BusinessError) => {
          console.error('Failed to release Model and code is ' + err.code);
          // [StartExclude aip_releaseImageModel_operating]
          this.message = 'aip releaseImageModel';
          // [EndExclude aip_releaseImageModel_operating]
        })
      // [End aip_releaseImageModel_operating]
    }
  }

  build() {
    Column() {
      Text(this.message)
        .fontSize(35)
        .fontWeight(FontWeight.Bold).margin({ bottom:10 })
        .height('20%')
        .id('show')
      Button('获取文本模型')
        .margin(10)
        .id('button1')
        .width('30%')
        .onClick(() => this.getTextEmbeddingModel())
      Button('加载文本模型')
        .margin(10)
        .id('button2')
        .width('30%')
        .onClick(() => this.loadTextModel())
      Button('获取文本向量')
        .margin(10)
        .id('button3')
        .width('30%')
        .onClick(() => this.getTextEmbedding())
      Button('释放文本模型')
        .margin(10)
        .id('button4')
        .width('30%')
        .onClick(() => this.releaseTextModel())
      Button('获取文本分块')
        .margin(10)
        .id('button5')
        .width('30%')
        .onClick(() => this.splitText())
      Button('获取图像模型')
        .margin(10)
        .id('button6')
        .width('30%')
        .onClick(() => this.getImageEmbeddingModel())
      Button('加载图像模型')
        .margin(10)
        .id('button7')
        .width('30%')
        .onClick(() => this.loadImageModel())
      Button('获取图像向量')
        .margin(10)
        .id('button8')
        .width('30%')
        .onClick(() => this.getImageEmbedding())
      Button('释放图像模型')
        .margin(10)
        .id('button9')
        .width('30%')
        .onClick(() => this.releaseImageModel())
    }
    .height('100%')
    .width('100%')
  }
}