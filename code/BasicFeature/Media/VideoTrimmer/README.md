# 视频下载保存及剪辑压缩上传

### 介绍

本示例主要介绍从网上下载视频到相册，以及从相册中选择视频进行剪辑、压缩、以及上传到服务器进行保存。从相册中选择一个视频保存到沙箱中，再使用FFmpeg命令对沙箱中的视频进行压缩、剪辑。最后使用request.agent将剪辑后的视频上传到服务器进行保存。

### 效果图预览

<img src="./video_trimmer.gif" width="300" >

**使用说明**

1. 点击视频列表的背景图片，进入到该视频播放界面。
2. 在视频播放界面，点击右上角的图片按钮，进入到视频分享弹窗。
3. 在视频分享弹窗点击“下载”按钮，将视频下载到相册。
4. 在首页点击右上角的“添加”按钮，从相册中选择要剪辑的视频。
5. 视频选择后，点击界面上视频首页的图片，进入到视频剪辑界面。
6. 在视频剪辑界面，选择要剪辑的时间范围后，点击“完成”按钮，进行视频剪辑。
7. 视频剪辑成功后自动返回到上一页，点击右上角的“保存”按钮，将视频保存到服务器。

### 实现步骤  

**下载视频：**  
点击视频列表中某个视频，进入视频播放界面。点击播放界面右上角的图片按钮，进行视频分享界面。点击视频分享界面中的下载按钮，将视频下载到相册保存。    
1. 定义下载配置参数 request.agent.Config。源码参考[RequestDownload.ets](./entry/src/main/ets/uploadanddownload/RequestDownload.ets)。   
    ```typescript   
    let downloadConfig: request.agent.Config = {
      action: request.agent.Action.DOWNLOAD,   // 下载
      url: url,  // 下载地址
      method: 'GET',
      title: 'download',
      mode: request.agent.Mode.BACKGROUND,  // 下载模式（前台或后台）
      retry: true,  // 是否支持重试
      network: request.agent.Network.ANY,  // 支持的网络类型
      saveas: `./${localPath}`,   // 保存路径
      overwrite: true             // 是否覆盖已存在文件
   }
   ```
2. 通过配置创建下载任务，并监听下载进度。当下载完成后通过callback进行回调通知，并删除下载任务。源码参考[RequestDownload.ets](./entry/src/main/ets/uploadanddownload/RequestDownload.ets)。            

    ```typescript  
      try {
        // 创建下载任务
        this.downloadTask = await request.agent.create(context, downloadConfig);
        // 监听下载进度
        this.downloadTask.on('progress', this.progressCallback = (progress: request.agent.Progress) => {
          logger.info(TAG, `progress = ${progress.processed} ,state =  ${progress.state}`);
          let processed = Number(progress.processed.toString()).valueOf();
          let size = progress.sizes[0];
          let process: number = Math.floor(processed / size * CommonConstants.PROGRESS_MAX);
          if (process < CommonConstants.PROGRESS_MAX) {
            callback(process, false, '');
          }
        })
        // 通过‘completed’监听下载完成
        this.downloadTask.on('completed', this.completedCallback = (progress: request.agent.Progress) => {
          logger.info(TAG, `download complete, file= ${url}, progress = ${progress.processed}, localPath=${localPath}`);
          // 通过回调函数传递下载进度和下载保存的地址
          callback(CommonConstants.PROGRESS_MAX, true, localPath);
          // 删除任务
          this.deleteTask();
        })
        // 启动下载任务   
        await this.downloadTask.start();
      } catch (error) {
        const err: BusinessError = error as BusinessError;
        logger.error(TAG, `task  err, Code is ${err.code}, message is ${err.message}`);
        callback(CommonConstants.PROGRESS_MAX, false, '');
      }
    }
    
    ```  
