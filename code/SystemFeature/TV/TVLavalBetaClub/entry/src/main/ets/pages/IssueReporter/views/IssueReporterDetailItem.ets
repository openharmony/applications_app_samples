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
import LogManager from '../../../common/Log/LogManager';
import dayjs from 'dayjs';
import picker from '@ohos.file.picker';
import base from '@ohos.base';
import photoAccessHelper from '@ohos.file.photoAccessHelper';
import dataSharePredicates from '@ohos.data.dataSharePredicates';
import ThumbnailList from '../../common/ThumbnailList';
import image from '@ohos.multimedia.image';
import { setImageBase64 } from '../../common/UtilImage';
import { Attachment } from '../models/IssueDetailInfo';

export enum IssueReporterDetailItemType {
  default = 0, // 默认样式，右侧为文字
  time, // 时间选择器
  filter, // 筛选选择器，比如故障概率等
  edit, // 编辑框
  attachment, // 附件
  attachmentDisplay, //详情展示
  date, // 日期选择器
}

const TAG = 'IssueReporterDetailItem';

@Component
export default struct IssueReporterDetailItem {
  isCanEdit: boolean = false;
  @Prop itemType: IssueReporterDetailItemType = IssueReporterDetailItemType.default;
  title: string = '';
  // default
  @Prop defaultContent: string = '';
  @Prop attachments: Attachment[] = [{
    type: '',
    id: '',
    url: '',
    thumbnail: ''
  }];
  // time
  @State time: string = '';
  selectedDate: Date = new Date();
  selectedDateHandle?: (time: string) => void;
  private endTime: string = '';
  private startTime: string = '';
  // filter
  @State filter: string = '';
  filters: string[] = [];
  private selectedFilterNumber: number | number[] = 0;
  selectedFilterHandle?: (filter: string, index: number) => void;
  // edit
  placeholder: string = '';
  @State editText: string = '';
  textAreaController: TextAreaController = new TextAreaController();
  @State editHeight: string = '500lpx';
  changeTextHandle?: (text: string) => void;
  // photo
  @State photoPixels: image.PixelMap[] = [];
  @State photoInfos: photoAccessHelper.PhotoAsset[] = [];
  selectedPhotoHandle?: (photoInfos: photoAccessHelper.PhotoAsset[]) => void;
  private imgClick?: (url: string) => void;

  aboutToAppear() {
    let currentDate = new Date();
    this.endTime = dayjs(currentDate).format('YYYY-MM-DD HH:mm:ss');
    // 显示当前及7天前的可选时间
    let startDate = (new Date()).setDate(currentDate.getDate() - 7);
    this.startTime = dayjs(startDate).format('YYYY-MM-DD HH:mm:ss');
    LogManager.hilogIWithTag(TAG,
      `aboutToAppear, currentTime: ${JSON.stringify(this.endTime)}, twoDaysAgoTime: ${JSON.stringify(this.startTime)}`);

  }

  private showDatePicker() {
    DatePickerDialog.show({
      start: new Date(this.startTime),
      end: new Date(this.endTime),
      selected: this.selectedDate,
      showTime: true,
      useMilitaryTime: true,
      disappearTextStyle: { color: Color.Black, font: { size: '40lpx', weight: FontWeight.Regular } },
      textStyle: { color: Color.Black, font: { size: '50lpx', weight: FontWeight.Normal } },
      selectedTextStyle: { color: Color.Black, font: { size: '60lpx', weight: FontWeight.Bold } },
      onDateAccept: (value: Date) => {
        LogManager.hilogIWithTag(TAG, `showDatePicker onDateAccept, value: ${JSON.stringify(value)}`);
        // 通过Date的setFullYear方法设置按下确定按钮时的日期，这样当弹窗再次弹出时显示选中的是上一次确定的日期
        this.selectedDate = value;

        this.time = dayjs(value).format('YYYY-MM-DD HH:mm:ss');

        //
        if (this.selectedDateHandle) {
          this.selectedDateHandle(this.time);
        }
      },
      onCancel: () => {
        console.info('DatePickerDialog:onCancel()');
      },
      onDateChange: (value: Date) => {
        console.info('DatePickerDialog:onDateChange()' + value.toString());
      }
    });
  }

