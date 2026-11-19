.class public Lru/gates/app/LoginChromeClient;
.super Landroid/webkit/WebChromeClient;
.field private status:Landroid/widget/TextView;
.field private failed:Z
.method public constructor <init>(Landroid/widget/TextView;)V
    .locals 0
    invoke-direct {p0}, Landroid/webkit/WebChromeClient;-><init>()V
    iput-object p1, p0, Lru/gates/app/LoginChromeClient;->status:Landroid/widget/TextView;
    return-void
.end method
.method public onProgressChanged(Landroid/webkit/WebView;I)V
    .locals 4
    const/16 v0, 0xa
    if-gt p2, v0, :keep_failure
    const/4 v0, 0x0
    iput-boolean v0, p0, Lru/gates/app/LoginChromeClient;->failed:Z
    :keep_failure
    iget-boolean v0, p0, Lru/gates/app/LoginChromeClient;->failed:Z
    if-nez v0, :done
    const/16 v0, 0x64
    if-ge p2, v0, :loaded
    new-instance v1, Ljava/lang/StringBuilder;
    const-string v2, "Загрузка входа SprutHub: "
    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V
    invoke-virtual {v1, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    const-string v2, "% · Нажмите здесь для повтора"
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v1
    goto :show
    :loaded
    const-string v1, "Войдите → откройте нужный замок, дверь или ворота → сохраните привязку. Здесь — перезагрузка"
    :show
    iget-object v0, p0, Lru/gates/app/LoginChromeClient;->status:Landroid/widget/TextView;
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    :done
    return-void
.end method
.method public onConsoleMessage(Landroid/webkit/ConsoleMessage;)Z
    .locals 4
    invoke-virtual {p1}, Landroid/webkit/ConsoleMessage;->message()Ljava/lang/String;
    move-result-object v0
    const-string v1, "GATE_DIAG:"
    invoke-virtual {v0, v1}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z
    move-result v1
    if-eqz v1, :done
    const/4 v1, 0x1
    iput-boolean v1, p0, Lru/gates/app/LoginChromeClient;->failed:Z
    iget-object v1, p0, Lru/gates/app/LoginChromeClient;->status:Landroid/widget/TextView;
    const/16 v2, 0xa
    invoke-virtual {v0, v2}, Ljava/lang/String;->substring(I)Ljava/lang/String;
    move-result-object v0
    invoke-virtual {v1, v0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    :done
    const/4 v0, 0x1
    return v0
.end method
