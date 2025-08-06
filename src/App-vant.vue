<template>
  <div class="app">
    <van-nav-bar title="Markdown转Word转换器" fixed />
    
    <div class="container">
      <div class="main-card">
        <div class="card-header">
          <h2>📝 Markdown转Word文档转换器</h2>
          <p>支持上传Markdown文件或直接输入文本，一键转换为Word文档</p>
        </div>

        <!-- 转换器主界面 -->
        <div class="converter-section">
          <!-- 文件上传区域 -->
          <van-cell-group inset title="上传Markdown文件">
            <van-uploader
              v-model="fileList"
              :after-read="handleFileRead"
              accept=".md,.txt"
              :max-count="1"
            >
              <van-button icon="plus" type="primary">选择文件</van-button>
            </van-uploader>
          </van-cell-group>

          <!-- 文本输入区域 -->
          <van-cell-group inset title="或直接输入Markdown文本">
            <van-field
              v-model="markdownText"
              type="textarea"
              placeholder="请输入Markdown文本..."
              rows="10"
              autosize
            />
          </van-cell-group>

          <!-- 转换设置 -->
          <van-cell-group inset title="转换设置">
            <van-field
              v-model="fileName"
              label="文件名"
              placeholder="请输入文件名（不含扩展名）"
            />
          </van-cell-group>

          <!-- 操作按钮 -->
          <van-space direction="vertical" fill>
            <van-button 
              type="primary" 
              block 
              @click="convertToWord"
              :loading="converting"
              :disabled="!markdownText.trim()"
            >
              {{ converting ? '转换中...' : '转换为Word文档' }}
            </van-button>
            
            <van-button 
              type="default" 
              block 
              @click="clearContent"
            >
              清空内容
            </van-button>
          </van-space>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { ref } from 'vue'
import { showToast } from 'vant'
import { Document, Packer, Paragraph, TextRun, HeadingLevel } from 'docx'
import { saveAs } from 'file-saver'
import { marked } from 'marked'

export default {
  name: 'App',
  setup() {
    const markdownText = ref('')
    const fileName = ref('converted-document')
    const fileList = ref([])
    const converting = ref(false)

    // 文件处理
    const handleFileRead = (file) => {
      const reader = new FileReader()
      reader.onload = (e) => {
        markdownText.value = e.target.result
        fileName.value = file.file.name.replace(/\.[^/.]+$/, "")
      }
      reader.readAsText(file.file)
    }

    // Markdown转Word
    const convertToWord = async () => {
      if (!markdownText.value.trim()) {
        showToast('请输入Markdown内容')
        return
      }

      converting.value = true
      
      try {
        // 创建Word文档
        const doc = new Document({
          sections: [{
            properties: {},
            children: parseMarkdownToDocx(markdownText.value)
          }]
        })

        // 生成Word文件
        const blob = await Packer.toBlob(doc)
        
        // 下载文件
        const fileNameWithExt = `${fileName.value || 'document'}.docx`
        saveAs(blob, fileNameWithExt)
        
        showToast('转换成功！文件已开始下载')
        
      } catch (error) {
        console.error('转换失败:', error)
        showToast('转换失败：' + error.message)
      } finally {
        converting.value = false
      }
    }

    // Markdown到DOCX转换
    const parseMarkdownToDocx = (markdown) => {
      const paragraphs = []
      const lines = markdown.split('\n')
      
      lines.forEach(line => {
        if (line.trim()) {
          if (line.startsWith('#')) {
            // 处理标题
            const level = line.match(/^#+/)[0].length
            const text = line.replace(/^#+\s*/, '')
            paragraphs.push(
              new Paragraph({
                text: text,
                heading: level === 1 ? HeadingLevel.HEADING_1 : 
                        level === 2 ? HeadingLevel.HEADING_2 : 
                        level === 3 ? HeadingLevel.HEADING_3 :
                        level === 4 ? HeadingLevel.HEADING_4 :
                        level === 5 ? HeadingLevel.HEADING_5 :
                        HeadingLevel.HEADING_6
              })
            )
          } else if (line.startsWith('- ') || line.startsWith('* ')) {
            // 处理列表项
            const text = line.replace(/^[-*]\s*/, '• ')
            paragraphs.push(
              new Paragraph({
                children: [new TextRun(text)]
              })
            )
          } else if (line.startsWith('**') && line.endsWith('**')) {
            // 处理粗体
            const text = line.replace(/^\*\*(.*)\*\*$/, '$1')
            paragraphs.push(
              new Paragraph({
                children: [new TextRun({ text: text, bold: true })]
              })
            )
          } else if (line.startsWith('*') && line.endsWith('*')) {
            // 处理斜体
            const text = line.replace(/^\*(.*)\*$/, '$1')
            paragraphs.push(
              new Paragraph({
                children: [new TextRun({ text: text, italics: true })]
              })
            )
          } else {
            // 普通段落
            paragraphs.push(
              new Paragraph({
                children: [new TextRun(line)]
              })
            )
          }
        } else {
          // 空行
          paragraphs.push(new Paragraph({ children: [new TextRun("")] }))
        }
      })
      
      return paragraphs
    }

    // 清空内容
    const clearContent = () => {
      markdownText.value = ''
      fileName.value = 'converted-document'
      fileList.value = []
    }

    return {
      markdownText,
      fileName,
      fileList,
      converting,
      handleFileRead,
      convertToWord,
      clearContent
    }
  }
}
</script>

<style scoped>
.app {
  min-height: 100vh;
  padding-top: 46px;
}

.container {
  padding: 16px;
  max-width: 800px;
  margin: 0 auto;
}

.main-card {
  background: white;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  padding: 20px;
}

.card-header {
  text-align: center;
  margin-bottom: 24px;
}

.card-header h2 {
  color: #1989fa;
  margin-bottom: 8px;
}

.card-header p {
  color: #646566;
  font-size: 14px;
}

.converter-section {
  padding: 20px 0;
}

.van-cell-group {
  margin-bottom: 16px;
}

.van-space {
  margin-top: 16px;
}
</style>