  private showFilterPicker() {
    TextPickerDialog.show({
      range: this.filters,
      selected: this.selectedFilterNumber,
      canLoop: false,
      disappearTextStyle: { color: Color.Red, font: { size: 15, weight: FontWeight.Lighter } },
      textStyle: { color: Color.Black, font: { size: 20, weight: FontWeight.Normal } },
      selectedTextStyle: { color: Color.Blue, font: { size: 30, weight: FontWeight.Bolder } },
      onAccept: (value: TextPickerResult) => {
        LogManager.hilogIWithTag(TAG, `showFilterPicker onAccept, value: ${JSON.stringify(value)}`);
        // 设置select为按下确定按钮时候的选中项index，这样当弹窗再次弹出时显示选中的是上一次确定的选项
        this.selectedFilterNumber = value.index;
        // 点击确定后，被选到的文本数据展示到页面
        this.filter = value.value as string;

        if (this.selectedFilterHandle) {
          this.selectedFilterHandle(this.filter, this.selectedFilterNumber as number);
        }
      },
      onCancel: () => {
        console.info('TextPickerDialog:onCancel()');
      },
      onChange: (value: TextPickerResult) => {
        console.info('TextPickerDialog:onChange()' + JSON.stringify(value));
      }
    });
  }

  private selectPhoto() {
    this.photoPixels = [];
    this.photoInfos = [];
    if (this.selectedPhotoHandle) {
      this.selectedPhotoHandle(this.photoInfos);
    }

    let photoSelectOptions = new picker.PhotoSelectOptions();
    photoSelectOptions.MIMEType = picker.PhotoViewMIMETypes.IMAGE_VIDEO_TYPE;
    photoSelectOptions.maxSelectNumber = 9;
    let photoPicker = new picker.PhotoViewPicker();
    photoPicker.select(photoSelectOptions).then(async (photoSelectResult: picker.PhotoSelectResult) => {
      LogManager.hilogIWithTag(TAG, `selectPhoto select, PhotoSelectResult: ${JSON.stringify(photoSelectResult)}`);

      let uris = photoSelectResult.photoUris;

      try {
        for (let index = 0; index < uris.length; index++) {
          let phAccessHelper = photoAccessHelper.getPhotoAccessHelper(getContext(this));
          let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
          // 配置查询条件，使用PhotoViewPicker选择图片返回的uri进行查询
          predicates.equalTo('uri', uris[index]);
          let fetchOption: photoAccessHelper.FetchOptions = {
            fetchColumns: [],
            predicates: predicates
          };
          LogManager.hilogIWithTag(TAG, `selectPhoto select, getAssets start`);
          let fetchResult: photoAccessHelper.FetchResult<photoAccessHelper.PhotoAsset> =
            await phAccessHelper.getAssets(fetchOption);
          // 得到uri对应的PhotoAsset对象，读取文件的部分信息
          LogManager.hilogIWithTag(TAG, `selectPhoto select, getFirstObject start`);
          let asset: photoAccessHelper.PhotoAsset = await fetchResult.getFirstObject();
          LogManager.hilogIWithTag(TAG, 'selectPhoto asset displayName: ' + asset.displayName);
          LogManager.hilogIWithTag(TAG, 'selectPhoto asset uri: ' + asset.uri);
          LogManager.hilogIWithTag(TAG, 'selectPhoto asset photoType: ' + asset.photoType);
          this.photoInfos.push(asset);

          // 获取缩略图
          let pixelMap = await asset.getThumbnail();
          LogManager.hilogIWithTag(TAG, 'selectPhoto getThumbnail, pixelMap: ' + JSON.stringify(pixelMap));
          //将pixelMap进行打包
          const imagePackageApi: image.ImagePacker = image.createImagePacker();
          let packOpts: image.PackingOption = {
            format: 'image/jpeg',
            quality: 100,
          };
          const readBuffer: ArrayBuffer = await imagePackageApi.packing(pixelMap, packOpts);
          setImageBase64(asset.displayName, readBuffer);
          this.photoPixels.push(pixelMap);
          if (this.selectedPhotoHandle) {
            this.selectedPhotoHandle(this.photoInfos);
          }
        }
        LogManager.hilogIWithTag(TAG, 'selectPhoto, photoPixels: ' + JSON.stringify(this.photoPixels));
      } catch (err) {
        LogManager.hilogIWithTag(TAG, 'selectPhoto, err: ' + JSON.stringify(err));
      }

    }).catch((err: base.BusinessError) => {
      LogManager.hilogIWithTag(TAG, `selectPhoto select, err: ${JSON.stringify(err)}`);
    });
  }

