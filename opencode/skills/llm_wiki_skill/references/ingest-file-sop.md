# File Ingestion SOP

## Goal

Ingest external documents (design documents, RFCs, articles, meeting notes, etc.) into the knowledge base.

## Prerequisites

- wiki-schema.md has been read to understand templates and conventions
- User has provided document content or file path

## Steps

### Step 0: Check Wiki Language

Before generating any content, read the language configuration:

```bash
cat ~/.llm-wiki/projects/{project-name}/.config 2>/dev/null || echo "lang: en"
```

**All generated content MUST use this language.** This includes:
- Source page summaries and key points
- Related Entities descriptions
- Notes and analysis

If the source document is in a different language, **translate it** to the wiki language during ingestion.

### Step 1: Determine Document Information

Get the following information:
- **File path / content**: Content provided by the user
- **Document type**: Design document / RFC / Technical article / Meeting notes / API documentation / Other
- **Target project**: Which project to file under (default current project, or global)
- **Tags** (optional): Related technologies, concepts

### Step 2: Read Document Content

Use the read tool to read the file content.

If the user provided a URL or text content, use it directly.

### Step 3: Extract Core Information

Analyze document content and extract:

**Basic Information**:
- Title
- Author (if available)
- Date
- Version (if available)

**Core Content**:
- Summary (2-3 sentences)
- Key decisions or conclusions
- Involved technologies / concepts
- Involved entities (association with project code entities)

**Structure Extraction**:
- If the document has a clear chapter structure, keep main chapter headings
- Extract core points from each chapter
- Do not copy the full text; distill and summarize

### Step 4: Generate Source Page

Use the write tool to create a new file in `sources/`:

**File name**: `sources/{kebab-case-title}.md`

**Content**: Use the Source page template from wiki-schema.md:

```markdown
# {Document Title}

> **Type**: {document|rfc|article|spec|meeting}  
> **Original**: `{file path or URL}`  
> **Date**: {YYYY-MM-DD}  
> **Project**: [[{project-name}]]

## Summary
{Core content summary, 2-3 paragraphs}

## Key Points
- {Point 1}
- {Point 2}
- {Point 3}

## Decisions
{If there are clear decisions, list them here}

## Related Entities
- [[EntityA]] — {Relationship description}
- [[EntityB]] — {Relationship description}

## Notes
{Agent's analysis or additions}
```

### Step 5: Update Related Entities

If the document involves entities in the project, use read + edit to add references in the relevant entity pages:

Append in the Notes or Change History of the entity page:

```markdown
## Notes
...

### Related Documents
- [{Document Title}](sources/{file-name}.md) — {One-line description of association}
```

### Step 6: Update index.md

Use the edit tool to update the project's index.md:
- Add new document link in the Sources section

### Step 7: Collaborative Confirmation

Show the user a summary:

```
I am preparing to file the document "{Title}" into the knowledge base:

📄 Will create: sources/{file-name}.md
📌 Key points:
  - {Point 1}
  - {Point 2}
  - {Point 3}
🔗 Related entities: [[EntityA]], [[EntityB]]

Is this accurate? What needs to be adjusted?
```

### Step 8: Git Commit

Use the bash tool:

```bash
cd ~/.llm-wiki/ && git add -A && git commit -m "[{YYYY-MM-DD HH:MM}] ingest-file | {project-name}: {document-title}"
```

### Step 9: Append Log

Use the edit tool to append to log.md:

```markdown
## [YYYY-MM-DD HH:MM] ingest-file | {document-title}
Source: {original-path}
Created: sources/{file-name}.md
Related entities: {entity list}
```

## Document Type Handling Guide

| Type | Extraction Focus | Storage Location |
|------|-----------------|------------------|
| **Design document** | Architecture decisions, module division, data flow | sources/ |
| **RFC** | Proposal content, decision reasons, alternatives | sources/ |
| **Technical article** | Core concepts, best practices, code examples | global/technologies/ or sources/ |
| **Meeting notes** | Decisions, action items, owners | sources/ |
| **API documentation** | Interface definitions, parameters, return values | api/ (not sources/) |

**Note**: API documentation (OpenAPI/Swagger) should use the api/ directory template, not sources/.

## FAQ

**Q: What if the document is very long?**
A: Extract core points only, no need to summarize paragraph by paragraph. Focus on: decisions, architecture, involved entities.

**Q: What if the document involves multiple projects?**
A: File under the most relevant project, and note cross-project associations in Related Entities.

**Q: What if the user just pasted a piece of text, not a formal document?**
A: It can still be recorded, mark Type as "note" or "snippet".
