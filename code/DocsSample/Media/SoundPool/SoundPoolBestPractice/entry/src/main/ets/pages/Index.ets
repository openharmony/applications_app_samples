/**
 * SoundPool 最佳实践 Demo（完整代码）
 *
 * 修正内容：
 * 1. 对象字面量显式声明类型（避免 arkts-no-untyped-obj-literals）
 * 2. Promise 显式指定泛型类型（避免 arkts-no-inferred-generic-params）
 * 3. 箭头函数体使用块语句（避免 arkts-no-implicit-return-types）
 */

import { media } from '@kit.MediaKit';
import { audio } from '@kit.AudioKit';
import { BusinessError } from '@kit.BasicServicesKit';
import common from '@ohos.app.ability.common';

// ---------- 定义数据结构 ----------
// 音频文件信息接口（解决 arkts-no-untyped-obj-literals 问题）
interface AudioFileInfo {
  name: string;
  soundId: number;
  loaded: boolean;
  settings: PlaySettings;
}

// 播放参数接口
interface PlaySettings {
  loop: number;
  leftVolume: number;
  rightVolume: number;
  priority: number;
  rate: number;
}

// 活跃音频流信息
interface ActiveStream {
  streamId: number;
  audioName: string;
  priority: number;
}

@Entry
@Component
struct SoundPoolBestPracticeDemo {
  // UI 状态
  @State message: string = 'SoundPool 最佳实践 Demo';
  @State soundPoolCreated: boolean = false;
  @State loadedCount: number = 0;
  @State activeStreams: ActiveStream[] = [];

  // 私有成员
  private soundPool: media.SoundPool | null = null;
  private audioFiles: AudioFileInfo[] = [];
  private context: common.UIAbilityContext | null = null;

  // 预定义音频文件名（需放在 resources/rawfile 目录下）
  //SoundPool只会加载播放前1MB的内容
  private readonly AUDIO_NAMES: string[] = [
    'demo.mp3',
    'demo.mp3',
    'demo.mp3',
    'demo.mp3'
  ];

  // ---------- 生命周期 ----------
  async aboutToAppear() {
    this.context = getContext(this) as common.UIAbilityContext;
    this.initAudioFiles();
    this.showMessage('请先点击“创建 SoundPool”');
  }

  async aboutToDisappear() {
    await this.releaseSoundPool();
  }

  // ---------- 辅助方法 ----------
  private showMessage(msg: string, timeout: number = 3000) {
    this.message = msg;
    setTimeout(() => {
      this.message = '';
    }, timeout);
  }

  private forceRefresh() {
    // 通过修改无关状态触发 UI 刷新
    this.loadedCount = this.loadedCount;
  }

  // 初始化音频文件列表（显式返回类型解决 arkts-no-untyped-obj-literals）
  private initAudioFiles() {
    this.audioFiles = this.AUDIO_NAMES.map(name => {
      const fileInfo: AudioFileInfo = {
        name: name,
        soundId: -1,
        loaded: false,
        settings: {
          loop: 0,
          leftVolume: 1.0,
          rightVolume: 1.0,
          priority: 1,
          rate: audio.AudioRendererRate.RENDER_RATE_NORMAL
        }
      };
      return fileInfo;
    });
  }

  // ---------- 1. 创建 SoundPool ----------
  private createSoundPool() {
    const audioRendererInfo: audio.AudioRendererInfo = {
      usage: audio.StreamUsage.STREAM_USAGE_MUSIC,
      rendererFlags: 0
    };
    const maxStreams = 8;

    media.createSoundPool(maxStreams, audioRendererInfo, (err: BusinessError, sp: media.SoundPool) => {
      if (err) {
        console.error(`创建 SoundPool 失败: ${err.message}`);
        this.showMessage(`创建失败: ${err.message}`);
        return;
      }
      this.soundPool = sp;
      this.soundPoolCreated = true;
      this.showMessage(`SoundPool 创建成功，最大并发流: ${maxStreams}`);
      this.registerListeners();
    });
  }

