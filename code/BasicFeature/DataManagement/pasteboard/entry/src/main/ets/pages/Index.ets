import { BusinessError } from '@ohos.base';
import unifiedDataChannel from '@ohos.data.unifiedDataChannel';
import pasteboard from '@ohos.pasteboard';
import uniformTypeDescriptor from '@ohos.data.uniformTypeDescriptor';
// import { pasteboardkit } from '@kit.BasicServicesKit';
import Log from '../../common/Log'

const TAG: string = 'pasteboard->';

@Entry
@Component
struct Index {
  @State text: string = 'Hello World';
  // @State text: string = ''
  controller: TextAreaController = new TextAreaController()


  addLog(message: string): void {
    Log.showInfo(TAG, `kikaInput-new: ${message}`);
  }

  build() {
    Row() {

      Column() {
        Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceEvenly }) {
          TextArea({
            text: this.text,
            placeholder: 'The text area can hold an unlimited amount of text. input your word...',
            controller: this.controller
          })
            .placeholderFont({ size: 16, weight: 400 })
            .width(336)
            .height(56)
            .margin(20)
            .fontSize(16)
            .fontColor('#182431')
            .backgroundColor(Color.Red)
            .id('pasteTextArea')
            .onChange((value: string) => {
              this.text = value
            })
          // Text($r('app.string.Button_copy'))
          // Row() {
          Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
            Button($r('app.string.Button_copy'))
              .backgroundColor('#007DFF')
              .margin(15)
              .onClick(() => {

                this.addLog('text arear content :' + this.text);
                let plainTextData = new unifiedDataChannel.UnifiedData();
                let plainText = new unifiedDataChannel.PlainText();
                plainText.details = {
                    Key: 'delayPlaintext',
                    Value: this.text,
                };
                plainText.textContent = this.text;
                plainText.abstract = 'delayTextContent'; // 'delayTextContent'
                plainTextData.addRecord(plainText);

                let systemPasteboard: pasteboard.SystemPasteboard = pasteboard.getSystemPasteboard();
                systemPasteboard.setUnifiedData(plainTextData).then((data: void) => {
                    console.info('Succeeded in setting UnifiedData.');
                }).catch((err: BusinessError) => {
                    console.error('Failed to set UnifiedData. Cause: ' + err.message);
                });
              })
            Button($r('app.string.Button_paste'))
              .backgroundColor('#007DFF')
              .margin(15)
              .onClick(() => {
                // 设置光标位置到第一个字符后
                let systemPasteboard: pasteboard.SystemPasteboard = pasteboard.getSystemPasteboard();
                systemPasteboard.getUnifiedData().then((data) => {
                  let records = data.getRecords();
                  this.addLog('Button_paste records.length: ' + records.length);
                  for (let j = 0; j < records.length; j++) {
                    if (records[j].getType() === uniformTypeDescriptor.UniformDataType.PLAIN_TEXT) {
                      let text = records[j] as unifiedDataChannel.PlainText;
                      this.text = text.textContent;
                      this.addLog('Button_paste' + `${j + 1}.${text.textContent}`);
                    }
                  }
                }).catch((err: BusinessError) => {
                  this.addLog('Failed to get UnifiedData. Cause: ' + err.message);
                });
              })
          }.height('10%').backgroundColor(Color.Orange)

          // }.width('100%').height('30%').backgroundColor('#F1F3F5')

          PasteButton()
            .backgroundColor('#007DFF')
            // .margin(15)
            // .onClick(() => {
              // 设置光标位置到第一个字符后
              // this.controller.caretPosition(1)

              // TextInput({ placeholder: '请输入验证码', text: this.message })
              .onClick((event: ClickEvent, result: PasteButtonOnClickResult) => {
                this.addLog('PasteButton onclick!')
                if (PasteButtonOnClickResult.SUCCESS === result) {
                  pasteboard.getSystemPasteboard().getData((err: BusinessError, pasteData: pasteboard.PasteData) => {
                    if (err) {
                      this.addLog(`Failed to get paste data. Code is ${err.code}, message is ${err.message}`);
                      return;
                    }
                    // 剪贴板内容为 'Hello World'
                    this.text = pasteData.getPrimaryText();
                    this.addLog('PasteButton onclick getPrimaryText: ' + this.text)
                  });
                }
              // })
            })

          Button($r('app.string.Button_text_paste'))
            .backgroundColor('#007DFF')
            .margin(15)
            .id('textPaste')
            .onClick(() => {
              // 设置光标位置到第一个字符后

              let systemPasteboard: pasteboard.SystemPasteboard = pasteboard.getSystemPasteboard();
              let result: boolean = systemPasteboard.hasDataType(pasteboard.MIMETYPE_TEXT_PLAIN);
              if (result) {
                let systemPasteboard: pasteboard.SystemPasteboard = pasteboard.getSystemPasteboard();
                systemPasteboard.getUnifiedData().then((data) => {
                  let records = data.getRecords();
                  for (let j = 0; j < records.length; j++) {
                    if (records[j].getType() === uniformTypeDescriptor.UniformDataType.PLAIN_TEXT) {
                      let text = records[j] as unifiedDataChannel.PlainText;
                      this.text = text.textContent;
                      this.addLog('Button_text_paste' + `${j + 1}.${text.textContent}`);
                    }
                  }
                }).catch((err: BusinessError) => {
                  this.addLog('Failed to get UnifiedData. Cause: ' + err.message);
                });

              } else {
                this.addLog('Check the PLAIN_TEXT DataType fail!')
              }
            })
          Button($r('app.string.Button_device_paste'))
            .backgroundColor('#007DFF')
            .margin(15)
            .onClick(() => {
              // 设置光标位置到第一个字符后
              // this.controller.caretPosition(1)

              let systemPasteboard: pasteboard.SystemPasteboard = pasteboard.getSystemPasteboard();
              let result: boolean = systemPasteboard.isRemoteData();
              if (result) {
                let systemPasteboard: pasteboard.SystemPasteboard = pasteboard.getSystemPasteboard();
                systemPasteboard.getUnifiedData().then((data) => {
                  let records = data.getRecords();
                  for (let j = 0; j < records.length; j++) {
                    if (records[j].getType() === uniformTypeDescriptor.UniformDataType.PLAIN_TEXT) {
                      let text = records[j] as unifiedDataChannel.PlainText;
                      this.text = text.textContent;
                      this.addLog('Button_device_paste' + `${j + 1}.${text.textContent}`);
                    }
                  }
                }).catch((err: BusinessError) => {
                  this.addLog('Failed to get UnifiedData. Cause: ' + err.message);
                });
              } else {
                this.addLog('Check isRemoteData DataType fail!');
              }
            })
          // Column() {
          //   Text(this.message)
          //     .fontSize(50)
          //     .fontWeight(FontWeight.Bold)
          // }
          // .width('100%')
        }
        .height('100%')
        .backgroundColor(Color.Green)
      }
      .height('100%')
      .width('100%')
    }
    .height('100%')
    .width('100%')
  }
}