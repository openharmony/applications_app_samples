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

import { window } from '@kit.ArkUI';
import abilityAccessCtrl from '@ohos.abilityAccessCtrl';
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
// [Start import_module]
import { audio } from '@kit.AudioKit';
import { fileIo as fileio } from '@kit.CoreFileKit';
// [End import_module]

class OptionItem {
  label: string;
  value: number;

  constructor(label: string, value: number) {
    this.label = label;
    this.value = value;
  }
}



class JsStreamState {
  id: number;
  name: string;
  capturer: audio.AudioCapturer | null = null;
  recordFd: number = -1;
  readCallback: ((buffer: ArrayBuffer) => void) | null = null;
  playbackRenderer: audio.AudioRenderer | null = null;
  playbackFd: number = -1;
  source: number = audio.SourceType.SOURCE_TYPE_MIC;
  sampleRate: number = audio.AudioSamplingRate.SAMPLE_RATE_16000;
  channelCount: number = audio.AudioChannel.CHANNEL_1;
  sampleFormat: number = audio.AudioSampleFormat.SAMPLE_FORMAT_S16LE;
  stateText: string = 'Released';
  streamId: number = -1;
  bufferSize: number = 0;
  savedBytes: number = 0;
  savePath: string = '';
  saveRet: number = 0;
  captureSnapshotStatus: string = 'Capture snapshot not generated';
  captureSnapshotPath: string = '';
  captureSnapshotText: string = '';
  showCaptureSnapshotText: boolean = false;
  playbackSnapshotStatus: string = 'Playback snapshot not generated';
  playbackSnapshotPath: string = '';
  playbackSnapshotText: string = '';
  showPlaybackSnapshotText: boolean = false;
  playbackState: number = 0;
  playedBytes: number = 0;
  playTotalBytes: number = 0;
  lastRecordUiRefreshAt: number = 0;
  playbackAutoStopTimerId: number = -1;

  constructor(id: number, name: string, source: number, sampleRate: number) {
    this.id = id;
    this.name = name;
    this.source = source;
    this.sampleRate = sampleRate;
  }
}

class NativeStreamState {
  id: number;
  name: string;
  source: number = audio.SourceType.SOURCE_TYPE_MIC;
  sampleRate: number = audio.AudioSamplingRate.SAMPLE_RATE_16000;
  channelCount: number = audio.AudioChannel.CHANNEL_1;
  sampleFormat: number = audio.AudioSampleFormat.SAMPLE_FORMAT_S16LE;
  stateText: string = 'Released';
  streamRuntimeId: number = -1;
  bufferSize: number = 0;
  savedBytes: number = 0;
  savePath: string = '';
  saveRet: number = 0;
  callbackCount: number = 0;
  lastReadSize: number = 0;
  lastError: number = 0;
  captureSnapshotStatus: string = 'Capture snapshot not generated';
  captureSnapshotPath: string = '';
  captureSnapshotText: string = '';
  showCaptureSnapshotText: boolean = false;
  playbackSnapshotStatus: string = 'Playback snapshot not generated';
  playbackSnapshotPath: string = '';
  playbackSnapshotText: string = '';
  showPlaybackSnapshotText: boolean = false;
  playbackState: number = 0;
  playedBytes: number = 0;
  playTotalBytes: number = 0;
  playbackError: number = 0;
  useJsFallback: boolean = false;

  constructor(id: number, name: string, source: number, sampleRate: number) {
    this.id = id;
    this.name = name;
    this.source = source;
    this.sampleRate = sampleRate;
  }
}

interface NativeCapturerStats {
  state: number;
  streamId: number;
  latencyMode: number;
  fastStatus: number;
  frameSize: number;
  capturedBytes: number;
  callbackCount: number;
  lastReadSize: number;
  lastFastStatus: number;
  lastError: number;
  savedBytes: number;
}

interface NativePlayerStats {
  state: number;
  playedBytes: number;
  totalBytes: number;
  lastError: number;
}

interface NativeAudioNapi {
  lowLatencyCapturerInit: (
    streamId: number,
    sourceType: number,
    sampleRate: number,
    channelCount: number,
    sampleFormat: number
  ) => number;
  lowLatencyCapturerStart: (streamId: number) => number;
  lowLatencyCapturerStop: (streamId: number) => number;
  lowLatencyCapturerRelease: (streamId: number) => number;
  lowLatencyCapturerSetSaveFile: (streamId: number, path: string) => number;
  lowLatencyCapturerGetStats: (streamId: number) => NativeCapturerStats;
  lowLatencyCapturerResetStats: (streamId: number) => number;
  lowLatencyCapturerPrintSnapshot: (streamId: number, fd: number) => number;
  pcmPlayerStart: (
    streamId: number,
    path: string,
    sampleRate: number,
    channelCount: number,
    sampleFormat: number
  ) => number;
  pcmPlayerStop: (streamId: number) => number;
  pcmPlayerGetStats: (streamId: number) => NativePlayerStats;
  pcmPlayerPrintSnapshot: (streamId: number, fd: number) => number;
  audioDebuggingManagerPrintAppInfo: (fd: number) => number;
}

const SOURCE_OPTIONS: OptionItem[] = [
  new OptionItem('MIC', audio.SourceType.SOURCE_TYPE_MIC),
  new OptionItem('LIVE', audio.SourceType.SOURCE_TYPE_LIVE),
  new OptionItem('VOICE_COMM', audio.SourceType.SOURCE_TYPE_VOICE_COMMUNICATION),
  new OptionItem('VOICE_RECOGNITION', audio.SourceType.SOURCE_TYPE_VOICE_RECOGNITION),
];

const SAMPLE_RATE_OPTIONS: OptionItem[] = [
  new OptionItem('16000', audio.AudioSamplingRate.SAMPLE_RATE_16000),
  new OptionItem('44100', audio.AudioSamplingRate.SAMPLE_RATE_44100),
  new OptionItem('48000', audio.AudioSamplingRate.SAMPLE_RATE_48000),
];

const CHANNEL_OPTIONS: OptionItem[] = [
  new OptionItem('1ch', audio.AudioChannel.CHANNEL_1),
  new OptionItem('2ch', audio.AudioChannel.CHANNEL_2),
];

const SAMPLE_FORMAT_OPTIONS: OptionItem[] = [
  new OptionItem('S16LE', audio.AudioSampleFormat.SAMPLE_FORMAT_S16LE),
  new OptionItem('S24LE', audio.AudioSampleFormat.SAMPLE_FORMAT_S24LE),
  new OptionItem('S32LE', audio.AudioSampleFormat.SAMPLE_FORMAT_S32LE),
];

const PLAYBACK_USAGE_OPTIONS: OptionItem[] = [
  new OptionItem('MUSIC', audio.StreamUsage.STREAM_USAGE_MUSIC),
  new OptionItem('MEDIA', audio.StreamUsage.STREAM_USAGE_MEDIA),
  new OptionItem('VOICE_COMM', audio.StreamUsage.STREAM_USAGE_VOICE_COMMUNICATION),
];

interface PageItem {
  label: string;
  value: number;
}

const PAGE_OPTIONS: PageItem[] = [
  { label: 'TS流', value: 0 },
  { label: 'C流', value: 1 },
  { label: '快照中心', value: 2 },
];

@Entry
@Component
struct Index {
  private context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
  private audioManager: audio.AudioManager = audio.getAudioManager();
  private streamManager: audio.AudioStreamManager = this.audioManager.getStreamManager();
  private debugManager: audio.AudioDebuggingManager | null = null;
  private nativeAudioNapi: NativeAudioNapi | null = null;
  private nativeAudioNapiLoadError: string = '';
  private refreshTimerId: number = -1;
  private readonly jsPlayerIdle: number = 0;
  private readonly jsPlayerPlaying: number = 1;
  private readonly jsPlayerCompleted: number = 2;
  private readonly jsPlaybackSnapshotGraceMs: number = 8000;
  private readonly nativePlayerIdle: number = 0;
  private readonly nativePlayerPlaying: number = 1;
  private readonly nativePlayerCompleted: number = 2;
  private readonly playbackChunkSize: number = 4096;
  private readonly maxLogCount: number = 100;

  private readonly jsStreams: JsStreamState[] = [
    new JsStreamState(1, 'TS Stream 1', audio.SourceType.SOURCE_TYPE_MIC, audio.AudioSamplingRate.SAMPLE_RATE_16000),
    new JsStreamState(2, 'TS Stream 2', audio.SourceType.SOURCE_TYPE_VOICE_COMMUNICATION, audio.AudioSamplingRate.SAMPLE_RATE_16000)
  ];

  private readonly fallbackJsStreams: JsStreamState[] = [
    new JsStreamState(1001, 'C Stream 1', audio.SourceType.SOURCE_TYPE_MIC, audio.AudioSamplingRate.SAMPLE_RATE_16000),
    new JsStreamState(1002, 'C Stream 2', audio.SourceType.SOURCE_TYPE_LIVE, audio.AudioSamplingRate.SAMPLE_RATE_16000)
  ];

  private readonly nativeStreams: NativeStreamState[] = [
    new NativeStreamState(1001, 'C Stream 1', audio.SourceType.SOURCE_TYPE_MIC, audio.AudioSamplingRate.SAMPLE_RATE_16000),
    new NativeStreamState(1002, 'C Stream 2', audio.SourceType.SOURCE_TYPE_LIVE, audio.AudioSamplingRate.SAMPLE_RATE_16000)
  ];

  @State private hasMicrophonePermission: boolean = false;
  @State private currentPage: number = 0;
  @State private playbackUsage: number = audio.StreamUsage.STREAM_USAGE_MUSIC;
  @State private playbackSampleRate: number = audio.AudioSamplingRate.SAMPLE_RATE_16000;
  @State private playbackChannelCount: number = audio.AudioChannel.CHANNEL_1;
  @State private playbackSampleFormat: number = audio.AudioSampleFormat.SAMPLE_FORMAT_S16LE;
  @State private frameworkSnapshot: string[] = ['No active capture streams'];
  @State private tsAppSnapshotStatus: string = 'TS app snapshot not generated';
  @State private tsAppSnapshotPath: string = '';
  @State private tsAppSnapshotText: string = '';
  @State private showTsAppSnapshotText: boolean = false;
  @State private cAppSnapshotStatus: string = 'C app snapshot not generated (aggregated diagnostic)';
  @State private cAppSnapshotPath: string = '';
  @State private cAppSnapshotText: string = '';
  @State private showCAppSnapshotText: boolean = false;
  @State private recentSnapshotFiles: string[] = ['No snapshot files generated yet'];
  @State private logs: string[] = [];
  @State private status: string = 'Ready';
  @State private refreshVersion: number = 0;

  aboutToAppear(): void {
    window.getLastWindow(this.context).then((win) => {
      win.setWindowLayoutFullScreen(true);
    }).catch((err: BusinessError) => {
      this.status = `Window init failed: ${err.code}`;
    });
    void this.requestMicrophonePermission();
    this.refreshAll();
    this.startPolling();
  }

  aboutToDisappear(): void {
    this.stopPolling();
    for (let i: number = 0; i < this.jsStreams.length; i++) {
      void this.releaseJsCapturer(this.jsStreams[i]);
      void this.stopJsPlayback(this.jsStreams[i]);
    }
    for (let i: number = 0; i < this.fallbackJsStreams.length; i++) {
      void this.releaseJsCapturer(this.fallbackJsStreams[i]);
      void this.stopJsPlayback(this.fallbackJsStreams[i]);
    }
    for (let i: number = 0; i < this.nativeStreams.length; i++) {
      this.releaseNativeCapturer(this.nativeStreams[i]);
      this.stopNativePlayback(this.nativeStreams[i]);
    }
  }

