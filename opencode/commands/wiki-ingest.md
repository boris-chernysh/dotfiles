---
description: Record recent code changes into LLM Wiki
subtask: true
---

Record the recent code changes into the LLM Wiki.

1. Load the `llm_wiki_skill` skill.
2. Read `references/ingest-changes-sop.md` from the skill.
3. Execute the ingest-changes workflow:
   - Get the latest commit info (message, diff, changed files)
   - Analyze the impact on entities
   - Present a summary to the user for confirmation
   - Update entity pages and create change records
4. Ask the user for confirmation before making any changes.
