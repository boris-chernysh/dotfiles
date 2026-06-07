---
description: Ingest an external document into LLM Wiki
subtask: true
---

Ingest an external document into the LLM Wiki.

Arguments: $ARGUMENTS (file path or document content)

1. Load the `llm_wiki_skill` skill.
2. Read `references/ingest-file-sop.md` from the skill.
3. Execute the ingest-file workflow:
   - Read the document at the provided path
   - Extract key information and summarize
   - Create a source page in the wiki
   - Update related entity pages if applicable
4. Ask the user for confirmation before writing any files.
