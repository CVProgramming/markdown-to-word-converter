# Markdown转Word文档转换器

一个基于Web的Markdown转Word文档转换器，使用Vue 3 + Supabase构建，支持用户认证、文件存储和转换历史记录。

## 🚀 功能特性

- **用户认证系统**：支持用户注册、登录和退出
- **Markdown转换**：支持文件上传或直接输入Markdown文本
- **Word文档生成**：一键转换为标准的.docx格式文档
- **云端存储**：使用Supabase存储转换后的文档
- **转换历史**：查看和重新下载历史转换记录
- **响应式设计**：适配移动端和桌面端

## 🛠️ 技术栈

- **前端**：Vue 3 + Vite + Vant UI
- **后端服务**：Supabase (认证、数据库、存储)
- **文档处理**：docx.js + marked.js
- **部署平台**：Vercel / Netlify

## 📦 安装和运行

### 本地开发

1. 克隆项目
```bash
git clone <repository-url>
cd markdown-to-word-converter
```

2. 安装依赖
```bash
npm install
```

3. 配置环境变量
创建 `.env` 文件并添加Supabase配置：
```env
VITE_SUPABASE_URL=your_supabase_url
VITE_SUPABASE_ANON_KEY=your_supabase_anon_key
```

4. 启动开发服务器
```bash
npm run dev
```

5. 访问 http://localhost:3000

### 生产构建

```bash
npm run build
```

## 🚀 部署指南

### Vercel部署

1. 将代码推送到GitHub仓库
2. 在Vercel中导入项目
3. 配置环境变量：
   - `VITE_SUPABASE_URL`
   - `VITE_SUPABASE_ANON_KEY`
4. 部署完成后获得公开URL

### Netlify部署

1. 将代码推送到GitHub仓库
2. 在Netlify中连接仓库
3. 设置构建命令：`npm run build`
4. 设置发布目录：`dist`
5. 配置环境变量
6. 部署完成

## 🗄️ 数据库结构

### conversion_history表
```sql
CREATE TABLE conversion_history (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES auth.users(id),
    file_name TEXT NOT NULL,
    markdown_content TEXT,
    storage_path TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### 存储桶
- `documents`：存储转换后的Word文档

## 🔧 Supabase配置

### 1. 创建Supabase项目
1. 访问 [Supabase](https://supabase.com)
2. 创建新项目
3. 获取项目URL和API密钥

### 2. 设置数据库
运行以下SQL创建必要的表和策略：

```sql
-- 创建转换历史记录表
CREATE TABLE conversion_history (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    file_name TEXT NOT NULL,
    markdown_content TEXT,
    storage_path TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 启用行级安全
ALTER TABLE conversion_history ENABLE ROW LEVEL SECURITY;

-- 创建安全策略
CREATE POLICY "Users can manage their own records" ON conversion_history
USING (auth.uid() = user_id);
```

### 3. 配置存储
1. 在Supabase控制台创建存储桶 `documents`
2. 设置适当的访问策略

## 📱 使用说明

### 用户注册/登录
1. 首次访问需要注册账户
2. 输入邮箱和密码进行注册
3. 检查邮箱验证链接（如果启用）
4. 使用注册的账户登录

### 转换文档
1. **上传文件**：点击"选择文件"上传.md或.txt文件
2. **直接输入**：在文本框中直接输入Markdown内容
3. **设置文件名**：自定义输出的Word文档名称
4. **开始转换**：点击"转换为Word文档"按钮
5. **下载文档**：转换完成后自动下载Word文档

### 查看历史
- 在"转换历史"区域查看之前的转换记录
- 点击历史记录可重新下载对应的Word文档

## 🎯 支持的Markdown语法

- 标题 (H1-H6)
- 段落文本
- 粗体和斜体
- 列表（有序和无序）
- 链接
- 代码块
- 引用

## 🔒 安全特性

- 用户认证和授权
- 行级安全策略
- 文件访问权限控制
- 数据加密传输

## 🐛 故障排除

### 常见问题

1. **转换失败**
   - 检查Markdown语法是否正确
   - 确保网络连接正常
   - 查看浏览器控制台错误信息

2. **登录问题**
   - 确认邮箱和密码正确
   - 检查邮箱验证状态
   - 清除浏览器缓存

3. **文件下载问题**
   - 检查浏览器下载设置
   - 确认存储权限
   - 尝试重新转换

## 📄 许可证

MIT License

## 🤝 贡献

欢迎提交Issue和Pull Request来改进这个项目。

## 📞 支持

如有问题，请通过以下方式联系：
- 创建GitHub Issue
- 发送邮件至项目维护者

---

**在线演示**：[部署后的URL将在此处显示]

**项目状态**：✅ 生产就绪