---
name: llm_wiki_skill
description: >
  **MANDATORY**: You MUST load and use this Skill for ALL operations related to
  the LLM Wiki knowledge base. Do NOT attempt to query, update, or manage the
  wiki without loading this Skill first. This Skill governs ALL interactions
  with the ~/.llm-wiki/ directory.

  **When to invoke this Skill (ALWAYS)：**
  - The user asks ANY technical question about a project ("How does X work?",
    "Why is Y designed this way?", "Explain Z"). You MUST query the wiki first
    using query-sop.md instead of answering from your training data.
  - The user mentions code changes ("I fixed X", "Refactored Y"), or git commit
    output appears. You MUST ingest these changes using ingest-changes-sop.md.
  - The user wants to understand a project ("Understand this project",
    "Analyze the codebase"). You MUST initialize or read the wiki using
    init-project-sop.md.
  - The user provides a document to record ("Store this in wiki",
    "Organize this doc"). You MUST ingest it using ingest-file-sop.md.
  - The user asks about wiki health ("Check wiki", "Find contradictions").
    You MUST run lint-sop.md.
  - You (the Agent) feel the urge to write project knowledge to a file.
    You MUST do it through this Skill's SOPs.

  **When NOT to use your own knowledge:**
  - When the user asks about a specific project's internals. Always query the
    wiki first. If the wiki doesn't have the answer, say so and offer to
    initialize/update it. Do NOT hallucinate from training data.

  **Core purpose**: Guide LLMs in maintaining a programming-oriented knowledge
  base (LLM Wiki) through structured SOPs. All wiki operations must follow
  the workflows defined in this Skill.
compatibility: >
  Does not depend on a specific MCP Server. The Agent needs the following
  base tools:
  - bash: execute shell commands (git, find, grep, etc.)
  - read: read file contents
  - write: create new files
  - edit: modify existing files
  - glob/ls: browse directory structures
  Optional: webfetch (for fetching external materials)
---

# LLM Wiki

## System Introduction

LLM Wiki is a personal knowledge base system for software development.

### Core Philosophy (from Karpathy)

Unlike RAG (retrieval per query), LLM Wiki is a **persistent, compounding** knowledge base:
- The Agent **incrementally builds and maintains** a Markdown Wiki during development
- Knowledge is **compiled once and continuously updated**, not re-derived every time
- Cross-references are already established, contradictions are already flagged
- Users' exploratory queries can also be **filed back** into the Wiki, allowing insights to compound

### Three-Layer Architecture

1. **Raw Sources** (project source code directory) — Read-only, source of truth
2. **The Wiki** (`~/.llm-wiki/`) — Agent-generated and maintained extraction layer
3. **Schema** (this Skill) — Defines structure, templates, and workflows

### Your Role as an Agent

Your job is to:
1. **ALWAYS load this Skill first** before doing anything related to the wiki
2. Read `references/wiki-schema.md` to understand specific conventions
3. Autonomously determine which workflow to trigger based on conversation context
4. Use your own tools (bash/read/write/edit) to execute operations
5. **Collaborate with the user for confirmation** before writing (show → feedback → adjust → confirm)

### ⚠️ Mandatory Rule: Query Wiki First

**When the user asks a technical question about a project, you MUST follow this order:**

```
1. Load this Skill
2. Execute query-sop.md to search the wiki
3. If wiki has the answer → answer using wiki content with citations
4. If wiki doesn't have the answer → say "The wiki doesn't contain information about X. 
   Would you like me to initialize/update the wiki to include this?"
5. NEVER answer from your training data about project internals
```

**Why?** Because:
- The wiki contains the ACTUAL current state of the project
- Your training data may be outdated or wrong for this specific project
- Answering from training data bypasses the knowledge base entirely, defeating its purpose

### Mandatory Rule: Update Through Skill

**When you need to write or update wiki content, you MUST:**

```
1. Load this Skill
2. Read the relevant SOP (init-project-sop, ingest-changes-sop, etc.)
3. Follow the SOP steps exactly
4. Use collaborative confirmation before writing
5. Git commit after writing
```

**Do NOT:**
- Write directly to ~/.llm-wiki/ without loading this Skill
- Skip the confirmation step
- Skip git commit
- Use your own templates instead of wiki-schema.md

---

## Loading Flow

When this Skill is loaded, execute in this order:

1. **Read Schema**: Use the read tool to read `references/wiki-schema.md`
   - Understand directory structure, naming conventions, page templates
   - If the file does not exist, inform the user that the wiki directory needs to be initialized first

2. **Understand Trigger Rules**: Read the "Trigger Rules" and "Workflows" sections of this SKILL.md

3. **Wait for User Input or Detect Soft Events**: Determine whether a Wiki operation is needed based on conversation context

---

## Trigger Rules

When the following signals are detected, trigger the corresponding workflow:

