# LLM Wiki Schema

> **Version**: 1.0.0  
> **Purpose**: Defines the structural conventions, page templates, and naming standards for the LLM Wiki knowledge base.  
> **Usage**: The Agent reads this file first when loading the Skill, to understand all templates and conventions before executing workflows.

---

## 1. Directory Structure

```
~/.llm-wiki/
├── .git/                           # Git version control
├── .schema/
│   └── wiki-schema.md              # This file
├── global/                         # Global shared knowledge layer
│   ├── index.md                    # Global catalog
│   ├── log.md                      # Global operation log
│   ├── concepts/                   # Cross-project concepts
│   ├── patterns/                   # Design patterns
│   ├── technologies/               # Technology stack knowledge
│   └── projects-index.md           # Project index
└── projects/                       # Project layer
    └── {project-name}/
        ├── index.md                # Project catalog
        ├── log.md                  # Project operation log
        ├── overview.md             # Project overview
        ├── architecture.md         # Architecture description
        ├── decisions/              # ADRs
        ├── entities/               # Code entities
        ├── api/                    # API documentation
        ├── changes/                # Change history
        ├── sources/                # External materials
        └── analyses/               # Analysis / synthesis (answer filing)
```

---

## 2. Naming Conventions

| Item | Convention | Example |
|------|------------|---------|
| Project directory name | kebab-case, from project root dir name or user-specified | my-api-service, web-dashboard |
| Entity file name | kebab-case | auth-service.md, user-repository.md |
| Decision file name | YYYY-MM-DD-{kebab-title}.md | 2026-04-22-adopt-kafka.md |
| Change file name | YYYY-MM-DD-{short-desc}.md | 2026-04-22-auth-jwt-refactor.md |
| Wiki link | [[page-name]] or relative path [text](path.md) | [[AuthService]], [API Design](../api/auth.md) |

---

## 3. Special Files

### 3.1 index.md (Catalog File)

Each index.md is a catalog to help the Agent quickly locate relevant pages.

**Project index.md format**:

```markdown
# {ProjectName} Index

## Overview
- [Project Overview](overview.md) — {One-line description}
- [Architecture](architecture.md) — {One-line description}

## Entities
- [[EntityName]] — {One-line description}
- [[AnotherEntity]] — {One-line description}

## API
- [Auth API](api/auth.md) — Authentication endpoints

## Decisions
- [2026-04-22 Adopt Kafka](decisions/2026-04-22-adopt-kafka.md) — {One-line description}

## Changes
- [2026-04-22 Auth JWT Refactor](changes/2026-04-22-auth-jwt-refactor.md) — {One-line description}

## Sources
- [System Design Doc](sources/system-design.md) — {One-line description}

## Analyses
- [Auth vs OAuth Comparison](analyses/auth-vs-oauth.md) — {One-line description}
```

**Global index.md format**:

```markdown
# Global Index

## Projects
- [my-api-service](../projects/my-api-service/index.md) — NestJS e-commerce backend
- [web-dashboard](../projects/web-dashboard/index.md) — React admin dashboard

## Concepts
- [Microservices](concepts/microservices.md) — Distributed architecture pattern
- [Event Sourcing](concepts/event-sourcing.md) — State persistence pattern

## Patterns
- [Repository Pattern](patterns/repository.md) — Data access abstraction
- [CQRS](patterns/cqrs.md) — Command Query Responsibility Segregation

## Technologies
- [NestJS](technologies/nestjs.md) — Node.js framework
- [PostgreSQL](technologies/postgresql.md) — Relational database
```

### 3.2 log.md (Log File)

Append-only, with a unified prefix for easy parsing.

```markdown
# Log

## [2026-04-22 14:30] init | my-api-service
Initialized project wiki. Scanned 12 modules, generated 15 entity pages.

## [2026-04-22 16:45] ingest-changes | commit 8f3a2b1
Recorded 3 file changes: auth.go, middleware.go, user_test.go
Updated entities: AuthService
Created entities: AuthMiddleware

## [2026-04-22 17:00] query | "How does auth work?"
Answered using entities/AuthService.md, api/auth.md
Sources: [[AuthService]], [[api/auth]]
```

**Log format specification**:
- Each record starts with `## [YYYY-MM-DD HH:MM] {operation} | {summary}`
- operation options: init, ingest-changes, ingest-file, query, lint, update
- Briefly describe what was done

---

## 4. Page Templates

### 4.1 Entity Page Template (entities/{name}.md)

```markdown
# {EntityName}

> **Type**: {service|component|class|module|function}  
> **Project**: [[{projectName}]]  
> **Last Updated**: {YYYY-MM-DD}  
> **Source**: `{src/auth/service.go}` (commit `8f3a2b1`)

## Overview
{One-line responsibility description}

## Responsibilities
- {Responsibility 1}
- {Responsibility 2}

## Dependencies
- Uses: [[DependencyA]], [[DependencyB]]
- Used by: [[ConsumerX]], [[ConsumerY]]

## Interface
{Key functions / API signatures}

## Change History
### {YYYY-MM-DD} — {change title}
{Change description, link to [[changes/YYYY-MM-DD-desc|change record page]]}

## Notes
{Design decisions, caveats, todos}
```

**Field descriptions**:
- **Type**: Entity type, choose from {service, component, class, module, function, middleware, repository, controller, model, util}
- **Source**: Must label the source code file path and latest commit hash. List multiple Source lines if there are multiple source files
- **Dependencies**: Uses (what this entity depends on), Used by (what depends on this entity)
- **Change History**: Append new records here each time, never delete old records

