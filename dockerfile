FROM openbullet/openbullet2:latest

EXPOSE 7860

ENV ASPNETCORE_URLS=http://0.0.0.0:7860
ENV DOTNET_RUNNING_IN_CONTAINER=true
ENV PORT=7860

WORKDIR /app

CMD /bin/bash -c '\
  mkdir -p /data/Configs /data/Wordlists /data/Logs /data/Plugins /data/UserData && \
  rm -rf /app/Configs /app/Wordlists /app/Logs /app/Plugins /app/UserData && \
  ln -sf /data/Configs /app/Configs && \
  ln -sf /data/Wordlists /app/Wordlists && \
  ln -sf /data/Logs /app/Logs && \
  ln -sf /data/Plugins /app/Plugins && \
  ln -sf /data/UserData /app/UserData && \
  touch /data/OpenBullet.db && \
  rm -f /app/OpenBullet.db && \
  ln -sf /data/OpenBullet.db /app/OpenBullet.db && \
  echo "✅ تم ربط جميع المجلدات وقاعدة البيانات في /data" && \
  echo "🚀 تشغيل OpenBullet 2 Web..." && \
  exec dotnet OpenBullet2.Web.dll'
