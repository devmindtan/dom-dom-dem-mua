#!/usr/bin/env python3
"""Generator cho sprite "splash": nước tóe khi giọt mưa chạm đất hoặc trúng đom đóm.

10x6, 3 frame: vương miện nước, bắn tung, tan. Neo ở giữa cạnh dưới.
Chạy:  gamekit art run dom-dom-dem-mua splash
"""

import sys
from pathlib import Path


def _workspace() -> Path:
    for parent in Path(__file__).resolve().parents:
        if (parent / "tools/gamekit/pipeline/spritekit.py").exists():
            return parent
    raise SystemExit("Không tìm thấy tools/gamekit/pipeline — chạy trong workspace game-studio")


sys.path.insert(0, str(_workspace() / "tools/gamekit/pipeline"))

from spritekit import from_rows, gif, preview, strip  # noqa: E402

NAME = "splash"
HERE = Path(__file__).resolve().parent
GAME = HERE.parents[3]
OUT = GAME / "assets/sprites/custom" / NAME

PALETTE = {
    "a": "#cfe0ff",
    "b": "#8faee8",
    "f": "#8faee870",  # mờ dần
}

FRAMES = [
    [
        "..........",
        "..........",
        "..........",
        "...a..a...",
        "....bb....",
        "..bbbbbb..",
    ],
    [
        "..........",
        ".a......a.",
        "..a....a..",
        "...b..b...",
        "..........",
        ".bb....bb.",
    ],
    [
        "a........a",
        "..........",
        ".f......f.",
        "..........",
        "..........",
        "f........f",
    ],
]


def main() -> None:
    frames = [from_rows(rows, PALETTE) for rows in FRAMES]
    OUT.mkdir(parents=True, exist_ok=True)
    frames[0].save(OUT / f"{NAME}.png")
    strip(frames).save(OUT / f"{NAME}_strip.png")
    preview(frames, HERE / "preview.png", scale=24)
    gif(frames, HERE / "anim.gif", fps=10, scale=12)
    print(f"strip: {OUT / f'{NAME}_strip.png'}")


if __name__ == "__main__":
    main()
