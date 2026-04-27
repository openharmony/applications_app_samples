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

import ConfigData from '../dtvsetting/ConfigData';
import lpx from '../dtvsetting/Lpx';
import { Ratio } from '../dtvsetting/Ratio';
import { KeyCode } from '@kit.InputKit';
import { promptAction, router } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import deleteChannel from '../../../common/DeleteChannel';
import automatedSearch from '../../../common/AutomatedSearch';
import LogUtil from '../../../utils/LogUtil';
import displaySetting from '@ohos.tvservice.displaySetting';
// import audioSetting from '@ohos.tvservice.audioSetting'
const TAG = 'imagesettingindex';
interface SettingList {
  id: number;
  name: string;
}
interface IChannel {
  id: number;
  url: string;
  channelName: string;
  serviceId: number;
}
// 定义可观察的AspectRatioItem类
@Observed
class AspectRatioItem {
  public id: number;
  public name: string;
  public isSelect: boolean;
  constructor(id: number, name: string, isSelect: boolean = false) {
    this.id = id;
    this.name = name;
    this.isSelect = isSelect;
  }
}
@Observed
class ImageModeItem {
  public id: number;
  public name: string;
  public isSelect: boolean;
  constructor(id: number, name: string, isSelect: boolean = false) {
    this.id = id;
    this.name = name;
    this.isSelect = isSelect;
  }
}
@Observed
class TrackItem {
  public id: number;
  public name: string;
  public isSelect: boolean;
  constructor(id: number, name: string, isSelect: boolean = false) {
    this.id = id;
    this.name = name;
    this.isSelect = isSelect;
  }
}
@Observed
class AudioLanguageFirstItem {
  public id: number;
  public name: string;
  public isSelect: boolean;
  constructor(id: number, name: string, isSelect: boolean = false) {
    this.id = id;
    this.name = name;
    this.isSelect = isSelect;
  }
}
@Observed
class AudioLanguageSecondItem {
  public id: number;
  public name: string;
  public isSelect: boolean;
  constructor(id: number, name: string, isSelect: boolean = false) {
    this.id = id;
    this.name = name;
    this.isSelect = isSelect;
  }
}
@Observed
class ChannelItem {
  public id: number;
  public name: string;
  public isSelect: boolean;
  constructor(id: number, name: string, isSelect: boolean = false) {
    this.id = id;
    this.name = name;
    this.isSelect = isSelect;
  }
}
@Observed
class SoundModeItem {
  public id: number;
  public name: string;
  public isSelect: boolean;
  constructor(id: number, name: string, isSelect: boolean = false) {
    this.id = id;
    this.name = name;
    this.isSelect = isSelect;
  }
}
@Observed
class CaptionSettingLanguageItem {
  public id: number;
  public name: string;
  public isSelect: boolean;
  constructor(id: number, name: string, isSelect: boolean = false) {
    this.id = id;
    this.name = name;
    this.isSelect = isSelect;
  }
}
@Observed
class CaptionSettingFirstItem {
  public id: number;
  public name: string;
  public isSelect: boolean;
  constructor(id: number, name: string, isSelect: boolean = false) {
    this.id = id;
    this.name = name;
    this.isSelect = isSelect;
  }
}
@Observed
class CaptionSettingSecondItem {
  public id: number;
  public name: string;
  public isSelect: boolean;
  constructor(id: number, name: string, isSelect: boolean = false) {
    this.id = id;
    this.name = name;
    this.isSelect = isSelect;
  }
}
// 子组件，使用@ObjectLink绑定单个项
@Component
struct AspectRatioItemView {
  @ObjectLink item: AspectRatioItem;
  @Prop isFocused: boolean
  build() {
    Column() {
      Row() {
        Text(this.item.name)
          .fontColor(this.isFocused ? 'rgba(0, 0, 0, 0.86)' : '#dbffffff')
          .height(lpx(98))
          .fontSize(lpx(36))
          .align(Alignment.Center)
          .margin({
            left: lpx(24)
          })
          .focusable(true)

        Row() {
          Radio({ group: 'radioGroup1', value: 'radio' + this.item.id })
            .width(lpx(40))
            .height(lpx(40))
            .margin({ right: lpx(24) })
            .aspectRatio(1)
            .checked(this.item.isSelect)
        }
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .focusable(true)
      .width('550lpx')
      .height('98lpx')
      .backgroundColor(this.isFocused ? '#e6ffffff' : '#33ffffff')
      .border({
        radius: '18lpx',
      })
    }
    .focusable(true)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .width('566lpx')
    .height('114lpx')
    .border({
      radius: '24lpx',
      color: this.isFocused ? '#e6ffffff' : 'transparent',
      width: '2lpx',
    })
  }
}

@Component
struct ImageModeItemView {
  @ObjectLink item: ImageModeItem;
  @Prop isFocused: boolean
  build() {
    Column() {
      Row() {
        Text(this.item.name)
          .fontColor(this.isFocused ? 'rgba(0, 0, 0, 0.86)' : '#dbffffff')
          .height(lpx(98))
          .fontSize(lpx(36))
          .align(Alignment.Center)
          .margin({
            left: lpx(24)
          })
          .focusable(true)

        Row() {
          Radio({ group: 'radioGroup2', value: 'radio' + this.item.id })
            .width(lpx(40))
            .height(lpx(40))
            .margin({ right: lpx(24) })
            .aspectRatio(1)
            .checked(this.item.isSelect)
        }
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .focusable(true)
      .width('550lpx')
      .height('98lpx')
      .backgroundColor(this.isFocused ? '#e6ffffff' : '#33ffffff')
      .border({
        radius: '18lpx',
      })
    }
    .focusable(true)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .width('566lpx')
    .height('114lpx')
    .border({
      radius: '24lpx',
      color: this.isFocused ? '#e6ffffff' : 'transparent',
      width: '2lpx',
    })
  }
}

@Component
struct TrackListView {
  @ObjectLink item: TrackItem;
  @Prop isFocused: boolean
  build() {
    Column() {
      Row() {
        Text(this.item.name)
          .fontColor(this.isFocused ? 'rgba(0, 0, 0, 0.86)' : '#dbffffff')
          .height(lpx(98))
          .fontSize(lpx(36))
          .align(Alignment.Center)
          .margin({
            left: lpx(24)
          })
          .focusable(true)

        Row() {
          Radio({ group: 'radioGroup3', value: 'radio' + this.item.id })
            .width(lpx(40))
            .height(lpx(40))
            .margin({ right: lpx(24) })
            .aspectRatio(1)
            .checked(this.item.isSelect)
        }
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .focusable(true)
      .width('550lpx')
      .height('98lpx')
      .backgroundColor(this.isFocused ? '#e6ffffff' : '#33ffffff')
      .border({
        radius: '18lpx',
      })
    }
    .focusable(true)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .width('566lpx')
    .height('114lpx')
    .border({
      radius: '24lpx',
      color: this.isFocused ? '#e6ffffff' : 'transparent',
      width: '2lpx',
    })
  }
}

@Component
struct AudioLanguageFirstView {
  @ObjectLink item:AudioLanguageFirstItem;
  @Prop isFocused: boolean
  build() {
    Column() {
      Row() {
        Text(this.item.name)
          .fontColor(this.isFocused ? 'rgba(0, 0, 0, 0.86)' : '#dbffffff')
          .height(lpx(98))
          .fontSize(lpx(36))
          .align(Alignment.Center)
          .margin({
            left: lpx(24)
          })
          .focusable(true)

        Row() {
          Radio({ group: 'radioGroup4', value: 'radio' + this.item.id })
            .width(lpx(40))
            .height(lpx(40))
            .margin({ right: lpx(24) })
            .aspectRatio(1)
            .checked(this.item.isSelect)
        }
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .focusable(true)
      .width('550lpx')
      .height('98lpx')
      .backgroundColor(this.isFocused ? '#e6ffffff' : '#33ffffff')
      .border({
        radius: '18lpx',
      })
    }
    .focusable(true)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .width('566lpx')
    .height('114lpx')
    .border({
      radius: '24lpx',
      color: this.isFocused ? '#e6ffffff' : 'transparent',
      width: '2lpx',
    })
  }
}

@Component
struct AudioLanguageSecondView {
  @ObjectLink item:AudioLanguageSecondItem;
  @Prop isFocused: boolean
  build() {
    Column() {
      Row() {
        Text(this.item.name)
          .fontColor(this.isFocused ? 'rgba(0, 0, 0, 0.86)' : '#dbffffff')
          .height(lpx(98))
          .fontSize(lpx(36))
          .align(Alignment.Center)
          .margin({
            left: lpx(24)
          })
          .focusable(true)

        Row() {
          Radio({ group: 'radioGroup5', value: 'radio' + this.item.id })
            .width(lpx(40))
            .height(lpx(40))
            .margin({ right: lpx(24) })
            .aspectRatio(1)
            .checked(this.item.isSelect)
        }
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .focusable(true)
      .width('550lpx')
      .height('98lpx')
      .backgroundColor(this.isFocused ? '#e6ffffff' : '#33ffffff')
      .border({
        radius: '18lpx',
      })
    }
    .focusable(true)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .width('566lpx')
    .height('114lpx')
    .border({
      radius: '24lpx',
      color: this.isFocused ? '#e6ffffff' : 'transparent',
      width: '2lpx',
    })
  }
}

@Component
struct ChannelView {
  @ObjectLink item: ChannelItem;
  @Prop isFocused: boolean
  build() {
    Column() {
      Row() {
        Text(this.item.name)
          .fontColor(this.isFocused ? 'rgba(0, 0, 0, 0.86)' : '#dbffffff')
          .height(lpx(98))
          .fontSize(lpx(36))
          .align(Alignment.Center)
          .margin({
            left: lpx(24)
          })
          .focusable(true)

        Row() {
          Radio({ group: 'radioGroup6', value: 'radio' + this.item.id })
            .width(lpx(40))
            .height(lpx(40))
            .margin({ right: lpx(24) })
            .aspectRatio(1)
            .checked(this.item.isSelect)
        }
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .focusable(true)
      .width('550lpx')
      .height('98lpx')
      .backgroundColor(this.isFocused ? '#e6ffffff' : '#33ffffff')
      .border({
        radius: '18lpx',
      })
    }
    .focusable(true)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .width('566lpx')
    .height('114lpx')
    .border({
      radius: '24lpx',
      color: this.isFocused ? '#e6ffffff' : 'transparent',
      width: '2lpx',
    })
  }
}

@Component
struct SoundModeView {
  @ObjectLink item: SoundModeItem;
  @Prop isFocused: boolean
  build() {
    Column() {
      Row() {
        Text(this.item.name)
          .fontColor(this.isFocused ? 'rgba(0, 0, 0, 0.86)' : '#dbffffff')
          .height(lpx(98))
          .fontSize(lpx(36))
          .align(Alignment.Center)
          .margin({
            left: lpx(24)
          })
          .focusable(true)

        Row() {
          Radio({ group: 'radioGroup7', value: 'radio' + this.item.id })
            .width(lpx(40))
            .height(lpx(40))
            .margin({ right: lpx(24) })
            .aspectRatio(1)
            .checked(this.item.isSelect)
        }
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .focusable(true)
      .width('550lpx')
      .height('98lpx')
      .backgroundColor(this.isFocused ? '#e6ffffff' : '#33ffffff')
      .border({
        radius: '18lpx',
      })
    }
    .focusable(true)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .width('566lpx')
    .height('114lpx')
    .border({
      radius: '24lpx',
      color: this.isFocused ? '#e6ffffff' : 'transparent',
      width: '2lpx',
    })
  }
}

@Component
struct CaptionSettingLanguageView {
  @ObjectLink item: CaptionSettingLanguageItem;
  @Prop isFocused: boolean
  build() {
    Column() {
      Row() {
        Text(this.item.name)
          .fontColor(this.isFocused ? 'rgba(0, 0, 0, 0.86)' : '#dbffffff')
          .height(lpx(98))
          .fontSize(lpx(36))
          .align(Alignment.Center)
          .margin({
            left: lpx(24)
          })
          .focusable(true)

        Row() {
          Radio({ group: 'radioGroup8', value: 'radio' + this.item.id })
            .width(lpx(40))
            .height(lpx(40))
            .margin({ right: lpx(24) })
            .aspectRatio(1)
            .checked(this.item.isSelect)
        }
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .focusable(true)
      .width('550lpx')
      .height('98lpx')
      .backgroundColor(this.isFocused ? '#e6ffffff' : '#33ffffff')
      .border({
        radius: '18lpx',
      })
    }
    .focusable(true)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .width('566lpx')
    .height('114lpx')
    .border({
      radius: '24lpx',
      color: this.isFocused ? '#e6ffffff' : 'transparent',
      width: '2lpx',
    })
  }
}
@Component
struct CaptionSettingFirstView {
  @ObjectLink item: CaptionSettingFirstItem;
  @Prop isFocused: boolean
  build() {
    Column() {
      Row() {
        Text(this.item.name)
          .fontColor(this.isFocused ? 'rgba(0, 0, 0, 0.86)' : '#dbffffff')
          .height(lpx(98))
          .fontSize(lpx(36))
          .align(Alignment.Center)
          .margin({
            left: lpx(24)
          })
          .focusable(true)

        Row() {
          Radio({ group: 'radioGroup9', value: 'radio' + this.item.id })
            .width(lpx(40))
            .height(lpx(40))
            .margin({ right: lpx(24) })
            .aspectRatio(1)
            .checked(this.item.isSelect)
        }
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .focusable(true)
      .width('550lpx')
      .height('98lpx')
      .backgroundColor(this.isFocused ? '#e6ffffff' : '#33ffffff')
      .border({
        radius: '18lpx',
      })
    }
    .focusable(true)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .width('566lpx')
    .height('114lpx')
    .border({
      radius: '24lpx',
      color: this.isFocused ? '#e6ffffff' : 'transparent',
      width: '2lpx',
    })
  }
}
@Component
struct CaptionSettingSecondView {
  @ObjectLink item: CaptionSettingSecondItem;
  @Prop isFocused: boolean
  build() {
    Column() {
      Row() {
        Text(this.item.name)
          .fontColor(this.isFocused ? 'rgba(0, 0, 0, 0.86)' : '#dbffffff')
          .height(lpx(98))
          .fontSize(lpx(36))
          .align(Alignment.Center)
          .margin({
            left: lpx(24)
          })
          .focusable(true)

        Row() {
          Radio({ group: 'radioGroup10', value: 'radio' + this.item.id })
            .width(lpx(40))
            .height(lpx(40))
            .margin({ right: lpx(24) })
            .aspectRatio(1)
            .checked(this.item.isSelect)
        }
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .focusable(true)
      .width('550lpx')
      .height('98lpx')
      .backgroundColor(this.isFocused ? '#e6ffffff' : '#33ffffff')
      .border({
        radius: '18lpx',
      })
    }
    .focusable(true)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .width('566lpx')
    .height('114lpx')
    .border({
      radius: '24lpx',
      color: this.isFocused ? '#e6ffffff' : 'transparent',
      width: '2lpx',
    })
  }
}

@Component
export struct ImageSettingIndex {
  private searchManuallyScroller: Scroller = new Scroller();
  private channelSortingScroller: Scroller = new Scroller();
  @State showCaptionSettingLanguage: boolean = true;
  private imageModeScroller: Scroller = new Scroller();
  @State settingListIndex: Array<SettingList> = [];
  @State settingIndex: number = -1;
  @Link settingIndexFirst: boolean;
  @Link settingIndexSecond: boolean;
  @State settingIndexSecondIndex: Array<SettingList> = [];
  @State settingSecondIndex: number = -1;
  @Link aspectRatioPanel: boolean;
  @State aspectRatioList: Array<AspectRatioItem> = [];
  @State aspectRatioIndex: number = -1;
  @Link aspectRatioText: string;
  @Link imageMode: boolean;
  @State imageModeList: Array<ImageModeItem> = [];
  @State imageModeIndex: number = -1;
  @State imageModeText: string = '自动';
  @Link soundSettings: boolean;
  @State soundSettingList: Array<SettingList> = [];
  @State soundSettingIndex: number = -1;

