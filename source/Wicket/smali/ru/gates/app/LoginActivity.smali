.class public Lru/gates/app/LoginActivity;
.super Landroid/app/Activity;
.source "LoginActivity.java"


# static fields
.field private static final APP_HOST:Ljava/lang/String; = "spruthub.ru"

.field private static final START_URL:Ljava/lang/String; = "https://beta.spruthub.ru/"


# instance fields
.field private done:Z

.field private final handler:Landroid/os/Handler;

.field private loadFailed:Z

.field private polyfillJs:Ljava/lang/String;

.field private retries:I

.field private web:Landroid/webkit/WebView;


# direct methods
.method public static synthetic $r8$lambda$kfSx5rVQukfVWoHlOfzTL0EU3XM(Lru/gates/app/LoginActivity;)V
    .locals 0

    invoke-direct {p0}, Lru/gates/app/LoginActivity;->checkAuth()V

    return-void
.end method

.method public constructor <init>()V
    .locals 2

    .line 38
    invoke-direct {p0}, Landroid/app/Activity;-><init>()V

    .line 44
    new-instance v0, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    iput-object v0, p0, Lru/gates/app/LoginActivity;->handler:Landroid/os/Handler;

    .line 45
    const/4 v0, 0x0

    iput-boolean v0, p0, Lru/gates/app/LoginActivity;->done:Z

    .line 47
    iput v0, p0, Lru/gates/app/LoginActivity;->retries:I

    .line 48
    iput-boolean v0, p0, Lru/gates/app/LoginActivity;->loadFailed:Z

    .line 38
    return-void
.end method

.method static synthetic access$0(Lru/gates/app/LoginActivity;)Ljava/lang/String;
    .locals 0

    .line 46
    iget-object p0, p0, Lru/gates/app/LoginActivity;->polyfillJs:Ljava/lang/String;

    return-object p0
.end method

.method static synthetic access$1(Lru/gates/app/LoginActivity;Landroid/webkit/WebResourceRequest;)Landroid/webkit/WebResourceResponse;
    .locals 0

    .line 165
    invoke-direct {p0, p1}, Lru/gates/app/LoginActivity;->injectIntoHtml(Landroid/webkit/WebResourceRequest;)Landroid/webkit/WebResourceResponse;

    move-result-object p0

    return-object p0
.end method

.method static synthetic access$2(Lru/gates/app/LoginActivity;Z)V
    .locals 0

    .line 48
    iput-boolean p1, p0, Lru/gates/app/LoginActivity;->loadFailed:Z

    return-void
.end method

.method static synthetic access$3(Lru/gates/app/LoginActivity;)V
    .locals 0

    .line 263
    invoke-direct {p0}, Lru/gates/app/LoginActivity;->scheduleCheck()V

    return-void
.end method

.method static synthetic access$4(Lru/gates/app/LoginActivity;)Z
    .locals 0

    .line 48
    iget-boolean p0, p0, Lru/gates/app/LoginActivity;->loadFailed:Z

    return p0
.end method

.method static synthetic access$5(Lru/gates/app/LoginActivity;I)V
    .locals 0

    .line 47
    iput p1, p0, Lru/gates/app/LoginActivity;->retries:I

    return-void
.end method

.method static synthetic access$6(Lru/gates/app/LoginActivity;)I
    .locals 0

    .line 47
    iget p0, p0, Lru/gates/app/LoginActivity;->retries:I

    return p0
.end method

.method static synthetic access$7(Lru/gates/app/LoginActivity;)Landroid/os/Handler;
    .locals 0

    .line 44
    iget-object p0, p0, Lru/gates/app/LoginActivity;->handler:Landroid/os/Handler;

    return-object p0
.end method

.method static synthetic access$8(Lru/gates/app/LoginActivity;)Landroid/webkit/WebView;
    .locals 0

    .line 43
    iget-object p0, p0, Lru/gates/app/LoginActivity;->web:Landroid/webkit/WebView;

    return-object p0
.end method