| User Context / Soft Event | Matching Signal | Action |
|---------------------------|-----------------|--------|
| **Project Initialization** | "Understand this project", "Familiarize with codebase", "Analyze this project", asking about architecture but wiki does not exist | Execute init-project-sop |
| **Change Ingestion** | Git commit output appears in conversation, user describes code changes ("I fixed X", "Refactored Y") | Ask for confirmation → Execute ingest-changes-sop |
| **File Ingestion** | User uploads/references a document and says "record", "store in wiki", "organize this document" | Ask for confirmation → Execute ingest-file-sop |
| **Technical Query** | "How does X work", "Why designed this way", "Relationship between X and Y" | Execute query-sop |
| **Health Check** | "Check wiki", "Knowledge base health", "Find contradictions", "Clean up wiki" | Execute lint-sop |

**How to determine if a project is initialized**:
- Use the bash tool to check if `~/.llm-wiki/projects/{project-name}/` exists
- How to determine project-name:
  1. User explicitly specifies
  2. Use the current working directory name (kebab-case)
  3. Read the project name from package.json/go.mod, etc.

---

## Collaborative Confirmation Mechanism

**This is the most important mechanism.** Before writing any files, you must collaborate with the user for confirmation.

### Flow

1. **Show Summary**
   Show the user a summary of what will be written:
   - If initializing: show overview.md core content, list of entities to be generated
   - If ingesting changes: show change impact analysis, list of pages to be updated
   - If ingesting a file: show extracted key points, pages to be created/updated
   - If filing a query: show analysis summary, suggested save path

2. **Request Feedback**
   Ask the user: "Is the above accurate? What needs to be adjusted or added?"

3. **Iterate and Adjust**
   - User provides modification suggestions → regenerate or adjust → show again
   - Loop until the user is satisfied

4. **Final Confirmation**
   - User explicitly says "confirm", "write", "no problem"
   - Or user does not provide modification suggestions (considered satisfied)

5. **Execute Write**
   - Use write/edit tools to write files
   - Use bash to execute git commit
   - Use edit to append log.md

### Example Dialogue

```
Agent: I am preparing to record this change:
  - Commit: feat(auth): migrate to JWT
  - Impact: auth.go (JWT verification logic), middleware.go (new JWT middleware)
  - Will update: entities/AuthService.md
  - Will create: entities/AuthMiddleware.md, changes/2026-04-22-auth-jwt.md
  
  Is this accurate? What needs to be added?

User: The middleware verification logic is important, record it separately

Agent: Understood, I will add a Verification Logic section in the AuthMiddleware page.

User: Confirm

Agent: [Execute write]
```

### Skip Rules

If the user explicitly says "skip", "no need", "cancel":
- Do not execute write
- Record in log.md: "## [time] skipped | {operation} — user cancelled"

---

## Sub-Agent Delegation (Optional)

When tasks are complex, you can delegate to a sub-Agent to avoid context bloat in the main Agent.

### Criteria

- Need to read > 10 files for analysis → Delegate
- Need to generate > 5 new pages → Delegate
- Main Agent has a more important conversation thread → Delegate

### Delegation Method

1. Tell the sub-Agent: "Please execute the {sop-name} SOP, file is at references/{sop-file}"
2. Provide context: project path, change info, user feedback, etc.
3. Define deliverables: which pages to generate, what content to update

### Review

After the sub-Agent completes, the main Agent reviews:
1. Whether content quality meets expectations
2. Whether it follows templates and conventions in wiki-schema.md
3. Report final results to the user

---

## Workflow Index

This Skill contains the following workflows (SOPs), stored in the references/ directory:

| SOP File | Purpose | Trigger Condition |
|----------|---------|-------------------|
| init-project-sop.md | Initialize project knowledge base | User asks to understand project, and wiki does not exist |
| ingest-changes-sop.md | Record code changes | Detect git commit or user describes changes |
| ingest-file-sop.md | Ingest external documents | User asks to record a document |
| query-sop.md | Technical query | User asks a technical question |
| lint-sop.md | Health check | User asks to check wiki |

**Execution Method**:
- Read the corresponding SOP file
- Follow the steps in the SOP, use your own tools (bash/read/write/edit) to execute
- The SOP details which tool to use and what operation to perform at each step

---

## Language Consistency Rule

**All content in a project's wiki MUST be written in a single, consistent language.**

### How language is determined:
1. During `init-project-sop`, the Agent proposes a language based on context
2. The user confirms or changes it
3. The language is stored in:
   - `~/.llm-wiki/projects/{name}/.config` (plain text: `lang: en`)
   - `overview.md` frontmatter (`lang: en`)

### Language enforcement:
- **All SOPs MUST check the language setting** before generating content
- Entity pages, change records, analyses, sources, decisions — ALL use the same language
- If a user provides a document in a different language, translate it to the wiki language during ingestion
- Changing the wiki language later requires explicit user request and a bulk update

### Why mandatory:
- Mixed-language wikis are unsearchable and hard to navigate
- Query SOP relies on language-consistent content for accurate matching
- Users expect uniform language throughout the knowledge base

---

## Important Reminders

1. **Never skip collaborative confirmation**: Even if it looks simple, give the user a chance to provide feedback
2. **Source attribution**: Every entity page must include a Source field (source code file + commit)
3. **Git version control**: Must git commit after every write
4. **Update index.md**: Sync index.md after adding/removing pages
5. **Append log.md**: Record every operation for traceability
6. **Answer filing**: Valuable query results should be saved to the analyses/ directory, allowing insights to compound
7. **Language consistency**: Always check and respect the project's wiki language setting