3. 界面收到下载成功的消息后，通过showAssetsCreationDialog拉起权限弹窗，将下载到沙箱中的视频文件通过写数据的方式保存到相册。源码参考[CustomShareDlg.ets](./entry/src/main/ets/customcomponents/CustomShareDlg.ets)。        

    ```typescript
    let phAccessHelper = photoAccessHelper.getPhotoAccessHelper(this.context);
    try {
      let photoCreationConfigs: Array<photoAccessHelper.PhotoCreationConfig> = [
        {
          title: 'videoDoanload',
          fileNameExtension: 'mp4',
          photoType: photoAccessHelper.PhotoType.VIDEO,
          subtype: photoAccessHelper.PhotoSubtype.DEFAULT,
        }
      ];
      // TODO: 知识点: 拉起授予权限的弹窗，获取将视频保存到图库的权限
      let desFileUris: Array<string> = await phAccessHelper.showAssetsCreationDialog(srcFileUris, photoCreationConfigs);
      logger.info(TAG, 'saveVideo des is：' + desFileUris[0]);
      // 转换为uri
      let uri: string = fileUri.getUriFromPath(srcFileUris[0]);
      // 打开沙箱路径下视频
      const file: fs.File = fs.openSync(uri, fs.OpenMode.READ_WRITE);
      // 将沙箱视频内容写入buffer
      const videoSize: number = fs.statSync(file.fd).size;
      let arrayBuffer: ArrayBuffer = new ArrayBuffer(videoSize);
      let readLength: number = fs.readSync(file.fd, arrayBuffer);
      let videoBuffer: ArrayBuffer = buffer.from(arrayBuffer, 0, readLength).buffer;
      try {
        // 打开图库视频保存的路径
        let fileInAlbum = fs.openSync(desFileUris[0], fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
        // 写入图库
        await fs.write(fileInAlbum.fd, videoBuffer);
        // 关闭文件
        await fs.close(file.fd);
        await fs.close(fileInAlbum.fd);
        logger.info(TAG, 'saveVideo success');
        // 视频保存成功后，删掉沙箱路径下视频
        fs.unlinkSync(srcFileUris[0]);
        promptAction.showToast({
          message: $r("app.string.video_trimmer_save_success"),
          duration: DURATION
        });
        this.controller.close();
      } catch (error) {
        logger.error(TAG, `saveVideo failed, code is: ${error.code}, message is: ${error.message}`);
      }
    } catch (err) {
      logger.error(TAG, `showAssetsCreationDialog failed, errCode is: ${err.code}, message is: ${err.message}`);
    }
    ```   

**视频剪辑：**  
点击首页右上角的"添加"按钮，从相册中选择一个视频存入沙箱。通过MP4Parser.getFrameAtTimeRang接口，传入起始时间，获取视频的第一张图片进行展示。点击该图片进入视频剪辑界面，视频剪辑完成后自动回到本界面，点击右上角的保存按钮，将剪辑后的视频上传到配置好的服务器。  

1. 通过photoViewPicker从相册中选择一个视频。源码参考[VideoTrimmer.ets](./entry/src/main/ets/pages/VideoTrimmer.ets)。   
     ```typescript    
     // 创建图库选项实例
        const photoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
        // 设置选择的媒体文件类型
        photoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.VIDEO_TYPE;
        // 设置选择媒体文件的最大数目
        photoSelectOptions.maxSelectNumber = 1;
        // 创建图库选择器实例
        const photoViewPicker = new photoAccessHelper.PhotoViewPicker();
        // 调用photoViewPicker.select()接口拉起图库界面进行图片选择，图片选择成功后，返回photoSelectResult结果集。
        photoViewPicker.select(photoSelectOptions).then((photoSelectResult) => {
          if (photoSelectResult !== null && photoSelectResult !== undefined) {
            // 将视频保存到沙箱中
            this.saveFileToSandbox(photoSelectResult.photoUris[0]);
          }
        }).catch((err: BusinessError) => {
        logger.error(TAG,
          `selectPhotoFromAlbum PhotoViewPicker.select failed :, error code: ${err.code}, message: ${err.message}.`);
        })
    ```