.method private checkAuth()V
    .locals 3

    .line 269
    iget-boolean v0, p0, Lru/gates/app/LoginActivity;->done:Z

    if-eqz v0, :cond_0

    return-void

    .line 270
    :cond_0
    nop

    .line 275
    iget-object v0, p0, Lru/gates/app/LoginActivity;->web:Landroid/webkit/WebView;

    new-instance v1, Lru/gates/app/LoginActivity$$ExternalSyntheticLambda0;

    invoke-direct {v1, p0}, Lru/gates/app/LoginActivity$$ExternalSyntheticLambda0;-><init>(Lru/gates/app/LoginActivity;)V

    const-string v2, "(function(){if(!window.__gateSetupReady||!window.__gateSetupSerial||!window.__gateSetupCommand)return '';var a=localStorage.getItem('spruthub:store/auth')||'';var h=localStorage.getItem('spruthub:store/hubs')||'';var s=localStorage.getItem('spruthub:store/settings')||'';try{var j=JSON.parse(a);j.gateCommand=JSON.stringify(window.__gateSetupCommand);a=JSON.stringify(j);var q=JSON.parse(s||'{}');q.lastHubSerial=window.__gateSetupSerial;s=JSON.stringify(q);}catch(e){if(!window.__gateBridgeError){window.__gateBridgeError=true;console.error('GATE_DIAG:Привязка: не удалось прочитать данные входа. Перезагрузите страницу и войдите заново');}return '';}return a+'\\n@@@\\n'+h+'\\n@@@\\n'+s;})()"

    invoke-virtual {v0, v2, v1}, Landroid/webkit/WebView;->evaluateJavascript(Ljava/lang/String;Landroid/webkit/ValueCallback;)V

    .line 297
    return-void
.end method

.method private static chromeMajor(Ljava/lang/String;)I
    .locals 3

    .line 254
    const/4 v0, 0x0

    :try_start_0
    const-string v1, "Chrome/"

    invoke-virtual {p0, v1}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v1

    .line 255
    if-gez v1, :cond_0

    return v0

    .line 256
    :cond_0
    add-int/lit8 v1, v1, 0x7

    const/16 v2, 0x2e

    invoke-virtual {p0, v2, v1}, Ljava/lang/String;->indexOf(II)I

    move-result v2

    .line 257
    invoke-virtual {p0, v1, v2}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result p0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return p0

    .line 258
    :catch_0
    move-exception p0

    .line 259
    return v0
.end method