  // Documentation example methods referenced by OpenHarmony docs
  private exampleGetDebugManager(): void {
    // [Start get_debug_manager_ts]
    // 获取音频调试管理器
    const audioManager = audio.getAudioManager();
    const debugManager: audio.AudioDebuggingManager = audioManager.getDebuggingManager();
    // [End get_debug_manager_ts]
  }

  private examplePrintAppSnapshot(debugManager: audio.AudioDebuggingManager): void {
    // [Start print_app_snapshot_ts]
    // 打印应用快照到文件
    const path = this.context.filesDir + '/audio_snapshot.txt';
    let fd: number = this.openSnapshotFile(path);
    if (fd >= 0) {
      debugManager.printAppInfo(fd);
      this.safeCloseFd(fd);
    }

    // 也可将快照信息输出到hilog日志（fd < 0时输出到hilog）
    debugManager.printAppInfo(-1);
    // [End print_app_snapshot_ts]
  }

  private examplePrintCapturerSnapshot(debugManager: audio.AudioDebuggingManager,
    capturer: audio.AudioCapturer): void {
    // [Start print_capturer_snapshot_ts]
    // 打印指定录音实例的快照
    const path = this.context.filesDir + '/capturer_snapshot.txt';
    let fd: number = this.openSnapshotFile(path);
    if (fd >= 0) {
      debugManager.printCapturerInfo(capturer, fd);
      this.safeCloseFd(fd);
    }
    // [End print_capturer_snapshot_ts]
  }

  private examplePrintRendererSnapshot(debugManager: audio.AudioDebuggingManager,
    renderer: audio.AudioRenderer): void {
    // [Start print_renderer_snapshot_ts]
    // 打印指定播放实例的快照
    const path = this.context.filesDir + '/renderer_snapshot.txt';
    let fd: number = this.openSnapshotFile(path);
    if (fd >= 0) {
      debugManager.printRendererInfo(renderer, fd);
      this.safeCloseFd(fd);
    }
    // [End print_renderer_snapshot_ts]
  }

  private async exampleConcurrentSnapshot(): Promise<void> {
    // [Start concurrent_snapshot_ts]
    // 1. 创建并启动多个录音流
    const debugManager: audio.AudioDebuggingManager = this.audioManager.getDebuggingManager();
    const capturerOptions1: audio.AudioCapturerOptions = this.getJsCapturerOptions(this.jsStreams[0]);
    const capturerOptions2: audio.AudioCapturerOptions = this.getJsCapturerOptions(this.jsStreams[1]);
    const capturer1: audio.AudioCapturer = await audio.createAudioCapturer(capturerOptions1);
    const capturer2: audio.AudioCapturer = await audio.createAudioCapturer(capturerOptions2);
    await capturer1.start();
    await capturer2.start();

    // 2. 分别获取各录音流的快照
    const file1Fd: number = this.openSnapshotFile(this.context.filesDir + '/capturer1_snapshot.txt');
    if (file1Fd >= 0) {
      debugManager.printCapturerInfo(capturer1, file1Fd);
      this.safeCloseFd(file1Fd);
    }

    const file2Fd: number = this.openSnapshotFile(this.context.filesDir + '/capturer2_snapshot.txt');
    if (file2Fd >= 0) {
      debugManager.printCapturerInfo(capturer2, file2Fd);
      this.safeCloseFd(file2Fd);
    }

    // 3. 也可以一次性获取应用级别的整体快照（包含所有活跃流信息）
    const appFileFd: number = this.openSnapshotFile(this.context.filesDir + '/app_snapshot.txt');
    if (appFileFd >= 0) {
      debugManager.printAppInfo(appFileFd);
      this.safeCloseFd(appFileFd);
    }
    // [End concurrent_snapshot_ts]
  }

  private forceRefresh(): void {
    this.refreshVersion++;
  }

  private appendLog(message: string): void {
    const now: Date = new Date();
    const time: string = `${now.getHours().toString().padStart(2, '0')}:${now.getMinutes().toString().padStart(2, '0')}:${now.getSeconds().toString().padStart(2, '0')}`;
    const next: string[] = [`[${time}] ${message}`, ...this.logs];
    this.logs = next.slice(0, this.maxLogCount);
    try {
      hilog.info(0x0000, 'AudioSnapshot', '%{public}s', message);
    } catch (_) {
    }
    this.forceRefresh();
  }

  private loadNativeAudioNapi(): void {
    if (this.nativeAudioNapi !== null) {
      return;
    }
    try {
      const moduleObject = loadNativeModule('libentry.so');
      this.nativeAudioNapi = moduleObject as NativeAudioNapi;
      this.nativeAudioNapiLoadError = '';
    } catch (error) {
      this.nativeAudioNapi = null;
      this.nativeAudioNapiLoadError = this.describeError(error);
    }
  }

  private getNativeAudioNapi(): NativeAudioNapi | null {
    return this.nativeAudioNapi;
  }

  private ensureNativeAudioAvailable(scene: string): NativeAudioNapi | null {
    this.loadNativeAudioNapi();
    const napi: NativeAudioNapi | null = this.getNativeAudioNapi();
    if (napi !== null) {
      return napi;
    }
    const reason: string = this.nativeAudioNapiLoadError.length > 0 ? this.nativeAudioNapiLoadError : 'libentry.so not loaded';
    this.status = `${scene} unavailable: ${reason}`;
    this.forceRefresh();
    return null;
  }

  private toErrorCode(error: BusinessError | Object | undefined | null): number {
    const err: BusinessError | undefined = error as BusinessError | undefined;
    return typeof err?.code === 'number' ? err.code : -1;
  }

  private describeError(error: BusinessError | Object | undefined | null): string {
    if (error === undefined || error === null) {
      return 'unknown';
    }
    const err: BusinessError | undefined = error as BusinessError | undefined;
    const codeText: string = typeof err?.code === 'number' ? `${err.code}` : 'NA';
    const nameText: string = typeof (error as Record<string, string>).name === 'string' ?
      (error as Record<string, string>).name : 'UnknownError';
    const messageText: string = typeof err?.message === 'string' ? err.message : JSON.stringify(error);
    return `name=${nameText} code=${codeText} message=${messageText}`;
  }

  private getOptionLabel(options: OptionItem[], value: number): string {
    for (let index: number = 0; index < options.length; index++) {
      if (options[index].value === value) {
        return options[index].label;
      }
    }
    return `${value}`;
  }

  private getOptionIndex(options: OptionItem[], value: number): number {
    for (let index: number = 0; index < options.length; index++) {
      if (options[index].value === value) {
        return index;
      }
    }
    return 0;
  }

  private toSelectOptions(options: OptionItem[]): SelectOption[] {
    const result: SelectOption[] = [];
    for (let index: number = 0; index < options.length; index++) {
      result.push({ value: options[index].label });
    }
    return result;
  }

  private formatBytes(bytes: number): string {
    if (bytes < 1024) {
      return `${bytes} B`;
    }
    if (bytes < 1024 * 1024) {
      return `${(bytes / 1024).toFixed(2)} KB`;
    }
    return `${(bytes / (1024 * 1024)).toFixed(2)} MB`;
  }

  private describeJsPlaybackState(state: number): string {
    if (state === this.jsPlayerPlaying) {
      return 'Playing';
    }
    if (state === this.jsPlayerCompleted) {
      return 'Completed';
    }
    return 'Idle';
  }

  private describeNativePlaybackState(state: number): string {
    if (state === this.nativePlayerPlaying) {
      return 'Playing';
    }
    if (state === this.nativePlayerCompleted) {
      return 'Completed';
    }
    return 'Idle';
  }

  private describeCapturerState(state: number): string {
    switch (state) {
      case audio.AudioState.STATE_NEW:
        return 'New';
      case audio.AudioState.STATE_PREPARED:
        return 'Prepared';
      case audio.AudioState.STATE_RUNNING:
        return 'Running';
      case audio.AudioState.STATE_STOPPED:
        return 'Stopped';
      case audio.AudioState.STATE_RELEASED:
        return 'Released';
      default:
        return `${state}`;
    }
  }

  private buildPcmPath(prefix: string, id: number): string {
    return `${this.context.filesDir}/${prefix}_${id}_${Date.now()}.pcm`;
  }

  private buildSnapshotPath(prefix: string, id: number): string {
    return `${this.context.filesDir}/${prefix}_${id}_snapshot_${Date.now()}.txt`;
  }

  private buildTsAppSnapshotPath(): string {
    return `${this.context.filesDir}/ts_app_snapshot_${Date.now()}.txt`;
  }

  private buildCAppSnapshotPath(): string {
    return `${this.context.filesDir}/c_app_snapshot_${Date.now()}.txt`;
  }

  private async withJsStreamAlias<T>(jsStream: JsStreamState, alias: string,
    action: () => Promise<T> | T): Promise<T> {
    const originalName: string = jsStream.name;
    jsStream.name = alias;
    try {
      return await action();
    } finally {
      jsStream.name = originalName;
    }
  }

  private openSnapshotFile(path: string): number {
    try {
      return fileio.openSync(path, fileio.OpenMode.READ_WRITE | fileio.OpenMode.CREATE | fileio.OpenMode.TRUNC).fd;
    } catch (error) {
      this.appendLog(`Failed to open snapshot file: ${path} ret=${this.toErrorCode(error)}`);
      return -1;
    }
  }

  private safeCloseFd(fd: number): void {
    if (fd < 0) {
      return;
    }
    try {
      fileio.closeSync(fd);
    } catch (error) {
      this.appendLog(`Failed to close fd: fd=${fd} ret=${this.toErrorCode(error)}`);
    }
  }

  private readSnapshotText(path: string): string {
    if (path.length === 0) {
      return '';
    }
    try {
      const text: string = fileio.readTextSync(path);
      if (text.length <= 1200) {
        return text;
      }
      return `${text.slice(0, 1200)}\n......(truncated, see file for full content)`;
    } catch (error) {
      return `Failed to read snapshot: ${this.toErrorCode(error)}`;
    }
  }

  private printSnapshotToHilog(action: () => void, tag: string): void {
    try {
      action();
      this.appendLog(`${tag} mirrored to hilog`);
    } catch (error) {
      this.appendLog(`${tag} hilog mirror failed: ${this.toErrorCode(error)}`);
    }
  }

  private extractSnapshotHighlights(content: string): string[] {
    if (content.length === 0) {
      return [];
    }
    const lines: string[] = content.split('\n');
    const keywords: string[] = [
      'stream', 'source', 'usage', 'sample', 'rate', 'channel', 'format', 'state',
      'renderer', 'capturer', 'session', 'device', 'uid', 'pid', 'app'
    ];
    const results: string[] = [];
    for (let index: number = 0; index < lines.length; index++) {
      const line: string = lines[index].trim();
      if (line.length === 0) {
        continue;
      }
      const lower: string = line.toLowerCase();
      let matched: boolean = false;
      for (let i: number = 0; i < keywords.length; i++) {
        if (lower.indexOf(keywords[i]) >= 0) {
          matched = true;
          break;
        }
      }
      if (matched && results.indexOf(line) < 0) {
        results.push(line);
      }
      if (results.length >= 12) {
        break;
      }
    }
    if (results.length > 0) {
      return results;
    }
    for (let index: number = 0; index < lines.length && results.length < 6; index++) {
      const line: string = lines[index].trim();
      if (line.length > 0) {
        results.push(line);
      }
    }
    return results;
  }

