# Siri-VK-Demo

### Instruction

Say to Siri: "Отправь сообщение <Имя (Фамилия) пользователя>" через Орион <Ваше сообщение>"

### Requirements

1) Xcode 8

2) Device with iOS 10

### Launch actions

1) Enable "Automatically manage signing" and select team in all targets

2) Enable App Groups and Keychain Access Groups entitlements for main app and intent extension

3) N7DataStore.m -> set correct values for N7VKSiriKeychainAccessGroup and N7VKSiriApplicationGroup constants
