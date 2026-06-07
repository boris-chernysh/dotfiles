---
description: Query the LLM Wiki for technical answers
subtask: false
---

Answer the user's technical question using the LLM Wiki knowledge base.

1. Load the `llm_wiki_skill` skill.
2. Read `references/query-sop.md` from the skill.
3. Execute the query workflow:
   - Search relevant pages in the wiki
   - Read and synthesize information
   - Provide a well-cited answer
   - If the answer contains valuable synthesis, ask the user if they want to save it to the wiki