2. 将选择的视频写入到沙箱中,写入成功后跳转到视频上传展示界面。源码参考[VideoTrimmer.ets](./entry/src/main/ets/pages/VideoTrimmer.ets)。    

      ```typescript    
       /**
       * 将图库中的视频保存到沙箱中
       */
      async saveFileToSandbox(filePathString: string): Promise<void> {
        this.localSelectVideoUrl[0] = filePathString;
        try {
          // 打开图库中视频的文件
          let resFile = fs.openSync(filePathString, fs.OpenMode.READ_ONLY);
        
          const dateStr = (new Date().getTime()).toString()
          let newPath = getContext().cacheDir + "/" + `${dateStr + resFile.name}`;
          // 将图库中的视频保存到沙箱中
          fs.copyFileSync(resFile.fd, newPath);
          // 新的路径
          this.localSelectVideoUrl[0] = newPath;
          logger.info(TAG,
          `selectPhotoFromAlbum, VideoUpload url:${this.localSelectVideoUrl[0].toString()}`);
          if (this.localSelectVideoUrl[0] !== undefined && this.localSelectVideoUrl[0] !== '') {
            // 进入到视频上传展示页面
            DynamicsRouter.pushUri("videotrimmer/VideoUpload", this.localSelectVideoUrl[0]);
          }
        } catch (err) {
          logger.error(TAG, `selectPhotoFromAlbum.select failed :, error code: ${err.code}, message: ${err.message}.`);
        }
      }
      ```
3. 视频上传展示界面初始时，通过MP4Parser.getFrameAtTimeRang接口获取沙箱中视频的首页图片进行展示。源码参考[VideoUpload.ets](./entry/src/main/ets/pages/VideoUpload.ets)。   
    ```typescript
    let callBack: ICallBack = {
      //  回调函数
      callBackResult: (code: number) => {
        if (code == 0) {
          let frameCallBack: IFrameCallBack = {
            callBackResult: async (data: ArrayBuffer, timeUs: number) => {
              const imageSource: image.ImageSource = image.createImageSource(data);

              let decodingOptions: image.DecodingOptions = {
                sampleSize: 1,
                editable: true,
                desiredSize: { width: CommonConstants.firstImageWidth, height: CommonConstants.firstImageHeight },
                desiredPixelFormat: image.PixelMapFormat.RGBA_8888
              };
              await imageSource.createPixelMap(decodingOptions).then(async (px: image.PixelMap) => {
                this.workItem.firstImage = px;
                imageSource.release();
              })
            }
          }
          let startTimeUs = CommonConstants.FIRST_IMAGE_START_TIME + '';
          let endTimeUs = CommonConstants.FIRST_IMAGE_END_TIME + '';
          // TODO: 知识点：传入起始时间，通过MP4Parser的getFrameAtTimeRang接口获取视频的首页图片
          MP4Parser.getFrameAtTimeRang(startTimeUs, endTimeUs, MP4Parser.OPTION_CLOSEST, frameCallBack);
        }
      }
    }
    // TODO: 知识点：设置MP4Parser视频源地址及回调函数
    MP4Parser.setDataSource(this.workItem.videoSrc, callBack);
    ```
4. 视频上传展示界面初始时，配置视频剪辑参数mVideoTrimmerOption。源码参考[VideoUpload.ets](./entry/src/main/ets/pages/VideoUpload.ets)和[视频剪辑参数](./entry/src/main/ets/videotrimmer/VideoTrimmerOption.ets)。  

   ```typescript
   // 视频剪辑参数类
    export class VideoTrimmerOption {
    constructor() {
    this.scaleNum = 100;
    this.videoMaxTime = 8;
    this.videoMinTime = 3;
    this.maxCountRange = 8;
    this.thumbWidth = 30;
    this.paddingLineHeight = 10;
    }
    
    // 源文件路径
    @Track srcFilePath: string = '';
    // 视频剪辑回调接口
    @Track listener: VideoTrimListener = {
    onStartTrim() {
    },
    onFinishTrim(outputFile: string) {
    },
    onCancel() {
    }
    };
    // 视频帧加载回调接口
    @Track loadFrameListener: VideoLoadFramesListener = {
    onStartLoad() {
    },
    onFinishLoad() {
    }
    }
    // 裁剪事件长度 默认值8秒
    @Track videoMaxTime?: number = 8;
    // 最小剪辑时间
    @Track videoMinTime?: number = 3;
    // seekBar的区域内一共有多少张图片
    @Track maxCountRange?: number = 8;
    // 裁剪视频预览长方形条状左右边缘宽度
    @Track thumbWidth?: number = 30;
    // 裁剪视频预览长方形条状上下边缘高度
    @Track paddingLineHeight?: number = 10;
    // 当加载帧没有完成，默认的占位图
    @Track framePlaceholder?: PixelMap;
    // 裁剪视频预览长方形条状区域背景颜色
    @Track frameBackground?: string;
    @Track context?: common.UIAbilityContext;
    // 裁剪时压缩比率，100 为1：1，即不压缩
    @Track scaleNum?: number = 100;
    }
   ```
   ```typescript
   // 视频剪辑参数选项
   let tempOption = new VideoTrimmerOption();
   tempOption.listener = this.initListener;
   tempOption.loadFrameListener = this.initLoadFrameListener;
   tempOption.srcFilePath = this.workItem.videoSrc;
   this.mVideoTrimmerOption = tempOption;
   ```

