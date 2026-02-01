---
name: tk:design
description: Create distinctive frontend interfaces. /tk:[$cmd] light|medium|heavy <what to build>
allowed-tools:
  - Read
  - Write
  - Bash
  - SubAgent
  - AskUserQuestion
  - WebSearch
  - WebFetch
---

$import(commands/tk/_shared.md)

# TK v1.1.0 | /tk:design [mode]

## STEP 0: LOAD RULES (SILENT)

Before ANY action: silently read .tk/RULES.md and follow ALL rules constantly.
Do not display rules. Just follow them.

Create production-grade frontend interfaces with exceptional design quality. Avoid generic "AI slop" aesthetics.

## Critical Principles

**NEVER use:**
- Generic fonts (Inter, Roboto, Arial, system fonts, Space Grotesk)
- Cliched colors (purple gradients on white)
- Predictable layouts and cookie-cutter patterns
- Same aesthetic twice

**ALWAYS:**
- Commit to a BOLD aesthetic direction
- Make unexpected, memorable choices
- Match implementation complexity to vision
- Execute with precision and intentionality

## Process

### 1. Pre-flight (from _shared.md)

### 2. Design Thinking (before ANY code)

**LIGHT:** Quick mental model, pick aesthetic, build
**MEDIUM/HEAVY:** Answer these explicitly:

- **Purpose:** What problem? Who uses it?
- **Tone:** Pick an EXTREME - brutally minimal, maximalist chaos, retro-futuristic, organic/natural, luxury/refined, playful/toy-like, editorial/magazine, brutalist/raw, art deco/geometric, soft/pastel, industrial/utilitarian
- **Constraints:** Framework, performance, accessibility requirements
- **Differentiation:** What's the ONE thing someone will remember?

### 3. Mode Execution

**LIGHT (quick component):**
- Pick distinctive aesthetic direction (don't overthink, just commit)
- Build production-ready code
- Focus on: unique typography, bold color choice, one memorable detail
- No generic defaults - every choice intentional

**MEDIUM (full design process):**
Interview user (3-5 questions):
- What's the vibe/mood? (show tone options)
- Any brand colors/fonts to respect?
- Reference sites they admire?
- Target audience?
- Dark or light theme preference?

Then implement with attention to:
- **Typography:** Distinctive display + refined body font pairing (Google Fonts, not defaults)
- **Color:** CSS variables, dominant + sharp accent palette
- **Motion:** CSS animations for load (staggered animation-delay), hover states that surprise
- **Composition:** Asymmetry, overlap, grid-breaking, generous negative space OR controlled density
- **Atmosphere:** Gradient meshes, noise textures, geometric patterns, layered transparencies, grain overlays

**HEAVY (research + parallel specialists):**
```
Phase 1 - Research:
SubAgent 1: Research aesthetic direction - find 3 reference sites/designs matching the vibe
SubAgent 2: Research typography - find perfect font pairing for this context
SubAgent 3: Research color theory - build palette that matches tone
SubAgent DOCS: Document design decisions in .planning/DESIGN.md

Phase 2 - Build (parallel specialists):
SubAgent 1 (Structure): HTML/component architecture, semantic markup, accessibility
SubAgent 2 (Styling): CSS/styling system, variables, responsive breakpoints
SubAgent 3 (Motion): Animations, transitions, micro-interactions, scroll effects
SubAgent 4 (Polish): Visual details, textures, shadows, custom cursors, grain overlays
SubAgent DOCS: Document component API, usage examples, design rationale
```

### 4. Implementation Checklist

Before completion, verify:
- [ ] Typography: No generic fonts, distinctive pairing
- [ ] Colors: CSS variables, cohesive palette, not timid/evenly-distributed
- [ ] Motion: Page load animation with staggered reveals, hover states
- [ ] Layout: Not predictable - has asymmetry, overlap, or unexpected composition
- [ ] Atmosphere: Background isn't flat solid color (gradients, textures, patterns)
- [ ] Memorable: Has ONE unforgettable detail
- [ ] Functional: Production-ready, accessible, responsive

### 5. Completion

```bash
# Update STATE.md, HISTORY.md
# If patterns discovered, add to PATTERNS.md
git add -A && git commit -m "feat: [component/page name] - [aesthetic direction]"
```

Report: What was built, aesthetic direction chosen, key design decisions, how to use/integrate

## Aesthetic Reference (vary between these, never repeat)

| Direction | Typography | Colors | Motion | Details |
|-----------|------------|--------|--------|---------|
| Brutalist | Mono, raw | Black/white, neon accent | Glitchy, abrupt | Exposed grid, raw borders |
| Luxury | Thin serif, refined | Deep jewel tones, gold | Smooth, elegant | Subtle textures, shadows |
| Playful | Rounded, bouncy | Bright primaries, pastels | Springy, wobble | Blob shapes, illustrations |
| Editorial | Classic serif | High contrast B&W | Minimal, purposeful | Large type, white space |
| Retro-future | Geometric sans | Neon on dark | Glow, scan lines | CRT effects, chrome |
| Organic | Handwritten, natural | Earth tones, greens | Flowing, natural | Grain, paper textures |
| Art Deco | Geometric display | Gold, black, cream | Geometric reveals | Borders, patterns |

**Remember:** Claude is capable of extraordinary creative work. Commit fully to a distinctive vision.
