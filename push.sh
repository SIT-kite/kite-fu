# 编译项目
flutter build web --web-renderer=html --base-href=/fu/ --no-source-maps --no-null-assertions --no-native-null-assertions --release

# 推送到服务器
scp -r -P [端口] ./build/web [用户]@[主机]:[路径]