  private getDebuggingManagerInstanceCompat(): audio.AudioDebuggingManager | null {
    if (this.debugManager !== null) {
      return this.debugManager;
    }
    try {
      this.debugManager = this.audioManager.getDebuggingManager();
      this.appendLog('JS debugging manager acquired: getDebuggingManager');
      return this.debugManager;
    } catch (error) {
      this.appendLog(`getDebuggingManager failed: ${this.describeError(error)}`);
      return null;
    }
  }

  private async requestMicrophonePermission(): Promise<boolean> {
    if (this.hasMicrophonePermission) {
      return true;
    }
    try {
      const atManager = abilityAccessCtrl.createAtManager();
      const data = await atManager.requestPermissionsFromUser(this.context, ['ohos.permission.MICROPHONE']);
      const granted: boolean = data.authResults.length > 0 &&
        data.authResults.every((result: number) => result === 0);
      this.hasMicrophonePermission = granted;
      this.status = granted ? 'Microphone permission granted' : 'Microphone permission denied';
      this.forceRefresh();
      return granted;
    } catch (error) {
      this.status = `Permission request failed: ${this.toErrorCode(error)}`;
      this.forceRefresh();
      return false;
    }
  }

  private startPolling(): void {
    if (this.refreshTimerId >= 0) {
      return;
    }
    this.refreshTimerId = setInterval(() => {
      this.refreshAll();
    }, 1000);
  }

  private stopPolling(): void {
    if (this.refreshTimerId < 0) {
      return;
    }
    clearInterval(this.refreshTimerId);
    this.refreshTimerId = -1;
  }

  private refreshFrameworkSnapshot(): void {
    try {
      const infos: audio.AudioCapturerChangeInfoArray = this.streamManager.getCurrentAudioCapturerInfoArraySync();
      const lines: string[] = [];
      for (let index: number = 0; index < infos.length; index++) {
        const info: audio.AudioCapturerChangeInfo = infos[index];
        lines.push(`streamId=${info.streamId} source=${info.capturerInfo.source}`);
      }
      this.frameworkSnapshot = lines.length > 0 ? lines : ['No active capture streams'];
    } catch (error) {
      this.frameworkSnapshot = [`Snapshot query failed: ${this.toErrorCode(error)}`];
    }
  }

  private getFallbackJsStream(stream: NativeStreamState): JsStreamState | null {
    const index: number = this.nativeStreams.findIndex((item: NativeStreamState) => item.id === stream.id);
    if (index < 0 || index >= this.fallbackJsStreams.length) {
      return null;
    }
    return this.fallbackJsStreams[index];
  }

  private applyNativeConfigToFallbackJs(nativeStream: NativeStreamState, jsStream: JsStreamState): void {
    jsStream.source = nativeStream.source;
    jsStream.sampleRate = nativeStream.sampleRate;
    jsStream.channelCount = nativeStream.channelCount;
    jsStream.sampleFormat = nativeStream.sampleFormat;
  }

  private syncNativeStreamFromJsFallback(nativeStream: NativeStreamState): void {
    const jsStream: JsStreamState | null = this.getFallbackJsStream(nativeStream);
    if (jsStream === null) {
      nativeStream.stateText = 'Unavailable';
      nativeStream.streamRuntimeId = -1;
      nativeStream.bufferSize = 0;
      nativeStream.savedBytes = 0;
      nativeStream.savePath = '';
      nativeStream.saveRet = -1;
      nativeStream.callbackCount = 0;
      nativeStream.lastReadSize = 0;
      nativeStream.lastError = 0;
      nativeStream.playbackState = this.nativePlayerIdle;
      nativeStream.playedBytes = 0;
      nativeStream.playTotalBytes = 0;
      nativeStream.playbackError = 0;
      return;
    }
    nativeStream.stateText = jsStream.stateText;
    nativeStream.streamRuntimeId = jsStream.streamId;
    nativeStream.bufferSize = jsStream.bufferSize;
    nativeStream.savedBytes = jsStream.savedBytes;
    nativeStream.savePath = jsStream.savePath;
    nativeStream.saveRet = jsStream.saveRet;
    nativeStream.callbackCount = 0;
    nativeStream.lastReadSize = 0;
    nativeStream.lastError = 0;
    nativeStream.captureSnapshotStatus = jsStream.captureSnapshotStatus;
    nativeStream.captureSnapshotPath = jsStream.captureSnapshotPath;
    nativeStream.captureSnapshotText = jsStream.captureSnapshotText;
    nativeStream.showCaptureSnapshotText = jsStream.showCaptureSnapshotText;
    nativeStream.playbackSnapshotStatus = jsStream.playbackSnapshotStatus;
    nativeStream.playbackSnapshotPath = jsStream.playbackSnapshotPath;
    nativeStream.playbackSnapshotText = jsStream.playbackSnapshotText;
    nativeStream.showPlaybackSnapshotText = jsStream.showPlaybackSnapshotText;
    if (jsStream.playbackState === this.jsPlayerPlaying) {
      nativeStream.playbackState = this.nativePlayerPlaying;
    } else if (jsStream.playbackState === this.jsPlayerCompleted) {
      nativeStream.playbackState = this.nativePlayerCompleted;
    } else {
      nativeStream.playbackState = this.nativePlayerIdle;
    }
    nativeStream.playedBytes = jsStream.playedBytes;
    nativeStream.playTotalBytes = jsStream.playTotalBytes;
    nativeStream.playbackError = 0;
  }

  private async runNativeActionWithJsFallback(stream: NativeStreamState, scene: string,
    jsAction: (jsStream: JsStreamState) => Promise<void> | void, forceFallback: boolean = false): Promise<boolean> {
    const jsStream: JsStreamState | null = this.getFallbackJsStream(stream);
    if (jsStream === null) {
      return false;
    }
    if (!forceFallback) {
      const napi: NativeAudioNapi | null = this.ensureNativeAudioAvailable(`${stream.name} ${scene}`);
      if (napi !== null) {
        stream.useJsFallback = false;
        return false;
      }
    }
    stream.useJsFallback = true;
    this.applyNativeConfigToFallbackJs(stream, jsStream);
    await this.withJsStreamAlias(jsStream, stream.name, async (): Promise<void> => {
      await jsAction(jsStream);
    });
    this.syncNativeStreamFromJsFallback(stream);
    this.status = `${stream.name} ${scene} compatibility mode`;
    this.forceRefresh();
    return true;
  }

  private refreshNativeStats(stream: NativeStreamState): void {
    if (stream.useJsFallback) {
      this.syncNativeStreamFromJsFallback(stream);
      return;
    }
    const napi: NativeAudioNapi | null = this.getNativeAudioNapi();
    if (napi === null) {
      stream.stateText = 'Unavailable';
      stream.streamRuntimeId = -1;
      stream.bufferSize = 0;
      stream.savedBytes = 0;
      stream.callbackCount = 0;
      stream.lastReadSize = 0;
      stream.lastError = 0;
      stream.playbackState = this.nativePlayerIdle;
      stream.playedBytes = 0;
      stream.playTotalBytes = 0;
      stream.playbackError = 0;
      return;
    }
    try {
      const stats: NativeCapturerStats = napi.lowLatencyCapturerGetStats(stream.id) as NativeCapturerStats;
      if (stats.state === 0) {
        stream.stateText = 'Released';
      } else if (stats.state === 1) {
        stream.stateText = 'Stopped';
      } else if (stats.state === 2) {
        stream.stateText = 'Running';
      } else {
        stream.stateText = `${stats.state}`;
      }
      stream.streamRuntimeId = stats.streamId;
      stream.bufferSize = stats.frameSize;
      stream.savedBytes = stats.savedBytes;
      stream.callbackCount = stats.callbackCount;
      stream.lastReadSize = stats.lastReadSize;
      stream.lastError = stats.lastError;
    } catch (error) {
      stream.stateText = 'Released';
      stream.streamRuntimeId = -1;
      stream.bufferSize = 0;
      stream.savedBytes = 0;
      stream.callbackCount = 0;
      stream.lastReadSize = 0;
      stream.lastError = 0;
    }

    try {
      const playerStats: NativePlayerStats = napi.pcmPlayerGetStats(stream.id) as NativePlayerStats;
      stream.playbackState = playerStats.state;
      stream.playedBytes = playerStats.playedBytes;
      stream.playTotalBytes = playerStats.totalBytes;
      stream.playbackError = playerStats.lastError;
    } catch (error) {
      stream.playbackState = this.nativePlayerIdle;
      stream.playedBytes = 0;
      stream.playTotalBytes = 0;
      stream.playbackError = 0;
    }
  }

  private refreshJsRuntime(stream: JsStreamState): void {
    if (stream.capturer === null) {
      stream.stateText = 'Released';
      stream.streamId = -1;
      stream.bufferSize = 0;
      return;
    }
    try {
      stream.stateText = this.describeCapturerState(Number(stream.capturer.state));
    } catch (error) {
      stream.stateText = `State error(${this.toErrorCode(error)})`;
    }
    try {
      stream.streamId = Number(stream.capturer.getAudioStreamIdSync());
    } catch (error) {
      stream.streamId = -1;
    }
    try {
      stream.bufferSize = Number(stream.capturer.getBufferSizeSync());
    } catch (error) {
      stream.bufferSize = 0;
    }
  }

  private refreshAll(): void {
    for (let i: number = 0; i < this.jsStreams.length; i++) {
      this.refreshJsRuntime(this.jsStreams[i]);
    }
    for (let i: number = 0; i < this.nativeStreams.length; i++) {
      this.refreshNativeStats(this.nativeStreams[i]);
    }
    this.refreshFrameworkSnapshot();
    this.forceRefresh();
  }

  private getJsCapturerOptions(stream: JsStreamState): audio.AudioCapturerOptions {
    return {
      streamInfo: {
        samplingRate: stream.sampleRate as audio.AudioSamplingRate,
        channels: stream.channelCount as audio.AudioChannel,
        sampleFormat: stream.sampleFormat as audio.AudioSampleFormat,
        encodingType: audio.AudioEncodingType.ENCODING_TYPE_RAW
      },
      capturerInfo: {
        source: stream.source as audio.SourceType,
        capturerFlags: 0
      }
    };
  }

  private getJsRendererOptions(): audio.AudioRendererOptions {
    return {
      streamInfo: {
        samplingRate: this.playbackSampleRate as audio.AudioSamplingRate,
        channels: this.playbackChannelCount as audio.AudioChannel,
        sampleFormat: this.playbackSampleFormat as audio.AudioSampleFormat,
        encodingType: audio.AudioEncodingType.ENCODING_TYPE_RAW
      },
      rendererInfo: {
        usage: this.playbackUsage as audio.StreamUsage,
        rendererFlags: 0
      }
    };
  }

  private finishJsRecordFile(stream: JsStreamState): void {
    if (stream.recordFd >= 0) {
      this.safeCloseFd(stream.recordFd);
      stream.recordFd = -1;
    }
  }

  private getJsCapturerStateValue(stream: JsStreamState): number {
    if (stream.capturer === null) {
      return -1;
    }
    try {
      return Number(stream.capturer.state);
    } catch (error) {
      return -1;
    }
  }

