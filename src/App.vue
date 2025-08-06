<template>
  <div class="app">
    <div class="container">
      <h1>📝 Markdown转Word转换器</h1>
      <p>支持上传Markdown文件或直接输入文本，一键转换为Word文档</p>
      
      <div class="form-section">
        <!-- 文件上传区域 -->
        <div class="upload-section">
          <h3>📁 上传Markdown文件</h3>
          <div class="upload-area">
            <input 
              type="file" 
              ref="fileInput"
              @change="handleFileUpload"
              accept=".md,.txt"
              style="display: none"
            />
            <button @click="$refs.fileInput.click()" class="upload-btn">
              选择文件 (.md, .txt)
            </button>
            <span v-if="uploadedFileName" class="file-name">
              已选择: {{ uploadedFileName }}
            </span>
          </div>
        </div>

        <!-- 分隔线 -->
        <div class="divider">
          <span>或</span>
        </div>
        
        <!-- 文本输入区域 -->
        <div class="input-group">
          <h3>📝 直接输入Markdown文本</h3>
          <textarea 
            v-model="markdownText" 
            placeholder="请输入Markdown文本..."
            rows="12"
          ></textarea>
        </div>
        
        <!-- 文件名设置 -->
        <div class="input-group">
          <label>📄 输出文件名：</label>
          <input 
            v-model="fileName" 
            type="text" 
            placeholder="请输入文件名（不含扩展名）"
          />
        </div>
        
        <!-- 操作按钮 -->
        <div class="button-group">
          <button 
            @click="convertToWord" 
            :disabled="!markdownText.trim() || converting"
            class="convert-btn"
          >
            {{ converting ? '转换中...' : '🔄 转换为Word文档' }}
          </button>
          
          <button @click="clearContent" class="clear-btn">
            🗑️ 清空内容
          </button>
        </div>

        <!-- 使用说明 -->
        <div class="help-section">
          <h4>💡 支持的Markdown语法：</h4>
          <ul>
            <li><code># 标题</code> - 一级标题</li>
            <li><code>## 标题</code> - 二级标题</li>
            <li><code>- 项目</code> - 列表项</li>
            <li><code>**粗体**</code> - 粗体文本</li>
            <li><code>*斜体*</code> - 斜体文本</li>
          </ul>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { ref } from 'vue'
import { Document, Packer, Paragraph, TextRun, HeadingLevel } from 'docx'
import { saveAs } from 'file-saver'