  @Link track: boolean;
  @State trackList: Array<TrackItem> = [];
  @State trackIndex: number = -1;
  @State trackModeText: string = '音轨1';

  @Link audioLanguage: boolean;
  @State audioLanguageList: Array<SettingList> = [];
  @State audioLanguageIndex: number = -1;

  @Link audioLanguageFirst: boolean;
  @State audioLanguageFirstList: Array<AudioLanguageFirstItem> = [];
  @State audioLanguageFirstIndex: number = -1;
  @State audioLanguageFirstText: string = '中文';

  @Link audioLanguageSecond: boolean;
  @State audioLanguageSecondList: Array<AudioLanguageSecondItem> = [];
  @State audioLanguageSecondIndex: number = -1;
  @State audioLanguageSecondText: string = '中文';

  @Link channel: boolean;
  @State channelList: Array<ChannelItem> = [];
  @State channelIndex: number = -1;
  @State channelText: string = '立体声';

  @Link soundMode: boolean;
  @State soundModeList: Array<SoundModeItem> = [];
  @State soundModeIndex: number = -1;
  @State soundModeText: string = '自动';

  @Link captionSettings: boolean;
  @State captionSettingsList: Array<SettingList> = [];
  @State captionSettingsIndex: number = -1;

  @Link captionSettingLanguage: boolean;
  @State captionSettingLanguageList: Array<CaptionSettingLanguageItem> = [];
  @State captionSettingLanguageIndex: number = -1;
  @State captionSettingLanguageText: string = '中文';

  @Link captionSettingFirst: boolean;
  @State captionSettingFirstList: Array<CaptionSettingFirstItem> = [];
  @State captionSettingFirstIndex: number = -1;
  @State captionSettingFirstText: string = '中文';

  @Link captionSettingSecond: boolean;
  @State captionSettingSecondList: Array<CaptionSettingSecondItem> = [];
  @State captionSettingSecondIndex: number = -1;
  @State captionSettingSecondText: string = '中文';


  @Link channelSettings: boolean;
  @State channelSettingsList: Array<SettingList> = [];
  @State channelSettingsIndex: number = -1;

  @Link channelInformation:boolean;

  @State searchManuallyList: Array<SettingList> = [];
  @Link searchManually: boolean;
  @State searchManuallyIndex: number = -1;

  @State channelSortingList: Array<IChannel> = [];
  @Link channelSorting: boolean;
  @State channelSortingIndex: number = 0;
  @Link isEdit: boolean;

  @State deleteMessage: string = '删除后可通过自动搜索重新添加';
  @State deleteTitle: string = '是否删除频道2?';
  @State brightnessValue: number = 100;
  deleteController: CustomDialogController = new CustomDialogController({
    builder: deleteChannel({
      deleteconfirm: this.deleteOnConfirm,
      deletemessage: this.deleteMessage,
      deletetitle: this.deleteTitle,
    }),
    openAnimation: {
      duration: 500
    },
    gridCount: 12,
    alignment: DialogAlignment.Center,
    customStyle: true,
    autoCancel: false
  });
  @State message: string = '搜索电视频道后即可观看电视节目';
  @State title: string = '是否进行自动搜台?';
  controller: CustomDialogController = new CustomDialogController({
    builder: automatedSearch({
      confirm: this.onConfirmSearch,
      message: this.message,
      title: this.title,
    }),
    openAnimation: {
      duration: 500
    },
    gridCount: 12,
    alignment: DialogAlignment.Center,
    customStyle: true,
    autoCancel: false
  });
  deleteOnConfirm() {
    console.log('pppp1');
  }
  onConfirmSearch() {
    console.log('pppp');
    try {
      router.pushUrl({ url: 'pages/SearchPage' }, router.RouterMode.Single);
    } catch (error) {
      const businessError = error as BusinessError;
      LogUtil.warn(`router.pushUrl failed: ${businessError.code}`);
    }
  }
  resetAllStates() {
    this.settingIndexFirst = false;
    this.channelInformation = false;
    this.searchManually = false;
    this.channelSettings = false;
    this.captionSettingSecond = false;
    this.captionSettingFirst = false;
    this.captionSettingLanguage = false;
    this.captionSettings = false;
    this.soundMode = false;
    this.channel = false;
    this.audioLanguageSecond = false;
    this.audioLanguageFirst = false;
    this.audioLanguage = false;
    this.track = false;
    this.soundSettings = false;
    this.imageMode = false;
    this.aspectRatioPanel = false;
    this.settingIndexSecond = false;
    this.channelSorting=false;
  }

  aboutToAppear() {
    this.settingListIndex=[
      {id:1,name:'图像设置'},{id:2,name:'声音设置'},{id:3,name:'字幕设置'},{id:4,name:'频道设置'}
    ]
    this.settingIndexSecondIndex=[
      {id:1,name:'画面比例'},{id:2,name:'屏幕亮度'},{id:3,name:'图像模式'}
    ]
    this.aspectRatioList = [
      new AspectRatioItem(1, '自动'),
      new AspectRatioItem(2, '全屏'),
      new AspectRatioItem(3, '16:9'),
      new AspectRatioItem(4, '4:3')
    ]
    this.imageModeList = [
      new ImageModeItem(1, '自动'),
      new ImageModeItem(2, '标准'),
      new ImageModeItem(3, '电影'),
      new ImageModeItem(4, '体育'),
      new ImageModeItem(5, '鲜艳'),
      new ImageModeItem(6, '照片'),
      new ImageModeItem(7, '游戏'),
      new ImageModeItem(8, '大师原彩')
    ]
    this.soundSettingList=[
      {id:1,name:'音轨'},{id:2,name:'音频语言'},{id:3,name:'声道'},{id:4,name:'音效模式'}
    ]

    this.trackList = [
      new TrackItem(1, '音轨1'),
      new TrackItem(2, '音轨2'),
    ]
    this.audioLanguageList=[
      {id:1,name:'第一音频语言'},{id:2,name:'第二音频语言'}
    ]

    this.audioLanguageFirstList = [
      new AudioLanguageFirstItem(1, '中文'),
      new AudioLanguageFirstItem(2, '英文'),
    ]

    this.audioLanguageSecondList = [
      new AudioLanguageSecondItem(1, '中文'),
      new AudioLanguageSecondItem(2, '英文'),
    ]

    this.channelList = [
      new ChannelItem(1, '立体声'),
      new ChannelItem(2, '左声道'),
      new ChannelItem(3, '右声道'),
    ]

    this.soundModeList = [
      new SoundModeItem(1, '自动'),
      new SoundModeItem(2, '标准'),
      new SoundModeItem(3, '影院'),
      new SoundModeItem(4, '音乐'),
      new SoundModeItem(5, '新闻'),
      new SoundModeItem(6, '自定义'),
    ]

    this.captionSettingsList=[
      {id:1,name:'字幕'},{id:2,name:'第一字幕语言'},{id:3,name:'第二字幕语言'}
    ]

    this.captionSettingLanguageList = [
      new CaptionSettingLanguageItem(1, '中文'),
      new CaptionSettingLanguageItem(2, '英文'),
    ]

    this.captionSettingFirstList = [
      new CaptionSettingFirstItem(1, '中文'),
      new CaptionSettingFirstItem(2, '英文'),
    ]

    this.captionSettingSecondList = [
      new CaptionSettingSecondItem(1, '中文'),
      new CaptionSettingSecondItem(2, '英文'),
    ]

    this.channelSettingsList=[
      {id:1,name:'频道排序'},
      {id:2,name:'频道删除'},
      {id:3,name:'自动搜索'},
      {id:4,name:'手动搜索'},
      {id:5,name:'频道信息'},
    ]

    this.searchManuallyList = [
      { id: 1, name: '51.5 MHz'},
      { id: 2, name: '52.5 MHz'},
      { id: 3, name: '53.5 MHz'},
      { id: 4, name: '54.5 MHz'},
      { id: 5, name: '55.5 MHz'},
      { id: 6, name: '56.5 MHz'},
      { id: 7, name: '57.5 MHz'},
      { id: 8, name: '58.5 MHz'},
      { id: 9, name: '59.5 MHz'},
      { id: 10, name: '60.5 MHz'},
      { id: 11, name: '61.5 MHz'},
      { id: 12, name: '62.5 MHz'},
    ]

    this.channelSortingList = [
      {
        id: 1,
        url: '',
        channelName: 'cctv-1',
        serviceId: 88
      },
      {
        id: 2,
        url: '',
        channelName: 'cctv-2',
        serviceId: 11
      },
      {
        id: 3,
        url: '',
        channelName: 'cctv-3',
        serviceId: 2
      },
      {
        id: 4,
        url: '',
        channelName: 'cctv-4',
        serviceId: 33
      },
      {
        id: 5,
        url: '',
        channelName: 'cctv-5',
        serviceId: 44
      },
      {
        id: 6,
        url: '',
        channelName: 'cctv-6',
        serviceId: 85
      },
      {
        id: 7,
        url: '',
        channelName: 'cctv-7',
        serviceId: 24
      },
      {
        id: 8,
        url: '',
        channelName: 'cctv-8',
        serviceId: 12
      },
      {
        id: 9,
        url: '',
        channelName: 'cctv-9',
        serviceId: 13
      },
      {
        id: 10,
        url: '',
        channelName: 'cctv-10',
        serviceId: 15
      },
      {
        id: 11,
        url: '',
        channelName: 'cctv-12',
        serviceId: 47
      },
      {
        id: 12,
        url: '',
        channelName: 'cctv-54',
        serviceId: 68
      }
    ]
  }
  // 更新选中状态的方法
  updateSelection(selectedId: number) {
    this.aspectRatioList.forEach(item => {
      item.isSelect = (item.id === selectedId);
    });
    this.aspectRatioText = this.aspectRatioList.find(item => item.id === selectedId)?.name || '自动';
  }
  updateImageMode(selectedId: number) {
    this.imageModeList.forEach(item => {
      item.isSelect = (item.id === selectedId);
    });
    this.imageModeText = this.imageModeList.find(item => item.id === selectedId)?.name || '自动';
  }
  updateTrack(selectedId: number){
    this.trackList.forEach(item => {
      item.isSelect = (item.id === selectedId);
    });
    this.trackModeText = this.trackList.find(item => item.id === selectedId)?.name || '音轨1';
  }

