.class public Lru/gates/app/WsClient;
.super Ljava/lang/Object;
.source "WsClient.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lru/gates/app/WsClient$Handler;
    }
.end annotation


# instance fields
.field private volatile closed:Z

.field private final handler:Lru/gates/app/WsClient$Handler;

.field private final in:Ljava/io/InputStream;

.field private final out:Ljava/io/OutputStream;

.field private final socket:Ljavax/net/ssl/SSLSocket;


# direct methods
.method public constructor <init>(Ljava/lang/String;ILjava/lang/String;Lru/gates/app/WsClient$Handler;)V
    .locals 5
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 35
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 32
    const/4 v0, 0x0

    iput-boolean v0, p0, Lru/gates/app/WsClient;->closed:Z

    .line 36
    iput-object p4, p0, Lru/gates/app/WsClient;->handler:Lru/gates/app/WsClient$Handler;

    .line 37
    invoke-static {}, Ljavax/net/ssl/SSLSocketFactory;->getDefault()Ljavax/net/SocketFactory;

    move-result-object p4

    check-cast p4, Ljavax/net/ssl/SSLSocketFactory;

    .line 38
    invoke-virtual {p4}, Ljavax/net/ssl/SSLSocketFactory;->createSocket()Ljava/net/Socket;

    move-result-object p4

    check-cast p4, Ljavax/net/ssl/SSLSocket;

    iput-object p4, p0, Lru/gates/app/WsClient;->socket:Ljavax/net/ssl/SSLSocket;

    .line 39
    new-instance v1, Ljava/net/InetSocketAddress;

    invoke-direct {v1, p1, p2}, Ljava/net/InetSocketAddress;-><init>(Ljava/lang/String;I)V

    const/16 p2, 0x1f40

    invoke-virtual {p4, v1, p2}, Ljavax/net/ssl/SSLSocket;->connect(Ljava/net/SocketAddress;I)V

    .line 42
    :try_start_0
    invoke-virtual {p4}, Ljavax/net/ssl/SSLSocket;->getSSLParameters()Ljavax/net/ssl/SSLParameters;

    move-result-object p2

    .line 43
    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    .line 44
    new-instance v2, Ljavax/net/ssl/SNIHostName;

    invoke-direct {v2, p1}, Ljavax/net/ssl/SNIHostName;-><init>(Ljava/lang/String;)V

    invoke-interface {v1, v2}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 45
    invoke-virtual {p2, v1}, Ljavax/net/ssl/SSLParameters;->setServerNames(Ljava/util/List;)V

    .line 46
    invoke-virtual {p4, p2}, Ljavax/net/ssl/SSLSocket;->setSSLParameters(Ljavax/net/ssl/SSLParameters;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 47
    :catch_0
    move-exception p2

    :goto_0
    nop

    .line 49
    iget-object p2, p0, Lru/gates/app/WsClient;->socket:Ljavax/net/ssl/SSLSocket;

    const p4, 0x88b8

    invoke-virtual {p2, p4}, Ljavax/net/ssl/SSLSocket;->setSoTimeout(I)V

    .line 50
    iget-object p2, p0, Lru/gates/app/WsClient;->socket:Ljavax/net/ssl/SSLSocket;

    invoke-virtual {p2}, Ljavax/net/ssl/SSLSocket;->getInputStream()Ljava/io/InputStream;

    move-result-object p2

    iput-object p2, p0, Lru/gates/app/WsClient;->in:Ljava/io/InputStream;

    .line 51
    iget-object p2, p0, Lru/gates/app/WsClient;->socket:Ljavax/net/ssl/SSLSocket;

    invoke-virtual {p2}, Ljavax/net/ssl/SSLSocket;->getOutputStream()Ljava/io/OutputStream;

    move-result-object p2

    iput-object p2, p0, Lru/gates/app/WsClient;->out:Ljava/io/OutputStream;

    .line 53
    const/16 p4, 0x10

    new-array p4, p4, [B

    .line 54
    new-instance v1, Ljava/security/SecureRandom;

    invoke-direct {v1}, Ljava/security/SecureRandom;-><init>()V

    invoke-virtual {v1, p4}, Ljava/security/SecureRandom;->nextBytes([B)V

    .line 55
    invoke-static {}, Ljava/util/Base64;->getEncoder()Ljava/util/Base64$Encoder;

    move-result-object v1

    invoke-virtual {v1, p4}, Ljava/util/Base64$Encoder;->encodeToString([B)Ljava/lang/String;

    move-result-object p4

    .line 57
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "GET "

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p3

    const-string v1, " HTTP/1.1\r\n"

    invoke-virtual {p3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p3

    .line 58
    const-string v1, "Host: "

    invoke-virtual {p3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p3

    invoke-virtual {p3, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string p3, "\r\n"

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    .line 59
    const-string v1, "Upgrade: websocket\r\n"

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    .line 60
    const-string v1, "Connection: Upgrade\r\n"

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    .line 61
    const-string v1, "Sec-WebSocket-Key: "

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, p4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    .line 62
    const-string p4, "Sec-WebSocket-Version: 13\r\n"

    invoke-virtual {p1, p4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    .line 63
    const-string p4, "Sec-WebSocket-Protocol: json-rpc\r\n"

    invoke-virtual {p1, p4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    .line 64
    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    .line 57
    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 65
    const-string p4, "US-ASCII"

    invoke-virtual {p1, p4}, Ljava/lang/String;->getBytes(Ljava/lang/String;)[B

    move-result-object p1

    invoke-virtual {p2, p1}, Ljava/io/OutputStream;->write([B)V

    .line 66
    invoke-virtual {p2}, Ljava/io/OutputStream;->flush()V

    .line 69
    new-instance p1, Ljava/io/ByteArrayOutputStream;

    invoke-direct {p1}, Ljava/io/ByteArrayOutputStream;-><init>()V

    .line 70
    nop

    .line 71
    const/16 p2, 0xd

    const/16 v1, 0xa

    filled-new-array {p2, v1, p2, v1}, [I

    move-result-object v1

    move v2, v0

    .line 73
    :goto_1
    iget-object v3, p0, Lru/gates/app/WsClient;->in:Ljava/io/InputStream;

    invoke-virtual {v3}, Ljava/io/InputStream;->read()I

    move-result v3

    .line 74
    if-ltz v3, :cond_5

    .line 75
    invoke-virtual {p1, v3}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 76
    aget v4, v1, v2

    if-ne v3, v4, :cond_1

    .line 77
    add-int/lit8 v2, v2, 0x1

    .line 78
    const/4 v3, 0x4

    if-ne v2, v3, :cond_3

    .line 84
    new-instance p2, Ljava/lang/String;

    invoke-virtual {p1}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object p1

    invoke-direct {p2, p1, p4}, Ljava/lang/String;-><init>([BLjava/lang/String;)V

    .line 85
    const-string p1, "101"

    invoke-virtual {p2, p1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result p1

    if-eqz p1, :cond_0

    .line 88
    return-void

    .line 86
    :cond_0
    new-instance p1, Ljava/io/IOException;

    new-instance p4, Ljava/lang/StringBuilder;

    const-string v1, "Handshake: "

    invoke-direct {p4, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const/4 v1, 0x2

    invoke-virtual {p2, p3, v1}, Ljava/lang/String;->split(Ljava/lang/String;I)[Ljava/lang/String;

    move-result-object p2

    aget-object p2, p2, v0

    invoke-virtual {p4, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-direct {p1, p2}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p1

    .line 80
    :cond_1
    if-ne v3, p2, :cond_2

    const/4 v2, 0x1

    goto :goto_2

    :cond_2
    move v2, v0

    .line 82
    :cond_3
    :goto_2
    invoke-virtual {p1}, Ljava/io/ByteArrayOutputStream;->size()I

    move-result v3

    const/16 v4, 0x4000

    if-gt v3, v4, :cond_4

    goto :goto_1

    :cond_4
    new-instance p1, Ljava/io/IOException;

    const-string p2, "Handshake: \u0441\u043b\u0438\u0448\u043a\u043e\u043c \u0431\u043e\u043b\u044c\u0448\u043e\u0439 \u043e\u0442\u0432\u0435\u0442"

    invoke-direct {p1, p2}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p1

    .line 74
    :cond_5
    new-instance p1, Ljava/io/EOFException;

    const-string p2, "Handshake: \u0441\u043e\u0435\u0434\u0438\u043d\u0435\u043d\u0438\u0435 \u0437\u0430\u043a\u0440\u044b\u0442\u043e"

    invoke-direct {p1, p2}, Ljava/io/EOFException;-><init>(Ljava/lang/String;)V

    throw p1
.end method

.method private readMessage()Ljava/lang/String;
    .locals 14
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 133
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    .line 135
    :cond_0
    iget-object v1, p0, Lru/gates/app/WsClient;->in:Ljava/io/InputStream;

    invoke-virtual {v1}, Ljava/io/InputStream;->read()I

    move-result v1

    .line 136
    const/4 v2, 0x0

    if-gez v1, :cond_1

    return-object v2

    .line 137
    :cond_1
    and-int/lit16 v3, v1, 0x80

    const/4 v4, 0x1

    const/4 v5, 0x0

    if-eqz v3, :cond_2

    move v3, v4

    goto :goto_0

    :cond_2
    move v3, v5

    .line 138
    :goto_0
    and-int/lit8 v1, v1, 0xf

    .line 139
    iget-object v6, p0, Lru/gates/app/WsClient;->in:Ljava/io/InputStream;

    invoke-virtual {v6}, Ljava/io/InputStream;->read()I

    move-result v6

    .line 140
    if-gez v6, :cond_3

    return-object v2

    .line 141
    :cond_3
    and-int/lit16 v7, v6, 0x80

    if-eqz v7, :cond_4

    goto :goto_1

    :cond_4
    move v4, v5

    .line 142
    :goto_1
    and-int/lit8 v6, v6, 0x7f

    int-to-long v6, v6

    .line 143
    const-wide/16 v8, 0x7e

    cmp-long v8, v6, v8

    const-wide/16 v9, 0x0

    const/16 v11, 0x8

    if-nez v8, :cond_5

    .line 144
    iget-object v6, p0, Lru/gates/app/WsClient;->in:Ljava/io/InputStream;

    invoke-virtual {v6}, Ljava/io/InputStream;->read()I

    move-result v6

    int-to-long v6, v6

    shl-long/2addr v6, v11

    iget-object v8, p0, Lru/gates/app/WsClient;->in:Ljava/io/InputStream;

    invoke-virtual {v8}, Ljava/io/InputStream;->read()I

    move-result v8

    int-to-long v11, v8

    or-long/2addr v6, v11

    goto :goto_3

    .line 145
    :cond_5
    const-wide/16 v12, 0x7f

    cmp-long v8, v6, v12

    if-nez v8, :cond_7

    .line 146
    nop

    .line 147
    move v8, v5

    move-wide v6, v9

    :goto_2
    if-lt v8, v11, :cond_6

    goto :goto_4

    :cond_6
    shl-long/2addr v6, v11

    iget-object v12, p0, Lru/gates/app/WsClient;->in:Ljava/io/InputStream;

    invoke-virtual {v12}, Ljava/io/InputStream;->read()I

    move-result v12

    int-to-long v12, v12

    or-long/2addr v6, v12

    add-int/lit8 v8, v8, 0x1

    goto :goto_2

    .line 145
    :cond_7
    :goto_3
    nop

    .line 149
    :goto_4
    nop

    .line 150
    if-eqz v4, :cond_a

    .line 151
    const/4 v4, 0x4

    new-array v8, v4, [B

    .line 152
    nop

    :goto_5
    if-lt v5, v4, :cond_8

    goto :goto_6

    .line 153
    :cond_8
    iget-object v11, p0, Lru/gates/app/WsClient;->in:Ljava/io/InputStream;

    invoke-virtual {v11}, Ljava/io/InputStream;->read()I

    move-result v11

    .line 154
    if-ltz v11, :cond_9

    .line 155
    int-to-byte v11, v11

    aput-byte v11, v8, v5

    .line 152
    add-int/lit8 v5, v5, 0x1

    goto :goto_5

    .line 154
    :cond_9
    new-instance v0, Ljava/io/EOFException;

    invoke-direct {v0}, Ljava/io/EOFException;-><init>()V

    throw v0

    .line 150
    :cond_a
    move-object v8, v2

    .line 158
    :goto_6
    new-instance v4, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v4}, Ljava/io/ByteArrayOutputStream;-><init>()V

    .line 159
    nop

    :goto_7
    cmp-long v5, v9, v6

    if-ltz v5, :cond_b

    .line 165
    sparse-switch v1, :sswitch_data_0

    goto :goto_8

    .line 170
    :sswitch_0
    const/16 v1, 0xa

    invoke-virtual {v4}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object v2

    invoke-direct {p0, v1, v2}, Lru/gates/app/WsClient;->sendControl(I[B)V

    .line 171
    goto :goto_8

    .line 173
    :sswitch_1
    return-object v2

    .line 167
    :sswitch_2
    new-instance v1, Ljava/lang/String;

    invoke-virtual {v4}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object v2

    const-string v4, "UTF-8"

    invoke-direct {v1, v2, v4}, Ljava/lang/String;-><init>([BLjava/lang/String;)V

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 168
    nop

    .line 177
    :goto_8
    if-eqz v3, :cond_0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0

    .line 160
    :cond_b
    iget-object v5, p0, Lru/gates/app/WsClient;->in:Ljava/io/InputStream;

    invoke-virtual {v5}, Ljava/io/InputStream;->read()I

    move-result v5

    .line 161
    if-ltz v5, :cond_d

    .line 162
    if-eqz v8, :cond_c

    const-wide/16 v11, 0x3

    and-long/2addr v11, v9

    long-to-int v11, v11

    aget-byte v11, v8, v11

    xor-int/2addr v5, v11

    .line 163
    :cond_c
    invoke-virtual {v4, v5}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 159
    const-wide/16 v11, 0x1

    add-long/2addr v9, v11

    goto :goto_7

    .line 161
    :cond_d
    new-instance v0, Ljava/io/EOFException;

    invoke-direct {v0}, Ljava/io/EOFException;-><init>()V

    throw v0

    :sswitch_data_0
    .sparse-switch
        0x1 -> :sswitch_2
        0x8 -> :sswitch_1
        0x9 -> :sswitch_0
    .end sparse-switch
.end method

.method private sendControl(I[B)V
    .locals 5
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 182
    iget-object v0, p0, Lru/gates/app/WsClient;->out:Ljava/io/OutputStream;

    monitor-enter v0

    .line 183
    :try_start_0
    iget-object v1, p0, Lru/gates/app/WsClient;->out:Ljava/io/OutputStream;

    or-int/lit16 p1, p1, 0x80

    invoke-virtual {v1, p1}, Ljava/io/OutputStream;->write(I)V

    .line 184
    iget-object p1, p0, Lru/gates/app/WsClient;->out:Ljava/io/OutputStream;

    array-length v1, p2

    or-int/lit16 v1, v1, 0x80

    invoke-virtual {p1, v1}, Ljava/io/OutputStream;->write(I)V

    .line 185
    const/4 p1, 0x4

    new-array p1, p1, [B

    .line 186
    new-instance v1, Ljava/security/SecureRandom;

    invoke-direct {v1}, Ljava/security/SecureRandom;-><init>()V

    invoke-virtual {v1, p1}, Ljava/security/SecureRandom;->nextBytes([B)V

    .line 187
    iget-object v1, p0, Lru/gates/app/WsClient;->out:Ljava/io/OutputStream;

    invoke-virtual {v1, p1}, Ljava/io/OutputStream;->write([B)V

    .line 188
    const/4 v1, 0x0

    :goto_0
    array-length v2, p2

    if-lt v1, v2, :cond_0

    .line 189
    iget-object p1, p0, Lru/gates/app/WsClient;->out:Ljava/io/OutputStream;

    invoke-virtual {p1}, Ljava/io/OutputStream;->flush()V

    .line 182
    monitor-exit v0

    .line 191
    return-void

    .line 188
    :cond_0
    iget-object v2, p0, Lru/gates/app/WsClient;->out:Ljava/io/OutputStream;

    aget-byte v3, p2, v1

    and-int/lit8 v4, v1, 0x3

    aget-byte v4, p1, v4

    xor-int/2addr v3, v4

    invoke-virtual {v2, v3}, Ljava/io/OutputStream;->write(I)V

    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 182
    :catchall_0
    move-exception p1

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p1
.end method


# virtual methods
.method public close()V
    .locals 1

    .line 194
    iget-boolean v0, p0, Lru/gates/app/WsClient;->closed:Z

    if-eqz v0, :cond_0

    return-void

    .line 195
    :cond_0
    const/4 v0, 0x1

    iput-boolean v0, p0, Lru/gates/app/WsClient;->closed:Z

    .line 197
    :try_start_0
    iget-object v0, p0, Lru/gates/app/WsClient;->socket:Ljavax/net/ssl/SSLSocket;

    invoke-virtual {v0}, Ljavax/net/ssl/SSLSocket;->close()V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 198
    :catch_0
    move-exception v0

    :goto_0
    nop

    .line 200
    return-void
.end method

.method public loop()V
    .locals 2

    .line 120
    nop

    :cond_0
    :goto_0
    :try_start_0
    iget-boolean v0, p0, Lru/gates/app/WsClient;->closed:Z

    if-eqz v0, :cond_1

    .line 125
    goto :goto_1

    .line 121
    :cond_1
    invoke-direct {p0}, Lru/gates/app/WsClient;->readMessage()Ljava/lang/String;

    move-result-object v0
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 122
    if-nez v0, :cond_2

    .line 127
    :goto_1
    invoke-virtual {p0}, Lru/gates/app/WsClient;->close()V

    .line 128
    iget-object v0, p0, Lru/gates/app/WsClient;->handler:Lru/gates/app/WsClient$Handler;

    if-eqz v0, :cond_4

    goto :goto_2

    .line 123
    :cond_2
    :try_start_1
    iget-object v1, p0, Lru/gates/app/WsClient;->handler:Lru/gates/app/WsClient$Handler;

    if-eqz v1, :cond_0

    invoke-interface {v1, v0}, Lru/gates/app/WsClient$Handler;->onMessage(Ljava/lang/String;)V
    :try_end_1
    .catch Ljava/io/IOException; {:try_start_1 .. :try_end_1} :catch_0
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    goto :goto_0

    .line 126
    :catchall_0
    move-exception v0

    .line 127
    invoke-virtual {p0}, Lru/gates/app/WsClient;->close()V

    .line 128
    iget-object v1, p0, Lru/gates/app/WsClient;->handler:Lru/gates/app/WsClient$Handler;

    if-eqz v1, :cond_3

    invoke-interface {v1}, Lru/gates/app/WsClient$Handler;->onClosed()V

    .line 129
    :cond_3
    throw v0

    .line 125
    :catch_0
    move-exception v0

    .line 127
    invoke-virtual {p0}, Lru/gates/app/WsClient;->close()V

    .line 128
    iget-object v0, p0, Lru/gates/app/WsClient;->handler:Lru/gates/app/WsClient$Handler;

    if-eqz v0, :cond_4

    :goto_2
    invoke-interface {v0}, Lru/gates/app/WsClient$Handler;->onClosed()V

    .line 130
    :cond_4
    return-void
.end method

.method public sendText(Ljava/lang/String;)V
    .locals 6
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 91
    const-string v0, "UTF-8"

    invoke-virtual {p1, v0}, Ljava/lang/String;->getBytes(Ljava/lang/String;)[B

    move-result-object p1

    .line 92
    new-instance v0, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v0}, Ljava/io/ByteArrayOutputStream;-><init>()V

    .line 93
    const/16 v1, 0x81

    invoke-virtual {v0, v1}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 94
    array-length v1, p1

    .line 95
    const/16 v2, 0x7e

    if-ge v1, v2, :cond_0

    .line 96
    or-int/lit16 v2, v1, 0x80

    invoke-virtual {v0, v2}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 97
    goto :goto_1

    :cond_0
    const v2, 0xffff

    const/16 v3, 0xff

    if-gt v1, v2, :cond_1

    .line 98
    const/16 v2, 0xfe

    invoke-virtual {v0, v2}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 99
    shr-int/lit8 v2, v1, 0x8

    and-int/2addr v2, v3

    invoke-virtual {v0, v2}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 100
    and-int/lit16 v2, v1, 0xff

    invoke-virtual {v0, v2}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 101
    goto :goto_1

    .line 102
    :cond_1
    invoke-virtual {v0, v3}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 103
    const/4 v2, 0x7

    :goto_0
    if-gez v2, :cond_3

    .line 105
    :goto_1
    const/4 v2, 0x4

    new-array v4, v2, [B

    .line 106
    new-instance v2, Ljava/security/SecureRandom;

    invoke-direct {v2}, Ljava/security/SecureRandom;-><init>()V

    invoke-virtual {v2, v4}, Ljava/security/SecureRandom;->nextBytes([B)V

    .line 107
    invoke-virtual {v0, v4}, Ljava/io/ByteArrayOutputStream;->write([B)V

    .line 108
    const/4 v2, 0x0

    :goto_2
    if-lt v2, v1, :cond_2

    .line 111
    iget-object v3, p0, Lru/gates/app/WsClient;->out:Ljava/io/OutputStream;

    monitor-enter v3

    .line 112
    :try_start_0
    iget-object p1, p0, Lru/gates/app/WsClient;->out:Ljava/io/OutputStream;

    invoke-virtual {v0}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/io/OutputStream;->write([B)V

    .line 113
    iget-object p1, p0, Lru/gates/app/WsClient;->out:Ljava/io/OutputStream;

    invoke-virtual {p1}, Ljava/io/OutputStream;->flush()V

    .line 111
    monitor-exit v3

    .line 115
    return-void

    .line 111
    :catchall_0
    move-exception p1

    monitor-exit v3
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p1

    .line 109
    :cond_2
    aget-byte v3, p1, v2

    and-int/lit8 v5, v2, 0x3

    aget-byte v5, v4, v5

    xor-int/2addr v3, v5

    invoke-virtual {v0, v3}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 108
    add-int/lit8 v2, v2, 0x1

    goto :goto_2

    .line 103
    :cond_3
    mul-int/lit8 v4, v2, 0x8

    shr-int v4, v1, v4

    and-int/2addr v4, v3

    invoke-virtual {v0, v4}, Ljava/io/ByteArrayOutputStream;->write(I)V

    add-int/lit8 v2, v2, -0x1

    goto :goto_0
.end method