export default {
  name: 'App',
  setup() {
    const markdownText = ref('# 示例标题\n\n这是一个示例段落。\n\n- 列表项1\n- 列表项2\n\n**粗体文本**\n*斜体文本*')
    const fileName = ref('converted-document')
    const converting = ref(false)
    const uploadedFileName = ref('')

    // 处理文件上传
    const handleFileUpload = (event) => {
      const file = event.target.files[0]
      if (file) {
        uploadedFileName.value = file.name
        fileName.value = file.name.replace(/\.[^/.]+$/, "")
        
        const reader = new FileReader()
        reader.onload = (e) => {
          markdownText.value = e.target.result
        }
        reader.readAsText(file)
      }
    }

    // Markdown转Word
    const convertToWord = async () => {
      if (!markdownText.value.trim()) {
        alert('请输入Markdown内容')
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
        
        alert('转换成功！文件已开始下载')
        
      } catch (error) {
        console.error('转换失败:', error)
        alert('转换失败：' + error.message)
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
          } else {
            // 处理粗体和斜体
            const children = []
            let currentText = line
            
            // 简单的粗体处理
            if (currentText.includes('**')) {
              const parts = currentText.split('**')
              parts.forEach((part, index) => {
                if (index % 2 === 0) {
                  if (part) children.push(new TextRun(part))
                } else {
                  children.push(new TextRun({ text: part, bold: true }))
                }
              })
            } else if (currentText.includes('*')) {
              const parts = currentText.split('*')
              parts.forEach((part, index) => {
                if (index % 2 === 0) {
                  if (part) children.push(new TextRun(part))
                } else {
                  children.push(new TextRun({ text: part, italics: true }))
                }
              })
            } else {
              children.push(new TextRun(currentText))
            }
            
            paragraphs.push(new Paragraph({ children }))
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
      uploadedFileName.value = ''
      // 清空文件输入
      const fileInput = document.querySelector('input[type="file"]')
      if (fileInput) fileInput.value = ''
    }

    return {
      markdownText,
      fileName,
      converting,
      uploadedFileName,
      handleFileUpload,
      convertToWord,
      clearContent
    }
  }
}
</script>

<style scoped>
.app {
  min-height: 100vh;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 20px;
}

.container {
  max-width: 900px;
  margin: 0 auto;
  background: white;
  border-radius: 12px;
  padding: 30px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
}

h1 {
  color: #1989fa;
  text-align: center;
  margin-bottom: 10px;
}

p {
  text-align: center;
  color: #666;
  margin-bottom: 30px;
}

.form-section {
  display: flex;
  flex-direction: column;
  gap: 25px;
}

.upload-section {
  border: 2px dashed #e1e5e9;
  border-radius: 12px;
  padding: 20px;
  text-align: center;
  background: #f8f9fa;
}

.upload-section h3 {
  margin-bottom: 15px;
  color: #333;
}

.upload-area {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 10px;
}

.upload-btn {
  padding: 12px 24px;
  background: #28a745;
  color: white;
  border: none;
  border-radius: 8px;
  font-size: 16px;
  cursor: pointer;
  transition: background 0.3s;
}

.upload-btn:hover {
  background: #218838;
}

.file-name {
  color: #28a745;
  font-weight: bold;
  font-size: 14px;
}

.divider {
  text-align: center;
  position: relative;
  margin: 20px 0;
}

.divider::before {
  content: '';
  position: absolute;
  top: 50%;
  left: 0;
  right: 0;
  height: 1px;
  background: #e1e5e9;
}

.divider span {
  background: white;
  padding: 0 20px;
  color: #666;
  font-weight: bold;
}

.input-group {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.input-group h3 {
  margin-bottom: 10px;
  color: #333;
}

label {
  font-weight: bold;
  color: #333;
}

textarea, input {
  padding: 12px;
  border: 2px solid #e1e5e9;
  border-radius: 8px;
  font-size: 14px;
  font-family: 'Courier New', monospace;
}

textarea:focus, input:focus {
  outline: none;
  border-color: #1989fa;
}

.button-group {
  display: flex;
  gap: 12px;
  margin-top: 20px;
}

.convert-btn {
  flex: 1;
  padding: 15px;
  background: #1989fa;
  color: white;
  border: none;
  border-radius: 8px;
  font-size: 16px;
  font-weight: bold;
  cursor: pointer;
  transition: background 0.3s;
}

.convert-btn:hover:not(:disabled) {
  background: #1976d2;
}

.convert-btn:disabled {
  background: #ccc;
  cursor: not-allowed;
}

.clear-btn {
  padding: 15px 30px;
  background: #f5f5f5;
  color: #666;
  border: 2px solid #e1e5e9;
  border-radius: 8px;
  font-size: 16px;
  cursor: pointer;
  transition: all 0.3s;
}

.clear-btn:hover {
  background: #e9ecef;
  border-color: #ccc;
}

.help-section {
  background: #f8f9fa;
  padding: 20px;
  border-radius: 8px;
  border-left: 4px solid #1989fa;
}

.help-section h4 {
  margin-bottom: 10px;
  color: #333;
}

.help-section ul {
  margin: 0;
  padding-left: 20px;
}

.help-section li {
  margin-bottom: 5px;
  color: #666;
}

.help-section code {
  background: #e9ecef;
  padding: 2px 6px;
  border-radius: 4px;
  font-family: 'Courier New', monospace;
  color: #d63384;
}
</style>