  private clearJsReadDataBinding(stream: JsStreamState, scene: string): void {
    if (stream.capturer !== null && stream.readCallback !== null) {
      try {
        stream.capturer.off('readData', stream.readCallback);
      } catch (error) {
        this.appendLog(`${stream.name} off readData failed during ${scene}: ${this.toErrorCode(error)}`);
      }
    }
    stream.readCallback = null;
    stream.lastRecordUiRefreshAt = 0;
    this.finishJsRecordFile(stream);
  }

  private refreshJsRecordingProgress(stream: JsStreamState): void {
    const now: number = Date.now();
    if (now - stream.lastRecordUiRefreshAt < 200) {
      return;
    }
    stream.lastRecordUiRefreshAt = now;
    this.forceRefresh();
  }

  private async createJsCapturer(stream: JsStreamState): Promise<void> {
    if (!(await this.requestMicrophonePermission())) {
      return;
    }
    if (stream.capturer !== null) {
      this.status = `${stream.name} already created (${this.describeCapturerState(this.getJsCapturerStateValue(stream))})`;
      this.forceRefresh();
      return;
    }
    try {
      stream.capturer = await audio.createAudioCapturer(this.getJsCapturerOptions(stream));
      stream.stateText = 'Prepared';
      this.status = `${stream.name} created`;
      this.appendLog(`${stream.name} created`);
      this.refreshJsRuntime(stream);
      this.forceRefresh();
    } catch (error) {
      this.status = `${stream.name} create failed: ${this.toErrorCode(error)}`;
      this.forceRefresh();
    }
  }

  private async startJsCapturer(stream: JsStreamState): Promise<void> {
    if (!(await this.requestMicrophonePermission())) {
      return;
    }
    if (stream.capturer === null) {
      await this.createJsCapturer(stream);
    }
    if (stream.capturer === null) {
      return;
    }
    const stateValue: number = this.getJsCapturerStateValue(stream);
    if (stateValue === audio.AudioState.STATE_RUNNING) {
      this.status = `${stream.name} already running`;
      this.appendLog(`${stream.name} start skipped, already running`);
      this.forceRefresh();
      return;
    }
    try {
      if (stream.savePath.length === 0) {
        stream.savePath = this.buildPcmPath('js_record', stream.id);
      }
      stream.savedBytes = 0;
      stream.saveRet = 0;
      stream.lastRecordUiRefreshAt = 0;
      this.clearJsReadDataBinding(stream, 'start');
      stream.recordFd = fileio.openSync(
        stream.savePath,
        fileio.OpenMode.WRITE_ONLY | fileio.OpenMode.CREATE | fileio.OpenMode.TRUNC
      ).fd;
      stream.readCallback = (buffer: ArrayBuffer): void => {
        if (stream.recordFd < 0) {
          return;
        }
        try {
          const written: number = Number(fileio.writeSync(stream.recordFd, buffer));
          stream.savedBytes += written;
          this.refreshJsRecordingProgress(stream);
        } catch (error) {
          stream.saveRet = this.toErrorCode(error);
          this.forceRefresh();
        }
      };
      stream.capturer.on('readData', stream.readCallback);
      await stream.capturer.start();
      this.status = `${stream.name} recording started`;
      this.appendLog(`${stream.name} recording: ${stream.savePath}`);
      this.refreshJsRuntime(stream);
      this.forceRefresh();
    } catch (error) {
      this.status = `${stream.name} start failed: ${this.toErrorCode(error)}`;
      this.clearJsReadDataBinding(stream, 'start failure');
      this.forceRefresh();
    }
  }

  private async stopJsCapturer(stream: JsStreamState): Promise<void> {
    if (stream.capturer === null) {
      this.status = `${stream.name} not created`;
      this.forceRefresh();
      return;
    }
    const stateValue: number = this.getJsCapturerStateValue(stream);
    try {
      if (stateValue === audio.AudioState.STATE_RUNNING) {
        await stream.capturer.stop();
        this.clearJsReadDataBinding(stream, 'stop');
        this.status = `${stream.name} recording stopped`;
        this.appendLog(`${stream.name} stopped, saved ${stream.savedBytes} bytes`);
      } else if (stateValue === audio.AudioState.STATE_STOPPED) {
        this.clearJsReadDataBinding(stream, 'stop when stopped');
        this.status = `${stream.name} already stopped`;
        this.appendLog(`${stream.name} stop skipped, already stopped`);
      } else {
        this.status = `${stream.name} stop skipped, current state: ${this.describeCapturerState(stateValue)}`;
        this.appendLog(`${stream.name} stop skipped in state ${this.describeCapturerState(stateValue)}`);
      }
      this.refreshJsRuntime(stream);
      this.forceRefresh();
    } catch (error) {
      this.status = `${stream.name} stop failed: ${this.toErrorCode(error)}`;
      this.appendLog(`${stream.name} stop failed: ${this.toErrorCode(error)}`);
      this.forceRefresh();
    }
  }

  private async releaseJsCapturer(stream: JsStreamState): Promise<void> {
    if (stream.capturer === null) {
      return;
    }
    const stateValue: number = this.getJsCapturerStateValue(stream);
    if (stateValue === audio.AudioState.STATE_RUNNING) {
      try {
        await stream.capturer.stop();
      } catch (error) {
        this.appendLog(`${stream.name} stop before release failed: ${this.toErrorCode(error)}`);
      }
    }
    this.clearJsReadDataBinding(stream, 'release');
    try {
      await stream.capturer.release();
    } catch (error) {
      this.appendLog(`${stream.name} release failed: ${this.toErrorCode(error)}`);
    }
    stream.capturer = null;
    this.refreshJsRuntime(stream);
    this.status = `${stream.name} released`;
    this.forceRefresh();
  }

  private async stopJsPlayback(stream: JsStreamState): Promise<number> {
    let ret: number = 0;
    if (stream.playbackAutoStopTimerId >= 0) {
      clearTimeout(stream.playbackAutoStopTimerId);
      stream.playbackAutoStopTimerId = -1;
    }
    if (stream.playbackRenderer !== null) {
      try {
        await stream.playbackRenderer.stop();
      } catch (error) {
        ret = this.toErrorCode(error);
      }
      try {
        await stream.playbackRenderer.release();
      } catch (error) {
        if (ret === 0) {
          ret = this.toErrorCode(error);
        }
      }
    }
    if (stream.playbackFd >= 0) {
      try {
        this.safeCloseFd(stream.playbackFd);
      } catch (error) {
        if (ret === 0) {
          ret = this.toErrorCode(error);
        }
      }
    }
    stream.playbackRenderer = null;
    stream.playbackFd = -1;
    stream.playbackState = this.jsPlayerIdle;
    this.forceRefresh();
    return ret;
  }

  private async jsPlaybackLoop(stream: JsStreamState, fd: number, renderer: audio.AudioRenderer): Promise<void> {
    let completed: boolean = false;
    try {
      while (stream.playbackRenderer === renderer) {
        const buffer: ArrayBuffer = new ArrayBuffer(this.playbackChunkSize);
        const readSize: number = Number(fileio.readSync(fd, buffer, { length: this.playbackChunkSize }));
        if (readSize <= 0) {
          completed = true;
          break;
        }
        const chunk: ArrayBuffer = readSize === this.playbackChunkSize ? buffer : buffer.slice(0, readSize);
        const written: number = Number(await renderer.write(chunk));
        stream.playedBytes += written;
        this.forceRefresh();
      }
    } catch (error) {
      this.appendLog(`${stream.name} JS playback loop failed: ${this.toErrorCode(error)}`);
    } finally {
      this.appendLog(`${stream.name} JS playback loop exit: completed=${completed} played=${stream.playedBytes}/${stream.playTotalBytes}`);
      if (completed) {
        try {
          await renderer.stop();
        } catch (error) {
          this.appendLog(`${stream.name} playback stop after completion failed: ${this.toErrorCode(error)}`);
        }
        stream.playbackState = this.jsPlayerCompleted;
        this.appendLog(`${stream.name} playback completed`);
        if (stream.playbackRenderer === renderer) {
          stream.playbackAutoStopTimerId = setTimeout(() => {
            stream.playbackAutoStopTimerId = -1;
            void this.stopJsPlayback(stream);
          }, this.jsPlaybackSnapshotGraceMs);
          this.appendLog(`${stream.name} playback snapshot grace period: ${this.jsPlaybackSnapshotGraceMs}ms`);
        }
      } else {
        stream.playbackState = this.jsPlayerIdle;
        await this.stopJsPlayback(stream);
      }
      this.forceRefresh();
    }
  }

  private async playJsRecording(stream: JsStreamState): Promise<void> {
    if (stream.savePath.length === 0 || stream.savedBytes <= 0) {
      this.status = `${stream.name} no PCM file to play`;
      this.appendLog(`${stream.name} playback skipped: no PCM file, savedBytes=${stream.savedBytes}, path=${stream.savePath}`);
      this.forceRefresh();
      return;
    }
    try {
      await this.stopJsPlayback(stream);
      this.appendLog(`${stream.name} playback preparing: bytes=${stream.savedBytes}, state=${this.describeJsPlaybackState(stream.playbackState)}, path=${stream.savePath}`);
      const file = fileio.openSync(stream.savePath, fileio.OpenMode.READ_ONLY);
      const renderer: audio.AudioRenderer = await audio.createAudioRenderer(this.getJsRendererOptions());
      await renderer.start();
      stream.playbackFd = file.fd;
      stream.playbackRenderer = renderer;
      stream.playbackState = this.jsPlayerPlaying;
      stream.playedBytes = 0;
      stream.playTotalBytes = stream.savedBytes;
      this.status = `${stream.name} playback started`;
      this.appendLog(`${stream.name} playing: ${stream.savePath}`);
      this.forceRefresh();
      void this.jsPlaybackLoop(stream, file.fd, renderer);
    } catch (error) {
      this.status = `${stream.name} playback failed: ${this.toErrorCode(error)}`;
      this.appendLog(`${stream.name} playback failed: ${this.toErrorCode(error)}`);
      void this.stopJsPlayback(stream);
      this.forceRefresh();
    }
  }

  private printJsCaptureSnapshot(stream: JsStreamState): void {
    if (stream.capturer === null) {
      stream.captureSnapshotStatus = 'Capture snapshot unavailable';
      this.status = `${stream.name} capture snapshot unavailable`;
      this.forceRefresh();
      return;
    }
    const manager: audio.AudioDebuggingManager | null = this.getDebuggingManagerInstanceCompat();
    if (manager === null) {
      stream.captureSnapshotStatus = 'JS debugging manager unavailable';
      this.status = stream.captureSnapshotStatus;
      this.forceRefresh();
      return;
    }
    const path: string = stream.captureSnapshotPath.length > 0 ?
      stream.captureSnapshotPath : this.buildSnapshotPath('js_capturer', stream.id);
    let fd: number = this.openSnapshotFile(path);
    if (fd < 0) {
      stream.captureSnapshotStatus = `Failed to open capture snapshot file: ${path}`;
      this.status = stream.captureSnapshotStatus;
      this.forceRefresh();
      return;
    }
    try {
      manager.printCapturerInfo(stream.capturer, fd);
      this.printSnapshotToHilog(() => {
        manager.printCapturerInfo(stream.capturer, -1);
      }, `${stream.name} JS capture snapshot`);
      this.safeCloseFd(fd);
      fd = -1;
      stream.captureSnapshotPath = path;
      stream.captureSnapshotStatus = `Capture snapshot saved: ${path}`;
      stream.captureSnapshotText = this.readSnapshotText(path);
      stream.showCaptureSnapshotText = true;
      this.status = `${stream.name} capture snapshot success`;
    } catch (error) {
      stream.captureSnapshotStatus = `Capture snapshot failed: ${this.toErrorCode(error)}`;
      stream.captureSnapshotText = '';
      stream.showCaptureSnapshotText = false;
      this.status = `${stream.name} capture snapshot failed`;
    } finally {
      this.safeCloseFd(fd);
      this.forceRefresh();
    }
  }