  updateAudioLanguageFirst(selectedId: number){
    this.audioLanguageFirstList.forEach(item => {
      item.isSelect = (item.id === selectedId);
    });
    this.audioLanguageFirstText = this.audioLanguageFirstList.find(item => item.id === selectedId)?.name || '中文';
  }

  updateAudioLanguageSecond(selectedId: number){
    this.audioLanguageSecondList.forEach(item => {
      item.isSelect = (item.id === selectedId);
    });
    this.audioLanguageSecondText = this.audioLanguageSecondList.find(item => item.id === selectedId)?.name || '中文';
  }

  updateChannel(selectedId: number){
    this.channelList.forEach(item => {
      item.isSelect = (item.id === selectedId);
    });
    this.channelText = this.channelList.find(item => item.id === selectedId)?.name || '立体声';
  }

  updateSoundMode(selectedId: number){
    this.soundModeList.forEach(item => {
      item.isSelect = (item.id === selectedId);
    });
    this.soundModeText = this.soundModeList.find(item => item.id === selectedId)?.name || '自动';
  }

  updateCaptionSettingLanguage(selectedId: number){
    this.captionSettingLanguageList.forEach(item => {
      item.isSelect = (item.id === selectedId);
    });
    this.captionSettingLanguageText =
      this.captionSettingLanguageList.find(item => item.id === selectedId)?.name || '中文';
  }

  updateCaptionSettingFirst(selectedId: number){
    this.captionSettingFirstList.forEach(item => {
      item.isSelect = (item.id === selectedId);
    });
    this.captionSettingFirstText = this.captionSettingFirstList.find(item => item.id === selectedId)?.name || '中文';
  }

  updateCaptionSettingSecond(selectedId: number){
    this.captionSettingSecondList.forEach(item => {
      item.isSelect = (item.id === selectedId);
    });
    this.captionSettingSecondText = this.captionSettingSecondList.find(item => item.id === selectedId)?.name || '中文';
  }


  build() {
    Column() {
      Column() {
        Text('菜单')
          .height(lpx(75))
          .lineHeight(lpx(75))
          .fontColor(Color.White)
          .fontSize(lpx(64))
          .fontWeight(FontWeight.Medium)
          .textAlign(TextAlign.Start)
          .margin({
            top: lpx(48),
            bottom: lpx(48),
            left: lpx(12)
          })
          .focusable(true)

        List({ space: lpx(24) }) {
          ForEach(this.settingListIndex, (item: SettingList, index: number) => {
            ListItem() {
              Column() {
                Row() {
                  Text(item.name)
                    .fontColor(this.settingIndex == item.id ? 'rgba(0, 0, 0, 0.86)' : '#dbffffff')
                    .height(lpx(98))
                    .fontSize(lpx(36))
                    .align(Alignment.Center)
                    .margin({
                      left: lpx(24)
                    })
                    .focusable(true)

                  Image($r(Ratio.resName('icon_arrow_right')))
                    .fillColor(this.settingIndex == item.id ? 'rgba(0, 0, 0, 0.86)' : '#99ffffff')
                    .width(lpx(24))
                    .height(lpx(48))
                    .objectFit(ImageFit.Fill)
                    .align(Alignment.Center)
                    .margin({ right: lpx(24) })
                    .focusable(true)
                }
                .justifyContent(FlexAlign.SpaceBetween)
                .focusable(true)
                .width('550lpx')
                .height('98lpx')
                .backgroundColor(this.settingIndex == item.id ? '#e6ffffff' : '#33ffffff')
                .border({
                  radius: '18lpx',
                })
              }
              .focusable(true)
              .justifyContent(FlexAlign.Center)
              .alignItems(HorizontalAlign.Center)
              .width('566lpx')
              .height('114lpx')
              .border({
                radius: '24lpx',
                color: this.settingIndex == item.id ? '#e6ffffff' : 'transparent',
                width: '2lpx',
              })
            }
            .focusable(true)
            .height(lpx(114))
            .width(lpx(566))
            .id('settingIndex' + item.id)
            .onFocus(() => {
              this.settingIndex = Number(item.id);
            })
            .onBlur(() => {
              this.settingIndex = -1;
            })
            .onKeyEvent(async (e?: KeyEvent) => {
              if (!e) {
                return;
              }
              if (e.keyCode == KeyCode.KEYCODE_DPAD_UP && e.type == KeyType.Up) {
                if (Number(item.id) > 1) {
                  this.settingIndex--;
                  focusControl.requestFocus(`settingIndex${this.settingIndex.toString()}`);
                }
              }
              if (e.keyCode == KeyCode.KEYCODE_DPAD_DOWN && e.type == KeyType.Up) {
                if (Number(item.id) < this.settingListIndex.length) {
                  this.settingIndex++;
                  focusControl.requestFocus(`settingIndex${this.settingIndex.toString()}`);
                }
              }
              if ((e.keyCode == KeyCode.KEYCODE_DPAD_CENTER || e.keyCode == KeyCode.KEYCODE_ENTER) &&
                e.type == KeyType.Up) {
                this.resetAllStates();
                if (item.name == '图像设置') {
                  this.settingIndexSecond = true;
                  focusControl.requestFocus('settingSecondindex1');
                  //查询画面比例
                  try {
                    displaySetting.getAspect((err, getAspect) => {
                      LogUtil.log(TAG + 'getAspecterr=' + JSON.stringify(err));
                      LogUtil.log(TAG + 'getAspect=' + JSON.stringify(getAspect));
                      if (err) {
                        promptAction.showToast({ message: '查询画面比例接口报错' });
                        this.aspectRatioText = '自动';
                      } else {
                        LogUtil.log(TAG + 'getAspectSuccess=' + JSON.stringify(getAspect));
                        if (getAspect == 5) {
                          this.aspectRatioText = '自动';
                        } else if (getAspect == 3) {
                          this.aspectRatioText = '全屏';
                        } else if (getAspect == 0) {
                          this.aspectRatioText = '16:9';
                        } else if (getAspect == 2) {
                          this.aspectRatioText = '4:3';
                        }
                      }
                    });
                  } catch (error) {
                    promptAction.showToast({ message: '查询画面比例接口报错' });
                    this.aspectRatioText = '自动';
                    LogUtil.log(TAG + 'getAspecterror=' + JSON.stringify(error));
                  }

                } else if (item.name == '声音设置') {
                  this.soundSettings = true;
                  focusControl.requestFocus('Soundsettings1');
                } else if (item.name == '字幕设置') {
                  this.captionSettings = true;
                  focusControl.requestFocus('captionsettings1');
                } else if (item.name == '频道设置') {
                  this.channelSettings = true;
                  focusControl.requestFocus('Channelsettings1');
                }
                e.stopPropagation?.();
              }
              if (e.keyCode == KeyCode.KEYCODE_MENU && e.type == KeyType.Up) {
                e.stopPropagation?.();
              }
            })
          })
        }
        .focusable(true)
        .scrollBar(BarState.Off)
        .width(ConfigData.WH_100_100)
        .layoutWeight(1)
        .margin({
          bottom: lpx(48),
        })
        .alignListItem(ListItemAlign.Start)
      }
      .focusable(true)
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Start)
      .height('100%')
      .visibility(this.settingIndexFirst ? Visibility.Visible : Visibility.None)


      Column() {
        Text('图像设置')
          .height(lpx(75))
          .lineHeight(lpx(75))
          .fontColor(Color.White)
          .fontSize(lpx(64))
          .fontWeight(FontWeight.Medium)
          .textAlign(TextAlign.Start)
          .margin({
            top: lpx(48),
            bottom: lpx(44),
            left: lpx(12)
          })
          .focusable(true)
        Text('DTV')
          .height(lpx(35))
          .fontSize(lpx(30))
          .margin({ left: lpx(12), bottom: lpx(9) })
          .fontColor('rgba(255, 255, 255, 0.6)')


        List({ space: lpx(24) }) {
          ForEach(this.settingIndexSecondIndex, (item: SettingList, index: number) => {
            ListItem() {
              Column() {
                Row() {
                  Text(item.name)
                    .fontColor(this.settingSecondIndex == item.id ? 'rgba(0, 0, 0, 0.86)' : '#dbffffff')
                    .height(lpx(98))
                    .fontSize(lpx(36))
                    .align(Alignment.Center)
                    .margin({
                      left: lpx(24)
                    })
                    .focusable(true)


                  Row(){
                    if(index==0){
                      Text(this.aspectRatioText)
                        .fontSize(lpx(36))
                        .align(Alignment.Center)
                        .fontColor(this.settingSecondIndex == item.id ? '#99000000' : '#dbffffff')
                        .margin({ right: lpx(12) })
                    }else if(index==1){
                      Image($r(Ratio.resName('icon_arrow_left')))
                        .fillColor(this.settingSecondIndex == item.id ? 'rgba(0, 0, 0, 0.86)' : '#99ffffff')
                        .width(lpx(24))
                        .height(lpx(48))
                        .objectFit(ImageFit.Fill)
                        .align(Alignment.Center)
                        .margin({ right: lpx(12) })
                        .focusable(true)
                      Text(this.brightnessValue + '')
                        .fontSize(lpx(36))
                        .align(Alignment.Center)
                        .fontColor(this.settingSecondIndex == item.id ? '#99000000' : '#dbffffff')
                        .margin({ right: lpx(12) })
                    }else if(index==2){
                      Text(this.imageModeText)
                        .fontSize(lpx(36))
                        .align(Alignment.Center)
                        .fontColor(this.settingSecondIndex == item.id ? '#99000000' : '#dbffffff')
                        .margin({ right: lpx(12) })
                    }
                    Image($r(Ratio.resName('icon_arrow_right')))
                      .fillColor(this.settingSecondIndex == item.id ? 'rgba(0, 0, 0, 0.86)' : '#99ffffff')
                      .width(lpx(24))
                      .height(lpx(48))
                      .objectFit(ImageFit.Fill)
                      .align(Alignment.Center)
                      .margin({ right: lpx(24) })
                      .focusable(true)
                  }
                }
                .justifyContent(FlexAlign.SpaceBetween)
                .focusable(true)
                .width('550lpx')
                .height('98lpx')
                .backgroundColor(this.settingSecondIndex == item.id ? '#e6ffffff' : '#33ffffff')
                .border({
                  radius: '18lpx',
                })
              }
              .focusable(true)
              .justifyContent(FlexAlign.Center)
              .alignItems(HorizontalAlign.Center)
              .width('566lpx')
              .height('114lpx')
              .border({
                radius: '24lpx',
                color: this.settingSecondIndex == item.id ? '#e6ffffff' : 'transparent',
                width: '2lpx',
              })
            }
            .focusable(true)
            .height(lpx(114))
            .width(lpx(566))
            .id('settingSecondIndex' + item.id)
            .onFocus(() => {
              this.settingSecondIndex = Number(item.id);
            })
            .onBlur(() => {
              this.settingSecondIndex = -1;
            })
            .onKeyEvent((e?: KeyEvent) => {
              if (!e) {
                return;
              }
              if (e.keyCode == KeyCode.KEYCODE_DPAD_UP && e.type == KeyType.Up) {
                if (Number(item.id) > 1) {
                  this.settingSecondIndex--
                  focusControl.requestFocus(`${'settingSecondIndex' + this.settingSecondIndex.toString()}`)
                }
              }
              if (e.keyCode == KeyCode.KEYCODE_DPAD_DOWN && e.type == KeyType.Up) {
                if (Number(item.id) < this.settingIndexSecondIndex.length) {
                  this.settingSecondIndex++
                  focusControl.requestFocus(`${'settingSecondIndex' + this.settingSecondIndex.toString()}`)
                }
              }
              if ((e.keyCode == KeyCode.KEYCODE_DPAD_CENTER || e.keyCode == KeyCode.KEYCODE_ENTER) &&
                e.type == KeyType.Up) {
                if (item.name == '画面比例') {
                  this.resetAllStates();
                  this.aspectRatioPanel = true;
                  focusControl.requestFocus(
                    'aspectRatio' + (this.aspectRatioList.find(item => item.name == this.aspectRatioText )?.id || '1')
                  );
                  this.updateSelection(
                    this.aspectRatioList.find(item => item.name == this.aspectRatioText )?.id || 1
                  );
                }else if(item.name == '图像模式'){
                  this.resetAllStates();
                  this.imageMode=true;
                  this.imageModeScroller.scrollToIndex(
                    Number(this.imageModeList.find(item => item.name == this.imageModeText )?.id) - 1 || 0
                  );
                  focusControl.requestFocus(
                    'imageMode' + (this.imageModeList.find(item => item.name == this.imageModeText )?.id || '1')
                  );
                  this.updateImageMode(
                    this.imageModeList.find(item => item.name == this.imageModeText )?.id || 1
                  );
                }
                e.stopPropagation?.();
              }
              if (e.keyCode == KeyCode.KEYCODE_DPAD_LEFT&& e.type == KeyType.Up) {
                if(item.name == '屏幕亮度') {
                  if(this.brightnessValue==0){
                    return
                  }
                  this.brightnessValue=this.brightnessValue-1;
                }
                e.stopPropagation?.();
              }
              if (e.keyCode == KeyCode.KEYCODE_DPAD_RIGHT&& e.type == KeyType.Up) {
                if(item.name == '屏幕亮度') {
                  if(this.brightnessValue==100){
                    return
                  }
                  this.brightnessValue=this.brightnessValue+1;
                }
                e.stopPropagation?.();
              }
              if (e.keyCode == KeyCode.KEYCODE_MENU&& e.type == KeyType.Up) {
                e.stopPropagation?.();
              }
            })
          })
        }
        .focusable(true)
        .scrollBar(BarState.Off)
        .width(ConfigData.WH_100_100)
        .layoutWeight(1)
        .margin({
          bottom: lpx(48),
        })
        .alignListItem(ListItemAlign.Start)
      }
      .focusable(true)
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Start)
      .height('100%')
      .visibility(this.settingIndexSecond ? Visibility.Visible : Visibility.None)

