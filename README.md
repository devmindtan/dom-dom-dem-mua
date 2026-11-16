# Đom Đóm Đêm Mưa

Một chú đom đóm phải giữ cho đèn của mình không tắt qua một đêm mưa: bay đi nhặt đốm sáng, né giọt mưa,
và trụ được càng lâu càng tốt. Ánh sáng chính là máu: đèn càng yếu thì quầng sáng quanh đom đóm càng nhỏ.

Thiết kế: [design/game-brief.md](design/game-brief.md) · Phiên bản: `0.1.0` (`config/version` trong `project.godot`)

## Chơi

| Phím | Tác dụng |
|---|---|
| Mũi tên / WASD | bay |
| Space / Enter | bắt đầu, chơi lại |
| Esc | thoát |

- Đèn tự hao theo thời gian. Mỗi đốm sáng xanh nạp thêm đèn; mỗi giọt mưa trúng người mất 1/5 đèn.
- Mưa dày và rơi nhanh dần. Đèn tắt là thua; điểm là số đốm sáng nhặt được.

```bash
gamekit run          # hoặc: make run
```

Bản build sẵn (sau `gamekit export`): `builds/dist/dom-dom-dem-mua-<version>-{linux,windows,web}.zip`.
Bản web chạy được trên itch.io.

## Phát triển

```bash
gamekit test         # 16 test unit + integration
gamekit shot . "" 600 -- --demo --seed=7   # để bot tự chơi 10 giây rồi lưu ảnh vào builds/shots/
gamekit export       # test → Linux + Windows + Web
```

| Ở đâu | Là gì |
|---|---|
| `src/core/` | luật chơi thuần, test được: `LightMeter` (đèn = máu), `Difficulty` (mưa tăng dần), `GameConfig` |
| `src/game/main.gd` | màn chơi duy nhất; mọi hình vẽ bằng code (`_draw`), không dùng ảnh |
| `assets/data/game_config.json` | **mọi con số cân bằng**: tốc độ, tốc độ hao đèn, mật độ mưa… sửa ở đây, không sửa code |
| `tests/unit`, `tests/integration` | test |
| `production/qa/evidence/` | ảnh chụp chứng minh từng màn đã chạy |
| `assets/sprites/characters/sample_hero` | nhân vật LPC mẫu để thử pipeline (game hiện chưa dùng) |

Tham số dòng lệnh khi chạy (sau `--`): `--demo` (bot tự bay), `--idle` (đứng yên cho tới khi thua),
`--seed=<n>` (cố định ngẫu nhiên).

Mở AI agent (Claude Code, OpenCode, Codex…) **trong thư mục này** để dùng skill của framework (`/next-step`, `/balance-check`, `/dev-story`…); agent nào cũng bắt đầu từ `AGENTS.md`.

## Thư mục nào của ai

| Phần | Thuộc về | Ghi chú |
|---|---|---|
| `src/`, `assets/`, `tests/`, `design/`, `production/`, `project.godot`, `export_presets.cfg`, `README.md` | **game này** | sửa thoải mái |
| `addons/gamekit/`, `Makefile` | gamekit (`../../tools/gamekit`) | bản sao, sửa ở tools/gamekit rồi `gamekit install` |
| `.claude/`, `CLAUDE.md`, `project.yaml`, `docs/` | framework Claude Code Game Studios | cấu hình agent; cập nhật theo `UPGRADING.md` của template |
| `AGENTS.md`, `GEMINI.md`, `.agents/skills` | gamekit (`gamekit agents-link`) | lối vào cho mọi agent; `.agents/skills` là symlink tới `.claude/skills` |
| `LICENSES/` | giấy phép của mã bên thứ ba | không xóa |

Git: remote `framework` trỏ về repo gốc của framework. Thêm repo riêng của game bằng `git remote add origin <url>`.

## Credits

- Framework: [Claude Code Game Studios](https://github.com/Donchitos/Claude-Code-Game-Studios), MIT, xem `LICENSES/`.
- Nhân vật mẫu LPC (chưa dùng trong game): [assets/credits/CREDITS.md](assets/credits/CREDITS.md).
