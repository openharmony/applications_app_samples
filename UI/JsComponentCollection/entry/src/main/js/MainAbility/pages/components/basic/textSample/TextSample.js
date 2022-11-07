/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

export default {
  data: {
    textTitle: '',
    fontColor: '',
    textDecoration: 'none',
    textAlign: 'start',
    lineHeight: '24',
    textOverflow: '',
    textChangeFontColor: '',
    maxLines: '-1',
    textContentEn: '',
    letterSpacing: '2',
    textChangeLetterSpacing: '',
    textChangeLineHeight: '',
    textChangeAlignmentType: '',
    textChangeDisplayMode: '',
    textChangeDecorativeThread: '',
    textChangeTextCase: '',
    oldTextContentEn: '',
    minSliderLetterSpacing: '0',
    maxSliderLetterSpacing: '12',
    minSliderLineHeight: '22',
    maxSliderLineHeight: '30',
    textAlignmentTypeOptions: [],
    textFontColorOptions: [],
    textDisplayModeOptions: [],
    textDecorativeThreadOptions: [],
    textCaseOptions: [],
    textInputColorOptions: []
  },
  onInit() {
    this.textTitle = this.$t('strings.text_title')
    this.textChangeLetterSpacing = this.$t('strings.text_change_letter_spacing')
    this.textChangeLineHeight = this.$t('strings.text_change_line_height')
    this.textChangeAlignmentType = this.$t('strings.text_change_alignment_type')
    this.textChangeDisplayMode = this.$t('strings.text_change_display_mode')
    this.textChangeDecorativeThread = this.$t('strings.text_change_decorative_thread')
    this.textChangeTextCase = this.$t('strings.text_change_text_case')
    this.textChangeFontColor = this.$t('strings.text_change_font_color')
    this.textAlignmentTypeOptions = this.$t('strings.text_alignment_type_options')
    this.textFontColorOptions = this.$t('strings.text_font_color_options')
    this.textContentEn = this.$t('strings.text_content_en')
    this.oldTextContentEn = this.textContentEn
    this.textDisplayModeOptions = this.$t('strings.text_display_mode_options')
    this.textDecorativeThreadOptions = this.$t('strings.text_decorative_thread_options')
    this.textCaseOptions = this.$t('strings.text_case_options')
    this.textInputColorOptions = this.$t('strings.divider_color_options')
  },

  setLetterSpacingValue(letterSpacingValueObj) {
    if (letterSpacingValueObj.detail.value) {
      this.letterSpacing = letterSpacingValueObj.detail.value
    }
  },

  setLineHeightValue(lineHeightValueObj) {
    if (lineHeightValueObj.detail.value) {
      this.lineHeight = lineHeightValueObj.detail.value
    }
  },

  setAlignTypeValue(alignTypeValueObj) {
    if (alignTypeValueObj.detail.value) {
      this.textAlign = alignTypeValueObj.detail.value
    }
  },

  setFontColorValue(fontColorValueObj) {
    if (fontColorValueObj.detail.value) {
      this.fontColor = fontColorValueObj.detail.value
    }
  },

  setDisplayModeValue(displayModeValueObj) {
    if (!displayModeValueObj.detail.value) {
      return
    }
    this.textOverflow = displayModeValueObj.detail.value
    if (this.textOverflow === 'ellipsis' || this.textOverflow === 'clip') {
      this.maxLines = '3'
    } else {
      this.maxLines = '-1'
    }
  },

  setDecorativeThreadValue(decorativeThreadValueObj) {
    if (decorativeThreadValueObj.detail.value) {
      this.textDecoration = decorativeThreadValueObj.detail.value
    }
  },

  setTextCaseValue(textCaseValueObj) {
    if (!textCaseValueObj.detail.value) {
      return
    }
    if (textCaseValueObj.detail.value === 'toUpperCase') {
      this.textContentEn = this.textContentEn.toUpperCase()
    } else if (textCaseValueObj.detail.value === 'toLowerCase') {
      this.textContentEn = this.textContentEn.toLowerCase()
    } else {
      this.textContentEn = this.oldTextContentEn
    }
  }
}
