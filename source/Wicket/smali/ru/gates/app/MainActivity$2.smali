.class Lru/gates/app/MainActivity$2;
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

    .line 61
    iput-object p1, p0, Lru/gates/app/MainActivity$2;->this$0:Lru/gates/app/MainActivity;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 2

    .line 64
    iget-object v0, p0, Lru/gates/app/MainActivity$2;->this$0:Lru/gates/app/MainActivity;

    invoke-static {v0}, Lru/gates/app/MainActivity;->access$2(Lru/gates/app/MainActivity;)Z

    move-result v0

    if-nez v0, :cond_0

    .line 65
    new-instance v0, Lru/gates/app/SprutApi$Result;

    invoke-direct {v0}, Lru/gates/app/SprutApi$Result;-><init>()V

    .line 66
    const/4 v1, 0x0

    iput-boolean v1, v0, Lru/gates/app/SprutApi$Result;->ok:Z

    .line 67
    const-string v1, "\u0422\u0430\u0439\u043c\u0430\u0443\u0442 \u0441\u043e\u0435\u0434\u0438\u043d\u0435\u043d\u0438\u044f"

    iput-object v1, v0, Lru/gates/app/SprutApi$Result;->error:Ljava/lang/String;

    .line 68
    iget-object v1, p0, Lru/gates/app/MainActivity$2;->this$0:Lru/gates/app/MainActivity;

    invoke-static {v1, v0}, Lru/gates/app/MainActivity;->access$1(Lru/gates/app/MainActivity;Lru/gates/app/SprutApi$Result;)V

    .line 70
    :cond_0
    return-void
.end method