      //画面比例
      Column() {
        Text('画面比例')
          .height(lpx(75))
          .lineHeight(lpx(75))
          .fontColor(Color.White)
          .fontSize(lpx(64))
          .fontWeight(FontWeight.Medium)
          .textAlign(TextAlign.Start)
          .margin({
            top: lpx(48),
            bottom: lpx(44),
            left: lpx(12)
          })
          .focusable(true)
        Text('DTV').height(lpx(35)) .fontSize(lpx(30)).margin({ left: lpx(12), bottom: lpx(9) }).fontColor('rgba(255, 255, 255, 0.6)')


        List({ space: lpx(24) }) {
          ForEach(this.aspectRatioList, (item:AspectRatioItem, index: number) => {
            ListItem() {
              AspectRatioItemView({ item: item, isFocused: this.aspectRatioIndex == item.id })
            }
            .focusable(true)
            .height(lpx(114))
            .width(lpx(566))
            .id('aspectRatio' + item.id)
            .onFocus(() => {
              this.aspectRatioIndex = Number(item.id)
            })
            .onBlur(() => {
              if (this.aspectRatioIndex === item.id) {
                this.aspectRatioIndex = -1;
              }
            })
            .onKeyEvent(async (e?: KeyEvent) => {
              if (!e) {
                return;
              }
              if (e.keyCode == KeyCode.KEYCODE_DPAD_UP && e.type == KeyType.Up) {
                if (Number(item.id) > 1) {
                  this.aspectRatioIndex = item.id - 1;
                  focusControl.requestFocus(`${'aspectRatio' + this.aspectRatioIndex.toString()}`)
                }
              }
              if (e.keyCode == KeyCode.KEYCODE_DPAD_DOWN && e.type == KeyType.Up) {
                if (Number(item.id) < this.aspectRatioList.length) {
                  this.aspectRatioIndex = item.id + 1;
                  focusControl.requestFocus(`${'aspectRatio' + this.aspectRatioIndex.toString()}`)
                }
              }
              if ((e.keyCode == KeyCode.KEYCODE_DPAD_CENTER || e.keyCode == KeyCode.KEYCODE_ENTER) &&
                e.type == KeyType.Up) {
                this.updateSelection(item.id);
                console.log('已选择:', item.name);
                try {
                  displaySetting.setAspect(item.id==1? 5:item.id==2?3:item.id==3?0:2,(err,setAspect)=>{
                    if(err){
                      promptAction.showToast({ message: '设置画面比例接口报错' });
                    }else {
                      if(!setAspect){
                        promptAction.showToast({ message: '设置画面比例失败' });
                      }
                    }
                  })
                } catch (error) {
                  promptAction.showToast({ message: '设置画面比例接口报错' });
                  LogUtil.log(TAG + 'setAspecterror=' + JSON.stringify(error));
                }
                e.stopPropagation?.();
              }
              if (e.keyCode == KeyCode.KEYCODE_MENU&& e.type == KeyType.Up) {
                e.stopPropagation?.();
              }
            })
          })
        }
        .focusable(true)
        .scrollBar(BarState.Off)
        .width(ConfigData.WH_100_100)
        .layoutWeight(1)
        .margin({
          bottom: lpx(48),
        })
        .alignListItem(ListItemAlign.Start)
      }
      .focusable(true)
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Start)
      .height('100%')
      .visibility(this.aspectRatioPanel ? Visibility.Visible : Visibility.None)

      //图像模式
      Column() {
        Text('图像设置')
          .height(lpx(75))
          .lineHeight(lpx(75))
          .fontColor(Color.White)
          .fontSize(lpx(64))
          .fontWeight(FontWeight.Medium)
          .textAlign(TextAlign.Start)
          .margin({
            top: lpx(48),
            bottom: lpx(44),
            left: lpx(12)
          })
          .focusable(true)
        Text('DTV').height(lpx(35)) .fontSize(lpx(30)).margin({ left: lpx(12), bottom: lpx(9) }).fontColor('rgba(255, 255, 255, 0.6)')


        List({ space: lpx(24),scroller: this.imageModeScroller  }) {
          ForEach(this.imageModeList, (item:ImageModeItem, index: number) => {
            ListItem() {
              ImageModeItemView({ item: item, isFocused: this.imageModeIndex == item.id })
            }
            .focusable(true)
            .height(lpx(114))
            .width(lpx(566))
            .id('imageMode' + item.id)
            .onFocus(() => {
              this.imageModeIndex = Number(item.id)
            })
            .onBlur(() => {
              if (this.imageModeIndex === item.id) {
                this.imageModeIndex = -1;
              }
            })
            .onKeyEvent(async (e?: KeyEvent) => {
              if (!e) {
                return;
              }
              if (e.keyCode == KeyCode.KEYCODE_DPAD_UP && e.type == KeyType.Up) {
                if (Number(item.id) > 1) {
                  this.imageModeIndex = item.id - 1;
                  this.imageModeScroller.scrollToIndex(Number(this.imageModeIndex) - 1);
                  focusControl.requestFocus(`${'imageMode' + this.imageModeIndex.toString()}`)
                }
              }
              if (e.keyCode == KeyCode.KEYCODE_DPAD_DOWN && e.type == KeyType.Up) {
                if (Number(item.id) < this.imageModeList.length) {
                  this.imageModeIndex = item.id + 1;
                  this.imageModeScroller.scrollToIndex(Number(this.imageModeIndex) - 1);
                  focusControl.requestFocus(`${'imageMode' + this.imageModeIndex.toString()}`)
                }
              }
              if ((e.keyCode == KeyCode.KEYCODE_DPAD_CENTER || e.keyCode == KeyCode.KEYCODE_ENTER) &&
                e.type == KeyType.Up) {
                this.updateImageMode(item.id);
                console.log('已选择:', item.name);
                e.stopPropagation?.();
              }
              if (e.keyCode == KeyCode.KEYCODE_MENU&& e.type == KeyType.Up) {
                e.stopPropagation?.();
              }
            })
          })
        }
        .focusable(true)
        .scrollBar(BarState.Off)
        .width(ConfigData.WH_100_100)
        .layoutWeight(1)
        .margin({
          bottom: lpx(48),
        })
        .alignListItem(ListItemAlign.Start)
      }
      .focusable(true)
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Start)
      .height('100%')
      .visibility(this.imageMode ? Visibility.Visible : Visibility.None)

      //声音设置
      Column() {
        Text('声音设置')
          .height(lpx(75))
          .lineHeight(lpx(75))
          .fontColor(Color.White)
          .fontSize(lpx(64))
          .fontWeight(FontWeight.Medium)
          .textAlign(TextAlign.Start)
          .margin({
            top: lpx(48),
            bottom: lpx(48),
            left: lpx(12)
          })
          .focusable(true)

        List({ space: lpx(24) }) {
          ForEach(this.soundSettingList, (item: SettingList, index: number) => {
            ListItem() {
              Column() {
                Row() {
                  Text(item.name)
                    .fontColor(this.soundSettingIndex == item.id ? 'rgba(0, 0, 0, 0.86)' : '#dbffffff')
                    .height(lpx(98))
                    .fontSize(lpx(36))
                    .align(Alignment.Center)
                    .margin({
                      left: lpx(24)
                    })
                    .focusable(true)
                  Row(){
                    if(index==0){
                      Text(this.trackModeText).fontSize(lpx(36)).align(Alignment.Center).fontColor(this.soundSettingIndex == item.id ?'#99000000':'#dbffffff').margin({ right: lpx(12) })
                    }else if(index==1){
                      Text('' ).fontSize(lpx(36)).align(Alignment.Center).fontColor(this.soundSettingIndex == item.id ?'#99000000':'#dbffffff').margin({ right: lpx(12) })
                    }else if(index==2){
                      Text(this.channelText).fontSize(lpx(36)).align(Alignment.Center).fontColor(this.soundSettingIndex == item.id ?'#99000000':'#dbffffff').margin({ right: lpx(12) })
                    }else if(index==3){
                      Text(this.soundModeText).fontSize(lpx(36)).align(Alignment.Center).fontColor(this.soundSettingIndex == item.id ?'#99000000':'#dbffffff').margin({ right: lpx(12) })
                    }
                    Image($r(Ratio.resName('icon_arrow_right')))
                      .fillColor(this.soundSettingIndex == item.id ? 'rgba(0, 0, 0, 0.86)' : '#99ffffff')
                      .width(lpx(24))
                      .height(lpx(48))
                      .objectFit(ImageFit.Fill)
                      .align(Alignment.Center)
                      .margin({ right: lpx(24) })
                      .focusable(true)
                  }
                }
                .justifyContent(FlexAlign.SpaceBetween)
                .focusable(true)
                .width('550lpx')
                .height('98lpx')
                .backgroundColor(this.soundSettingIndex == item.id ? '#e6ffffff' : '#33ffffff')
                .border({
                  radius: '18lpx',
                })
              }
              .focusable(true)
              .justifyContent(FlexAlign.Center)
              .alignItems(HorizontalAlign.Center)
              .width('566lpx')
              .height('114lpx')
              .border({
                radius: '24lpx',
                color: this.soundSettingIndex == item.id ? '#e6ffffff' : 'transparent',
                width: '2lpx',
              })
            }
            .focusable(true)
            .height(lpx(114))
            .width(lpx(566))
            .id('soundSettings' + item.id)
            .onFocus(() => {
              this.soundSettingIndex = Number(item.id);
            })
            .onBlur(() => {
              this.soundSettingIndex = -1;
            })
            .onKeyEvent((e?: KeyEvent) => {
              if (!e) {
                return;
              }
              if (e.keyCode == KeyCode.KEYCODE_DPAD_UP && e.type == KeyType.Up) {
                if (Number(item.id) > 1) {
                  this.soundSettingIndex--
                  focusControl.requestFocus(`${'soundSettings' + this.soundSettingIndex.toString()}`)
                }
              }
              if (e.keyCode == KeyCode.KEYCODE_DPAD_DOWN && e.type == KeyType.Up) {
                if (Number(item.id) < this.soundSettingList.length) {
                  this.soundSettingIndex++
                  focusControl.requestFocus(`${'soundSettings' + this.soundSettingIndex.toString()}`)
                }
              }
              if ((e.keyCode == KeyCode.KEYCODE_DPAD_CENTER || e.keyCode == KeyCode.KEYCODE_ENTER) &&
                e.type == KeyType.Up) {
                this.resetAllStates();
                if (item.name == '音轨') {
                  //显示音轨界面
                  this.track=true;
                  focusControl.requestFocus('track'+ this.trackList.find(item => item.name ==this.trackModeText )?.id || '1');
                  this.updateTrack(this.trackList.find(item => item.name ==this.trackModeText )?.id || 1);
                }else if(item.name =='音频语言'){
                  //显示音频语言界面
                  this.audioLanguage=true;
                  focusControl.requestFocus('Audiolanguage1')
                }else if(item.name =='声道'){
                  //显示声道界面
                  this.channel=true;
                  focusControl.requestFocus('channel'+ this.channelList.find(item => item.name ==this.channelText )?.id || '1');
                  this.updateChannel(this.channelList.find(item => item.name ==this.channelText )?.id || 1);
                }else if(item.name =='音效模式'){
                  this.soundMode=true;
                  focusControl.requestFocus('soundMode'+ this.soundModeList.find(item => item.name ==this.soundModeText )?.id || '1');
                  this.updateSoundMode(this.soundModeList.find(item => item.name ==this.soundModeText )?.id || 1);
                }
                e.stopPropagation?.();
              }
              if (e.keyCode == KeyCode.KEYCODE_MENU&& e.type == KeyType.Up) {
                e.stopPropagation?.();
              }
            })
          })
        }
        .focusable(true)
        .scrollBar(BarState.Off)
        .width(ConfigData.WH_100_100)
        .layoutWeight(1)
        .margin({
          bottom: lpx(48),
        })
        .alignListItem(ListItemAlign.Start)
      }
      .focusable(true)
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Start)
      .height('100%')
      .visibility(this.soundSettings ? Visibility.Visible : Visibility.None)