5. 点击视频图片进入到视频剪辑模块，剪辑成功后自动回到本模块。源码参考[VideoUpload.ets](./entry/src/main/ets/pages/VideoUpload.ets)。     

    ```typescript
    @State isTrimmer: boolean = false;  // 是否处于剪辑状态
   
    if (!this.isTrimmer) {
      this.VideoUpdateInfo();
    } else {
      // TODO: 知识点: 视频剪辑组件VideoTrimmerView。 videoTrimmerOption：视频剪辑相关参数
      VideoTrimmerView({ videoTrimmerOption: this.mVideoTrimmerOption!! })
    }
   ```

6. 视频剪辑模块初始化时，根据参数中小图的个数，通过MP4Parser.getFrameAtTimeRang命令循环生成小图列表以便用户选择剪辑时间段。其中在生成第一张小图的时候，根据压缩比率参数，生成视频压缩命令。源码参考[VideoTrimmerView.ets](./entry/src/main/ets/videotrimmer/VideoTrimmerView.ets)。。

     ```typescript
     initImageList() {
       // 将视频长度分割为一秒一张图片
       let videoThumbs = new Array<ThumbContent>()
       for (let i = 0; i < this.mDuration; i = i + CommonConstants.MS_ONE_SECOND) {
       let temp = new ThumbContent();

         if (this.videoTrimmerOption.framePlaceholder) {
           temp.framePlaceholder = this.videoTrimmerOption.framePlaceholder;
         }
         if (this.videoTrimmerOption.frameBackground) {
           temp.frameBackground = this.videoTrimmerOption.frameBackground;
         }
         videoThumbs.push(temp);
       }

       let firstLoadMax = this.maxCountRange;
       if (this.mDuration / CommonConstants.MS_ONE_SECOND < this.maxCountRange) {
         firstLoadMax = Math.ceil(this.mDuration / CommonConstants.MS_ONE_SECOND);
       }

       let callBack: ICallBack = {
         callBackResult: (code: number) => {
           if (code == 0) {
             let count = 0;

             let frameCallBack: IFrameCallBack = {
               callBackResult: async (data: ArrayBuffer, timeUs: number) => {
                 const imageSource: image.ImageSource = image.createImageSource(data);
                 // TODO: 知识点: 如果要压缩分辨率，则加载第一张图时，获取视频的压缩分辨率相关参数信息，生成视频压缩命令
                 if (this.videoTrimmerOption!.scaleNum! > 0 &&
                   this.videoTrimmerOption!.scaleNum !== CommonConstants.SCALE_NUM &&
                   this.imageWidth !== 0) {
                   // 读取图片信息
                   const imageInfo: image.ImageInfo = await imageSource!.getImageInfo();
                   this.imageWidth = imageInfo.size.width;
                   this.imageHeight = imageInfo.size.height;
                   // 生成视频压缩命令
                   this.scaleCmd =
                     'scale=' +
                     ((this.imageWidth / CommonConstants.SCALE_NUM) * this.videoTrimmerOption!.scaleNum!).toString() +
                       ':' +
                     ((this.imageHeight / CommonConstants.SCALE_NUM) * this.videoTrimmerOption!.scaleNum!).toString()
                 }

                 let videoThumbWidth: number = vp2px((this.mSeekBarWidth - 2 * this.thumbWidth) / this.maxCountRange);
                 let videoThumbHeight: number = vp2px(this.mSeekBarHeight);
                 let decodingOptions: image.DecodingOptions = {
                   sampleSize: 1,
                   editable: true,
                   desiredSize: { width: videoThumbWidth, height: videoThumbHeight },
                   desiredPixelFormat: image.PixelMapFormat.RGBA_8888
                 };
                 // TODO: 知识点: 在回调函数中循环生成小图，更新到小图列表中
                 imageSource.createPixelMap(decodingOptions).then((px: image.PixelMap) => {
                   let second = timeUs / CommonConstants.US_ONE_SECOND;
                   let framePos = count;
                   if (second == framePos) {
                     logger.info(TAG,
                       'framePos equal second, second=' + second + ' timeUs=' + timeUs + ' length=' + videoThumbs.length);
                     videoThumbs[second].pixelMap = px;
                     this.updateList(videoThumbs);
                     count++;
                     imageSource.release();
                   } else {
                     logger.info(TAG, 'framePos not equal second, framePos=' + framePos + ' timeUs=' + timeUs);
                     videoThumbs[framePos].pixelMap = px;
                     this.updateList(videoThumbs);
                     count++;
                     imageSource.release();
                   }
                   if (count == firstLoadMax) {
                     this.videoTrimmerOption.loadFrameListener.onFinishLoad();
                   }
                 }).catch((err: Error) => {
                   // 部分视频创建图片异常，直接返回
                   console.error("createPixelMap Failed, err = " + err.name + ", message = " + err.message);
                   this.videoTrimmerOption.loadFrameListener.onFinishLoad();
                 })
               }
             }
             // TODO: 知识点: 根据开始、结束时间，通过MP4Parser.getFrameAtTimeRang命令循环生成小图
             let startTime = 0 * CommonConstants.US_ONE_SECOND + '';
             let endTime = (firstLoadMax - 1) * CommonConstants.US_ONE_SECOND + '';
            // 通过开始、结束时间，回调函数，获取视频小图
             MP4Parser.getFrameAtTimeRang(startTime, endTime, MP4Parser.OPTION_CLOSEST, frameCallBack);
           } else {
             logger.info(TAG, 'setDataSource fail, error code =' + code.toString());
           }
         }
       }
       this.videoTrimmerOption.loadFrameListener.onStartLoad();
       // 设置视频源和回调函数
       MP4Parser.setDataSource(this.videoTrimmerOption.srcFilePath, callBack);
       logger.info(TAG, "initList list size=" + videoThumbs.length);
       this.updateList(videoThumbs);
     }
     ```