.method private injectIntoHtml(Landroid/webkit/WebResourceRequest;)Landroid/webkit/WebResourceResponse;
    .locals 10

    .line 166
    const-string v0, "text/html"

    .line 168
    const/4 v1, 0x0

    :try_start_0
    invoke-interface {p1}, Landroid/webkit/WebResourceRequest;->getUrl()Landroid/net/Uri;

    move-result-object v2

    invoke-virtual {v2}, Landroid/net/Uri;->toString()Ljava/lang/String;

    move-result-object v2

    .line 169
    new-instance v3, Ljava/net/URL;

    invoke-direct {v3, v2}, Ljava/net/URL;-><init>(Ljava/lang/String;)V

    invoke-virtual {v3}, Ljava/net/URL;->openConnection()Ljava/net/URLConnection;

    move-result-object v3

    check-cast v3, Ljava/net/HttpURLConnection;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_1
    .catchall {:try_start_0 .. :try_end_0} :catchall_1

    .line 170
    const/4 v4, 0x0

    :try_start_1
    invoke-virtual {v3, v4}, Ljava/net/HttpURLConnection;->setInstanceFollowRedirects(Z)V

    .line 171
    const/16 v5, 0x3a98

    invoke-virtual {v3, v5}, Ljava/net/HttpURLConnection;->setConnectTimeout(I)V

    .line 172
    const/16 v5, 0x7530

    invoke-virtual {v3, v5}, Ljava/net/HttpURLConnection;->setReadTimeout(I)V

    .line 173
    invoke-interface {p1}, Landroid/webkit/WebResourceRequest;->getRequestHeaders()Ljava/util/Map;

    move-result-object p1

    invoke-interface {p1}, Ljava/util/Map;->entrySet()Ljava/util/Set;

    move-result-object p1

    invoke-interface {p1}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :cond_0
    :goto_0
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v5
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    const-string v6, "Accept-Encoding"

    if-nez v5, :cond_e

    .line 180
    :try_start_2
    const-string p1, "identity"

    invoke-virtual {v3, v6, p1}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    .line 181
    invoke-static {}, Landroid/webkit/CookieManager;->getInstance()Landroid/webkit/CookieManager;

    move-result-object p1

    invoke-virtual {p1, v2}, Landroid/webkit/CookieManager;->getCookie(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    .line 182
    if-eqz p1, :cond_1

    .line 183
    const-string v5, "Cookie"

    invoke-virtual {v3, v5, p1}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    .line 185
    :cond_1
    invoke-virtual {v3}, Ljava/net/HttpURLConnection;->getResponseCode()I

    move-result p1

    .line 186
    invoke-virtual {v3}, Ljava/net/HttpURLConnection;->getContentType()Ljava/lang/String;

    move-result-object v5

    .line 187
    invoke-virtual {v3}, Ljava/net/HttpURLConnection;->getHeaderFields()Ljava/util/Map;

    move-result-object v6

    invoke-interface {v6}, Ljava/util/Map;->entrySet()Ljava/util/Set;

    move-result-object v6

    invoke-interface {v6}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v6

    :cond_2
    :goto_1
    invoke-interface {v6}, Ljava/util/Iterator;->hasNext()Z

    move-result v7

    if-nez v7, :cond_c

    .line 194
    const/16 v2, 0xc8

    if-ne p1, v2, :cond_a

    if-nez v5, :cond_3

    goto/16 :goto_4

    .line 197
    :cond_3
    invoke-virtual {v5}, Ljava/lang/String;->toLowerCase()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p1, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result p1
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_0
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    if-nez p1, :cond_5

    .line 227
    if-eqz v3, :cond_4

    invoke-virtual {v3}, Ljava/net/HttpURLConnection;->disconnect()V

    .line 198
    :cond_4
    return-object v1

    .line 200
    :cond_5
    :try_start_3
    const-string p1, "UTF-8"

    .line 201
    invoke-virtual {v5}, Ljava/lang/String;->toLowerCase()Ljava/lang/String;

    move-result-object v2

    const-string v6, "charset="

    invoke-virtual {v2, v6}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v2

    .line 202
    if-ltz v2, :cond_6

    .line 203
    add-int/lit8 v2, v2, 0x8

    invoke-virtual {v5, v2}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object p1

    const-string v2, "\""

    const-string v5, ""

    invoke-virtual {p1, v2, v5}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object p1

    const-string v2, ";"

    invoke-virtual {p1, v2}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object p1

    aget-object p1, p1, v4

    invoke-virtual {p1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p1

    .line 205
    :cond_6
    invoke-virtual {v3}, Ljava/net/HttpURLConnection;->getInputStream()Ljava/io/InputStream;

    move-result-object v2

    .line 206
    new-instance v5, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v5}, Ljava/io/ByteArrayOutputStream;-><init>()V

    .line 207
    const/16 v6, 0x2000

    new-array v6, v6, [B

    .line 209
    nop

    :goto_2
    invoke-virtual {v2, v6}, Ljava/io/InputStream;->read([B)I

    move-result v7

    if-gtz v7, :cond_9

    .line 212
    invoke-virtual {v2}, Ljava/io/InputStream;->close()V

    .line 213
    invoke-virtual {v5, p1}, Ljava/io/ByteArrayOutputStream;->toString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 214
    new-instance v5, Ljava/lang/StringBuilder;

    const-string v6, "<script>"

    invoke-direct {v5, v6}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v6, p0, Lru/gates/app/LoginActivity;->polyfillJs:Ljava/lang/String;

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    const-string v6, "</script>"

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    .line 215
    invoke-virtual {v2}, Ljava/lang/String;->toLowerCase()Ljava/lang/String;

    move-result-object v6

    const-string v7, "<head"

    invoke-virtual {v6, v7}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v6

    .line 216
    if-ltz v6, :cond_7

    .line 217
    const/16 v7, 0x3e

    invoke-virtual {v2, v7, v6}, Ljava/lang/String;->indexOf(II)I

    move-result v6

    .line 218
    new-instance v7, Ljava/lang/StringBuilder;

    add-int/lit8 v6, v6, 0x1

    invoke-virtual {v2, v4, v6}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v4

    invoke-static {v4}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v4

    invoke-direct {v7, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v7, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v2, v6}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    .line 219
    goto :goto_3

    .line 220
    :cond_7
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-static {v5}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v5

    invoke-direct {v4, v5}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    .line 222
    :goto_3
    new-instance v4, Landroid/webkit/WebResourceResponse;

    .line 223
    new-instance v5, Ljava/io/ByteArrayInputStream;

    invoke-virtual {v2, p1}, Ljava/lang/String;->getBytes(Ljava/lang/String;)[B

    move-result-object v2

    invoke-direct {v5, v2}, Ljava/io/ByteArrayInputStream;-><init>([B)V

    .line 222
    invoke-direct {v4, v0, p1, v5}, Landroid/webkit/WebResourceResponse;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/io/InputStream;)V
    :try_end_3
    .catch Ljava/lang/Exception; {:try_start_3 .. :try_end_3} :catch_0
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    .line 227
    if-eqz v3, :cond_8

    invoke-virtual {v3}, Ljava/net/HttpURLConnection;->disconnect()V

    .line 222
    :cond_8
    return-object v4

    .line 210
    :cond_9
    :try_start_4
    invoke-virtual {v5, v6, v4, v7}, Ljava/io/ByteArrayOutputStream;->write([BII)V
    :try_end_4
    .catch Ljava/lang/Exception; {:try_start_4 .. :try_end_4} :catch_0
    .catchall {:try_start_4 .. :try_end_4} :catchall_0

    goto :goto_2

    .line 227
    :cond_a
    :goto_4
    if-eqz v3, :cond_b

    invoke-virtual {v3}, Ljava/net/HttpURLConnection;->disconnect()V

    .line 195
    :cond_b
    return-object v1

    .line 187
    :cond_c
    :try_start_5
    invoke-interface {v6}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v7

    check-cast v7, Ljava/util/Map$Entry;

    .line 188
    invoke-interface {v7}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object v8

    if-eqz v8, :cond_2

    invoke-interface {v7}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object v8

    check-cast v8, Ljava/lang/String;

    const-string v9, "Set-Cookie"

    invoke-virtual {v8, v9}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v8

    if-eqz v8, :cond_2

    .line 189
    invoke-interface {v7}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    move-result-object v7

    check-cast v7, Ljava/util/List;

    invoke-interface {v7}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v7

    :goto_5
    invoke-interface {v7}, Ljava/util/Iterator;->hasNext()Z

    move-result v8

    if-nez v8, :cond_d

    goto/16 :goto_1

    :cond_d
    invoke-interface {v7}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v8

    check-cast v8, Ljava/lang/String;

    .line 190
    invoke-static {}, Landroid/webkit/CookieManager;->getInstance()Landroid/webkit/CookieManager;

    move-result-object v9

    invoke-virtual {v9, v2, v8}, Landroid/webkit/CookieManager;->setCookie(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_5

    .line 173
    :cond_e
    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Ljava/util/Map$Entry;

    .line 174
    invoke-interface {v5}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object v7

    check-cast v7, Ljava/lang/String;

    .line 175
    invoke-virtual {v7, v6}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v6

    if-nez v6, :cond_0

    const-string v6, "Range"

    invoke-virtual {v7, v6}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v6

    if-nez v6, :cond_0

    .line 176
    const-string v6, "If-None-Match"

    invoke-virtual {v7, v6}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v6

    if-nez v6, :cond_0

    const-string v6, "If-Modified-Since"

    invoke-virtual {v7, v6}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v6

    if-nez v6, :cond_0

    .line 177
    invoke-interface {v5}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Ljava/lang/String;

    invoke-virtual {v3, v7, v5}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V
    :try_end_5
    .catch Ljava/lang/Exception; {:try_start_5 .. :try_end_5} :catch_0
    .catchall {:try_start_5 .. :try_end_5} :catchall_0

    goto/16 :goto_0

    .line 226
    :catchall_0
    move-exception p1

    move-object v1, v3

    goto :goto_6

    .line 224
    :catch_0
    move-exception p1

    goto :goto_7

    .line 226
    :catchall_1
    move-exception p1

    .line 227
    :goto_6
    if-eqz v1, :cond_f

    invoke-virtual {v1}, Ljava/net/HttpURLConnection;->disconnect()V

    .line 228
    :cond_f
    throw p1

    .line 224
    :catch_1
    move-exception p1

    move-object v3, v1

    .line 227
    :goto_7
    if-eqz v3, :cond_10

    invoke-virtual {v3}, Ljava/net/HttpURLConnection;->disconnect()V

    .line 225
    :cond_10
    return-object v1
.end method

.method private readAsset(Ljava/lang/String;)Ljava/lang/String;
    .locals 6

    .line 232
    nop

    .line 234
    const/4 v0, 0x0

    :try_start_0
    invoke-virtual {p0}, Lru/gates/app/LoginActivity;->getAssets()Landroid/content/res/AssetManager;

    move-result-object v1

    invoke-virtual {v1, p1}, Landroid/content/res/AssetManager;->open(Ljava/lang/String;)Ljava/io/InputStream;

    move-result-object p1
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_3
    .catchall {:try_start_0 .. :try_end_0} :catchall_1

    .line 235
    :try_start_1
    new-instance v1, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v1}, Ljava/io/ByteArrayOutputStream;-><init>()V

    .line 236
    const/16 v2, 0x1000

    new-array v2, v2, [B

    .line 238
    nop

    :goto_0
    invoke-virtual {p1, v2}, Ljava/io/InputStream;->read([B)I

    move-result v3

    if-gtz v3, :cond_1

    .line 241
    const-string v2, "UTF-8"

    invoke-virtual {v1, v2}, Ljava/io/ByteArrayOutputStream;->toString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 245
    if-eqz p1, :cond_0

    .line 246
    :try_start_2
    invoke-virtual {p1}, Ljava/io/InputStream;->close()V
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_0

    .line 247
    :goto_1
    goto :goto_2

    :catch_0
    move-exception p1

    goto :goto_1

    .line 241
    :cond_0
    :goto_2
    return-object v0

    .line 239
    :cond_1
    const/4 v4, 0x0

    :try_start_3
    invoke-virtual {v1, v2, v4, v3}, Ljava/io/ByteArrayOutputStream;->write([BII)V
    :try_end_3
    .catch Ljava/lang/Exception; {:try_start_3 .. :try_end_3} :catch_1
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    goto :goto_0

    .line 244
    :catchall_0
    move-exception v0

    goto :goto_3

    .line 242
    :catch_1
    move-exception v1

    goto :goto_6

    .line 244
    :catchall_1
    move-exception p1

    move-object v5, v0

    move-object v0, p1

    move-object p1, v5

    .line 245
    :goto_3
    if-eqz p1, :cond_2

    .line 246
    :try_start_4
    invoke-virtual {p1}, Ljava/io/InputStream;->close()V
    :try_end_4
    .catch Ljava/lang/Exception; {:try_start_4 .. :try_end_4} :catch_2

    .line 247
    :goto_4
    goto :goto_5

    :catch_2
    move-exception p1

    goto :goto_4

    .line 249
    :cond_2
    :goto_5
    throw v0

    .line 242
    :catch_3
    move-exception p1

    move-object p1, v0

    .line 245
    :goto_6
    if-eqz p1, :cond_3

    .line 246
    :try_start_5
    invoke-virtual {p1}, Ljava/io/InputStream;->close()V
    :try_end_5
    .catch Ljava/lang/Exception; {:try_start_5 .. :try_end_5} :catch_4

    .line 247
    :goto_7
    goto :goto_8

    :catch_4
    move-exception p1

    goto :goto_7

    .line 243
    :cond_3
    :goto_8
    return-object v0
.end method

.method private scheduleCheck()V
    .locals 4

    .line 264
    iget-boolean v0, p0, Lru/gates/app/LoginActivity;->done:Z

    if-eqz v0, :cond_0

    return-void

    .line 265
    :cond_0
    iget-object v0, p0, Lru/gates/app/LoginActivity;->handler:Landroid/os/Handler;

    new-instance v1, Lru/gates/app/LoginActivity$$ExternalSyntheticLambda1;

    invoke-direct {v1, p0}, Lru/gates/app/LoginActivity$$ExternalSyntheticLambda1;-><init>(Lru/gates/app/LoginActivity;)V

    const-wide/16 v2, 0x5dc

    invoke-virtual {v0, v1, v2, v3}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 266
    return-void
.end method

.method private unquoteJs(Ljava/lang/String;)Ljava/lang/String;
    .locals 3

    .line 301
    :try_start_0
    new-instance v0, Lorg/json/JSONArray;

    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "["

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "]"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {v0, v1}, Lorg/json/JSONArray;-><init>(Ljava/lang/String;)V

    .line 302
    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Lorg/json/JSONArray;->getString(I)Ljava/lang/String;

    move-result-object p1
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-object p1

    .line 303
    :catch_0
    move-exception v0

    .line 304
    return-object p1
.end method


# virtual methods
.method synthetic lambda$1$ru-gates-app-LoginActivity(Ljava/lang/String;)V
    .locals 6

    .line 276
    iget-boolean v0, p0, Lru/gates/app/LoginActivity;->done:Z

    if-nez v0, :cond_5

    if-eqz p1, :cond_5

    const-string v0, "null"

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_2

    .line 280
    :cond_0
    invoke-direct {p0, p1}, Lru/gates/app/LoginActivity;->unquoteJs(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    .line 281
    const-string v0, "\n@@@\n"

    const/4 v1, 0x3

    invoke-virtual {p1, v0, v1}, Ljava/lang/String;->split(Ljava/lang/String;I)[Ljava/lang/String;

    move-result-object p1

    .line 282
    array-length v0, p1

    const-string v1, ""

    if-lez v0, :cond_1

    const/4 v0, 0x0

    aget-object v0, p1, v0

    goto :goto_0

    :cond_1
    move-object v0, v1

    .line 283
    :goto_0
    array-length v2, p1

    const/4 v3, 0x1

    if-le v2, v3, :cond_2

    aget-object v2, p1, v3

    goto :goto_1

    :cond_2
    move-object v2, v1

    .line 284
    :goto_1
    array-length v4, p1

    const/4 v5, 0x2

    if-le v4, v5, :cond_3

    aget-object v1, p1, v5

    .line 285
    :cond_3
    const-string p1, "\"token\""

    invoke-virtual {v0, p1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result p1

    if-eqz p1, :cond_4

    .line 286
    invoke-static {p0, v0, v2, v1}, Lru/gates/app/SprutApi;->saveFromWeb(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 287
    invoke-static {p0}, Lru/gates/app/SprutApi;->hasCredentials(Landroid/content/Context;)Z

    move-result p1

    if-eqz p1, :cond_4

    .line 288
    iput-boolean v3, p0, Lru/gates/app/LoginActivity;->done:Z

    .line 289
    nop

    .line 290
    nop

    .line 289
    const-string p1, "\u0413\u043e\u0442\u043e\u0432\u043e! \u0422\u0435\u043f\u0435\u0440\u044c \u0432\u043e\u0440\u043e\u0442\u0430 \u043e\u0442\u043a\u0440\u044b\u0432\u0430\u044e\u0442\u0441\u044f \u043f\u043e \u043d\u0430\u0436\u0430\u0442\u0438\u044e \u043d\u0430 \u0438\u043a\u043e\u043d\u043a\u0443"

    invoke-static {p0, p1, v3}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p1

    .line 290
    invoke-virtual {p1}, Landroid/widget/Toast;->show()V

    .line 291
    invoke-virtual {p0}, Lru/gates/app/LoginActivity;->finish()V

    .line 292
    return-void

    .line 295
    :cond_4
    invoke-direct {p0}, Lru/gates/app/LoginActivity;->scheduleCheck()V

    .line 296
    return-void

    .line 277
    :cond_5
    :goto_2
    invoke-direct {p0}, Lru/gates/app/LoginActivity;->scheduleCheck()V

    .line 278
    return-void
.end method

.method protected onCreate(Landroid/os/Bundle;)V
    .locals 6

    .line 53
    invoke-super {p0, p1}, Landroid/app/Activity;->onCreate(Landroid/os/Bundle;)V

    .line 55
    new-instance p1, Landroid/widget/LinearLayout;

    invoke-direct {p1, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v0, 0x1
    invoke-virtual {p1, v0}, Landroid/widget/LinearLayout;->setOrientation(I)V

    .line 56
    const-string v0, "#121212"

    invoke-static {v0}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v1

    invoke-virtual {p1, v1}, Landroid/widget/LinearLayout;->setBackgroundColor(I)V

    .line 58
    new-instance v1, Landroid/webkit/WebView;

    invoke-direct {v1, p0}, Landroid/webkit/WebView;-><init>(Landroid/content/Context;)V

    iput-object v1, p0, Lru/gates/app/LoginActivity;->web:Landroid/webkit/WebView;

    .line 59
    invoke-static {v0}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v0

    invoke-virtual {v1, v0}, Landroid/webkit/WebView;->setBackgroundColor(I)V

    # Keep the existing software fallback for large head-unit/tablet layouts.
    # Phones use the normal hardware-accelerated WebView composition.
    invoke-virtual {p0}, Lru/gates/app/LoginActivity;->getResources()Landroid/content/res/Resources;
    move-result-object v2
    invoke-virtual {v2}, Landroid/content/res/Resources;->getConfiguration()Landroid/content/res/Configuration;
    move-result-object v2
    iget v2, v2, Landroid/content/res/Configuration;->smallestScreenWidthDp:I
    const/16 v3, 0x258
    if-ge v2, v3, :large_display
    const/4 v2, 0x0
    goto :layer_selected
    :large_display
    const/4 v2, 0x1
    :layer_selected
    const/4 v3, 0x0
    invoke-virtual {v1, v2, v3}, Landroid/webkit/WebView;->setLayerType(ILandroid/graphics/Paint;)V
    invoke-virtual {v1, v3}, Landroid/webkit/WebView;->setInitialScale(I)V

    .line 61
    new-instance v0, Landroid/widget/TextView;

    invoke-direct {v0, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    .line 62
    const-string v1, "\u0412\u043e\u0439\u0434\u0438\u0442\u0435 \u0432 SprutHub \u043e\u0434\u0438\u043d \u0440\u0430\u0437 \u2014 \u0434\u0430\u043b\u044c\u0448\u0435 \u0432\u043e\u0440\u043e\u0442\u0430 \u0431\u0443\u0434\u0443\u0442 \u043e\u0442\u043a\u0440\u044b\u0432\u0430\u0442\u044c\u0441\u044f \u043f\u043e \u043d\u0430\u0436\u0430\u0442\u0438\u044e \u043d\u0430 \u0438\u043a\u043e\u043d\u043a\u0443"

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    new-instance v2, Lru/gates/app/LoginChromeClient;
    invoke-direct {v2, v0}, Lru/gates/app/LoginChromeClient;-><init>(Landroid/widget/TextView;)V
    iget-object v3, p0, Lru/gates/app/LoginActivity;->web:Landroid/webkit/WebView;
    invoke-virtual {v3, v2}, Landroid/webkit/WebView;->setWebChromeClient(Landroid/webkit/WebChromeClient;)V
    new-instance v2, Lru/gates/app/LoginReload;
    invoke-direct {v2, v3}, Lru/gates/app/LoginReload;-><init>(Landroid/webkit/WebView;)V
    invoke-virtual {v0, v2}, Landroid/widget/TextView;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 63
    const/4 v1, -0x1

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setTextColor(I)V
    const/4 v2, 0x2
    invoke-virtual {v0, v2}, Landroid/widget/TextView;->setMaxLines(I)V
    sget-object v2, Landroid/text/TextUtils$TruncateAt;->END:Landroid/text/TextUtils$TruncateAt;
    invoke-virtual {v0, v2}, Landroid/widget/TextView;->setEllipsize(Landroid/text/TextUtils$TruncateAt;)V


    .line 64
    const/high16 v2, 0x41600000    # 14.0f

    invoke-virtual {v0, v2}, Landroid/widget/TextView;->setTextSize(F)V

    .line 65
    const/16 v3, 0x11

    invoke-virtual {v0, v3}, Landroid/widget/TextView;->setGravity(I)V

    .line 66
    const v3, -0x19ddd9d5

    invoke-virtual {v0, v3}, Landroid/widget/TextView;->setBackgroundColor(I)V

    .line 67
    invoke-virtual {p0}, Lru/gates/app/LoginActivity;->getResources()Landroid/content/res/Resources;

    move-result-object v3

    invoke-virtual {v3}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v3

    iget v3, v3, Landroid/util/DisplayMetrics;->density:F

    mul-float/2addr v3, v2

    float-to-int v2, v3

    .line 68
    invoke-virtual {v0, v2, v2, v2, v2}, Landroid/widget/TextView;->setPadding(IIII)V

    .line 70
    iget-object v2, p0, Lru/gates/app/LoginActivity;->web:Landroid/webkit/WebView;

    invoke-virtual {v2}, Landroid/webkit/WebView;->getSettings()Landroid/webkit/WebSettings;

    move-result-object v2

    .line 71
    const/4 v3, 0x1

    invoke-virtual {v2, v3}, Landroid/webkit/WebSettings;->setJavaScriptEnabled(Z)V

    .line 72
    invoke-virtual {v2, v3}, Landroid/webkit/WebSettings;->setDomStorageEnabled(Z)V
    invoke-virtual {v2, v3}, Landroid/webkit/WebSettings;->setUseWideViewPort(Z)V
    const/4 v4, 0x0
    invoke-virtual {v2, v4}, Landroid/webkit/WebSettings;->setLoadWithOverviewMode(Z)V
    const/16 v5, 0x64
    invoke-virtual {v2, v5}, Landroid/webkit/WebSettings;->setTextZoom(I)V


    .line 73
    const/4 v4, 0x0

    invoke-virtual {v2, v4}, Landroid/webkit/WebSettings;->setMediaPlaybackRequiresUserGesture(Z)V

    const/4 v5, 0x2
    invoke-virtual {v2, v5}, Landroid/webkit/WebSettings;->setCacheMode(I)V

    .line 74
    invoke-virtual {v2, v4}, Landroid/webkit/WebSettings;->setSupportZoom(Z)V

    .line 75
    invoke-virtual {v2, v4}, Landroid/webkit/WebSettings;->setBuiltInZoomControls(Z)V

    .line 76
    invoke-static {}, Landroid/webkit/CookieManager;->getInstance()Landroid/webkit/CookieManager;

    move-result-object v4

    .line 77
    nop

    .line 78
    iget-object v5, p0, Lru/gates/app/LoginActivity;->web:Landroid/webkit/WebView;

    invoke-virtual {v4, v5, v3}, Landroid/webkit/CookieManager;->setAcceptThirdPartyCookies(Landroid/webkit/WebView;Z)V

    .line 81
    invoke-virtual {v2}, Landroid/webkit/WebSettings;->getUserAgentString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lru/gates/app/LoginActivity;->chromeMajor(Ljava/lang/String;)I

    .line 83
    const-string v2, "polyfills.js"

    invoke-direct {p0, v2}, Lru/gates/app/LoginActivity;->readAsset(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    iput-object v2, p0, Lru/gates/app/LoginActivity;->polyfillJs:Ljava/lang/String;

    .line 85
    iget-object v2, p0, Lru/gates/app/LoginActivity;->web:Landroid/webkit/WebView;

    new-instance v3, Lru/gates/app/LoginActivity$1;

    invoke-direct {v3, p0}, Lru/gates/app/LoginActivity$1;-><init>(Lru/gates/app/LoginActivity;)V

    invoke-virtual {v2, v3}, Landroid/webkit/WebView;->setWebViewClient(Landroid/webkit/WebViewClient;)V

    .line 153
    iget-object v2, p0, Lru/gates/app/LoginActivity;->web:Landroid/webkit/WebView;

    new-instance v3, Landroid/widget/LinearLayout$LayoutParams;

    .line 154
    const/4 v4, 0x0
    const/high16 v5, 0x3f800000    # 1.0f
    invoke-direct {v3, v1, v4, v5}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    .line 153
    invoke-virtual {p1, v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 155
    new-instance v2, Landroid/widget/LinearLayout$LayoutParams;

    .line 156
    nop

    .line 155
    const/4 v3, -0x2

    invoke-direct {v2, v1, v3}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    .line 157
    nop

    .line 158
    invoke-virtual {p1, v0, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 159
    invoke-virtual {p0, p1}, Lru/gates/app/LoginActivity;->setContentView(Landroid/view/View;)V

    .line 161
    iget-object p1, p0, Lru/gates/app/LoginActivity;->web:Landroid/webkit/WebView;

    const-string v0, "https://beta.spruthub.ru/"

    invoke-virtual {p1, v0}, Landroid/webkit/WebView;->loadUrl(Ljava/lang/String;)V

    .line 162
    return-void
.end method

.method protected onDestroy()V
    .locals 2

    .line 310
    iget-object v0, p0, Lru/gates/app/LoginActivity;->handler:Landroid/os/Handler;

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacksAndMessages(Ljava/lang/Object;)V

    .line 311
    iget-object v0, p0, Lru/gates/app/LoginActivity;->web:Landroid/webkit/WebView;

    if-eqz v0, :cond_0

    invoke-virtual {v0}, Landroid/webkit/WebView;->destroy()V

    .line 312
    :cond_0
    invoke-super {p0}, Landroid/app/Activity;->onDestroy()V

    .line 313
    return-void
.end method
