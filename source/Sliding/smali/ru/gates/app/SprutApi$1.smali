.class Lru/gates/app/SprutApi$1;
.super Ljava/lang/Object;
.source "SprutApi.java"

# interfaces
.implements Lru/gates/app/WsClient$Handler;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lru/gates/app/SprutApi;->tryOpen(Lru/gates/app/SprutApi$Creds;IIII)Lru/gates/app/SprutApi$Result;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field private final synthetic val$incoming:Ljava/util/concurrent/BlockingQueue;


# direct methods
.method constructor <init>(Ljava/util/concurrent/BlockingQueue;)V
    .locals 0

    .line 223
    iput-object p1, p0, Lru/gates/app/SprutApi$1;->val$incoming:Ljava/util/concurrent/BlockingQueue;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClosed()V
    .locals 2

    .line 231
    iget-object v0, p0, Lru/gates/app/SprutApi$1;->val$incoming:Ljava/util/concurrent/BlockingQueue;

    const-string v1, "__CLOSED__"

    invoke-interface {v0, v1}, Ljava/util/concurrent/BlockingQueue;->offer(Ljava/lang/Object;)Z

    .line 232
    return-void
.end method

.method public onMessage(Ljava/lang/String;)V
    .locals 1

    .line 226
    iget-object v0, p0, Lru/gates/app/SprutApi$1;->val$incoming:Ljava/util/concurrent/BlockingQueue;

    invoke-interface {v0, p1}, Ljava/util/concurrent/BlockingQueue;->offer(Ljava/lang/Object;)Z

    .line 227
    return-void
.end method
