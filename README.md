# iyagi-incubator

*이야기 (iyagi): story, tale*

An agent skill for generating short Korean stories constrained to a learner's known grammar, language level, and study preferences.

## Setup

Copy or symlink the skill directory into your own agent skills directory:

```sh
cp -R skills/iyagi-incubator ~/.config/pi/agent/skills/
```

Then ask the agent for Korean story practice, for example:

```text
Write a short Korean story about going to the library.
```
or simply call the skill directly:

```text
/skill:iyagi-incubator topic: first love
```

If no topic or level is provided, the skill asks for the missing information before composing.

## What it does

- Writes Korean short stories for reading and grammar practice.
- Uses only a natural subset of grammar patterns listed in `GRAMMAR.md`.
- Adapts vocabulary and sentence complexity to the learner's Sejong level.
- Can include an English translation, grammar table, vocabulary list, and practice questions.

## Skill files

- `skills/iyagi-incubator/SKILL.md`: workflow and generation rules.
- `skills/iyagi-incubator/GRAMMAR.md`: known grammar formulas, one per row.
- `skills/iyagi-incubator/PROFILE.md`: default level and output preferences.

## Customization

Edit `GRAMMAR.md` to add or remove grammar patterns. Edit `PROFILE.md` to change the default level, story length, translation preference, vocabulary list, or practice questions.
