.class Lru/gates/app/LoginActivity$1;
.super Landroid/webkit/WebViewClient;
.source "LoginActivity.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lru/gates/app/LoginActivity;->onCreate(Landroid/os/Bundle;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lru/gates/app/LoginActivity;


# direct methods
.method constructor <init>(Lru/gates/app/LoginActivity;)V
    .locals 0

    .line 85
    iput-object p1, p0, Lru/gates/app/LoginActivity$1;->this$0:Lru/gates/app/LoginActivity;

    invoke-direct {p0}, Landroid/webkit/WebViewClient;-><init>()V

    return-void
.end method


# virtual methods
.method synthetic lambda$0$ru-gates-app-LoginActivity$1(Ljava/lang/String;)V
    .locals 1

    .line 139
    iget-object v0, p0, Lru/gates/app/LoginActivity$1;->this$0:Lru/gates/app/LoginActivity;

    invoke-static {v0}, Lru/gates/app/LoginActivity;->access$8(Lru/gates/app/LoginActivity;)Landroid/webkit/WebView;

    move-result-object v0

    if-eqz v0, :cond_0

    iget-object v0, p0, Lru/gates/app/LoginActivity$1;->this$0:Lru/gates/app/LoginActivity;

    invoke-static {v0}, Lru/gates/app/LoginActivity;->access$8(Lru/gates/app/LoginActivity;)Landroid/webkit/WebView;

    move-result-object v0

    invoke-virtual {v0, p1}, Landroid/webkit/WebView;->loadUrl(Ljava/lang/String;)V

    .line 140
    :cond_0
    return-void
.end method

.method public onPageFinished(Landroid/webkit/WebView;Ljava/lang/String;)V
    .locals 0

    .line 126
    iget-object p1, p0, Lru/gates/app/LoginActivity$1;->this$0:Lru/gates/app/LoginActivity;

    invoke-static {p1}, Lru/gates/app/LoginActivity;->access$4(Lru/gates/app/LoginActivity;)Z

    move-result p1

    if-nez p1, :cond_0

    if-eqz p2, :cond_0

    const-string p1, "http"

    invoke-virtual {p2, p1}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result p1

    if-eqz p1, :cond_0

    .line 127
    iget-object p1, p0, Lru/gates/app/LoginActivity$1;->this$0:Lru/gates/app/LoginActivity;

    const/4 p2, 0x0

    invoke-static {p1, p2}, Lru/gates/app/LoginActivity;->access$5(Lru/gates/app/LoginActivity;I)V

    .line 129
    :cond_0
    return-void
.end method

.method public onPageStarted(Landroid/webkit/WebView;Ljava/lang/String;Landroid/graphics/Bitmap;)V
    .locals 0

    .line 117
    iget-object p2, p0, Lru/gates/app/LoginActivity$1;->this$0:Lru/gates/app/LoginActivity;

    const/4 p3, 0x0

    invoke-static {p2, p3}, Lru/gates/app/LoginActivity;->access$2(Lru/gates/app/LoginActivity;Z)V

    .line 118
    iget-object p2, p0, Lru/gates/app/LoginActivity$1;->this$0:Lru/gates/app/LoginActivity;

    invoke-static {p2}, Lru/gates/app/LoginActivity;->access$0(Lru/gates/app/LoginActivity;)Ljava/lang/String;

    move-result-object p2

    if-eqz p2, :cond_0

    .line 119
    iget-object p2, p0, Lru/gates/app/LoginActivity$1;->this$0:Lru/gates/app/LoginActivity;

    invoke-static {p2}, Lru/gates/app/LoginActivity;->access$0(Lru/gates/app/LoginActivity;)Ljava/lang/String;

    move-result-object p2

    const/4 p3, 0x0

    invoke-virtual {p1, p2, p3}, Landroid/webkit/WebView;->evaluateJavascript(Ljava/lang/String;Landroid/webkit/ValueCallback;)V

    .line 121
    :cond_0
    iget-object p1, p0, Lru/gates/app/LoginActivity$1;->this$0:Lru/gates/app/LoginActivity;

    invoke-static {p1}, Lru/gates/app/LoginActivity;->access$3(Lru/gates/app/LoginActivity;)V

    .line 122
    return-void
