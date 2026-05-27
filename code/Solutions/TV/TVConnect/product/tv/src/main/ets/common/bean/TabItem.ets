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
/**
 * Tab item info.
 */
export class TabItem {
  constructor(index: number, title: Resource, imageActivated: Resource, imageOriginal: Resource) {
    this.index = index;
    this.title = title;
    this.imageActivated = imageActivated;
    this.imageOriginal = imageOriginal;
  }

  /**
   * Tab item index.
   */
  public index: number;
  /**
   * Tab item title.
   */
  public title: Resource;
  /**
   * Image activated.
   */
  public imageActivated: Resource;
  /**
   * Image original.
   */
  public imageOriginal: Resource;
}