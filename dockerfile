FROM openbullet/openbullet2:latest

EXPOSE 7860

ENV ASPNETCORE_URLS=http://0.0.0.0:7860
ENV DOTNET_RUNNING_IN_CONTAINER=true
ENV PORT=7860

RUN apt-get update && apt-get install -y postgresql-client && rm -rf /var/lib/apt/lists/*

WORKDIR /app

ENTRYPOINT ["bash", "-c", "\
  mkdir -p /tmp/Configs /tmp/Wordlists /tmp/Logs /tmp/Plugins && \
  rm -rf /app/Configs /app/Wordlists /app/Logs /app/Plugins && \
  ln -sf /tmp/Configs /app/Configs && \
  ln -sf /tmp/Wordlists /app/Wordlists && \
  ln -sf /tmp/Logs /app/Logs && \
  ln -sf /tmp/Plugins /app/Plugins && \
  if [ -n \"$DATABASE_URL\" ]; then \
    DB_USER=$(echo $DATABASE_URL | sed -n 's/postgresql:\/\/\([^:]*\):.*@.*/\\1/p'); \
    DB_PASS=$(echo $DATABASE_URL | sed -n 's/postgresql:\/\/[^:]*:\([^@]*\)@.*/\\1/p'); \
    DB_HOST=$(echo $DATABASE_URL | sed -n 's/postgresql:\/\/[^@]*@\([^:]*\):.*/\\1/p'); \
    DB_PORT=$(echo $DATABASE_URL | sed -n 's/postgresql:\/\/[^@]*@[^:]*:\([0-9]*\)\/.*/\\1/p'); \
    DB_NAME=$(echo $DATABASE_URL | sed -n 's/postgresql:\/\/[^@]*@[^:]*:[0-9]*\/\(.*\)/\\1/p'); \
    CONN_STRING=\"Host=$DB_HOST;Port=$DB_PORT;Database=$DB_NAME;Username=$DB_USER;Password=$DB_PASS;SslMode=Require;\"; \
    printf '%s\n' '{\"Database\":{\"Type\":\"PostgreSQL\",\"ConnectionString\":\"'\"$CONN_STRING\"'\",\"Provider\":\"Npgsql\",\"AutoMigrate\":true}}' > /app/appsettings.json; \
    echo '✅ تم إنشاء appsettings.json من DATABASE_URL'; \
  else \
    echo '⚠️ متغير DATABASE_URL غير موجود، جاري استخدام SQLite مؤقتاً'; \
  fi && \
  echo '========== appsettings.json ==========' && \
  cat /app/appsettings.json || echo 'ملف غير موجود' && \
  echo '=======================================' && \
  echo '🚀 تشغيل OpenBullet 2 Web...' && \
  exec dotnet OpenBullet2.Web.dll"]
