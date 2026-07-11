FROM openbullet/openbullet2:latest

EXPOSE 7860

ENV ASPNETCORE_URLS=http://0.0.0.0:7860
ENV DOTNET_RUNNING_IN_CONTAINER=true
ENV PORT=7860

WORKDIR /app

ENTRYPOINT ["bash", "-c", "\
  mkdir -p /tmp/Configs /tmp/Wordlists /tmp/Logs /tmp/Plugins && \
  rm -rf /app/Configs /app/Wordlists /app/Logs /app/Plugins && \
  ln -sf /tmp/Configs /app/Configs && \
  ln -sf /tmp/Wordlists /app/Wordlists && \
  ln -sf /tmp/Logs /app/Logs && \
  ln -sf /tmp/Plugins /app/Plugins && \
  echo '✅ تم إعداد المجلدات المؤقتة (سيتم فقدان الملفات المرفوعة عند إعادة النشر، لذا استخدم قاعدة البيانات لتخزين الهيتس والإعدادات)' && \
  echo '🚀 تشغيل OpenBullet 2 Web مع PostgreSQL...' && \
  exec dotnet OpenBullet2.Web.dll"]
