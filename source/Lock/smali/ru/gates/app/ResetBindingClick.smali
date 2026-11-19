.class public final Lru/gates/app/ResetBindingClick;
.super Ljava/lang/Object;
.implements Landroid/view/View$OnClickListener;
.field private final activity:Lru/gates/app/MainActivity;
.method public constructor <init>(Lru/gates/app/MainActivity;)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lru/gates/app/ResetBindingClick;->activity:Lru/gates/app/MainActivity;
    return-void
.end method
.method public onClick(Landroid/view/View;)V
    .locals 1
    iget-object v0, p0, Lru/gates/app/ResetBindingClick;->activity:Lru/gates/app/MainActivity;
    invoke-virtual {v0}, Lru/gates/app/MainActivity;->changeDevice()V
    return-void
.end method
