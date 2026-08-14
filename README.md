# Microsoft Defender Real-Time Protection Policy

[中文说明](#中文说明) | [English](#english)

## 中文说明

这是一个用于 Windows 10/11 的单文件脚本，通过本机策略和 Microsoft Defender PowerShell 设置持续关闭实时保护，避免 Windows 安全中心的临时关闭选项随后自动恢复。

### 要求

- Windows 10 或 Windows 11
- 当前用户具有管理员权限
- 系统使用 Microsoft Defender Antivirus
- 防篡改保护未阻止本机策略变更

### 关闭实时保护

1. 下载 `defender-real-time-policy.cmd`。
2. 双击运行，并在 UAC 提示中选择“是”。
3. 脚本会自动申请管理员权限、写入策略并输出当前状态。

成功时应看到：

```text
RealTimeProtectionEnabled: False
DisableRealtimeMonitoring: True
```

重复运行不会重复创建额外文件。

### 使用 GitHub 直链远程执行

以下命令会从 GitHub Raw 直链下载脚本到临时目录，以管理员权限运行，然后删除临时文件。该直链要求仓库为公开状态；私有仓库匿名访问时会返回 `404`。

远程关闭实时保护：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$url='https://raw.githubusercontent.com/junjundesk/defender-real-time-policy/main/defender-real-time-policy.cmd'; $file=Join-Path $env:TEMP 'defender-real-time-policy.cmd'; Invoke-WebRequest -Uri $url -OutFile $file; Start-Process -FilePath $file -Verb RunAs -Wait; Remove-Item -LiteralPath $file -Force"
```

远程恢复实时保护：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$url='https://raw.githubusercontent.com/junjundesk/defender-real-time-policy/main/defender-real-time-policy.cmd'; $file=Join-Path $env:TEMP 'defender-real-time-policy.cmd'; Invoke-WebRequest -Uri $url -OutFile $file; Start-Process -FilePath $file -ArgumentList 'restore' -Verb RunAs -Wait; Remove-Item -LiteralPath $file -Force"
```

脚本直链：

```text
https://raw.githubusercontent.com/junjundesk/defender-real-time-policy/main/defender-real-time-policy.cmd
```

### 恢复实时保护

在脚本所在目录打开管理员终端，然后运行：

```cmd
defender-real-time-policy.cmd restore
```

恢复成功时应看到：

```text
RealTimeProtectionEnabled: True
DisableRealtimeMonitoring: False
```

### 工作方式

禁用模式会写入以下本机策略，并立即应用 Defender 设置：

```text
HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection
DisableRealtimeMonitoring = 1 (DWORD)
```

恢复模式会删除该策略值，并重新开启实时保护。本脚本只管理实时保护，不会关闭 Windows 防火墙或删除 Microsoft Defender。

> 关闭实时保护会降低系统对正在运行和新下载文件的即时检测能力。仅在你有权管理的设备上使用。

## English

This single-file script persistently disables Microsoft Defender real-time protection on Windows 10/11 by applying a local machine policy and the corresponding Defender PowerShell preference. It avoids the automatic restoration associated with the temporary toggle in Windows Security.

### Requirements

- Windows 10 or Windows 11
- A user account with administrator privileges
- Microsoft Defender Antivirus is available
- Tamper Protection does not block local policy changes

### Disable real-time protection

1. Download `defender-real-time-policy.cmd`.
2. Double-click it and approve the UAC prompt.
3. The script elevates itself, writes the policy, applies the setting, and prints the resulting state.

Expected output:

```text
RealTimeProtectionEnabled: False
DisableRealtimeMonitoring: True
```

The operation is idempotent and does not create additional files.

### Remote execution using the GitHub direct link

The following commands download the script from its GitHub Raw URL into the temporary directory, run it with administrator privileges, and remove the temporary file afterward. The repository must be public for anonymous direct-link access; a private repository returns `404`.

Remotely disable real-time protection:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$url='https://raw.githubusercontent.com/junjundesk/defender-real-time-policy/main/defender-real-time-policy.cmd'; $file=Join-Path $env:TEMP 'defender-real-time-policy.cmd'; Invoke-WebRequest -Uri $url -OutFile $file; Start-Process -FilePath $file -Verb RunAs -Wait; Remove-Item -LiteralPath $file -Force"
```

Remotely restore real-time protection:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$url='https://raw.githubusercontent.com/junjundesk/defender-real-time-policy/main/defender-real-time-policy.cmd'; $file=Join-Path $env:TEMP 'defender-real-time-policy.cmd'; Invoke-WebRequest -Uri $url -OutFile $file; Start-Process -FilePath $file -ArgumentList 'restore' -Verb RunAs -Wait; Remove-Item -LiteralPath $file -Force"
```

Raw script URL:

```text
https://raw.githubusercontent.com/junjundesk/defender-real-time-policy/main/defender-real-time-policy.cmd
```

### Restore real-time protection

Open an elevated terminal in the script directory and run:

```cmd
defender-real-time-policy.cmd restore
```

Expected output after restoration:

```text
RealTimeProtectionEnabled: True
DisableRealtimeMonitoring: False
```

### How it works

Disable mode writes the following local machine policy and immediately applies the Defender preference:

```text
HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection
DisableRealtimeMonitoring = 1 (DWORD)
```

Restore mode removes that policy value and enables real-time protection again. The script manages only real-time protection; it does not disable Windows Firewall or remove Microsoft Defender.

> Disabling real-time protection reduces immediate scanning of running and newly downloaded files. Use it only on systems you are authorized to administer.