7. 在视频剪辑界面，拉动左右进度条，根据拉动后的位置，计算选择要剪辑的时间范围，源码参考[RangeSeekBarView.ets](./entry/src/main/ets/videotrimmer/RangeSeekBarView.ets)。    
获取拉动位置：
    ```typescript
    .onActionUpdate((event?: GestureEvent) => {
      let touchXNew: number = this.clearUndefined(event?.offsetX);
      let deltax: number = touchXNew - this.touchXOld;
      // 左边滑块移动
      if (this.touchStatus == this.touch_left_thumb) {
        this.leftThumbUpdate(deltax);
      } else if (this.touchStatus == this.touch_right_thumb) {
        // 右边滑块移动
        this.rightThumbUpdate(deltax);
      } else if (this.touchStatus == this.touch_hor_scroll) {
        this.scrollUpdate(deltax);
      }
      this.touchDeltaX = deltax;
      this.touchXOld = this.clearUndefined(event?.offsetX);
    })
    .onActionEnd((event?: GestureEvent) => {
      this.touchStatus = this.touch_hor_scroll;
      this.onRangeStopScrollChanged();
    })
    ```
   根据拉动位置计算选择的时间段：
    ```typescript
   // 选取时间变动事件
   onRangeValueChanged() {
     let x0: number = this.scroller.currentOffset().xOffset;
     let start: number = x0 + this.leftThumbRect[2] - this.leftThumbWidth;
     let end: number = start + this.transparentWidth;

     let startTime: number = start * CommonConstants.US_ONE_SECOND / this.msPxAvg;
     this.leftText = this.showThumbText(startTime);
     let endTime: number = end * CommonConstants.US_ONE_SECOND / this.msPxAvg;
     this.rightText = this.showThumbText(endTime);

     if (this.mRangSeekBarListener) {
       this.mRangSeekBarListener.onRangeSeekBarValuesChanged(startTime, endTime);
     }
   }
   ```

