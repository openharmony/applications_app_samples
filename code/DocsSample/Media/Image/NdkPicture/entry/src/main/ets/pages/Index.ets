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
import image from '@ohos.multimedia.image';
import { myButton } from '../utils/MyButton'
import { PictureFunctions } from '../utils/PicutreFunctions'

@Entry
@Component
struct Index {
  @State message: number = 0;
  @State picture: image.Picture | null = null;
  @State returnMessage: string = "No";
  private test = new PictureFunctions();

  build() {
    Row() {
      Column() {
        List() {
          ListItem() {
            myButton({ text: "Create Picture", fun: this.test.createPicture })
          }

          ListItem() {
            myButton({ text: "Get MainPixelMap", fun: this.test.getMainPixelMap })
          }

          ListItem() {
            myButton({ text: "Pack to Data", fun: this.test.packToData })
          }

          ListItem() {
            myButton({ text: "Pack to File", fun: this.test.packToFile })
          }

          ListItem() {
            myButton({ text: "Release Picture", fun: this.test.pictureRelease })
          }
        }
      }
    }
  }
}