  // ---------- 2. 注册事件监听 ----------
  private registerListeners() {
    if (!this.soundPool) return;

    // 音频加载完成事件
    this.soundPool.on('loadComplete', (soundId: number) => {
      console.info(`音频加载完成，soundId: ${soundId}`);
      const index = this.audioFiles.findIndex(f => f.soundId === soundId);
      if (index !== -1) {
        this.audioFiles[index].loaded = true;
        this.loadedCount = this.audioFiles.filter(f => f.loaded).length;
        this.showMessage(`${this.audioFiles[index].name} 加载完成`);
        this.forceRefresh();
      }
    });

    // 播放完成事件
    this.soundPool.on('playFinishedWithStreamId', (streamId: number) => {
      console.info(`播放完成，streamId: ${streamId}`);
      const idx = this.activeStreams.findIndex(s => s.streamId === streamId);
      if (idx !== -1) {
        this.activeStreams.splice(idx, 1);
        this.forceRefresh();
      }
    });

    // 错误事件
    this.soundPool.on('error', (error: BusinessError) => {
      console.error(`SoundPool 错误: ${error.code} - ${error.message}`);
      this.showMessage(`错误: ${error.message}`);
    });
  }

  // ---------- 3. 加载所有音频 ----------
  private async loadAllAudios() {
    if (!this.soundPool) {
      this.showMessage('请先创建 SoundPool');
      return;
    }
    if (!this.context) {
      this.showMessage('上下文无效');
      return;
    }

    const resourceManager = this.context.resourceManager;
    for (let i = 0; i < this.audioFiles.length; i++) {
      const file = this.audioFiles[i];
      // 若已加载，先卸载
      if (file.soundId !== -1) {
        this.soundPool.unload(file.soundId);
        file.soundId = -1;
        file.loaded = false;
      }

      try {
        const fd = await resourceManager.getRawFd(file.name);
        this.soundPool.load(
          fd.fd,
          fd.offset,
          fd.length,
          (err: BusinessError, soundId: number) => {
            if (err) {
              console.error(`加载 ${file.name} 失败: ${err.message}`);
              this.showMessage(`加载失败: ${file.name}`);
              return;
            }
            file.soundId = soundId;
            this.forceRefresh();
          }
        );
        // 修正：Promise 显式指定 void 类型
        await new Promise<void>(resolve => setTimeout(resolve, 200));
      } catch (err) {
        console.error(`获取资源 ${file.name} 失败: ${err}`);
        this.showMessage(`资源不存在: ${file.name}`);
      }
    }
    this.showMessage('开始加载所有音频，请稍后...');
  }

  // ---------- 4. 播放音频 ----------
  private playAudio(index: number) {
    const file = this.audioFiles[index];
    if (!this.soundPool) {
      this.showMessage('SoundPool 未创建');
      return;
    }
    if (!file.loaded) {
      this.showMessage(`音频未就绪: ${file.name}`);
      return;
    }

    const playParams: media.PlayParameters = {
      loop: file.settings.loop,
      rate: file.settings.rate,
      leftVolume: file.settings.leftVolume,
      rightVolume: file.settings.rightVolume,
      priority: file.settings.priority
    };

    this.soundPool.play(file.soundId, playParams, (err: BusinessError, streamId: number) => {
      if (err) {
        console.error(`播放失败: ${err.message}`);
        this.showMessage(`播放失败: ${err.message}`);
        return;
      }
      console.info(`开始播放 ${file.name}，streamId: ${streamId}`);
      this.activeStreams.push({
        streamId: streamId,
        audioName: file.name,
        priority: file.settings.priority
      });
      this.forceRefresh();
    });
  }

  // ---------- 5. 动态修改参数 ----------
  private setLoop(index: number, loop: number) {
    const file = this.audioFiles[index];
    file.settings.loop = loop;
    this.applyToActiveStream(file, streamId => {
      this.soundPool?.setLoop(streamId, loop, (err) => {
        if (err) console.error(`设置循环失败: ${err.message}`);
      });
    });
    this.showMessage(`设置循环 ${loop} 次`);
  }

