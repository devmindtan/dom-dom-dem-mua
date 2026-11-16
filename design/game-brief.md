# Game Brief: Đom Đóm Đêm Mưa

## In your words
"cài thử và làm 1 game đơn giản xem" — the person said only this; every field below is *(provisional)*.

**Pitch:** A tiny firefly must keep its light alive through a rainy night — eat glowing motes, dodge raindrops, last as long as you can. *(provisional)*

**Genre:** arcade survival / dodge-and-collect *(provisional)*

**Controls:** Arrow keys or WASD to fly, Space/Enter to start or restart. *(provisional)*

**Question:** Is "your health is your light" readable and tense enough for a two-minute run? *(provisional)*

**Hooks:** The firefly's glow *is* its life bar — as it fades, the halo around you shrinks. *(provisional)*

**Intent:**

## Look and references
- Look: 2D night meadow in deep navy, crescent moon, twinkling stars, black grass silhouette; warm yellow-green firefly with a soft halo whose size tracks its light; cold pale-blue rain streaks. Every figure drawn in code. *(provisional)*
- References: none.
- View: 2D · Camera: fixed, whole field on screen.

## First minute
The title shows the firefly glowing over the meadow. Space starts the run; a few motes appear and rain is light, so the player learns that flying into a mote brightens the halo. Within ~20 s the light visibly fades if they idle, teaching the drain.

## Challenge
Rain starts sparse and gets denser and faster every second; around 60–90 s the sky is busy enough that grabbing a mote means threading between drops. A hit costs a fifth of your light.

## Core loop
- Fly to a mote → light goes up → the halo grows.
- Light drains constantly → you must keep moving into danger to collect.
- Rain thickens over time → each mote costs more risk.

## Goal & fail state
- Goal: collect as many motes as possible (score; best score this session).
- Fail: light reaches 0 (drain + raindrop hits) → game over, Space to retry.

## Features
- [x] Firefly flight with arrow keys / WASD, kept inside the screen
- [x] Light meter: constant drain, +light per mote, −light per raindrop hit, brief invulnerability after a hit
- [x] Motes spawn, pulse and expire
- [x] Rain that ramps in density and speed
- [x] Title, HUD (light bar, score, best), game-over screen with restart
- [x] All tuning values in `assets/data/game_config.json`

## Your systems

## Keep

## Avoid

## Out of scope
- No sound, no save file, no menus beyond title/game over, one screen only.

## Build order
1. Flight + light meter + motes + rain + game over (the whole slice).
2. Tune numbers in the JSON after first play.

---
**Kill condition:** if after one tuning pass the run still feels either trivially safe or instantly lost.

**Who it's for / what they feel:** anyone wanting a short, calm-but-tense one-minute run.
