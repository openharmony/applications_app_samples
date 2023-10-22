/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
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
import FolderItem from './FolderItem';

@Component
export default struct Folder {
  @State images: Array<Resource> = new Array<Resource>($r('app.media.img_test_1'), $r('app.media.img_test_2'), $r('app.media.img_test_3'));
  @Link isOpen: boolean;

  build() {
    Column() {
      Grid() {
        ForEach(this.images, (image: Resource, i: number) => {
          ForEach(this.images, (image: Resource, index: number) => {
            GridItem() {
              FolderItem({ isOpen: $isOpen, img: image, name: `${(index + 1) + i * this.images.length}` })
            }
          }, (image: Resource, index: number) => index.toString())
        }, (image: Resource, index: number) => index.toString())
      }
      .columnsTemplate('1fr 1fr 1fr')
      .rowsTemplate('1fr 1fr 1fr')
      .rowsGap(this.isOpen ? 3 : 0)
      .rowsGap(this.isOpen ? 9 : 0)
      .padding(this.isOpen ? 12 : 6)
      .borderRadius(10)
      .backgroundColor('#99ffffff')
    }
  }
}