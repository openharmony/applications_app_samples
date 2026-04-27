/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

@Component
export default struct ProgramInfo {
  @Prop name: string = '';
  @Prop datetime: string = '';
  @Prop epgCurrent: string = '';
  @Prop epgAfter: string = '';

  build() {
    Column({space: '24lpx'}) {
      Row({space: '24lpx'}) {
        Text('88')
          .lineHeight('75lpx')
          .fontSize('64lpx')
          .fontColor('#E6FFFFFF')
          .fontWeight(500)
          .textAlign(TextAlign.Start);

        Text('CCTV-1')
          .lineHeight('56lpx')
          .fontSize('48lpx')
          .fontColor('#E6FFFFFF')
          .fontWeight(500)
          .textAlign(TextAlign.Start);

      }
      .width('100%');

      Row({space: '20lpx'}) {

        // 时间轴
        Column(){
          Row()
          .width('18lpx')
          .height('18lpx')
          .backgroundColor('#FFFFFF').borderRadius('50%');
          Row()
            .width('4lpx')
            .height('84lpx')
            .margin({top: '-4lpx'})
            .linearGradient({
              direction: GradientDirection.Top, // 渐变方向;
              colors: [[0x000000, 0], [0xE6FFFFFF, 1]] // 数组末尾元素占比小于1时满足重复着色效果;
            });
        }
        .padding({top: '14lpx'});

        Column({space: '24lpx'}){
          // 当前节目
          Row({space: '16lpx'}){
            Text('正在播放')
              .fontSize('24lpx')
              .lineHeight('35lpx')
              .backgroundColor('#0191FF')
              .fontColor('#dbffffff')
              .borderRadius('20lpx')
              .width('110lpx')
              .height('40lpx')
              .textAlign(TextAlign.Center);
            Text(this.epgCurrent)
              .fontSize('30lpx')
              .fontColor('#FFFFFF')
              .textAlign(TextAlign.Start)
              .textOverflow({ overflow: TextOverflow.None });
          }
          // 下一个节目
          Row({space: '16lpx'}){
            Text('下个节目')
              .fontSize('24lpx')
              .backgroundColor('#00ffffff')
              .fontColor('#99FFFFFF')
              .width('110lpx')
              .textAlign(TextAlign.Center);
            Text(this.epgAfter)
              .fontSize('24lpx')
              .fontColor('#99FFFFFF');
          }
        }
        .alignItems(HorizontalAlign.Start);

      }
      .alignItems(VerticalAlign.Top)
      .width('100%');
    }
    .width('100%')
    .height('300lpx')
    .padding({ left: '96lpx', right: '96lpx', top: '50lpx', bottom: '10lpx' })
    .backgroundColor('#9e3e3e3e')
    .linearGradient({
      direction: GradientDirection.Top,
      colors: [[0x000000, 0.0], [0x9e3e3e3e, 1]]
    });
  }

}

export interface ProgramInfoPresentation {
  channelNoText: string;
  channelNameText: string;
  currentProgramText: string;
  nextProgramText: string;
  dateTimeText: string;
}

/**
 * Builds stable program information text with empty-value fallbacks.
 *
 * @param channelNo Channel number shown on the left side of the banner.
 * @param channelName Channel name shown next to the number.
 * @param currentProgram Current EPG text.
 * @param nextProgram Next EPG text.
 * @param dateTime Program datetime text.
 * @returns ProgramInfoPresentation Sanitized text payload for the component.
 */
export function buildProgramInfoPresentation(
  channelNo: number,
  channelName: string,
  currentProgram: string,
  nextProgram: string,
  dateTime: string
): ProgramInfoPresentation {
  const safeChannelNo = channelNo > 0 ? `${channelNo}` : '--';
  const safeChannelName = channelName.length > 0 ? channelName : '未知频道';
  const safeCurrentProgram = currentProgram.length > 0 ? currentProgram : '暂无节目信息';
  const safeNextProgram = nextProgram.length > 0 ? nextProgram : '暂无后续节目';
  return {
    channelNoText: safeChannelNo,
    channelNameText: safeChannelName,
    currentProgramText: safeCurrentProgram,
    nextProgramText: safeNextProgram,
    dateTimeText: dateTime
  };
}
