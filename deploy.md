# 部署指南

## 快速部署到Vercel

### 方法一：通过Vercel CLI
1. 安装Vercel CLI
```bash
npm i -g vercel
```

2. 在项目根目录运行
```bash
vercel
```

3. 按照提示配置项目
4. 设置环境变量：
   - `VITE_SUPABASE_URL`
   - `VITE_SUPABASE_ANON_KEY`

### 方法二：通过GitHub集成
1. 将代码推送到GitHub
2. 访问 [Vercel](https://vercel.com)
3. 导入GitHub仓库
4. 配置环境变量
5. 部署完成

## 部署到Netlify

### 方法一：拖拽部署
1. 运行 `npm run build`
2. 将 `dist` 文件夹拖拽到 [Netlify Drop](https://app.netlify.com/drop)

### 方法二：Git集成
1. 将代码推送到GitHub
2. 在Netlify中连接仓库
3. 设置构建配置：
   - Build command: `npm run build`
   - Publish directory: `dist`
4. 配置环境变量
5. 部署

## 环境变量配置

确保在部署平台设置以下环境变量：

```
VITE_SUPABASE_URL=https://your-project.supabase.co
VITE_SUPABASE_ANON_KEY=your-anon-key
```

## 部署后验证

1. 访问部署的URL
2. 测试用户注册/登录功能
3. 测试Markdown转Word功能
4. 验证文件上传和下载
5. 检查转换历史记录

## 常见部署问题

### 构建失败
- 检查Node.js版本（推荐18+）
- 确认所有依赖已正确安装
- 检查环境变量配置

### 功能异常
- 验证Supabase配置
- 检查数据库表和策略
- 确认存储桶权限设置

### 性能优化
- 启用CDN加速
- 配置缓存策略
- 优化图片和资源加载