  private printJsPlaybackSnapshot(stream: JsStreamState): void {
    if (stream.playbackRenderer === null) {
      stream.playbackSnapshotStatus = 'Playback snapshot unavailable';
      this.appendLog(`${stream.name} playback snapshot unavailable: renderer=null state=${this.describeJsPlaybackState(stream.playbackState)} played=${stream.playedBytes}/${stream.playTotalBytes}`);
      this.status = `${stream.name} playback snapshot unavailable`;
      this.forceRefresh();
      return;
    }
    const manager: audio.AudioDebuggingManager | null = this.getDebuggingManagerInstanceCompat();
    if (manager === null) {
      stream.playbackSnapshotStatus = 'JS debugging manager unavailable';
      this.status = stream.playbackSnapshotStatus;
      this.forceRefresh();
      return;
    }
    const path: string = stream.playbackSnapshotPath.length > 0 ?
      stream.playbackSnapshotPath : this.buildSnapshotPath('js_renderer', stream.id);
    let fd: number = this.openSnapshotFile(path);
    if (fd < 0) {
      stream.playbackSnapshotStatus = `Failed to open playback snapshot file: ${path}`;
      this.status = stream.playbackSnapshotStatus;
      this.forceRefresh();
      return;
    }
    try {
      manager.printRendererInfo(stream.playbackRenderer, fd);
      this.printSnapshotToHilog(() => {
        manager.printRendererInfo(stream.playbackRenderer, -1);
      }, `${stream.name} JS playback snapshot`);
      this.safeCloseFd(fd);
      fd = -1;
      stream.playbackSnapshotPath = path;
      stream.playbackSnapshotStatus = `Playback snapshot saved: ${path}`;
      stream.playbackSnapshotText = this.readSnapshotText(path);
      stream.showPlaybackSnapshotText = true;
      this.status = `${stream.name} playback snapshot success`;
    } catch (error) {
      stream.playbackSnapshotStatus = `Playback snapshot failed: ${this.toErrorCode(error)}`;
      stream.playbackSnapshotText = '';
      stream.showPlaybackSnapshotText = false;
      this.status = `${stream.name} playback snapshot failed`;
    } finally {
      this.safeCloseFd(fd);
      this.forceRefresh();
    }
  }

  private createNativeCapturer(stream: NativeStreamState): void {
    const napi: NativeAudioNapi | null = this.ensureNativeAudioAvailable(`${stream.name} create`);
    if (napi === null) {
      stream.saveRet = -1;
      return;
    }
    stream.savePath = this.buildPcmPath('c_record', stream.id);
    try {
      const ret: number = napi.lowLatencyCapturerInit(
        stream.id,
        stream.source,
        stream.sampleRate,
        stream.channelCount,
        stream.sampleFormat
      );
      stream.saveRet = ret;
      this.refreshNativeStats(stream);
      this.status = `${stream.name} create ret=${ret}`;
      this.forceRefresh();
    } catch (error) {
      this.status = `${stream.name} create failed: ${this.toErrorCode(error)}`;
      this.forceRefresh();
    }
  }

  private async handleNativeCreate(stream: NativeStreamState): Promise<void> {
    if (await this.runNativeActionWithJsFallback(stream, 'create',
      async (jsStream: JsStreamState): Promise<void> => {
        if (jsStream.capturer !== null) {
          await this.releaseJsCapturer(jsStream);
        }
        jsStream.savePath = this.buildPcmPath('c_record', stream.id);
        await this.createJsCapturer(jsStream);
      })) {
      return;
    }
    this.createNativeCapturer(stream);
  }

  private startNativeCapturer(stream: NativeStreamState): void {
    const napi: NativeAudioNapi | null = this.ensureNativeAudioAvailable(`${stream.name} start`);
    if (napi === null) {
      return;
    }
    if (stream.savePath.length === 0) {
      stream.savePath = this.buildPcmPath('c_record', stream.id);
    }
    try {
      const saveRet: number = napi.lowLatencyCapturerSetSaveFile(stream.id, stream.savePath);
      stream.saveRet = saveRet;
      const ret: number = napi.lowLatencyCapturerStart(stream.id);
      this.status = `${stream.name} start ret=${ret}`;
      this.appendLog(`${stream.name} recording: ${stream.savePath}`);
      this.refreshNativeStats(stream);
      this.forceRefresh();
    } catch (error) {
      this.status = `${stream.name} start failed: ${this.toErrorCode(error)}`;
      this.forceRefresh();
    }
  }

  private async handleNativeStart(stream: NativeStreamState): Promise<void> {
    if (await this.runNativeActionWithJsFallback(stream, 'start',
      async (jsStream: JsStreamState): Promise<void> => {
        jsStream.savePath = this.buildPcmPath('c_record', stream.id);
        await this.startJsCapturer(jsStream);
      }, stream.useJsFallback)) {
      return;
    }
    this.startNativeCapturer(stream);
  }

  private stopNativeCapturer(stream: NativeStreamState): void {
    const napi: NativeAudioNapi | null = this.ensureNativeAudioAvailable(`${stream.name} stop`);
    if (napi === null) {
      return;
    }
    try {
      const ret: number = napi.lowLatencyCapturerStop(stream.id);
      napi.lowLatencyCapturerSetSaveFile(stream.id, '');
      this.status = `${stream.name} stop ret=${ret}`;
      this.refreshNativeStats(stream);
      this.forceRefresh();
    } catch (error) {
      this.status = `${stream.name} stop failed: ${this.toErrorCode(error)}`;
      this.forceRefresh();
    }
  }

  private async handleNativeStop(stream: NativeStreamState): Promise<void> {
    if (await this.runNativeActionWithJsFallback(stream, 'stop',
      async (jsStream: JsStreamState): Promise<void> => {
        await this.stopJsCapturer(jsStream);
      }, stream.useJsFallback)) {
      return;
    }
    this.stopNativeCapturer(stream);
  }

  private releaseNativeCapturer(stream: NativeStreamState): void {
    const napi: NativeAudioNapi | null = this.getNativeAudioNapi();
    if (napi === null) {
      stream.stateText = 'Unavailable';
      return;
    }
    try {
      napi.lowLatencyCapturerSetSaveFile(stream.id, '');
    } catch (error) {
      this.appendLog(`${stream.name} clear save file failed: ${this.toErrorCode(error)}`);
    }
    try {
      const ret: number = napi.lowLatencyCapturerRelease(stream.id);
      this.status = `${stream.name} release ret=${ret}`;
      this.refreshNativeStats(stream);
      this.forceRefresh();
    } catch (error) {
      this.status = `${stream.name} release failed: ${this.toErrorCode(error)}`;
      this.forceRefresh();
    }
  }

  private async handleNativeRelease(stream: NativeStreamState): Promise<void> {
    if (await this.runNativeActionWithJsFallback(stream, 'release',
      async (jsStream: JsStreamState): Promise<void> => {
        await this.releaseJsCapturer(jsStream);
      }, stream.useJsFallback)) {
      stream.useJsFallback = false;
      stream.stateText = 'Released';
      this.forceRefresh();
      return;
    }
    stream.useJsFallback = false;
    this.releaseNativeCapturer(stream);
  }

  private playNativeRecording(stream: NativeStreamState): void {
    const napi: NativeAudioNapi | null = this.ensureNativeAudioAvailable(`${stream.name} playback`);
    if (napi === null) {
      return;
    }
    if (stream.savePath.length === 0 || stream.savedBytes <= 0) {
      this.status = `${stream.name} no PCM file to play`;
      this.forceRefresh();
      return;
    }
    try {
      const ret: number = napi.pcmPlayerStart(
        stream.id,
        stream.savePath,
        this.playbackSampleRate,
        this.playbackChannelCount,
        this.playbackSampleFormat
      );
      this.status = `${stream.name} playback ret=${ret}`;
      this.appendLog(`${stream.name} playing: ${stream.savePath}`);
      this.refreshNativeStats(stream);
      this.forceRefresh();
    } catch (error) {
      this.status = `${stream.name} playback failed: ${this.toErrorCode(error)}`;
      this.forceRefresh();
    }
  }

  private async handleNativePlayback(stream: NativeStreamState): Promise<void> {
    if (await this.runNativeActionWithJsFallback(stream, 'playback',
      async (jsStream: JsStreamState): Promise<void> => {
        await this.playJsRecording(jsStream);
      }, stream.useJsFallback)) {
      return;
    }
    this.playNativeRecording(stream);
  }

  private stopNativePlayback(stream: NativeStreamState): void {
    const napi: NativeAudioNapi | null = this.getNativeAudioNapi();
    if (napi === null) {
      stream.playbackState = this.nativePlayerIdle;
      return;
    }
    try {
      const ret: number = napi.pcmPlayerStop(stream.id);
      this.status = `${stream.name} stop playback ret=${ret}`;
      this.refreshNativeStats(stream);
      this.forceRefresh();
    } catch (error) {
      this.status = `${stream.name} stop playback failed: ${this.toErrorCode(error)}`;
      this.forceRefresh();
    }
  }

  private async handleNativeStopPlayback(stream: NativeStreamState): Promise<void> {
    if (await this.runNativeActionWithJsFallback(stream, 'stop playback',
      async (jsStream: JsStreamState): Promise<void> => {
        await this.stopJsPlayback(jsStream);
      }, stream.useJsFallback)) {
      return;
    }
    this.stopNativePlayback(stream);
  }

  private printNativeCaptureSnapshot(stream: NativeStreamState): void {
    const napi: NativeAudioNapi | null = this.ensureNativeAudioAvailable(`${stream.name} capture snapshot`);
    if (napi === null) {
      stream.captureSnapshotStatus = 'Capture snapshot unavailable: native module not loaded';
      this.status = stream.captureSnapshotStatus;
      this.forceRefresh();
      return;
    }
    const path: string = this.buildSnapshotPath('c_capturer', stream.id);
    let fd: number = this.openSnapshotFile(path);
    if (fd < 0) {
      stream.captureSnapshotStatus = `Failed to open capture snapshot file: ${path}`;
      this.status = stream.captureSnapshotStatus;
      this.forceRefresh();
      return;
    }
    try {
      const ret: number = napi.lowLatencyCapturerPrintSnapshot(stream.id, fd);
      if (ret !== 0) {
        stream.captureSnapshotStatus = `Capture snapshot failed: ${ret}`;
        this.appendLog(`${stream.name} C capture snapshot failed ret=${ret}`);
        stream.captureSnapshotText = '';
        stream.showCaptureSnapshotText = false;
      } else {
        const hilogRet: number = napi.lowLatencyCapturerPrintSnapshot(stream.id, -1);
        this.appendLog(`${stream.name} C capture snapshot mirrored to hilog ret=${hilogRet}`);
        this.safeCloseFd(fd);
        fd = -1;
        stream.captureSnapshotPath = path;
        stream.captureSnapshotStatus = `Capture snapshot saved: ${path}`;
        stream.captureSnapshotText = this.readSnapshotText(path);
        stream.showCaptureSnapshotText = true;
      }
      this.status = `${stream.name} capture snapshot done`;
    } catch (error) {
      stream.captureSnapshotStatus = `Capture snapshot error: ${this.toErrorCode(error)}`;
      stream.captureSnapshotText = '';
      stream.showCaptureSnapshotText = false;
      this.status = `${stream.name} capture snapshot error`;
    } finally {
      this.safeCloseFd(fd);
      this.forceRefresh();
    }
  }

