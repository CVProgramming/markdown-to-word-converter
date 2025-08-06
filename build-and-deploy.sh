#!/bin/bash

echo "🚀 开始构建和部署 Markdown转Word转换器..."

# 构建项目
echo "📦 正在构建项目..."
npm run build

if [ $? -eq 0 ]; then
    echo "✅ 构建成功！"
else
    echo "❌ 构建失败！"
    exit 1
fi

# 检查是否安装了Vercel CLI
if command -v vercel &> /dev/null; then
    echo "🌐 使用Vercel部署..."
    vercel --prod
else
    echo "⚠️  Vercel CLI未安装，请手动部署："
    echo "1. 安装Vercel CLI: npm i -g vercel"
    echo "2. 运行: vercel"
    echo "3. 或者将dist文件夹上传到Netlify"
fi

echo "🎉 部署完成！"
echo "📝 请确保在部署平台设置以下环境变量："
echo "   VITE_SUPABASE_URL=https://iazxjudhdfapkojryqxg.supabase.co"
echo "   VITE_SUPABASE_ANON_KEY=your-anon-key"