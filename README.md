# 🛠️ .NET + Neovim Dev Environment Setup (Windows)

Цей гайд допоможе тобі налаштувати зручне середовище розробки на Windows з використанням Neovim, .NET, дебагера та інших інструментів.

---

## 1. Встановлення Scoop

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
irm get.scoop.sh | iex
```

---

## 2. Встановлення Neovim

```powershell
scoop install neovim
```

---

## 3. Налаштування змінної середовища `DOTNET_ROOT`

> Потрібно для коректної роботи OmniSharp або `csharp-ls`.

### Якщо .NET встановлено через інсталер:

```
DOTNET_ROOT = C:\Program Files\dotnet
```

### Якщо .NET встановлено вручну (наприклад, через zip):

```
DOTNET_ROOT = C:\Users\<your_user>\.dotnet
```

Додай цю змінну в "Environment Variables".

---

## 4. Встановлення Debugger (`netcoredbg`)

```powershell
scoop bucket add extras
scoop install netcoredbg
```

Перевір шлях до встановлення:

```powershell
scoop prefix netcoredbg
```

---

## 5. Встановлення `lazygit`

```powershell
scoop install lazygit
```

---

## 6. OmniSharp (встановлений через Mason)

Треба також встановити MSBuild через Visual Stodio Installer
Тільки .NET SDK

---

## 7. Покриття коду: `coverlet.console`

```bash
dotnet tool install --global coverlet.console
```

---

## 8. Модний павершел: `pwsh.exe`

```bash
winget install --id Microsoft.Powershell --source winget
```

---

## 9. Zig для компіляції TreeSitter: `Zig`

```powershell
scoop intall zig
```

---


## 10. sqlcmd для nvim-dadbod: `sqlcmd`

```powershell 
winget install sqlcmd
```

---

## ✅ Готово!

Тепер у тебе є:

- Neovim як IDE
- `omnisharp` для C# (LSP)
- `netcoredbg` для дебагу
- `neotest` для тестів
- `coverlet` для покриття тестів
- `lazygit` для роботи з git
- `dadbod`  для DB
- `telescope`  для навігації (сесії, NuGet, StartUp)

Удачі з кодом 💻