  private setVolume(index: number, left: number, right: number) {
    const file = this.audioFiles[index];
    file.settings.leftVolume = left;
    file.settings.rightVolume = right;
    this.applyToActiveStream(file, streamId => {
      this.soundPool?.setVolume(streamId, left, right, (err) => {
        if (err) console.error(`设置音量失败: ${err.message}`);
      });
    });
    this.showMessage(`设置音量 ${left * 100}%`);
  }

  private setPriority(index: number, priority: number) {
    const file = this.audioFiles[index];
    file.settings.priority = priority;
    this.applyToActiveStream(file, streamId => {
      this.soundPool?.setPriority(streamId, priority, (err) => {
        if (err) console.error(`设置优先级失败: ${err.message}`);
        else {
          const stream = this.activeStreams.find(s => s.streamId === streamId);
          if (stream) stream.priority = priority;
          this.forceRefresh();
        }
      });
    });
    this.showMessage(`设置优先级 ${priority}`);
  }

  private setRate(index: number, rate: number) {
    const file = this.audioFiles[index];
    file.settings.rate = rate;
    this.applyToActiveStream(file, streamId => {
      this.soundPool?.setRate(streamId, rate, (err) => {
        if (err) console.error(`设置速率失败: ${err.message}`);
      });
    });
    this.showMessage(`设置速率 ${rate}`);
  }

  private applyToActiveStream(file: AudioFileInfo, callback: (streamId: number) => void) {
    const streams = this.activeStreams.filter(s => s.audioName === file.name);
    streams.forEach(s => callback(s.streamId));
  }

  // ---------- 6. 停止播放 ----------
  private stopAudio(index: number) {
    const file = this.audioFiles[index];
    const streams = this.activeStreams.filter(s => s.audioName === file.name);
    if (streams.length === 0) {
      this.showMessage(`没有正在播放的 ${file.name}`);
      return;
    }
    streams.forEach(s => {
      this.stopStream(s.streamId);
    });
  }

  private stopStream(streamId: number) {
    if (!this.soundPool) return;
    this.soundPool.stop(streamId, (err) => {
      if (err) {
        console.error(`停止流 ${streamId} 失败: ${err.message}`);
      } else {
        console.info(`流 ${streamId} 已停止`);
        const idx = this.activeStreams.findIndex(s => s.streamId === streamId);
        if (idx !== -1) this.activeStreams.splice(idx, 1);
        this.forceRefresh();
      }
    });
  }

  private stopAll() {
    if (!this.soundPool) return;
    // 复制一份避免遍历时修改（使用块语句解决隐式返回类型）
    const streamsCopy = [...this.activeStreams];
    streamsCopy.forEach(s => {
      this.stopStream(s.streamId);
    });
    this.showMessage('已停止所有音频');
  }

  // ---------- 7. 释放资源 ----------
  private async releaseSoundPool() {
    if (!this.soundPool) return;

    this.stopAll();

    for (const file of this.audioFiles) {
      if (file.soundId !== -1) {
        this.soundPool.unload(file.soundId);
        file.soundId = -1;
        file.loaded = false;
      }
    }

    this.soundPool.off('loadComplete');
    this.soundPool.off('playFinishedWithStreamId');
    this.soundPool.off('error');

    this.soundPool.release();
    this.soundPool = null;
    this.soundPoolCreated = false;
    this.loadedCount = 0;
    this.activeStreams = [];
    this.showMessage('SoundPool 已释放');
  }