8. 点击完成按钮，使用MP4Parser.ffmpegCmd接口，根据选择的起始时间和视频压缩命令，对视频进行压缩和剪辑，并保存到本地沙箱。源码参考[VideoTrimmerView.ets](./entry/src/main/ets/videotrimmer/VideoTrimmerView.ets)。

   ```typescript
	  // 最后一帧保护
	  let sTime1 = 0;
	  let eTime1 = 0;
	  let lastFrameTime =
		Math.floor(this.mDuration / CommonConstants.MS_ONE_SECOND) * CommonConstants.MS_ONE_SECOND;
	  if (this.endTruncationTime > lastFrameTime) {
		eTime1 = lastFrameTime;
		sTime1 = eTime1 - (this.endTruncationTime - this.startTruncationTime);
		eTime1 += CommonConstants.MS_ONE_SECOND; // 补偿1s
	  } else {
		sTime1 = this.startTruncationTime;
		eTime1 = this.endTruncationTime;
	  }
	  // 选取的裁剪时间段
	  let sTime = TimeUtils.msToHHMMSS(sTime1);
	  let eTime = TimeUtils.msToHHMMSS(eTime1);
      // 原视频
	  let srcFilePath = this.videoTrimmerOption.srcFilePath;
	  // 保留原来的文件名
	  let fileName: string | undefined = srcFilePath!.split('/').pop()!.split('.')[0];
	  // 组装剪辑后的文件路径(以 原来的文件名+当前时间 命名)
	  let outFilePath: string =
		getContext(this).cacheDir + '/' + fileName + '_' + TimeUtils.format(new Date()) + '.mp4';
	  // 剪辑回调函数
	  let callback: ICallBack = {   
		callBackResult: (code: number) => {
		  if (code == 0) {
			if (this.videoTrimmerOption) {
			  // 通知上层调用
			  this.videoTrimmerOption.listener.onFinishTrim(outFilePath);
			  this.isTrimming = false;
			}
          }
		}
	  }
	  // TODO: // 知识点： 根据开始、结束时间，视频源以及目标文件地址对视频进行剪辑
	  this.videoClip(sTime, eTime, srcFilePath, outFilePath, this.scaleCmd, callback);
   ```
   
    ```typescript
      // TODO: 知识点: 视频剪辑。  scaleCmd为视频压缩命令
    videoClip(sTime: string, eTime: string, srcFilePath: string, outFilePath: string, scaleCmd: string,
    callback: ICallBack) {
      let ffmpegCmd: string = '';
      if (scaleCmd !== '') {
        ffmpegCmd =
          'ffmpeg -y -i ' + srcFilePath + ' -vf ' + scaleCmd + ' -c:v mpeg4 -c:a aac -ss ' + sTime + ' -to ' + eTime +
            ' ' + outFilePath;
      } else {
        ffmpegCmd = 'ffmpeg -y -i ' + srcFilePath + ' -c:v mpeg4 -c:a aac -ss ' + sTime + ' -to ' + eTime +
          ' ' + outFilePath;
      }
      logger.info(TAG, 'videoClip cmd: ' + ffmpegCmd);
      MP4Parser.ffmpegCmd(ffmpegCmd, callback);
    }
    ```   

**视频上传：**     
视频剪辑成功后自动跳转到视频上传界面。点击右上角的“保存”按钮，如果检测到没有配置服务器，则弹窗提示设置服务器地址，设置后重新点击右上角“保存”按钮，上传视频到服务器进行保存。
1. 参照[environment](./environment/README.md)配置服务器地址，视频剪辑完成后点击“保存”，视频将上传到该服务器地址。

2. 点击保存时，检测是否配置了服务器。源码参考[VideoUpload.ets](./entry/src/main/ets/pages/VideoUpload.ets)。
   ```typescript
   // 获取服务器地址
   this.serverUrl = await urlUtils.getUrl(getContext(this) as common.UIAbilityContext);
   if (this.serverUrl === undefined || this.serverUrl === '') {
     // 打开自定义对话框，配置服务器地址
     await this.customSetServerDlg.open();
   }
   this.serverUrl = await urlUtils.getUrl(getContext(this) as common.UIAbilityContext);
   logger.info(TAG, 'serverUrl is = ' + this.serverUrl);
   if (this.serverUrl !== undefined && this.serverUrl.length > 1) {
     return true;
   } else {
     return false;
   }
   ```

