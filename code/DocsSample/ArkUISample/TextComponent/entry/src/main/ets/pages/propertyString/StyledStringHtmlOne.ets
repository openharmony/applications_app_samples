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
// [Start styledStringHtmlOne_start]
// xxx.ets
@Entry
@Component
struct HtmlSpanStringDemo {
  @State html: string =
    "<p>This is <b>b</b> <strong>strong</strong> <em>em</em> <i>i</i> <u>u</u> <del>del</del> <s>s</s> <span style =   \"foreground-color:blue\"> <a href='https://www.example.com'>www.example</a> </span> <span   style=\"background-color: red;\">red span</span> <sup>superscript</sup> and <sub>subscript</sub></p>";
  @State spanString: StyledString | undefined = undefined;
  @State resultText: string = ''; // 保存结果文本的状态
  controller: TextController = new TextController;

  build() {
    Column() {
      // 显示转换后的spanString
      Text(undefined, { controller: this.controller }).height(100).id('text1')

      // TextArea显示每个步骤的结果
      TextArea({ text: this.html })
        .width('100%')
        .height(100)
        .margin(5)

      // 按钮1:将HTML转换为SpanString
      // 请将$r('app.string.Converted_HTML_to_SpanString')替换为实际资源文件，在本示例中该资源文件的value值为"Converted HTML to SpanString"
      Button($r('app.string.Converted_HTML_to_SpanString')).onClick(async () => {
        this.spanString = await StyledString.fromHtml(this.html);
        this.controller.setStyledString(this.spanString);
        this.resultText = 'Converted HTML to SpanString successfully.';
      }).margin(5)

      // 按钮2:将SpanString转换为HTML
      // 请将$r('app.string.Converted_SpanString_to_HTML')替换为实际资源文件，在本示例中该资源文件的value值为"Converted SpanString to HTML"
      Button($r('app.string.Converted_SpanString_to_HTML')).onClick(() => {
        if (this.spanString) {
          // 将spanString转换为HTML并替换当前的HTML状态
          const newHtml = StyledString.toHtml(this.spanString);
          if (newHtml !== this.html) { // 通过检查内容是否已经相同来防止重复
            this.html = newHtml;
          }
          this.resultText = 'Converted SpanString to HTML successfully.';
        } else {
          this.resultText = 'SpanString is undefined.';
        }
      }).margin(5)

      // 按钮3:将HTML转换回SpanString
      // 请将$r('app.string.Converted_HTML_back_to_SpanString')替换为实际资源文件，
      // 在本示例中该资源文件的value值为"Converted HTML back to SpanString"
      Button($r('app.string.Converted_HTML_back_to_SpanString')).onClick(async () => {
        this.spanString = await StyledString.fromHtml(this.html);
        this.controller.setStyledString(this.spanString);
        this.resultText = 'Converted HTML back to SpanString successfully.';
      }).margin(5)

      // 重置：重置HTML和SpanString
      // 请将$r('app.string.Reset')替换为实际资源文件，在本示例中该资源文件的value值为"Reset"
      Button($r('app.string.Reset')).onClick(() => {
        this.html =
          "<p>This is <b>b</b> <strong>strong</strong> <em>em</em> <i>i</i> <u>u</u> <del>del</del> <s>s</s> <span   style = \"foreground-color:blue\"> <a href='https://www.example.com'>www.example</a> </span> <span   style=\"background-color: red;\">red span</span> <sup>superscript</sup> and <sub>subscript</sub></p>";
        this.spanString = undefined;
        this.controller.setStyledString(new StyledString('')); // 使用空的StyledString实例
        this.resultText = 'Reset HTML and SpanString successfully.';
      }).margin(5)
    }.width('100%').padding(20)
  }
}
// [End styledStringHtmlOne_start]