      //音轨界面
      Column() {
        Text('音轨')
          .height(lpx(75))
          .lineHeight(lpx(75))
          .fontColor(Color.White)
          .fontSize(lpx(64))
          .fontWeight(FontWeight.Medium)
          .textAlign(TextAlign.Start)
          .margin({
            top: lpx(48),
            bottom: lpx(48),
            left: lpx(12)
          })
          .focusable(true)


        List({ space: lpx(24) }) {
          ForEach(this.trackList, (item:TrackItem, index: number) => {
            ListItem() {
              TrackListView({ item: item, isFocused: this.trackIndex == item.id })
            }
            .focusable(true)
            .height(lpx(114))
            .width(lpx(566))
            .id('track' + item.id)
            .onFocus(() => {
              this.trackIndex = Number(item.id)
            })
            .onBlur(() => {
              if (this.trackIndex === item.id) {
                this.trackIndex = -1;
              }
            })
            .onKeyEvent((e?: KeyEvent) => {
              if (!e) {
                return;
              }
              if (e.keyCode == KeyCode.KEYCODE_DPAD_UP && e.type == KeyType.Up) {
                if (Number(item.id) > 1) {
                  this.trackIndex = item.id - 1;
                  focusControl.requestFocus(`${'track' + this.trackIndex.toString()}`)
                }
              }
              if (e.keyCode == KeyCode.KEYCODE_DPAD_DOWN && e.type == KeyType.Up) {
                if (Number(item.id) < this.trackList.length) {
                  this.trackIndex = item.id + 1;
                  focusControl.requestFocus(`${'track' + this.trackIndex.toString()}`)
                }
              }
              if ((e.keyCode == KeyCode.KEYCODE_DPAD_CENTER || e.keyCode == KeyCode.KEYCODE_ENTER) &&
                e.type == KeyType.Up) {
                this.updateTrack(item.id);
                console.log('已选择:', item.name);
                e.stopPropagation?.();
              }
              if (e.keyCode == KeyCode.KEYCODE_MENU&& e.type == KeyType.Up) {
                e.stopPropagation?.();
              }
            })
          })
        }
        .focusable(true)
        .scrollBar(BarState.Off)
        .width(ConfigData.WH_100_100)
        .layoutWeight(1)
        .margin({
          bottom: lpx(48),
        })
        .alignListItem(ListItemAlign.Start)
      }
      .focusable(true)
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Start)
      .height('100%')
      .visibility(this.track ? Visibility.Visible : Visibility.None)

      //音频语言
      Column() {
        Text('音频语言')
          .height(lpx(75))
          .lineHeight(lpx(75))
          .fontColor(Color.White)
          .fontSize(lpx(64))
          .fontWeight(FontWeight.Medium)
          .textAlign(TextAlign.Start)
          .margin({
            top: lpx(48),
            bottom: lpx(48),
            left: lpx(12)
          })
          .focusable(true)

        List({ space: lpx(24) }) {
          ForEach(this.audioLanguageList, (item: SettingList, index: number) => {
            ListItem() {
              Column() {
                Row() {
                  Text(item.name)
                    .fontColor(this.audioLanguageIndex == item.id ? 'rgba(0, 0, 0, 0.86)' : '#dbffffff')
                    .height(lpx(98))
                    .fontSize(lpx(36))
                    .align(Alignment.Center)
                    .margin({
                      left: lpx(24)
                    })
                    .focusable(true)
                  Row(){
                    if(index==0){
                      Text(this.audioLanguageFirstText)
                        .fontSize(lpx(36))
                        .align(Alignment.Center)
                        .fontColor(this.audioLanguageIndex == item.id ? '#99000000' : '#dbffffff')
                        .margin({ right: lpx(12) })
                    }else if(index==1){
                      Text(this.audioLanguageSecondText)
                        .fontSize(lpx(36))
                        .align(Alignment.Center)
                        .fontColor(this.audioLanguageIndex == item.id ? '#99000000' : '#dbffffff')
                        .margin({ right: lpx(12) })
                    }
                    Image($r(Ratio.resName('icon_arrow_right')))
                      .fillColor(this.audioLanguageIndex == item.id ? 'rgba(0, 0, 0, 0.86)' : '#99ffffff')
                      .width(lpx(24))
                      .height(lpx(48))
                      .objectFit(ImageFit.Fill)
                      .align(Alignment.Center)
                      .margin({ right: lpx(24) })
                      .focusable(true)
                  }
                }
                .justifyContent(FlexAlign.SpaceBetween)
                .focusable(true)
                .width('550lpx')
                .height('98lpx')
                .backgroundColor(this.audioLanguageIndex == item.id ? '#e6ffffff' : '#33ffffff')
                .border({
                  radius: '18lpx',
                })
              }
              .focusable(true)
              .justifyContent(FlexAlign.Center)
              .alignItems(HorizontalAlign.Center)
              .width('566lpx')
              .height('114lpx')
              .border({
                radius: '24lpx',
                color: this.audioLanguageIndex == item.id ? '#e6ffffff' : 'transparent',
                width: '2lpx',
              })
            }
            .focusable(true)
            .height(lpx(114))
            .width(lpx(566))
            .id('audioLanguage' + item.id)
            .onFocus(() => {
              this.audioLanguageIndex = Number(item.id);
            })
            .onBlur(() => {
              this.audioLanguageIndex = -1;
            })
            .onKeyEvent((e?: KeyEvent) => {
              if (!e) {
                return;
              }
              if (e.keyCode == KeyCode.KEYCODE_DPAD_UP && e.type == KeyType.Up) {
                if (Number(item.id) > 1) {
                  this.audioLanguageIndex--
                  focusControl.requestFocus(`${'audioLanguage' + this.audioLanguageIndex.toString()}`)
                }
              }
              if (e.keyCode == KeyCode.KEYCODE_DPAD_DOWN && e.type == KeyType.Up) {
                if (Number(item.id) < this.audioLanguageList.length) {
                  this.audioLanguageIndex++
                  focusControl.requestFocus(`${'audioLanguage' + this.audioLanguageIndex.toString()}`)
                }
              }
              if ((e.keyCode == KeyCode.KEYCODE_DPAD_CENTER || e.keyCode == KeyCode.KEYCODE_ENTER) &&
                e.type == KeyType.Up) {
                this.resetAllStates();
                if (item.name == '第一音频语言') {
                  //显示音轨界面
                  this.audioLanguageFirst=true;
                  focusControl.requestFocus(
                    'audioLanguageFirst' +
                      (this.audioLanguageFirstList.find(item => item.name == this.audioLanguageFirstText)?.id || '1')
                  );
                  this.updateAudioLanguageFirst(
                    this.audioLanguageFirstList.find(item => item.name == this.audioLanguageFirstText)?.id || 1
                  );
                }else if(item.name == '第二音频语言'){
                  //显示第二音频语言界面
                  this.audioLanguageSecond=true;
                  focusControl.requestFocus(
                    'audioLanguageSecond' +
                      (this.audioLanguageSecondList.find(item => item.name == this.audioLanguageSecondText)?.id || '1')
                  );
                  this.updateAudioLanguageSecond(
                    this.audioLanguageSecondList.find(item => item.name == this.audioLanguageSecondText)?.id || 1
                  );
                }
                e.stopPropagation?.();
              }
              if (e.keyCode == KeyCode.KEYCODE_MENU&& e.type == KeyType.Up) {
                e.stopPropagation?.();
              }
            })
          })
        }
        .focusable(true)
        .scrollBar(BarState.Off)
        .width(ConfigData.WH_100_100)
        .layoutWeight(1)
        .margin({
          bottom: lpx(48),
        })
        .alignListItem(ListItemAlign.Start)
      }
      .focusable(true)
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Start)
      .height('100%')
      .visibility(this.audioLanguage ? Visibility.Visible : Visibility.None)

