---
description: Check LLM Wiki health and quality
subtask: true
---

Run a health check on the LLM Wiki.

1. Load the `llm_wiki_skill` skill.
2. Read `references/lint-sop.md` from the skill.
3. Execute the lint workflow:
   - Scan all wiki pages
   - Check for dead links, orphan pages, empty pages
   - Check for missing Source fields
   - Analyze contradictions between pages
   - Generate a health report
4. Present findings to the user and ask which issues to fix.
