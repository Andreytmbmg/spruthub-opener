.class public Lru/gates/app/SprutApi;
.super Ljava/lang/Object;
.source "SprutApi.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lru/gates/app/SprutApi$Creds;,
        Lru/gates/app/SprutApi$Result;
    }
.end annotation


# static fields
.field private static final WS_HOST:Ljava/lang/String; = "beta.spruthub.ru"

.field private static final WS_PATH:Ljava/lang/String; = "/spruthub"


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 19
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static clearCredentials(Landroid/content/Context;)V
    .locals 0

    .line 103
    invoke-static {p0}, Lru/gates/app/SprutApi;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->clear()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 104
    return-void
.end method

.method private static collectStrings(Ljava/lang/Object;Ljava/lang/String;Ljava/util/Set;)V
    .locals 5
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/Object;",
            "Ljava/lang/String;",
            "Ljava/util/Set<",
            "Ljava/lang/String;",
            ">;)V"
        }
    .end annotation

    .line 80
    instance-of v0, p0, Lorg/json/JSONObject;

    const/4 v1, 0x0

    if-eqz v0, :cond_5

    .line 81
    move-object v0, p0

    check-cast v0, Lorg/json/JSONObject;

    .line 82
    invoke-virtual {v0}, Lorg/json/JSONObject;->names()Lorg/json/JSONArray;

    move-result-object v2

    .line 83
    if-nez v2, :cond_0

    return-void

    .line 84
    :cond_0
    nop

    :goto_0
    invoke-virtual {v2}, Lorg/json/JSONArray;->length()I

    move-result p0

    if-lt v1, p0, :cond_1

    .line 93
    goto :goto_5

    .line 85
    :cond_1
    invoke-virtual {v2, v1}, Lorg/json/JSONArray;->optString(I)Ljava/lang/String;

    move-result-object p0

    .line 86
    invoke-virtual {v0, p0}, Lorg/json/JSONObject;->opt(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v3

    .line 87
    invoke-virtual {p1, p0}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result p0

    if-eqz p0, :cond_2

    instance-of p0, v3, Ljava/lang/String;

    if-eqz p0, :cond_2

    move-object p0, v3

    check-cast p0, Ljava/lang/String;

    invoke-virtual {p0}, Ljava/lang/String;->isEmpty()Z

    move-result v4

    if-nez v4, :cond_2

    .line 88
    invoke-interface {p2, p0}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    goto :goto_1

    .line 89
    :cond_2
    instance-of p0, v3, Lorg/json/JSONObject;

    if-nez p0, :cond_4

    instance-of p0, v3, Lorg/json/JSONArray;

    if-eqz p0, :cond_3

    goto :goto_2

    :cond_3
    :goto_1
    goto :goto_3

    .line 90
    :cond_4
    :goto_2
    invoke-static {v3, p1, p2}, Lru/gates/app/SprutApi;->collectStrings(Ljava/lang/Object;Ljava/lang/String;Ljava/util/Set;)V

    .line 84
    :goto_3
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 93
    :cond_5
    instance-of v0, p0, Lorg/json/JSONArray;

    if-eqz v0, :cond_9

    .line 94
    check-cast p0, Lorg/json/JSONArray;

    .line 95
    nop

    :goto_4
    invoke-virtual {p0}, Lorg/json/JSONArray;->length()I

    move-result v0

    if-lt v1, v0, :cond_6

    goto :goto_5

    .line 96
    :cond_6
    invoke-virtual {p0, v1}, Lorg/json/JSONArray;->opt(I)Ljava/lang/Object;

    move-result-object v0

    .line 97
    instance-of v2, v0, Lorg/json/JSONObject;

    if-nez v2, :cond_7

    instance-of v2, v0, Lorg/json/JSONArray;

    if-eqz v2, :cond_8

    :cond_7
    invoke-static {v0, p1, p2}, Lru/gates/app/SprutApi;->collectStrings(Ljava/lang/Object;Ljava/lang/String;Ljava/util/Set;)V

    .line 95
    :cond_8
    add-int/lit8 v1, v1, 0x1

    goto :goto_4

    .line 100
    :cond_9
    :goto_5
    return-void
.end method

.method private static envelope(Lru/gates/app/SprutApi$Creds;ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Lorg/json/JSONObject;)Ljava/lang/String;
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lorg/json/JSONException;
        }
    .end annotation

    .line 316
    new-instance v0, Lorg/json/JSONObject;

    invoke-direct {v0}, Lorg/json/JSONObject;-><init>()V

    .line 317
    const-string v1, "id"

    invoke-virtual {v0, v1, p1}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    .line 318
    iget-object p1, p0, Lru/gates/app/SprutApi$Creds;->token:Ljava/lang/String;

    if-eqz p1, :cond_0

    iget-object p1, p0, Lru/gates/app/SprutApi$Creds;->token:Ljava/lang/String;

    goto :goto_0

    :cond_0
    sget-object p1, Lorg/json/JSONObject;->NULL:Ljava/lang/Object;

    :goto_0
    const-string v1, "token"

    invoke-virtual {v0, v1, p1}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 319
    iget-object p1, p0, Lru/gates/app/SprutApi$Creds;->cid:Ljava/lang/String;

    if-eqz p1, :cond_1

    const-string p1, "cid"

    iget-object v1, p0, Lru/gates/app/SprutApi$Creds;->cid:Ljava/lang/String;

    invoke-virtual {v0, p1, v1}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 320
    :cond_1
    iget-object p1, p0, Lru/gates/app/SprutApi$Creds;->serial:Ljava/lang/String;

    if-eqz p1, :cond_2

    const-string p1, "serial"

    iget-object p0, p0, Lru/gates/app/SprutApi$Creds;->serial:Ljava/lang/String;

    invoke-virtual {v0, p1, p0}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 321
    :cond_2
    const-string p0, "method"

    invoke-virtual {v0, p0, p2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 322
    new-instance p0, Lorg/json/JSONObject;

    invoke-direct {p0}, Lorg/json/JSONObject;-><init>()V

    .line 323
    invoke-virtual {p0, p4, p5}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 324
    new-instance p1, Lorg/json/JSONObject;

    invoke-direct {p1}, Lorg/json/JSONObject;-><init>()V

    .line 325
    invoke-virtual {p1, p3, p0}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 326
    const-string p0, "params"

    invoke-virtual {v0, p0, p1}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 327
    invoke-virtual {v0}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static findIntValue(Ljava/lang/Object;)I
    .locals 5

    .line 352
    instance-of v0, p0, Lorg/json/JSONObject;

    const/4 v1, -0x1

    if-eqz v0, :cond_3

    .line 353
    check-cast p0, Lorg/json/JSONObject;

    .line 354
    const-string v0, "intValue"

    invoke-virtual {p0, v0}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z

    move-result v2

    if-eqz v2, :cond_0

    invoke-virtual {p0, v0, v1}, Lorg/json/JSONObject;->optInt(Ljava/lang/String;I)I

    move-result p0

    return p0

    .line 355
    :cond_0
    invoke-virtual {p0}, Lorg/json/JSONObject;->names()Lorg/json/JSONArray;

    move-result-object v0

    .line 356
    if-eqz v0, :cond_3

    .line 357
    const/4 v2, 0x0

    :goto_0
    invoke-virtual {v0}, Lorg/json/JSONArray;->length()I

    move-result v3

    if-lt v2, v3, :cond_1

    goto :goto_1

    .line 358
    :cond_1
    invoke-virtual {v0, v2}, Lorg/json/JSONArray;->optString(I)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {p0, v3}, Lorg/json/JSONObject;->opt(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v3

    .line 359
    instance-of v4, v3, Lorg/json/JSONObject;

    if-eqz v4, :cond_2

    .line 360
    invoke-static {v3}, Lru/gates/app/SprutApi;->findIntValue(Ljava/lang/Object;)I

    move-result v3

    .line 361
    if-ltz v3, :cond_2

    return v3

    .line 357
    :cond_2
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 366
    :cond_3
    :goto_1
    return v1
.end method

.method private static findString(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/String;
    .locals 6

    .line 107
    instance-of v0, p0, Lorg/json/JSONObject;

    const/4 v1, 0x0

    const/4 v2, 0x0

    if-eqz v0, :cond_5

    .line 108
    move-object v0, p0

    check-cast v0, Lorg/json/JSONObject;

    .line 109
    invoke-virtual {v0}, Lorg/json/JSONObject;->names()Lorg/json/JSONArray;

    move-result-object v3

    .line 110
    if-nez v3, :cond_0

    return-object v2

    .line 111
    :cond_0
    nop

    :goto_0
    invoke-virtual {v3}, Lorg/json/JSONArray;->length()I

    move-result p0

    if-lt v1, p0, :cond_1

    .line 122
    goto :goto_2

    .line 112
    :cond_1
    invoke-virtual {v3, v1}, Lorg/json/JSONArray;->optString(I)Ljava/lang/String;

    move-result-object p0

    .line 113
    invoke-virtual {v0, p0}, Lorg/json/JSONObject;->opt(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v4

    .line 114
    invoke-virtual {p1, p0}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result p0

    if-eqz p0, :cond_2

    instance-of p0, v4, Ljava/lang/String;

    if-eqz p0, :cond_2

    move-object p0, v4

    check-cast p0, Ljava/lang/String;

    invoke-virtual {p0}, Ljava/lang/String;->isEmpty()Z

    move-result v5

    if-nez v5, :cond_2

    .line 115
    return-object p0

    .line 117
    :cond_2
    instance-of p0, v4, Lorg/json/JSONObject;

    if-nez p0, :cond_3

    instance-of p0, v4, Lorg/json/JSONArray;

    if-eqz p0, :cond_4

    .line 118
    :cond_3
    invoke-static {v4, p1}, Lru/gates/app/SprutApi;->findString(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    .line 119
    if-eqz p0, :cond_4

    return-object p0

    .line 111
    :cond_4
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 122
    :cond_5
    instance-of v0, p0, Lorg/json/JSONArray;

    if-eqz v0, :cond_9

    .line 123
    check-cast p0, Lorg/json/JSONArray;

    .line 124
    nop

    :goto_1
    invoke-virtual {p0}, Lorg/json/JSONArray;->length()I

    move-result v0

    if-lt v1, v0, :cond_6

    goto :goto_2

    .line 125
    :cond_6
    invoke-virtual {p0, v1}, Lorg/json/JSONArray;->opt(I)Ljava/lang/Object;

    move-result-object v0

    .line 126
    instance-of v3, v0, Lorg/json/JSONObject;

    if-nez v3, :cond_7

    instance-of v3, v0, Lorg/json/JSONArray;

    if-eqz v3, :cond_8

    .line 127
    :cond_7
    invoke-static {v0, p1}, Lru/gates/app/SprutApi;->findString(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 128
    if-eqz v0, :cond_8

    return-object v0

    .line 124
    :cond_8
    add-int/lit8 v1, v1, 0x1

    goto :goto_1

    .line 132
    :cond_9
    :goto_2
    return-object v2
.end method

.method public static hasCredentials(Landroid/content/Context;)Z
    .locals 4
    invoke-static {p0}, Lru/gates/app/SprutApi;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;
    move-result-object v0
    const/4 v2, 0x0
    const-string v1, "setup_v21"
    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v3
    if-eqz v3, :invalid
    const-string v1, "gateCommand"
    const-string v3, ""
    invoke-interface {v0, v1, v3}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v1
    invoke-virtual {v1}, Ljava/lang/String;->isEmpty()Z
    move-result v1
    if-nez v1, :invalid
    const-string v1, "serial"
    const-string v3, ""
    invoke-interface {v0, v1, v3}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v1
    invoke-virtual {v1}, Ljava/lang/String;->isEmpty()Z
    move-result v1
    if-nez v1, :invalid
    const-string v1, "token"
    invoke-interface {v0, v1, v3}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v1
    invoke-virtual {v1}, Ljava/lang/String;->isEmpty()Z
    move-result v1
    if-nez v1, :invalid
    const/4 v2, 0x1
    :invalid
    return v2
.end method

.method public static openGate(Landroid/content/Context;IIII)Lru/gates/app/SprutApi$Result;
    .locals 1

    .line 141
    new-instance v0, Lru/gates/app/SprutApi$Result;

    invoke-direct {v0}, Lru/gates/app/SprutApi$Result;-><init>()V

    .line 143
    :try_start_0
    invoke-static {p0, p1, p2, p3, p4}, Lru/gates/app/SprutApi;->openGateInternal(Landroid/content/Context;IIII)Lru/gates/app/SprutApi$Result;

    move-result-object v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 144
    goto :goto_0

    :catchall_0
    move-exception p0

    .line 145
    const/4 p0, 0x0

    iput-boolean p0, v0, Lru/gates/app/SprutApi$Result;->ok:Z

    .line 146
    const-string p0, "\u0421\u0431\u043e\u0439 \u0441\u0432\u044f\u0437\u0438"

    iput-object p0, v0, Lru/gates/app/SprutApi$Result;->error:Ljava/lang/String;

    .line 148
    :goto_0
    return-object v0
.end method

.method private static openGateInternal(Landroid/content/Context;IIII)Lru/gates/app/SprutApi$Result;
    .locals 4
    new-instance v0, Lru/gates/app/SprutApi$Creds;
    invoke-direct {v0}, Lru/gates/app/SprutApi$Creds;-><init>()V
    invoke-static {p0}, Lru/gates/app/SprutApi;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;
    move-result-object v1
    const-string v2, "token"
    const/4 v3, 0x0
    invoke-interface {v1, v2, v3}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    iput-object v2, v0, Lru/gates/app/SprutApi$Creds;->token:Ljava/lang/String;
    const-string v2, "gateCommand"
    invoke-interface {v1, v2, v3}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    iput-object v2, v0, Lru/gates/app/SprutApi$Creds;->command:Ljava/lang/String;
    const-string v2, "cid"
    invoke-interface {v1, v2, v3}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    iput-object v2, v0, Lru/gates/app/SprutApi$Creds;->cid:Ljava/lang/String;
    const-string v2, "serial"
    invoke-interface {v1, v2, v3}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    iput-object v2, v0, Lru/gates/app/SprutApi$Creds;->serial:Ljava/lang/String;
    invoke-static {v0, p1, p2, p3, p4}, Lru/gates/app/SprutApi;->tryOpen(Lru/gates/app/SprutApi$Creds;IIII)Lru/gates/app/SprutApi$Result;
    move-result-object v0
    return-object v0
.end method

.method private static prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;
    .locals 2

    .line 37
    const-string v0, "auth"

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p0

    return-object p0
.end method

.method public static saveFromWeb(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 7

    .line 46
    const-string v0, "cid"

    const-string v1, "token"

    new-instance v2, Lru/gates/app/SprutApi$Creds;

    invoke-direct {v2}, Lru/gates/app/SprutApi$Creds;-><init>()V

    .line 48
    :try_start_0
    new-instance v3, Lorg/json/JSONObject;

    invoke-direct {v3, p1}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V
    const-string v4, "gateCommand"
    invoke-virtual {v3, v4}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v5
    invoke-static {p0}, Lru/gates/app/SprutApi;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;
    move-result-object v6
    invoke-interface {v6}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v6
    invoke-interface {v6, v4, v5}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;
    invoke-interface {v6}, Landroid/content/SharedPreferences$Editor;->apply()V



    .line 49
    invoke-static {v3, v1}, Lru/gates/app/SprutApi;->findString(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    iput-object p1, v2, Lru/gates/app/SprutApi$Creds;->token:Ljava/lang/String;

    .line 50
    invoke-static {v3, v0}, Lru/gates/app/SprutApi;->findString(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    iput-object p1, v2, Lru/gates/app/SprutApi$Creds;->cid:Ljava/lang/String;
    :try_end_0
    .catch Lorg/json/JSONException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 51
    :catch_0
    move-exception p1

    :goto_0
    nop

    .line 55
    if-eqz p3, :cond_0

    .line 56
    :try_start_1
    new-instance p1, Lorg/json/JSONObject;

    invoke-direct {p1, p3}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    .line 57
    const-string p3, "lastHubSerial"

    invoke-static {p1, p3}, Lru/gates/app/SprutApi;->findString(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    iput-object p1, v2, Lru/gates/app/SprutApi$Creds;->serial:Ljava/lang/String;
    :try_end_1
    .catch Lorg/json/JSONException; {:try_start_1 .. :try_end_1} :catch_1

    goto :goto_1

    .line 59
    :catch_1
    move-exception p1

    :goto_1
    nop

    .line 61
    :cond_0
    new-instance p1, Ljava/util/LinkedHashSet;

    invoke-direct {p1}, Ljava/util/LinkedHashSet;-><init>()V

    .line 62
    iget-object p3, v2, Lru/gates/app/SprutApi$Creds;->serial:Ljava/lang/String;

    if-eqz p3, :cond_1

    iget-object p3, v2, Lru/gates/app/SprutApi$Creds;->serial:Ljava/lang/String;

    invoke-virtual {p1, p3}, Ljava/util/LinkedHashSet;->add(Ljava/lang/Object;)Z

    .line 64
    :cond_1
    const-string p3, "serial"

    if-eqz p2, :cond_2

    .line 65
    :try_start_2
    new-instance v3, Lorg/json/JSONObject;

    invoke-direct {v3, p2}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    invoke-static {v3, p3, p1}, Lru/gates/app/SprutApi;->collectStrings(Ljava/lang/Object;Ljava/lang/String;Ljava/util/Set;)V
    :try_end_2
    .catch Lorg/json/JSONException; {:try_start_2 .. :try_end_2} :catch_2

    goto :goto_2

    .line 67
    :catch_2
    move-exception p2

    :goto_2
    nop

    .line 69
    :cond_2
    iget-object p2, v2, Lru/gates/app/SprutApi$Creds;->token:Ljava/lang/String;

    if-eqz p2, :cond_5

    iget-object p2, v2, Lru/gates/app/SprutApi$Creds;->token:Ljava/lang/String;

    invoke-virtual {p2}, Ljava/lang/String;->isEmpty()Z

    move-result p2

    if-nez p2, :cond_5

    .line 70
    invoke-static {p0}, Lru/gates/app/SprutApi;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 71
    iget-object p2, v2, Lru/gates/app/SprutApi$Creds;->token:Ljava/lang/String;

    invoke-interface {p0, v1, p2}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    .line 72
    iget-object p2, v2, Lru/gates/app/SprutApi$Creds;->cid:Ljava/lang/String;

    if-eqz p2, :cond_3

    iget-object p2, v2, Lru/gates/app/SprutApi$Creds;->cid:Ljava/lang/String;

    invoke-interface {p0, v0, p2}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    .line 73
    :cond_3
    iget-object p2, v2, Lru/gates/app/SprutApi$Creds;->serial:Ljava/lang/String;

    if-eqz p2, :cond_4

    iget-object p2, v2, Lru/gates/app/SprutApi$Creds;->serial:Ljava/lang/String;

    goto :goto_3

    :cond_4
    const-string p2, ""

    :goto_3
    invoke-interface {p0, p3, p2}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    .line 74
    const-string p2, "serials"

    invoke-interface {p0, p2, p1}, Landroid/content/SharedPreferences$Editor;->putStringSet(Ljava/lang/String;Ljava/util/Set;)Landroid/content/SharedPreferences$Editor;

    const-string p2, "setup_v21"
    const/4 p3, 0x1
    invoke-interface {p0, p2, p3}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;
    .line 75
    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 77
    :cond_5
    return-void
.end method

.method private static tryOpen(Lru/gates/app/SprutApi$Creds;IIII)Lru/gates/app/SprutApi$Result;
    .locals 21
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lorg/json/JSONException;,
            Ljava/io/IOException;
        }
    .end annotation

    .line 217
    move/from16 v0, p1

    move/from16 v1, p2

    const-string v2, "cId"

    const-string v3, "sId"

    const-string v4, "aId"

    const-string v5, "error"

    new-instance v6, Lru/gates/app/SprutApi$Result;

    invoke-direct {v6}, Lru/gates/app/SprutApi$Result;-><init>()V

    .line 219
    new-instance v7, Ljava/util/concurrent/ArrayBlockingQueue;

    const/16 v8, 0x40

    invoke-direct {v7, v8}, Ljava/util/concurrent/ArrayBlockingQueue;-><init>(I)V

    .line 220
    new-instance v8, Ljava/util/concurrent/atomic/AtomicInteger;

    const/4 v9, 0x0

    invoke-direct {v8, v9}, Ljava/util/concurrent/atomic/AtomicInteger;-><init>(I)V

    .line 223
    :try_start_0
    new-instance v10, Lru/gates/app/WsClient;

    const-string v11, "beta.spruthub.ru"

    const-string v12, "/spruthub"

    new-instance v13, Lru/gates/app/SprutApi$1;

    invoke-direct {v13, v7}, Lru/gates/app/SprutApi$1;-><init>(Ljava/util/concurrent/BlockingQueue;)V

    const/16 v14, 0x1bb

    invoke-direct {v10, v11, v14, v12, v13}, Lru/gates/app/WsClient;-><init>(Ljava/lang/String;ILjava/lang/String;Lru/gates/app/WsClient$Handler;)V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_1

    .line 234
    nop

    .line 240
    new-instance v11, Ljava/lang/Thread;

    new-instance v12, Lru/gates/app/SprutApi$2;

    invoke-direct {v12, v10}, Lru/gates/app/SprutApi$2;-><init>(Lru/gates/app/WsClient;)V

    .line 245
    nop

    .line 240
    const-string v13, "ws-reader"

    invoke-direct {v11, v12, v13}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;Ljava/lang/String;)V

    .line 245
    invoke-virtual {v11}, Ljava/lang/Thread;->start()V

    .line 249
    :try_start_1
    invoke-virtual {v8}, Ljava/util/concurrent/atomic/AtomicInteger;->incrementAndGet()I

    move-result v11

    .line 250
    move-object/from16 v14, p0
    iget-object v13, v14, Lru/gates/app/SprutApi$Creds;->command:Ljava/lang/String;
    new-instance v12, Lorg/json/JSONObject;
    invoke-direct {v12, v13}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V
    const-string v16, "characteristic.update"

    const-string v17, "characteristic"

    const-string v18, "update"

    move-object/from16 v14, p0

    move v15, v11

    move-object/from16 v19, v12

    invoke-static/range {v14 .. v19}, Lru/gates/app/SprutApi;->envelope(Lru/gates/app/SprutApi$Creds;ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Lorg/json/JSONObject;)Ljava/lang/String;

    move-result-object v12

    invoke-virtual {v10, v12}, Lru/gates/app/WsClient;->sendText(Ljava/lang/String;)V

    .line 261
    const-wide/16 v12, 0x3a98

    invoke-static {v7, v11, v12, v13}, Lru/gates/app/SprutApi;->waitForId(Ljava/util/concurrent/BlockingQueue;IJ)Ljava/lang/String;

    move-result-object v11

    .line 262
    if-nez v11, :cond_0

    .line 263
    const-string v0, "\u0421\u0435\u0440\u0432\u0435\u0440 \u043d\u0435 \u043e\u0442\u0432\u0435\u0442\u0438\u043b \u043d\u0430 \u043a\u043e\u043c\u0430\u043d\u0434\u0443"

    iput-object v0, v6, Lru/gates/app/SprutApi$Result;->error:Ljava/lang/String;
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 264
    nop

    .line 311
    invoke-virtual {v10}, Lru/gates/app/WsClient;->close()V

    .line 264
    return-object v6

    .line 266
    :cond_0
    :try_start_2
    new-instance v12, Lorg/json/JSONObject;

    invoke-direct {v12, v11}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    .line 267
    invoke-virtual {v12, v5}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z

    move-result v11

    if-eqz v11, :cond_4

    .line 268
    invoke-virtual {v12, v5}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v0

    .line 269
    if-eqz v0, :cond_1

    const-string v1, "message"

    new-instance v2, Ljava/lang/StringBuilder;

    const-string v3, "\u043a\u043e\u0434 "

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-string v3, "code"

    invoke-virtual {v0, v3}, Lorg/json/JSONObject;->optInt(Ljava/lang/String;)I

    move-result v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    goto :goto_0

    :cond_1
    const-string v0, "unknown"

    .line 270
    :goto_0
    invoke-virtual {v0}, Ljava/lang/String;->toLowerCase()Ljava/lang/String;

    move-result-object v1

    const-string v2, "token"

    invoke-virtual {v1, v2}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_3

    const-string v1, "denied"

    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :cond_2

    goto :goto_1

    .line 273
    :cond_2
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "\u041e\u0448\u0438\u0431\u043a\u0430: "

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, v6, Lru/gates/app/SprutApi$Result;->error:Ljava/lang/String;

    goto :goto_2

    .line 271
    :cond_3
    :goto_1
    const-string v0, "\u0422\u0440\u0435\u0431\u0443\u0435\u0442\u0441\u044f \u043f\u043e\u0432\u0442\u043e\u0440\u043d\u044b\u0439 \u0432\u0445\u043e\u0434"

    iput-object v0, v6, Lru/gates/app/SprutApi$Result;->error:Ljava/lang/String;
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    .line 272
    nop

    .line 275
    :goto_2
    nop

    .line 311
    invoke-virtual {v10}, Lru/gates/app/WsClient;->close()V

    .line 275
    return-object v6

    :cond_4
    :try_start_3
    const-string v0, "result"
    invoke-virtual {v12, v0}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z
    move-result v0
    if-eqz v0, :missing_result
    const/4 v1, 0x1
    iput-boolean v1, v6, Lru/gates/app/SprutApi$Result;->ok:Z
    const/4 v1, 0x0
    iput-boolean v1, v6, Lru/gates/app/SprutApi$Result;->opened:Z
    goto :accepted_done
    :missing_result
    const-string v0, "Нет подтверждения команды от SprutHub"
    iput-object v0, v6, Lru/gates/app/SprutApi$Result;->error:Ljava/lang/String;
    :accepted_done
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_0
    invoke-virtual {v10}, Lru/gates/app/WsClient;->close()V
    return-object v6

    .line 310
    :catchall_0
    move-exception v0

    .line 311
    invoke-virtual {v10}, Lru/gates/app/WsClient;->close()V

    .line 312
    throw v0

    .line 234
    :catch_1
    move-exception v0

    .line 235
    const-string v0, "\u041d\u0435\u0442 \u0441\u0432\u044f\u0437\u0438 \u0441 \u0441\u0435\u0440\u0432\u0435\u0440\u043e\u043c"

    iput-object v0, v6, Lru/gates/app/SprutApi$Result;->error:Ljava/lang/String;

    .line 236
    return-object v6
.end method

.method private static waitForId(Ljava/util/concurrent/BlockingQueue;IJ)Ljava/lang/String;
    .locals 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/concurrent/BlockingQueue<",
            "Ljava/lang/String;",
            ">;IJ)",
            "Ljava/lang/String;"
        }
    .end annotation

    .line 331
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    add-long/2addr v0, p2

    .line 332
    nop

    :cond_0
    :goto_0
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide p2

    cmp-long p2, p2, v0

    const/4 p3, 0x0

    if-ltz p2, :cond_1

    .line 347
    return-object p3

    .line 335
    :cond_1
    :try_start_0
    sget-object p2, Ljava/util/concurrent/TimeUnit;->MILLISECONDS:Ljava/util/concurrent/TimeUnit;

    const-wide/16 v2, 0x3e8

    invoke-interface {p0, v2, v3, p2}, Ljava/util/concurrent/BlockingQueue;->poll(JLjava/util/concurrent/TimeUnit;)Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Ljava/lang/String;
    :try_end_0
    .catch Ljava/lang/InterruptedException; {:try_start_0 .. :try_end_0} :catch_1

    .line 336
    nop

    .line 339
    if-nez p2, :cond_2

    goto :goto_0

    .line 340
    :cond_2
    const-string v2, "__CLOSED__"

    invoke-virtual {v2, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_3

    return-object p3

    .line 342
    :cond_3
    :try_start_1
    new-instance p3, Lorg/json/JSONObject;

    invoke-direct {p3, p2}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    .line 343
    const-string v2, "id"

    const/4 v3, -0x1

    invoke-virtual {p3, v2, v3}, Lorg/json/JSONObject;->optInt(Ljava/lang/String;I)I

    move-result p3
    :try_end_1
    .catch Lorg/json/JSONException; {:try_start_1 .. :try_end_1} :catch_0

    if-ne p3, p1, :cond_0

    return-object p2

    .line 344
    :catch_0
    move-exception p2

    goto :goto_0

    .line 336
    :catch_1
    move-exception p0

    .line 337
    return-object p3
.end method

.method public static resetBinding(Landroid/content/Context;)V
    .locals 2
    invoke-static {p0}, Lru/gates/app/SprutApi;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;
    move-result-object v0
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v0
    const-string v1, "gateCommand"
    invoke-interface {v0, v1}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;
    const-string v1, "gateAid"
    invoke-interface {v0, v1}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;
    const-string v1, "serial"
    invoke-interface {v0, v1}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;
    const-string v1, "serials"
    invoke-interface {v0, v1}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;
    const-string v1, "setup_v21"
    invoke-interface {v0, v1}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;
    const-string v1, "setup_v13"
    invoke-interface {v0, v1}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;
    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V
    return-void
.end method