  private printNativePlaybackSnapshot(stream: NativeStreamState): void {
    const napi: NativeAudioNapi | null = this.ensureNativeAudioAvailable(`${stream.name} playback snapshot`);
    if (napi === null) {
      stream.playbackSnapshotStatus = 'Playback snapshot unavailable: native module not loaded';
      this.status = stream.playbackSnapshotStatus;
      this.forceRefresh();
      return;
    }
    const path: string = this.buildSnapshotPath('c_renderer', stream.id);
    let fd: number = this.openSnapshotFile(path);
    if (fd < 0) {
      stream.playbackSnapshotStatus = `Failed to open playback snapshot file: ${path}`;
      this.status = stream.playbackSnapshotStatus;
      this.forceRefresh();
      return;
    }
    try {
      const ret: number = napi.pcmPlayerPrintSnapshot(stream.id, fd);
      if (ret !== 0) {
        stream.playbackSnapshotStatus = `Playback snapshot failed: ${ret}`;
        this.appendLog(`${stream.name} C playback snapshot failed ret=${ret}`);
        stream.playbackSnapshotText = '';
        stream.showPlaybackSnapshotText = false;
      } else {
        const hilogRet: number = napi.pcmPlayerPrintSnapshot(stream.id, -1);
        this.appendLog(`${stream.name} C playback snapshot mirrored to hilog ret=${hilogRet}`);
        this.safeCloseFd(fd);
        fd = -1;
        stream.playbackSnapshotPath = path;
        stream.playbackSnapshotStatus = `Playback snapshot saved: ${path}`;
        stream.playbackSnapshotText = this.readSnapshotText(path);
        stream.showPlaybackSnapshotText = true;
      }
      this.status = `${stream.name} playback snapshot done`;
    } catch (error) {
      stream.playbackSnapshotStatus = `Playback snapshot error: ${this.toErrorCode(error)}`;
      stream.playbackSnapshotText = '';
      stream.showPlaybackSnapshotText = false;
      this.status = `${stream.name} playback snapshot error`;
    } finally {
      this.safeCloseFd(fd);
      this.forceRefresh();
    }
  }

  private async handleNativeCaptureSnapshot(stream: NativeStreamState): Promise<void> {
    if (await this.runNativeActionWithJsFallback(stream, 'capture snapshot',
      (jsStream: JsStreamState): void => {
        jsStream.captureSnapshotPath = this.buildSnapshotPath('c_capturer', stream.id);
        this.printJsCaptureSnapshot(jsStream);
      }, stream.useJsFallback)) {
      return;
    }
    this.printNativeCaptureSnapshot(stream);
  }

  private async handleNativePlaybackSnapshot(stream: NativeStreamState): Promise<void> {
    if (await this.runNativeActionWithJsFallback(stream, 'playback snapshot',
      (jsStream: JsStreamState): void => {
        jsStream.playbackSnapshotPath = this.buildSnapshotPath('c_renderer', stream.id);
        this.printJsPlaybackSnapshot(jsStream);
      }, stream.useJsFallback)) {
      return;
    }
    this.printNativePlaybackSnapshot(stream);
  }

  private printTsAppSnapshot(): void {
    const manager: audio.AudioDebuggingManager | null = this.getDebuggingManagerInstanceCompat();
    if (manager === null) {
      this.tsAppSnapshotStatus = 'TS app debugging manager unavailable';
      this.status = this.tsAppSnapshotStatus;
      this.forceRefresh();
      return;
    }
    const path: string = this.buildTsAppSnapshotPath();
    let fd: number = this.openSnapshotFile(path);
    if (fd < 0) {
      this.tsAppSnapshotStatus = `Failed to open TS app snapshot file: ${path}`;
      this.status = this.tsAppSnapshotStatus;
      this.forceRefresh();
      return;
    }
    try {
      manager.printAppInfo(fd);
      this.printSnapshotToHilog(() => {
        manager.printAppInfo(-1);
      }, 'TS app snapshot');
      this.safeCloseFd(fd);
      fd = -1;
      this.tsAppSnapshotPath = path;
      this.tsAppSnapshotText = this.readSnapshotText(path);
      this.tsAppSnapshotStatus = this.tsAppSnapshotText.length > 0 ?
        `TS app snapshot saved: ${path}` :
        `TS app snapshot saved but file is empty: ${path}`;
      this.showTsAppSnapshotText = true;
      this.status = this.tsAppSnapshotStatus;
      this.appendLog(this.tsAppSnapshotStatus);
    } catch (error) {
      this.tsAppSnapshotStatus = `TS app snapshot failed: ${this.toErrorCode(error)}`;
      this.tsAppSnapshotText = '';
      this.showTsAppSnapshotText = false;
      this.status = this.tsAppSnapshotStatus;
      this.appendLog(this.tsAppSnapshotStatus);
    } finally {
      this.safeCloseFd(fd);
      this.forceRefresh();
    }
  }

  private printCAppSnapshot(): void {
    const napi: NativeAudioNapi | null = this.ensureNativeAudioAvailable('C app snapshot');
    if (napi === null) {
      this.cAppSnapshotStatus = 'C app snapshot unavailable: native module not loaded';
      this.cAppSnapshotText = '';
      this.showCAppSnapshotText = false;
      this.status = this.cAppSnapshotStatus;
      this.forceRefresh();
      return;
    }
    const path: string = this.buildCAppSnapshotPath();
    let fd: number = this.openSnapshotFile(path);
    if (fd < 0) {
      this.cAppSnapshotStatus = `Failed to open C app snapshot file: ${path}`;
      this.status = this.cAppSnapshotStatus;
      this.forceRefresh();
      return;
    }
    try {
      const ret: number = napi.audioDebuggingManagerPrintAppInfo(fd);
      if (ret !== 0) {
        this.cAppSnapshotPath = '';
        this.cAppSnapshotStatus = `C app snapshot failed: ${ret} (aggregated diagnostic; stream snapshots may still succeed)`;
        this.appendLog(`C app snapshot failed ret=${ret}; this path aggregates app/session state and may fail independently of stream snapshots`);
        this.cAppSnapshotText = '';
        this.showCAppSnapshotText = false;
      } else {
        const hilogRet: number = napi.audioDebuggingManagerPrintAppInfo(-1);
        this.appendLog(`C app snapshot mirrored to hilog ret=${hilogRet}`);
        this.safeCloseFd(fd);
        fd = -1;
        this.cAppSnapshotPath = path;
        this.cAppSnapshotText = this.readSnapshotText(path);
        this.cAppSnapshotStatus = this.cAppSnapshotText.length > 0 ?
          `C app snapshot saved: ${path}` :
          `C app snapshot saved but file is empty: ${path}`;
        this.showCAppSnapshotText = true;
        this.appendLog(this.cAppSnapshotStatus);
      }
      this.status = this.cAppSnapshotStatus;
    } catch (error) {
      this.cAppSnapshotStatus = `C app snapshot error: ${this.toErrorCode(error)}`;
      this.cAppSnapshotText = '';
      this.showCAppSnapshotText = false;
      this.status = this.cAppSnapshotStatus;
      this.appendLog(this.cAppSnapshotStatus);
    } finally {
      this.safeCloseFd(fd);
      this.forceRefresh();
    }
  }

  private printAllAvailableSnapshots(): void {
    const generatedFiles: string[] = [];
    this.currentPage = 3;
    this.recentSnapshotFiles = ['Capturing snapshot files...'];
    this.forceRefresh();
    this.refreshAll();
    for (let index: number = 0; index < this.jsStreams.length; index++) {
      const jsStream: JsStreamState = this.jsStreams[index];
      if (jsStream.capturer !== null) {
        this.printJsCaptureSnapshot(jsStream);
        if (jsStream.captureSnapshotPath.length > 0) {
          generatedFiles.push(`${jsStream.name} capture: ${jsStream.captureSnapshotPath}`);
        }
      }
      if (jsStream.playbackRenderer !== null) {
        this.printJsPlaybackSnapshot(jsStream);
        if (jsStream.playbackSnapshotPath.length > 0) {
          generatedFiles.push(`${jsStream.name} playback: ${jsStream.playbackSnapshotPath}`);
        }
      }
    }
    for (let index: number = 0; index < this.nativeStreams.length; index++) {
      const nativeStream: NativeStreamState = this.nativeStreams[index];
      if (nativeStream.streamRuntimeId >= 0 || nativeStream.stateText !== 'Released') {
        this.printNativeCaptureSnapshot(nativeStream);
        if (nativeStream.captureSnapshotPath.length > 0) {
          generatedFiles.push(`${nativeStream.name} capture: ${nativeStream.captureSnapshotPath}`);
        }
      }
      if (nativeStream.playbackState !== this.nativePlayerIdle) {
        this.printNativePlaybackSnapshot(nativeStream);
        if (nativeStream.playbackSnapshotPath.length > 0) {
          generatedFiles.push(`${nativeStream.name} playback: ${nativeStream.playbackSnapshotPath}`);
        }
      }
    }
    this.refreshFrameworkSnapshot();
    this.recentSnapshotFiles = generatedFiles.length > 0 ? generatedFiles : ['No snapshot files generated in this run'];
    this.status = 'Full snapshot capture finished';
    this.appendLog(`Full snapshot capture finished; files=${this.recentSnapshotFiles.length}`);
    for (let index: number = 0; index < this.recentSnapshotFiles.length; index++) {
      this.appendLog(`Snapshot file: ${this.recentSnapshotFiles[index]}`);
    }
    this.forceRefresh();
  }

  @Builder
  private buildSectionTitle(title: string, subTitle: string) {
    Column({ space: 2 }) {
      Text(title)
        .fontSize(15)
        .fontWeight(FontWeight.Medium)
        .width('100%');
      Text(subTitle)
        .fontSize(10)
        .fontColor('#475569')
        .width('100%');
    }
  }

  @Builder
  private buildSelectField(title: string, options: OptionItem[], value: number,
    onChange: (nextValue: number) => void) {
    Column({ space: 4 }) {
      Text(title)
        .fontSize(9)
        .fontColor('#64748B')
        .width('100%');
      Select(this.toSelectOptions(options))
        .selected(this.getOptionIndex(options, value))
        .value(this.getOptionLabel(options, value))
        .font({ size: 11, weight: 400 })
        .fontColor('#0F172A')
        .selectedOptionBgColor('#DCEAFE')
        .selectedOptionFont({ size: 11, weight: 500 })
        .selectedOptionFontColor('#0F172A')
        .optionBgColor('#FFFFFF')
        .optionFont({ size: 11, weight: 400 })
        .optionFontColor('#1E293B')
        .controlSize(ControlSize.SMALL)
        .arrowPosition(ArrowPosition.END)
        .menuAlign(MenuAlignType.START)
        .height(32)
        .width('100%')
        .backgroundColor('#F8FAFC')
        .border({ width: 1, color: '#CBD5E1' })
        .borderRadius(10)
        .padding({ left: 10, right: 10 })
        .onSelect((index: number) => {
          if (index >= 0 && index < options.length) {
            onChange(options[index].value);
          }
        });
    }
    .layoutWeight(1);
  }