  build() {
    Row() {
      Text(this.title)
        .fontSize('60lpx')
        .width('260lpx')
        .margin({ left: '40lpx' });

      Blank();

      if (this.itemType == IssueReporterDetailItemType.default) {
        Text(this.defaultContent)
          .fontSize('60lpx')
          .margin({ left: '40lpx', right: '40lpx' })
          .textAlign(TextAlign.End)
          .layoutWeight(1);
      } else if (this.itemType == IssueReporterDetailItemType.time) {
        if (this.isCanEdit) {
          Text('*')
            .fontColor(Color.Red)
            .fontSize('60lpx');
        }

        if (this.time.length > 0) {
          Text(this.time)
            .fontSize('60lpx')
            .margin({ left: '40lpx', right: '40lpx' })
            .textAlign(TextAlign.End)
            .layoutWeight(1);
        } else {
          Text('请选择故障时间')
            .fontSize('60lpx')
            .fontColor(Color.Gray)
            .margin({ left: '40lpx', right: '40lpx' })
            .textAlign(TextAlign.End)
            .layoutWeight(1);
        }

      } else if (this.itemType == IssueReporterDetailItemType.filter) {
        if (this.isCanEdit) {
          Text('*')
            .fontColor(Color.Red)
            .fontSize('60lpx');
        }

        if (this.filter.length > 0) {
          Text(this.filter)
            .fontSize('60lpx')
            .margin({ left: '40lpx', right: '40lpx' })
            .textAlign(TextAlign.End)
            .layoutWeight(1);
        } else {
          Text('请选择问题概率')
            .fontSize('60lpx')
            .fontColor(Color.Gray)
            .margin({ left: '40lpx', right: '40lpx' })
            .textAlign(TextAlign.End)
            .layoutWeight(1);
        }

      } else if (this.itemType == IssueReporterDetailItemType.edit) {
        if (this.isCanEdit) {
          Text('*')
            .fontColor(Color.Red)
            .fontSize('60lpx');
        }

        TextArea({
          text: this.editText,
          placeholder: this.placeholder,
          controller: this.textAreaController
        })
          .placeholderFont({ size: '60lpx' })
          .height(this.editHeight)
          .margin({ left: '40lpx', right: '40lpx' })
          .barState(BarState.Auto)
          .fontSize('60lpx')
          .fontColor('#182431')
          .maxLength(1024)
          .enableKeyboardOnFocus(false)
          .layoutWeight(1)
          .onChange((value: string) => {
            LogManager.hilogIWithTag(TAG, `TextArea onChange, value: ${JSON.stringify(value)}`);
            this.editText = value;

            if (this.changeTextHandle) {
              this.changeTextHandle(this.editText);
            }
          });
      } else if (this.itemType == IssueReporterDetailItemType.attachment) {
        ThumbnailList({
          thumbnails: this.photoPixels,
          photoInfos: this.photoInfos
        })
          .margin({ left: '40lpx', right: '40lpx' })
          .layoutWeight(1);
      } else if (this.itemType == IssueReporterDetailItemType.attachmentDisplay) {
        if (this.attachments && this.attachments.length > 0 && this.attachments[0].thumbnail !== '') {
          Column() {
            Grid() {
              ForEach(this.attachments, (item: Attachment) => {
                GridItem() {
                  this.GridItemView(item);
                };
              }, (item: Attachment, index?: number) => index + JSON.stringify(item.id));
            }
            .padding({
              bottom: 3
            });
          }
          .layoutWeight(1);
        }
        if (this.attachments && this.attachments.length === 0) {
          Text($r('app.string.no_attachment_uploaded'))
            .fontSize('60lpx')
            .margin({ left: '40lpx', right: '40lpx' })
            .textAlign(TextAlign.End)
            .layoutWeight(1);
        }

      }
    }
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .backgroundColor(Color.White)
    .padding({ top: '40lpx', bottom: '40lpx' })
    .onClick(async (event) => {
      LogManager.hilogIWithTag(TAG, `onClick enter`);

      if (!this.isCanEdit) {
        return;
      }

      this.textAreaController.stopEditing();

      switch (this.itemType) {
        case IssueReporterDetailItemType.time: {
          this.showDatePicker();
        }
          break;

        case IssueReporterDetailItemType.filter: {
          this.showFilterPicker();
        }
          break;

        case IssueReporterDetailItemType.attachment: {
          this.selectPhoto();
        }
        case IssueReporterDetailItemType.attachmentDisplay: {
          this.selectPhoto();
        }
          break;
      }
    });
  }

  @Builder
  GridItemView(item: Attachment) {
    Flex({
      direction: FlexDirection.Column,
      alignItems: ItemAlign.Center,
      justifyContent: FlexAlign.Center
    }) {
      Image(item.thumbnail)
        .objectFit(ImageFit.Contain)
        .width(60)
        .height(60)
        .onClick(() => {
          LogManager.hilogIWithTag(TAG, `Image click, value: ${JSON.stringify(item.url)}`);
          if (!this.isCanEdit && this.imgClick) {
            this.imgClick(item.url);
          }
        });

    }
    .width(60)
    .height(60)
    .padding({ top: 8 });
  }
}