      //第一音频语言
      Column() {
        Text('第一音频语言')
          .height(lpx(75))
          .lineHeight(lpx(75))
          .fontColor(Color.White)
          .fontSize(lpx(64))
          .fontWeight(FontWeight.Medium)
          .textAlign(TextAlign.Start)
          .margin({
            top: lpx(48),
            bottom: lpx(48),
            left: lpx(12)
          })
          .focusable(true)


        List({ space: lpx(24) }) {
          ForEach(this.audioLanguageFirstList, (item:AudioLanguageFirstItem, index: number) => {
            ListItem() {
              AudioLanguageFirstView({ item: item, isFocused: this.audioLanguageFirstIndex == item.id })
            }
            .focusable(true)
            .height(lpx(114))
            .width(lpx(566))
            .id('audioLanguageFirst' + item.id)
            .onFocus(() => {
              this.audioLanguageFirstIndex = Number(item.id)
            })
            .onBlur(() => {
              if (this.audioLanguageFirstIndex === item.id) {
                this.audioLanguageFirstIndex = -1;
              }
            })
            .onKeyEvent((e?: KeyEvent) => {
              if (!e) {
                return;
              }
              if (e.keyCode == KeyCode.KEYCODE_DPAD_UP && e.type == KeyType.Up) {
                if (Number(item.id) > 1) {
                  this.audioLanguageFirstIndex = item.id - 1;
                  focusControl.requestFocus(`${'audioLanguageFirst' + this.audioLanguageFirstIndex.toString()}`)
                }
              }
              if (e.keyCode == KeyCode.KEYCODE_DPAD_DOWN && e.type == KeyType.Up) {
                if (Number(item.id) < this.audioLanguageFirstList.length) {
                  this.audioLanguageFirstIndex = item.id + 1;
                  focusControl.requestFocus(`${'audioLanguageFirst' + this.audioLanguageFirstIndex.toString()}`)
                }
              }
              if ((e.keyCode == KeyCode.KEYCODE_DPAD_CENTER || e.keyCode == KeyCode.KEYCODE_ENTER) &&
                e.type == KeyType.Up) {
                this.updateAudioLanguageFirst(item.id);
                console.log('已选择:', item.name);
                e.stopPropagation?.();
              }
              if (e.keyCode == KeyCode.KEYCODE_MENU&& e.type == KeyType.Up) {
                e.stopPropagation?.();
              }
            })
          })
        }
        .focusable(true)
        .scrollBar(BarState.Off)
        .width(ConfigData.WH_100_100)
        .layoutWeight(1)
        .margin({
          bottom: lpx(48),
        })
        .alignListItem(ListItemAlign.Start)
      }
      .focusable(true)
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Start)
      .height('100%')
      .visibility(this.audioLanguageFirst ? Visibility.Visible : Visibility.None)
      //第二音频语言
      Column() {
        Text('第二音频语言')
          .height(lpx(75))
          .lineHeight(lpx(75))
          .fontColor(Color.White)
          .fontSize(lpx(64))
          .fontWeight(FontWeight.Medium)
          .textAlign(TextAlign.Start)
          .margin({
            top: lpx(48),
            bottom: lpx(48),
            left: lpx(12)
          })
          .focusable(true)


        List({ space: lpx(24) }) {
          ForEach(this.audioLanguageSecondList, (item:AudioLanguageSecondItem, index: number) => {
            ListItem() {
              AudioLanguageSecondView({ item: item, isFocused: this.audioLanguageSecondIndex == item.id })
            }
            .focusable(true)
            .height(lpx(114))
            .width(lpx(566))
            .id('audioLanguageSecond' + item.id)
            .onFocus(() => {
              this.audioLanguageSecondIndex = Number(item.id)
            })
            .onBlur(() => {
              if (this.audioLanguageSecondIndex === item.id) {
                this.audioLanguageSecondIndex = -1;
              }
            })
            .onKeyEvent((e?: KeyEvent) => {
              if (!e) {
                return;
              }
              if (e.keyCode == KeyCode.KEYCODE_DPAD_UP && e.type == KeyType.Up) {
                if (Number(item.id) > 1) {
                  this.audioLanguageSecondIndex = item.id - 1;
                  focusControl.requestFocus(`${'audioLanguageSecond' + this.audioLanguageSecondIndex.toString()}`)
                }
              }
              if (e.keyCode == KeyCode.KEYCODE_DPAD_DOWN && e.type == KeyType.Up) {
                if (Number(item.id) < this.audioLanguageSecondList.length) {
                  this.audioLanguageSecondIndex = item.id + 1;
                  focusControl.requestFocus(`${'audioLanguageSecond' + this.audioLanguageSecondIndex.toString()}`)
                }
              }
              if ((e.keyCode == KeyCode.KEYCODE_DPAD_CENTER || e.keyCode == KeyCode.KEYCODE_ENTER) &&
                e.type == KeyType.Up) {
                this.updateAudioLanguageSecond(item.id);
                console.log('已选择:', item.name);
                e.stopPropagation?.();
              }
              if (e.keyCode == KeyCode.KEYCODE_MENU&& e.type == KeyType.Up) {
                e.stopPropagation?.();
              }
            })
          })
        }
        .focusable(true)
        .scrollBar(BarState.Off)
        .width(ConfigData.WH_100_100)
        .layoutWeight(1)
        .margin({
          bottom: lpx(48),
        })
        .alignListItem(ListItemAlign.Start)
      }
      .focusable(true)
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Start)
      .height('100%')
      .visibility(this.audioLanguageSecond ? Visibility.Visible : Visibility.None)
      //声道
      Column() {
        Text('声道')
          .height(lpx(75))
          .lineHeight(lpx(75))
          .fontColor(Color.White)
          .fontSize(lpx(64))
          .fontWeight(FontWeight.Medium)
          .textAlign(TextAlign.Start)
          .margin({
            top: lpx(48),
            bottom: lpx(48),
            left: lpx(12)
          })
          .focusable(true)


        List({ space: lpx(24) }) {
          ForEach(this.channelList, (item:ChannelItem, index: number) => {
            ListItem() {
              ChannelView({ item: item, isFocused: this.channelIndex == item.id })
            }
            .focusable(true)
            .height(lpx(114))
            .width(lpx(566))
            .id('channel' + item.id)
            .onFocus(() => {
              this.channelIndex = Number(item.id)
            })
            .onBlur(() => {
              if (this.channelIndex === item.id) {
                this.channelIndex = -1;
              }
            })
            .onKeyEvent((e?: KeyEvent) => {
              if (!e) {
                return;
              }
              if (e.keyCode == KeyCode.KEYCODE_DPAD_UP && e.type == KeyType.Up) {
                if (Number(item.id) > 1) {
                  this.channelIndex = item.id - 1;
                  focusControl.requestFocus(`${'channel' + this.channelIndex.toString()}`)
                }
              }
              if (e.keyCode == KeyCode.KEYCODE_DPAD_DOWN && e.type == KeyType.Up) {
                if (Number(item.id) < this.channelList.length) {
                  this.channelIndex = item.id + 1;
                  focusControl.requestFocus(`${'channel' + this.channelIndex.toString()}`)
                }
              }
              if ((e.keyCode == KeyCode.KEYCODE_DPAD_CENTER || e.keyCode == KeyCode.KEYCODE_ENTER) &&
                e.type == KeyType.Up) {
                this.updateChannel(item.id);
                console.log('已选择:', item.name);
                e.stopPropagation?.();
              }
              if (e.keyCode == KeyCode.KEYCODE_MENU&& e.type == KeyType.Up) {
                e.stopPropagation?.();
              }
            })
          })
        }
        .focusable(true)
        .scrollBar(BarState.Off)
        .width(ConfigData.WH_100_100)
        .layoutWeight(1)
        .margin({
          bottom: lpx(48),
        })
        .alignListItem(ListItemAlign.Start)
      }
      .focusable(true)
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Start)
      .height('100%')
      .visibility(this.channel ? Visibility.Visible : Visibility.None)
      //音效模式
      Column() {
        Text('音效模式')
          .height(lpx(75))
          .lineHeight(lpx(75))
          .fontColor(Color.White)
          .fontSize(lpx(64))
          .fontWeight(FontWeight.Medium)
          .textAlign(TextAlign.Start)
          .margin({
            top: lpx(48),
            bottom: lpx(48),
            left: lpx(12)
          })
          .focusable(true)
        List({ space: lpx(24) }) {
          ForEach(this.soundModeList, (item:SoundModeItem, index: number) => {
            ListItem() {
              SoundModeView({ item: item, isFocused: this.soundModeIndex == item.id })
            }
            .focusable(true)
            .height(lpx(114))
            .width(lpx(566))
            .id('soundMode' + item.id)
            .onFocus(() => {
              this.soundModeIndex = Number(item.id)
            })
            .onBlur(() => {
              if (this.soundModeIndex === item.id) {
                this.soundModeIndex = -1;
              }
            })
            .onKeyEvent(async (e?: KeyEvent) => {
              if (!e) {
                return;
              }
              if (e.keyCode == KeyCode.KEYCODE_DPAD_UP && e.type == KeyType.Up) {
                if (Number(item.id) > 1) {
                  this.soundModeIndex = item.id - 1;
                  focusControl.requestFocus(`${'soundMode' + this.soundModeIndex.toString()}`)
                }
              }
              if (e.keyCode == KeyCode.KEYCODE_DPAD_DOWN && e.type == KeyType.Up) {
                if (Number(item.id) < this.soundModeList.length) {
                  this.soundModeIndex = item.id + 1;
                  focusControl.requestFocus(`${'soundMode' + this.soundModeIndex.toString()}`)
                }
              }
              if ((e.keyCode == KeyCode.KEYCODE_DPAD_CENTER || e.keyCode == KeyCode.KEYCODE_ENTER) &&
                e.type == KeyType.Up) {
                this.updateSoundMode(item.id);
                console.log('已选择:', item.name);
                e.stopPropagation?.();
              }
              if (e.keyCode == KeyCode.KEYCODE_MENU&& e.type == KeyType.Up) {
                e.stopPropagation?.();
              }
            })
          })
        }
        .focusable(true)
        .scrollBar(BarState.Off)
        .width(ConfigData.WH_100_100)
        .layoutWeight(1)
        .margin({
          bottom: lpx(48),
        })
        .alignListItem(ListItemAlign.Start)
      }
      .focusable(true)
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Start)
      .height('100%')
      .visibility(this.soundMode ? Visibility.Visible : Visibility.None)
      //字幕
      Column() {
        Text('字幕设置')
          .height(lpx(75))
          .lineHeight(lpx(75))
          .fontColor(Color.White)
          .fontSize(lpx(64))
          .fontWeight(FontWeight.Medium)
          .textAlign(TextAlign.Start)
          .margin({
            top: lpx(48),
            bottom: lpx(48),
            left: lpx(12)
          })
          .focusable(true)

        List({ space: lpx(24) }) {
          ForEach(this.captionSettingsList, (item: SettingList, index: number) => {
            ListItem() {
              Column() {
                Row() {
                  Text(item.name)
                    .fontColor(this.captionSettingsIndex == item.id ? 'rgba(0, 0, 0, 0.86)' : '#dbffffff')
                    .height(lpx(98))
                    .fontSize(lpx(36))
                    .align(Alignment.Center)
                    .margin({
                      left: lpx(24)
                    })
                    .focusable(true)
                  Row(){
                    if(index==0){
                      Text(this.showCaptionSettingLanguage ? this.captionSettingLanguageText : '')
                        .fontSize(lpx(36))
                        .align(Alignment.Center)
                        .fontColor(this.captionSettingsIndex == item.id ? '#99000000' : '#dbffffff')
                        .margin({ right: lpx(12) })
                    }else if(index==1){
                      Text(this.captionSettingFirstText)
                        .fontSize(lpx(36))
                        .align(Alignment.Center)
                        .fontColor(this.captionSettingsIndex == item.id ? '#99000000' : '#dbffffff')
                        .margin({ right: lpx(12) })
                    }else if(index==2){
                      Text(this.captionSettingSecondText)
                        .fontSize(lpx(36))
                        .align(Alignment.Center)
                        .fontColor(this.captionSettingsIndex == item.id ? '#99000000' : '#dbffffff')
                        .margin({ right: lpx(12) })
                    }
                    Image($r(Ratio.resName('icon_arrow_right')))
                      .fillColor(this.captionSettingsIndex == item.id ? 'rgba(0, 0, 0, 0.86)' : '#99ffffff')
                      .width(lpx(24))
                      .height(lpx(48))
                      .objectFit(ImageFit.Fill)
                      .align(Alignment.Center)
                      .margin({ right: lpx(24) })
                      .focusable(true)
                  }
                }
                .justifyContent(FlexAlign.SpaceBetween)
                .focusable(true)
                .width('550lpx')
                .height('98lpx')
                .backgroundColor(this.captionSettingsIndex == item.id ? '#e6ffffff' : '#33ffffff')
                .border({
                  radius: '18lpx',
                })
              }
              .focusable(true)
              .justifyContent(FlexAlign.Center)
              .alignItems(HorizontalAlign.Center)
              .width('566lpx')
              .height('114lpx')
              .border({
                radius: '24lpx',
                color: this.captionSettingsIndex == item.id ? '#e6ffffff' : 'transparent',
                width: '2lpx',
              })
            }
            .focusable(true)
            .height(lpx(114))
            .width(lpx(566))
            .id('captionSettings' + item.id)
            .onFocus(() => {
              this.captionSettingsIndex = Number(item.id);
            })
            .onBlur(() => {
              this.captionSettingsIndex = -1;
            })
            .onKeyEvent((e?: KeyEvent) => {
              if (!e) {
                return;
              }
              if (e.keyCode == KeyCode.KEYCODE_DPAD_UP && e.type == KeyType.Up) {
                if (Number(item.id) > 1) {
                  this.captionSettingsIndex--
                  focusControl.requestFocus(`${'captionSettings' + this.captionSettingsIndex.toString()}`)
                }
              }
              if (e.keyCode == KeyCode.KEYCODE_DPAD_DOWN && e.type == KeyType.Up) {
                if (Number(item.id) < this.captionSettingsList.length) {
                  this.captionSettingsIndex++
                  focusControl.requestFocus(`${'captionSettings' + this.captionSettingsIndex.toString()}`)
                }
              }
              if ((e.keyCode == KeyCode.KEYCODE_DPAD_CENTER || e.keyCode == KeyCode.KEYCODE_ENTER) &&
                e.type == KeyType.Up) {
                this.resetAllStates();
                if (item.name == '字幕') {
                  if(this.showCaptionSettingLanguage){
                    this.captionSettings=false;
                    //显示字幕界面
                    this.captionSettingLanguage=true;
                    focusControl.requestFocus(
                      'captionSettingLanguage' +
                        (this.captionSettingLanguageList.find(item => item.name == this.captionSettingLanguageText)?.id || '1')
                    );
                    this.updateCaptionSettingLanguage(
                      this.captionSettingLanguageList
                        .find(item => item.name == this.captionSettingLanguageText)?.id || 1
                    );
                  }else {
                    this.captionSettings=true;
                    promptAction.showToast({
                      message: '当前节目没有字幕',
                      backgroundColor: '#404040',
                      textColor: '#dbffffff'
                    })
                  }
                }else if(item.name == '第一字幕语言'){
                  this.captionSettings=false;
                  //显示第一字幕语言
                  this.captionSettingFirst=true;
                  focusControl.requestFocus(
                    'captionSettingFirst' +
                      (this.captionSettingFirstList.find(item => item.name == this.captionSettingFirstText)?.id || '1')
                  );
                  this.updateCaptionSettingFirst(
                    this.captionSettingFirstList.find(item => item.name == this.captionSettingFirstText)?.id || 1
                  );
                }else if(item.name == '第二字幕语言'){
                  this.captionSettings=false;
                  //显示第二字幕语言
                  this.captionSettingSecond=true;
                  focusControl.requestFocus(
                    'captionSettingSecond' +
                      (this.captionSettingSecondList.find(item => item.name == this.captionSettingSecondText)?.id || '1')
                  );
                  this.updateCaptionSettingSecond(
                    this.captionSettingSecondList.find(item => item.name == this.captionSettingSecondText)?.id || 1
                  );
                }
                e.stopPropagation?.();
              }
              if (e.keyCode == KeyCode.KEYCODE_MENU&& e.type == KeyType.Up) {
                e.stopPropagation?.();
              }
            })
          })
        }
        .focusable(true)
        .scrollBar(BarState.Off)
        .width(ConfigData.WH_100_100)
        .layoutWeight(1)
        .margin({
          bottom: lpx(48),
        })
        .alignListItem(ListItemAlign.Start)
      }
      .focusable(true)
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Start)
      .height('100%')
      .visibility(this.captionSettings ? Visibility.Visible : Visibility.None)
      //字幕语言
      Column() {
        Text('字幕设置')
          .height(lpx(75))
          .lineHeight(lpx(75))
          .fontColor(Color.White)
          .fontSize(lpx(64))
          .fontWeight(FontWeight.Medium)
          .textAlign(TextAlign.Start)
          .margin({
            top: lpx(48),
            bottom: lpx(48),
            left: lpx(12)
          })
          .focusable(true)


        List({ space: lpx(24) }) {
          ForEach(this.captionSettingLanguageList, (item:CaptionSettingLanguageItem, index: number) => {
            ListItem() {
              CaptionSettingLanguageView({ item: item, isFocused: this.captionSettingLanguageIndex == item.id })
            }
            .focusable(true)
            .height(lpx(114))
            .width(lpx(566))
            .id('captionSettingLanguage' + item.id)
            .onFocus(() => {
              this.captionSettingLanguageIndex = Number(item.id)
            })
            .onBlur(() => {
              if (this.captionSettingLanguageIndex === item.id) {
                this.captionSettingLanguageIndex = -1;
              }
            })
            .onKeyEvent((e?: KeyEvent) => {
              if (!e) {
                return;
              }
              if (e.keyCode == KeyCode.KEYCODE_DPAD_UP && e.type == KeyType.Up) {
                if (Number(item.id) > 1) {
                  this.captionSettingLanguageIndex = item.id - 1;
                  focusControl.requestFocus(`${'captionSettingLanguage' + this.captionSettingLanguageIndex.toString()}`)
                }
              }
              if (e.keyCode == KeyCode.KEYCODE_DPAD_DOWN && e.type == KeyType.Up) {
                if (Number(item.id) < this.captionSettingLanguageList.length) {
                  this.captionSettingLanguageIndex = item.id + 1;
                  focusControl.requestFocus(`${'captionSettingLanguage' + this.captionSettingLanguageIndex.toString()}`)
                }
              }
              if ((e.keyCode == KeyCode.KEYCODE_DPAD_CENTER || e.keyCode == KeyCode.KEYCODE_ENTER) &&
                e.type == KeyType.Up) {
                this.updateCaptionSettingLanguage(item.id);
                console.log('已选择:', item.name);
                e.stopPropagation?.();
              }
              if (e.keyCode == KeyCode.KEYCODE_MENU&& e.type == KeyType.Up) {
                e.stopPropagation?.();
              }
            })
          })
        }
        .focusable(true)
        .scrollBar(BarState.Off)
        .width(ConfigData.WH_100_100)
        .layoutWeight(1)
        .margin({
          bottom: lpx(48),
        })
        .alignListItem(ListItemAlign.Start)
      }
      .focusable(true)
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Start)
      .height('100%')
      .visibility(this.captionSettingLanguage ? Visibility.Visible : Visibility.None)
      //第一字幕语言
      Column() {
        Text('第一字幕语言')
          .height(lpx(75))
          .lineHeight(lpx(75))
          .fontColor(Color.White)
          .fontSize(lpx(64))
          .fontWeight(FontWeight.Medium)
          .textAlign(TextAlign.Start)
          .margin({
            top: lpx(48),
            bottom: lpx(48),
            left: lpx(12)
          })
          .focusable(true)


        List({ space: lpx(24) }) {
          ForEach(this.captionSettingFirstList, (item:CaptionSettingFirstItem, index: number) => {
            ListItem() {
              CaptionSettingFirstView({ item: item, isFocused: this.captionSettingFirstIndex == item.id })
            }
            .focusable(true)
            .height(lpx(114))
            .width(lpx(566))
            .id('captionSettingFirst' + item.id)
            .onFocus(() => {
              this.captionSettingFirstIndex = Number(item.id)
            })
            .onBlur(() => {
              if (this.captionSettingFirstIndex === item.id) {
                this.captionSettingFirstIndex = -1;
              }
            })
            .onKeyEvent((e?: KeyEvent) => {
              if (!e) {
                return;
              }
              if (e.keyCode == KeyCode.KEYCODE_DPAD_UP && e.type == KeyType.Up) {
                if (Number(item.id) > 1) {
                  this.captionSettingFirstIndex = item.id - 1;
                  focusControl.requestFocus(`${'captionSettingFirst' + this.captionSettingFirstIndex.toString()}`)
                }
              }
              if (e.keyCode == KeyCode.KEYCODE_DPAD_DOWN && e.type == KeyType.Up) {
                if (Number(item.id) < this.captionSettingFirstList.length) {
                  this.captionSettingFirstIndex = item.id + 1;
                  focusControl.requestFocus(`${'captionSettingFirst' + this.captionSettingFirstIndex.toString()}`)
                }
              }
              if ((e.keyCode == KeyCode.KEYCODE_DPAD_CENTER || e.keyCode == KeyCode.KEYCODE_ENTER) &&
                e.type == KeyType.Up) {
                this.updateCaptionSettingFirst(item.id);
                console.log('已选择:', item.name);
                e.stopPropagation?.();
              }
              if (e.keyCode == KeyCode.KEYCODE_MENU&& e.type == KeyType.Up) {
                e.stopPropagation?.();
              }
            })
          })
        }
        .focusable(true)
        .scrollBar(BarState.Off)
        .width(ConfigData.WH_100_100)
        .layoutWeight(1)
        .margin({
          bottom: lpx(48),
        })
        .alignListItem(ListItemAlign.Start)
      }
      .focusable(true)
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Start)
      .height('100%')
      .visibility(this.captionSettingFirst ? Visibility.Visible : Visibility.None)
      //第二字幕语言
      Column() {
        Text('第二字幕语言')
          .height(lpx(75))
          .lineHeight(lpx(75))
          .fontColor(Color.White)
          .fontSize(lpx(64))
          .fontWeight(FontWeight.Medium)
          .textAlign(TextAlign.Start)
          .margin({
            top: lpx(48),
            bottom: lpx(48),
            left: lpx(12)
          })
          .focusable(true)


        List({ space: lpx(24) }) {
          ForEach(this.captionSettingSecondList, (item:CaptionSettingSecondItem, index: number) => {
            ListItem() {
              CaptionSettingSecondView({ item: item, isFocused: this.captionSettingSecondIndex == item.id })
            }
            .focusable(true)
            .height(lpx(114))
            .width(lpx(566))
            .id('captionSettingSecond' + item.id)
            .onFocus(() => {
              this.captionSettingSecondIndex = Number(item.id)
            })
            .onBlur(() => {
              if (this.captionSettingSecondIndex === item.id) {
                this.captionSettingSecondIndex = -1;
              }
            })
            .onKeyEvent((e?: KeyEvent) => {
              if (!e) {
                return;
              }
              if (e.keyCode == KeyCode.KEYCODE_DPAD_UP && e.type == KeyType.Up) {
                if (Number(item.id) > 1) {
                  this.captionSettingSecondIndex = item.id - 1;
                  focusControl.requestFocus(`${'captionSettingSecond' + this.captionSettingSecondIndex.toString()}`)
                }
              }
              if (e.keyCode == KeyCode.KEYCODE_DPAD_DOWN && e.type == KeyType.Up) {
                if (Number(item.id) < this.captionSettingSecondList.length) {
                  this.captionSettingSecondIndex = item.id + 1;
                  focusControl.requestFocus(`${'captionSettingSecond' + this.captionSettingSecondIndex.toString()}`)
                }
              }
              if ((e.keyCode == KeyCode.KEYCODE_DPAD_CENTER || e.keyCode == KeyCode.KEYCODE_ENTER) &&
                e.type == KeyType.Up) {
                this.updateCaptionSettingSecond(item.id);
                console.log('已选择:', item.name);
                e.stopPropagation?.();
              }
              if (e.keyCode == KeyCode.KEYCODE_MENU&& e.type == KeyType.Up) {
                e.stopPropagation?.();
              }
            })
          })
        }
        .focusable(true)
        .scrollBar(BarState.Off)
        .width(ConfigData.WH_100_100)
        .layoutWeight(1)
        .margin({
          bottom: lpx(48),
        })
        .alignListItem(ListItemAlign.Start)
      }
      .focusable(true)
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Start)
      .height('100%')
      .visibility(this.captionSettingSecond ? Visibility.Visible : Visibility.None)
      //频道管理
      Column() {
        Text('频道管理')
          .height(lpx(75))
          .lineHeight(lpx(75))
          .fontColor(Color.White)
          .fontSize(lpx(64))
          .fontWeight(FontWeight.Medium)
          .textAlign(TextAlign.Start)
          .margin({
            top: lpx(48),
            bottom: lpx(48),
            left: lpx(12)
          })
          .focusable(true)

        List({ space: lpx(24) }) {
          ForEach(this.channelSettingsList, (item: SettingList, index: number) => {
            ListItem() {
              Column() {
                Row() {
                  Text(item.name)
                    .fontColor(this.channelSettingsIndex == item.id ? 'rgba(0, 0, 0, 0.86)' : '#dbffffff')
                    .height(lpx(98))
                    .fontSize(lpx(36))
                    .align(Alignment.Center)
                    .margin({
                      left: lpx(24)
                    })
                    .focusable(true)
                  Row(){
                    Image($r(Ratio.resName('icon_arrow_right')))
                      .fillColor(this.channelSettingsIndex == item.id ? 'rgba(0, 0, 0, 0.86)' : '#99ffffff')
                      .width(lpx(24))
                      .height(lpx(48))
                      .objectFit(ImageFit.Fill)
                      .align(Alignment.Center)
                      .margin({ right: lpx(24) })
                      .focusable(true)
                  }
                }
                .justifyContent(FlexAlign.SpaceBetween)
                .focusable(true)
                .width('550lpx')
                .height('98lpx')
                .backgroundColor(this.channelSettingsIndex == item.id ? '#e6ffffff' : '#33ffffff')
                .border({
                  radius: '18lpx',
                })
              }
              .focusable(true)
              .justifyContent(FlexAlign.Center)
              .alignItems(HorizontalAlign.Center)
              .width('566lpx')
              .height('114lpx')
              .border({
                radius: '24lpx',
                color: this.channelSettingsIndex == item.id ? '#e6ffffff' : 'transparent',
                width: '2lpx',
              })
            }
            .focusable(true)
            .height(lpx(114))
            .width(lpx(566))
            .id('channelSettings' + item.id)
            .onFocus(() => {
              this.channelSettingsIndex = Number(item.id);
            })
            .onBlur(() => {
              this.channelSettingsIndex = -1;
            })
            .onKeyEvent((e?: KeyEvent) => {
              if (!e) {
                return;
              }
              if (e.keyCode == KeyCode.KEYCODE_DPAD_UP && e.type == KeyType.Up) {
                if (Number(item.id) > 1) {
                  this.channelSettingsIndex--
                  focusControl.requestFocus(`${'channelSettings' + this.channelSettingsIndex.toString()}`)
                }
              }
              if (e.keyCode == KeyCode.KEYCODE_DPAD_DOWN && e.type == KeyType.Up) {
                if (Number(item.id) < this.channelSettingsList.length) {
                  this.channelSettingsIndex++
                  focusControl.requestFocus(`${'channelSettings' + this.channelSettingsIndex.toString()}`)
                }
              }
              if ((e.keyCode == KeyCode.KEYCODE_DPAD_CENTER || e.keyCode == KeyCode.KEYCODE_ENTER) &&
                e.type == KeyType.Up) {
                if(item.name=='频道信息'){
                  this.resetAllStates();
                  this.channelInformation=true;
                }else if(item.name=='手动搜索'){
                  this.resetAllStates();
                  this.searchManually=true;
                  this.searchManuallyScroller.scrollToIndex(0);
                  focusControl.requestFocus('Searchmanually1')
                }else if(item.name=='频道删除'){
                  this.deleteController.open()
                }else if(item.name=='自动搜索'){
                  this.controller.open()
                }else if(item.name=='频道排序'){
                  this.resetAllStates();
                  this.channelSorting=true;
                  this.channelSortingScroller.scrollToIndex(this.channelSortingIndex);
                  focusControl.requestFocus('channelSorting' + Number(this.channelSortingIndex))
                }
                e.stopPropagation?.();
              }
              if (e.keyCode == KeyCode.KEYCODE_MENU&& e.type == KeyType.Up) {
                e.stopPropagation?.();
              }
            })
          })
        }
        .focusable(true)
        .scrollBar(BarState.Off)
        .width(ConfigData.WH_100_100)
        .layoutWeight(1)
        .margin({
          bottom: lpx(48),
        })
        .alignListItem(ListItemAlign.Start)
      }
      .focusable(true)
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Start)
      .height('100%')
      .visibility(this.channelSettings ? Visibility.Visible : Visibility.None)

      //频道信息
      Column() {
        Row(){
          Text('信号信息')
            .height(lpx(75))
            .lineHeight(lpx(75))
            .fontColor(Color.White)
            .fontSize(lpx(64))
            .fontWeight(FontWeight.Medium)
            .textAlign(TextAlign.Start)
        }
        .height(lpx(75)).width('100%')
        .margin({
          top: lpx(48),
          bottom: lpx(38.5),
        })
        .justifyContent(FlexAlign.Center)
        Row(){
          Text('使用遥控器切换频道，可查看不同频道信号信息。')
            .fontColor('#e6ffffff')
            .fontSize(lpx(30))
            .fontWeight(500)
        }.height(lpx(35)).width('100%').justifyContent(FlexAlign.Center)

        Column(){
          Row(){
           Text('频道ID').fontColor('#e6ffffff')
             .fontSize(lpx(36))
             .fontWeight(500)
            Text('2').fontColor('#e6ffffff')
              .fontSize(lpx(36))
              .fontWeight(500)
          }.height(lpx(42)).width('100%').margin({
            bottom:'24lpx'
          }).justifyContent(FlexAlign.SpaceBetween)
          Row(){
            Text('频率').fontColor('#e6ffffff')
              .fontSize(lpx(36))
              .fontWeight(500)
            Text('500.0MHz').fontColor('#e6ffffff')
              .fontSize(lpx(36))
              .fontWeight(500)
          }.height(lpx(42)).width('100%').margin({
            bottom:'24lpx'
          }).justifyContent(FlexAlign.SpaceBetween)
          Row(){
            Text('天线').fontColor('#e6ffffff')
              .fontSize(lpx(36))
              .fontWeight(500)
            Text('DTMB').fontColor('#e6ffffff')
              .fontSize(lpx(36))
              .fontWeight(500)
          }.height(lpx(42)).width('100%').margin({
            bottom:'24lpx'
          }).justifyContent(FlexAlign.SpaceBetween)
          Row(){
            Text('业务标识').fontColor('#e6ffffff')
              .fontSize(lpx(36))
              .fontWeight(500)
            Text('0000').fontColor('#e6ffffff')
              .fontSize(lpx(36))
              .fontWeight(500)
          }.height(lpx(42)).width('100%').margin({
            bottom:'24lpx'
          }).justifyContent(FlexAlign.SpaceBetween)
          Row(){
            Text('复用流').fontColor('#e6ffffff')
              .fontSize(lpx(36))
              .fontWeight(500)
            Text('TSID 0,ONID 0').fontColor('#e6ffffff')
              .fontSize(lpx(36))
              .fontWeight(500)
          }.height(lpx(42)).width('100%').margin({
            bottom:'24lpx'
          }).justifyContent(FlexAlign.SpaceBetween)
          Row(){
            Text('网络ID').fontColor('#e6ffffff')
              .fontSize(lpx(36))
              .fontWeight(500)
            Text('0').fontColor('#e6ffffff')
              .fontSize(lpx(36))
              .fontWeight(500)
          }.height(lpx(42)).width('100%').margin({
            bottom:'24lpx'
          }).justifyContent(FlexAlign.SpaceBetween)
          Row(){
            Text('误码程度').fontColor('#e6ffffff')
              .fontSize(lpx(36))
              .fontWeight(500)
            Text('0.0 BER').fontColor('#e6ffffff')
              .fontSize(lpx(36))
              .fontWeight(500)
          }.height(lpx(42)).width('100%').margin({
            bottom:'24lpx'
          }).justifyContent(FlexAlign.SpaceBetween)
          Row(){
            Text('信号强度').fontColor('#e6ffffff')
              .fontSize(lpx(36))
              .fontWeight(500)
            Progress({ value: 100,total: 100, type: ProgressType.Linear }).width('248lpx').height('8lpx').backgroundColor('#33ffffff')
              .borderRadius('4lpx')
            Text('100%').fontColor('#e6ffffff')
              .fontSize(lpx(36))
              .fontWeight(500)
          }.height(lpx(42)).width('100%').margin({
            bottom:'24lpx'
          }).justifyContent(FlexAlign.SpaceBetween)
          Row(){
            Text('信号质量').fontColor('#e6ffffff')
              .fontSize(lpx(36))
              .fontWeight(500)
            Progress({ value: 100,total: 100, type: ProgressType.Linear }).width('248lpx').height('8lpx').backgroundColor('#33ffffff')
              .borderRadius('4lpx')
            Text('100%').fontColor('#e6ffffff')
              .fontSize(lpx(36))
              .fontWeight(500)
          }.height(lpx(42)).width('100%').margin({
            bottom:'24lpx'
          }).justifyContent(FlexAlign.SpaceBetween)
          Row(){
            Text('SSI').fontColor('#e6ffffff')
              .fontSize(lpx(36))
              .fontWeight(500)
              .margin({right:'50lpx'})
            Progress({ value: 5,total: 100, type: ProgressType.Linear }).width('248lpx').height('8lpx').backgroundColor('#33ffffff')
              .borderRadius('4lpx')
            Text('5%').fontColor('#e6ffffff')
              .fontSize(lpx(36))
              .fontWeight(500)
          }.height(lpx(42)).width('100%').justifyContent(FlexAlign.SpaceBetween)
        }.padding({
          left:'64lpx',
          right:'64lpx'
        })
        .height(lpx(636)).width('100%').margin({
          top: lpx(53.5),
        })
      }
      .focusable(true)
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Start)
      .height('100%')
      .width('936lpx')
      .visibility(this.channelInformation ? Visibility.Visible : Visibility.None)

      //手动搜索
      Column() {
        Text('手动搜索')
          .height(lpx(75))
          .lineHeight(lpx(75))
          .fontColor(Color.White)
          .fontSize(lpx(64))
          .fontWeight(FontWeight.Medium)
          .textAlign(TextAlign.Start)
          .margin({
            top: lpx(48),
            bottom: lpx(48),
            left: lpx(12)
          })
          .focusable(true)

        List({ space: lpx(24),scroller: this.searchManuallyScroller}) {
          ForEach(this.searchManuallyList, (item: SettingList, index: number) => {
            ListItem() {
              Column() {
                Row() {
                  Text(item.name)
                    .fontColor(this.searchManuallyIndex == item.id ? 'rgba(0, 0, 0, 0.86)' : '#dbffffff')
                    .height(lpx(98))
                    .fontSize(lpx(36))
                    .align(Alignment.Center)
                    .margin({
                      left: lpx(24)
                    })
                    .focusable(true)
                  Row(){
                    Image($r(Ratio.resName('icon_arrow_right')))
                      .fillColor(this.searchManuallyIndex == item.id ? 'rgba(0, 0, 0, 0.86)' : '#99ffffff')
                      .width(lpx(24))
                      .height(lpx(48))
                      .objectFit(ImageFit.Fill)
                      .align(Alignment.Center)
                      .margin({ right: lpx(24) })
                      .focusable(true)
                  }
                }
                .justifyContent(FlexAlign.SpaceBetween)
                .focusable(true)
                .width('550lpx')
                .height('98lpx')
                .backgroundColor(this.searchManuallyIndex == item.id ? '#e6ffffff' : '#33ffffff')
                .border({
                  radius: '18lpx',
                })
              }
              .focusable(true)
              .justifyContent(FlexAlign.Center)
              .alignItems(HorizontalAlign.Center)
              .width('566lpx')
              .height('114lpx')
              .border({
                radius: '24lpx',
                color: this.searchManuallyIndex == item.id ? '#e6ffffff' : 'transparent',
                width: '2lpx',
              })
            }
            .focusable(true)
            .height(lpx(114))
            .width(lpx(566))
            .id('searchManually' + item.id)
            .onFocus(() => {
              this.searchManuallyIndex = Number(item.id);
            })
            .onBlur(() => {
              this.searchManuallyIndex = -1;
            })
            .onKeyEvent((e?: KeyEvent) => {
              if (!e) {
                return;
              }
              if (e.keyCode == KeyCode.KEYCODE_DPAD_UP && e.type == KeyType.Up) {
                if (Number(item.id) > 1) {
                  this.searchManuallyIndex--
                  this.searchManuallyScroller.scrollToIndex(Number(this.searchManuallyIndex) - 1)
                  focusControl.requestFocus(`${'searchManually' + this.searchManuallyIndex.toString()}`)
                }
              }
              if (e.keyCode == KeyCode.KEYCODE_DPAD_DOWN && e.type == KeyType.Up) {
                if (Number(item.id) < this.searchManuallyList.length) {
                  this.searchManuallyIndex++
                  this.searchManuallyScroller.scrollToIndex(Number(this.searchManuallyIndex) - 1)
                  focusControl.requestFocus(`${'searchManually' + this.searchManuallyIndex.toString()}`)
                }
              }
              if ((e.keyCode == KeyCode.KEYCODE_DPAD_CENTER || e.keyCode == KeyCode.KEYCODE_ENTER) &&
                e.type == KeyType.Up) {
                router.pushUrl({ url: 'pages/ManualSearch' }, router.RouterMode.Single);
                e.stopPropagation?.();
              }
              if (e.keyCode == KeyCode.KEYCODE_MENU&& e.type == KeyType.Up) {
                e.stopPropagation?.();
              }
            })
          })
        }
        .focusable(true)
        .scrollBar(BarState.Off)
        .width(ConfigData.WH_100_100)
        .height('800lpx')
        .alignListItem(ListItemAlign.Start)
      }
      .focusable(true)
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Start)
      .height('100%')
      .width('936lpx')
      .visibility(this.searchManually ? Visibility.Visible : Visibility.None)

      //频道排序
      Column() {
        Text('频道排序')
          .height(lpx(75))
          .lineHeight(lpx(75))
          .fontColor(Color.White)
          .fontSize(lpx(64))
          .fontWeight(FontWeight.Medium)
          .textAlign(TextAlign.Start)
          .margin({
            top: lpx(48),
            bottom: lpx(44),
            left: lpx(12)
          })
          .focusable(true)

        Text() {
          Span('按').focusable(true)
          ImageSpan($r('app.media.img_1'))
            .width('24lpx')
            .height('24lpx')
            .verticalAlign(ImageSpanAlignment.CENTER)
            .margin({ left: '8lpx', right: '8lpx' }).focusable(true)
          Span('键进入编辑模式').focusable(true)
        }
        .focusable(true)
        .fontColor('rgba(255, 255, 255, 0.6)')
        .fontSize('30lpx')
        .fontWeight(400)
        .textAlign(TextAlign.Start)
        .width('100%')
        .height('35lpx')
        .lineHeight('35lpx')
        .margin({ left: lpx(12), bottom: lpx(9) }).focusable(true)
        List({ space: '24lpx', scroller: this.channelSortingScroller }) {
          ForEach(this.channelSortingList, (channel: IChannel, index) => {
            ListItem() {
              Column(){
                Row() {
                  Text(`${channel.id}  ${channel.channelName}`).focusable(true)
                    .textExtend(this.channelSortingIndex, index)
                  if (this.channelSortingIndex == index && this.isEdit) {
                    Image($r('app.media.sort'))
                      .width('48lpx')
                      .height('48lpx').focusable(true)
                  }
                }
                .width('550lpx')
                .height('98lpx')
                .padding({
                  left: '24lpx',
                  right: '30lpx'
                })
                .justifyContent(FlexAlign.SpaceBetween)
                .focusable(true)
                .backgroundColor(this.channelSortingIndex === index ? '#e6ffffff' : '#33ffffff')
                .border({
                  radius: '18lpx',
                })
              }
              .focusable(true)
              .justifyContent(FlexAlign.Center)
              .alignItems(HorizontalAlign.Center)
              .width('566lpx')
              .height('114lpx')
              .border({
                radius: '24lpx',
                color: this.channelSortingIndex === index ? '#e6ffffff' : 'transparent',
                width: '2lpx',
              })
            }
            .id('channelSorting' + index)
            .focusable(true)
            .width(lpx(566))
            .height(lpx(114))
            .onKeyEvent((e?: KeyEvent) => {
              if (!e) {
                return;
              }
              console.log('peng keyCode: ' + e.keyCode, 'type: ' + e.type);
              if (e.keyCode == KeyCode.KEYCODE_ENTER && e.type == KeyType.Up) {
                this.isEdit = !this.isEdit;
                console.log('peng channelSortingIndex KEYCODE_ENTER', this.channelSortingIndex);
                console.log(JSON.stringify(channel),'点击确定的item');
                e.stopPropagation?.();
              }
              if (e.keyCode == KeyCode.KEYCODE_MENU&& e.type == KeyType.Up) {
                e.stopPropagation?.();
              }

              if ((e.keyCode == KeyCode.KEYCODE_DPAD_UP || e.keyCode == KeyCode.KEYCODE_DPAD_DOWN) &&
                e.type == KeyType.Up) {
                // 只有大于2个，才能移动
                if (this.channelSortingList.length < 2) {
                  return;
                }

                if (e.keyCode == KeyCode.KEYCODE_DPAD_UP && this.channelSortingIndex > 0) {
                  console.log('peng channelSortingIndex up start', this.channelSortingIndex);
                  if (this.isEdit) {
                    const tempChannelList = this.channelSortingList.slice();
                    tempChannelList[this.channelSortingIndex] = this.channelSortingList[this.channelSortingIndex - 1];
                    tempChannelList[this.channelSortingIndex - 1] = this.channelSortingList[this.channelSortingIndex];
                    this.channelSortingList = tempChannelList.slice();
                  }
                  this.channelSortingIndex = this.channelSortingIndex - 1;
                  console.log('peng channelSortingIndex up end', this.channelSortingIndex);
                }
                if (
                  e.keyCode == KeyCode.KEYCODE_DPAD_DOWN &&
                  this.channelSortingIndex < this.channelSortingList.length - 1
                ) {
                  console.log('peng channelSortingIndex down start', this.channelSortingIndex);
                  if (this.isEdit) {
                    const tempChannelList = this.channelSortingList.slice();
                    tempChannelList[this.channelSortingIndex] = this.channelSortingList[this.channelSortingIndex + 1];
                    tempChannelList[this.channelSortingIndex + 1] = this.channelSortingList[this.channelSortingIndex];
                    this.channelSortingList = tempChannelList.slice();
                  }
                  this.channelSortingIndex = this.channelSortingIndex + 1;
                  console.log('peng channelSortingIndex down end', this.channelSortingIndex);
                }
                this.channelSortingScroller.scrollToIndex(this.channelSortingIndex, true);
                focusControl.requestFocus('channelSorting' + Number(this.channelSortingIndex));
              }
            })
          })
        }
        .width('100%')
        .scrollBar(BarState.Off)
        .focusable(true)
        .layoutWeight(1)
        .margin({
          bottom: lpx(48),
        })
      }
      .focusable(true)
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Start)
      .height('100%')
      .width('936lpx')
      .visibility(this.channelSorting ? Visibility.Visible : Visibility.None)
    }
    .focusable(true)
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Start)
    .height('100%')
  }
}
@Extend(Text)
function textExtend(channelSortingIndex: number, index: number) {
  .fontColor(channelSortingIndex == index ? 'rgba(0, 0, 0, 0.86)' : '#dbffffff')
  .fontSize('36lpx')
  .fontWeight(500)
}