  @Builder
  private buildPageSelector() {
    Row({ space: 6 }) {
      ForEach(PAGE_OPTIONS, (item: PageItem) => {
        Button(item.label)
          .height(30)
          .fontSize(10)
          .fontWeight(this.currentPage === item.value ? FontWeight.Medium : FontWeight.Regular)
          .fontColor(this.currentPage === item.value ? '#0F172A' : '#475569')
          .backgroundColor(this.currentPage === item.value ? '#E0F2FE' : '#FFFFFF')
          .border({ width: 1, color: this.currentPage === item.value ? '#38BDF8' : '#CBD5E1' })
          .borderRadius(999)
          .padding({ left: 10, right: 10 })
          .onClick(() => {
            this.currentPage = item.value;
            this.forceRefresh();
          });
      }, (item: PageItem) => `${item.value}`);
    }
    .width('100%');
  }

  @Builder
  private buildSnapshotTextPanel(title: string, summary: string, path: string, content: string, expanded: boolean,
    onToggle: () => void) {
    Column({ space: 4 }) {
      Text(title)
        .fontSize(10)
        .fontWeight(FontWeight.Medium)
        .width('100%');
      Text(summary)
        .fontSize(9)
        .width('100%');
      Text(path.length > 0 ? path : 'No snapshot file')
        .fontSize(9)
        .fontColor('#475569')
        .width('100%');
      if (this.extractSnapshotHighlights(content).length > 0) {
        Column({ space: 2 }) {
          Text('Highlights')
            .fontSize(9)
            .fontWeight(FontWeight.Medium)
            .width('100%');
          ForEach(this.extractSnapshotHighlights(content), (line: string) => {
            Text(line)
              .fontSize(9)
              .fontColor('#0F172A')
              .width('100%');
          }, (line: string) => line);
        }
        .padding(8)
        .backgroundColor('#EFF6FF')
        .borderRadius(8);
      }
      if (content.length > 0) {
        Button(expanded ? 'Collapse' : 'Expand')
          .height(28)
          .fontSize(10)
          .width(96)
          .onClick(() => {
            onToggle();
          });
      }
      if (expanded && content.length > 0) {
        Text(content)
          .fontSize(9)
          .fontColor('#0F172A')
          .width('100%')
          .padding(8)
          .backgroundColor('#F8FAFC')
          .borderRadius(8);
      }
    }
    .padding(10)
    .backgroundColor('#FFFFFF')
    .borderRadius(10)
    .border({ width: 1, color: '#E2E8F0' });
  }

  @Builder
  private buildJsSnapshotCenterSection() {
    Column({ space: 8 }) {
      this.buildSectionTitle('TS 流快照', '这里展示每个 TS 流最近一次采集/播放快照结果。')
      ForEach(this.jsStreams, (stream: JsStreamState) => {
        Column({ space: 6 }) {
          Text(stream.name)
            .fontSize(12)
            .fontWeight(FontWeight.Medium)
            .width('100%');
          this.buildSnapshotTextPanel(`${stream.name} 采集快照`, stream.captureSnapshotStatus,
            stream.captureSnapshotPath, stream.captureSnapshotText, stream.showCaptureSnapshotText, () => {
              stream.showCaptureSnapshotText = !stream.showCaptureSnapshotText;
              this.forceRefresh();
            })
          this.buildSnapshotTextPanel(`${stream.name} 播放快照`, stream.playbackSnapshotStatus,
            stream.playbackSnapshotPath, stream.playbackSnapshotText, stream.showPlaybackSnapshotText, () => {
              stream.showPlaybackSnapshotText = !stream.showPlaybackSnapshotText;
              this.forceRefresh();
            })
        }
        .padding(10)
        .backgroundColor('#F8FAFC')
        .borderRadius(8);
      }, (stream: JsStreamState) => `${stream.id}-${this.refreshVersion}`);
    }
    .padding(12)
    .backgroundColor('#FFFFFF')
    .borderRadius(10)
    .border({ width: 1, color: '#E2E8F0' });
  }

  @Builder
  private buildNativeSnapshotCenterSection() {
    Column({ space: 8 }) {
      this.buildSectionTitle('C 流快照', '这里展示每个 C 流最近一次采集/播放快照结果。')
      ForEach(this.nativeStreams, (stream: NativeStreamState) => {
        Column({ space: 6 }) {
          Text(stream.name)
            .fontSize(12)
            .fontWeight(FontWeight.Medium)
            .width('100%');
          this.buildSnapshotTextPanel(`${stream.name} 采集快照`, stream.captureSnapshotStatus,
            stream.captureSnapshotPath, stream.captureSnapshotText, stream.showCaptureSnapshotText, () => {
              stream.showCaptureSnapshotText = !stream.showCaptureSnapshotText;
              this.forceRefresh();
            })
          this.buildSnapshotTextPanel(`${stream.name} 播放快照`, stream.playbackSnapshotStatus,
            stream.playbackSnapshotPath, stream.playbackSnapshotText, stream.showPlaybackSnapshotText, () => {
              stream.showPlaybackSnapshotText = !stream.showPlaybackSnapshotText;
              this.forceRefresh();
            })
        }
        .padding(10)
        .backgroundColor('#F8FAFC')
        .borderRadius(8);
      }, (stream: NativeStreamState) => `${stream.id}-${this.refreshVersion}`);
    }
    .padding(12)
    .backgroundColor('#FFFFFF')
    .borderRadius(10)
    .border({ width: 1, color: '#E2E8F0' });
  }

  @Builder
  private buildJsStreamCard(stream: JsStreamState) {
    Column({ space: 6 }) {
      Text(stream.name)
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .width('100%');
      Text(`Capture: source=${this.getOptionLabel(SOURCE_OPTIONS, stream.source)} rate=${this.getOptionLabel(SAMPLE_RATE_OPTIONS, stream.sampleRate)} Hz ch=${this.getOptionLabel(CHANNEL_OPTIONS, stream.channelCount)} fmt=${this.getOptionLabel(SAMPLE_FORMAT_OPTIONS, stream.sampleFormat)}`)
        .fontSize(10)
        .width('100%');
      Text(`Playback: usage=${this.getOptionLabel(PLAYBACK_USAGE_OPTIONS, this.playbackUsage)} rate=${this.getOptionLabel(SAMPLE_RATE_OPTIONS, this.playbackSampleRate)} Hz ch=${this.getOptionLabel(CHANNEL_OPTIONS, this.playbackChannelCount)} fmt=${this.getOptionLabel(SAMPLE_FORMAT_OPTIONS, this.playbackSampleFormat)}`)
        .fontSize(9)
        .fontColor('#475569')
        .width('100%');
      Row({ space: 6 }) {
        this.buildSelectField('Source', SOURCE_OPTIONS, stream.source, (nextValue: number) => {
          stream.source = nextValue;
          this.forceRefresh();
        })
        this.buildSelectField('Sample Rate', SAMPLE_RATE_OPTIONS, stream.sampleRate, (nextValue: number) => {
          stream.sampleRate = nextValue;
          this.forceRefresh();
        })
      }
      Row({ space: 6 }) {
        this.buildSelectField('Channels', CHANNEL_OPTIONS, stream.channelCount, (nextValue: number) => {
          stream.channelCount = nextValue;
          this.forceRefresh();
        })
        this.buildSelectField('Format', SAMPLE_FORMAT_OPTIONS, stream.sampleFormat, (nextValue: number) => {
          stream.sampleFormat = nextValue;
          this.forceRefresh();
        })
      }
      Row({ space: 6 }) {
        Button('创建')
          .height(32)
          .fontSize(11)
          .layoutWeight(1)
          .onClick(() => {
            void this.createJsCapturer(stream);
          });
        Button('启动')
          .height(32)
          .fontSize(11)
          .layoutWeight(1)
          .onClick(() => {
            void this.startJsCapturer(stream);
          });
        Button('停止')
          .height(32)
          .fontSize(11)
          .layoutWeight(1)
          .onClick(() => {
            void this.stopJsCapturer(stream);
          });
        Button('释放')
          .height(32)
          .fontSize(11)
          .layoutWeight(1)
          .onClick(() => {
            void this.releaseJsCapturer(stream);
          });
      }
      Column({ space: 6 }) {
        Row({ space: 6 }) {
          Button('采集快照')
            .height(32)
            .fontSize(11)
            .layoutWeight(1)
            .onClick(() => {
              this.printJsCaptureSnapshot(stream);
            });
          Button('播放快照')
            .height(32)
            .fontSize(11)
            .layoutWeight(1)
            .onClick(() => {
              this.printJsPlaybackSnapshot(stream);
            });
        }
        Row({ space: 6 }) {
          Button('播放')
            .height(32)
            .fontSize(11)
            .layoutWeight(1)
            .onClick(() => {
              void this.playJsRecording(stream);
            });
          Button('停止播放')
            .height(32)
            .fontSize(11)
            .layoutWeight(1)
            .onClick(() => {
              void this.stopJsPlayback(stream);
            });
        }
      }
      Text(`State: ${stream.stateText} | streamId=${stream.streamId} | buffer=${stream.bufferSize}`)
        .fontSize(10)
        .width('100%');
      Text(`PCM: ${stream.savePath.length > 0 ? stream.savePath : 'None'}`)
        .fontSize(9)
        .width('100%');
      Text(`Saved: ${this.formatBytes(stream.savedBytes)} | saveRet=${stream.saveRet}`)
        .fontSize(10)
        .width('100%');
      Text(`Playback: ${this.describeJsPlaybackState(stream.playbackState)} | ${this.formatBytes(stream.playedBytes)} / ${this.formatBytes(stream.playTotalBytes)}`)
        .fontSize(10)
        .width('100%');
      Text(stream.captureSnapshotStatus)
        .fontSize(9)
        .width('100%');
      Text(`Capture snap file: ${stream.captureSnapshotPath.length > 0 ? stream.captureSnapshotPath : 'None'}`)
        .fontSize(9)
        .width('100%');
      if (stream.captureSnapshotText.length > 0) {
        Button(stream.showCaptureSnapshotText ? 'Collapse' : 'Expand Capture')
          .height(28)
          .fontSize(10)
          .width(120)
          .onClick(() => {
            stream.showCaptureSnapshotText = !stream.showCaptureSnapshotText;
            this.forceRefresh();
          });
      }
      if (stream.showCaptureSnapshotText && stream.captureSnapshotText.length > 0) {
        Text(stream.captureSnapshotText)
          .fontSize(9)
          .width('100%')
          .padding(8)
          .backgroundColor('#FFFFFF')
          .borderRadius(8);
      }
      Text(stream.playbackSnapshotStatus)
        .fontSize(9)
        .width('100%');
      Text(`Playback snap file: ${stream.playbackSnapshotPath.length > 0 ? stream.playbackSnapshotPath : 'None'}`)
        .fontSize(9)
        .width('100%');
      if (stream.playbackSnapshotText.length > 0) {
        Button(stream.showPlaybackSnapshotText ? 'Collapse' : 'Expand Playback')
          .height(28)
          .fontSize(10)
          .width(120)
          .onClick(() => {
            stream.showPlaybackSnapshotText = !stream.showPlaybackSnapshotText;
            this.forceRefresh();
          });
      }
      if (stream.showPlaybackSnapshotText && stream.playbackSnapshotText.length > 0) {
        Text(stream.playbackSnapshotText)
          .fontSize(9)
          .width('100%')
          .padding(8)
          .backgroundColor('#FFFFFF')
          .borderRadius(8);
      }
    }
    .padding(10)
    .backgroundColor('#F8FAFC')
    .borderRadius(8);
  }

