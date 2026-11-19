.class Lru/gates/app/SprutApi$2;
.super Ljava/lang/Object;
.source "SprutApi.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lru/gates/app/SprutApi;->tryOpen(Lru/gates/app/SprutApi$Creds;IIII)Lru/gates/app/SprutApi$Result;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field private final synthetic val$ws:Lru/gates/app/WsClient;


# direct methods
.method constructor <init>(Lru/gates/app/WsClient;)V
    .locals 0

    .line 240
    iput-object p1, p0, Lru/gates/app/SprutApi$2;->val$ws:Lru/gates/app/WsClient;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 1

    .line 243
    iget-object v0, p0, Lru/gates/app/SprutApi$2;->val$ws:Lru/gates/app/WsClient;

    invoke-virtual {v0}, Lru/gates/app/WsClient;->loop()V

    .line 244
    return-void
.end method
