# 🗺️ Configuração do Google Maps

## Como obter a API Key do Google Maps

### Passo 1: Criar um projeto no Google Cloud Console

1. Acesse o [Google Cloud Console](https://console.cloud.google.com/)
2. Crie um novo projeto ou selecione um existente
3. No menu lateral, vá em **APIs & Services** > **Library**
4. Procure e habilite as seguintes APIs:
   - **Maps SDK for Android**
   - **Maps SDK for iOS**

### Passo 2: Criar a API Key

1. No menu lateral, vá em **APIs & Services** > **Credentials**
2. Clique em **Create Credentials** > **API Key**
3. Copie a API Key gerada

### Passo 3: (Recomendado) Restringir a API Key

1. Clique na API Key criada
2. Em **Application restrictions**, selecione:
   - **Android apps** para Android
   - **iOS apps** para iOS
3. Adicione as restrições de pacote/bundle:
   - Android: `com.example.patientcareapp` (ou o package name do seu app)
   - iOS: Bundle ID do seu app
4. Em **API restrictions**, selecione **Restrict key** e escolha:
   - Maps SDK for Android
   - Maps SDK for iOS
5. Clique em **Save**

## Configurar a API Key no Projeto

### Android

Abra o arquivo: `android/app/src/main/AndroidManifest.xml`

Substitua `YOUR_API_KEY_HERE` pela sua API Key:

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="SUA_API_KEY_AQUI"/>
```

### iOS

Abra o arquivo: `ios/Runner/AppDelegate.swift`

Substitua `YOUR_API_KEY_HERE` pela sua API Key:

```swift
GMSServices.provideAPIKey("SUA_API_KEY_AQUI")
```

## ⚠️ Segurança

**IMPORTANTE:** Nunca commite sua API Key diretamente no código!

### Melhor Prática: Usar variáveis de ambiente

1. Crie um arquivo `.env` na raiz do projeto (e adicione ao `.gitignore`)
2. Adicione sua API Key no arquivo:
   ```
   GOOGLE_MAPS_API_KEY=sua_api_key_aqui
   ```
3. Use um pacote como `flutter_dotenv` para carregar as variáveis

## 🧪 Testando

Após configurar a API Key, execute:

```bash
flutter clean
flutter pub get
flutter run
```

## 💰 Custos

O Google Maps oferece $200 em créditos mensais gratuitos. Para uso básico durante desenvolvimento, isso geralmente é suficiente.

Para mais informações sobre preços: [Google Maps Platform Pricing](https://mapsplatform.google.com/pricing/)

