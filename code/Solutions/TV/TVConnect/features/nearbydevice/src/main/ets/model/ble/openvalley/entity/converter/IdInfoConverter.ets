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
import { PayloadIdInfo } from '../../model/payload/PayloadIdInfo';
import { ControllerItem } from '../ControllerItem';

export class IdInfoConverter {
  private static instance: IdInfoConverter | null = null;

  private constructor() {
  }

  public static getInstance(): IdInfoConverter {
    if (!IdInfoConverter.instance) {
      IdInfoConverter.instance = new IdInfoConverter();
    }
    return IdInfoConverter.instance;
  }

  convert(idInfo: PayloadIdInfo): Array<ControllerItem> {
    let list: ControllerItem[] = [];
    for (let i = 0; i < idInfo.idLists!.length; i++) {
      let id: string = idInfo.idLists![i];
      let name: string = idInfo.ctrlNameLists![i];
      let item: ControllerItem = new ControllerItem();
      item.id = id;
      item.name = name;
      item.showName = name;
      if (idInfo.stateLists && idInfo.stateLists.length > 0) {
        item.state = idInfo.stateLists[i];
      }
      list.push(item);
    }
    return list;
  }

  convert2CurrentControllerItem(localId: string, idInfo: PayloadIdInfo): ControllerItem | null {
    for (let i = 0; i < idInfo.idLists!.length; i++) {
      let id: string = idInfo.idLists![i];
      if (id === localId) {
        let item: ControllerItem = new ControllerItem();
        let name: string = idInfo.ctrlNameLists![i];
        item.id = id;
        item.name = name;
        return item;
      }
    }
    return null;
  }
}