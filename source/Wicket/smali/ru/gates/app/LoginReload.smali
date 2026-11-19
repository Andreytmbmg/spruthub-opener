.class public Lru/gates/app/LoginReload;
.super Ljava/lang/Object;
.implements Landroid/view/View$OnClickListener;
.field private web:Landroid/webkit/WebView;
.method public constructor <init>(Landroid/webkit/WebView;)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lru/gates/app/LoginReload;->web:Landroid/webkit/WebView;
    return-void
.end method
.method public onClick(Landroid/view/View;)V
    .locals 2
    iget-object v0, p0, Lru/gates/app/LoginReload;->web:Landroid/webkit/WebView;
    const/4 v1, 0x1
    invoke-virtual {v0, v1}, Landroid/webkit/WebView;->clearCache(Z)V
    invoke-virtual {v0}, Landroid/webkit/WebView;->reload()V
    return-void
.end method