3. 定义上传配置参数 request.agent.Config。源码参考[RequestUpload.ets](./entry/src/main/ets/uploadanddownload/RequestUpload.ets)。
    ```typescript   
    private config: request.agent.Config = {
      action: request.agent.Action.UPLOAD,  // 上传
      headers: HEADER,
      url: '',                              // 上传服务器地址
      mode: request.agent.Mode.FOREGROUND,  // 前台方式
      method: 'POST',
      title: 'upload',
      network: request.agent.Network.ANY,   // 网络类型
      data: [],
      token: UPLOAD_TOKEN
    }
   ```
   
4. 根据配置创建上传任务，并监听上传进度。当上传完成后通过callback进行回调通知，并删除上传任务。源码参考[RequestUpload.ets](./entry/src/main/ets/uploadanddownload/RequestUpload.ets)。
    ```typescript   
    private uploadTask: request.agent.Task | undefined = undefined; // 上传任务

      // 获取本地上传文件
    this.config.data = await this.getFilesAndData(context.cacheDir, fileUris);
    // TODO : 知识点 将视频上传到服务器地址
    // 获取服务器地址
    this.config.url = await urlUtils.getUrl(context);
    // 前台模式
    this.config.mode = request.agent.Mode.FOREGROUND;
    try {
      // 创建上传任务
      this.uploadTask = await request.agent.create(context, this.config);
      logger.info(TAG, `create uploadTask success, TaskID= ${this.uploadTask.tid}`);
      // 监听上传进度
      this.uploadTask.on('progress', this.progressCallback = (progress: request.agent.Progress) => {
        logger.info(TAG, `progress,  progress = ${progress.processed} ${progress.state}`);
        let processed = Number(progress.processed.toString()).valueOf();
        let size = progress.sizes[0];
        let process: number = Math.floor(processed / size * CommonConstants.PROGRESS_MAX);
        if (process < CommonConstants.PROGRESS_MAX) {
          // 进度通知
          callback(process, false);
        }
      });
      // 下载完成事件
      this.uploadTask.on('completed', this.completedCallback = (progress: request.agent.Progress) => {
        logger.info(TAG, `complete,  progress = ${progress.processed}, state= ${progress.state}`);
        // 通知下载完成
        callback(CommonConstants.PROGRESS_MAX, true);
        // 删除任务
        this.deleteTask();
      });
   }
   ```

5. 视频上传成功后，删除本地裁剪的视频，然后返回视频列表首页。源码参考[VideoUpload.ets](./entry/src/main/ets/pages/VideoUpload.ets)。
    ```typescript  
    // 上传成功后删除裁剪的视频
    fs.unlinkSync(this.workItem.videoSrc);
   // 视频地址替换为服务器上的视频
   this.workItem.videoSrc = this.serverUrl + this.workItem.videoSrc.split('/').pop();
   
   //  保存首页背景图
   async saveFirstImage() {
     const url = await savePixelMap(getContext(this), this.workItem.firstImage as PixelMap, getTimeStr());
     this.workItem.firstImage = fileUri.getUriFromPath(url);
     this.workItem.date = TimeUtils.getCurrentTime();
     // 通知视频列表首页更新上传的数据
     AppStorage.setOrCreate('addWorkItem', this.workItem);
     await this.customSetServerDlg.close();
     DynamicsRouter.popAppRouter();
   }
   ```

6. 视频列表首页监听“addWorkItem”数据，更新上传的视频数据。源码参考[VideoTrimmer.ets](./entry/src/main/ets/pages/VideoTrimmer.ets)。
    ```typescript  
   @StorageLink('addWorkItem') @Watch('getUploadWorkItem') addWorkItem: WorkItem =
     new WorkItem('', '', '', '', '', true); // 上传到服务器的视频信息

   // 获取并添加新发表的视频信息
   getUploadWorkItem(): void {
     if (this.addWorkItem.videoSrc !== undefined && this.addWorkItem.videoSrc !== '') {
       this.workList.addData(0, this.addWorkItem);
       AppStorage.setOrCreate('addWorkItem', new WorkItem('', '', '', '', '', false));
     }
   }
   ```

