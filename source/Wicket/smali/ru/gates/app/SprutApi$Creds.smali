.class public Lru/gates/app/SprutApi$Creds;
.super Ljava/lang/Object;
.source "SprutApi.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lru/gates/app/SprutApi;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x9
    name = "Creds"
.end annotation


# instance fields
.field cid:Ljava/lang/String;

.field serial:Ljava/lang/String;

.field token:Ljava/lang/String;

.field command:Ljava/lang/String;


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 24
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method
