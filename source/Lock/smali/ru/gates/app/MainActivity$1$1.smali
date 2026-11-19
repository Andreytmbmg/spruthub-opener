.class Lru/gates/app/MainActivity$1$1;
.super Ljava/lang/Object;
.source "MainActivity.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lru/gates/app/MainActivity$1;->run()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$1:Lru/gates/app/MainActivity$1;

.field private final synthetic val$r:Lru/gates/app/SprutApi$Result;


# direct methods
.method constructor <init>(Lru/gates/app/MainActivity$1;Lru/gates/app/SprutApi$Result;)V
    .locals 0

    .line 51
    iput-object p1, p0, Lru/gates/app/MainActivity$1$1;->this$1:Lru/gates/app/MainActivity$1;

    iput-object p2, p0, Lru/gates/app/MainActivity$1$1;->val$r:Lru/gates/app/SprutApi$Result;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 2

    .line 54
    iget-object v0, p0, Lru/gates/app/MainActivity$1$1;->this$1:Lru/gates/app/MainActivity$1;

    invoke-static {v0}, Lru/gates/app/MainActivity$1;->access$0(Lru/gates/app/MainActivity$1;)Lru/gates/app/MainActivity;

    move-result-object v0

    iget-object v1, p0, Lru/gates/app/MainActivity$1$1;->val$r:Lru/gates/app/SprutApi$Result;

    invoke-static {v0, v1}, Lru/gates/app/MainActivity;->access$1(Lru/gates/app/MainActivity;Lru/gates/app/SprutApi$Result;)V

    .line 55
    return-void
.end method
