FROM openbullet/openbullet2:latest

EXPOSE 7860

ENV ASPNETCORE_URLS=http://0.0.0.0:7860
ENV DOTNET_RUNNING_IN_CONTAINER=true
ENV PORT=7860

# تثبيت مكتبات PostgreSQL لتجنب خطأ 139 (Segmentation Fault)
RUN apt-get update && apt-get install -y postgresql-client libpq-dev && rm -rf /var/lib/apt/lists/*

WORKDIR /app

ENTRYPOINT ["bash", "-c", "\
  mkdir -p /tmp/Configs /tmp/Wordlists /tmp/Logs /tmp/Plugins && \
  rm -rf /app/Configs /app/Wordlists /app/Logs /app/Plugins && \
  ln -sf /tmp/Configs /app/Configs && \
  ln -sf /tmp/Wordlists /app/Wordlists && \
  ln -sf /tmp/Logs /app/Logs && \
  ln -sf /tmp/Plugins /app/Plugins && \
  echo '🔄 جاري إعداد ملف OpenBulletSettings.json مع PostgreSQL...' && \
  if [ -n \"$DATABASE_URL\" ]; then \
    printf '%s\n' '{\"GeneralSettings\":{\"ConfigSectionOnLoad\":2,\"AutoSetRecommendedBots\":true,\"WarnConfigNotSaved\":true,\"DefaultAuthor\":\"Anonymous\",\"EnableJobLogging\":false,\"LogBufferSize\":30,\"IgnoreWordlistNameOnHitsDedupe\":false,\"ProxyCheckTargets\":[{\"Url\":\"https://google.com\",\"SuccessKey\":\"title>Google\"}],\"DefaultJobDisplayMode\":0,\"JobUpdateInterval\":1000,\"JobManagerUpdateInterval\":1000,\"GroupCapturesInDebugger\":false,\"Culture\":\"en\",\"CustomSnippets\":[]},\"RemoteSettings\":{\"ConfigsEndpoints\":[]},\"SecuritySettings\":{\"AllowSystemWideFileAccess\":false,\"RequireAdminLogin\":false,\"AdminUsername\":\"admin\",\"AdminPasswordHash\":\"$2b$10$2ssZSqlVfv12U7iR8b6T1O3XzNcSAMtGmYrRteRU.w4xn7m52WmHW\",\"AdminApiKey\":\"\",\"JwtKey\":\"EM/rjJN2A7+xHsvNJQZy2oBX86ZlesZN0w4V5ent+3XvsLWEHDKqhDMbAvb3GiFWXaOseQjAZQ4loCxXB4boxQ==\",\"AdminSessionLifetimeHours\":24,\"GuestSessionLifetimeHours\":24,\"HttpsRedirect\":false},\"CustomizationSettings\":{\"Theme\":\"Default\",\"MonacoTheme\":\"vs-dark\",\"WordWrap\":false,\"BackgroundMain\":\"#222\",\"BackgroundInput\":\"#282828\",\"BackgroundSecondary\":\"#111\",\"ForegroundMain\":\"#DCDCDC\",\"ForegroundInput\":\"#DCDCDC\",\"ForegroundGood\":\"#ADFF2F\",\"ForegroundBad\":\"#FF6347\",\"ForegroundCustom\":\"#FF8C00\",\"ForegroundRetry\":\"#FFFF00\",\"ForegroundBanned\":\"#DDA0DD\",\"ForegroundToCheck\":\"#7FFFD4\",\"ForegroundMenuSelected\":\"#1E90FF\",\"SuccessButton\":\"#2f5738\",\"PrimaryButton\":\"#3b3a63\",\"WarningButton\":\"#7a552a\",\"DangerButton\":\"#693838\",\"ForegroundButton\":\"#DCDCDC\",\"BackgroundButton\":\"#282828\",\"BackgroundImagePath\":\"\",\"BackgroundOpacity\":100.0,\"PlaySoundOnHit\":false},\"Database\":{\"Type\":\"PostgreSQL\",\"ConnectionString\":\"'\"$DATABASE_URL\"'\",\"Provider\":\"Npgsql\",\"AutoMigrate\":true}}' > /app/OpenBulletSettings.json && \
    echo '✅ تم إنشاء OpenBulletSettings.json بنجاح'; \
  else \
    echo '⚠️ متغير DATABASE_URL غير موجود، جاري استخدام SQLite مؤقتاً'; \
  fi && \
  echo '========== محتوى OpenBulletSettings.json ==========' && \
  cat /app/OpenBulletSettings.json && \
  echo '' && \
  echo '===================================================' && \
  echo '🚀 تشغيل OpenBullet 2 Web...' && \
  exec dotnet OpenBullet2.Web.dll"]