  // ---------- UI 构建 ----------
  build() {
    Scroll() {
      Column({ space: 20 }) {
        // 消息显示
        if (this.message) {
          Text(this.message)
            .fontSize(16)
            .textAlign(TextAlign.Center)
            .width('100%')
            .padding(10)
            .backgroundColor('#F0F0F0')
            .borderRadius(5)
        }

        // 状态栏
        Row({ space: 10 }) {
          Text(`SoundPool: ${this.soundPoolCreated ? '已创建' : '未创建'}`)
            .fontColor(this.soundPoolCreated ? '#00AA00' : '#AA0000')
          Text(`已加载: ${this.loadedCount}/${this.audioFiles.length}`)
          Text(`活跃流: ${this.activeStreams.length}`)
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceAround)

        // 控制按钮组
        Button('1. 创建 SoundPool (最大8流)')
          .width('100%')
          .onClick(() => this.createSoundPool())
        Button('2. 加载所有音频')
          .width('100%')
          .onClick(() => this.loadAllAudios())
        Button('3. 停止所有音频')
          .width('100%')
          .onClick(() => this.stopAll())
        Button('4. 释放所有资源')
          .width('100%')
          .backgroundColor('#FF6666')
          .onClick(() => this.releaseSoundPool())

        // 每个音频的独立控制面板
        ForEach(this.audioFiles, (file: AudioFileInfo, idx: number) => {
          Column({ space: 5 }) {
            Text(`${file.name} ${file.loaded ? '✓' : '✗'}`)
              .fontSize(16)
              .fontWeight(FontWeight.Bold)

            Row({ space: 5 }) {
              Button('播放')
                .layoutWeight(1)
                .onClick(() => this.playAudio(idx))
              Button('停止')
                .layoutWeight(1)
                .onClick(() => this.stopAudio(idx))
            }
            .width('100%')

            Row({ space: 5 }) {
              Button('循环 3 次')
                .layoutWeight(1)
                .onClick(() => this.setLoop(idx, 3))
              Button('无限循环')
                .layoutWeight(1)
                .onClick(() => this.setLoop(idx, -1))
              Button('不循环')
                .layoutWeight(1)
                .onClick(() => this.setLoop(idx, 0))
            }
            .width('100%')

            Row({ space: 5 }) {
              Button('音量 50%')
                .layoutWeight(1)
                .onClick(() => this.setVolume(idx, 0.5, 0.5))
              Button('音量 100%')
                .layoutWeight(1)
                .onClick(() => this.setVolume(idx, 1.0, 1.0))
              Button('静音')
                .layoutWeight(1)
                .onClick(() => this.setVolume(idx, 0, 0))
            }
            .width('100%')

            Row({ space: 5 }) {
              Button('优先级 1')
                .layoutWeight(1)
                .onClick(() => this.setPriority(idx, 1))
              Button('优先级 8')
                .layoutWeight(1)
                .onClick(() => this.setPriority(idx, 8))
            }
            .width('100%')

            Row({ space: 5 }) {
              Button('速率 0.5x')
                .layoutWeight(1)
                .onClick(() => this.setRate(idx, audio.AudioRendererRate.RENDER_RATE_HALF))
              Button('正常')
                .layoutWeight(1)
                .onClick(() => this.setRate(idx, audio.AudioRendererRate.RENDER_RATE_NORMAL))
              Button('速率 2.0x')
                .layoutWeight(1)
                .onClick(() => this.setRate(idx, audio.AudioRendererRate.RENDER_RATE_DOUBLE))
            }
            .width('100%')
          }
          .width('100%')
          .padding(10)
          .backgroundColor('#FAFAFA')
          .borderRadius(8)
          .margin({ top: 5 })
        })

        // 显示正在播放的音频列表
        Column({ space: 5 }) {
          Text('正在播放:')
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
          ForEach(this.activeStreams, (stream: ActiveStream) => {
            Row({ space: 5 }) {
              Text(`${stream.audioName}`)
                .layoutWeight(1)
              Text(`P:${stream.priority}`)
                .fontSize(12)
                .fontColor('#FFA500')
              Button('停止')
                .width(60)
                .height(28)
                .fontSize(12)
                .backgroundColor('#FF6666')
                .onClick(() => this.stopStream(stream.streamId))
            }
            .width('100%')
            .padding(5)
            .backgroundColor('#F8F8F8')
            .borderRadius(4)
          })
        }
        .width('100%')
        .padding(10)
        .backgroundColor('#FFFFFF')
        .borderRadius(8)
      }
      .padding(20)
    }
  }
}