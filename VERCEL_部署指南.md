# Vercel 部署指南 - 简化版

## 方案一：通过 GitHub 部署（推荐，最简单）

### 1. 准备 GitHub 仓库
1. 访问 [https://github.com](https://github.com) 并登录
2. 点击右上角的 "+" 号，选择 "New repository"
3. 仓库名称：`markdown-to-word-converter`
4. 设置为 Public
5. 点击 "Create repository"

### 2. 上传代码到 GitHub
在项目目录中执行：
```bash
git init
git add .
git commit -m "Initial commit: Markdown to Word converter"
git branch -M main
git remote add origin https://github.com/你的用户名/markdown-to-word-converter.git
git push -u origin main
```

### 3. 在 Vercel 中导入项目
1. 访问 [https://vercel.com](https://vercel.com)
2. 使用 GitHub 账户登录
3. 点击 "New Project"
4. 选择刚才创建的 `markdown-to-word-converter` 仓库
5. 点击 "Import"
6. 保持默认设置，点击 "Deploy"

### 4. 等待部署完成
- Vercel 会自动检测这是一个 Vite 项目
- 自动运行 `npm run build`
- 部署完成后会给你一个公开的 URL

## 方案二：直接上传 dist 文件夹

如果 GitHub 方式有问题，可以直接上传构建好的文件：

### 1. 访问 Netlify Drop
1. 打开 [https://app.netlify.com/drop](https://app.netlify.com/drop)
2. 将项目中的 `dist` 文件夹直接拖拽到页面上
3. 等待上传完成，会自动给你一个公开 URL

### 2. 或者使用 Surge.sh
```bash
npm install -g surge
cd dist
surge
```
按提示操作即可获得公开 URL。

## 推荐步骤

**最简单的方式是方案一（GitHub + Vercel）：**

1. 你需要做的：
   - 在 GitHub 上创建仓库
   - 复制仓库的 git 地址
   - 告诉我仓库地址，我帮你推送代码

2. 然后：
   - 在 Vercel 中导入 GitHub 仓库
   - 一键部署

你想选择哪种方式？我推荐方案一，因为以后更新代码也很方便。