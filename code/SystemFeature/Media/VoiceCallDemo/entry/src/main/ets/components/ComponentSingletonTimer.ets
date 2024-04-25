/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import TimerUtil, { Observer } from '../utils/TimerUtil';
import TimeUtil from '../utils/TimeUtil';

/**
 * 结合单例TimerUtil，实现单例timer组件
 */
@Component
export default struct ComponentSingletonTimer {
  @State time: string = '00:00';
  private mTextColor: ResourceColor = $r('app.color.color_fff');
  private mTextSize: Length = 18;
  private observer: Observer | null = null;

  build() {
    Text(this.time)
      .id('componentSingletonTimer')
      .fontColor(this.mTextColor)
      .fontSize(this.mTextSize)
      .fontWeight(FontWeight.Regular)
      .fontFamily('HarmonyOS Sans SC')
  }

  aboutToAppear() {
    this.timerCallback();
    this.observer = TimerUtil.getInstance().registerObserver((count: number) => {
      this.timerCallback();
    })
  }

  aboutToDisappear() {
    if(this.observer){
      TimerUtil.getInstance().removeObserver(this.observer);
    }
  }

  private timerCallback() {
    TimerUtil.getInstance().getTimestamp().then((data) => {
      this.time = TimeUtil.getTimeStr(data);
    });
  }
}
