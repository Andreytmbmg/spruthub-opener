.class Lru/gates/app/MainActivity$1;
.super Ljava/lang/Object;
.source "MainActivity.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lru/gates/app/MainActivity;->onCreate(Landroid/os/Bundle;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lru/gates/app/MainActivity;


# direct methods
.method constructor <init>(Lru/gates/app/MainActivity;)V
    .locals 0

    .line 46
    iput-object p1, p0, Lru/gates/app/MainActivity$1;->this$0:Lru/gates/app/MainActivity;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static synthetic access$0(Lru/gates/app/MainActivity$1;)Lru/gates/app/MainActivity;
    .locals 0

    .line 46
    iget-object p0, p0, Lru/gates/app/MainActivity$1;->this$0:Lru/gates/app/MainActivity;

    return-object p0
.end method


# virtual methods
.method public run()V
    .locals 5

    .line 49
    iget-object v0, p0, Lru/gates/app/MainActivity$1;->this$0:Lru/gates/app/MainActivity;

    .line 50
    nop

    .line 49
    const/16 v1, 0x0

    const/16 v2, 0x0

    const/16 v3, 0x0

    const/16 v4, 0x0

    invoke-static {v0, v1, v2, v3, v4}, Lru/gates/app/SprutApi;->openGate(Landroid/content/Context;IIII)Lru/gates/app/SprutApi$Result;

    move-result-object v0

    .line 51
    iget-object v1, p0, Lru/gates/app/MainActivity$1;->this$0:Lru/gates/app/MainActivity;

    invoke-static {v1}, Lru/gates/app/MainActivity;->access$0(Lru/gates/app/MainActivity;)Landroid/os/Handler;

    move-result-object v1

    new-instance v2, Lru/gates/app/MainActivity$1$1;

    invoke-direct {v2, p0, v0}, Lru/gates/app/MainActivity$1$1;-><init>(Lru/gates/app/MainActivity$1;Lru/gates/app/SprutApi$Result;)V

    invoke-virtual {v1, v2}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 57
    return-void
.end method