  @Builder
  private buildNativeStreamCard(stream: NativeStreamState) {
    Column({ space: 6 }) {
      Text(stream.name)
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .width('100%');
      Text(`Capture: source=${this.getOptionLabel(SOURCE_OPTIONS, stream.source)} rate=${this.getOptionLabel(SAMPLE_RATE_OPTIONS, stream.sampleRate)} Hz ch=${this.getOptionLabel(CHANNEL_OPTIONS, stream.channelCount)} fmt=${this.getOptionLabel(SAMPLE_FORMAT_OPTIONS, stream.sampleFormat)}`)
        .fontSize(10)
        .width('100%');
      Text(`Playback: usage=${this.getOptionLabel(PLAYBACK_USAGE_OPTIONS, this.playbackUsage)} rate=${this.getOptionLabel(SAMPLE_RATE_OPTIONS, this.playbackSampleRate)} Hz ch=${this.getOptionLabel(CHANNEL_OPTIONS, this.playbackChannelCount)} fmt=${this.getOptionLabel(SAMPLE_FORMAT_OPTIONS, this.playbackSampleFormat)}`)
        .fontSize(9)
        .fontColor('#475569')
        .width('100%');
      Row({ space: 6 }) {
        this.buildSelectField('Source', SOURCE_OPTIONS, stream.source, (nextValue: number) => {
          stream.source = nextValue;
          this.forceRefresh();
        })
        this.buildSelectField('Sample Rate', SAMPLE_RATE_OPTIONS, stream.sampleRate, (nextValue: number) => {
          stream.sampleRate = nextValue;
          this.forceRefresh();
        })
      }
      Row({ space: 6 }) {
        this.buildSelectField('Channels', CHANNEL_OPTIONS, stream.channelCount, (nextValue: number) => {
          stream.channelCount = nextValue;
          this.forceRefresh();
        })
        this.buildSelectField('Format', SAMPLE_FORMAT_OPTIONS, stream.sampleFormat, (nextValue: number) => {
          stream.sampleFormat = nextValue;
          this.forceRefresh();
        })
      }
      Row({ space: 6 }) {
        Button('创建')
          .height(32)
          .fontSize(11)
          .layoutWeight(1)
          .onClick(() => {
            this.appendLog(`${stream.name} create clicked`);
            void this.handleNativeCreate(stream);
          });
        Button('启动')
          .height(32)
          .fontSize(11)
          .layoutWeight(1)
          .onClick(() => {
            void this.handleNativeStart(stream);
          });
        Button('停止')
          .height(32)
          .fontSize(11)
          .layoutWeight(1)
          .onClick(() => {
            void this.handleNativeStop(stream);
          });
        Button('释放')
          .height(32)
          .fontSize(11)
          .layoutWeight(1)
          .onClick(() => {
            void this.handleNativeRelease(stream);
          });
      }
      Column({ space: 6 }) {
        Row({ space: 6 }) {
          Button('采集快照')
            .height(32)
            .fontSize(11)
            .layoutWeight(1)
            .onClick(() => {
              void this.handleNativeCaptureSnapshot(stream);
            });
          Button('播放快照')
            .height(32)
            .fontSize(11)
            .layoutWeight(1)
            .onClick(() => {
              void this.handleNativePlaybackSnapshot(stream);
            });
        }
        Row({ space: 6 }) {
          Button('播放')
            .height(32)
            .fontSize(11)
            .layoutWeight(1)
            .onClick(() => {
              void this.handleNativePlayback(stream);
            });
          Button('停止播放')
            .height(32)
            .fontSize(11)
            .layoutWeight(1)
            .onClick(() => {
              void this.handleNativeStopPlayback(stream);
            });
        }
      }
      Text(`State: ${stream.stateText} | streamId=${stream.streamRuntimeId} | buffer=${stream.bufferSize}`)
        .fontSize(10)
        .width('100%');
      Text(`PCM: ${stream.savePath.length > 0 ? stream.savePath : 'None'}`)
        .fontSize(9)
        .width('100%');
      Text(`Saved: ${this.formatBytes(stream.savedBytes)} | saveRet=${stream.saveRet}`)
        .fontSize(10)
        .width('100%');
      Text(`Callbacks: count=${stream.callbackCount} last=${stream.lastReadSize} err=${stream.lastError}`)
        .fontSize(10)
        .width('100%');
      Text(`Playback: ${this.describeNativePlaybackState(stream.playbackState)} | ${this.formatBytes(stream.playedBytes)} / ${this.formatBytes(stream.playTotalBytes)} | err=${stream.playbackError}`)
        .fontSize(10)
        .width('100%');
      Text(stream.captureSnapshotStatus)
        .fontSize(9)
        .width('100%');
      Text(`Capture snap file: ${stream.captureSnapshotPath.length > 0 ? stream.captureSnapshotPath : 'None'}`)
        .fontSize(9)
        .width('100%');
      if (stream.captureSnapshotText.length > 0) {
        Button(stream.showCaptureSnapshotText ? 'Collapse' : 'Expand Capture')
          .height(28)
          .fontSize(10)
          .width(120)
          .onClick(() => {
            stream.showCaptureSnapshotText = !stream.showCaptureSnapshotText;
            this.forceRefresh();
          });
      }
      if (stream.showCaptureSnapshotText && stream.captureSnapshotText.length > 0) {
        Text(stream.captureSnapshotText)
          .fontSize(9)
          .width('100%')
          .padding(8)
          .backgroundColor('#FFFFFF')
          .borderRadius(8);
      }
      Text(stream.playbackSnapshotStatus)
        .fontSize(9)
        .width('100%');
      Text(`Playback snap file: ${stream.playbackSnapshotPath.length > 0 ? stream.playbackSnapshotPath : 'None'}`)
        .fontSize(9)
        .width('100%');
      if (stream.playbackSnapshotText.length > 0) {
        Button(stream.showPlaybackSnapshotText ? 'Collapse' : 'Expand Playback')
          .height(28)
          .fontSize(10)
          .width(120)
          .onClick(() => {
            stream.showPlaybackSnapshotText = !stream.showPlaybackSnapshotText;
            this.forceRefresh();
          });
      }
      if (stream.showPlaybackSnapshotText && stream.playbackSnapshotText.length > 0) {
        Text(stream.playbackSnapshotText)
          .fontSize(9)
          .width('100%')
          .padding(8)
          .backgroundColor('#FFFFFF')
          .borderRadius(8);
      }
    }
    .padding(10)
    .backgroundColor('#F8FAFC')
    .borderRadius(8);
  }

  @Builder
  private buildHeaderPanel() {
    Column({ space: 4 }) {
      Text($r('app.string.APP_TITLE'))
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor('#0F172A')
        .width('100%');
      Text('Concurrent snapshot verification: TS streams, C streams, stream-level snapshots, and aggregated app diagnostics')
        .fontSize(11)
        .fontColor('#475569')
        .width('100%');
      this.buildPageSelector()
      Text(this.status)
        .fontSize(10)
        .fontColor('#111827')
        .width('100%')
        .padding(8)
        .backgroundColor('#F8FAFC')
        .borderRadius(8);
    }
    .padding(12)
    .backgroundColor('#FFFFFF')
    .borderRadius(10)
    .border({ width: 1, color: '#E2E8F0' });
  }

  @Builder
  private buildJsPage() {
    Column({ space: 8 }) {
      this.buildSectionTitle('TS 并发流', '同时创建两个 JS 采集流，打印采集/播放快照。')
      ForEach(this.jsStreams, (stream: JsStreamState) => {
        this.buildJsStreamCard(stream);
      }, (stream: JsStreamState) => `${stream.id}-${this.refreshVersion}`);
    }
    .padding(12)
    .backgroundColor('#FFFFFF')
    .borderRadius(10)
    .border({ width: 1, color: '#E2E8F0' });
  }

  @Builder
  private buildNativePage() {
    Column({ space: 8 }) {
      this.buildSectionTitle('C 并发流', '同时创建两个 C 采集流，打印采集/播放快照。')
      ForEach(this.nativeStreams, (stream: NativeStreamState) => {
        this.buildNativeStreamCard(stream);
      }, (stream: NativeStreamState) => `${stream.id}-${this.refreshVersion}`);
    }
    .padding(12)
    .backgroundColor('#FFFFFF')
    .borderRadius(10)
    .border({ width: 1, color: '#E2E8F0' });
  }

  @Builder
  private buildSnapshotCenterPage() {
    Column({ space: 10 }) {
      Column({ space: 8 }) {
        this.buildSectionTitle('快照中心', '一次性捕获所有可用的采集级和播放级快照，并展示本次生成的 txt 文件路径。')
        Row({ space: 6 }) {
          Button('捕获所有快照')
            .height(32)
            .fontSize(11)
            .layoutWeight(1)
            .onClick(() => {
              this.printAllAvailableSnapshots();
            });
        }
        Text('这里仅展示本次批量捕获实际生成的 txt 文件路径，不再展示 TS/C 应用级快照卡片。')
          .fontSize(9)
          .width('100%');
        Column({ space: 2 }) {
          Text('本次捕获所有快照生成的文件列表')
            .fontSize(10)
            .fontWeight(FontWeight.Medium)
            .width('100%');
          ForEach(this.recentSnapshotFiles, (line: string) => {
            Text(line)
              .fontSize(9)
              .fontColor('#475569')
              .width('100%');
          }, (line: string) => line);
        }
        .padding(8)
        .backgroundColor('#F8FAFC')
        .borderRadius(8);
      }
      .padding(12)
      .backgroundColor('#FFFFFF')
      .borderRadius(10)
      .border({ width: 1, color: '#E2E8F0' });

      this.buildJsSnapshotCenterSection()

      this.buildNativeSnapshotCenterSection()

      Column({ space: 6 }) {
        this.buildSectionTitle('Framework 快照', '系统观察到的活跃采集流。在并发场景下最有用。')
        ForEach(this.frameworkSnapshot, (line: string) => {
          Text(line)
            .fontSize(9)
            .width('100%');
        }, (line: string) => line);
      }
      .padding(12)
      .backgroundColor('#FFFFFF')
      .borderRadius(10)
      .border({ width: 1, color: '#E2E8F0' });

      Column({ space: 6 }) {
        this.buildSectionTitle('事件日志', '最近的操作和错误。')
        if (this.logs.length === 0) {
          Text('暂无事件')
            .fontSize(9)
            .width('100%');
        }
        ForEach(this.logs, (line: string) => {
          Text(line)
            .fontSize(9)
            .width('100%');
        }, (line: string) => line);
      }
      .padding(12)
      .backgroundColor('#FFFFFF')
      .borderRadius(10)
      .border({ width: 1, color: '#E2E8F0' });
    }
  }

  @Builder
  private buildCurrentPage() {
    if (this.currentPage === 0) {
      this.buildJsPage()
    } else if (this.currentPage === 1) {
      this.buildNativePage()
    } else {
      this.buildSnapshotCenterPage()
    }
  }

  build() {
    Scroll() {
      Column({ space: 10 }) {
        Text(`${this.refreshVersion}`)
          .fontSize(1)
          .fontColor('#00000000')
          .width(1)
          .height(1);
        this.buildHeaderPanel()
        this.buildCurrentPage()
      }
      .padding(10)
      .width('100%');
    }
    .backgroundColor('#F3F4F6')
    .scrollBar(BarState.Auto);
  }
}