.end method

.method public onReceivedError(Landroid/webkit/WebView;Landroid/webkit/WebResourceRequest;Landroid/webkit/WebResourceError;)V
    .locals 9

    .line 133
    invoke-interface {p2}, Landroid/webkit/WebResourceRequest;->isForMainFrame()Z

    move-result p3

    if-eqz p3, :cond_1

    .line 134
    iget-object p3, p0, Lru/gates/app/LoginActivity$1;->this$0:Lru/gates/app/LoginActivity;

    const/4 v0, 0x1

    invoke-static {p3, v0}, Lru/gates/app/LoginActivity;->access$2(Lru/gates/app/LoginActivity;Z)V

    .line 135
    iget-object p3, p0, Lru/gates/app/LoginActivity$1;->this$0:Lru/gates/app/LoginActivity;

    invoke-static {p3}, Lru/gates/app/LoginActivity;->access$6(Lru/gates/app/LoginActivity;)I

    move-result p3

    const/4 v1, 0x5

    if-ge p3, v1, :cond_0

    .line 136
    iget-object p3, p0, Lru/gates/app/LoginActivity$1;->this$0:Lru/gates/app/LoginActivity;

    invoke-static {p3}, Lru/gates/app/LoginActivity;->access$6(Lru/gates/app/LoginActivity;)I

    move-result v1

    add-int/2addr v1, v0

    invoke-static {p3, v1}, Lru/gates/app/LoginActivity;->access$5(Lru/gates/app/LoginActivity;I)V

    .line 137
    invoke-interface {p2}, Landroid/webkit/WebResourceRequest;->getUrl()Landroid/net/Uri;

    move-result-object p2

    invoke-virtual {p2}, Landroid/net/Uri;->toString()Ljava/lang/String;

    move-result-object p2

    .line 138
    iget-object p3, p0, Lru/gates/app/LoginActivity$1;->this$0:Lru/gates/app/LoginActivity;

    invoke-static {p3}, Lru/gates/app/LoginActivity;->access$7(Lru/gates/app/LoginActivity;)Landroid/os/Handler;

    move-result-object p3

    new-instance v0, Lru/gates/app/LoginActivity$1$$ExternalSyntheticLambda0;

    invoke-direct {v0, p0, p2}, Lru/gates/app/LoginActivity$1$$ExternalSyntheticLambda0;-><init>(Lru/gates/app/LoginActivity$1;Ljava/lang/String;)V

    .line 140
    nop

    .line 138
    const-wide/16 v1, 0xbb8

    invoke-virtual {p3, v0, v1, v2}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 142
    :cond_0
    const/4 v4, 0x0

    .line 143
    const-string v5, "<html><body style=\'background:#121212;color:#ddd;font-family:sans-serif;text-align:center;padding-top:30vh\'><h3>\u041d\u0435\u0442 \u0441\u043e\u0435\u0434\u0438\u043d\u0435\u043d\u0438\u044f</h3><button style=\'font-size:18px;padding:10px 24px\' onclick=\"location.replace(\'https://beta.spruthub.ru/\')\">\u041f\u043e\u0432\u0442\u043e\u0440\u0438\u0442\u044c</button></body></html>"

    .line 148
    const-string v6, "text/html"

    const-string v7, "UTF-8"

    const/4 v8, 0x0

    .line 142
    move-object v3, p1

    invoke-virtual/range {v3 .. v8}, Landroid/webkit/WebView;->loadDataWithBaseURL(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 150
    :cond_1
    return-void
.end method

.method public shouldInterceptRequest(Landroid/webkit/WebView;Landroid/webkit/WebResourceRequest;)Landroid/webkit/WebResourceResponse;
    .locals 1

    .line 88
    iget-object p1, p0, Lru/gates/app/LoginActivity$1;->this$0:Lru/gates/app/LoginActivity;

    invoke-static {p1}, Lru/gates/app/LoginActivity;->access$0(Lru/gates/app/LoginActivity;)Ljava/lang/String;

    move-result-object p1

    if-eqz p1, :cond_1

    invoke-interface {p2}, Landroid/webkit/WebResourceRequest;->isForMainFrame()Z

    move-result p1

    if-eqz p1, :cond_1

    .line 89
    const-string p1, "GET"

    invoke-interface {p2}, Landroid/webkit/WebResourceRequest;->getMethod()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_1

    .line 90
    invoke-interface {p2}, Landroid/webkit/WebResourceRequest;->getUrl()Landroid/net/Uri;

    move-result-object p1

    invoke-virtual {p1}, Landroid/net/Uri;->getScheme()Ljava/lang/String;

    move-result-object p1

    const-string v0, "https"

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_1

    .line 91
    invoke-interface {p2}, Landroid/webkit/WebResourceRequest;->getUrl()Landroid/net/Uri;

    move-result-object p1

    invoke-virtual {p1}, Landroid/net/Uri;->getHost()Ljava/lang/String;

    move-result-object p1

    .line 92
    if-eqz p1, :cond_1

    const-string v0, "spruthub.ru"

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_0

    const-string v0, ".spruthub.ru"

    invoke-virtual {p1, v0}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result p1

    if-eqz p1, :cond_1

    .line 93
    :cond_0
    iget-object p1, p0, Lru/gates/app/LoginActivity$1;->this$0:Lru/gates/app/LoginActivity;

    invoke-static {p1, p2}, Lru/gates/app/LoginActivity;->access$1(Lru/gates/app/LoginActivity;Landroid/webkit/WebResourceRequest;)Landroid/webkit/WebResourceResponse;

    move-result-object p1

    return-object p1

    .line 96
    :cond_1
    const/4 p1, 0x0

    return-object p1
.end method

.method public shouldOverrideUrlLoading(Landroid/webkit/WebView;Landroid/webkit/WebResourceRequest;)Z
    .locals 4

    .line 101
    invoke-interface {p2}, Landroid/webkit/WebResourceRequest;->getUrl()Landroid/net/Uri;

    move-result-object p1

    .line 102
    invoke-virtual {p1}, Landroid/net/Uri;->getScheme()Ljava/lang/String;

    move-result-object p2

    .line 103
    invoke-virtual {p1}, Landroid/net/Uri;->getHost()Ljava/lang/String;

    move-result-object v0

    .line 104
    const-string v1, "http"

    invoke-virtual {v1, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    const/4 v2, 0x0

    const/4 v3, 0x1

    if-nez v1, :cond_0

    const-string v1, "https"

    invoke-virtual {v1, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p2

    if-nez p2, :cond_0

    move p2, v2

    goto :goto_0

    :cond_0
    move p2, v3

    .line 105
    :goto_0
    if-eqz p2, :cond_2

    if-eqz v0, :cond_2

    const-string p2, "spruthub.ru"

    invoke-virtual {v0, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p2

    if-nez p2, :cond_1

    const-string p2, ".spruthub.ru"

    invoke-virtual {v0, p2}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result p2

    if-eqz p2, :cond_2

    .line 106
    :cond_1
    return v2

    .line 109
    :cond_2
    :try_start_0
    iget-object p2, p0, Lru/gates/app/LoginActivity$1;->this$0:Lru/gates/app/LoginActivity;

    new-instance v0, Landroid/content/Intent;

    const-string v1, "android.intent.action.VIEW"

    invoke-direct {v0, v1, p1}, Landroid/content/Intent;-><init>(Ljava/lang/String;Landroid/net/Uri;)V

    invoke-virtual {p2, v0}, Lru/gates/app/LoginActivity;->startActivity(Landroid/content/Intent;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_1

    .line 110
    :catch_0
    move-exception p1

    :goto_1
    nop

    .line 112
    return v3
.end method
