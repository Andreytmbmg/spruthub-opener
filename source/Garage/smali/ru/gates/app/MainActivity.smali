.class public Lru/gates/app/MainActivity;
.super Landroid/app/Activity;
.source "MainActivity.java"


# static fields
.field private static final WATCHDOG_MS:J = 0xd6d8L


# instance fields
.field private card:Landroid/widget/LinearLayout;

.field private finished:Z

.field private final handler:Landroid/os/Handler;

.field private resultShown:Z


# direct methods
.method public static synthetic $r8$lambda$6c7ZdceJPXBG_TmXtAaYmQRBrhc(Lru/gates/app/MainActivity;)V
    .locals 0

    invoke-direct {p0}, Lru/gates/app/MainActivity;->finishNow()V

    return-void
.end method

.method public constructor <init>()V
    .locals 2

    .line 22
    invoke-direct {p0}, Landroid/app/Activity;-><init>()V

    .line 26
    new-instance v0, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    iput-object v0, p0, Lru/gates/app/MainActivity;->handler:Landroid/os/Handler;

    .line 28
    const/4 v0, 0x0

    iput-boolean v0, p0, Lru/gates/app/MainActivity;->finished:Z

    .line 29
    iput-boolean v0, p0, Lru/gates/app/MainActivity;->resultShown:Z

    .line 22
    return-void
.end method

.method static synthetic access$0(Lru/gates/app/MainActivity;)Landroid/os/Handler;
    .locals 0

    .line 26
    iget-object p0, p0, Lru/gates/app/MainActivity;->handler:Landroid/os/Handler;

    return-object p0
.end method

.method static synthetic access$1(Lru/gates/app/MainActivity;Lru/gates/app/SprutApi$Result;)V
    .locals 0

    .line 74
    invoke-direct {p0, p1}, Lru/gates/app/MainActivity;->showResult(Lru/gates/app/SprutApi$Result;)V

    return-void
.end method

.method static synthetic access$2(Lru/gates/app/MainActivity;)Z
    .locals 0

    .line 29
    iget-boolean p0, p0, Lru/gates/app/MainActivity;->resultShown:Z

    return p0
.end method