---

### 4.2 Architecture Page Template (architecture.md)

```markdown
# Architecture

> **Project**: [[{projectName}]]  
> **Last Updated**: {YYYY-MM-DD}

## Overview
{System-wide description, 2-3 sentences}

## Module Diagram
{Text diagram or Mermaid diagram}

Example:
```
┌─────────────┐      ┌─────────────┐      ┌─────────────┐
│   Client    │─────▶│  API Layer  │─────▶│  Services   │
└─────────────┘      └─────────────┘      └──────┬──────┘
                                                  │
                                           ┌──────▼──────┐
                                           │  Database   │
                                           └─────────────┘
```

## Data Flow
{Key data flow description}

## Key Decisions
- [[decisions/2026-04-22-adopt-kafka]] — Event streaming for order processing
- [[decisions/2026-04-20-monorepo]] — Monorepo for shared types

## Entity Map
- [[AuthService]] — Authentication and authorization
- [[UserService]] — User management and profiles
- [[OrderRepository]] — Order data access
```

---

### 4.3 Overview Page Template (overview.md)

```markdown
---
lang: {en|zh|es|...}
---

# {ProjectName} Overview

> **Last Updated**: {YYYY-MM-DD}

## Project Goal
{Project goal and scope, 1-2 sentences}

## Tech Stack
| Category | Technology | Version |
|----------|-----------|---------|
| Backend | NestJS | ^10.0 |
| Database | PostgreSQL | 15 |
| Cache | Redis | 7 |
| Message Queue | Kafka | 3.5 |

## Directory Structure
```
src/
├── api/           # API controllers
├── services/      # Business logic
├── repositories/  # Data access
├── models/        # Domain models
├── middleware/    # Express middleware
└── utils/         # Shared utilities
```

## Team
- {If applicable, record key contributors}

## Key Links
- [Repository]({repo-url})
- [Staging Environment]({staging-url})
- [Production Environment]({prod-url})
```

---

### 4.4 Change Record Template (changes/{date}-{desc}.md)

```markdown
# {Change Title}

> **Date**: {YYYY-MM-DD}  
> **Commit**: `{hash}`  
> **Type**: {feat|fix|refactor|docs|chore}  
> **Scope**: {scope}

## Summary
{One-line summary}

## Changes
- `{file1}` — {What was done}
- `{file2}` — {What was done}

## Affected Entities
- [[EntityA]] — {Impact description}
- [[EntityB]] — {Impact description}

## Motivation
{Why this change was made}

## Breaking Changes
{If there are breaking changes, describe them here}
```

---

### 4.5 Decision Record Template (decisions/{date}-{title}.md)

```markdown
# {Decision Title}

> **Date**: {YYYY-MM-DD}  
> **Status**: {proposed|accepted|deprecated|superseded}

## Context
{Decision background}

## Decision
{What was decided}

## Consequences
- {Positive impact}
- {Negative impact}
- {Risks}

## Alternatives Considered
- {Option A} — Why it was not chosen
- {Option B} — Why it was not chosen
```

---

### 4.6 Source Page Template (sources/{title}.md)

```markdown
# {Source Title}

> **Type**: {document|rfc|article|spec}  
> **Original**: `{file path or URL}`  
> **Date**: {YYYY-MM-DD}  
> **Project**: [[{projectName}]]

## Summary
{Core content summary, 2-3 paragraphs}

## Key Points
- {Point 1}
- {Point 2}

## Related Entities
- [[EntityA]] — {Relationship description}
- [[EntityB]] — {Relationship description}

## Notes
{Agent's analysis or additions}
```

---

### 4.7 Analysis Page Template (analyses/{title}.md)

For saving valuable comprehensive analyses produced by queries.

```markdown
# {Analysis Title}

> **Date**: {YYYY-MM-DD}  
> **Project**: [[{projectName}]]  
> **Query**: "{Original question}"  
> **Sources**: [[EntityA]], [[EntityB]], [[architecture]]

## Summary
{Analysis summary}

## Key Findings
- {Finding 1}
- {Finding 2}

## Comparison / Analysis
{Detailed analysis content}

## Conclusion
{Conclusion}
```

---

## 5. Cross-Page Universal Conventions

### 5.1 YAML Frontmatter (Optional)

If the Agent supports it, you can add YAML frontmatter at the top of pages for tools like Dataview to query:

```markdown
---
type: entity
created: 2026-04-22
updated: 2026-04-22
project: my-api-service
tags: [service, auth]
---
```

**But this is not required**; plain text structure is sufficient.

### 5.2 Link Conventions

- **Wikilink**: `[[EntityName]]` — For linking pages within the same project
- **Relative path**: `[Text](../api/auth.md)` — For cross-directory links
- **Absolute path**: Avoid when possible, use relative paths or wikilinks

### 5.3 Update Conventions

- **Append, don't delete**: Change History only appends new records, never deletes old ones
- **Update Last Updated**: Update `> **Last Updated**: {YYYY-MM-DD}` each time a page is modified
- **Sync index.md**: Must update the corresponding index.md after adding/removing pages
- **Record log.md**: Append to log.md after every write operation

### 5.4 Git Commit Convention

After every write, execute:

```bash
cd ~/.llm-wiki/ && git add -A && git commit -m "[{YYYY-MM-DD HH:MM}] {operation} | {summary}"
```

- operation: init, ingest-changes, ingest-file, query, lint, update
- summary: Brief description, e.g., "my-app: auth JWT refactor"
