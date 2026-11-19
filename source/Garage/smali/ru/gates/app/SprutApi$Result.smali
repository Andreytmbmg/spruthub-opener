.class public Lru/gates/app/SprutApi$Result;
.super Ljava/lang/Object;
.source "SprutApi.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lru/gates/app/SprutApi;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x9
    name = "Result"
.end annotation


# instance fields
.field public error:Ljava/lang/String;

.field public ok:Z

.field public opened:Z


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 30
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method
