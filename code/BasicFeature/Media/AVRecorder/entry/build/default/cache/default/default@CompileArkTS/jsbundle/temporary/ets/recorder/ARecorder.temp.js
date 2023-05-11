var _dc2c5df44f596112a82eb663dbdeca82;
/******/ (() => { // webpackBootstrap
/******/ 	"use strict";
/******/ 	var __webpack_modules__ = ({

/***/ "D:\\0510sample\\applications_app_samples_0510\\code\\BasicFeature\\Media\\AVRecorder\\entry\\src\\main\\ets\\recorder\\ARecorder.ets?entry":
/*!**************************************************************************************************************************************!*\
  !*** D:\0510sample\applications_app_samples_0510\code\BasicFeature\Media\AVRecorder\entry\src\main\ets\recorder\ARecorder.ets?entry ***!
  \**************************************************************************************************************************************/
/***/ (function(__unused_webpack_module, exports, __webpack_require__) {


var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", ({ value: true }));
let __generate__Id = 0;
function generateId() {
    return "ARecorder_" + ++__generate__Id;
}
/*
 * Copyright (C) 2023 Huawei Device Co., Ltd.
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
var _ohos_multimedia_media_1  = globalThis.requireNapi('multimedia.media') || (isSystemplugin('multimedia.media', 'ohos') ? globalThis.ohosplugin.multimedia.media : isSystemplugin('multimedia.media', 'system') ? globalThis.systemplugin.multimedia.media : undefined);
const DateTimeUtils_1 = __webpack_require__(/*! ../utils/DateTimeUtils */ "D:\\0510sample\\applications_app_samples_0510\\code\\BasicFeature\\Media\\AVRecorder\\entry\\src\\main\\ets\\utils\\DateTimeUtils.ets");
const Logger_1 = __importDefault(__webpack_require__(/*! ../utils/Logger */ "D:\\0510sample\\applications_app_samples_0510\\code\\BasicFeature\\Media\\AVRecorder\\entry\\src\\main\\ets\\utils\\Logger.ets"));
const SaveCameraAsset_1 = __importDefault(__webpack_require__(/*! ../utils/SaveCameraAsset */ "D:\\0510sample\\applications_app_samples_0510\\code\\BasicFeature\\Media\\AVRecorder\\entry\\src\\main\\ets\\utils\\SaveCameraAsset.ets"));
const TAG = 'Sample_AudioRecorder';
class audioRecording extends View {
    constructor(compilerAssignedUniqueChildId, parent, params) {
        super(compilerAssignedUniqueChildId, parent);
        this.audioRecorder = undefined;
        this.fdPath = undefined;
        this.__frameRate = new ObservedPropertySimple(15, this, "frameRate");
        this.__audioRecorderTimeText = new ObservedPropertySimple('00:00', this, "audioRecorderTimeText");
        this.seconds = 0;
        this.timer = 0;
        this.__displayLog = new ObservedPropertySimple(undefined, this, "displayLog");
        this.recorderState = 'free';
        this.__isStartRecording = new ObservedPropertySimple(false, this, "isStartRecording");
        this.__isPauseRecording = new ObservedPropertySimple(false, this, "isPauseRecording");
        this.mSaveCameraAsset = new SaveCameraAsset_1.default(TAG);
        this.mFileAssetId = 0;
        this.__audioChannels = new ObservedPropertySimple(2, this, "audioChannels");
        this.__audioSampleRate = new ObservedPropertySimple(48000, this, "audioSampleRate");
        this.avProfile = {
            audioBitrate: 48000,
            audioChannels: 2,
            audioCodec: _ohos_multimedia_media_1.CodecMimeType.AUDIO_AAC,
            audioSampleRate: 48000,
            fileFormat: _ohos_multimedia_media_1.ContainerFormatType.CFT_MPEG_4A, // set fileFormat, for video is m4a
        };
        this.avConfig = {
            audioSourceType: _ohos_multimedia_media_1.AudioSourceType.AUDIO_SOURCE_TYPE_MIC,
            profile: this.avProfile,
            url: 'fd://'
        };
        this.settingDialog = new CustomDialogController({
            builder: () => {
                let jsDialog = new CustomDialogSetting("2", this, {
                    cancel: this.onCancel,
                    confirm: this.onAccept,
                    audioChannels: this.__audioChannels,
                    audioSampleRate: this.__audioSampleRate,
                });
                jsDialog.setController(this.settingDialog);
                View.create(jsDialog);
            },
            cancel: this.existApp,
            autoCancel: false,
            alignment: DialogAlignment.Bottom,
            customStyle: true
        }, this);
        this.updateWithValueParams(params);
    }
    updateWithValueParams(params) {
        if (params.audioRecorder !== undefined) {
            this.audioRecorder = params.audioRecorder;
        }
        if (params.fdPath !== undefined) {
            this.fdPath = params.fdPath;
        }
        if (params.frameRate !== undefined) {
            this.frameRate = params.frameRate;
        }
        if (params.audioRecorderTimeText !== undefined) {
            this.audioRecorderTimeText = params.audioRecorderTimeText;
        }
        if (params.seconds !== undefined) {
            this.seconds = params.seconds;
        }
        if (params.timer !== undefined) {
            this.timer = params.timer;
        }
        if (params.displayLog !== undefined) {
            this.displayLog = params.displayLog;
        }
        if (params.recorderState !== undefined) {
            this.recorderState = params.recorderState;
        }
        if (params.isStartRecording !== undefined) {
            this.isStartRecording = params.isStartRecording;
        }
        if (params.isPauseRecording !== undefined) {
            this.isPauseRecording = params.isPauseRecording;
        }
        if (params.mSaveCameraAsset !== undefined) {
            this.mSaveCameraAsset = params.mSaveCameraAsset;
        }
        if (params.mFileAssetId !== undefined) {
            this.mFileAssetId = params.mFileAssetId;
        }
        if (params.audioChannels !== undefined) {
            this.audioChannels = params.audioChannels;
        }
        if (params.audioSampleRate !== undefined) {
            this.audioSampleRate = params.audioSampleRate;
        }
        if (params.avProfile !== undefined) {
            this.avProfile = params.avProfile;
        }
        if (params.avConfig !== undefined) {
            this.avConfig = params.avConfig;
        }
        if (params.settingDialog !== undefined) {
            this.settingDialog = params.settingDialog;
        }
    }
    aboutToBeDeleted() {
        this.__frameRate.aboutToBeDeleted();
        this.__audioRecorderTimeText.aboutToBeDeleted();
        this.__displayLog.aboutToBeDeleted();
        this.__isStartRecording.aboutToBeDeleted();
        this.__isPauseRecording.aboutToBeDeleted();
        this.__audioChannels.aboutToBeDeleted();
        this.__audioSampleRate.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id());
    }
    get frameRate() {
        return this.__frameRate.get();
    }
    set frameRate(newValue) {
        this.__frameRate.set(newValue);
    }
    get audioRecorderTimeText() {
        return this.__audioRecorderTimeText.get();
    }
    set audioRecorderTimeText(newValue) {
        this.__audioRecorderTimeText.set(newValue);
    }
    get displayLog() {
        return this.__displayLog.get();
    }
    set displayLog(newValue) {
        this.__displayLog.set(newValue);
    }
    get isStartRecording() {
        return this.__isStartRecording.get();
    }
    set isStartRecording(newValue) {
        this.__isStartRecording.set(newValue);
    }
    get isPauseRecording() {
        return this.__isPauseRecording.get();
    }
    set isPauseRecording(newValue) {
        this.__isPauseRecording.set(newValue);
    }
    get audioChannels() {
        return this.__audioChannels.get();
    }
    set audioChannels(newValue) {
        this.__audioChannels.set(newValue);
    }
    get audioSampleRate() {
        return this.__audioSampleRate.get();
    }
    set audioSampleRate(newValue) {
        this.__audioSampleRate.set(newValue);
    }
    aboutToAppear() {
        Logger_1.default.info(TAG, 'aboutToAppear called');
        Logger_1.default.info(TAG, 'aboutToAppear done');
    }
    aboutToDisappear() {
        Logger_1.default.info(TAG, 'aboutToDisappear called');
        Logger_1.default.info(TAG, 'aboutToDisappear done');
    }
    async failureCallback(error) {
        Logger_1.default.info(TAG, 'case failureCallback called,errMessage is ' + error.message);
    }
    async catchCallback(error) {
        Logger_1.default.info(TAG, 'case catchCallback called,errMessage is ' + error.message);
    }
    // show recording time
    getRecordTime() {
        this.timer = setInterval(() => {
            this.seconds += 1;
            this.audioRecorderTimeText = DateTimeUtils_1.dateTime(this.seconds);
        }, 1000);
    }
    // create file fd
    async getFileFd() {
        Logger_1.default.info(TAG, 'getFileFd called');
        this.mFileAssetId = await this.mSaveCameraAsset.createAudioFd();
        this.fdPath = 'fd://' + this.mFileAssetId.toString();
        this.avConfig.url = this.fdPath;
        Logger_1.default.info(TAG, 'fdPath is: ' + this.fdPath);
        Logger_1.default.info(TAG, 'getFileFd done');
    }
    async createAudioRecorder() {
        await _ohos_multimedia_media_1.createAVRecorder().then((recorder) => {
            Logger_1.default.info(TAG, 'case createAVRecorder called');
            if (typeof (recorder) !== 'undefined') {
                this.audioRecorder = recorder;
            }
            else {
                Logger_1.default.info(TAG, 'case create avRecorder failed!!!');
                return;
            }
        }, this.failureCallback).catch(this.catchCallback);
        this.setCallback();
    }
    // set callback on
    setCallback() {
        Logger_1.default.info(TAG, 'case callback');
        this.audioRecorder.on('stateChange', (state, reason) => {
            Logger_1.default.info(TAG, 'case state has changed, new state is' + state);
            switch (state) {
                case 'idle':
                    this.recorderState = 'idle';
                    break;
                case 'prepared':
                    this.recorderState = 'prepared';
                    break;
                case 'started':
                    this.recorderState = 'started';
                    this.getRecordTime();
                    this.isStartRecording = true;
                    this.isPauseRecording = false;
                    break;
                case 'paused':
                    this.recorderState = 'paused';
                    clearInterval(this.timer);
                    this.isPauseRecording = true;
                    break;
                case 'stopped':
                    this.recorderState = 'stopped';
                    this.isStartRecording = false;
                    break;
                case 'released':
                    this.recorderState = 'released';
                    break;
                case 'error':
                    Logger_1.default.info(TAG, 'case error state!!!');
                    this.recorderState = 'error';
                    break;
                default:
                    Logger_1.default.info(TAG, 'case start is unknown');
                    break;
            }
        });
        this.audioRecorder.on('error', (err) => {
            Logger_1.default.info(TAG, 'case avRecorder.on(error) called, errMessage is ' + err.message);
        });
    }
    async prepareAudioRecorder() {
        Logger_1.default.info(TAG, 'case prepareAudioRecorder in');
        this.avConfig.profile.audioChannels = this.audioChannels;
        this.avConfig.profile.audioSampleRate = this.audioSampleRate;
        await this.audioRecorder.prepare(this.avConfig).then(() => {
            Logger_1.default.info(TAG, 'case prepare AVRecorder called');
        }, this.failureCallback).catch(this.catchCallback);
        Logger_1.default.info(TAG, 'case prepareAudioRecorder out');
    }
    async startAudioRecording() {
        Logger_1.default.info(TAG, 'case startAudioRecording called');
        await this.audioRecorder.start().then(() => {
            Logger_1.default.info(TAG, 'case start AudioRecorder called');
        }, this.failureCallback).catch(this.catchCallback);
    }
    async pauseAudioRecording() {
        Logger_1.default.info(TAG, 'case pauseAudioRecording called');
        await this.audioRecorder.pause().then(() => {
            Logger_1.default.info(TAG, 'case pause AudioRecorder called');
        }, this.failureCallback).catch(this.catchCallback);
    }
    async resumeAudioRecording() {
        Logger_1.default.info(TAG, 'case resumeAudioRecording called');
        await this.audioRecorder.resume().then(() => {
            Logger_1.default.info(TAG, 'case resume AudioRecorder called');
        }, this.failureCallback).catch(this.catchCallback);
    }
    async stopAudioRecording() {
        Logger_1.default.info(TAG, 'case stopAudioRecording called');
        await this.audioRecorder.stop().then(() => {
            Logger_1.default.info(TAG, 'case stop AudioRecorder called');
        }, this.failureCallback).catch(this.catchCallback);
    }
    async resetAudioRecording() {
        await this.audioRecorder.reset().then(() => {
            Logger_1.default.info(TAG, 'case resetAudioRecording called');
        }, this.failureCallback).catch(this.catchCallback);
    }
    async releaseAudioRecorder() {
        if (this.audioRecorder) {
            this.audioRecorder.off('stateChange');
            this.audioRecorder.off('error');
            await this.audioRecorder.release().then(() => {
                Logger_1.default.info(TAG, 'case releaseAudioRecorder called');
            }, this.failureCallback).catch(this.catchCallback);
            this.audioRecorder = undefined;
        }
    }
    // close file fd
    async closeFd() {
        Logger_1.default.info(TAG, 'case closeFd called');
        if (this.fdPath) {
            await this.mSaveCameraAsset.AudioPrepareFile.close(this.mFileAssetId);
            this.mFileAssetId = undefined;
            this.fdPath = undefined;
            Logger_1.default.info(TAG, 'case closeFd done');
        }
    }
    // start button process
    async startRecordingProcess() {
        Logger_1.default.info(TAG, 'startRecording called');
        if (this.audioRecorder) {
            Logger_1.default.info(TAG, 'audioRecorder exist,release it');
            await this.audioRecorder.release();
        }
        await this.createAudioRecorder();
        await this.getFileFd();
        await this.prepareAudioRecorder();
        await this.startAudioRecording();
        Logger_1.default.info(TAG, 'startRecording done');
    }
    // pause button process
    async pauseRecordingProcess() {
        Logger_1.default.info(TAG, 'pauseRecording called');
        if (this.recorderState === 'started') {
            Logger_1.default.info(TAG, 'current state is started, to pause');
            await this.pauseAudioRecording();
        }
        Logger_1.default.info(TAG, 'pauseRecording done');
    }
    // resume button process
    async resumeRecordingProcess() {
        Logger_1.default.info(TAG, 'resumeRecording called');
        if (this.recorderState === 'paused') {
            Logger_1.default.info(TAG, 'current state is paused, to resume');
            await this.resumeAudioRecording();
        }
        Logger_1.default.info(TAG, 'resumeRecording done');
    }
    // stop button process
    async stopRecordingProcess() {
        Logger_1.default.info(TAG, 'stopRecording called');
        if (this.recorderState === 'started' || this.recorderState === 'paused') {
            await this.stopAudioRecording();
        }
        await this.resetAudioRecording();
        await this.releaseAudioRecorder();
        await this.closeFd();
        clearInterval(this.timer);
        this.isStartRecording = false;
        this.isPauseRecording = false;
        this.seconds = 0;
        this.audioRecorderTimeText = '00:00';
        Logger_1.default.info(TAG, 'stopRecording done');
    }
    render() {
        Column.create();
        Row.create();
        Row.backgroundColor(Color.Black);
        Stack.create({ alignContent: Alignment.Center });
        Stack.width('100%');
        Stack.height('100%');
        Text.create(this.audioRecorderTimeText);
        Text.fontFamily('HarmonyHeiTi-Light');
        Text.width(70);
        Text.height(40);
        Text.fontSize(27);
        Text.fontColor('white');
        Text.margin({ left: 99, top: 13, right: 79, bottom: 703 });
        Text.pop();
        If.create();
        if (!this.isStartRecording) {
            If.branchId(0);
            Image.create({ "id": 16777235, "type": 20000, params: [], "bundleName": "com.samples.avrecorder", "moduleName": "entry" });
            Image.width(40);
            Image.height(40);
            Image.margin({ left: 12, top: 12, right: 308, bottom: 704 });
            Image.onClick(() => {
                if (this.settingDialog !== undefined) {
                    Logger_1.default.info(TAG, 'to open setting dialog');
                    this.settingDialog.open();
                }
            });
            Image.id('audioSetting');
            Image.create({ "id": 16777234, "type": 20000, params: [], "bundleName": "com.samples.avrecorder", "moduleName": "entry" });
            Image.width(12);
            Image.height(12);
            Image.margin({ left: 136, top: 25, right: 212, bottom: 715 });
            Image.create({ "id": 16777239, "type": 20000, params: [], "bundleName": "com.samples.avrecorder", "moduleName": "entry" });
            Image.width(86);
            Image.height(86);
            Image.margin({ left: 132, top: 612, right: 132, bottom: 72 });
            Image.onClick(() => this.startRecordingProcess());
            Image.id('audioStart');
        }
        else {
            If.branchId(1);
            Image.create({ "id": 16777231, "type": 20000, params: [], "bundleName": "com.samples.avrecorder", "moduleName": "entry" });
            Image.width(120);
            Image.height(56);
            Image.margin({ left: 120, top: 632, right: 120, bottom: 92 });
            Image.create({ "id": 16777237, "type": 20000, params: [], "bundleName": "com.samples.avrecorder", "moduleName": "entry" });
            Image.width(16);
            Image.height(16);
            Image.margin({ left: 146, top: 652, right: 198, bottom: 112 });
            Image.onClick(() => this.stopRecordingProcess());
            Image.id('audioStop');
            If.create();
            if (!this.isPauseRecording) {
                If.branchId(0);
                Image.create({ "id": 16777234, "type": 20000, params: [], "bundleName": "com.samples.avrecorder", "moduleName": "entry" });
                Image.width(12);
                Image.height(12);
                Image.margin({ left: 136, top: 25, right: 212, bottom: 715 });
                Image.create({ "id": 16777233, "type": 20000, params: [], "bundleName": "com.samples.avrecorder", "moduleName": "entry" });
                Image.width(14);
                Image.height(15);
                Image.margin({ left: 200, top: 652, right: 146, bottom: 113 });
                Image.onClick(() => this.pauseRecordingProcess());
                Image.id('audioPause');
            }
            else {
                If.branchId(1);
                Image.create({ "id": 16777236, "type": 20000, params: [], "bundleName": "com.samples.avrecorder", "moduleName": "entry" });
                Image.width(14);
                Image.height(14);
                Image.margin({ left: 136, top: 25, right: 212, bottom: 715 });
                Image.create({ "id": 16777232, "type": 20000, params: [], "bundleName": "com.samples.avrecorder", "moduleName": "entry" });
                Image.width(16);
                Image.height(16);
                Image.margin({ left: 198, top: 651, right: 144, bottom: 111 });
                Image.onClick(() => this.resumeRecordingProcess());
                Image.id('audioResume');
            }
            If.pop();
        }
        If.pop();
        Stack.pop();
        Row.pop();
        Column.pop();
    }
    onCancel() {
        Logger_1.default.info(TAG, 'Callback when the cancel button is clicked');
    }
    onAccept() {
        Logger_1.default.info(TAG, 'Callback when the confirm button is clicked');
    }
    existApp() {
        Logger_1.default.info(TAG, 'Click the callback in the blank area');
    }
}
class CustomDialogSetting extends View {
    constructor(compilerAssignedUniqueChildId, parent, params) {
        super(compilerAssignedUniqueChildId, parent);
        this.__audioChannels = new SynchedPropertySimpleTwoWay(params.audioChannels, this, "audioChannels");
        this.__audioSampleRate = new SynchedPropertySimpleTwoWay(params.audioSampleRate, this, "audioSampleRate");
        this.controller = undefined;
        this.cancel = undefined;
        this.confirm = undefined;
        this.__currentAudioChannels = new ObservedPropertySimple(2, this, "currentAudioChannels");
        this.__currentAudioSampleRate = new ObservedPropertySimple(48000, this, "currentAudioSampleRate");
        this.initAudioChannels = this.audioChannels;
        this.initAudioSampleRate = this.audioSampleRate;
        this.__audioChannelsList = new ObservedPropertyObject([1, 2], this, "audioChannelsList");
        this.__audioSampleRateList = new ObservedPropertyObject([8000, 22050, 32000, 44100, 48000, 96000], this, "audioSampleRateList");
        this.updateWithValueParams(params);
    }
    updateWithValueParams(params) {
        if (params.controller !== undefined) {
            this.controller = params.controller;
        }
        if (params.cancel !== undefined) {
            this.cancel = params.cancel;
        }
        if (params.confirm !== undefined) {
            this.confirm = params.confirm;
        }
        if (params.currentAudioChannels !== undefined) {
            this.currentAudioChannels = params.currentAudioChannels;
        }
        if (params.currentAudioSampleRate !== undefined) {
            this.currentAudioSampleRate = params.currentAudioSampleRate;
        }
        if (params.initAudioChannels !== undefined) {
            this.initAudioChannels = params.initAudioChannels;
        }
        if (params.initAudioSampleRate !== undefined) {
            this.initAudioSampleRate = params.initAudioSampleRate;
        }
        if (params.audioChannelsList !== undefined) {
            this.audioChannelsList = params.audioChannelsList;
        }
        if (params.audioSampleRateList !== undefined) {
            this.audioSampleRateList = params.audioSampleRateList;
        }
    }
    aboutToBeDeleted() {
        this.__audioChannels.aboutToBeDeleted();
        this.__audioSampleRate.aboutToBeDeleted();
        this.__currentAudioChannels.aboutToBeDeleted();
        this.__currentAudioSampleRate.aboutToBeDeleted();
        this.__audioChannelsList.aboutToBeDeleted();
        this.__audioSampleRateList.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id());
    }
    get audioChannels() {
        return this.__audioChannels.get();
    }
    set audioChannels(newValue) {
        this.__audioChannels.set(newValue);
    }
    get audioSampleRate() {
        return this.__audioSampleRate.get();
    }
    set audioSampleRate(newValue) {
        this.__audioSampleRate.set(newValue);
    }
    setController(ctr) {
        this.controller = ctr;
    }
    get currentAudioChannels() {
        return this.__currentAudioChannels.get();
    }
    set currentAudioChannels(newValue) {
        this.__currentAudioChannels.set(newValue);
    }
    get currentAudioSampleRate() {
        return this.__currentAudioSampleRate.get();
    }
    set currentAudioSampleRate(newValue) {
        this.__currentAudioSampleRate.set(newValue);
    }
    get audioChannelsList() {
        return this.__audioChannelsList.get();
    }
    set audioChannelsList(newValue) {
        this.__audioChannelsList.set(newValue);
    }
    get audioSampleRateList() {
        return this.__audioSampleRateList.get();
    }
    set audioSampleRateList(newValue) {
        this.__audioSampleRateList.set(newValue);
    }
    render() {
        Column.create();
        Column.margin({ left: 12, right: 12, bottom: 12 });
        Column.backgroundColor('#FFFFFF');
        Column.borderRadius(32);
        Column.alignItems(HorizontalAlign.Center);
        Column.create();
        Column.alignItems(HorizontalAlign.Start);
        Text.create({ "id": 16777220, "type": 10003, params: [], "bundleName": "com.samples.avrecorder", "moduleName": "entry" });
        Text.fontFamily('HarmonyHeiTi-Medium');
        Text.fontSize(20);
        Text.width(288);
        Text.height(26);
        Text.margin({ left: 24, right: 24, top: 16 });
        Text.pop();
        Column.create();
        Column.margin({ left: 24, right: 24, top: 16 });
        List.create({ space: 10 });
        List.listDirection(Axis.Vertical);
        List.divider({ strokeWidth: 0.5, color: '#EEEEEE', startMargin: 0, endMargin: 0 });
        ForEach.create("3", this, ObservedObject.GetRawObject(this.audioSampleRateList), (item, index) => {
            ListItem.create();
            Row.create();
            Row.margin({ left: 0, right: 39 });
            Text.create({ "id": 16777221, "type": 10003, params: [], "bundleName": "com.samples.avrecorder", "moduleName": "entry" });
            Text.fontSize(16);
            Text.pop();
            Text.create(item.toString());
            Text.fontSize(16);
            Text.width(160);
            Text.pop();
            If.create();
            if (item == this.initAudioSampleRate) {
                If.branchId(0);
                Radio.create({ value: item.toString(), group: 'radioGroup2' });
                Radio.checked(true);
                Radio.height(20);
                Radio.id(item.toString());
                Radio.onChange((isChecked) => {
                    if (isChecked) {
                        Logger_1.default.info(TAG, item.toString() + ' audioSample is chosen');
                        this.currentAudioSampleRate = item;
                    }
                });
            }
            else {
                If.branchId(1);
                Radio.create({ value: item.toString(), group: 'radioGroup2' });
                Radio.checked(false);
                Radio.height(20);
                Radio.onChange((isChecked) => {
                    if (isChecked) {
                        Logger_1.default.info(TAG, item.toString() + ' audioSample is chosen');
                        this.currentAudioSampleRate = item;
                    }
                });
            }
            If.pop();
            Row.pop();
            ListItem.pop();
        });
        ForEach.pop();
        List.pop();
        Column.pop();
        Column.pop();
        Row.create();
        Row.width(300);
        Row.height(40);
        Row.margin({ top: 12, bottom: 16 });
        Button.createWithLabel({ "id": 16777222, "type": 10003, params: [], "bundleName": "com.samples.avrecorder", "moduleName": "entry" });
        Button.onClick(() => {
            this.audioChannels = this.initAudioChannels;
            this.audioSampleRate = this.initAudioSampleRate;
            this.controller.close();
            this.cancel();
        });
        Button.backgroundColor('#FFFFFF');
        Button.fontColor('#007DFF');
        Button.fontFamily('HarmonyHeiTi-Medium');
        Button.fontSize(16);
        Button.id('cancel');
        Button.layoutWeight(1);
        Button.pop();
        Divider.create();
        Divider.vertical(true);
        Divider.height(24);
        Divider.color('#182431');
        Divider.opacity(0.6);
        Divider.margin({ left: 8, right: 8 });
        Button.createWithLabel({ "id": 16777223, "type": 10003, params: [], "bundleName": "com.samples.avrecorder", "moduleName": "entry" });
        Button.onClick(() => {
            this.audioChannels = this.currentAudioChannels;
            this.audioSampleRate = this.currentAudioSampleRate;
            this.controller.close();
            this.confirm();
        });
        Button.backgroundColor('#FFFFFF');
        Button.fontColor('#007DFF');
        Button.fontFamily('HarmonyHeiTi-Medium');
        Button.fontSize(16);
        Button.id('confirm');
        Button.layoutWeight(1);
        Button.pop();
        Row.pop();
        Column.pop();
    }
}
loadDocument(new audioRecording("1", undefined, {}));


/***/ }),

/***/ "D:\\0510sample\\applications_app_samples_0510\\code\\BasicFeature\\Media\\AVRecorder\\entry\\src\\main\\ets\\utils\\DateTimeUtils.ets":
/*!*********************************************************************************************************************************!*\
  !*** D:\0510sample\applications_app_samples_0510\code\BasicFeature\Media\AVRecorder\entry\src\main\ets\utils\DateTimeUtils.ets ***!
  \*********************************************************************************************************************************/
/***/ ((__unused_webpack_module, exports) => {


Object.defineProperty(exports, "__esModule", ({ value: true }));
exports.dateTime = exports.getShownTimer = void 0;
let __generate__Id = 0;
function generateId() {
    return "DateTimeUtils_" + ++__generate__Id;
}
/*
 * Copyright (C) 2023 Huawei Device Co., Ltd.
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
class DateTimeUtil {
    getTime() {
        const DATETIME = new Date();
        return this.concatTime(DATETIME.getHours(), DATETIME.getMinutes(), DATETIME.getSeconds());
    }
    getDate() {
        const DATETIME = new Date();
        return this.concatDate(DATETIME.getFullYear(), DATETIME.getMonth() + 1, DATETIME.getDate());
    }
    fill(value) {
        return (value > 9 ? '' : '0') + value;
    }
    concatDate(year, month, date) {
        return `${year}${month}${date}`;
    }
    concatTime(hour, minute, second) {
        return `${this.fill(hour)}${this.fill(minute)}${this.fill(second)}`;
    }
}
exports["default"] = DateTimeUtil;
function getShownTimer(ms) {
    let seconds = Math.round(ms / 1000);
    let sec = seconds % 60;
    let min = (seconds - sec) / 60;
    if (sec < 10) {
        sec = '0' + sec;
    }
    if (min < 10) {
        min = '0' + min;
    }
    return min + ':' + sec;
}
exports.getShownTimer = getShownTimer;
function dateTime(t) {
    let minute = Math.floor(t / 60) % 60;
    let m = minute < 10 ? '0' + minute : minute;
    let second = t % 60;
    let s = second < 10 ? '0' + second : second;
    return m + ':' + s;
}
exports.dateTime = dateTime;


/***/ }),

/***/ "D:\\0510sample\\applications_app_samples_0510\\code\\BasicFeature\\Media\\AVRecorder\\entry\\src\\main\\ets\\utils\\Logger.ets":
/*!**************************************************************************************************************************!*\
  !*** D:\0510sample\applications_app_samples_0510\code\BasicFeature\Media\AVRecorder\entry\src\main\ets\utils\Logger.ets ***!
  \**************************************************************************************************************************/
/***/ (function(__unused_webpack_module, exports) {


var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", ({ value: true }));
let __generate__Id = 0;
function generateId() {
    return "Logger_" + ++__generate__Id;
}
/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
var _ohos_hilog_1  = globalThis.requireNapi('hilog') || (isSystemplugin('hilog', 'ohos') ? globalThis.ohosplugin.hilog : isSystemplugin('hilog', 'system') ? globalThis.systemplugin.hilog : undefined);
class Logger {
    constructor(prefix) {
        this.format = "%{public}s, %{public}s";
        this.prefix = prefix;
        this.domain = 0xFF00;
    }
    debug(...args) {
        _ohos_hilog_1.debug(this.domain, this.prefix, this.format, args);
    }
    info(...args) {
        _ohos_hilog_1.info(this.domain, this.prefix, this.format, args);
    }
    warn(...args) {
        _ohos_hilog_1.warn(this.domain, this.prefix, this.format, args);
    }
    error(...args) {
        _ohos_hilog_1.error(this.domain, this.prefix, this.format, args);
    }
}
exports["default"] = new Logger('AVRecorderSample');


/***/ }),

/***/ "D:\\0510sample\\applications_app_samples_0510\\code\\BasicFeature\\Media\\AVRecorder\\entry\\src\\main\\ets\\utils\\SaveCameraAsset.ets":
/*!***********************************************************************************************************************************!*\
  !*** D:\0510sample\applications_app_samples_0510\code\BasicFeature\Media\AVRecorder\entry\src\main\ets\utils\SaveCameraAsset.ets ***!
  \***********************************************************************************************************************************/
/***/ (function(__unused_webpack_module, exports, __webpack_require__) {


var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", ({ value: true }));
let __generate__Id = 0;
function generateId() {
    return "SaveCameraAsset_" + ++__generate__Id;
}
/*
 * Copyright (C) 2023 Huawei Device Co., Ltd.
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
var _ohos_multimedia_mediaLibrary_1  = globalThis.requireNapi('multimedia.mediaLibrary') || (isSystemplugin('multimedia.mediaLibrary', 'ohos') ? globalThis.ohosplugin.multimedia.mediaLibrary : isSystemplugin('multimedia.mediaLibrary', 'system') ? globalThis.systemplugin.multimedia.mediaLibrary : undefined);
const DateTimeUtils_1 = __importDefault(__webpack_require__(/*! ./DateTimeUtils */ "D:\\0510sample\\applications_app_samples_0510\\code\\BasicFeature\\Media\\AVRecorder\\entry\\src\\main\\ets\\utils\\DateTimeUtils.ets"));
const Logger_1 = __importDefault(__webpack_require__(/*! ./Logger */ "D:\\0510sample\\applications_app_samples_0510\\code\\BasicFeature\\Media\\AVRecorder\\entry\\src\\main\\ets\\utils\\Logger.ets"));
class SaveCameraAsset {
    constructor(tag) {
        this.lastSaveTime = '';
        this.saveIndex = 0;
        this.tag = tag;
    }
    async createVideoFd() {
        Logger_1.default.info(this.tag, 'get Recorder File Fd');
        const mDateTimeUtil = new DateTimeUtils_1.default();
        const displayName = this.checkName(`REC_${mDateTimeUtil.getDate()}_${mDateTimeUtil.getTime()}`) + '.mp4';
        Logger_1.default.info(this.tag, 'get Recorder display name is: ' + displayName);
        const media = _ohos_multimedia_mediaLibrary_1.getMediaLibrary(globalThis.abilityContext);
        Logger_1.default.info(this.tag, 'get Recorder File Fd publicPath');
        const fileKeyObj = _ohos_multimedia_mediaLibrary_1.FileKey;
        const mediaType = _ohos_multimedia_mediaLibrary_1.MediaType.VIDEO;
        let publicPath = await media.getPublicDirectory(_ohos_multimedia_mediaLibrary_1.DirectoryType.DIR_VIDEO);
        Logger_1.default.info(this.tag, 'get Recorder File publicPath: ' + JSON.stringify(publicPath));
        try {
            const dataUri = await media.createAsset(mediaType, displayName, publicPath);
            Logger_1.default.info(this.tag, 'get Recorder dataUri is: ' + dataUri);
            if (dataUri != undefined) {
                Logger_1.default.info(this.tag, 'dataUri is undefined');
                const args = dataUri.id.toString();
                const fetchOp = {
                    selections: fileKeyObj.ID + "=?",
                    selectionArgs: [args],
                };
                Logger_1.default.info(this.tag, 'fetchOp= ' + JSON.stringify(fetchOp));
                const fetchFileResult = await media.getFileAssets(fetchOp);
                Logger_1.default.info(this.tag, 'getFileAssets finished');
                this.VideoPrepareFile = await fetchFileResult.getFirstObject();
                const fdNumber = await this.VideoPrepareFile.open('rw');
                Logger_1.default.info(this.tag, 'get Recorder File fd is: ' + JSON.stringify(fdNumber));
                return fdNumber;
            }
        }
        catch (err) {
            Logger_1.default.error(this.tag, 'create Recorder File Fd ERROR: ' + err);
        }
    }
    async createAudioFd() {
        Logger_1.default.info(this.tag, 'get Recorder File Fd');
        const mDateTimeUtil = new DateTimeUtils_1.default();
        const displayName = this.checkName(`REC_${mDateTimeUtil.getDate()}_${mDateTimeUtil.getTime()}`) + '.m4a';
        Logger_1.default.info(this.tag, 'get Recorder display name is: ' + displayName);
        const media = _ohos_multimedia_mediaLibrary_1.getMediaLibrary(globalThis.abilityContext);
        Logger_1.default.info(this.tag, 'get Recorder File Fd publicPath');
        const fileKeyObj = _ohos_multimedia_mediaLibrary_1.FileKey;
        const mediaType = _ohos_multimedia_mediaLibrary_1.MediaType.AUDIO;
        let publicPath = await media.getPublicDirectory(_ohos_multimedia_mediaLibrary_1.DirectoryType.DIR_AUDIO);
        Logger_1.default.info(this.tag, 'get Recorder File publicPath: ' + JSON.stringify(publicPath));
        try {
            const dataUri = await media.createAsset(mediaType, displayName, publicPath);
            Logger_1.default.info(this.tag, 'get Recorder dataUri is: ' + dataUri);
            if (dataUri != undefined) {
                Logger_1.default.info(this.tag, 'dataUri is undefined');
                const args = dataUri.id.toString();
                const fetchOp = {
                    selections: fileKeyObj.ID + "=?",
                    selectionArgs: [args],
                };
                Logger_1.default.info(this.tag, 'fetchOp= ' + JSON.stringify(fetchOp));
                const fetchFileResult = await media.getFileAssets(fetchOp);
                Logger_1.default.info(this.tag, 'getFileAssets finished');
                this.AudioPrepareFile = await fetchFileResult.getFirstObject();
                const fdNumber = await this.AudioPrepareFile.open('rw');
                Logger_1.default.info(this.tag, 'get Recorder File fd is: ' + JSON.stringify(fdNumber));
                return fdNumber;
            }
        }
        catch (err) {
            Logger_1.default.error(this.tag, 'create Recorder File Fd ERROR: ' + err);
        }
    }
    checkName(name) {
        if (this.lastSaveTime == name) {
            this.saveIndex += 1;
            return `${name}_${this.saveIndex}`;
        }
        this.lastSaveTime = name;
        this.saveIndex = 0;
        Logger_1.default.info(this.tag, 'get Recorder File name is: ' + name);
        return name;
    }
}
exports["default"] = SaveCameraAsset;


/***/ })