### 高性能知识点

本示例使用了[LazyForEach](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-arkui/arkui-ts/ts-rendering-control-lazyforeach.md) 进行数据懒加载优化，以降低内存占用和渲染开销。

### 工程结构&模块类型

   ```   
videotrimmer                                 // har类型
|---constants                                // 常量
|   |---Constants.ets                        // 通用常量
|   |---DoanloadConstants.ets                // 下载常量
|---customcomponents                         // 自定义组件
|   |---CustomLoadingProgressDlg.ets         // 加载进度
|   |---CustomSetServerDlg.ets               // 设置上传下载服务器
|   |---CustomShareDlg.ets                   // 视频分享
|   |---CustomTabBar.ets                     // 首页底部自定义组件
|---model 
|   |---ShareInfo.ets                        // 分享信息数据
|   |---TabBarModel.ets                      // Tab组件信息  
|   |---WorkListDataSource.ets               // IDataSource处理数据监听的基本实现 
|   |---WorkItemModel.ets                    // 单条视频信息模型  
|---pages
|   |---VideoDetail.ets                      // 视图层-视频播放界面
|   |---VideoTrimmer.ets                     // 视图层-应用主页面
|   |---VideoUpload.ets                      // 视图层-视频保存上传界面
|---uploadanddownload                        // 上传下载
|   |---RequestDownload.ets                  // 下载类
|   |---VideoUpload.ets                      // 上传类
|---utils                                    // 通用工具
|   |---FileUtil.ets                         // 文件处理
|   |---Logger.ets                           // 日志
|   |---TimeUtils.ets                        // 时间处理
|   |---UrlUtils.ets                         // 服务器地址处理
|---videoplaycomponents                      // 视频播放组件
|   |---VideoPlayController.ets              // 视频控制器
|   |---VideoPlayListener.ets                // 视频播放侦听回调
|   |---XComponentVideo.ets                  // 视频播放组件
|---videotrimmer                             // 视频裁剪组件
|   |---RangeSeekBarView.ets                 // 视频剪辑时间长度选择组件
|   |---RangSeekBarListener.ets              // 视频剪辑长度侦听接口
|   |---RangSeekBarOption.ets                // 视频剪辑长度选项
|   |---VideoLoadFramesListener.ets          // 视频帧加载回调接口
|   |---VideoThumbListView.ets               // 视频帧图片列表预览组件
|   |---VideoThumbOption.ets                 // 视频帧图片选项
|   |---VideoTrimListener.ets                // 视频剪辑回调接口
|   |---VideoTrimmerOption.ets               // 视频剪辑选项
|   |---VideoTrimmerView.ets                 // 视频裁剪组件
   ```

### 模块依赖

  依赖[mp4parser](https://ohpm.openharmony.cn/#/cn/detail/@ohos%2Fmp4parser)来使用FFmpeg命令。  

### 参考资料  

  [video_trimmer](https://ohpm.openharmony.cn/#/cn/detail/@ohos%2Fvideotrimmer)源码      
  [XComponent组件](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-arkui/arkui-ts/ts-basic-components-xcomponent.md)   
  [mp4parser](https://ohpm.openharmony.cn/#/cn/detail/@ohos%2Fmp4parser)    
  [上传下载](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-basic-services-kit/js-apis-request.md)

### 相关权限

| 权限名                                    | 权限说明                       | 级别         |
|----------------------------------------|----------------------------| ------------ |
| ohos.permission.INTERNET               | 允许访问网络。                    | normal       |
| ohos.permission.READ_MEDIA     | 允许应用读取用户外部存储中的媒体文件信息。  | normal       |
| ohos.permission.WRITE_MEDIA       | 允许应用读写用户外部存储中的媒体文件信息。 | normal |
| ohos.permission.CAMERA | 允许应用使用相机。             | normal       |


### 依赖

- 不涉及

### 约束与限制

1.本示例仅支持标准系统上运行,支持设备：手机。

2.本示例为Stage模型，支持API12版本SDK，SDK版本号（API Version 12 Release）。

3.本示例需要使用DevEco Studio版本号（DevEco Studio 5.0.0 Release）及以上版本才可编译运行。


### 下载
如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/BasicFeature/Media/videotrimmer/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```