.method private buildUi()V
    .locals 5
    new-instance v0, Landroid/widget/FrameLayout;
    invoke-direct {v0, p0}, Landroid/widget/FrameLayout;-><init>(Landroid/content/Context;)V
    const/4 v1, 0x0
    invoke-virtual {v0, v1}, Landroid/widget/FrameLayout;->setBackgroundColor(I)V
    new-instance v1, Landroid/widget/LinearLayout;
    invoke-direct {v1, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    iput-object v1, p0, Lru/gates/app/MainActivity;->card:Landroid/widget/LinearLayout;
    const/4 v2, 0x1
    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->setOrientation(I)V
    invoke-virtual {p0}, Lru/gates/app/MainActivity;->getResources()Landroid/content/res/Resources;
    move-result-object v2
    invoke-virtual {v2}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;
    move-result-object v2
    iget v2, v2, Landroid/util/DisplayMetrics;->widthPixels:I
    const/16 v3, 0x30
    invoke-direct {p0, v3}, Lru/gates/app/MainActivity;->dp(I)I
    move-result v3
    sub-int/2addr v2, v3
    const/16 v3, 0x280
    invoke-direct {p0, v3}, Lru/gates/app/MainActivity;->dp(I)I
    move-result v3
    invoke-static {v2, v3}, Ljava/lang/Math;->min(II)I
    move-result v2
    new-instance v3, Landroid/widget/FrameLayout$LayoutParams;
    const/4 v4, -0x2
    invoke-direct {v3, v2, v4}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V
    const/16 v2, 0x11
    iput v2, v3, Landroid/widget/FrameLayout$LayoutParams;->gravity:I
    invoke-virtual {v0, v1, v3}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V
    invoke-virtual {p0, v0}, Lru/gates/app/MainActivity;->setContentView(Landroid/view/View;)V
    return-void
.end method

.method private dp(I)I
    .locals 2

    .line 161
    int-to-float p1, p1

    invoke-virtual {p0}, Lru/gates/app/MainActivity;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v0

    const/4 v1, 0x1

    invoke-static {v1, p1, v0}, Landroid/util/TypedValue;->applyDimension(IFLandroid/util/DisplayMetrics;)F

    move-result p1

    float-to-int p1, p1

    return p1
.end method

.method private declared-synchronized finishNow()V
    .locals 1

    monitor-enter p0

    .line 155
    :try_start_0
    iget-boolean v0, p0, Lru/gates/app/MainActivity;->finished:Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-eqz v0, :cond_0

    monitor-exit p0

    return-void

    .line 156
    :cond_0
    const/4 v0, 0x1

    :try_start_1
    iput-boolean v0, p0, Lru/gates/app/MainActivity;->finished:Z

    .line 157
    invoke-virtual {p0}, Lru/gates/app/MainActivity;->finish()V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 158
    monitor-exit p0

    return-void

    .line 154
    :catchall_0
    move-exception v0

    monitor-exit p0

    throw v0
.end method

.method private finishSoon(J)V
    .locals 2

    .line 151
    iget-object v0, p0, Lru/gates/app/MainActivity;->handler:Landroid/os/Handler;

    new-instance v1, Lru/gates/app/MainActivity$$ExternalSyntheticLambda0;

    invoke-direct {v1, p0}, Lru/gates/app/MainActivity$$ExternalSyntheticLambda0;-><init>(Lru/gates/app/MainActivity;)V

    invoke-virtual {v0, v1, p1, p2}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 152
    return-void
.end method

.method private showCard(ZLjava/lang/String;Ljava/lang/String;Z)V
    .locals 8
    iget-object v0, p0, Lru/gates/app/MainActivity;->card:Landroid/widget/LinearLayout;
    if-eqz v0, :done
    invoke-virtual {v0}, Landroid/widget/LinearLayout;->removeAllViews()V
    const-string v1, "confirmation"
    const-string v2, "layout"
    invoke-direct {p0, v1, v2}, Lru/gates/app/MainActivity;->resource(Ljava/lang/String;Ljava/lang/String;)I
    move-result v1
    invoke-virtual {p0}, Lru/gates/app/MainActivity;->getLayoutInflater()Landroid/view/LayoutInflater;
    move-result-object v2
    const/4 v3, 0x0
    invoke-virtual {v2, v1, v0, v3}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;Z)Landroid/view/View;
    move-result-object v2
    invoke-virtual {v0, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V
    const-string v1, "confirmation_title"
    const-string v3, "id"
    invoke-direct {p0, v1, v3}, Lru/gates/app/MainActivity;->resource(Ljava/lang/String;Ljava/lang/String;)I
    move-result v1
    invoke-virtual {v2, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v4
    check-cast v4, Landroid/widget/TextView;
    invoke-virtual {v4, p2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const-string v1, "confirmation_message"
    invoke-direct {p0, v1, v3}, Lru/gates/app/MainActivity;->resource(Ljava/lang/String;Ljava/lang/String;)I
    move-result v1
    invoke-virtual {v2, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v4
    check-cast v4, Landroid/widget/TextView;
    invoke-virtual {v4, p3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const-string v1, "reset_binding"
    invoke-direct {p0, v1, v3}, Lru/gates/app/MainActivity;->resource(Ljava/lang/String;Ljava/lang/String;)I
    move-result v1
    invoke-virtual {v2, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v5
    new-instance v6, Lru/gates/app/ResetBindingClick;
    invoke-direct {v6, p0}, Lru/gates/app/ResetBindingClick;-><init>(Lru/gates/app/MainActivity;)V
    invoke-virtual {v5, v6}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    if-nez p1, :done
    const-string v1, "#EF5350"
    invoke-static {v1}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I
    move-result v1
    invoke-virtual {v4, v1}, Landroid/widget/TextView;->setTextColor(I)V
    const-string v1, "confirmation_status_icon"
    invoke-direct {p0, v1, v3}, Lru/gates/app/MainActivity;->resource(Ljava/lang/String;Ljava/lang/String;)I
    move-result v1
    invoke-virtual {v2, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v4
    check-cast v4, Landroid/widget/ImageView;
    const-string v1, "confirmation_error"
    const-string v3, "drawable"
    invoke-direct {p0, v1, v3}, Lru/gates/app/MainActivity;->resource(Ljava/lang/String;Ljava/lang/String;)I
    move-result v1
    invoke-virtual {v4, v1}, Landroid/widget/ImageView;->setImageResource(I)V
    :done
    return-void
.end method

.method private showResult(Lru/gates/app/SprutApi$Result;)V
    .locals 4

    .line 75
    iget-boolean v0, p0, Lru/gates/app/MainActivity;->resultShown:Z

    if-eqz v0, :cond_0

    return-void

    .line 76
    :cond_0
    const/4 v0, 0x1

    iput-boolean v0, p0, Lru/gates/app/MainActivity;->resultShown:Z

    .line 77
    iget-boolean v1, p1, Lru/gates/app/SprutApi$Result;->ok:Z

    const-string v2, "Ворота открыты"

    const/4 v3, 0x0

    if-eqz v1, :cond_1

    iget-boolean v1, p1, Lru/gates/app/SprutApi$Result;->opened:Z

    if-eqz v1, :cond_1

    .line 78
    nop

    .line 79
    nop

    .line 78
    const-string p1, "\u0423\u0441\u0442\u0440\u043e\u0439\u0441\u0442\u0432\u043e \u043f\u043e\u0434\u0442\u0432\u0435\u0440\u0434\u0438\u043b\u043e \u043a\u043e\u043c\u0430\u043d\u0434\u0443"

    invoke-direct {p0, v0, v2, p1, v3}, Lru/gates/app/MainActivity;->showCard(ZLjava/lang/String;Ljava/lang/String;Z)V

    .line 80
    goto :goto_1

    :cond_1
    iget-boolean v1, p1, Lru/gates/app/SprutApi$Result;->ok:Z

    if-eqz v1, :cond_2

    .line 81
    nop

    .line 82
    nop

    .line 81
    const-string p1, "SprutHub принял команду"

    invoke-direct {p0, v0, v2, p1, v3}, Lru/gates/app/MainActivity;->showCard(ZLjava/lang/String;Ljava/lang/String;Z)V

    .line 83
    goto :goto_1

    .line 84
    :cond_2
    iget-object v0, p1, Lru/gates/app/SprutApi$Result;->error:Ljava/lang/String;

    if-eqz v0, :cond_3

    iget-object p1, p1, Lru/gates/app/SprutApi$Result;->error:Ljava/lang/String;

    goto :goto_0

    :cond_3
    const-string p1, "\u041e\u0448\u0438\u0431\u043a\u0430"

    :goto_0
    const-string v0, "\u041d\u0435 \u0443\u0434\u0430\u043b\u043e\u0441\u044c \u043e\u0442\u043a\u0440\u044b\u0442\u044c"

    invoke-direct {p0, v3, v0, p1, v3}, Lru/gates/app/MainActivity;->showCard(ZLjava/lang/String;Ljava/lang/String;Z)V

    .line 86
    :goto_1
    const-wide/16 v0, 0x1388

    invoke-direct {p0, v0, v1}, Lru/gates/app/MainActivity;->finishSoon(J)V

    .line 87
    return-void
.end method


# virtual methods
.method synthetic lambda$0$ru-gates-app-MainActivity(Landroid/view/View;)V
    .locals 0

    .line 147
    invoke-direct {p0}, Lru/gates/app/MainActivity;->finishNow()V

    return-void
.end method

.method protected onCreate(Landroid/os/Bundle;)V
    .locals 3

    .line 33
    invoke-super {p0, p1}, Landroid/app/Activity;->onCreate(Landroid/os/Bundle;)V

    .line 34
    const/4 p1, 0x1

    invoke-virtual {p0, p1}, Lru/gates/app/MainActivity;->requestWindowFeature(I)Z

    .line 36
    invoke-static {p0}, Lru/gates/app/SprutApi;->hasCredentials(Landroid/content/Context;)Z

    move-result v0

    if-nez v0, :cond_0

    .line 38
    new-instance p1, Landroid/content/Intent;

    const-class v0, Lru/gates/app/LoginActivity;

    invoke-direct {p1, p0, v0}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    invoke-virtual {p0, p1}, Lru/gates/app/MainActivity;->startActivity(Landroid/content/Intent;)V

    .line 39
    invoke-virtual {p0}, Lru/gates/app/MainActivity;->finish()V

    .line 40
    return-void

    .line 43
    :cond_0
    invoke-direct {p0}, Lru/gates/app/MainActivity;->buildUi()V

    .line 44
    const-string v0, "\u041f\u043e\u0434\u043e\u0436\u0434\u0438\u0442\u0435"

    const-string v1, "\u041e\u0442\u043f\u0440\u0430\u0432\u043b\u044f\u044e \u043a\u043e\u043c\u0430\u043d\u0434\u0443\u2026"

    const/4 v2, 0x0

    nop

    .line 46
    new-instance p1, Ljava/lang/Thread;

    new-instance v0, Lru/gates/app/MainActivity$1;

    invoke-direct {v0, p0}, Lru/gates/app/MainActivity$1;-><init>(Lru/gates/app/MainActivity;)V

    invoke-direct {p1, v0}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    .line 58
    invoke-virtual {p1}, Ljava/lang/Thread;->start()V

    .line 61
    iget-object p1, p0, Lru/gates/app/MainActivity;->handler:Landroid/os/Handler;

    new-instance v0, Lru/gates/app/MainActivity$2;

    invoke-direct {v0, p0}, Lru/gates/app/MainActivity$2;-><init>(Lru/gates/app/MainActivity;)V

    .line 71
    nop

    .line 61
    const-wide/32 v1, 0xd6d8

    invoke-virtual {p1, v0, v1, v2}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 72
    return-void
.end method

.method private resource(Ljava/lang/String;Ljava/lang/String;)I
    .locals 2
    invoke-virtual {p0}, Lru/gates/app/MainActivity;->getResources()Landroid/content/res/Resources;
    move-result-object v0
    invoke-virtual {p0}, Lru/gates/app/MainActivity;->getPackageName()Ljava/lang/String;
    move-result-object v1
    invoke-virtual {v0, p1, p2, v1}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I
    move-result v0
    return v0
.end method

.method public changeDevice()V
    .locals 3
    iget-boolean v0, p0, Lru/gates/app/MainActivity;->finished:Z
    if-nez v0, :done_reset
    const/4 v0, 0x1
    iput-boolean v0, p0, Lru/gates/app/MainActivity;->finished:Z
    iput-boolean v0, p0, Lru/gates/app/MainActivity;->resultShown:Z
    iget-object v0, p0, Lru/gates/app/MainActivity;->handler:Landroid/os/Handler;
    const/4 v1, 0x0
    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacksAndMessages(Ljava/lang/Object;)V
    invoke-static {p0}, Lru/gates/app/SprutApi;->resetBinding(Landroid/content/Context;)V
    new-instance v0, Landroid/content/Intent;
    const-class v1, Lru/gates/app/LoginActivity;
    invoke-direct {v0, p0, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V
    invoke-virtual {p0, v0}, Lru/gates/app/MainActivity;->startActivity(Landroid/content/Intent;)V
    invoke-virtual {p0}, Lru/gates/app/MainActivity;->finish()V
    :done_reset
    return-void
.end method
