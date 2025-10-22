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

// [Start list_scrolling_with_if_statements]
import hilog from '@ohos.hilog';

const TAG = '[Sample_ReusableComponent]';
const DOMAIN = 0xF811;
const BUNDLE = 'ReusableComponent_';

@Entry
@Component
struct Index {
  private dataSource = new MyDataSource<FriendMoment>();

  aboutToAppear(): void {
    for (let i = 0; i < 20; i++) { // 循环20次
      let title = i + 1 + 'test_if';
      this.dataSource.pushData(new FriendMoment(i.toString(), title, 'app.media.app_icon'));
    }

    for (let i = 0; i < 50; i++) { // 循环50次
      let title = i + 1 + 'test_if';
      this.dataSource.pushData(new FriendMoment(i.toString(), title, ''));
    }
  }

  build() {
    Column() {
      // TopBar()
      List({ space: 3 }) {
        LazyForEach(this.dataSource, (moment: FriendMoment) => {
          ListItem() {
            // 使用reuseId进行组件复用的控制。
            OneMoment({ moment: moment })
              .reuseId((moment.image !== '') ? 'withImage' : 'noImage');
          }
        }, (moment: FriendMoment) => moment.id)
      }
      .cachedCount(0)
    }
  }
}

class FriendMoment {
  public id: string = '';
  public text: string = '';
  public title: string = '';
  public image: string = '';
  public answers: Array<ResourceStr> = [];

  constructor(id: string, title: string, image: string) {
    this.text = id;
    this.title = title;
    this.image = image;
  }
}

@Reusable
@Component
export struct OneMoment {
  @Prop moment: FriendMoment;

  // 复用id相同的组件才能触发复用。
  aboutToReuse(params: ESObject): void {
    hilog.info(DOMAIN, TAG, BUNDLE + '=====aboutToReuse====OneMoment==复用了==' + this.moment.text);
  }

  build() {
    Column() {
      Text(this.moment.text)
      // if分支判断。
      if (this.moment.image !== '') {
        Flex({ wrap: FlexWrap.Wrap }) {
          Image($r(this.moment.image)).height(50).width(50);
          Image($r(this.moment.image)).height(50).width(50);
          Image($r(this.moment.image)).height(50).width(50);
          Image($r(this.moment.image)).height(50).width(50);
        }
      }
    }
  }
}

class BasicDataSource<T> implements IDataSource {
  private listeners: DataChangeListener[] = [];
  private originDataArray: T[] = [];

  public totalCount(): number {
    return 0;
  }

  public getData(index: number): T {
    return this.originDataArray[index];
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener);
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      this.listeners.splice(pos, 1);
    }
  }

  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index);
    });
  }
}

export class MyDataSource<T> extends BasicDataSource<T> {
  private dataArray: T[] = [];

  public totalCount(): number {
    return this.dataArray.length;
  }

  public getData(index: number): T {
    return this.dataArray[index];
  }

  public pushData(data: T): void {
    this.dataArray.push(data);
    this.notifyDataAdd(this.dataArray.length - 1);
  }
}
// [End list_scrolling_with_if_statements]