/******/ 	});
/************************************************************************/
/******/ 	// The module cache
/******/ 	var __webpack_module_cache__ = {};
/******/ 	
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/ 		var commonCachedModule = globalThis["__common_module_cache___dc2c5df44f596112a82eb663dbdeca82"] ? globalThis["__common_module_cache___dc2c5df44f596112a82eb663dbdeca82"][moduleId]: null;
/******/ 		if (commonCachedModule) { return commonCachedModule.exports; }
/******/ 		// Check if module is in cache
/******/ 		var cachedModule = __webpack_module_cache__[moduleId];
/******/ 		if (cachedModule !== undefined) {
/******/ 			return cachedModule.exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = __webpack_module_cache__[moduleId] = {
/******/ 			// no module.id needed
/******/ 			// no module.loaded needed
/******/ 			exports: {}
/******/ 		};
/******/ 	
/******/ 		function isCommonModue(moduleId) {
/******/ 		                if (globalThis["webpackChunk_dc2c5df44f596112a82eb663dbdeca82"]) {
/******/ 		                  const length = globalThis["webpackChunk_dc2c5df44f596112a82eb663dbdeca82"].length;
/******/ 		                  switch (length) {
/******/ 		                    case 1:
/******/ 		                      return globalThis["webpackChunk_dc2c5df44f596112a82eb663dbdeca82"][0][1][moduleId];
/******/ 		                    case 2:
/******/ 		                      return globalThis["webpackChunk_dc2c5df44f596112a82eb663dbdeca82"][0][1][moduleId] ||
/******/ 		                      globalThis["webpackChunk_dc2c5df44f596112a82eb663dbdeca82"][1][1][moduleId];
/******/ 		                  }
/******/ 		                }
/******/ 		                return undefined;
/******/ 		              }
/******/ 		if (globalThis["__common_module_cache___dc2c5df44f596112a82eb663dbdeca82"] && String(moduleId).indexOf("?name=") < 0 && isCommonModue(moduleId)) {
/******/ 		  globalThis["__common_module_cache___dc2c5df44f596112a82eb663dbdeca82"][moduleId] = module;
/******/ 		}
/******/ 		__webpack_modules__[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/ 	
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/ 	
/************************************************************************/
/******/ 	
/******/ 	// startup
/******/ 	// Load entry module and return exports
/******/ 	// This entry module is referenced by other modules so it can't be inlined
/******/ 	var __webpack_exports__ = __webpack_require__("D:\\0510sample\\applications_app_samples_0510\\code\\BasicFeature\\Media\\AVRecorder\\entry\\src\\main\\ets\\recorder\\ARecorder.ets?entry");
/******/ 	_dc2c5df44f596112a82eb663dbdeca82 = __webpack_exports__;
/******/ 	
/******/ })()
;
//# sourceMappingURL=ARecorder.js.map